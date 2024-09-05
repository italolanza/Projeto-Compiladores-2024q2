package io.compiler.types;

public class Var {
	
	private String id;
	private Types type;
	private boolean isInitialized;
	private double value;
	
	
	public Var(String id, Types type, double value) {
		super();
		this.id = id;
		this.type = type;
		this.value = value;
		this.isInitialized = true;
	}
	
	public Var(String id, Types type) {
		super();
		this.id = id;
		this.type = type;
		this.isInitialized = false;
	}
	
	public Var(String id) {
		super();
		this.id = id;
		this.isInitialized = false;
	}
	
	public Var() {
		super();
		this.isInitialized = false;
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return "VAR [id= " + this.id + ", type= " + this.type + ", value= " + this.value + ", isInitialized= " + this.isInitialized + "]";
	}
	
	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	
	public Types getType() {
		return type;
	}
	
	public void setType(Types type) {
		this.type = type;
	}
	
	public boolean isInitialized() {
		return isInitialized;
	}
	
	public void setInitialized(boolean isInitialized) {
		this.isInitialized = isInitialized;
	}

	public double getValue() {
		return value;
	}

	public void setValue(double value) {
		this.value = value;
		setInitialized(true);
	}
}
