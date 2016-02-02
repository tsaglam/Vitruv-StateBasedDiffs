/*
 * generated by Xtext 2.10.0-SNAPSHOT
 */
package edu.kit.ipd.sdq.vitruvius.dsls.ui;

import com.google.inject.Injector;
import edu.kit.ipd.sdq.vitruvius.dsls.mirbase.ui.internal.MirbaseActivator;
import org.eclipse.xtext.ui.guice.AbstractGuiceAwareExecutableExtensionFactory;
import org.osgi.framework.Bundle;

/**
 * This class was generated. Customizations should only happen in a newly
 * introduced subclass. 
 */
public class MirBaseExecutableExtensionFactory extends AbstractGuiceAwareExecutableExtensionFactory {

	@Override
	protected Bundle getBundle() {
		return MirbaseActivator.getInstance().getBundle();
	}
	
	@Override
	protected Injector getInjector() {
		return MirbaseActivator.getInstance().getInjector(MirbaseActivator.EDU_KIT_IPD_SDQ_VITRUVIUS_DSLS_MIRBASE);
	}
	
}
