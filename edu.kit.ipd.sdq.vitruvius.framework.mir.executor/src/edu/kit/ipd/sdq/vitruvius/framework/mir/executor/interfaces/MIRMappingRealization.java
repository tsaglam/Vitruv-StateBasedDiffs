package edu.kit.ipd.sdq.vitruvius.framework.mir.executor.interfaces;

import java.io.Serializable;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.Blackboard;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.TransformationResult;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.EChange;

/**
 * Represents a MIR mapping. Concrete implementations are generated by
 * {@link MIRCodeGenerator}.
 * @author Dominik Werle
 *
 */
public interface MIRMappingRealization extends Serializable {
	/**
	 * Applies the mapping.
	 * @param eChange
	 * @param correspondenceInstance
	 * @return the resulting change
	 */
	public TransformationResult applyEChange(EChange eChange, Blackboard blackboard);
	
	/**
	 * Returns an ID that is unique for all mapping realizations.
	 * @return
	 */
	public String getMappingID();
}
