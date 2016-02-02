/*
 * generated by Xtext 2.10.0-SNAPSHOT
 */
package edu.kit.ipd.sdq.vitruvius.dsls.parser.antlr;

import com.google.inject.Inject;
import edu.kit.ipd.sdq.vitruvius.dsls.parser.antlr.internal.InternalMirBaseParser;
import edu.kit.ipd.sdq.vitruvius.dsls.services.MirBaseGrammarAccess;
import org.eclipse.xtext.parser.antlr.AbstractAntlrParser;
import org.eclipse.xtext.parser.antlr.XtextTokenStream;

public class MirBaseParser extends AbstractAntlrParser {

	@Inject
	private MirBaseGrammarAccess grammarAccess;

	@Override
	protected void setInitialHiddenTokens(XtextTokenStream tokenStream) {
		tokenStream.setInitialHiddenTokens("RULE_WS", "RULE_SL_COMMENT");
	}
	

	@Override
	protected InternalMirBaseParser createParser(XtextTokenStream stream) {
		return new InternalMirBaseParser(stream, getGrammarAccess());
	}

	@Override 
	protected String getDefaultRuleName() {
		return "MetamodelImport";
	}

	public MirBaseGrammarAccess getGrammarAccess() {
		return this.grammarAccess;
	}

	public void setGrammarAccess(MirBaseGrammarAccess grammarAccess) {
		this.grammarAccess = grammarAccess;
	}
}
