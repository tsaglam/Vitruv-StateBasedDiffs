/** 
 */
package tools.vitruv.framework.versioning.repository.impl

import java.util.Collection
import org.eclipse.emf.common.notify.Notification
import org.eclipse.emf.common.notify.NotificationChain
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.InternalEObject
import org.eclipse.emf.ecore.impl.ENotificationImpl
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl
import org.eclipse.emf.ecore.util.EObjectContainmentEList
import org.eclipse.emf.ecore.util.EObjectResolvingEList
import org.eclipse.emf.ecore.util.InternalEList
import tools.vitruv.framework.versioning.branch.Branch
import tools.vitruv.framework.versioning.branch.MasterBranch
import tools.vitruv.framework.versioning.commit.Commit
import tools.vitruv.framework.versioning.commit.InitialCommit
import tools.vitruv.framework.versioning.repository.Repository
import tools.vitruv.framework.versioning.repository.RepositoryPackage
import tools.vitruv.framework.versioning.repository.Tag

/** 
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Repository</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 * <li>{@link tools.vitruv.framework.versioning.repository.impl.RepositoryImpl#getTags <em>Tags</em>}</li>
 * <li>{@link tools.vitruv.framework.versioning.repository.impl.RepositoryImpl#getCommits <em>Commits</em>}</li>
 * <li>{@link tools.vitruv.framework.versioning.repository.impl.RepositoryImpl#getBranches <em>Branches</em>}</li>
 * <li>{@link tools.vitruv.framework.versioning.repository.impl.RepositoryImpl#getInitialCommit <em>Initial Commit</em>}</li>
 * <li>{@link tools.vitruv.framework.versioning.repository.impl.RepositoryImpl#getMaster <em>Master</em>}</li>
 * </ul>
 * @generated
 */
