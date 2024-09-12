package io.compiler.runtime;

import java.util.ArrayList;

import io.compiler.core.AbstractCommand;

public class CommandDoWhile extends AbstractCommand {

    private AbstractExpression condition;
    private ArrayList<AbstractCommand> loopCommands;

    public CommandDoWhile(AbstractExpression condition, ArrayList<AbstractCommand> loopCommands) {
        this.condition = condition;
        this.loopCommands = loopCommands;
    }

    @Override
    public void execute() {
        do {
            for (AbstractCommand cmd : loopCommands) {
                cmd.execute();
            }
        } while (condition.evaluate() != 0); // assume 0 como falso
    }

    @Override
    public String generateTarget() {
        StringBuilder str = new StringBuilder();
        str.append("do {\n");
        for (AbstractCommand cmd : loopCommands) {
            str.append(cmd.generateTarget());
        }
        str.append("} while (" + condition.toString() + ");\n");
        return str.toString();
    }
}
