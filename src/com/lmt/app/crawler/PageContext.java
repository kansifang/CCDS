package com.lmt.app.crawler;



import org.htmlparser.Node;

//Ò³ÃæÄÚÈÝ
public class PageContext {
	private String title;
	private String time;
	private StringBuffer textBuffer;
	private int number;
	private Node node;

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public Node getNode() {
		return node;
	}

	public void setNode(Node node) {
		this.node = node;
	}

	public int getNumber() {
		return number;
	}

	public void setNumber(int number) {
		this.number = number;
	}

	public StringBuffer getTextBuffer() {
		return textBuffer;
	}

	public void setTextBuffer(StringBuffer textBuffer) {
		this.textBuffer = textBuffer;
	}
}
