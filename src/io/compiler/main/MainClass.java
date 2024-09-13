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

	final static private String INPUT_FOLDER = "input";
	final static private String DEFAULT_FILE = "test-general.in";
	
	public static void main(String[] args) {
		
		String INPUT_FILE_PATH = INPUT_FOLDER + File.separatorChar + DEFAULT_FILE;
		
		try {
			PjLangLexer  lexer;
			PjLangParser parser;
					
			lexer = new PjLangLexer(CharStreams.fromFileName(INPUT_FILE_PATH)); 
 			CommonTokenStream tokenStream = new CommonTokenStream(lexer);
 			parser = new PjLangParser(tokenStream);
 			//parser.setTrace(true);
 			
 			System.out.println("Starting Code Analysis");
 			parser.program();
 			
			// Chama a verificação de variáveis não usadas
			parser.checkUnusedVariables();
 			System.out.println("Analisys Finished!" );
 			
 			Program prog = parser.getProgram();
			// debug
 			// System.out.println(prog.generateTarget());
 			
 			// cria arquivo
 			try {
				File f = new File(prog.getName() + ".java");
				FileWriter fr = new FileWriter(f);
				PrintWriter pr = new PrintWriter(fr);
				
				pr.println(prog.generateTarget());
				pr.close();
				
			} catch (IOException ex) {
				ex.printStackTrace();
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}
	
	}

}
