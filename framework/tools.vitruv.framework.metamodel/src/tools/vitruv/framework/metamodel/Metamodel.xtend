package tools.vitruv.framework.metamodel

import java.util.Arrays
import java.util.Collections
import java.util.HashSet
import java.util.List
import java.util.Map
import java.util.Set
import org.eclipse.emf.ecore.EObject
import tools.vitruv.framework.tuid.TUIDCalculatorAndResolver
import tools.vitruv.framework.tuid.DefaultTUIDCalculatorAndResolver
import tools.vitruv.framework.util.datatypes.VURI
import tools.vitruv.framework.util.datatypes.AbstractURIHaving
import tools.vitruv.framework.tuid.TUID
import tools.vitruv.framework.tuid.TuidCalculator
import tools.vitruv.framework.tuid.TuidUpdateListener
import tools.vitruv.framework.tuid.TuidManager
import java.util.ArrayList

class Metamodel extends AbstractURIHaving implements TuidCalculator, TuidUpdateListener {
	List<String> fileExtensions
	TUIDCalculatorAndResolver tuidCalculatorAndResolver
	Set<String> nsURIs
	Map<Object, Object> defaultLoadOptions
	Map<Object, Object> defaultSaveOptions

	def private static Set<String> getNsURISet(String... nsURIs) {
		return new HashSet<String>(Arrays::asList(nsURIs))
	}

	def private static String getTUIDPrefix(String... nsURIs) {
		return getTUIDPrefix(getNsURISet(nsURIs))
	}

	def private static String getTUIDPrefix(Set<String> nsURIs) {
		if (nsURIs !== null && nsURIs.size() > 0) {
			return nsURIs.iterator().next()
		} else {
			throw new RuntimeException(
				'''Cannot get a TUID prefix from the set of namespace URIs '«»«nsURIs»'!'''.toString)
		}
	}

	new(String nsURI, VURI uri, String... fileExtensions) {
		this(getNsURISet(nsURI), uri, new DefaultTUIDCalculatorAndResolver(getTUIDPrefix(nsURI)), fileExtensions)
	}

	new(Set<String> nsURIs, VURI uri, String... fileExtensions) {
		this(nsURIs, uri, new DefaultTUIDCalculatorAndResolver(getTUIDPrefix(nsURIs)), fileExtensions)
	}

	new(String nsURI, String nameOfIDFeature, String nameOfNameAttribute, VURI uri, String... fileExtensions) {
		this(getNsURISet(nsURI), uri,
			new DefaultTUIDCalculatorAndResolver(getTUIDPrefix(nsURI), nameOfIDFeature, nameOfNameAttribute),
			fileExtensions)
	}

	new(Set<String> nsURIs, String nameOfIDFeature, VURI uri, String... fileExtensions) {
		this(nsURIs, uri, new DefaultTUIDCalculatorAndResolver(getTUIDPrefix(nsURIs), nameOfIDFeature),
			fileExtensions)
	}

	new(String nsURI, VURI uri, TUIDCalculatorAndResolver tuidCalculatorAndResolver, String... fileExtensions) {
		this(getNsURISet(nsURI), uri, tuidCalculatorAndResolver, fileExtensions)
	}

	new(Set<String> nsURIs, VURI uri, TUIDCalculatorAndResolver tuidCalculatorAndResolver,
		String... fileExtensions) {
		this(nsURIs, uri, tuidCalculatorAndResolver, Collections::emptyMap(), Collections::emptyMap(),
			fileExtensions)
	}

	new(Set<String> nsURIs, VURI uri, TUIDCalculatorAndResolver tuidCalculatorAndResolver,
		Map<Object, Object> defaultLoadOptions, Map<Object, Object> defaultSaveOptions, String... fileExtensions) {
		super(uri)
		this.fileExtensions = fileExtensions
		this.tuidCalculatorAndResolver = tuidCalculatorAndResolver
		this.nsURIs = nsURIs
		this.defaultLoadOptions = defaultLoadOptions
		this.defaultSaveOptions = defaultSaveOptions
		TuidManager.instance.addTuidCalculator(this);
		TuidManager.instance.addTuidUpdateListener(this);
	}

	def List<String> getFileExtensions() {
		return new ArrayList<String>(this.fileExtensions);
	}

	def boolean hasTUID(EObject eObject) {
		return tuidCalculatorAndResolver.hasTUID(eObject);
	}

	def String calculateTUIDFromEObject(EObject eObject) {
		return this.tuidCalculatorAndResolver.calculateTUIDFromEObject(eObject)
	}

	/** 
	 * syntactic sugar for map[{@link #calculateTUIDFromEObject(EObject)}]
	 * @param eObjects
	 * @return
	 */
	def List<String> calculateTUIDsFromEObjects(List<EObject> eObjects) {
		return eObjects.map[calculateTUIDFromEObject(it)].toList
	}
	
	def String calculateTUIDFromEObject(EObject eObject, EObject virtualRootObject, String prefix){
		return this.tuidCalculatorAndResolver.calculateTUIDFromEObject(eObject, virtualRootObject, prefix)
	}

	def VURI getModelVURIContainingIdentifiedEObject(String tuid) {
		val modelVURI = this.tuidCalculatorAndResolver.getModelVURIContainingIdentifiedEObject(tuid)
		if(null == modelVURI){
			return null;
		}
		return VURI::getInstance(modelVURI)
	}

	def EObject resolveEObjectFromRootAndFullTUID(EObject root, String tuid) {
		return this.tuidCalculatorAndResolver.resolveEObjectFromRootAndFullTUID(root, tuid)
	}

	def void removeRootFromTUIDCache(EObject root) {
		this.tuidCalculatorAndResolver.removeRootFromCache(root)
	}

	def void removeIfRootAndCached(String tuid) {
		this.tuidCalculatorAndResolver.removeIfRootAndCached(tuid)
	}

	def boolean hasMetaclassInstances(List<EObject> eObjects) {
		for (EObject eObject : eObjects) {
			if (null === eObject || null === eObject.eClass() || null === eObject.eClass().getEPackage() ||
				null === eObject.eClass().getEPackage().getNsURI() ||
				!this.nsURIs.contains(eObject.eClass().getEPackage().getNsURI())) {
				return false
			}

		}
		return true
	}

	def boolean hasTUID(String tuid) {
		return this.tuidCalculatorAndResolver.isValidTUID(tuid)
	}

	def Set<String> getNsURIs() {
		return this.nsURIs
	}

	def Map<Object, Object> getDefaultLoadOptions() {
		return this.defaultLoadOptions
	}

	def Map<Object, Object> getDefaultSaveOptions() {
		return this.defaultSaveOptions
	}

	override canCalculateTuid(EObject object) {
		return hasMetaclassInstances(#[object]) && hasTUID(object);
	}
	
	override calculateTuid(EObject object) {
		return TUID.getInstance(calculateTUIDFromEObject(object));
	}
	
	override performPreAction(TUID oldTuid) {
		if (this.hasTUID(oldTuid.toString)) {
			removeIfRootAndCached(oldTuid.toString);
		}
	}
	
	override performPostAction(TUID newTuid) {
		// Do nothing
	}
	
	override toString() {
		return "Metamodel for namespaces: " + nsURIs;
	}
	
}
