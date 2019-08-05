package tools.vitruv.dsls.commonalities.ui.tests.attributeoperators

import com.google.inject.Singleton
import tools.vitruv.dsls.commonalities.testutils.ExecutionTestCompiler

@Singleton
class AttributeMappingOperatorTestCompiler extends ExecutionTestCompiler {

	static val TEST_PROJECT_NAME = 'commonalities-test-attribute-mapping-operator'
	static val COMMONALITY_FILES = #['Identified.commonality']
	static val DOMAIN_DEPENDENCIES = #[
		'tools.vitruv.testutils.domains',
		'tools.vitruv.testutils.metamodels',
		'tools.vitruv.dsls.commonalities.testutils'
	]

	override protected getProjectName() {
		return TEST_PROJECT_NAME
	}

	override protected getCommonalityFiles() {
		return COMMONALITY_FILES
	}

	override protected getDomainDependencies() {
		return DOMAIN_DEPENDENCIES
	}
}