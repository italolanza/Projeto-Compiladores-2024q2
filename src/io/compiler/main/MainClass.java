package io.compiler.main;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import io.compiler.core.PjLangLexer;
import io.compiler.core.PjLangParser;

public class MainClass {

	public static void main(String[] args) {
		try {
			PjLangLexer  lexer;
			PjLangParser parser;
			
			lexer = new PjLangLexer(CharStreams.fromFileName("input/test-expressions.in")); 
 			CommonTokenStream tokenStream = new CommonTokenStream(lexer);
 			parser = new PjLangParser(tokenStream);
// 			parser.setTrace(true);
 			
 			System.out.println("Starting Expression Analysis");
 			parser.program();
 			System.out.println("Analisys Finished!" ); 			
 			parser.printDeclaredVariables();
// 			System.out.println(parser.gerenateExpressionTreeJSON());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	
	}

}
