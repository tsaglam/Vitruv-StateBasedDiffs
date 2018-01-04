package tools.vitruv.framework.change.description.impl

import org.eclipse.emf.ecore.EObject
import tools.vitruv.framework.change.echange.EChange
import tools.vitruv.framework.tuid.TuidManager
import static extension tools.vitruv.framework.change.echange.resolve.EChangeResolverAndApplicator.*
import tools.vitruv.framework.uuid.UuidResolver
import tools.vitruv.framework.change.echange.resolve.EChangeUnresolver
import tools.vitruv.framework.util.datatypes.VURI
import org.eclipse.emf.ecore.InternalEObject
import tools.vitruv.framework.change.echange.root.RootEChange

class ConcreteApplicableChangeImpl extends ConcreteChangeImpl {
	private var boolean canBeBackwardsApplied;
	private var VURI vuri;
	
    public new(EChange eChange) {
    	super(eChange);
    	tryToSetUri;
    	this.canBeBackwardsApplied = true;
    }

	override resolveBeforeAndApplyForward(UuidResolver uuidResolver) {
		this.EChange = this.EChange.resolveBefore(uuidResolver)
		tryToSetUri;
		this.registerOldObjectTuidsForUpdate(getObjectsWithPotentiallyModifiedTuids)
		this.canBeBackwardsApplied = false;
		applyForward()
		tryToSetUri;
		this.updateTuids
	}
	
	override resolveAfterAndApplyBackward(UuidResolver uuidResolver) {
		this.EChange = this.EChange.resolveAfter(uuidResolver)
		tryToSetUri;
		this.registerOldObjectTuidsForUpdate(getObjectsWithPotentiallyModifiedTuids)
		this.canBeBackwardsApplied = true;
		applyBackward()
		tryToSetUri;
		this.updateTuids
	}
	
	private def void tryToSetUri() {
		val eChange = EChange;
		var resolvedResources = affectedNotReferencedEObjects.map[eResource].filterNull.toList;
		if (eChange instanceof RootEChange) {
			resolvedResources += eChange.resource;
		}
		if (resolvedResources.size > 0) {
			this.vuri = VURI.getInstance(resolvedResources.get(0));
			return;
		}
		val proxyUris = affectedNotReferencedEObjects.filter(InternalEObject).map[eProxyURI].filterNull.filter[segmentCount > 0]
		if (proxyUris.size > 0) {
			this.vuri = VURI.getInstance(proxyUris.get(0).trimFragment);
			return;
		}
	}
	
	override getURI() {
		return vuri;
	}
	
	private def getObjectsWithPotentiallyModifiedTuids() {
		// We currently support 3 hierarchy layers upwards update. This is necessary
		// e.g. for Operations whose TUIDs depend on the values of their parameter type references.
		// This number of layers may still be too few, this is just a random number.
		this.affectedEObjects.map[#{it, it.eContainer, it.eContainer?.eContainer, it.eContainer?.eContainer?.eContainer}].flatten.filterNull.toSet
	}
	
	def applyForward() {
		if (this.canBeBackwardsApplied) {
			throw new IllegalStateException("Change " + this + " cannot be applied forwards as was not backwards applied before.");	
		}
		this.EChange.applyForward
		this.canBeBackwardsApplied = true;
	}

	def applyBackward() {
		if (!this.canBeBackwardsApplied) {
			throw new IllegalStateException("Change " + this + " cannot be applied backwards as was not forward applied before.");	
		}
		this.EChange.applyBackward
		this.canBeBackwardsApplied = false;
	}
	
	private def void registerOldObjectTuidsForUpdate(Iterable<EObject> objects) {
		val tuidManager = TuidManager.instance
		for (object : objects) {
			tuidManager.registerObjectUnderModification(object)
		}
	}
	
	private def void updateTuids() {
		TuidManager.instance.updateTuidsOfRegisteredObjects
		TuidManager.instance.flushRegisteredObjectsUnderModification
	}
	
	override unresolveIfApplicable() {
		EChanges.forEach[EChangeUnresolver.unresolve(it)]	
	}
	
}