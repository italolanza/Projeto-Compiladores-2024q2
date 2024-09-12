package io.compiler.runtime;

import java.util.ArrayList;

import io.compiler.core.AbstractCommand;

public class CommandIf extends AbstractCommand {

    private AbstractExpression condition;
    private ArrayList<AbstractCommand> ifCommands;
    private ArrayList<AbstractCommand> elseCommands;

    public CommandIf(AbstractExpression condition, ArrayList<AbstractCommand> ifCommands, ArrayList<AbstractCommand> elseCommands) {
        this.condition = condition;
        this.ifCommands = ifCommands;
        this.elseCommands = elseCommands;
    }
    
    @Override
    public String generateTarget() {
        StringBuilder str = new StringBuilder();
        str.append("if (" + condition.toString() + ") {\n");
        for (AbstractCommand cmd : ifCommands) {
            str.append(cmd.generateTarget());
        }
        str.append("}\n");

        if (elseCommands != null) {
            str.append("else {\n");
            for (AbstractCommand cmd : elseCommands) {
                str.append(cmd.generateTarget());
            }
            str.append("}\n");
        }
        return str.toString();
    }


    @Override
    public void execute() {
        if (condition.evaluate() != 0) {
            for (AbstractCommand cmd : ifCommands) {
                cmd.execute();
            }
        } else {
            if (elseCommands != null) {
                for (AbstractCommand cmd : elseCommands) {
                    cmd.execute();
                }
            }
        }
    }

    @Override
    public String toString() {
        return "If(" + condition + ")";
    }
}
