package io.compiler.core;

import java.util.List;

public class IFCommand extends AbstractCommand {

	private String expression;
	private List<AbstractCommand> trueList;
	private List<AbstractCommand> falseList;
	
	
	public IFCommand() {
		super();
	}
	
	public IFCommand(String expression, List<AbstractCommand> trueList, List<AbstractCommand> falseList) {
		super();
		this.expression = expression;
		this.trueList = trueList;
		this.falseList = falseList;
	}

	@Override
	public String generateTarget() {
		
		StringBuilder str = new StringBuilder();
		str.append("    if (" + expression + ") {\n");
		for (AbstractCommand cmd: trueList) {
			str.append("    ");
			str.append(cmd.generateTarget());
		}
		str.append("    }\n");
		
		if (falseList != null) {
			if(!falseList.isEmpty() ) {
				str.append("    else {\n");
				for (AbstractCommand cmd: falseList) {
					str.append("    ");
					str.append(cmd.generateTarget());
				}
				str.append("    }\n");
			}
		}
		
		return str.toString();
	}


	public String getExpression() {
		return expression;
	}

	public void setExpression(String expression) {
		this.expression = expression;
	}

	public List<AbstractCommand> getTrueList() {
		return trueList;
	}

	public void setTrueList(List<AbstractCommand> trueList) {
		this.trueList = trueList;
	}
	
	public List<AbstractCommand> getFalseList() {
		return falseList;
	}

	public void setFalseList(List<AbstractCommand> falseList) {
		this.falseList = falseList;
	}

	// @Override
	// public void execute() {
	// 	// TODO Auto-generated method stub
		
	// }

}
