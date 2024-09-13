package io.compiler.main;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import io.compiler.antlr.PjLangLexer;
import io.compiler.antlr.PjLangParser;
import io.compiler.core.Program;

public class MainClass {

	public static void main(String[] args) {
		try {
			PjLangLexer  lexer;
			PjLangParser parser;
			
			lexer = new PjLangLexer(CharStreams.fromFileName("input/test-general.in")); 
 			CommonTokenStream tokenStream = new CommonTokenStream(lexer);
 			parser = new PjLangParser(tokenStream);
 			//parser.setTrace(true);
 			
 			System.out.println("Starting Expression Analysis");
 			parser.program();
 			System.out.println("Analisys Finished!" ); 			
 			//parser.printDeclaredVariables();
// 			System.out.println(parser.gerenateExpressionTreeJSON());
 			
 			Program prog = parser.getProgram();
 			
 			// TODO: Adicionar verificacao do uso de variaveis
 			
 			// debug
 			System.out.println(prog.generateTarget());
 			
// 			try {
//				File f = new File(prog.getName() + ".java");
//				FileWriter fr = new FileWriter(f);
//				PrintWriter pr = new PrintWriter(fr);
//				
//				pr.println(prog.generateTarget());
//				pr.close();
//				
//			} catch (IOException ex) {
//				ex.printStackTrace();
//			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}
	
	}

}
