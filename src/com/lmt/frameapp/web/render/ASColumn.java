/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.render;

import com.lmt.baseapp.util.StringFunction;

public class ASColumn implements Cloneable {

	public ASColumn(String sName) {
		setAttribute("Name", sName);
	}

	public ASColumn(String sName, String sActualName, String sTableName) {
		setAttribute("Name", sName);
		setAttribute("ActualName", sActualName);
		setAttribute("TableName", sTableName);
	}

	public boolean setAttribute(String sAttributeName, String sAttributeValue) {
		return StringFunction.setAttribute(Attributes, sAttributeName,
				sAttributeValue);
	}

	public String getAttribute(String sAttributeName) {
		return StringFunction.getAttribute(Attributes, sAttributeName);
	}

	public boolean setEvent(String sEventName, String sEventScript) {
		return StringFunction.setAttribute(Events, sEventName, sEventScript);
	}

	public String getEvent(String sEventName) {
		return StringFunction.getAttribute(Events, sEventName);
	}

	public String getItemName() {
		return getAttribute("Name");
	}

	public String getItemType() {
		return getAttribute("Type");
	}

	public String getItemValue() {
		String sValue = getAttribute("Value");
		return sValue;
	}

	public String getDBName() throws Exception {
		String DBName = "";
		String Name = getAttribute("Name");
		String ActualName = getAttribute("ActualName");
		String TableName = getAttribute("TableName");
		if (TableName != null && !TableName.equals(""))
			DBName = (new StringBuilder()).append(TableName).append(".")
					.toString();
		if (ActualName != null && !ActualName.equals(""))
			DBName = (new StringBuilder()).append(DBName).append(ActualName)
					.toString();
		else
			DBName = (new StringBuilder()).append(DBName).append(Name)
					.toString();
		return DBName;
	}

	public String getActualName() {
		String Name = getAttribute("Name");
		String ActualName = getAttribute("ActualName");
		if (!ActualName.equals(""))
			return ActualName;
		else
			return Name;
	}

	private String Attributes[][] = { { "Name", "" }, { "ActualName", "" },
			{ "TableName", "" }, { "Index", "" }, { "Type", "String" },
			{ "Value", "" }, { "DefaultValue", "" }, { "Header", "" },
			{ "ColumnType", "1" }, { "DisplayFormat", "" },
			{ "CheckFormat", "1" }, { "Align", "1" }, { "EditStyle", "1" },
			{ "EditSource", "" }, { "HTMLStyle", "" }, { "TabOrder", "" },
			{ "Limit", "0" }, { "Key", "0" }, { "Updateable", "1" },
			{ "Visible", "1" }, { "ReadOnly", "0" }, { "Required", "0" },
			{ "Sortable", "1" }, { "CheckItem", "1" }, { "Modifyed", "" },
			{ "Event", "" }, { "Group", "0" }, { "Unit", "" },
			{ "TransferBack", "" }, { "IsFilter", "" },
			{ "FilterOptions", "" }, { "DockOptions", "" },
			{ "AuditColumn", "0" }, { "Auditable", "0" } };
	private String Events[][] = { { "OnClick", "" }, { "OnDoubleClick", "" },
			{ "OnBlur", "" }, { "OnChange", "" }, { "OnKeyUp", "" },
			{ "OnKeyDown", "" } };
}
