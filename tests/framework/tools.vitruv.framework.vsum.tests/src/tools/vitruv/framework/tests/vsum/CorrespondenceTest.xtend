package tools.vitruv.framework.tests.vsum

import java.util.List
import java.util.Set
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil
import org.junit.Test
import pcm_mockup.PInterface
import pcm_mockup.Repository
import tools.vitruv.framework.correspondence.Correspondence
import tools.vitruv.framework.correspondence.CorrespondenceModel
import tools.vitruv.framework.tuid.TuidManager
import tools.vitruv.framework.util.datatypes.ModelInstance
import tools.vitruv.framework.util.datatypes.VURI
import tools.vitruv.framework.vsum.InternalVirtualModel
import uml_mockup.UInterface
import uml_mockup.UPackage

import static org.junit.Assert.assertEquals
import static org.junit.Assert.assertFalse
import static org.junit.Assert.assertNotNull
import static org.junit.Assert.assertNull
import static org.junit.Assert.assertTrue

import static extension edu.kit.ipd.sdq.commons.util.java.lang.IterableUtil.*
import static extension tools.vitruv.framework.correspondence.CorrespondenceModelUtil.*
import static extension tools.vitruv.framework.util.bridges.CollectionBridge.toList

class CorrespondenceTest extends VsumTest {
	static final Logger LOGGER = Logger.getLogger(CorrespondenceTest.getSimpleName())

	@Test def void testAllInCommand() {
		val InternalVirtualModel vsum = createVirtualModelAndModelInstances()
		vsum.executeCommand([testAll(vsum) return null]);
	}

