package io.compiler.expression;

import io.compiler.exceptions.ExpressionException;
import io.compiler.types.Types;

public class BinaryExpression extends AbstractExpression {
	
	private char operation;
	private AbstractExpression left;
	private AbstractExpression right;
	
	
	public BinaryExpression(char operation, AbstractExpression left, AbstractExpression right) {
		super();
		this.operation = operation;
		this.left = left;
		this.right = right;
	}
	
	public BinaryExpression(char operation) {
		super();
		this.operation = operation;
	}
	
	public BinaryExpression() {
		super();
	}
	
	@Override
	public double evaluate() {
		if ((left.evaluateType() == Types.INTEGER || left.evaluateType() == Types.REALNUMBER)
			&& (right.evaluateType() == Types.INTEGER || right.evaluateType() == Types.REALNUMBER))
		{
			switch(this.operation) {
			case '+':
				return left.evaluate() + right.evaluate();
			case '-':
				return left.evaluate() - right.evaluate();
			case '*':
				return left.evaluate() * right.evaluate();
			case '/':
				return left.evaluate() / right.evaluate();
			default:
				return 0;			
			}
		}
		return 0;
	}
	
	@Override
	public Types evaluateType() {	
		Types leftType = left.evaluateType();
		Types rightType = right.evaluateType();

		if (leftType == Types.TEXT || rightType == Types.TEXT ) {
    		throw new ExpressionException("Operator type mismatching. Trying to operate with a text type!");
		}
		else if (leftType == Types.REALNUMBER ||  rightType == Types.REALNUMBER ) {
			return Types.REALNUMBER;
		}
		// ambos os lados da expressao sao do tipo INTEGER
		else {
			if ((this.operation == '/') && (this.left.evaluate() % this.right.evaluate() != 0)) {
				return Types.REALNUMBER;
			}	
			else {
				return Types.INTEGER;
			}
		}
	}

	@Override
	public String toJson() {
		return "{ \"operation\": \"" + this.operation + "\"," 
					+ "\"left\": " + left.toJson() + ","
					+ "\"right\": " + right.toJson()
			 + "}";
	}
	
	@Override
	public String toString() {
		return "EXPRESSION [OP= " + this.operation + ", leftTerm= " + this.left + ", rightTerm= " + this.right + "]";
	}
	
	public char getOperation() {
		return operation;
	}
	public void setOperation(char operation) {
		this.operation = operation;
	}
	public AbstractExpression getLeft() {
		return left;
	}
	public void setLeft(AbstractExpression left) {
		this.left = left;
	}
	public AbstractExpression getRight() {
		return right;
	}
	public void setRight(AbstractExpression right) {
		this.right = right;
	}
	
}
