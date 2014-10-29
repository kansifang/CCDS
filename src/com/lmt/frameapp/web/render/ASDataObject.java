/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.render;

import java.util.Vector;

import javax.servlet.ServletRequest;

import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

// Referenced classes of package com.amarsoft.web.dw:
//            ASColumn, ASDataObjectFilter

public class ASDataObject implements Cloneable {

	public String getDoNo() {
		if (doNo == null)
			doNo = "";
		return doNo;
	}

	public ASDataObject() {
		SourceSql = "";
		SelectClause = "";
		FromClause = "";
		WhereClause = "";
		GroupClause = "";
		OrderClause = "";
		Arguments = "";
		UpdateTable = "";
		UpdateWhere = "1";
		UpdateKeyInPlace = "1";
		Updateable = "1";
		Columns = new Vector();
		Filters = new Vector();
		multiSelectionEnabled = false;
		receivedFilterData = false;
		KeyFilter = "";
		JoinClause = "";
		AuditTable = null;
		AuditMode = AUDITMODE_NONE;
		AuditUser = "";
		AuditOrg = "";
	}

	public ASDataObject(String sDONo, Transaction transSql) throws Exception {
		SourceSql = "";
		SelectClause = "";
		FromClause = "";
		WhereClause = "";
		GroupClause = "";
		OrderClause = "";
		Arguments = "";
		UpdateTable = "";
		UpdateWhere = "1";
		UpdateKeyInPlace = "1";
		Updateable = "1";
		Columns = new Vector();
		Filters = new Vector();
		multiSelectionEnabled = false;
		receivedFilterData = false;
		KeyFilter = "";
		JoinClause = "";
		AuditTable = null;
		AuditMode = AUDITMODE_NONE;
		AuditUser = "";
		AuditOrg = "";
		doNo = sDONo;
		init(sDONo, "", transSql);
	}

	public ASDataObject(String sDONo, String sWhere, Transaction transSql)
			throws Exception {
		SourceSql = "";
		SelectClause = "";
		FromClause = "";
		WhereClause = "";
		GroupClause = "";
		OrderClause = "";
		Arguments = "";
		UpdateTable = "";
		UpdateWhere = "1";
		UpdateKeyInPlace = "1";
		Updateable = "1";
		Columns = new Vector();
		Filters = new Vector();
		multiSelectionEnabled = false;
		receivedFilterData = false;
		KeyFilter = "";
		JoinClause = "";
		AuditTable = null;
		AuditMode = AUDITMODE_NONE;
		AuditUser = "";
		AuditOrg = "";
		doNo = sDONo;
		init(sDONo, sWhere, transSql);
	}

	public void composeSourceSql(Transaction transSql) throws Exception {
		String sFilterWhereClause = getFilterWhereClause(transSql);
		if (sFilterWhereClause != null && !sFilterWhereClause.equals(""))
			if (WhereClause == null || WhereClause.equals(""))
				WhereClause = (new StringBuilder()).append(" 1=1 ")
						.append(getFilterWhereClause(transSql)).toString();
			else
				WhereClause = (new StringBuilder()).append(WhereClause)
						.append(" and ").append("(").append(sFilterWhereClause)
						.append(")").toString();
		if (multiSelectionEnabled)
			enableMultiSelection();
		SourceSql = (new StringBuilder()).append(SelectClause).append(" ")
				.append(FromClause).append(" ").append(WhereClause).append(" ")
				.append(GroupClause).append(" ").append(OrderClause).toString();
	}

