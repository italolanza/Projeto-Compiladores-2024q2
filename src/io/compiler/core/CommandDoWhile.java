package io.compiler.core;

import java.util.List;

public class CommandDoWhile extends AbstractCommand {

	private String condition;
    private List<AbstractCommand> loopCommands;

    
    public CommandDoWhile() {
    	super();
    }
    
    public CommandDoWhile(String condition, List<AbstractCommand> loopCommands) {
    	super();
    	this.condition = condition;
        this.loopCommands = loopCommands;
    }

    // @Override
    // public void execute() {
    //     do {
    //         for (AbstractCommand cmd : loopCommands) {
    //             cmd.execute();
    //         }
    //     } while (condition.evaluate() != 0); // assume 0 como falso
    // }

    @Override
    public String generateTarget() {
        StringBuilder str = new StringBuilder();
        str.append("do {\n");
        for (AbstractCommand cmd : loopCommands) {
            str.append(cmd.generateTarget());
        }
        str.append("} while (" + condition + ");\n");
        return str.toString();
    }
    
    public String getCondition() {
		return condition;
	}

	public void setCondition(String condition) {
		this.condition = condition;
	}

	public List<AbstractCommand> getLoopCommands() {
		return loopCommands;
	}

	public void setLoopCommands(List<AbstractCommand> loopCommands) {
		this.loopCommands = loopCommands;
	}

}
