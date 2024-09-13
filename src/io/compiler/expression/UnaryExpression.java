package io.compiler.expression;

import io.compiler.types.Types;

public class UnaryExpression extends AbstractExpression {

	private Object value;
	private Types type;
	
		public UnaryExpression() {
		super();
	}

	public UnaryExpression(Object value) {
		super();
		this.value = value;
	}
	
	public UnaryExpression(Object value, Types valueType) {
		super();
		this.value = value;
		this.type = valueType;
	}
	
	@Override
	public double evaluate() {
		switch(this.type) {
			case INTEGER:
				return (double) this.value;
			case REALNUMBER:
				return (double) this.value;
			case TEXT:
			default:
				//TODO: Throw exception???
				return 0;
			}
	}
	
	@Override
	public Types evaluateType() {
		return this.type;
	}

	@Override
	public String toJson() {
		return "{\"value\": " + this.toString() + "}";
	}

	@Override
	public String toString() {
		switch(this.type) {
			case INTEGER:
			case REALNUMBER:
				return Double.toString((double)this.value);
			case TEXT:
				return (String)this.value;
			default:
				return "<UNKOWN_TYPE>";
			}
	}
	public Object getValue() {
		return value;
	}

	public void setValue(Object value) {
		this.value = value;
	}
	
	public Types getType() {
		return type;
	}

	public void setType(Types type) {
		this.type = type;
	}

}