	public void init(String sDONo, String sWhere, Transaction transSql)
			throws Exception {
		String sSelectClause = "";
		String sSql = (new StringBuilder())
				.append("select DATAOBJECT_CATALOG.* from DATAOBJECT_CATALOG where DONo='")
				.append(sDONo).append("' ").toString();
		ASResultSet rs = transSql.getResultSet(sSql);
		if (rs.next()) {
			Arguments = DataConvert.toString(rs.getString("DOArguments"));
			UpdateTable = DataConvert.toString(rs.getString("DOUpdateTable"));
			UpdateWhere = DataConvert.toString(rs.getString("DOUpdateWhere"));
			FromClause = DataConvert.toString(rs.getString("DOFromClause"))
					.trim();
			WhereClause = DataConvert.toString(rs.getString("DOWhereClause"))
					.trim();
			GroupClause = DataConvert.toString(rs.getString("DOGroupClause"))
					.trim();
			OrderClause = DataConvert.toString(rs.getString("DOOrderClause"))
					.trim();
		}
		rs.getStatement().close();
		sSql = (new StringBuilder())
				.append("select DATAOBJECT_LIBRARY.* from DATAOBJECT_LIBRARY where DONo='")
				.append(sDONo).append("'").toString();
		if (sWhere != null && !sWhere.equals(""))
			sSql = (new StringBuilder()).append(sSql).append(" and ")
					.append(sWhere).toString();
		sSql = (new StringBuilder()).append(sSql).append(" order by ColIndex")
				.toString();
		for (rs = transSql.getResultSet(sSql); rs.next();) {
			int iIndex = addColumn(DataConvert
					.toString(rs.getString("ColName")));
			setColumnAttribute(iIndex, "Header",
					DataConvert.toString(rs.getString("ColHeader")));
			setColumnAttribute(iIndex, "Unit",
					DataConvert.toString(rs.getString("ColUnit")));
			setColumnAttribute(iIndex, "TableName",
					DataConvert.toString(rs.getString("ColTableName")));
			setColumnAttribute(iIndex, "ActualName",
					DataConvert.toString(rs.getString("ColActualName")));
			setColumnAttribute(iIndex, "Index",
					DataConvert.toString(rs.getString("ColIndex")));
			setType(iIndex, DataConvert.toString(rs.getString("ColType")));
			setColumnAttribute(iIndex, "DefaultValue",
					DataConvert.toString(rs.getString("ColDefaultValue")));
			setColumnAttribute(iIndex, "ColumnType",
					DataConvert.toString(rs.getString("ColColumnType")));
			setCheckFormat(iIndex,
					DataConvert.toString(rs.getString("ColCheckFormat")));
			setColumnAttribute(iIndex, "Align",
					DataConvert.toString(rs.getString("ColAlign")));
			setColumnAttribute(iIndex, "EditStyle",
					DataConvert.toString(rs.getString("ColEditStyle")));
			setColumnAttribute(
					iIndex,
					"EditSource",
					(new StringBuilder())
							.append(DataConvert.toString(rs
									.getString("ColEditSourceType")))
							.append(":")
							.append(DataConvert.toString(rs
									.getString("ColEditSource"))).toString());
			setColumnAttribute(iIndex, "Limit",
					DataConvert.toString(rs.getString("ColLimit")));
			setColumnAttribute(iIndex, "Key",
					DataConvert.toString(rs.getString("ColKey")));
			setColumnAttribute(iIndex, "Updateable",
					DataConvert.toString(rs.getString("ColUpdateable")));
			setColumnAttribute(iIndex, "Visible",
					DataConvert.toString(rs.getString("ColVisible")));
			setColumnAttribute(iIndex, "Required",
					DataConvert.toString(rs.getString("ColRequired")));
			setColumnAttribute(iIndex, "Sortable",
					DataConvert.toString(rs.getString("ColSortable")));
			setColumnAttribute(iIndex, "CheckItem",
					DataConvert.toString(rs.getString("ColCheckItem")));
			setHTMLStyle(iIndex,
					DataConvert.toString(rs.getString("ColHTMLStyle")));
			setReadOnly(iIndex,
					DataConvert.toString(rs.getString("ColReadOnly")));
			setColumnAttribute(iIndex, "TransferBack",
					DataConvert.toString(rs.getString("ColTransferBack")));
			setColumnAttribute(iIndex, "IsFilter",
					DataConvert.toString(rs.getString("IsFilter")));
			setColumnAttribute(iIndex, "FilterOptions",
					DataConvert.toString(rs.getString("FilterOptions")));
			setColumnAttribute(iIndex, "AuditColumn",
					DataConvert.toString(rs.getString("AuditColumn")));
			setColumnAttribute(iIndex, "Auditable",
					DataConvert.toString(rs.getString("Auditable")));
			String sDockOptions = "";
			try {
				String sDockID = DataConvert.toString(rs.getString("DockID"));
				String sColSpan = DataConvert.toString(rs.getString("ColSpan"));
				String sPositionType = DataConvert.toString(rs
						.getString("PositionType"));
				String sBlankColsAhead = DataConvert.toString(rs
						.getString("BlankColsAhead"));
				String sBlankColsAfter = DataConvert.toString(rs
						.getString("BlankColsAfter"));
				sDockOptions = (new StringBuilder()).append("DockID=")
						.append(sDockID).append(";ColSpan=").append(sColSpan)
						.append(";PositionType=").append(sPositionType)
						.append(";BlankColsAhead=").append(sBlankColsAhead)
						.append(";BlankColsAfter=").append(sBlankColsAfter)
						.toString();
				setColumnAttribute(iIndex, "DockOptions", sDockOptions);
			} catch (Exception ex) {
				ARE.getLog()
						.error("DATAOBJECT_LIBRARY\u8868\u7F3A\u5C11\u5B57\u6BB5\uFF1ADockID\uFF0CColSpan\uFF0CPositionType\uFF0CBlankColsAhead\uFF0CBlankColsAfter\uFF0C\u8BF7\u6DFB\u52A0\u8FD9\u4E9B\u5B57\u6BB5\u3002");
			}
			String sName = getColumnAttribute(iIndex, "Name");
			String sTableName = getColumnAttribute(iIndex, "TableName");
			String sActualName = getColumnAttribute(iIndex, "ActualName");
			if (!sTableName.trim().equals("") && !sActualName.trim().equals(""))
				sSelectClause = (new StringBuilder()).append(sSelectClause)
						.append(sTableName).append(".").append(sActualName)
						.append(" as ").append(sName).append(",").toString();
			else if (!sActualName.trim().equals(""))
				sSelectClause = (new StringBuilder()).append(sSelectClause)
						.append(sActualName).append(" as ").append(sName)
						.append(",").toString();
			else
				sSelectClause = (new StringBuilder()).append(sSelectClause)
						.append(sName).append(",").toString();
		}

		if (!sSelectClause.equals(""))
			sSelectClause = (new StringBuilder())
					.append(" select ")
					.append(sSelectClause.substring(0,
							sSelectClause.length() - 1)).toString();
		SelectClause = sSelectClause;
		composeSourceSql(transSql);
		rs.getStatement().close();
	}

