package edu.kit.ipd.sdq.vitruvius.tests.mockup;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.eclipse.emf.ecore.EObject;
import org.junit.Test;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.ModelInstance;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.VURI;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces.user.DefaultTUIDCalculatorAndResolver;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces.user.TUIDCalculatorAndResolver;
import edu.kit.ipd.sdq.vitruvius.framework.util.VitruviusConstants;
import edu.kit.ipd.sdq.vitruvius.framework.vsum.VSUMImpl;

public class DefaultTUIDCalculatorTest extends VSUMTest {
    @Override
    @Test
    public void testAll() {
        VSUMImpl vsum = testMetaRepositoryVSUMAndModelInstancesCreation();
        VURI model1URI = VURI.getInstance(PCM_INSTANCE_URI);
        ModelInstance model1 = vsum.getModelInstanceOriginal(model1URI);
        EObject pcmRoot = model1.getResource().getContents().get(0);
        VURI vURI = testTUIDCalculator(pcmRoot);
        assertEquals(vURI.toString(), VitruviusConstants.getPlatformResourcePrefix() + PCM_INSTANCE_URI);
    }

    public VURI testTUIDCalculator(final EObject eObject) {
        TUIDCalculatorAndResolver defaultTUIDCalculatorAndResolver = new DefaultTUIDCalculatorAndResolver();
        String tuid = defaultTUIDCalculatorAndResolver.getTUID(eObject);
        assertNotNull(tuid);
        VURI vURI = defaultTUIDCalculatorAndResolver.getModelVURIContainingIdentifiedEObject(tuid);
        assertNotNull(vURI);
        return vURI;
    }
}
