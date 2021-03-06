package tools.vitruv.framework.vsum

import java.io.File
import java.util.Collections
import java.util.List
import java.util.Vector
import java.util.concurrent.Callable
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import tools.vitruv.framework.change.description.PropagatedChange
import tools.vitruv.framework.change.description.VitruviusChange
import tools.vitruv.framework.change.processing.ChangePropagationSpecificationProvider
import tools.vitruv.framework.change.processing.ChangePropagationSpecificationRepository
import tools.vitruv.framework.domains.TuidAwareVitruvDomain
import tools.vitruv.framework.domains.repository.VitruvDomainRepository
import tools.vitruv.framework.domains.repository.VitruvDomainRepositoryImpl
import tools.vitruv.framework.userinteraction.InternalUserInteractor
import tools.vitruv.framework.userinteraction.UserInteractor
import tools.vitruv.framework.util.command.EMFCommandBridge
import tools.vitruv.framework.util.datatypes.VURI
import tools.vitruv.framework.vsum.helper.ChangeDomainExtractor
import tools.vitruv.framework.vsum.modelsynchronization.ChangePropagationListener
import tools.vitruv.framework.vsum.modelsynchronization.ChangePropagator
import tools.vitruv.framework.vsum.modelsynchronization.ChangePropagatorImpl
import tools.vitruv.framework.vsum.repositories.ModelRepositoryImpl
import tools.vitruv.framework.vsum.repositories.ResourceRepositoryImpl
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI

class VirtualModelImpl implements InternalVirtualModel {
	private static val Logger LOGGER = Logger.getLogger(VirtualModelImpl.name)
	private val ResourceRepositoryImpl resourceRepository
	private val ModelRepositoryImpl modelRepository
	private val VitruvDomainRepository metamodelRepository
	private val ChangePropagator changePropagator
	private val ChangePropagationSpecificationProvider changePropagationSpecificationProvider
	private val File folder
	private val extension ChangeDomainExtractor changeDomainExtractor

	/**
	 * A list of {@link PropagatedChangeListener}s that are informed of all changes made
	 */
	private val List<PropagatedChangeListener> propagatedChangeListeners

	public new(File folder, InternalUserInteractor userInteractor, VirtualModelConfiguration modelConfiguration) {
		this.folder = folder
		this.metamodelRepository = new VitruvDomainRepositoryImpl()
		for (metamodel : modelConfiguration.metamodels) {
			this.metamodelRepository.addDomain(metamodel)
			if (metamodel instanceof TuidAwareVitruvDomain) {
				metamodel.registerAtTuidManagement()
			}
		}
		this.resourceRepository = new ResourceRepositoryImpl(folder, metamodelRepository)
		this.modelRepository = new ModelRepositoryImpl(resourceRepository.uuidGeneratorAndResolver)
		val changePropagationSpecificationRepository = new ChangePropagationSpecificationRepository()
		for (changePropagationSpecification : modelConfiguration.changePropagationSpecifications) {
			changePropagationSpecification.userInteractor = userInteractor
			changePropagationSpecificationRepository.putChangePropagationSpecification(changePropagationSpecification)
		}
		this.changePropagationSpecificationProvider = changePropagationSpecificationRepository
		this.changePropagator = new ChangePropagatorImpl(
			resourceRepository,
			changePropagationSpecificationProvider,
			metamodelRepository,
			resourceRepository,
			modelRepository,
			userInteractor
		)
		VirtualModelManager.instance.putVirtualModel(this)

		this.propagatedChangeListeners = new Vector<PropagatedChangeListener>()
		this.changeDomainExtractor = new ChangeDomainExtractor(metamodelRepository)
	}

	override getCorrespondenceModel() {
		this.resourceRepository.getCorrespondenceModel()
	}

	override getModelInstance(VURI modelVuri) {
		return this.resourceRepository.getModel(modelVuri)
	}

	override save() {
		this.resourceRepository.saveAllModels()
	}

	override persistRootElement(VURI persistenceVuri, EObject rootElement) {
		this.resourceRepository.persistAsRoot(rootElement, persistenceVuri)
	}

	override executeCommand(Callable<Void> command) {
		this.resourceRepository.createRecordingCommandAndExecuteCommandOnTransactionalDomain(command)
	}

	override addChangePropagationListener(ChangePropagationListener changePropagationListener) {
		changePropagator.addChangePropagationListener(changePropagationListener)
	}

