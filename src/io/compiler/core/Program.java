package io.compiler.core;

import java.util.ArrayList;
import java.util.HashMap;

import io.compiler.types.Types;
import io.compiler.types.Var;

public class Program {
	
	private String name;
	private HashMap<String, Var> symbolTable = new HashMap<String, Var>();
	private ArrayList<AbstractCommand> commandList = new ArrayList<AbstractCommand>();
	
	public String generateTarget() {

		StringBuilder str = new StringBuilder();

		// adiciona/gera cabecalho do programa
		str.append("import java.util.Scanner;\n");
		str.append("public class " + name + "{\n");
		str.append("    public static void main(String args[]) {\n");
		str.append("    Scanner scanner = new Scanner(System.in);\n");

		// adiciona/gera declaracao das variaveis
		for(String varID: symbolTable.keySet()) {
			Var var = symbolTable.get(varID);

			if (var.getType() == Types.INTEGER) {
				str.append("    int ");
			}
			else if (var.getType() == Types.INTEGER) {
				str.append("    double ");
			}
			else {
				str.append("    String ");
			}

			str.append(var.getId() + ";\n");
		}

		// adiciona/gera todos os comados
		for (AbstractCommand cmd: commandList) {
			str.append(cmd.generateTarget());
		}

		// fim
		str.append("    }\n");
		str.append("}");
		

		return str.toString();
	}
	
	
	public HashMap<String, Var> getSymbolTable() {
		return symbolTable;
	}

	public void setSymbolTable(HashMap<String, Var> symbolTable) {
		this.symbolTable = symbolTable;
	}

	public ArrayList<AbstractCommand> getCommandList() {
		return commandList;
	}

	public void setCommandList(ArrayList<AbstractCommand> commandList) {
		this.commandList = commandList;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	
}
