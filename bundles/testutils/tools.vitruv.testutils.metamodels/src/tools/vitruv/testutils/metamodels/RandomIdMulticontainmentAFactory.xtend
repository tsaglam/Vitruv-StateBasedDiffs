package tools.vitruv.testutils.metamodels

import multicontainment_a.Identified
import multicontainment_a.impl.Multicontainment_aFactoryImpl
import tools.vitruv.testutils.activeannotations.WithGeneratedRandomIds

@WithGeneratedRandomIds(identifierMetaclass=Identified)
class RandomIdMulticontainmentAFactory extends Multicontainment_aFactoryImpl {
}
