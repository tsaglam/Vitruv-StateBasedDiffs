package mir.reactions.test_L2RSegment;

import edu.kit.ipd.sdq.metamodels.addresses.Addresses;
import mir.routines.test_L2RSegment.RoutinesFacade;
import org.eclipse.xtext.xbase.lib.Extension;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractReactionRealization;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;
import tools.vitruv.framework.change.echange.EChange;
import tools.vitruv.framework.change.echange.eobject.DeleteEObject;

@SuppressWarnings("all")
public class OnAdRootXReRootAddressesDeletedReaction extends AbstractReactionRealization {
  private DeleteEObject<Addresses> deleteChange;
  
  private int currentlyMatchedChange;
  
  public OnAdRootXReRootAddressesDeletedReaction(final RoutinesFacade routinesFacade) {
    super(routinesFacade);
  }
  
  public void executeReaction(final EChange change) {
    if (!checkPrecondition(change)) {
    	return;
    }
    edu.kit.ipd.sdq.metamodels.addresses.Addresses affectedEObject = deleteChange.getAffectedEObject();
    				
    getLogger().trace("Passed complete precondition check of Reaction " + this.getClass().getName());
    				
    mir.reactions.test_L2RSegment.OnAdRootXReRootAddressesDeletedReaction.ActionUserExecution userExecution = new mir.reactions.test_L2RSegment.OnAdRootXReRootAddressesDeletedReaction.ActionUserExecution(this.executionState, this);
    userExecution.callRoutine1(deleteChange, affectedEObject, this.getRoutinesFacade());
    
    resetChanges();
  }
  
  private boolean matchDeleteChange(final EChange change) {
    if (change instanceof DeleteEObject<?>) {
    	DeleteEObject<edu.kit.ipd.sdq.metamodels.addresses.Addresses> _localTypedChange = (DeleteEObject<edu.kit.ipd.sdq.metamodels.addresses.Addresses>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof edu.kit.ipd.sdq.metamodels.addresses.Addresses)) {
    		return false;
    	}
    	this.deleteChange = (DeleteEObject<edu.kit.ipd.sdq.metamodels.addresses.Addresses>) change;
    	return true;
    }
    
    return false;
  }
  
  private void resetChanges() {
    deleteChange = null;
    currentlyMatchedChange = 0;
  }
  
  public boolean checkPrecondition(final EChange change) {
    if (currentlyMatchedChange == 0) {
    	if (!matchDeleteChange(change)) {
    		resetChanges();
    		return false;
    	} else {
    		currentlyMatchedChange++;
    	}
    }
    
    return true;
  }
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final DeleteEObject deleteChange, final Addresses affectedEObject, @Extension final RoutinesFacade _routinesFacade) {
      _routinesFacade.onAdRootXReRootAddressesDeletedRepair(affectedEObject);
    }
  }
}
