package io.compiler.core;

import io.compiler.types.Var;

public class AssignmentCommand extends AbstractCommand {
	
	private Var var;
	String expression;

	public AssignmentCommand() {
		super();
	}
	
	public AssignmentCommand(Var var) {
		super();
		this.var = var;
	}
	
	public AssignmentCommand(Var var, String expression) {
		super();
		this.var = var;
		this.expression = expression;
	}

	@Override
	public String generateTarget() {
		
		StringBuilder str = new StringBuilder();
		
		str.append("    ");
		str.append(var.getId());
		str.append(" = ");
		str.append(expression);
		str.append(" ;\n");
		
		return str.toString();
	}

	
	public Var getVar() {
		return var;
	}

	public void setVar(Var var) {
		this.var = var;
	}

	public String getExpression() {
		return expression;
	}

	public void setExpression(String expression) {
		this.expression = expression;
	}

//	@Override
//	public void execute() {
//		// TODO Auto-generated method stub
//		
//	}
}