	override propagateChange(VitruviusChange change) {
		change.unresolveIfApplicable
		// Save is done by the change propagator because it has to be performed before finishing sync
		val result = changePropagator.propagateChange(change)
		informPropagatedChangeListeners(result)
		return result
	}

	/**
	 * @see tools.vitruv.framework.vsum.VirtualModel#propagateChangedState(Resource)
	 */
	override propagateChangedState(Resource newState) {
		return propagateChangedState(newState, newState?.URI)
	}

	/**
	 * @see tools.vitruv.framework.vsum.VirtualModel#propagateChangedState(Resource, URI)
	 */
	override propagateChangedState(Resource newState, URI oldLocation) {
		if (newState === null || oldLocation === null) {
			throw new IllegalArgumentException("New state and old location cannot be null!")
		}
		val vuri = VURI.getInstance(oldLocation) // using the URI of a resource allows using the model resource, the model root, or any model element as input.
		val vitruvDomain = metamodelRepository.getDomain(vuri.fileExtension)
		val currentState = resourceRepository.getModel(vuri).resource
		if (currentState.isValid(newState)) {
			val strategy = vitruvDomain.stateChangePropagationStrategy
			val compositeChange = strategy.getChangeSequences(newState, currentState, uuidGeneratorAndResolver)
			return propagateChange(compositeChange)
		}
		LOGGER.error("Could not load current state for new state. No changes were propagated!")
		return #[] // empty list
	}

	override reverseChanges(List<PropagatedChange> changes) {
		val command = EMFCommandBridge.createVitruviusRecordingCommand([|
			changes.reverseView.forEach[it.applyBackward(uuidGeneratorAndResolver)]
			return null
		])
		resourceRepository.executeRecordingCommandOnTransactionalDomain(command)

		// TODO HK Instead of this make the changes set the modified flag of the resource when applied
		val changedEObjects = changes.map[originalChange.affectedEObjects + consequentialChanges.affectedEObjects].flatten
		changedEObjects.map[eResource].filterNull.forEach[modified = true]
		save()
	}

	override setUserInteractor(UserInteractor userInteractor) {
		for (propagationSpecification : this.changePropagationSpecificationProvider) {
			propagationSpecification.userInteractor = userInteractor
		}
	}

	override File getFolder() {
		return folder
	}

	override getUuidGeneratorAndResolver() {
		return resourceRepository.uuidGeneratorAndResolver
	}

	/**
	 * Registers a given {@link PropagatedChangeListener}.
	 * 
	 * @param propagatedChangeListener The listener to register
	 */
	override void addPropagatedChangeListener(PropagatedChangeListener propagatedChangeListener) {
		this.propagatedChangeListeners.add(propagatedChangeListener)
	}

	/**
	 * Removes a given {@link PropagatedChangeListener}. 
	 * Does nothing if the listener was not registered before.
	 * 
	 * @param propagatedChangeListener The listener to remove
	 */
	override void removePropagatedChangeListener(PropagatedChangeListener propagatedChangeListener) {
		this.propagatedChangeListeners.remove(propagatedChangeListener)
	}

	/**
	 * Returns the name of the virtual model.
	 * 
	 * @return The name of the virtual model
	 */
	def getName() {
		val name = this.folder.name
		// Special treatment in JUnit tests: they use a folder named name_vsum_...
		val separator = "_vsum"
		if (name.indexOf(separator) != -1) {
			return name.substring(0, name.indexOf(separator))
		} else {
			return name
		}
	}

	/**
	 * This method informs the registered {@link PropagatedChangeListener}s of the propagation result.
	 * 
	 * @param propagationResult The propagation result
	 */
	def private void informPropagatedChangeListeners(List<PropagatedChange> propagationResult) {
		if (this.propagatedChangeListeners.isEmpty()) {
			return
		}
		val sourceDomain = getSourceDomain(propagationResult)
		val targetDomain = getTargetDomain(propagationResult)
		for (PropagatedChangeListener propagatedChangeListener : this.propagatedChangeListeners) {
			propagatedChangeListener.postChanges(name, sourceDomain, targetDomain, propagationResult)
		}
	}

	/**
	 * Confirms whether the current state is retrievable via its URI from the resource set of the new state.
	 */
	private def boolean isValid(Resource currentState, Resource newState) {
		newState.resourceSet.URIConverter.exists(currentState.URI, Collections.emptyMap)
	}

}