	public ASDataObject(String sSql) throws Exception {
		SourceSql = "";
		SelectClause = "";
		FromClause = "";
		WhereClause = "";
		GroupClause = "";
		OrderClause = "";
		Arguments = "";
		UpdateTable = "";
		UpdateWhere = "1";
		UpdateKeyInPlace = "1";
		Updateable = "1";
		Columns = new Vector();
		Filters = new Vector();
		multiSelectionEnabled = false;
		receivedFilterData = false;
		KeyFilter = "";
		JoinClause = "";
		AuditTable = null;
		AuditMode = AUDITMODE_NONE;
		AuditUser = "";
		AuditOrg = "";
		setSourceSql(sSql);
	}

	public void setSourceSql(String sSql) throws Exception {
		parseSql(sSql);
		parseColumns();
	}

	public String getActualSql(String sArgsValue) {
		return StringFunction.applyArgs(SourceSql, Arguments, sArgsValue);
	}

	public void setKeyFilter(String s1) {
		KeyFilter = s1;
	}

	public void setJoinClause(String s1) {
		JoinClause = s1;
	}

	public String getActualKeySql(String sArgsValue) {
		String sSql = "";
		sSql = (new StringBuilder()).append("select ").append(KeyFilter)
				.append(" ").append(FromClause).append(" ").append(WhereClause)
				.append(" ").append(OrderClause).toString();
		return StringFunction.applyArgs(sSql, Arguments, sArgsValue);
	}

	public String getActualNewSql(String sArgsValue, String sKeyFilterCollect) {
		String sSql = "";
		String sNewWhere = "";
		if (JoinClause.equals("")) {
			if (WhereClause.equals(""))
				sNewWhere = (new StringBuilder()).append(" where ")
						.append(KeyFilter).append(" in (")
						.append(sKeyFilterCollect).append(") ").toString();
			else
				sNewWhere = (new StringBuilder()).append(WhereClause)
						.append(" and ").append(KeyFilter).append(" in (")
						.append(sKeyFilterCollect).append(") ").toString();
		} else {
			sNewWhere = (new StringBuilder()).append(" where ")
					.append(JoinClause).append(" and ").append(KeyFilter)
					.append(" in (").append(sKeyFilterCollect).append(") ")
					.toString();
		}
		sSql = (new StringBuilder()).append(SelectClause).append(" ")
				.append(FromClause).append(" ").append(sNewWhere).append(" ")
				.append(OrderClause).toString();
		return StringFunction.applyArgs(sSql, Arguments, sArgsValue);
	}

