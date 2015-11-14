/**
 */
package edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.impl;

import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.ConstraintLiteral;
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.EqualsLiteralExpression;
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.FeatureOfContextVariable;
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.MappingLanguagePackage;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Equals Literal Expression</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.impl.EqualsLiteralExpressionImpl#getTarget <em>Target</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.impl.EqualsLiteralExpressionImpl#getValue <em>Value</em>}</li>
 * </ul>
 *
 * @generated
 */
public class EqualsLiteralExpressionImpl extends ConstraintExpressionImpl implements EqualsLiteralExpression
{
  /**
   * The cached value of the '{@link #getTarget() <em>Target</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getTarget()
   * @generated
   * @ordered
   */
  protected FeatureOfContextVariable target;

  /**
   * The cached value of the '{@link #getValue() <em>Value</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getValue()
   * @generated
   * @ordered
   */
  protected ConstraintLiteral value;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected EqualsLiteralExpressionImpl()
  {
    super();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  protected EClass eStaticClass()
  {
    return MappingLanguagePackage.Literals.EQUALS_LITERAL_EXPRESSION;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public FeatureOfContextVariable getTarget()
  {
    return target;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public NotificationChain basicSetTarget(FeatureOfContextVariable newTarget, NotificationChain msgs)
  {
    FeatureOfContextVariable oldTarget = target;
    target = newTarget;
    if (eNotificationRequired())
    {
      ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__TARGET, oldTarget, newTarget);
      if (msgs == null) msgs = notification; else msgs.add(notification);
    }
    return msgs;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void setTarget(FeatureOfContextVariable newTarget)
  {
    if (newTarget != target)
    {
      NotificationChain msgs = null;
      if (target != null)
        msgs = ((InternalEObject)target).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__TARGET, null, msgs);
      if (newTarget != null)
        msgs = ((InternalEObject)newTarget).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__TARGET, null, msgs);
      msgs = basicSetTarget(newTarget, msgs);
      if (msgs != null) msgs.dispatch();
    }
    else if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__TARGET, newTarget, newTarget));
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public ConstraintLiteral getValue()
  {
    return value;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public NotificationChain basicSetValue(ConstraintLiteral newValue, NotificationChain msgs)
  {
    ConstraintLiteral oldValue = value;
    value = newValue;
    if (eNotificationRequired())
    {
      ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__VALUE, oldValue, newValue);
      if (msgs == null) msgs = notification; else msgs.add(notification);
    }
    return msgs;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void setValue(ConstraintLiteral newValue)
  {
    if (newValue != value)
    {
      NotificationChain msgs = null;
      if (value != null)
        msgs = ((InternalEObject)value).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__VALUE, null, msgs);
      if (newValue != null)
        msgs = ((InternalEObject)newValue).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__VALUE, null, msgs);
      msgs = basicSetValue(newValue, msgs);
      if (msgs != null) msgs.dispatch();
    }
    else if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__VALUE, newValue, newValue));
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs)
  {
    switch (featureID)
    {
      case MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__TARGET:
        return basicSetTarget(null, msgs);
      case MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__VALUE:
        return basicSetValue(null, msgs);
    }
    return super.eInverseRemove(otherEnd, featureID, msgs);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public Object eGet(int featureID, boolean resolve, boolean coreType)
  {
    switch (featureID)
    {
      case MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__TARGET:
        return getTarget();
      case MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__VALUE:
        return getValue();
    }
    return super.eGet(featureID, resolve, coreType);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void eSet(int featureID, Object newValue)
  {
    switch (featureID)
    {
      case MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__TARGET:
        setTarget((FeatureOfContextVariable)newValue);
        return;
      case MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__VALUE:
        setValue((ConstraintLiteral)newValue);
        return;
    }
    super.eSet(featureID, newValue);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void eUnset(int featureID)
  {
    switch (featureID)
    {
      case MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__TARGET:
        setTarget((FeatureOfContextVariable)null);
        return;
      case MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__VALUE:
        setValue((ConstraintLiteral)null);
        return;
    }
    super.eUnset(featureID);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public boolean eIsSet(int featureID)
  {
    switch (featureID)
    {
      case MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__TARGET:
        return target != null;
      case MappingLanguagePackage.EQUALS_LITERAL_EXPRESSION__VALUE:
        return value != null;
    }
    return super.eIsSet(featureID);
  }

} //EqualsLiteralExpressionImpl