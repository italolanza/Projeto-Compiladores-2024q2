package io.compiler.runtime;

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
		// TODO Auto-generated method stub
		
		switch (this.operation) {
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

	@Override
	public String toJson() {
		// TODO Auto-generated method stub
		return "{ \"operation\": \"" + this.operation + "\"," 
					+ "\"left\": " + left.toJson() + ","
					+ "\"right\": " + right.toJson()
			 + "}";
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