	public void parseSql(String sSql) throws Exception {
		sSql = sSql.trim();
		SourceSql = sSql;
		int iPosSelect = StringFunction.indexOf(sSql.toLowerCase(), "select ","'", "'", 0);
		int iPosFrom = StringFunction.indexOf(sSql.toLowerCase(), " from ","'@'~(@)", 0);
		int iPosWhere = StringFunction.indexOf(sSql.toLowerCase(), " where ","(", ")", iPosFrom + 1);
		int iPosGroup = StringFunction.indexOf(sSql.toLowerCase()," group by ", "(", ")", iPosFrom + 1);
		int iPosOrder = StringFunction.indexOf(sSql.toLowerCase()," order by ", "(", ")", iPosFrom + 1);
		if (iPosSelect < 0)
			throw new Exception(
					(new StringBuilder())
							.append("SQL\u8BED\u53E5\u4E2D\u6CA1\u6709\u627E\u5230\u5173\u952E\u5B57\u201Cselect\u201D\u3002SQL\u8BED\u53E5\uFF1A\n")
							.append(sSql).toString());
		SelectClause = sSql.substring(iPosSelect, iPosFrom).trim();
		if (iPosWhere >= 0)
			FromClause = sSql.substring(iPosFrom, iPosWhere);
		else if (iPosGroup >= 0)
			FromClause = sSql.substring(iPosFrom, iPosGroup);
		else if (iPosOrder >= 0)
			FromClause = sSql.substring(iPosFrom, iPosOrder);
		else
			FromClause = sSql.substring(iPosFrom);
		if (iPosWhere >= 0) {
			if (iPosGroup >= 0)
				WhereClause = sSql.substring(iPosWhere, iPosGroup);
			else if (iPosOrder >= 0)
				WhereClause = sSql.substring(iPosWhere, iPosOrder);
			else
				WhereClause = sSql.substring(iPosWhere);
		} else {
			WhereClause = "";
		}
		if (iPosGroup >= 0) {
			if (iPosOrder >= 0)
				GroupClause = sSql.substring(iPosGroup, iPosOrder);
			else
				GroupClause = sSql.substring(iPosGroup);
		} else {
			GroupClause = "";
		}
		if (iPosOrder >= 0)
			OrderClause = sSql.substring(iPosOrder);
		else
			OrderClause = "";
	}

	public void parseColumns() {
		int iPos = 0;
		int iPosComma = 0;
		String sSelect = SelectClause.substring(6).trim();
		do {
			//必须保证","同时不在'' [] ()之间，才认定是Sql查询语句中的字段分隔符","
			//20141009 重构，StringFunction增加一个新的indexOf
			iPosComma = StringFunction.indexOf(sSelect, ",", "'@'~[@]~(@)", iPos);
			String sColumn;
			//识别出了一个Column，下面当然是解析喽
			if (iPosComma >= 0)
				sColumn = sSelect.substring(iPos, iPosComma).trim();
			else
				sColumn = sSelect.substring(iPos).trim();//既然找不到',',只能把整个字符串当成一个 Column
			//解析 表名 字段名，字段别名 。。。。一定要有 as 哦
			int iPosAs = StringFunction.indexOf(sColumn, " as ", "'@'~(@)", 0);
			int iPosDot = StringFunction.indexOf(sColumn, ".", "'", "'", 0);
			String sName;
			String sTableName;
			String sActualName;
			if (iPosAs >= 0) {
				sName = sColumn.substring(iPosAs + 3).trim().replace("\"", "");//这个是字段别名，当然也对应标题名,replace主要是针对别名以数字开头时，SQL语句要求加双引号，这导致，标题带双引号，故在此消除
				if (iPosDot >= 0) {
					sTableName = sColumn.substring(0, iPosDot).trim();//可能是表名也可能是表的别名
					sActualName = sColumn.substring(iPosDot + 1, iPosAs).trim();//这个肯定是字段
				} else {
					sTableName = "";
					sActualName = sColumn.substring(0, iPosAs);
				}
			} else if (iPosDot >= 0) {
				sTableName = sColumn.substring(0, iPosDot).trim();
				sActualName = sColumn.substring(iPosDot + 1).trim();
				sName = sActualName;
			} else {
				sTableName = "";
				sActualName = sColumn;
				sName = sColumn;
			}
			int iIndex = addColumn(sName);
			setColumnAttribute(iIndex, "Header", sName);
			setColumnAttribute(iIndex, "TableName", sTableName);
			setColumnAttribute(iIndex, "ActualName", sActualName);
			setColumnAttribute(iIndex, "Index", String.valueOf(iIndex));
			setColumnAttribute(iIndex, "TabOrder", String.valueOf(iIndex));
			iPos = iPosComma + 1;
		} while (iPosComma >= 0);
	}

	public int addColumn(String sColumnName) {
		int iIndex = getColumnIndex(sColumnName);
		if (iIndex == -1) {
			Columns.addElement(new ASColumn(sColumnName));
			return Columns.size() - 1;
		} else {
			return iIndex;
		}
	}

	public int addColumn(int iPos, String sColumnName) {
		int iIndex = getColumnIndex(sColumnName);
		if (iIndex == -1) {
			Columns.add(iPos, new ASColumn(sColumnName));
			return iPos;
		} else {
			return iIndex;
		}
	}

	public int getColumnIndex(String sColumnName) {
		int iSize = Columns.size();
		for (int i = 0; i < iSize; i++)
			if (((ASColumn) Columns.get(i)).getAttribute("Name")
					.equalsIgnoreCase(sColumnName))
				return i;

		return -1;
	}

