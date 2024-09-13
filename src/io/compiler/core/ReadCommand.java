package io.compiler.core;

import io.compiler.types.Types;
import io.compiler.types.Var;

public class ReadCommand extends AbstractCommand {

	private Var var;
	
	
	public ReadCommand() {
		super();
	}
	
	public ReadCommand(Var var) {
		super();
		this.var = var;
	}

	@Override
	public String generateTarget() {
		StringBuilder str = new StringBuilder();
		
		str.append(this.var.getId());
		str.append(" = ");
		
		switch (this.var.getType()) {
		case Types.INTEGER:
			str.append("scanner.nextInt();");
			break;
		case Types.REALNUMBER:
			str.append("scanner.nextDouble();");
			break;
		default:
			str.append("scanner.nextLine();");
		}		
		
		str.append("\n");
		
		return str.toString();
	}

	public Var getVar() {
		return var;
	}

	public void setVar(Var var) {
		this.var = var;
	}

	// @Override
	// public void execute() {
	// 	// TODO Auto-generated method stub
		
	// }

}
