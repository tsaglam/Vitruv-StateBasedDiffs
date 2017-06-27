package tools.vitruv.framework.change.recording.impl

import java.util.ArrayList
import java.util.Collection
import java.util.List

import org.apache.log4j.Level
import org.apache.log4j.Logger

import org.eclipse.emf.common.notify.Notification
import org.eclipse.emf.common.notify.Notifier
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.change.ChangeDescription
import org.eclipse.emf.ecore.change.util.ChangeRecorder
import org.eclipse.emf.ecore.util.EcoreUtil

import tools.vitruv.framework.change.description.TransactionalChange
import tools.vitruv.framework.change.description.VitruviusChangeFactory
import tools.vitruv.framework.change.echange.EChange
import tools.vitruv.framework.change.echange.compound.CompoundEChange
import tools.vitruv.framework.change.echange.eobject.CreateEObject
import tools.vitruv.framework.change.echange.resolve.EChangeUnresolver
import tools.vitruv.framework.change.echange.resolve.StagingArea
import tools.vitruv.framework.change.recording.AtomicEmfChangeRecorder
import tools.vitruv.framework.util.datatypes.VURI

class AtomicEmfChangeRecorderImpl implements AtomicEmfChangeRecorder {
	static val logger = Logger::getLogger(AtomicEmfChangeRecorderImpl)
	List<ChangeDescription> changeDescriptions
	VURI modelVURI
	Collection<Notifier> elementsToObserve
	boolean unresolveRecordedChanges

	/**
	 * Constructor for the AtmoicEMFChangeRecorder, which does not unresolve
	 * the recorded changes.
	 */
	new() {
		this(false)
	}

	/**
	 * Constructor for AtomicEMFChangeRecorder
	 * @param 	unresolveRecordedChanges The recorded changes will be replaced
	 * 			by unresolved changes, which referenced EObjects are proxy objects.
	 */
	new(boolean unresolveRecordedChanges) {
		elementsToObserve = new ArrayList<Notifier>
		changeRecorder.recordingTransientFeatures = false
		changeRecorder.resolveProxies = true
		this.unresolveRecordedChanges = unresolveRecordedChanges

		// TODO PS Remove
		logger.level = Level::INFO
	}

	override beginRecording(VURI modelVURI, Collection<? extends Notifier> elementsToObserve) {
		this.modelVURI = modelVURI
		this.elementsToObserve.clear
		this.elementsToObserve += elementsToObserve
		changeDescriptions = new ArrayList<ChangeDescription>
		changeRecorder.beginRecording(elementsToObserve)
	}

	override endRecording() {
		logger.debug('''End recording, unresolveRecordedChanges: «unresolveRecordedChanges»''')
		if (!recording)
			throw new IllegalStateException
		changeRecorder.endRecording
		changeDescriptions.reverseView.forEach[applyAndReverse]
		val transactionalChanges = changeDescriptions.filterNull.map[createModelChange].filterNull.toList
		if (unresolveRecordedChanges)
			correctChanges(transactionalChanges.immutableCopy)
		if (transactionalChanges.map[EChanges].flatten.exists[resolved])
			throw new IllegalStateException("A changed was resolved")
		return transactionalChanges
	}

	private def createModelChange(ChangeDescription changeDescription) {
		if (!(changeDescription.objectChanges.empty && changeDescription.resourceChanges.empty)) {
			var TransactionalChange result = null
			if (unresolveRecordedChanges) {
				result = VitruviusChangeFactory::instance.createEMFModelChange(changeDescription, modelVURI)
				changeDescription.applyAndReverse
			} else {
				result = VitruviusChangeFactory::instance.createLegacyEMFModelChange(changeDescription, modelVURI)
				result.applyForward
			}
			return result
		}
		changeDescription.applyAndReverse
		null
	}

	override restartRecording() {
		val modelChanges = endRecording
		beginRecording(modelVURI, elementsToObserve)
		modelChanges
	}

	override isRecording() {
		changeRecorder.recording
	}

	override dispose() {
		changeRecorder.dispose
	}

	/*
	 * The recorder doesn't produce the correct changes, because all created changes of one change
	 * description are resolved to the same state before all changes were applied. Every atomic change must be resolved
	 * directly to the state before itself is applied => roll everything back and re-apply all changes, while
	 * correcting the wrong changes.
	 */
	private def void correctChanges(List<TransactionalChange> changes) {
		val eChanges = changes.map[EChanges].flatten.toList
		// Roll back
		eChanges.reverseView.forEach [
			updateStagingArea // corrects the missing or wrong staging area of CreateEObject changes.
			if (resolved)
				applyBackward
		]
		// Apply again and unresolve the results if necessary
		eChanges.forEach [ c |
			val copy = EcoreUtil::copy(c)
			EChangeUnresolver::unresolve(c)
			if (copy.resolved)
				copy.applyForward
		]
	}

	/*
	 * Updates the staging area to the current state of the model.
	 */
	private def dispatch void updateStagingArea(EChange change) {
		// Is needed to create a dispatch method which is applicable for EChange base class.
	}

	private def dispatch void updateStagingArea(CreateEObject<EObject> change) {
		// The newly created object is in an resource after the change, so
		// the correct staging area can be chosen, before the change
		// is applied backward.
		change.stagingArea = StagingArea::getStagingArea(change.affectedEObject.eResource)
	}

	private def dispatch void updateStagingArea(CompoundEChange change) {
		change.atomicChanges.forEach[updateStagingArea]
	}

	/**
	 * A change recorder that restarts after each change notification to get atomic change descriptions.
	 */
	ChangeRecorder changeRecorder = new ChangeRecorder {
		Collection<?> rootObjects
		var isDisposed = false

		override dispose() {
			isDisposed = true
			super.dispose
		}

		override notifyChanged(Notification notification) {
			if (isRecording && !isDisposed) {
				super.notifyChanged(notification)
				endRecording
				beginRecording(rootObjects)
			}
		}

		override beginRecording(Collection<?> rootObjects) {
			if (!isDisposed) {
				this.rootObjects = rootObjects
				super.beginRecording(rootObjects)
			}
		}

		override endRecording() {
			if (!isDisposed)
				changeDescriptions += super.endRecording
			changeDescription
		}
	}
}