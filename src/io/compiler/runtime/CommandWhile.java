package io.compiler.runtime;

import java.util.ArrayList;

import io.compiler.core.AbstractCommand;

public class CommandWhile extends AbstractCommand {

    private AbstractExpression condition;
    private ArrayList<AbstractCommand> loopCommands;

    public CommandWhile(AbstractExpression condition, ArrayList<AbstractCommand> loopCommands) {
        this.condition = condition;
        this.loopCommands = loopCommands;
    }

    @Override
    public void execute() {
        while (condition.evaluate() != 0) { // assume 0 como falso
            for (AbstractCommand cmd : loopCommands) {
                cmd.execute();
            }
        }
    }

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
}
