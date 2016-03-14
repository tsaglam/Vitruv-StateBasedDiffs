/**
 * generated by Xtext 2.9.1
 */
package edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Model Persistence</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ModelPersistence#isUseRelativeToSource <em>Use Relative To Source</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ModelPersistence#isUseRelativeToProject <em>Use Relative To Project</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ModelPersistence#getModelPath <em>Model Path</em>}</li>
 * </ul>
 *
 * @see edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguagePackage#getModelPersistence()
 * @model
 * @generated
 */
public interface ModelPersistence extends EObject
{
  /**
   * Returns the value of the '<em><b>Use Relative To Source</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Use Relative To Source</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Use Relative To Source</em>' attribute.
   * @see #setUseRelativeToSource(boolean)
   * @see edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguagePackage#getModelPersistence_UseRelativeToSource()
   * @model
   * @generated
   */
  boolean isUseRelativeToSource();

  /**
   * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ModelPersistence#isUseRelativeToSource <em>Use Relative To Source</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Use Relative To Source</em>' attribute.
   * @see #isUseRelativeToSource()
   * @generated
   */
  void setUseRelativeToSource(boolean value);

  /**
   * Returns the value of the '<em><b>Use Relative To Project</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Use Relative To Project</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Use Relative To Project</em>' attribute.
   * @see #setUseRelativeToProject(boolean)
   * @see edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguagePackage#getModelPersistence_UseRelativeToProject()
   * @model
   * @generated
   */
  boolean isUseRelativeToProject();

  /**
   * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ModelPersistence#isUseRelativeToProject <em>Use Relative To Project</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Use Relative To Project</em>' attribute.
   * @see #isUseRelativeToProject()
   * @generated
   */
  void setUseRelativeToProject(boolean value);

  /**
   * Returns the value of the '<em><b>Model Path</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Model Path</em>' containment reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Model Path</em>' containment reference.
   * @see #setModelPath(ModelPathCodeBlock)
   * @see edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponseLanguagePackage#getModelPersistence_ModelPath()
   * @model containment="true"
   * @generated
   */
  ModelPathCodeBlock getModelPath();

  /**
   * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ModelPersistence#getModelPath <em>Model Path</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Model Path</em>' containment reference.
   * @see #getModelPath()
   * @generated
   */
  void setModelPath(ModelPathCodeBlock value);

} // ModelPersistence