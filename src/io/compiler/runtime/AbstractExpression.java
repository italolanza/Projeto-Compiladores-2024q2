package io.compiler.runtime;

import io.compiler.types.Types;

public abstract class AbstractExpression {
	public abstract double evaluate(); // evaluate the value of expressions (math)
	public abstract Types evaluateType(); // evaluate the expression type
	public abstract String toJson();
}