	public ASColumn getColumn(String sColumnName) {
		int iIndex = getColumnIndex(sColumnName);
		if (iIndex >= 0)
			return (ASColumn) Columns.get(iIndex);
		else
			return null;
	}

	public ASColumn getColumn(int iIndex) {
		if (iIndex >= 0)
			return (ASColumn) Columns.get(iIndex);
		else
			return null;
	}

	public boolean setColumnAttribute(String sColumnList,
			String sAttributeName, String sAttributeValue) {
		int i = 0;
		int iSize = 0;
		int iIndex = 0;
		if (sColumnList.equals("") || sColumnList.equals("*")) {
			iSize = Columns.size();
			for (i = 0; i < iSize; i++)
				setColumnAttribute(i, sAttributeName, sAttributeValue);

		} else {
			iSize = StringFunction.getSeparateSum(sColumnList, ",");
			for (i = 1; i <= iSize; i++) {
				String sColumnName = StringFunction.getSeparate(sColumnList,
						",", i);
				iIndex = getColumnIndex(sColumnName);
				if (iIndex >= 0)
					setColumnAttribute(iIndex, sAttributeName, sAttributeValue);
			}

		}
		return true;
	}

	public boolean appendColumnAttribute(String sColumnList,
			String sAttributeName, String sAttributeValue) {
		if (sColumnList.equals("") || sColumnList.equals("*")) {
			int iSize = Columns.size();
			for (int i = 0; i < iSize; i++)
				appendColumnAttribute(i, sAttributeName, sAttributeValue);

		} else {
			int iSize = StringFunction.getSeparateSum(sColumnList, ",");
			for (int i = 1; i <= iSize; i++) {
				String sColumnName = StringFunction.getSeparate(sColumnList,
						",", i);
				int iIndex = getColumnIndex(sColumnName);
				if (iIndex >= 0)
					appendColumnAttribute(iIndex, sAttributeName,
							sAttributeValue);
			}

		}
		return true;
	}

	public boolean setColumnAttribute(int iIndex, String sAttributeName,
			String sAttributeValue) {
		if (iIndex >= 0 && iIndex <= Columns.size()) {
			ASColumn ascTemp = (ASColumn) Columns.get(iIndex);
			ascTemp.setAttribute(sAttributeName, sAttributeValue);
			return true;
		} else {
			return false;
		}
	}

	public boolean appendColumnAttribute(int iIndex, String sAttributeName,
			String sAttributeValue) {
		if (iIndex >= 0 && iIndex <= Columns.size()) {
			ASColumn ascTemp = (ASColumn) Columns.get(iIndex);
			ascTemp.setAttribute(
					sAttributeName,
					(new StringBuilder())
							.append(ascTemp.getAttribute(sAttributeName))
							.append(sAttributeValue).toString());
			return true;
		} else {
			return false;
		}
	}

	public String getColumnAttribute(String sColumnName, String sAttributeName) {
		int iSize = Columns.size();
		for (int i = 0; i < iSize; i++) {
			int iIndex = getColumnIndex(sColumnName);
			if (iIndex >= 0)
				return getColumnAttribute(iIndex, sAttributeName);
		}

		return null;
	}

	public String getColumnAttribute(int iIndex, String sAttributeName) {
		if (iIndex >= 0 && iIndex < Columns.size())
			return ((ASColumn) Columns.get(iIndex))
					.getAttribute(sAttributeName);
		else
			return null;
	}

	public String getName(int iIndex) {
		if (iIndex >= 0 && iIndex <= Columns.size())
			return ((ASColumn) Columns.get(iIndex)).getAttribute("Name");
		else
			return null;
	}

	public void setType(int iIndex, String sType) {
		setType(getName(iIndex), sType);
	}

	public void setType(String sColumnList, String sType) {
		setColumnAttribute(sColumnList, "Type", sType);
		if (sType.equalsIgnoreCase("Number"))
			setAlign(sColumnList, "3");
	}

	public void setColumnType(String sColumnList, String sColumnType) {
		setColumnAttribute(sColumnList, "ColumnType", sColumnType);
	}

	public void setUpdateable(String sColumnList, boolean bValue) {
		setColumnAttribute(sColumnList, "Updateable", bValue ? "1" : "0");
	}

	public void setKey(String sColumnList, boolean bValue) {
		setColumnAttribute(sColumnList, "Key", bValue ? "1" : "0");
	}

	public void setVisible(String sColumnList, boolean bValue) {
		setColumnAttribute(sColumnList, "Visible", bValue ? "1" : "0");
	}

	public void setReadOnly(int iIndex, String sValue) {
		setReadOnly(getName(iIndex), sValue.equals("1"));
	}

	public void setReadOnly(String sColumnList, boolean bValue) {
		setColumnAttribute(sColumnList, "ReadOnly", bValue ? "1" : "0");
	}