	def private void testAll(InternalVirtualModel vsum) {
		var Repository repo = testLoadObject(vsum, getDefaultPcmInstanceURI(), Repository)
		var UPackage pkg = testLoadObject(vsum, getDefaultUMLInstanceURI(), UPackage)
		var CorrespondenceModel correspondenceModel = testCorrespondenceModelCreation(vsum)
		assertFalse(correspondenceModel.hasCorrespondences())
		var Correspondence repo2pkg = createRepo2PkgCorrespondence(repo, pkg, correspondenceModel)
		// 1. EOC: repo _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg _sJD6YPxjEeOD3p0i_uuRbQ
		testAllClaimersAndGettersForEObjectCorrespondences(repo, pkg, correspondenceModel, repo2pkg)
		var PInterface repoInterface = testHasCorrespondences(repo, pkg, correspondenceModel)
		testSimpleRemove(pkg, correspondenceModel, repo2pkg, repoInterface) // 1. EOC: repo _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg _sJD6YPxjEeOD3p0i_uuRbQ
		testRecursiveRemove(repo, pkg, correspondenceModel, repo2pkg) // now the correspondence instance should be empty
		// recreate the same correspondence as before
		repo2pkg = createRepo2PkgCorrespondence(repo, pkg, correspondenceModel) // 1. EOC: repo _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg _sJD6YPxjEeOD3p0i_uuRbQ
		//testCreateRepo2PkgCorrespondenceAndUpdateTuid(repo, pkg, correspondenceModel, repo2pkg)
		val removedCorrespondences = correspondenceModel.removeCorrespondencesBetween(#[repo], #[pkg], null) // now the correspondence instance should be empty
		assertEquals(repo2pkg, removedCorrespondences.claimOne);
		testCorrespondencePersistence(vsum, repo, pkg, correspondenceModel)
	}

	@Test def void testCorrespondenceUpdate() {
		val InternalVirtualModel vsum = createVirtualModelAndModelInstances()
		vsum.executeCommand([ // create vsum and Repo and UPackage
			var Repository repo = testLoadObject(vsum, getDefaultPcmInstanceURI(), Repository)
			var UPackage pkg = testLoadObject(vsum, getDefaultUMLInstanceURI(), UPackage)
			// create correspondence
			var CorrespondenceModel correspondenceModel = testCorrespondenceModelCreation(vsum)
			correspondenceModel.createAndAddCorrespondence(repo, pkg)
			removePkgFromFileAndUpdateCorrespondence(pkg, correspondenceModel)
			saveUPackageInNewFileAndUpdateCorrespondence(vsum, pkg, correspondenceModel)
			assertRepositoryCorrespondences(repo, correspondenceModel)
			return null
		])
	}

	@Test def void testMoveRootEObjectBetweenResource() {
		val InternalVirtualModel vsum = createVirtualModelAndModelInstances()
		vsum.executeCommand([
			var Repository repo = testLoadObject(vsum, getDefaultPcmInstanceURI(), Repository)
			var UPackage pkg = testLoadObject(vsum, getDefaultUMLInstanceURI(), UPackage)
			// create correspondence
			var CorrespondenceModel correspondenceModel = testCorrespondenceModelCreation(vsum)
			correspondenceModel.createAndAddCorrespondence(repo, pkg) // execute the test
			moveUMLPackageTo(pkg, getTmpUMLInstanceURI(), vsum, correspondenceModel)
			moveUMLPackageTo(pkg, getNewUMLInstanceURI(), vsum, correspondenceModel)
			assertRepositoryCorrespondences(repo, correspondenceModel)
			return null
		])
	}

	def private void assertRepositoryCorrespondences(Repository repo,
		CorrespondenceModel correspondenceModel) {
		// get the correspondence of repo
		correspondenceModel.getCorrespondences(repo.toList).claimOne;
		var correspondingObjects = correspondenceModel.getCorrespondingEObjects(repo.toList).flatten
		assertEquals("Only one corresonding object is expected for the repository.", 1, correspondingObjects.size())
		for (correspondingObject : correspondingObjects) {
			assertNotNull("Corresponding object is null", correspondingObject)
			val reverseCorrespondingObjects = correspondenceModel.getCorrespondingEObjects(correspondingObject.toList).flatten
			assertNotNull("Reverse corresponding object is null", reverseCorrespondingObjects.claimOne)
			LOGGER.info('''A: «reverseCorrespondingObjects» corresponds to B: «correspondingObject»''')
		}

	}

	def private void moveUMLPackageTo(UPackage pkg, String string, InternalVirtualModel vsum,
		CorrespondenceModel correspondenceModel) {
		saveUPackageInNewFileAndUpdateCorrespondence(vsum, pkg, correspondenceModel)
	}

	def private void saveUPackageInNewFileAndUpdateCorrespondence(InternalVirtualModel vsum, UPackage pkg,
		CorrespondenceModel correspondenceModel) {
		var VURI newVURI = VURI.getInstance(getNewUMLInstanceURI())
		vsum.persistRootElement(newVURI, pkg)
	}

	def private String getNewUMLInstanceURI() {
		return '''«getCurrentProjectModelFolder()»/MyNewUML.uml_mockup'''
	}

	def private String getTmpUMLInstanceURI() {
		return '''«getCurrentProjectFolderName()»/MyTmpUML.uml_mockup'''
	}

	def private void removePkgFromFileAndUpdateCorrespondence(UPackage pkg,
		CorrespondenceModel correspondenceModel) {
		TuidManager.instance.registerObjectUnderModification(pkg);
		EcoreUtil.remove(pkg)
		TuidManager.instance.updateTuidsOfRegisteredObjects;
		TuidManager.instance.flushRegisteredObjectsUnderModification;
	}

	def private void testCorrespondencePersistence(InternalVirtualModel vsum, Repository repo, UPackage pkg,
		CorrespondenceModel corresp) {
		// recreate the same correspondence as before
		//var Correspondence repo2pkg = 
		createRepo2PkgCorrespondence(repo, pkg, corresp)
		// 1. EOC: repo _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg _sJD6YPxjEeOD3p0i_uuRbQ
		assertNotNull("Correspondence instance is null", corresp)
		// save instances in order to trigger saving for CorrespondenceModel(s)
		//var VURI pcmVURI = VURI.getInstance(getDefaultPcmInstanceURI())
		vsum.save()//(pcmVURI)
		// create a new vsum from disk and load correspondence instance from disk
		var InternalVirtualModel vsum2 = createAlternativeVirtualModelAndModelInstances(alternativePcmInstanceURI, alterantiveUMLInstanceURI);
		var Repository repo2 = testLoadObject(vsum2, alternativePcmInstanceURI, Repository)
		var UPackage pkg2 = testLoadObject(vsum2, alterantiveUMLInstanceURI, UPackage)
		var CorrespondenceModel corresp2 = testCorrespondenceModelCreation(vsum2)
		corresp2.createAndAddCorrespondence(repo2, pkg2);
		assertTrue(corresp2.hasCorrespondences()) // obtain
		var Correspondence repo2pkg2 = corresp2.claimUniqueCorrespondence(repo2.toList, pkg2.toList)
		// test everything as if the correspondence would just have been created
		testAllClaimersAndGettersForEObjectCorrespondences(repo2, pkg2, corresp2, repo2pkg2)
	}

	def private <T extends EObject> T testLoadObject(InternalVirtualModel vsum, URI uri, Class<T> clazz) {
		var VURI vURI = VURI.getInstance(uri)
		var ModelInstance instance = vsum.getModelInstance(vURI)
		var T obj = instance.getUniqueRootEObjectIfCorrectlyTyped(clazz)
		return obj
	}

	def private CorrespondenceModel testCorrespondenceModelCreation(InternalVirtualModel vsum) {
		var CorrespondenceModel corresp = vsum.getCorrespondenceModel()
		assertNotNull(corresp)
		return corresp
	}

	def private Correspondence createRepo2PkgCorrespondence(Repository repo, UPackage pkg,
		CorrespondenceModel corresp) {
		// until this point the correspondence instance is empty
		var Correspondence repo2pkg = corresp.createAndAddCorrespondence(repo, pkg)
		// 1. EOC: repo _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg _sJD6YPxjEeOD3p0i_uuRbQ
		return repo2pkg
	}

	def private void testAllClaimersAndGettersForEObjectCorrespondences(Repository repo, UPackage pkg,
		CorrespondenceModel corresp, Correspondence repo2pkg) {
		// claimAllCorrespondence is already indirectly tested via claimUniqueCorrespondence
		var Correspondence uniqueRepoCorrespondence = corresp.claimUniqueCorrespondence(repo)
		assertEquals(uniqueRepoCorrespondence, repo2pkg)
		var Correspondence uniquePkgCorrespondence = corresp.claimUniqueCorrespondence(pkg)
		assertEquals(uniquePkgCorrespondence, repo2pkg) // claimCorrespondingEObject is already indirectly tested via
		// claimUniqueCorrespondingEObject
		var EObject correspForRepo = corresp.getCorrespondingEObjects(repo).claimOne
		assertEquals(correspForRepo, pkg)
		var EObject correspForPkg = corresp.getCorrespondingEObjects(pkg).claimOne
		assertEquals(correspForPkg, repo)
		var List<PInterface> interfaces = repo.getInterfaces()
		assertEquals(interfaces.size(), 1)
		var PInterface iface = interfaces.get(0)
		var Correspondence correspForIface = corresp.getCorrespondences(iface.toList).claimNotMany
		assertNull(correspForIface) // TODO test exception throwing of claimUniqueOrNullCorrespondenceForEObject
		var Set<Correspondence> allRepoCorrespondences = corresp.getCorrespondences(repo.toList)
		assertEquals(allRepoCorrespondences.size(), 1)
		assertTrue(allRepoCorrespondences.contains(repo2pkg))
		var Set<Correspondence> allPkgCorrespondences = corresp.getCorrespondences(pkg.toList)
		assertEquals(allPkgCorrespondences.size(), 1)
		assertTrue(allPkgCorrespondences.contains(repo2pkg))
		var Set<Repository> allRepoTypeCorresp = corresp.getAllEObjectsOfTypeInCorrespondences(Repository)
		assertTrue(allRepoTypeCorresp.contains(repo))
		var Set<UPackage> allPkgTypeCorresp = corresp.getAllEObjectsOfTypeInCorrespondences(UPackage)
		assertTrue(allPkgTypeCorresp.contains(pkg))
		var Set<EObject> allCorrespForRepo = corresp.getCorrespondingEObjects(repo)
		assertEquals(allCorrespForRepo.size(), 1)
		assertTrue(allCorrespForRepo.contains(pkg))
		var Set<EObject> allCorrespForPkg = corresp.getCorrespondingEObjects(pkg)
		assertEquals(allCorrespForPkg.size(), 1)
		assertTrue(allCorrespForPkg.contains(repo))
	}

	def private PInterface testHasCorrespondences(Repository repo, UPackage pkg, CorrespondenceModel corresp) {
		assertTrue(corresp.hasCorrespondences(repo.toList))
		assertTrue(corresp.hasCorrespondences(pkg.toList))
		var List<PInterface> repoInterfaces = repo.getInterfaces()
		assertEquals(repoInterfaces.size(), 1)
		var PInterface repoInterface = repoInterfaces.get(0)
		assertTrue(!corresp.hasCorrespondences(repoInterface.toList))
		return repoInterface
	}

	def private void testSimpleRemove(UPackage pkg, CorrespondenceModel corresp, Correspondence repo2pkg,
		PInterface repoInterface) {
		var List<UInterface> pkgInterfaces = pkg.getInterfaces()
		assertEquals(pkgInterfaces.size(), 1)
		var UInterface pkgInterface = pkgInterfaces.get(0)
		// 1. EOC: repo _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg _sJD6YPxjEeOD3p0i_uuRbQ
		// 2. CRC: repo.ifaces _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg.ifaces _sJD6YPxjEeOD3p0i_uuRbQ
		// add correspondence
		corresp.createAndAddCorrespondence(repoInterface, pkgInterface) // 1. EOC: repo _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg _sJD6YPxjEeOD3p0i_uuRbQ
		// 2. CRC: repo.ifaces _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg.ifaces _sJD6YPxjEeOD3p0i_uuRbQ
		// 3. EOC: pcmIfac _tAgfwPxjEeOD3p0i_uuRbQ <=> umlIface _vWjxIPxjEeOD3p0i_uuRbQ
		// remove correspondence
		corresp.removeCorrespondencesFor(repoInterface.toList, null) // 1. EOC: repo _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg _sJD6YPxjEeOD3p0i_uuRbQ
		// 2. CRC: repo.ifaces _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg.ifaces _sJD6YPxjEeOD3p0i_uuRbQ
		// check whether it is removed
		var Set<Correspondence> repoInterfaceCorresp = corresp.getCorrespondences(repoInterface.toList)
		assertTrue(repoInterfaceCorresp.isEmpty())
		var Set<Correspondence> pkgInterfaceCorresp = corresp.getCorrespondences(pkgInterface.toList)
		assertTrue(pkgInterfaceCorresp.isEmpty())
		var Set<EObject> correspForRepoInterface = corresp.getCorrespondingEObjects(repoInterface)
		assertTrue(correspForRepoInterface.isEmpty())
		var Set<EObject> correspForPkgInterface = corresp.getCorrespondingEObjects(pkgInterface)
		assertTrue(correspForPkgInterface.isEmpty())
		var Set<PInterface> correspForRepoInterfaceType = corresp.getAllEObjectsOfTypeInCorrespondences(PInterface)
		assertTrue(correspForRepoInterfaceType.isEmpty()) 
		var Set<UInterface> correspForPkgInterfaceType = corresp.
			getAllEObjectsOfTypeInCorrespondences(UInterface)
		assertTrue(correspForPkgInterfaceType.isEmpty())
	}

	def private void testRecursiveRemove(Repository repo, UPackage pkg, CorrespondenceModel corresp,
		Correspondence repo2pkg) {
		// 1. EOC: repo _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg _sJD6YPxjEeOD3p0i_uuRbQ
		// 2. CRC: repo.ifaces _r5CW0PxiEeO_U4GJ6Zitkg <=> pkg.ifaces _sJD6YPxjEeOD3p0i_uuRbQ
		val removedCorrespondences = corresp.removeCorrespondencesBetween(#[repo], #[pkg], null) // now the correspondence instance should be empty
		assertEquals(repo2pkg, removedCorrespondences.claimOne);
		var Set<Correspondence> repoCorresp = corresp.getCorrespondences(repo.toList)
		assertTrue(repoCorresp.isEmpty())
		var Set<Correspondence> pkgCorresp = corresp.getCorrespondences(pkg.toList)
		assertTrue(pkgCorresp.isEmpty())
		var Set<EObject> correspForRepo = corresp.getCorrespondingEObjects(repo)
		assertTrue(correspForRepo.isEmpty())
		var Set<EObject> correspForPkg = corresp.getCorrespondingEObjects(pkg)
		assertTrue(correspForPkg.isEmpty())
		var Set<Repository> correspForRepoType = corresp.getAllEObjectsOfTypeInCorrespondences(Repository)
		assertTrue(correspForRepoType.isEmpty())
		var Set<UPackage> correspForPkgType = corresp.getAllEObjectsOfTypeInCorrespondences(UPackage)
		assertTrue(correspForPkgType.isEmpty()) // FeatureInstance repoIfaceFI = repoIfaceFIAndPkgIfaceFI.getFirst();
		// FeatureInstance pkgIfaceFI = repoIfaceFIAndPkgIfaceFI.getSecond();
		// Set<FeatureInstance> correspForRepoIfaceFI =
		// corresp.getAllCorrespondingFeatureInstances(repoIfaceFI);
		// assertTrue(correspForRepoIfaceFI.isEmpty());
		// Set<FeatureInstance> correspForPkgIfaceFI =
		// corresp.getAllCorrespondingFeatureInstances(pkgIfaceFI);
		// assertTrue(correspForPkgIfaceFI.isEmpty());
		// assertFalse(corresp.hasCorrespondences());
	}

//	def private void testCreateRepo2PkgCorrespondenceAndUpdateTuid(Repository repo, UPackage pkg,
//		CorrespondenceModel corresp, Correspondence repo2pkg) {
//		var Repository newRepo = Pcm_mockupFactory.eINSTANCE.createRepository()
//		TuidManager.instance.updateTuid(repo, newRepo)
//		var Set<Correspondence> repoCorresp = corresp.getCorrespondences(repo.toList)
//		assertTrue(repoCorresp.isEmpty())
//		var Correspondence uniqueNewRepoCorrespondence = corresp.claimUniqueCorrespondence(newRepo)
//		assertEquals(uniqueNewRepoCorrespondence, repo2pkg)
//		var Correspondence uniquePkgCorrespondence = corresp.claimUniqueCorrespondence(pkg)
//		assertEquals(uniquePkgCorrespondence, repo2pkg)
//		var EObject correspForNewRepo = corresp.getCorrespondingEObjects(newRepo).claimOne
//		assertEquals(correspForNewRepo, pkg)
//		var EObject correspForPkg = corresp.getCorrespondingEObjects(pkg).claimOne
//		assertEquals(correspForPkg, newRepo) // TODO is this really enough update testing?
//	}

}
