package io.compiler.core;

import java.util.List;

public class CommandWhile extends AbstractCommand {

    private String condition;
    private List<AbstractCommand> loopCommands;


    public CommandWhile() {
    	super();
    }
    
	public CommandWhile(String condition, List<AbstractCommand> loopCommands) {
		super();
		this.condition = condition;
        this.loopCommands = loopCommands;
    }

    // @Override
    // public void execute() {
    //     while (condition.evaluate() != 0) { // assume 0 como falso
    //         for (AbstractCommand cmd : loopCommands) {
    //             cmd.execute();
    //         }
    //     }
    // }

    @Override
    public String generateTarget() {
        StringBuilder str = new StringBuilder();
        str.append("while (" + condition.toString() + ") {\n");
        for (AbstractCommand cmd : loopCommands) {
            str.append(cmd.generateTarget());
        }
        str.append("}\n");
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