class RepositoryImpl extends MinimalEObjectImpl.Container implements Repository {
	/** 
	 * The cached value of the '{@link #getTags() <em>Tags</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTags()
	 * @generated
	 * @ordered
	 */
	protected EList<Tag> tags
	/** 
	 * The cached value of the '{@link #getCommits() <em>Commits</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCommits()
	 * @generated
	 * @ordered
	 */
	protected EList<Commit> commits
	/** 
	 * The cached value of the '{@link #getBranches() <em>Branches</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getBranches()
	 * @generated
	 * @ordered
	 */
	protected EList<Branch> branches
	/** 
	 * The cached value of the '{@link #getInitialCommit() <em>Initial Commit</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getInitialCommit()
	 * @generated
	 * @ordered
	 */
	protected InitialCommit initialCommit
	/** 
	 * The cached value of the '{@link #getMaster() <em>Master</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getMaster()
	 * @generated
	 * @ordered
	 */
	protected MasterBranch master

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected new() {
		super()
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override protected EClass eStaticClass() {
		return RepositoryPackage.Literals.REPOSITORY
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override EList<Tag> getTags() {
		if (tags === null) {
			tags = new EObjectContainmentEList<Tag>(Tag, this, RepositoryPackage.REPOSITORY__TAGS)
		}
		return tags
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override EList<Commit> getCommits() {
		if (commits === null) {
			commits = new EObjectResolvingEList<Commit>(Commit, this, RepositoryPackage.REPOSITORY__COMMITS)
		}
		return commits
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override EList<Branch> getBranches() {
		if (branches === null) {
			branches = new EObjectContainmentEList<Branch>(Branch, this, RepositoryPackage.REPOSITORY__BRANCHES)
		}
		return branches
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override InitialCommit getInitialCommit() {
		return initialCommit
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	def NotificationChain basicSetInitialCommit(InitialCommit newInitialCommit, NotificationChain msgs_finalParam_) {
		var msgs = msgs_finalParam_
		var InitialCommit oldInitialCommit = initialCommit
		initialCommit = newInitialCommit
		if (eNotificationRequired()) {
			var ENotificationImpl notification = new ENotificationImpl(this, Notification.SET,
				RepositoryPackage.REPOSITORY__INITIAL_COMMIT, oldInitialCommit, newInitialCommit)
			if (msgs === null) msgs = notification else msgs.add(notification)
		}
		return msgs
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override void setInitialCommit(InitialCommit newInitialCommit) {
		if (newInitialCommit !== initialCommit) {
			var NotificationChain msgs = null
			if (initialCommit !== null) msgs = ((initialCommit as InternalEObject)).eInverseRemove(this,
				EOPPOSITE_FEATURE_BASE - RepositoryPackage.REPOSITORY__INITIAL_COMMIT, null, msgs)
			if (newInitialCommit !== null) msgs = ((newInitialCommit as InternalEObject)).eInverseAdd(this,
				EOPPOSITE_FEATURE_BASE - RepositoryPackage.REPOSITORY__INITIAL_COMMIT, null, msgs)
			msgs = basicSetInitialCommit(newInitialCommit, msgs)
			if (msgs !== null) msgs.^dispatch()
		} else if (eNotificationRequired()) eNotify(
			new ENotificationImpl(this, Notification.SET, RepositoryPackage.REPOSITORY__INITIAL_COMMIT,
				newInitialCommit, newInitialCommit))
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override MasterBranch getMaster() {
		if (master !== null && master.eIsProxy()) {
			var InternalEObject oldMaster = (master as InternalEObject)
			master = eResolveProxy(oldMaster) as MasterBranch
			if (master !== oldMaster) {
				if (eNotificationRequired()) eNotify(
					new ENotificationImpl(this, Notification.RESOLVE, RepositoryPackage.REPOSITORY__MASTER, oldMaster,
						master))
			}
		}
		return master
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	def MasterBranch basicGetMaster() {
		return master
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override void setMaster(MasterBranch newMaster) {
		var MasterBranch oldMaster = master
		master = newMaster
		if (eNotificationRequired()) eNotify(
			new ENotificationImpl(this, Notification.SET, RepositoryPackage.REPOSITORY__MASTER, oldMaster, master))
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {

		switch (featureID) {
			case RepositoryPackage.REPOSITORY__TAGS: {
				return ((getTags() as InternalEList<?>)).basicRemove(otherEnd, msgs)
			}
			case RepositoryPackage.REPOSITORY__BRANCHES: {
				return ((getBranches() as InternalEList<?>)).basicRemove(otherEnd, msgs)
			}
			case RepositoryPackage.REPOSITORY__INITIAL_COMMIT: {
				return basicSetInitialCommit(null, msgs)
			}
		}
		return super.eInverseRemove(otherEnd, featureID, msgs)
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override Object eGet(int featureID, boolean resolve, boolean coreType) {

		switch (featureID) {
			case RepositoryPackage.REPOSITORY__TAGS: {
				return getTags()
			}
			case RepositoryPackage.REPOSITORY__COMMITS: {
				return getCommits()
			}
			case RepositoryPackage.REPOSITORY__BRANCHES: {
				return getBranches()
			}
			case RepositoryPackage.REPOSITORY__INITIAL_COMMIT: {
				return getInitialCommit()
			}
			case RepositoryPackage.REPOSITORY__MASTER: {
				if (resolve) return getMaster()
				return basicGetMaster()
			}
		}
		return super.eGet(featureID, resolve, coreType)
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	override void eSet(int featureID, Object newValue) {

		switch (featureID) {
			case RepositoryPackage.REPOSITORY__TAGS: {
				getTags().clear()
				getTags().addAll((newValue as Collection<? extends Tag>))
				return
			}
			case RepositoryPackage.REPOSITORY__COMMITS: {
				getCommits().clear()
				getCommits().addAll((newValue as Collection<? extends Commit>))
				return
			}
			case RepositoryPackage.REPOSITORY__BRANCHES: {
				getBranches().clear()
				getBranches().addAll((newValue as Collection<? extends Branch>))
				return
			}
			case RepositoryPackage.REPOSITORY__INITIAL_COMMIT: {
				setInitialCommit((newValue as InitialCommit))
				return
			}
			case RepositoryPackage.REPOSITORY__MASTER: {
				setMaster((newValue as MasterBranch))
				return
			}
		}
		super.eSet(featureID, newValue)
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override void eUnset(int featureID) {

		switch (featureID) {
			case RepositoryPackage.REPOSITORY__TAGS: {
				getTags().clear()
				return
			}
			case RepositoryPackage.REPOSITORY__COMMITS: {
				getCommits().clear()
				return
			}
			case RepositoryPackage.REPOSITORY__BRANCHES: {
				getBranches().clear()
				return
			}
			case RepositoryPackage.REPOSITORY__INITIAL_COMMIT: {
				setInitialCommit((null as InitialCommit))
				return
			}
			case RepositoryPackage.REPOSITORY__MASTER: {
				setMaster((null as MasterBranch))
				return
			}
		}
		super.eUnset(featureID)
	}

	/** 
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	override boolean eIsSet(int featureID) {

		switch (featureID) {
			case RepositoryPackage.REPOSITORY__TAGS: {
				return tags !== null && !tags.isEmpty()
			}
			case RepositoryPackage.REPOSITORY__COMMITS: {
				return commits !== null && !commits.isEmpty()
			}
			case RepositoryPackage.REPOSITORY__BRANCHES: {
				return branches !== null && !branches.isEmpty()
			}
			case RepositoryPackage.REPOSITORY__INITIAL_COMMIT: {
				return initialCommit !== null
			}
			case RepositoryPackage.REPOSITORY__MASTER: {
				return master !== null
			}
		}
		return super.eIsSet(featureID)
	} // RepositoryImpl
}