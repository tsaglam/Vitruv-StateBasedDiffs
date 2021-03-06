/*
 * generated by Xtext 2.12.0
 */
package tools.vitruv.dsls.mirbase.ide

import com.google.inject.Guice
import org.eclipse.xtext.util.Modules2
import tools.vitruv.dsls.mirbase.MirBaseRuntimeModule
import tools.vitruv.dsls.mirbase.MirBaseStandaloneSetup

/**
 * Initialization support for running Xtext languages as language servers.
 */
class MirBaseIdeSetup extends MirBaseStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new MirBaseRuntimeModule, new MirBaseIdeModule))
	}
	
}