	public void setRequired(String sColumnList, boolean bValue) {
		setColumnAttribute(sColumnList, "Required", bValue ? "1" : "0");
	}

	public void setCheckFormat(int iIndex, String sFormat) {
		setCheckFormat(getName(iIndex), sFormat);
	}

	public void setCheckFormat(String sColumnList, String sFormat) {
		setColumnAttribute(sColumnList, "CheckFormat", sFormat);
		if (sFormat.equals("3")) {
			setHTMLStyle(sColumnList, "style={width:80px} ");
			setAlign(sColumnList, "2");
		}
	}

	public void setDefaultValue(String sColumnList, String sValue) {
		setColumnAttribute(sColumnList, "DefaultValue", sValue);
	}

	public void setAlign(String sColumnList, String sFormat) {
		setColumnAttribute(sColumnList, "Align", sFormat);
	}

	public void setLimit(String sColumnList, int iLimit) {
		setColumnAttribute(sColumnList, "Limit", String.valueOf(iLimit));
	}

	public void setEditStyle(String sColumnList, String sStyle) {
		setColumnAttribute(sColumnList, "EditStyle", sStyle);
		if (sStyle.equals("3"))
			setHTMLStyle(sColumnList, " style={height:150px;width:450px} ");
	}

	public void setHTMLStyle(int iIndex, String sStyle) {
		if (!sStyle.equals(""))
			setHTMLStyle(getName(iIndex), sStyle);
	}

	public void appendHTMLStyle(int iIndex, String sStyle) {
		if (!sStyle.equals(""))
			appendHTMLStyle(getName(iIndex), sStyle);
	}

	public void setHTMLStyle(String sColumnList, String sStyle) {
		setColumnAttribute(sColumnList, "HTMLStyle", sStyle);
	}

	public void appendHTMLStyle(String sColumnList, String sStyle) {
		appendColumnAttribute(sColumnList, "HTMLStyle", sStyle);
	}

	public void setPopCode(String sColumnList, String sCodeName) {
		setColumnAttribute(sColumnList, "EditStyle", "4");
		setColumnAttribute(sColumnList, "EditSource", (new StringBuilder())
				.append("Code:").append(sCodeName).toString());
	}

	public void setPopSql(String sColumnList, String sSql) {
		setColumnAttribute(sColumnList, "EditStyle", "4");
		setColumnAttribute(sColumnList, "EditSource", (new StringBuilder())
				.append("Sql:").append(sSql).toString());
	}

	public void setHRadioCode(String sColumnList, String sCodeName) {
		setColumnAttribute(sColumnList, "EditStyle", "5");
		setColumnAttribute(sColumnList, "EditSource", (new StringBuilder())
				.append("Code:").append(sCodeName).toString());
	}

	public void setHRadioSql(String sColumnList, String sSql) {
		setColumnAttribute(sColumnList, "EditStyle", "5");
		setColumnAttribute(sColumnList, "EditSource", (new StringBuilder())
				.append("Sql:").append(sSql).toString());
	}

	public void setVRadioCode(String sColumnList, String sCodeName) {
		setColumnAttribute(sColumnList, "EditStyle", "6");
		setColumnAttribute(sColumnList, "EditSource", (new StringBuilder())
				.append("Code:").append(sCodeName).toString());
	}

	public void setVRadioSql(String sColumnList, String sSql) {
		setColumnAttribute(sColumnList, "EditStyle", "6");
		setColumnAttribute(sColumnList, "EditSource", (new StringBuilder())
				.append("Sql:").append(sSql).toString());
	}

	public void setCheckboxCode(String sColumnList, String sCodeName) {
		setColumnAttribute(sColumnList, "EditStyle", "7");
		setColumnAttribute(sColumnList, "EditSource", (new StringBuilder())
				.append("Code:").append(sCodeName).toString());
	}

	public void setCheckboxSql(String sColumnList, String sSql) {
		setColumnAttribute(sColumnList, "EditStyle", "7");
		setColumnAttribute(sColumnList, "EditSource", (new StringBuilder())
				.append("Sql:").append(sSql).toString());
	}

	public void setDDDWCode(String sColumnList, String sCodeName) {
		setColumnAttribute(sColumnList, "EditStyle", "2");
		setColumnAttribute(sColumnList, "EditSource", (new StringBuilder())
				.append("Code:").append(sCodeName).toString());
	}

	public void setDDDWSql(String sColumnList, String sSql) {
		setColumnAttribute(sColumnList, "EditStyle", "2");
		setColumnAttribute(sColumnList, "EditSource", (new StringBuilder())
				.append("Sql:").append(sSql).toString());
	}

