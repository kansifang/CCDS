/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.ui;

public class TreeViewItem {

	public TreeViewItem(String sID, String sParentID, String sType,
			String sName, String sValue, String sScript, int iOrder,
			String sPicture) {
		id = sID;
		parentID = sParentID;
		order = iOrder;
		type = sType;
		name = sName;
		value = sValue;
		script = sScript;
		picture = sPicture;
	}

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getParentID() {
		return parentID;
	}

	public void setParentID(String parentID) {
		this.parentID = parentID;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getScript() {
		return script;
	}

	public void setScript(String script) {
		this.script = script;
	}

	public String getPicture() {
		return picture;
	}

	public void setPicture(String picture) {
		this.picture = picture;
	}

	private int order;
	private String id;
	private String parentID;
	private String type;
	private String name;
	private String value;
	private String script;
	private String picture;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 172 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/