package io.compiler.runtime;

public class UnaryExpression extends AbstractExpression {

	private double value;
	
	
	public UnaryExpression() {
		super();
	}

	public UnaryExpression(double value) {
		super();
		this.value = value;
	}
	
	@Override
	public double evaluate() {
		// TODO Auto-generated method stub
		return value;
	}

	@Override
	public String toJson() {
		// TODO Auto-generated method stub
		return "{\"value\": " + this.value + "}";
	}

	public double getValue() {
		return value;
	}

	public void setValue(double value) {
		this.value = value;
	}

}
