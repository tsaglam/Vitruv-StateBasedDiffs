/**
 */
package edu.kit.ipd.sdq.vitruvius.framework.change.echange.feature.attribute;

import edu.kit.ipd.sdq.vitruvius.framework.change.echange.SubtractiveEChange;
import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Subtractive Attribute EChange</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.change.echange.feature.attribute.SubtractiveAttributeEChange#getOldValue <em>Old Value</em>}</li>
 * </ul>
 *
 * @see edu.kit.ipd.sdq.vitruvius.framework.change.echange.feature.attribute.AttributePackage#getSubtractiveAttributeEChange()
 * @model abstract="true" TBounds="org.eclipse.emf.ecore.EJavaObject"
 * @generated
 */
public interface SubtractiveAttributeEChange<A extends EObject, T extends Object> extends SubtractiveEChange<T>, UpdateAttributeEChange<A> {
    /**
	 * Returns the value of the '<em><b>Old Value</b></em>' attribute.
	 * <!-- begin-user-doc -->
     * <p>
     * If the meaning of the '<em>Old Value</em>' attribute isn't clear,
     * there really should be more of a description here...
     * </p>
     * <!-- end-user-doc -->
	 * @return the value of the '<em>Old Value</em>' attribute.
	 * @see #setOldValue(Object)
	 * @see edu.kit.ipd.sdq.vitruvius.framework.change.echange.feature.attribute.AttributePackage#getSubtractiveAttributeEChange_OldValue()
	 * @model required="true"
	 * @generated
	 */
    T getOldValue();

    /**
	 * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.framework.change.echange.feature.attribute.SubtractiveAttributeEChange#getOldValue <em>Old Value</em>}' attribute.
	 * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Old Value</em>' attribute.
	 * @see #getOldValue()
	 * @generated
	 */
    void setOldValue(T value);

} // SubtractiveAttributeEChange