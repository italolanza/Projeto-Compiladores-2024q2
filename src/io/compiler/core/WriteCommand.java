package io.compiler.core;

public class WriteCommand extends AbstractCommand {

	private String content;

	
	public WriteCommand() {
		super();
	}
	
	public WriteCommand(String content) {
		super();
		this.content = content;
	}
	
	@Override
	public String generateTarget() {
		return "System.out.println(" + content + ");\n";
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

}
