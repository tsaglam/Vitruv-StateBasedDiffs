/*
 * generated by Xtext
 */
package tools.vitruv.domains.jml.language.parser.antlr;

import java.io.InputStream;
import org.eclipse.xtext.parser.antlr.IAntlrTokenFileProvider;

public class JMLAntlrTokenFileProvider implements IAntlrTokenFileProvider {
	
	@Override
	public InputStream getAntlrTokenFile() {
		ClassLoader classLoader = getClass().getClassLoader();
    	return classLoader.getResourceAsStream("tools.vitruv/domains/jml/language/parser/antlr/internal/InternalJML.tokens");
	}
}