package io.compiler.core;

import java.util.ArrayList;
import java.util.HashMap;

import io.compiler.types.Var;

public class Program {
	
	private String name;
	private HashMap<String, Var> symbolTable = new HashMap<String, Var>();
	private ArrayList<AbstractCommand> commandList = new ArrayList<AbstractCommand>();
	
	public void generateTarget() {
		
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