	public void setDDDWCodeTable(String sColumnList, String sCodeTable) {
		setColumnAttribute(sColumnList, "EditStyle", "2");
		setColumnAttribute(sColumnList, "EditSource", (new StringBuilder())
				.append("CodeTable:").append(sCodeTable).toString());
	}

	public void setDDDWCodeTable(String sColumnList, String sCodeArray[]) {
		setColumnAttribute(sColumnList, "EditStyle", "2");
		setColumnAttribute(
				sColumnList,
				"EditSource",
				(new StringBuilder()).append("CodeTable:")
						.append(StringFunction.toArrayString(sCodeArray, ","))
						.toString());
	}

	public void setHeader(String sColumnList, String sValue) {
		setColumnAttribute(sColumnList, "Header", sValue);
	}

	public void setHeader(String sValueList) {
		int iCount = StringFunction.getSeparateSum(sValueList, ",");
		for (int i = 1; i <= iCount; i++)
			setColumnAttribute(i - 1, "Header",
					StringFunction.getSeparate(sValueList, ",", i));

	}

	public void setHeader(String sValueArray[][]) {
		int iCount = sValueArray.length;
		for (int i = 0; i < iCount; i++) {
			int iIndex = getColumnIndex(sValueArray[i][0]);
			if (iIndex >= 0)
				setColumnAttribute(iIndex, "Header", sValueArray[i][1]);
		}

	}

	public void setUnit(String sColumnList, String sValue) {
		setColumnAttribute(sColumnList, "Unit", sValue);
	}

	public void setValue(String sColumnList, String sValue) {
		setColumnAttribute(sColumnList, "Value", sValue);
	}

	public void setGroup(String sColumnList, String sValue) {
		setColumnAttribute(sColumnList, "Group", sValue);
	}

	public boolean setColumnEvent(String sColumnName, String sEventName,
			String sEventScript) {
		int iIndex = getColumnIndex(sColumnName);
		if (iIndex >= 0)
			return setColumnEvent(iIndex, sEventName, sEventScript);
		else
			return false;
	}

	public boolean setColumnEvent(int iIndex, String sEventName,
			String sEventScript) {
		if (iIndex >= 0 && iIndex <= Columns.size())
			return ((ASColumn) Columns.get(iIndex)).setEvent(sEventName,
					sEventScript);
		else
			return false;
	}

	public String getColumnEvent(String sColumnName, String sEventName) {
		int iIndex = getColumnIndex(sColumnName);
		if (iIndex >= 0)
			return getColumnEvent(iIndex, sEventName);
		else
			return null;
	}

	public String getColumnEvent(int iIndex, String sEventName) {
		if (iIndex >= 0 && iIndex <= Columns.size())
			return ((ASColumn) Columns.get(iIndex)).getEvent(sEventName);
		else
			return null;
	}

	public void appendFilter(ASDataObjectFilter dfFilter) throws Exception {
		Filters.addElement(dfFilter);
		setColumnAttribute(dfFilter.sFilterColumnID, "IsFilter", "1");
	}

	public void generateFilters(Transaction Sqlca) throws Exception {
		int iFilterID = 0;
		for (int i = 0; i < Columns.size(); i++) {
			ASColumn acTempColumn = (ASColumn) Columns.get(i);
			if (acTempColumn.getAttribute("IsFilter").equals("1")) {
				iFilterID++;
				setFilter(Sqlca,(new StringBuilder()).append("DF").append(iFilterID).toString(), acTempColumn.getAttribute("Name"),acTempColumn.getAttribute("FilterOptions"));
			}
		}

	}

	public void setFilter(Transaction transSql, String sFilterID,
			String sColumnID, String sOptions) throws Exception {
		ASColumn acTempColumn = getColumn(sColumnID);
		if (acTempColumn == null) {
			throw new Exception((new StringBuilder())
					.append("\u83B7\u5F97ASColumn\u5931\u8D25\u3002ColumnID:")
					.append(sColumnID).toString());
		} else {
			ASDataObjectFilter dfFilter = new ASDataObjectFilter(transSql,sFilterID, acTempColumn, sOptions);
			appendFilter(dfFilter);
			return;
		}
	}

	public ASDataObjectFilter getFilter(String sFilterID) throws Exception {
		for (int i = 0; i < Filters.size(); i++) {
			ASDataObjectFilter tmpFilter = (ASDataObjectFilter) Filters.get(i);
			if (tmpFilter.sFilterID.equals(sFilterID))
				return tmpFilter;
		}

		return null;
	}

	public ASDataObjectFilter getFilter(int i) throws Exception {
		return (ASDataObjectFilter) Filters.get(i);
	}

