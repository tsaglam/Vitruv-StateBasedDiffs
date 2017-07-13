package tools.vitruv.framework.vsum.ui;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Tree;
import org.eclipse.swt.widgets.TreeItem;

import tools.vitruv.framework.domains.VitruvDomain;
import tools.vitruv.framework.domains.VitruvDomainProvider;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

public class DomainSelectionPage extends WizardPage {

	private static final String PAGENAME = "Vitruvius Project";
	private static final String DESCRIPTION = "Create a new Vitruvius Project.";
	private HashMap<IProject, HashSet<VitruvDomain>> selectedDomainsForProjects;

	private Composite container;

	protected DomainSelectionPage() {
		super(PAGENAME);
		setTitle(PAGENAME);
		setDescription(DESCRIPTION);
		this.selectedDomainsForProjects = new HashMap<>();
	}

	@Override
	public void createControl(Composite parent) {
		container = new Composite(parent, SWT.NONE);
		GridLayout layout = new GridLayout();
		container.setLayout(layout);
		layout.numColumns = 1;
		Label label1 = new Label(container, SWT.NONE);
		label1.setText("Select the Project and a required domain.");

		IProject projects[] = getProjects();

		final Tree tree = new Tree(container, SWT.CHECK | SWT.BORDER | SWT.V_SCROLL | SWT.H_SCROLL);

		GridData treeGridData = new GridData(GridData.FILL_BOTH);
		tree.setLayoutData(treeGridData);

		Iterable<VitruvDomainProvider<?>> domainProviders = VitruvDomainProvider.getAllDomainProvidersFromExtensionPoint();

		for (IProject project : projects) {
			TreeItem t = new TreeItem(tree, SWT.CHECK);
			t.setText(project.getName());
			t.setData(project);
			selectedDomainsForProjects.put(project, new HashSet<>());
			for (VitruvDomainProvider<?> provider : domainProviders) {
				TreeItem childItem = new TreeItem(t, SWT.CHECK);
				childItem.setText(provider.getDomain().getName());
				childItem.setData(provider.getDomain());
			}
		}

		tree.addListener(SWT.Selection, new Listener() {
			public void handleEvent(Event event) {
				if (event.detail == SWT.CHECK) {
					TreeItem item = (TreeItem) event.item;
					TreeItem parent = item.getParentItem();
					if (item.getChecked()) {
						// check a project automatically, when one of it's
						// domains is checked
						if (null != parent) {
							parent.setChecked(true);
							selectedDomainsForProjects.get(parent.getData()).add((VitruvDomain) item.getData());
						}
					} else {
						// all domains get deselected, when project is
						// deselected.
						if (null == parent) {
							for (TreeItem child : item.getItems()) {
								child.setChecked(false);
								selectedDomainsForProjects.get(item.getData()).remove(child.getData());
							}
						} else {
							selectedDomainsForProjects.get(parent.getData()).remove(item.getData());
						}
					}
					// only finish if something is checked.
					boolean finished = false;
					for (TreeItem treeItem : tree.getItems()) {
						finished = finished || treeItem.getChecked();
					}
					setPageComplete(finished);
				}
			}
		});

		setControl(container);
		setPageComplete(false);
	}

	/**
	 * Returns a HashMap of Projects, where every project is mapped to all of
	 * it's selected domains, respectively.
	 * 
	 * @return a HashMap that maps all project to their checked domains,
	 *         respectively
	 */
	public HashMap<IProject, HashSet<VitruvDomain>> getCheckedDomains() {
		return selectedDomainsForProjects;
	}

	private IProject[] getProjects() {
		return ResourcesPlugin.getWorkspace().getRoot().getProjects();
	}

	Iterable<VitruvDomain> getSelectedDomains() {
		Set<VitruvDomain> domains = new HashSet<>();
		for (Set<VitruvDomain> domainSet : selectedDomainsForProjects.values()) {
			for (VitruvDomain domain : domainSet) {
				domains.add(domain);
			}
		}
		return domains;
	}

}
