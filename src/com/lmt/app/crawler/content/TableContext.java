package com.lmt.app.crawler.content;


import java.util.List;

//table中的内容
public class TableContext {
	private List linkList;
	private StringBuffer textBuffer;
	private int tableRow;
	private int totalRow;
	private String sign;

	public String getSign() {
		return sign;
	}

	public void setSign(String sign) {
		this.sign = sign;
	}

	public int getTotalRow() {
		return totalRow;
	}

	public void setTotalRow(int totalRow) {
		this.totalRow = totalRow;
	}

	public int getTableRow() {
		return tableRow;
	}

	public void setTableRow(int tableRow) {
		this.tableRow = tableRow;
	}

	public List getLinkList() {
		return linkList;
	}

	public void setLinkList(List linkList) {
		this.linkList = linkList;
	}

	public StringBuffer getTextBuffer() {
		return textBuffer;
	}

	public void setTextBuffer(StringBuffer textBuffer) {
		this.textBuffer = textBuffer;
	}
}