	public String getFilterHtml(Transaction Sqlca) throws Exception {
		String sReturn = "";
		for (int i = 0; i < Filters.size(); i++) {
			ASDataObjectFilter dofTemp = (ASDataObjectFilter) Filters.get(i);
			sReturn = (new StringBuilder()).append(sReturn).append(dofTemp.getFilterHtml(Sqlca)).toString();
		}

		return sReturn;
	}

	public void parseFilterData(ServletRequest request, int iPostChange)
			throws Exception {
		for (int i = 0; i < Filters.size(); i++) {
			ASDataObjectFilter dofTemp = (ASDataObjectFilter) Filters.get(i);
			String sTempFilterOperator = DataConvert.toRealString(iPostChange,request.getParameter((new StringBuilder()).append("DOFILTER_").append(dofTemp.sFilterID).append("_OP").toString()));
			if (sTempFilterOperator != null && !sTempFilterOperator.equals(""))
				dofTemp.sOperator = sTempFilterOperator;
			for (int j = 0; j < dofTemp.sFilterInputs.length; j++) {
				String sTempFilterValue = DataConvert.toRealString(iPostChange,request.getParameter(dofTemp.sFilterInputs[j][0]));//dofTemp.sFilterInputs[j][0]--input name
				if (sTempFilterValue != null && !sTempFilterValue.equals(""))
					dofTemp.sFilterInputs[j][1] = DataConvert.toString(sTempFilterValue);//dofTemp.sFilterInputs[j][1]--value
				if (dofTemp.sFilterInputs[j][1] != null&& !dofTemp.sFilterInputs[j][1].equals(""))
					receivedFilterData = true;
			}
		}
	}

	private String getFilterWhereClause(Transaction Sqlca) throws Exception {
		String sReturn = "";
		String sCurWhereClause = "";
		int j = 0;
		for (int i = 0; i < Filters.size(); i++) {
			ASDataObjectFilter dofTemp = (ASDataObjectFilter) Filters.get(i);
			sCurWhereClause = dofTemp.getFilterWhereClause(Sqlca);
			if (sCurWhereClause != null && !sCurWhereClause.equals("")) {
				j++;
				sReturn = (new StringBuilder()).append(sReturn)
						.append(j != 1 ? " and " : "").append("(")
						.append(dofTemp.getFilterWhereClause(Sqlca))
						.append(")").toString();
			}
		}

		return sReturn;
	}

	private void enableMultiSelection() {
		int iPosSelect = StringFunction.indexOf(SelectClause.toLowerCase(),
				"select ", "'", "'", 0);
		SelectClause = (new StringBuilder())
				.append(SelectClause.substring(iPosSelect, iPosSelect + 7))
				.append(" '' as MultiSelectionFlag,")
				.append(SelectClause.substring(iPosSelect + 7)).toString();
		Columns.add(0, new ASColumn("MultiSelectionFlag"));
		setUpdateable("MultiSelectionFlag", false);
		setAlign("MultiSelectionFlag", "2");
		setHTMLStyle("MultiSelectionFlag",
				" style={width:30px} onDBLClick=parent.multiSelectCurrentRow() ");
		setHeader("MultiSelectionFlag", "\u221A");
	}

	public boolean haveReceivedFilterCriteria() {
		return receivedFilterData;
	}

	public void setAuditTable(String sAuditTable) {
		AuditTable = sAuditTable;
	}

	public void setAuditMode(String sAuditMode) {
		AuditMode = sAuditMode;
	}

	public void setColAuditable(String sColumnList, boolean bValue) {
		setColumnAttribute(sColumnList, "Auditable", bValue ? "1" : "0");
		setColumnAttribute(sColumnList, "AuditColumn", bValue ? "1" : "0");
	}

	public void setAuditColumn(String sColumnList, boolean bValue) {
		setColumnAttribute(sColumnList, "AuditColumn", bValue ? "1" : "0");
	}

	public void setAuditUser(String sAuditUser) {
		AuditUser = sAuditUser;
	}

	public void setAuditOrg(String sAuditOrg) {
		AuditOrg = sAuditOrg;
	}

	public String SourceSql;
	public String SelectClause;
	public String FromClause;
	public String WhereClause;
	public String GroupClause;
	public String OrderClause;
	public String Arguments;
	public String UpdateTable;
	public String UpdateWhere;
	public String UpdateKeyInPlace;
	public String Updateable;
	public Vector Columns;
	public Vector Filters;
	public boolean multiSelectionEnabled;
	private boolean receivedFilterData;
	public String KeyFilter;
	public String JoinClause;
	private String doNo;
	public static String AUDITMODE_UPDATE_DELETE = "10";
	public static String AUDITMODE_DELETE = "20";
	public static String AUDITMODE_UPDATE = "30";
	public static String AUDITMODE_NONE = "40";
	public String AuditTable;
	public String AuditMode;
	public String AuditUser;
	public String AuditOrg;

}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 234 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/