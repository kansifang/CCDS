package com.lmt.frameapp.web.render;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Vector;
import java.util.zip.CRC32;
import java.util.zip.CheckedOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;

import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.SpecialTools;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.ASException;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.config.CodeManager;
import com.lmt.frameapp.lang.StringX;
import com.lmt.frameapp.script.AmarInterpreter;
import com.lmt.frameapp.script.AmarScript;
import com.lmt.frameapp.script.Any;
import com.lmt.frameapp.script.Anything;
import com.lmt.frameapp.script.Expression;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
import com.lmt.frameapp.web.ASComponent;
import com.lmt.frameapp.web.ASPage;

public class ASDataWindow implements Cloneable {

	public void setDataSourceName(String argDataSourceName) {
		sDataSourceName = argDataSourceName;
	}

	public String getDataSourceName() {
		return sDataSourceName;
	}

	public void setPageSize(int iSize) {
		if (iPageSize <= 0)
			iPageSize = 100;
		iPageSize = iSize;
	}

	public void setSortField(String sName, String sSort) throws Exception {
		sSortField = sName;
		if (sSort.equals("1"))
			sSortOrder = " desc ";
		else
			sSortOrder = "";
		ascSortField = DataObject.getColumn(sSortField);
	}

	public ASDataWindow(ASComponent cpComp, ASDataObject doDataObject,
			Transaction Sqlca) throws Exception {
		Name = "";
		DataObject = null;
		this.Sqlca = null;
		Style = "1";
		HTMLStyle = "";
		ReadOnly = "0";
		ShowSummary = "0";
		ArrayName = "DZ";
		harbor = new ASDataWindowHarbor("default");
		bSaveLog = false;
		bFirstInvoke = true;
		iPageSize = 100;
		iRowCount = 0;
		iPageCount = 0;
		iCurPage = 0;
		CurComp = null;
		CurPage = null;
		interpreter = null;
		isAuditChanged = false;
		sSortField = "";
		sSortOrder = "";
		ascSortField = null;
		sDataSourceName = "";
		ARE.getLog()
				.warn("\u4E0D\u5EFA\u8BAE\u7684Datawindow\u521D\u59CB\u5316\u65B9\u5F0F\uFF1Anew ASDataWindow(CurComp,doTemp,Sqlca)\u3002\n\u6B64\u7528\u6CD5\u5C06\u5BFC\u81F4DW\u65E0\u6CD5\u83B7\u5F97\u9875\u9762\u72B6\u6001\u3002\n\u8BF7\u4F7F\u7528\uFF1A new ASDataWindow(CurPage,doTemp,Sqlca)\u3002");
		throw new Exception(
				"\u4F7F\u7528\u4E86\u8FC7\u671F\u7684Datawindow\u521D\u59CB\u5316\u65B9\u5F0F\uFF1Anew ASDataWindow(CurComp,doTemp,Sqlca)\u3002\n\u6B64\u7528\u6CD5\u5C06\u5BFC\u81F4DW\u65E0\u6CD5\u83B7\u5F97\u9875\u9762\u72B6\u6001\u3002\n\u8BF7\u4F7F\u7528\uFF1A new ASDataWindow(CurPage,doTemp,Sqlca)\u3002");
	}

	public ASDataWindow(ASPage page, ASDataObject doDataObject,
			Transaction Sqlca) throws Exception {
		Name = "";
		DataObject = null;
		this.Sqlca = null;
		Style = "1";
		HTMLStyle = "";
		ReadOnly = "0";
		ShowSummary = "0";
		ArrayName = "DZ";
		harbor = new ASDataWindowHarbor("default");
		bSaveLog = false;
		bFirstInvoke = true;
		iPageSize = 100;
		iRowCount = 0;
		iPageCount = 0;
		iCurPage = 0;
		CurComp = null;
		CurPage = null;
		interpreter = null;
		isAuditChanged = false;
		sSortField = "";
		sSortOrder = "";
		ascSortField = null;
		sDataSourceName = "";
		if (page == null)
			throw new Exception(
					"\u65E0\u6CD5\u627E\u5230DataWindow\u6240\u5728\u9875\u9762\u5728\u670D\u52A1\u5668\u7AEF\u5B9E\u4F8B(CurPage)\u3002");
		CurPage = page;
		CurComp = page.CurComp;
		if (CurComp == null) {
			throw new Exception(
					"\u65E0\u6CD5\u627E\u5230DataWindow\u6240\u5728\u9875\u9762\u6240\u5C5E\u7684\u7EC4\u4EF6\u670D\u52A1\u5668\u7AEF\u5B9E\u4F8B(CurComp)\u3002");
		} else {
			doDataObject.composeSourceSql(Sqlca);
			Name = (new StringBuilder()).append(StringFunction.getMathRandom())
					.append("|").append(CurComp.ClientID).append("|")
					.append(page.ClientID).toString();
			DataObject = doDataObject;
			this.Sqlca = Sqlca;
			page.setAttribute(Name, this);
			sSortField = "";
			setDataSourceName(Sqlca.getDataSourceName());
			return;
		}
	}

	public ASDataWindow(ASDataObject doDataObject, Transaction Sqlca,
			String sDWName) throws Exception {
		Name = "";
		DataObject = null;
		this.Sqlca = null;
		Style = "1";
		HTMLStyle = "";
		ReadOnly = "0";
		ShowSummary = "0";
		ArrayName = "DZ";
		harbor = new ASDataWindowHarbor("default");
		bSaveLog = false;
		bFirstInvoke = true;
		iPageSize = 100;
		iRowCount = 0;
		iPageCount = 0;
		iCurPage = 0;
		CurComp = null;
		CurPage = null;
		interpreter = null;
		isAuditChanged = false;
		sSortField = "";
		sSortOrder = "";
		ascSortField = null;
		sDataSourceName = "";
		doDataObject.composeSourceSql(Sqlca);
		Name = (new StringBuilder()).append(sDWName)
				.append(StringFunction.getMathRandom()).toString();
		DataObject = doDataObject;
		this.Sqlca = Sqlca;
		sSortField = "";
		setDataSourceName(Sqlca.getDataSourceName());
	}

	public void setInterpreter(AmarInterpreter argInterpreter) {
		interpreter = argInterpreter;
	}

	public String getNewOrder() throws Exception {
		String sNewOrder = "";
		if (DataObject.OrderClause.equals("")) {
			if (!sSortField.equals("")
					&& !sSortField.equals("MultiSelectionFlag"))
				if (ascSortField.getItemName().equals(DataObject.KeyFilter)
						|| ascSortField.getDBName()
								.equals(DataObject.KeyFilter))
					sNewOrder = (new StringBuilder()).append(" order by ")
							.append(DataObject.KeyFilter).append(sSortOrder)
							.toString();
				else
					sNewOrder = (new StringBuilder()).append(" order by ")
							.append(sSortField).append(sSortOrder).toString();
		} else {
			sNewOrder = DataObject.OrderClause;
			if (!sSortField.equals("")
					&& !sSortField.equals("MultiSelectionFlag"))
				if (ascSortField.getItemName().equals(DataObject.KeyFilter)
						|| ascSortField.getDBName()
								.equals(DataObject.KeyFilter))
					sNewOrder = (new StringBuilder())
							.append("order by ")
							.append(DataObject.KeyFilter)
							.append(sSortOrder)
							.append(",")
							.append(sNewOrder.substring(sNewOrder.toLowerCase()
									.indexOf(" order by ") + 9)).toString();
				else
					sNewOrder = (new StringBuilder())
							.append("order by ")
							.append(sSortField)
							.append(sSortOrder)
							.append(",")
							.append(sNewOrder.substring(sNewOrder.toLowerCase()
									.indexOf(" order by ") + 9)).toString();
		}
		return sNewOrder;
	}

	public String getSelectEx() throws Exception {
		if (!sSortField.equals("") && !sSortField.equals("MultiSelectionFlag")) {
			if (ascSortField.getItemName().equals(DataObject.KeyFilter)
					|| ascSortField.getDBName().equals(DataObject.KeyFilter))
				return "";
			else
				return (new StringBuilder()).append(",")
						.append(ascSortField.getDBName()).append(" as ")
						.append(ascSortField.getItemName()).toString();
		} else {
			return "";
		}
	}

	public ASResultSet retrieve(String sArgsValue) throws Exception {
		String sSql = "";
		sSql = (new StringBuilder()).append(DataObject.SelectClause)
				.append(" ").append(DataObject.FromClause).append(" ")
				.append(DataObject.WhereClause).append(" ")
				.append(DataObject.GroupClause).append(" ")
				.append(getNewOrder()).toString();
		sSql = StringFunction.applyArgs(sSql, DataObject.Arguments, sArgsValue);
		ASResultSet rsReturn = null;
		try {
			rsReturn = Sqlca.getResultSet(sSql);
		} catch (Exception ex) {
			throw new Exception(
					(new StringBuilder())
							.append("\u751F\u6210\u6570\u636E\u96C6\u9519\u8BEF\u3002SQL:")
							.append(sSql).append(" \u9519\u8BEF\uFF1A")
							.append(ex.toString()).toString());
		}
		return rsReturn;
	}

	public ASResultSet retrieveKey(String sArgsValue) throws Exception {
		String sSql = "";
		sSql = (new StringBuilder()).append("select ")
				.append(DataObject.KeyFilter).append(getSelectEx()).append(" ")
				.append(DataObject.FromClause).append(" ")
				.append(DataObject.WhereClause).append(" ")
				.append(getNewOrder()).toString();
		sSql = StringFunction.applyArgs(sSql, DataObject.Arguments, sArgsValue);
		ASResultSet rsReturn = null;
		try {
			rsReturn = Sqlca.getResultSet(sSql);
		} catch (Exception ex) {
			throw new Exception(
					(new StringBuilder())
							.append("\u751F\u6210\u6570\u636E\u96C6\u9519\u8BEF\u3002SQL:")
							.append(sSql).append(" \u9519\u8BEF\uFF1A")
							.append(ex.toString()).toString());
		}
		return rsReturn;
	}

	public ASResultSet retrieveNew(String sArgsValue, String sKeyFilterCollect)
			throws Exception {
		String sSql = "";
		String sNewWhere = "";
		if (DataObject.JoinClause.equals("")) {
			if (DataObject.WhereClause.equals(""))
				sNewWhere = (new StringBuilder()).append(" where ")
						.append(DataObject.KeyFilter).append(" in (")
						.append(sKeyFilterCollect).append(") ").toString();
			else
				sNewWhere = (new StringBuilder())
						.append(DataObject.WhereClause).append(" and ")
						.append(DataObject.KeyFilter).append(" in (")
						.append(sKeyFilterCollect).append(") ").toString();
		} else {
			sNewWhere = (new StringBuilder()).append(" where ")
					.append(DataObject.JoinClause).append(" and ")
					.append(DataObject.KeyFilter).append(" in (")
					.append(sKeyFilterCollect).append(") ").toString();
		}
		sSql = (new StringBuilder()).append(DataObject.SelectClause)
				.append(" ").append(DataObject.FromClause).append(" ")
				.append(sNewWhere).append(" ").append(getNewOrder()).toString();
		sSql = StringFunction.applyArgs(sSql, DataObject.Arguments, sArgsValue);
		ASResultSet rsReturn = null;
		try {
			rsReturn = Sqlca.getResultSet(sSql);
		} catch (Exception ex) {
			throw new Exception(
					(new StringBuilder())
							.append("\u751F\u6210\u6570\u636E\u96C6\u9519\u8BEF\u3002SQL:")
							.append(sSql).append(" \u9519\u8BEF\uFF1A")
							.append(ex.toString()).toString());
		}
		return rsReturn;
	}

	public Vector genHTMLDataWindow(String sArgsValue) throws Exception {
		setRightType();
		return genHTMLDataWindow(sArgsValue, iMaxRows);
	}

	public Vector genHTMLDataWindow(String sArgsValue, int iMyMaxRows)
			throws Exception {
		int iRow = 0;
		int iColCount = DataObject.Columns.size();
		String sColType = "";
		String sItemValue = "";
		Vector vSql = new Vector();
		if (bFirstInvoke) {
			vSql.add((new StringBuilder())
					.append("<script type=\"text/javascript\"> DisplayDONO='")
					.append(DataObject.getDoNo()).append("';\r\n i=")
					.append(ArrayName).append(".length;\r\n").append(ArrayName)
					.append("[i]=new Array();\r\n").toString());
			vSql.add((new StringBuilder()).append(ArrayName)
					.append("[i][0]=new Array(").append(Style).append(",'")
					.append(Name).append("',").append(ReadOnly).append(",")
					.append(DataObject.UpdateWhere).append(",")
					.append(ShowSummary).append(");\r\n").toString());
			vSql.add((new StringBuilder()).append(ArrayName)
					.append("[i][1]=new Array();\r\n").toString());
			String sAttribute[] = new String[20];
			String sCodeArray[] = null;
			for (int iCol = 0; iCol < iColCount; iCol++) {
				sAttribute[0] = (new StringBuilder()).append("'")
						.append(DataObject.getColumnAttribute(iCol, "Header"))
						.append("'").toString();
				sAttribute[1] = DataObject.getColumnAttribute(iCol, "Key");
				sAttribute[2] = DataObject.getColumnAttribute(iCol, "Visible");
				sAttribute[3] = DataObject.getColumnAttribute(iCol, "ReadOnly");
				sAttribute[4] = DataObject.getColumnAttribute(iCol, "Required");
				sAttribute[5] = DataObject.getColumnAttribute(iCol,"Updateable");
				sAttribute[6] = DataObject.getColumnAttribute(iCol, "Sortable");
				sAttribute[7] = DataObject.getColumnAttribute(iCol, "Limit");
				sAttribute[8] = DataObject.getColumnAttribute(iCol, "Align");
				sAttribute[9] = (new StringBuilder())
						.append("'").append(DataObject.getColumnAttribute(iCol,"DefaultValue")).append("'").toString();
				sAttribute[10] = "";
				sAttribute[11] = DataObject.getColumnAttribute(iCol,
						"EditStyle");
				sAttribute[12] = DataObject.getColumnAttribute(iCol,
						"CheckFormat");
				sAttribute[13] = (new StringBuilder()).append("'")
						.append(DataObject.getColumnAttribute(iCol, "Event"))
						.append("'").toString();
				sAttribute[14] = DataObject.getColumnAttribute(iCol,
						"ColumnType");
				sAttribute[15] = (new StringBuilder()).append("'")
						.append(DataObject.getColumnAttribute(iCol, "Name"))
						.append("'").toString();
				sAttribute[16] = DataObject.getColumnAttribute(iCol, "Group");
				sAttribute[17] = (new StringBuilder()).append("'")
						.append(DataObject.getColumnAttribute(iCol, "Unit"))
						.append("'").toString();
				sAttribute[18] = (new StringBuilder())
						.append("'")
						.append(DataObject.getColumnAttribute(iCol,
								"TransferBack")).append("'").toString();
				if (sAttribute[1].equals("1"))
					sAttribute[18] = "'0'";
				if (sAttribute[12] != null&& (sAttribute[12].equals("2")|| sAttribute[12].equals("5") || Integer.valueOf(sAttribute[12]).intValue() > 10))
					DataObject.setType(iCol, "Number");
				String sAlign = (new StringBuilder())
						.append("text-align:")
						.append(sAttribute[8] != "1" ? (new StringBuilder())
								.append(sAttribute[8] != "2" ? "right"
										: "center").append(";").toString()
								: "left").toString();
				String subStyle = "";
				String otherStyle = "";
				HTMLStyle = DataObject.getColumnAttribute(iCol, "HTMLStyle")
						.trim();
				if (HTMLStyle == null)
					HTMLStyle = "";
				if (HTMLStyle.indexOf("style={") >= 0
						&& HTMLStyle.indexOf("}") >= 0) {
					subStyle = HTMLStyle.substring(
							HTMLStyle.indexOf("style={") + 7,
							HTMLStyle.indexOf("}"));
					otherStyle = HTMLStyle.replace((new StringBuilder())
							.append("style={").append(subStyle).append("}")
							.toString(), "");
				} else {
					otherStyle = HTMLStyle;
				}
				if (Style.equals("2")) {
					if (sAttribute[3].equals("1"))
						sAttribute[10] = "background:#efefef;color:black;";
					if (sAttribute[11].equals("3"))
						sAttribute[10] = "overflow:auto;resize: none;";
				}
				sAttribute[10] = (new StringBuilder()).append("' style=\"")
						.append(sAttribute[10]).append("").append(subStyle)
						.append("\" ").append(otherStyle).append(" ' ")
						.toString();
				String sEditSource = DataObject.getColumnAttribute(iCol,
						"EditSource");
				String colName = DataObject.getColumnAttribute(iCol, "Name");
				int iPos;
				if (sAttribute[11].equals("8") && sEditSource != null
						&& sEditSource.length() > 0) {
					iPos = sEditSource.indexOf(":");
					if (iPos > 0) {
						String sSourceType = sEditSource.substring(0, iPos);
						String sSourceCode = sEditSource.substring(iPos + 1);
						if (sSourceType.equalsIgnoreCase("JSFunc"))
							sAttribute[17] = (new StringBuilder())
									.append(" ' <input class=inputdate value=... type=button onClick=pContextnt.")
									.append(sSourceCode)
									.append("> ")
									.append(DataObject.getColumnAttribute(iCol,
											"Unit")).append(" ' ").toString();
						else if (sSourceType.equalsIgnoreCase("SelectCatalog")) {
							String sObjectType = StringFunction
									.getProfileString(sSourceCode, "ObjectType");
							String sParaString = StringFunction
									.getProfileString(sSourceCode, "ParaString");
							String sValueString = StringFunction
									.getProfileString(sSourceCode,
											"ValueString");
							vSql.add((new StringBuilder())
									.append("function PopSelect")
									.append(colName)
									.append("(){setObjectValuePretreat('")
									.append(sObjectType).append("','")
									.append(sParaString).append("','")
									.append(sValueString).append("',0,0,'');}")
									.toString());
							sAttribute[17] = (new StringBuilder())
									.append(" ' <input class=inputdate value=... type=button onClick=pContextnt.PopSelect")
									.append(colName)
									.append("()> ")
									.append(DataObject.getColumnAttribute(iCol,
											"Unit")).append(" ' ").toString();
						}
					}
				}
				vSql.add((new StringBuilder()).append(ArrayName)
						.append("[i][1][").append(iCol).append("]= new Array(")
						.toString());
				int i;
				for (i = 0; i < sAttribute.length - 1; i++)
					vSql.add((new StringBuilder()).append(sAttribute[i])
							.append(",").toString());

				vSql.add((new StringBuilder()).append(sAttribute[i])
						.append(");\r\n").toString());
				String sEditStyle = sAttribute[11];
				if (!sEditStyle.equals("2") && !sEditStyle.equals("4")
						&& !sEditStyle.equals("5") && !sEditStyle.equals("6")
						&& !sEditStyle.equals("7") && !sEditStyle.equals("9"))
					continue;
				vSql.add((new StringBuilder()).append(ArrayName)
						.append("[i][1][").append(iCol)
						.append("][20]=new Array(").toString());
				iPos = sEditSource.indexOf(":");
				if (iPos > 0) {
					String sSourceType = sEditSource.substring(0, iPos);
					String sSourceCode = sEditSource.substring(iPos + 1);
					if (sSourceType.equalsIgnoreCase("Code"))
						sCodeArray = CodeManager.getItemArray(sSourceCode,
								Sqlca);
					else if (sSourceType.equalsIgnoreCase("SQL"))
						sCodeArray = CodeManager.getItemArrayFromSql(
								sSourceCode, Sqlca);
					else if (sSourceType.equalsIgnoreCase("CodeTable"))
						sCodeArray = StringFunction.toStringArray(sSourceCode,
								",");
				}
				if (sCodeArray != null && sCodeArray.length > 1) {
					vSql.add("'','',");
					for (i = 0; i < sCodeArray.length - 1; i++)
						vSql.add((new StringBuilder()).append("'")
								.append(sCodeArray[i]).append("',").toString());

					vSql.add((new StringBuilder()).append("'")
							.append(sCodeArray[i]).append("');\r\n").toString());
				} else {
					vSql.add("'','');\r\n");
				}
				if (sEditStyle.equals("4"))
					vSql.add((new StringBuilder()).append(ArrayName)
							.append("[i][1][").append(iCol).append("][21]='")
							.append(SpecialTools.real2Amarsoft(sEditSource))
							.append("';").toString());
			}

			sArgumentValue = sArgsValue;
		} else {
			vSql.add((new StringBuilder())
					.append("<script type=\"text/javascript\">  DisplayDONO='")
					.append(DataObject.getDoNo()).append("'; i=")
					.append(ArrayName).append(".length;i=i-1;\r\n").toString());
		}
		vSql.add((new StringBuilder()).append(ArrayName).append("[i][2]=new Array();\r\n").toString());
		ASResultSet rsData = null;
		if (!DataObject.KeyFilter.equals("")&& DataObject.GroupClause.equals(""))
			rsData = retrieveKey(sArgumentValue);
		else
			rsData = retrieve(sArgumentValue);
		if (bFirstInvoke) {
			String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
			if (Style.equals("1") && DataObject.GroupClause.equals("")
					&& sDBName.startsWith("ORACLE")) {
				String sSql = "";
				if (DataObject.SourceSql.toUpperCase().indexOf(" UNION ") > 0)
					sSql = (new StringBuilder())
							.append("select count(*) as cnt from (")
							.append(DataObject.SourceSql).append(")")
							.toString();
				else if (DataObject.SelectClause.indexOf("/*+all_rows*/") > 0)
					sSql = (new StringBuilder())
							.append("select /*+all_rows*/count(*) as cnt ")
							.append(DataObject.FromClause).append(" ")
							.append(DataObject.WhereClause).toString();
				else if (DataObject.SelectClause.indexOf("/*+choose*/") > 0)
					sSql = (new StringBuilder())
							.append("select /*+choose*/count(*) as cnt ")
							.append(DataObject.FromClause).append(" ")
							.append(DataObject.WhereClause).toString();
				else if (DataObject.SelectClause.indexOf("/*+rule*/") > 0)
					sSql = (new StringBuilder())
							.append("select /*+rule*/count(*) as cnt ")
							.append(DataObject.FromClause).append(" ")
							.append(DataObject.WhereClause).toString();
				else if (DataObject.SelectClause.indexOf("/*+first_rows*/") > 0)
					sSql = (new StringBuilder())
							.append("select /*+first_rows*/count(*) as cnt ")
							.append(DataObject.FromClause).append(" ")
							.append(DataObject.WhereClause).toString();
				else
					sSql = (new StringBuilder())
							.append("select count(*) as cnt ")
							.append(DataObject.FromClause).append(" ")
							.append(DataObject.WhereClause).toString();
				sSql = StringFunction.applyArgs(sSql, DataObject.Arguments,
						sArgsValue);
				ASResultSet rsCount = null;
				try {
					rsCount = Sqlca.getResultSet(sSql);
					if (rsCount.next())
						iRowCount = rsCount.getInt("cnt");
					else
						iRowCount = 0;
					rsCount.getStatement().close();
					rsCount = null;
				} catch (Exception ex) {
					throw new Exception(
							(new StringBuilder())
									.append("\u8BA1\u7B97count(*)\u9519\u8BEF\u3002SQL:")
									.append(sSql).append(" \u9519\u8BEF\uFF1A")
									.append(ex.toString()).toString());
				}
			} else {
				iRowCount = rsData.getRowCount();
			}
			iPageCount = (new Double(Math.ceil(((double) iRowCount * 1.0D)/(double) iPageSize))).intValue();
			bFirstInvoke = false;
			vSql.add((new StringBuilder()).append("s_r_c[i]=").append(iRowCount).append(";\r\n").toString());
			vSql.add((new StringBuilder()).append("s_p_s[i]=").append(iPageSize).append(";\r\n").toString());
			vSql.add((new StringBuilder()).append("s_p_c[i]=").append(iPageCount).append(";\r\n").toString());
			vSql.add((new StringBuilder()).append("s_c_p[i]=").append(iCurPage).append(";\r\n").toString());
		} else {
			if (iCurPage <= 0)
				rsData.rs.beforeFirst();
			else
				rsData.rs.absolute(iCurPage * iPageSize);
			vSql.add((new StringBuilder()).append("s_r_c[i]=").append(iRowCount).append(";\r\n").toString());
			vSql.add((new StringBuilder()).append("s_p_s[i]=").append(iPageSize).append(";\r\n").toString());
			vSql.add((new StringBuilder()).append("s_p_c[i]=").append(iPageCount).append(";\r\n").toString());
			vSql.add((new StringBuilder()).append("s_c_p[i]=").append(iCurPage).append(";\r\n").toString());
		}
		boolean bNextDo = true;
		if (!DataObject.KeyFilter.equals("")&& DataObject.GroupClause.equals("")) {
			StringBuffer sTemp = new StringBuffer();
			String sKeyFilterCollect = "";
			for (iRow = iCurPage * iPageSize; rsData.next()&& iRow < iMyMaxRows && iRow < (iCurPage + 1) * iPageSize; iRow++)
				sTemp.append((new StringBuilder()).append("'").append(rsData.getString(1)).append("',").toString());

			sKeyFilterCollect = sTemp.toString();
			if (sKeyFilterCollect.length() > 0) {
				sKeyFilterCollect = sKeyFilterCollect.substring(0,sKeyFilterCollect.length() - 1);
				rsData.getStatement().close();
				rsData = retrieveNew(sArgumentValue, sKeyFilterCollect);
			} else {
				bNextDo = false;
			}
		}
		for (iRow = iCurPage * iPageSize; bNextDo && rsData.next()&& iRow < iMyMaxRows && iRow < (iCurPage + 1) * iPageSize; iRow++) {
			vSql.add((new StringBuilder()).append(ArrayName).append("[i][2][").append(iRow - iCurPage * iPageSize).append("]=new Array(").toString());
			for (int iCol = 0; iCol < iColCount; iCol++) {
				sColType = DataObject.getColumnAttribute(iCol, "Type");
				sItemValue = rsData.getString(iCol + 1);
				if (sItemValue != null) {
					sItemValue = StringX.trimEnd(sItemValue);
					sItemValue = SpecialTools.real2Amarsoft(sItemValue);
				}
				if (rsData.wasNull())
					sItemValue = "";
				if (sColType.equalsIgnoreCase("String"))
					sItemValue = (new StringBuilder()).append("'").append(sItemValue).append("'").toString();
				else if (sColType.equalsIgnoreCase("Number")&& (sItemValue == null || sItemValue.trim().equals("")))
					sItemValue = "null";
				if (iCol == iColCount - 1)
					vSql.add((new StringBuilder()).append(sItemValue).append(");\r\n").toString());
				else
					vSql.add((new StringBuilder()).append(sItemValue).append(",").toString());
			}

		}
		vSql.add(getDockingScript());
		vSql.add("</script>");
		rsData.getStatement().close();
		return vSql;
	}

	public int update(HttpServletRequest request, Transaction Sqlca)
			throws Exception {
		return update(request, iChange, Sqlca);
	}

	public int update(HttpServletRequest request, int iChange0, Transaction cSqlca)
        throws Exception
    {
        Vector vRowsUpdate;
        Vector vRowsInsert;
        Vector vRowsDelete;
        int iReturn;
        if(DataObject.UpdateTable == null || DataObject.UpdateTable.equals(""))
            throw new Exception("DataObject\u6CA1\u6709\u5B9A\u4E49UpdateTable\uFF01");
        String sKeyTemp = "";
        String sValueTemp = "";
        String sActionTemp = "";
        String sOpDesc = " ";
        vRowsUpdate = new Vector();
        vRowsInsert = new Vector();
        vRowsDelete = new Vector();
        Enumeration enuParameterNames = request.getParameterNames();
        do
        {
            if(!enuParameterNames.hasMoreElements())
                break;
            String sParameterName = (String)enuParameterNames.nextElement();
            String sParameterValue = request.getParameter(sParameterName);
            if(sParameterValue != null)
            {
                sParameterValue = URLDecoder.decode(sParameterValue, "UTF-8");
                if(iChange0 == 0)
                    sParameterValue = new String(sParameterValue.getBytes("GBK"), "ISO8859-1");
                sParameterValue = StringX.trimEnd(sParameterValue);
                sParameterValue = StringFunction.replace(sParameterValue, "'", "''");
            }
            if(sParameterName.indexOf(".") != -1)
            {
                String sRowNo = StringFunction.getSeparate(sParameterName, ".", 1);
                String sColNo = StringFunction.getSeparate(sParameterName, ".", 2);
                String sChangeType = StringFunction.getSeparate(sParameterName, ".", 3);
                String sOldOrNew = StringFunction.getSeparate(sParameterName, ".", 4);
                int iColNo = Integer.valueOf(sColNo).intValue();
                ASColumn colNew = new ASColumn(DataObject.getColumnAttribute(iColNo, "Name"));
                colNew.setAttribute("ActualName", DataObject.getColumnAttribute(iColNo, "ActualName"));
                colNew.setAttribute("TableName", DataObject.getColumnAttribute(iColNo, "TableName"));
                colNew.setAttribute("Type", DataObject.getColumnAttribute(iColNo, "Type"));
                colNew.setAttribute("Key", DataObject.getColumnAttribute(iColNo, "Key"));
                colNew.setAttribute("Updateable", DataObject.getColumnAttribute(iColNo, "Updateable"));
                colNew.setAttribute("Auditable", DataObject.getColumnAttribute(iColNo, "Auditable"));
                colNew.setAttribute("AuditColumn", DataObject.getColumnAttribute(iColNo, "AuditColumn"));
                if(colNew.getAttribute("Type").equals("Number"))
                    sParameterValue = StringFunction.replace(sParameterValue, ",", "");
                colNew.setAttribute("Value", sParameterValue);
                if(request.getParameter((new StringBuilder()).append(sRowNo).append(".").append(sColNo).append(".").append(sChangeType).append(".1").toString()) != null)
                    colNew.setAttribute("Modifyed", "1");
                Vector vRows;
                if(sChangeType.equals("1"))
                    vRows = vRowsUpdate;
                else
                if(sChangeType.equals("2"))
                    vRows = vRowsInsert;
                else
                if(sChangeType.equals("3") || sChangeType.equals("5"))
                    vRows = vRowsDelete;
                else
                    vRows = vRowsUpdate;
                int iRowIndex = addRow(vRows, sRowNo);
                if(sOldOrNew.equals("0"))
                    getRow(vRows, iRowIndex).AllColumns.addElement(colNew);
                else
                    getRow(vRows, iRowIndex).ChangedColumns.addElement(colNew);
                if(bSaveLog)
                {
                    if(DataObject.getColumnAttribute(iColNo, "Key").equals("1"))
                    {
                        sKeyTemp = (new StringBuilder()).append(sKeyTemp).append(colNew.getActualName()).append(",").toString();
                        sValueTemp = (new StringBuilder()).append(sValueTemp).append(sParameterValue).append(",").toString();
                        if(sChangeType.equals("1"))
                            sActionTemp = (new StringBuilder()).append(sActionTemp).append("\u66F4\u65B0,").toString();
                        else
                        if(sChangeType.equals("2"))
                            sActionTemp = (new StringBuilder()).append(sActionTemp).append("\u65B0\u589E,").toString();
                        else
                        if(sChangeType.equals("3") || sChangeType.equals("5"))
                            sActionTemp = (new StringBuilder()).append(sActionTemp).append("\u5220\u9664,").toString();
                        else
                            sActionTemp = (new StringBuilder()).append(sActionTemp).append("\u66F4\u65B0,").toString();
                    }
                    if(sChangeType.equals("1") && sOldOrNew.equals("1"))
                    {
                        String sName1 = (new StringBuilder()).append(sRowNo).append(".").append(sColNo).append(".").append(sChangeType).append(".0").toString();
                        String sValue1 = request.getParameter(sName1);
                        if(sValue1 != null)
                        {
                            sValue1 = URLDecoder.decode(sValue1, "UTF-8");
                            if(iChange0 == 0)
                                sValue1 = new String(sValue1.getBytes("GBK"), "ISO8859-1");
                            sValue1 = StringX.trimEnd(sValue1);
                        } else
                        {
                            sValue1 = "";
                        }
                        sOpDesc = (new StringBuilder()).append(sOpDesc).append(DataObject.getColumnAttribute(iColNo, "Header")).append("(").append(colNew.getActualName()).append(")\uFF1A").append("\u539F\u503C=").append(sValue1).append("\uFF0C\u65B0\u503C=").append(sParameterValue).append("\u3002   ").toString();
                    }
                    if(sChangeType.equals("2"))
                        sOpDesc = (new StringBuilder()).append(sOpDesc).append(DataObject.getColumnAttribute(iColNo, "Header")).append("(").append(colNew.getActualName()).append(")=").append(sParameterValue).append("   ").toString();
                }
            }
        } while(true);
        genRowsSql(vRowsUpdate, "Update", request);
        genRowsSql(vRowsInsert, "Insert", request);
        genRowsSql(vRowsDelete, "Delete", request);
        iReturn = 1;
        if(cSqlca.conn.getTransactionIsolation() == 0)
        {
            if(iDebugMode == 1)
                ARE.getLog().debug("Not Support Trans");
            executeRowsSql(vRowsUpdate, "Update", cSqlca);
            executeRowsSql(vRowsInsert, "Insert", cSqlca);
            executeRowsSql(vRowsDelete, "Delete", cSqlca);
            iReturn = -1;
        }
        if(iDebugMode == 1 && iTransMode == 1)
            ARE.getLog().debug(".......\u4E8B\u52A1\u5F00\u59CB");
        try
        {
            executeRowsSql(vRowsUpdate, "Update", cSqlca);
            executeRowsSql(vRowsInsert, "Insert", cSqlca);
            executeRowsSql(vRowsDelete, "Delete", cSqlca);
            if(iTransMode == 1)
                cSqlca.conn.commit();
            iReturn = 1;
            if(iDebugMode == 1 && iTransMode == 1)
                ARE.getLog().debug(".......\u4FDD\u5B58\u6210\u529F,\u6267\u884C\u4E8B\u52A1");
        }
        catch(Exception e)
        {
            if(iTransMode == 1)
                cSqlca.conn.rollback();
            iReturn = 0;
            if(iDebugMode == 1 && iTransMode == 1)
                ARE.getLog().debug(".......\u4FDD\u5B58\u5931\u8D25,\u56DE\u6EDA\u4E8B\u52A1");
            if(iDebugMode == 1 && iTransMode == 1)
                ARE.getLog().debug((new StringBuilder()).append("==========\u4E8B\u52A1\u5904\u7406\u5931\u8D25\u3002\u9519\u8BEF\u4FE1\u606F\uFF1A").append(e.getMessage()).append("========").toString());
            throw e;
        }
        return iReturn;
    }

	public String getSubString(String mystr, int mylendo) {
		if (mystr == null)
			return null;
		int mylen = mystr.length();
		if (mystr.substring(mylen - 1, mylen).equals(","))
			mystr = mystr.substring(0, mylen - 1);
		mylen--;
		if (mylendo >= mylen)
			return mystr;
		else
			return mystr.substring(0, mylendo - 1);
	}

	private int executeRowsSql(Vector vRows, String sEventName,
			Transaction Sqlca) throws Exception {
		String sBeforeScript = getEvent((new StringBuilder()).append("Before")
				.append(sEventName).toString());
		String sAfterScript = getEvent((new StringBuilder()).append("After")
				.append(sEventName).toString());
		int iRowsSize = vRows.size();
		for (int i = 0; i < iRowsSize; i++) {
			ASRow rowTemp = (ASRow) vRows.get(i);
			String sSql = rowTemp.RowDescribe;
			String sAuditSql = rowTemp.RowAuditStr;
			String sActualScript;
			if (!sBeforeScript.equals(""))
				if (interpreter == null) {
					Any aBeforeScriptResult = null;
					String sBeforeScriptResult = null;
					if (iDebugMode == 1)
						ARE.getLog().debug(
								(new StringBuilder()).append("Before...")
										.append(sBeforeScript).toString());
					sActualScript = pretreatScript(sBeforeScript, rowTemp);
					if (iDebugMode == 1)
						ARE.getLog().debug(
								(new StringBuilder()).append("Before...")
										.append(sActualScript).toString());
					aBeforeScriptResult = Expression.getExpressionValue(
							sActualScript, Sqlca);
					sBeforeScriptResult = aBeforeScriptResult.toStringValue();
					if (sBeforeScriptResult != null
							&& sBeforeScriptResult.equals("false"))
						continue;
				} else {
					Anything aBeforeScriptResult2006 = null;
					String sBeforeScriptResult = null;
					if (iDebugMode == 1)
						ARE.getLog().debug(
								(new StringBuilder()).append("Before...")
										.append(sBeforeScript).toString());
					sActualScript = pretreatScript(sBeforeScript, rowTemp);
					if (iDebugMode == 1)
						ARE.getLog().debug(
								(new StringBuilder()).append("Before...")
										.append(sActualScript).toString());
					aBeforeScriptResult2006 = interpreter.explain(Sqlca,
							sActualScript);
					sBeforeScriptResult = aBeforeScriptResult2006
							.toStringValue();
					if (sBeforeScriptResult != null
							&& sBeforeScriptResult.equals("false"))
						continue;
				}
			if (sAuditSql != null && sAuditSql.trim().length() > 0) {
				if (iDebugMode == 1)
					ARE.getLog().debug(
							(new StringBuilder()).append("Audit...")
									.append(sAuditSql).toString());
				Sqlca.executeSQL(sAuditSql);
			}
			//Auditor.getAuditor("com.amarsoft.Context.jbo").audit(rowTemp.auditRecord);
			if (iDebugMode == 1)
				ARE.getLog().debug(
						(new StringBuilder()).append(StringFunction.getNow())
								.append("... ").append(sSql).toString());
			try {
				if (!sSql.equals(""))
					Sqlca.executeSQL(sSql);
			} catch (Exception ex) {
				throw new Exception(
						(new StringBuilder())
								.append("\u6267\u884C\u7B2C")
								.append(i)
								.append("\u4E2A\u201C")
								.append(sEventName)
								.append("\u201D\u8BED\u53E5\u65F6\u51FA\u9519\u3002SQL\u8BED\u53E5\uFF1A")
								.append(sSql)
								.append("\u3002\u9519\u8BEF\u4FE1\u606F\uFF1A")
								.append(ex.getMessage()).toString());
			}
			if (sAfterScript.equals(""))
				continue;
			if (iDebugMode == 1)
				ARE.getLog()
						.debug((new StringBuilder())
								.append("--------AfterXXXX\uFF0C\u53C2\u6570\u66FF\u6362\u524D\uFF1A")
								.append(sAfterScript).toString());
			sActualScript = pretreatScript(sAfterScript, rowTemp);
			if (iDebugMode == 1)
				ARE.getLog()
						.debug((new StringBuilder())
								.append("--------AfterXXXX\uFF0C\u53C2\u6570\u66FF\u6362\u540E\uFF1A")
								.append(sActualScript).toString());
			if (interpreter == null)
				Expression.getExpressionValue(sActualScript, Sqlca);
			else
				interpreter.explain(Sqlca, sActualScript);
		}

		return 0;
	}

	private String pretreatScript(String sScript, ASRow rowTemp)
			throws Exception {
		int iSize = rowTemp.AllColumns.size();
		for (int i = 0; i < iSize; i++) {
			ASColumn columnTemp = (ASColumn) rowTemp.AllColumns.get(i);
			String sName = (new StringBuilder()).append("${")
					.append(columnTemp.getItemName()).append("}").toString();
			String sValue = columnTemp.getItemValue();
			sValue = StringFunction.replace(sValue, ",", "\uFF0C");
			sValue = StringFunction.replace(sValue, "!", "\uFF01");
			sScript = StringFunction.replace(sScript, sName, sValue);
		}

		iSize = rowTemp.ChangedColumns.size();
		for (int i = 0; i < iSize; i++) {
			ASColumn columnTemp = (ASColumn) rowTemp.ChangedColumns.get(i);
			String sName = (new StringBuilder()).append("#{")
					.append(columnTemp.getItemName()).append("}").toString();
			String sValue = columnTemp.getItemValue();
			sValue = StringFunction.replace(sValue, ",", "\uFF0C");
			sValue = StringFunction.replace(sValue, "!", "\uFF01");
			sScript = StringFunction.replace(sScript, sName, sValue);
		}

		iSize = rowTemp.AllColumns.size();
		for (int i = 0; i < iSize; i++) {
			ASColumn columnTemp = (ASColumn) rowTemp.AllColumns.get(i);
			String sName = (new StringBuilder()).append("#{")
					.append(columnTemp.getItemName()).append("}").toString();
			String sValue = columnTemp.getItemValue();
			sValue = StringFunction.replace(sValue, ",", "\uFF0C");
			sValue = StringFunction.replace(sValue, "!", "\uFF01");
			sScript = StringFunction.replace(sScript, sName, sValue);
		}

		sScript = StringFunction.replace(sScript, "\r\n", "\\r\\n");
		if (sScript.indexOf("#") >= 0)
			sScript = pretreatScriptOld(sScript, rowTemp);
		ARE.getLog().trace(
				(new StringBuilder()).append("Script after pretreat:")
						.append(sScript).toString());
		return sScript;
	}

	private String pretreatScriptOld(String sScript, ASRow rowTemp)
			throws Exception {
		int iSize = rowTemp.AllColumns.size();
		for (int i = 0; i < iSize; i++) {
			ASColumn columnTemp = (ASColumn) rowTemp.AllColumns.get(i);
			String sName = (new StringBuilder()).append("##")
					.append(columnTemp.getItemName()).toString();
			String sValue = columnTemp.getItemValue();
			sValue = StringFunction.replace(sValue, ",", "\uFF0C");
			sValue = StringFunction.replace(sValue, "!", "\uFF01");
			sValue = StringFunction.replace(sValue, "(", "\uFF08");
			sValue = StringFunction.replace(sValue, ")", "\uFF09");
			sScript = StringFunction.replace(sScript, sName, sValue);
		}

		iSize = rowTemp.ChangedColumns.size();
		for (int i = 0; i < iSize; i++) {
			ASColumn columnTemp = (ASColumn) rowTemp.ChangedColumns.get(i);
			String sName = (new StringBuilder()).append("#")
					.append(columnTemp.getItemName()).toString();
			String sValue = columnTemp.getItemValue();
			sValue = StringFunction.replace(sValue, ",", "\uFF0C");
			sValue = StringFunction.replace(sValue, "!", "\uFF01");
			sValue = StringFunction.replace(sValue, "(", "\uFF08");
			sValue = StringFunction.replace(sValue, ")", "\uFF09");
			sScript = StringFunction.replace(sScript, sName, sValue);
		}

		iSize = rowTemp.AllColumns.size();
		for (int i = 0; i < iSize; i++) {
			ASColumn columnTemp = (ASColumn) rowTemp.AllColumns.get(i);
			String sName = (new StringBuilder()).append("#")
					.append(columnTemp.getItemName()).toString();
			String sValue = columnTemp.getItemValue();
			sValue = StringFunction.replace(sValue, ",", "\uFF0C");
			sValue = StringFunction.replace(sValue, "!", "\uFF01");
			sValue = StringFunction.replace(sValue, "(", "\uFF08");
			sValue = StringFunction.replace(sValue, ")", "\uFF09");
			sScript = StringFunction.replace(sScript, sName, sValue);
		}

		sScript = StringFunction.replace(sScript, "\r\n", "\\r\\n");
		ARE.getLog().trace(
				(new StringBuilder()).append("Script after pretreat:")
						.append(sScript).toString());
		return sScript;
	}

	private void genRowsSql(Vector vRows, String sSqlType,
			HttpServletRequest request) throws Exception {
		int iRowsSize = vRows.size();
		for (int i = 0; i < iRowsSize; i++) {
			isAuditChanged = false;
			ASRow rowTemp = (ASRow) vRows.get(i);
			String sSql = genRowSql(rowTemp, DataObject.UpdateTable, sSqlType,
					request);
			rowTemp.RowDescribe = sSql;
			if (isAuditChanged
					&& !DataObject.AuditMode
							.equals(ASDataObject.AUDITMODE_NONE))
				rowTemp.RowAuditStr = genRowAuditSql(rowTemp,
						DataObject.UpdateTable, sSqlType,
						DataObject.AuditTable, DataObject.AuditMode);
			else
				rowTemp.RowAuditStr = null;
		}

	}

	private String genRowSql(ASRow rowTemp, String sTable, String sSqlType,
			HttpServletRequest request) throws Exception {
		String sSql = "";
		String sPart1 = "";
		String sPart2 = "";
		if (sSqlType.equalsIgnoreCase("Update")) {
			sPart1 = genSqlPart(rowTemp.ChangedColumns, "Update");
			sPart2 = genSqlPart(rowTemp.AllColumns, "Where");
			//rowTemp.auditRecord = createAuditRecord("UPDATE", rowTemp, request);
			if (sPart1.length() > 0) {
				sSql = (new StringBuilder()).append("update ").append(sTable)
						.append(" set ").append(sPart1).toString();
				if (sPart2.length() > 0)
					sSql = (new StringBuilder()).append(sSql).append(" where ")
							.append(sPart2).toString();
				else
					throw new Exception(
							(new StringBuilder())
									.append("ASDataWindow genUpdateSql Error:No Where Clause!")
									.append(sSql).toString());
			}
		} else if (sSqlType.equalsIgnoreCase("Insert")) {
			sPart1 = genSqlPart(rowTemp.ChangedColumns, "Insert");
			//rowTemp.auditRecord = createAuditRecord("CREATE", rowTemp, request);
			if (sPart1.length() > 0)
				sSql = (new StringBuilder()).append("insert into ")
						.append(sTable).append(" ").append(sPart1).toString();
		} else {
			isAuditChanged = true;
			sPart2 = genSqlPart(rowTemp.AllColumns, "Where");
			//rowTemp.auditRecord = createAuditRecord("DELETE", rowTemp, request);
			if (sPart2.length() > 0)
				sSql = (new StringBuilder()).append("delete from ")
						.append(sTable).append(" where ").append(sPart2)
						.toString();
			else
				throw new ASException(
						(new StringBuilder())
								.append("ASDataWindow genDeleteSql Error:No Where Clause!")
								.append(sSql).toString());
		}
		ARE.getLog().trace(sSql);
		sSql = replaceConstant(sSql);
		return sSql;
	}

	private String genRowAuditSql(ASRow rowTemp, String sTable,
			String sSqlType, String sAuditTable, String sAuditMode)
			throws Exception {
		String sSql = "";
		String sPartAudit = "";
		String sPartKeys = "";
		String sPartWhere = "";
		if (sAuditTable == null || sAuditTable.trim().length() == 0)
			return null;
		if (sSqlType.equalsIgnoreCase("Update")) {
			if (sAuditMode.equals(ASDataObject.AUDITMODE_UPDATE)
					|| sAuditMode.equals(ASDataObject.AUDITMODE_UPDATE_DELETE)) {
				sPartAudit = genSqlPart(rowTemp.ChangedColumns, "Audit");
				sPartKeys = genSqlPart(rowTemp.AllColumns, "Keys");
				sPartWhere = genSqlPart(rowTemp.AllColumns, "Where");
				if (sPartAudit.length() > 0 || sPartKeys.length() > 0) {
					sSql = (new StringBuilder())
							.append("insert into ")
							.append(sAuditTable)
							.append("(AuditRecordTime,AuditRecordType,AuditRecordOrg,AuditRecordUser")
							.append(sPartKeys).append(sPartAudit)
							.append(") select '")
							.append(StringFunction.getTodayNow()).append("','")
							.append(sSqlType).append("','")
							.append(DataObject.AuditOrg).append("','")
							.append(DataObject.AuditUser).append("'")
							.append(sPartKeys).append(sPartAudit)
							.append(" from ").append(sTable).toString();
					if (sPartWhere.length() > 0)
						sSql = (new StringBuilder()).append(sSql)
								.append(" where ").append(sPartWhere)
								.toString();
					else
						throw new Exception(
								(new StringBuilder())
										.append("ASDataWindow genUpdateAuditSql Error:No Where Clause!")
										.append(sSql).toString());
				}
			} else {
				return null;
			}
		} else {
			if (sSqlType.equalsIgnoreCase("Insert"))
				return null;
			if (sAuditMode.equals(ASDataObject.AUDITMODE_DELETE)
					|| sAuditMode.equals(ASDataObject.AUDITMODE_UPDATE_DELETE)) {
				sPartAudit = genSqlPart(rowTemp.AllColumns, "Audit");
				sPartKeys = genSqlPart(rowTemp.AllColumns, "Keys");
				sPartWhere = genSqlPart(rowTemp.AllColumns, "Where");
				if (sPartAudit.length() > 0 || sPartKeys.length() > 0) {
					sSql = (new StringBuilder())
							.append("insert into ")
							.append(sAuditTable)
							.append("(AuditRecordTime,AuditRecordType,AuditRecordOrg,AuditRecordUser")
							.append(sPartKeys).append(sPartAudit)
							.append(") select '")
							.append(StringFunction.getTodayNow()).append("','")
							.append(sSqlType).append("','")
							.append(DataObject.AuditOrg).append("','")
							.append(DataObject.AuditUser).append("'")
							.append(sPartKeys).append(sPartAudit)
							.append(" from ").append(sTable).toString();
					if (sPartWhere.length() > 0)
						sSql = (new StringBuilder()).append(sSql)
								.append(" where ").append(sPartWhere)
								.toString();
					else
						throw new Exception(
								(new StringBuilder())
										.append("ASDataWindow genDeleteAuditSql Error:No Where Clause!")
										.append(sSql).toString());
				}
			} else {
				return null;
			}
		}
		return sSql;
	}

	private String genSqlPart(Vector vColumns, String sPartType) {
		int iColumnsSize = vColumns.size();
		String sPart1 = "";
		String sPart2 = "";
		String sType = "";
		String sName = "";
		String sValue = "";
		String sKey = "";
		String sUpdateable = "";
		String sModifyed = "";
		String sAuditColumn = "";
		String sAuditable = "";
		String sUpdateWhere = DataObject.UpdateWhere;
		if (sPartType.equalsIgnoreCase("Update")) {
			for (int i = 0; i < iColumnsSize; i++) {
				ASColumn colTemp = (ASColumn) vColumns.get(i);
				sName = colTemp.getActualName();
				sType = colTemp.getItemType();
				sValue = colTemp.getItemValue();
				sUpdateable = colTemp.getAttribute("Updateable");
				sAuditable = colTemp.getAttribute("Auditable");
				if (sType.equalsIgnoreCase("Number")
						&& sValue.trim().equals(""))
					sValue = "null";
				if (sType.equalsIgnoreCase("String") && sValue != null
						&& sValue.indexOf("'") != 0)
					sValue = (new StringBuilder()).append("'").append(sValue)
							.append("'").toString();
				if (sUpdateable.equals("0"))
					continue;
				sPart1 = (new StringBuilder()).append(sPart1).append(",")
						.append(sName).append("=").append(sValue).toString();
				if (sAuditable.equals("1"))
					isAuditChanged = true;
			}

			if (sPart1.length() > 0)
				sPart1 = sPart1.substring(1);
		} else if (sPartType.equalsIgnoreCase("Where")) {
			for (int i = 0; i < iColumnsSize; i++) {
				ASColumn colTemp = (ASColumn) vColumns.get(i);
				sName = colTemp.getActualName();
				sKey = colTemp.getAttribute("Key");
				sModifyed = colTemp.getAttribute("Modifyed");
				sUpdateable = colTemp.getAttribute("Updateable");
				sValue = colTemp.getItemValue();
				sType = colTemp.getItemType();
				if (sType.equalsIgnoreCase("String") && sValue != null
						&& sValue.indexOf("'") != 0)
					sValue = (new StringBuilder()).append("'").append(sValue)
							.append("'").toString();
				if (sUpdateWhere.equals("1") && sKey.equals("1")
						|| sUpdateWhere.equals("2")
						&& (sKey.equals("1") || sUpdateable.equals("1"))
						|| sUpdateWhere.equals("3")
						&& (sKey.equals("1") || sModifyed.equals("1")))
					sPart1 = (new StringBuilder()).append(sPart1)
							.append(" and ").append(sName).append("=")
							.append(sValue).toString();
			}

			if (sPart1.length() > 0)
				sPart1 = sPart1.substring(4);
		} else if (sPartType.equalsIgnoreCase("Audit")) {
			for (int i = 0; i < iColumnsSize; i++) {
				ASColumn colTemp = (ASColumn) vColumns.get(i);
				sName = colTemp.getActualName();
				sType = colTemp.getItemType();
				sKey = colTemp.getAttribute("Key");
				sModifyed = colTemp.getAttribute("Modifyed");
				sUpdateable = colTemp.getAttribute("Updateable");
				sAuditColumn = colTemp.getAttribute("AuditColumn");
				if (!sUpdateable.equals("0")
						&& sAuditColumn.equals("1")
						&& (!sUpdateWhere.equals("1") || !sKey.equals("1"))
						&& (!sUpdateWhere.equals("2") || !sKey.equals("1")
								&& !sUpdateable.equals("1"))
						&& (!sUpdateWhere.equals("3") || !sKey.equals("1")
								&& !sModifyed.equals("1")))
					sPart1 = (new StringBuilder()).append(sPart1).append(",")
							.append(sName).toString();
			}

		} else if (sPartType.equalsIgnoreCase("Keys")) {
			for (int i = 0; i < iColumnsSize; i++) {
				ASColumn colTemp = (ASColumn) vColumns.get(i);
				sName = colTemp.getActualName();
				sKey = colTemp.getAttribute("Key");
				sModifyed = colTemp.getAttribute("Modifyed");
				sUpdateable = colTemp.getAttribute("Updateable");
				sAuditColumn = colTemp.getAttribute("AuditColumn");
				if (sUpdateWhere.equals("1") && sKey.equals("1")
						|| sUpdateWhere.equals("2")
						&& (sKey.equals("1") || sUpdateable.equals("1"))
						|| sUpdateWhere.equals("3")
						&& (sKey.equals("1") || sModifyed.equals("1")))
					sPart1 = (new StringBuilder()).append(sPart1).append(",")
							.append(sName).toString();
			}

		} else {
			for (int i = 0; i < iColumnsSize; i++) {
				ASColumn colTemp = (ASColumn) vColumns.get(i);
				sName = colTemp.getActualName();
				sType = colTemp.getItemType();
				sValue = colTemp.getItemValue();
				sUpdateable = colTemp.getAttribute("Updateable");
				if (sUpdateable.equals("0"))
					continue;
				if (sType.equalsIgnoreCase("Number")
						&& sValue.trim().equals(""))
					sValue = "null";
				if (sType.equalsIgnoreCase("String") && sValue != null
						&& sValue.indexOf("'") != 0)
					sValue = (new StringBuilder()).append("'").append(sValue)
							.append("'").toString();
				sPart1 = (new StringBuilder()).append(sPart1).append(",")
						.append(sName).toString();
				sPart2 = (new StringBuilder()).append(sPart2).append(",")
						.append(sValue).toString();
			}

			if (sPart1.length() > 0)
				sPart1 = sPart1.substring(1);
			if (sPart2.length() > 0)
				sPart2 = sPart2.substring(1);
			sPart1 = (new StringBuilder()).append("(").append(sPart1)
					.append(") values (").append(sPart2).append(")").toString();
		}
		return sPart1;
	}

	private int getRowIndex(Vector vRows, String sRowNo) {
		int iSize = vRows.size();
		for (int i = 0; i < iSize; i++)
			if (((ASRow) vRows.get(i)).RowNo.equals(sRowNo))
				return i;

		return -1;
	}

	private ASRow getRow(Vector vRows, int iIndex) {
		if (iIndex >= 0)
			return (ASRow) vRows.get(iIndex);
		else
			return null;
	}

	private int addRow(Vector vRows, String sRowNo) {
		int iRowIndex = getRowIndex(vRows, sRowNo);
		if (iRowIndex == -1) {
			vRows.addElement(new ASRow(sRowNo));
			return vRows.size() - 1;
		} else {
			return iRowIndex;
		}
	}

	public boolean setEvent(String sEventName, String sEventScript) {
		return StringFunction.setAttribute(Events, sEventName, sEventScript);
	}

	public String getEvent(String sEventName) {
		return StringFunction.getAttribute(Events, sEventName);
	}

	public void setHarborTemplate(String sHtmlTemplate) throws Exception {
		harbor.setHtmlTemplate(sHtmlTemplate);
	}

	public void setHarborTemplate(Transaction Sqlca, String sHarborTemplateID)
			throws Exception {
		String sHtmlTemplateParts[][] = Sqlca
				.getStringMatrix((new StringBuilder())
						.append("select RelativeCode,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5 from CODE_LIBRARY where CodeNo='DWHarborTemplate' and ItemNo='")
						.append(sHarborTemplateID).append("'").toString());
		String sHtmlTemplate = "";
		if (sHtmlTemplateParts == null || sHtmlTemplateParts.length < 1)
			throw new Exception(
					(new StringBuilder())
							.append("\u6CA1\u6709\u627E\u5230\u6307\u5B9A\u7684dw\u6A21\u7248:")
							.append(sHarborTemplateID)
							.append(" (from CODE_LIBRARY where CodeNo='DWHarborTemplate')")
							.toString());
		for (int i = 0; i < sHtmlTemplateParts[0].length; i++)
			sHtmlTemplate = (new StringBuilder())
					.append(sHtmlTemplate)
					.append(DataConvert.toString(sHtmlTemplateParts[0][i])
							.trim()).toString();

		harbor.setHtmlTemplate(sHtmlTemplate);
	}

	public String getDockingScript() throws Exception {
		int iCol = DataObject.Columns.size();
		StringBuffer sbTmp = new StringBuffer("");
		sbTmp.append("i = DZ.length-1;");
		sbTmp.append("arrangements[i] = new Array();\r\n");
		for (int i = 0; i < iCol; i++) {
			sbTmp.append((new StringBuilder()).append("arrangements[i][").append(i).append("]=new Array(").toString());
			sbTmp.append((new StringBuilder()).append(i).append(",").toString());
			String sDockOptions = DataObject.getColumnAttribute(i,"DockOptions");
			if (sDockOptions == null || sDockOptions.equals("")) {
				sbTmp.append("'${DOCK:default}','','','',''");
			} else {
				String sDockID = DataConvert.toString(StringFunction.getProfileString(sDockOptions, "DockID"));
				if (sDockID == null || sDockID.equals(""))
					sDockID = "default";
				sbTmp.append((new StringBuilder()).append("'${DOCK:").append(sDockID).append("}',").toString());
				sbTmp.append((new StringBuilder())
						.append("'")
						.append(DataConvert.toString(StringFunction.getProfileString(sDockOptions, "ColSpan")))
						.append("',").toString());
				sbTmp.append((new StringBuilder())
						.append("'")
						.append(DataConvert.toString(StringFunction.getProfileString(sDockOptions, "PositionType")))
						.append("',").toString());
				sbTmp.append((new StringBuilder())
						.append("'")
						.append(DataConvert.toString(StringFunction.getProfileString(sDockOptions,"BlankColsAhead")))
						.append("',").toString());
				sbTmp.append((new StringBuilder())
						.append("'")
						.append(DataConvert.toString(StringFunction.getProfileString(sDockOptions,"BlankColsAfter")))
						.append("'").toString());
			}
			sbTmp.append(");\r\n");
		}
		sbTmp.append("i = DZ.length-1;\r\n");
		sbTmp.append("harbors[i] = new Array();\r\n");
		sbTmp.append((new StringBuilder()).append("harbors[i][0] = '").append(harbor.id).append("';\r\n").toString());
		sbTmp.append((new StringBuilder())
				.append("harbors[i][1] = new Array('").append(harbor.id)
				.append("','").append(harbor.name).append("','")
				.append(SpecialTools.real2Amarsoft(harbor.getHtmlTemplate()))
				.append("');\r\n").toString());
		sbTmp.append("harbors[i][2] = new Array();\r\n");
		for (int i = 0; i < harbor.docksCount(); i++)
			sbTmp.append((new StringBuilder())
					.append("harbors[i][2][")
					.append(i)
					.append("]=new Array('${DOCK:")
					.append(harbor.getDock(i).id)
					.append("}',")
					.append("'")
					.append(harbor.getDock(i).name)
					.append("',")
					.append("'")
					.append(harbor.getDock(i).getAttribute("TableWidth"))
					.append("',")
					.append("'")
					.append(harbor.getDock(i).getAttribute("TableAttribute"))
					.append("',")
					.append("'")
					.append(harbor.getDock(i).getAttribute("TotalColumns"))
					.append("',")
					.append("'")
					.append(harbor.getDock(i).getAttribute("DefaultColspan"))
					.append("',")
					.append("'")
					.append(harbor.getDock(i).getAttribute(
							"DefaultColspanForLongType")).append("',")
					.append("'")
					.append(harbor.getDock(i).getAttribute("DefaultPosition"))
					.append("');\r\n").toString());

		return sbTmp.toString();
	}

	public static String amarMoney2(String sValue, int iCheckFormat) {
		if (sValue == null || sValue.equals(""))
			return "";
		if (iCheckFormat == 2 || iCheckFormat == 5 || iCheckFormat > 10) {
			NumberFormat nf = NumberFormat.getInstance();
			if (iCheckFormat == 2) {
				nf.setMinimumFractionDigits(2);
				nf.setMaximumFractionDigits(2);
			} else if (iCheckFormat == 5) {
				nf.setMinimumFractionDigits(0);
				nf.setMaximumFractionDigits(0);
			} else {
				nf.setMinimumFractionDigits(iCheckFormat - 10);
				nf.setMaximumFractionDigits(iCheckFormat - 10);
			}
			return nf.format(Double.valueOf(sValue).doubleValue());
		} else {
			return sValue;
		}
	}

	public Vector genHTMLAll(String s, int iRows) throws Exception {
		int i = 0;
		int j = 0;
		int colSize = DataObject.Columns.size();
		Vector vector = new Vector();
		vector.add("<HTML leftmargin='0' topmargin='0'>");
		vector.add("<HEAD>");
		vector.add("<META HTTP-EQUIV=\\\"Content-Type\\\" CONTENT=\\\"text/html; charset=gb_2312-80\\\">");
		vector.add("<STYLE>");
		vector.add(".inputstring {border-style:none;border-width:thin;border-color:#e9e9e9}");
		vector.add(".table {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}");
		vector.add(".td  {  font-family:\u5B8B\u4F53; font-size: 9pt; text-decoration: none; border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}");
		vector.add("td   {  font-family:\u5B8B\u4F53; font-size: 9pt; text-decoration: none; }");
		vector.add(".tdH {  font-family:\u5B8B\u4F53; font-size: 9pt; text-decoration: none; background-color:#B4B4B4; }");
		vector.add(".tdV {  font-family:\u5B8B\u4F53; font-size: 9pt; text-decoration: none; }");
		vector.add(".tdS {  font-family:\u5B8B\u4F53; font-size: 9pt; text-decoration: none; background-color:#CCCCCC; }");
		vector.add(".inputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}");
		vector.add(".pt16songud{font-family: '\u9ED1\u4F53','\u5B8B\u4F53';font-size: 16pt;font-weight:bold;text-decoration: none}");
		vector.add(".myfont{font-family: '\u9ED1\u4F53','\u5B8B\u4F53';font-size: 9pt;font-weight:bold;text-decoration: none}");
		vector.add("</STYLE>");
		vector.add("</HEAD>");
		vector.add("<BODY bgcolor='#DEDFCE' >    ");
		if (Style.equals("1")) {
			String as[][] = new String[colSize][22];
			String myAlign2[] = { "", "left", "center", "right" };
			double mytj[] = new double[colSize];
			for (j = 0; j < colSize; j++)
				mytj[j] = 0.0D;

			for (int l = 0; l < colSize; l++) {
				as[l][0] = DataObject.getColumnAttribute(l, "Header");
				as[l][2] = DataObject.getColumnAttribute(l, "Visible");
				as[l][8] = DataObject.getColumnAttribute(l, "Align");
				as[l][12] = DataObject.getColumnAttribute(l, "CheckFormat");
				as[l][14] = DataObject.getColumnAttribute(l, "ColumnType");
				as[l][17] = DataObject.getColumnAttribute(l, "Unit");
				as[l][21] = DataObject.getColumnAttribute(l, "Type");
				if (as[l][12] != null
						&& (as[l][12].equals("2") || as[l][12].equals("5") || Integer
								.valueOf(as[l][12]).intValue() > 10))
					as[l][21] = "Number";
			}

			vector.add("<table align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF>");
			vector.add("<TBODY>");
			vector.add("<TR bgColor=#cccccc height=24>");
			vector.add("<TD nowrap class=tdH noWrap width=30 align=middle>\u5E8F\u53F7</TD>");
			for (i = 0; i < colSize; i++)
				if (!as[i][2].equals("0"))
					vector.add((new StringBuilder())
							.append("<TD nowrap class=tdH align=middle >")
							.append(as[i][0]).append(as[i][17]).append("</TD>")
							.toString());

			vector.add("</TR>");
			j = 0;
			ASResultSet LSResultSet;
			for (LSResultSet = retrieve(sArgumentValue); LSResultSet.next()
					&& j < iRows; j++) {
				vector.add("<tr>");
				vector.add((new StringBuilder())
						.append("<TD nowrap   bgcolor=#E4E4E4 noWrap align=right width=35 ><font style='font-size:9pt'>")
						.append(j + 1).append("</font></TD>").toString());
				for (int k1 = 0; k1 < colSize; k1++) {
					if (as[k1][2].equals("0"))
						continue;
					String s6 = LSResultSet.getString(k1 + 1);
					if (s6 != null) {
						s6 = StringX.trimEnd(s6);
						s6 = StringFunction.replace(s6, "\\", "\\\\");
						s6 = StringFunction.replace(s6, "\\\\r\\\\n", "\\r\\n");
						s6 = StringFunction.replace(s6, "\"", "\\\"");
					}
					if (LSResultSet.wasNull())
						s6 = "";
					if (as[k1][21].equalsIgnoreCase("String"))
						s6 = (new StringBuilder()).append("&nbsp;").append(s6)
								.append("").toString();
					else if (as[k1][21].equalsIgnoreCase("Number")
							&& s6.equals(""))
						s6 = "";
					int ii = Integer.valueOf(as[k1][8]).intValue();
					if (ii > 1)
						vector.add((new StringBuilder())
								.append("<td nowrap align=")
								.append(myAlign2[ii])
								.append(" >")
								.append(amarMoney2(s6,
										Integer.valueOf(as[k1][12]).intValue()))
								.append("</td>").toString());
					else
						vector.add((new StringBuilder())
								.append("<td nowrap >")
								.append(amarMoney2(s6,
										Integer.valueOf(as[k1][12]).intValue()))
								.append("</td>").toString());
				}

				vector.add("</tr>");
			}

			vector.add("</TBODY>");
			vector.add("</TABLE>");
			vector.add("</BODY>");
			vector.add("</HTML>");
			LSResultSet.getStatement().close();
		}
		return vector;
	}

	public void setRightType() throws Exception {
		if (CurComp != null) {
			String sCompRightType = CurComp.getParameter("RightType", 10);
			if (sCompRightType != null && sCompRightType.equals("ReadOnly"))
				ReadOnly = "1";
		}
	}

	public String replaceConstant(String _source) throws Exception {
		String sReturn = _source;
		ASValuePool constants = new ASValuePool();
		constants.setAttribute("TODAY", StringFunction.getToday());
		constants.setAttribute("NOW", StringFunction.getNow());
		constants.setAttribute("TODAYNOW", StringFunction.getTodayNow());
		sReturn = AmarScript.forceMacroReplace(constants, sReturn, "[$", "$]");
		return sReturn;
	}

	public byte[] str2byte(String s) throws UnsupportedEncodingException {
		return s.getBytes("GBK");
	}

	public static void ZipFiles(String fs[], String zipFileName) {
		try {
			if (0 == zipFileName.length())
				zipFileName = "myzip";
			FileOutputStream f = new FileOutputStream(zipFileName);
			CheckedOutputStream cs = new CheckedOutputStream(f, new CRC32());
			ZipOutputStream out = new ZipOutputStream(new BufferedOutputStream(
					cs));
			ARE.getLog()
					.debug((new StringBuilder())
							.append("\u5BF9\u591A\u6587\u4EF6\u8FDB\u884C\u538B\u7F29:")
							.append(fs.length).toString());
			for (int i = 0; i < fs.length; i++) {
				ARE.getLog().debug(
						(new StringBuilder()).append("Write file ")
								.append(fs[i]).toString());
				BufferedReader in = new BufferedReader(new FileReader(fs[i]));
				out.putNextEntry(new ZipEntry(fs[i]));
				for (String c = new String(); (c = in.readLine()) != null;) {
					c = (new StringBuilder()).append(c).append(" ").toString();
					out.write(c.getBytes());
				}

				in.close();
			}

			out.close();
			ARE.getLog().debug(
					(new StringBuilder()).append("Checksum::")
							.append(cs.getChecksum().getValue()).toString());
		} catch (Exception e) {
			ARE.getLog().error("ZipFiles error!", e);
		}
	}

	public static void ZipFileEx(String FilePath, String FileName,
			String ZipFileName) throws IOException {
		String sSlash = "\\";
		if (FilePath.indexOf("/") >= 0)
			sSlash = "/";
		if (!sSlash.equals(FilePath.substring(FilePath.length() - 1)))
			FilePath = (new StringBuilder()).append(FilePath).append(sSlash)
					.toString();
		ZipOutputStream os = new ZipOutputStream(new FileOutputStream(
				ZipFileName));
		ZipEntry ze = new ZipEntry(FileName);
		ze.setMethod(8);
		os.putNextEntry(ze);
		FileInputStream fs = new FileInputStream(FilePath.concat(FileName));
		byte buff[] = new byte[1024];
		for (int n = 0; (n = fs.read(buff, 0, buff.length)) > 0;)
			os.write(buff, 0, n);

		fs.close();
		os.closeEntry();
		os.close();
	}

	public String genHTMLAllEx(HttpServletRequest request, String s, int iRows)
			throws Exception {
		ASConfigure curConfig = ASConfigure.getASConfigure();
		if (curConfig == null)
			throw new Exception(
					"\u8BFB\u53D6\u914D\u7F6E\u6587\u4EF6\u9519\u8BEF\uFF01\u8BF7\u68C0\u67E5\u5BF9\u5E94xml\u6587\u4EF6");
		String sPath = curConfig.getConfigure("DWDownloadFilePath");
		if (sPath == null)
			sPath = "/tmp/DownLoad";
		File dFile = new File(sPath);
		if (!dFile.exists())
			dFile.mkdirs();
		SimpleDateFormat sdf_temp = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
		String sNow = sdf_temp.format(new Date());
		String sSourceName = (new StringBuilder()).append(sNow).append(".xls").toString();
		String sFileName = (new StringBuilder()).append(sPath).append("/").append(sNow).append(".xls").toString();
		String sFileZipName = (new StringBuilder()).append(sPath).append("/").append(sNow).append(".zip").toString();
		File file = new File(sFileName);
		FileOutputStream fileOut = new FileOutputStream(file);
		int i = 0;
		int j = 0;
		int colSize = DataObject.Columns.size();
		fileOut.write(str2byte("<HTML leftmargin='0' topmargin='0'>"));
		fileOut.write(str2byte("<HEAD>"));
		fileOut.write(str2byte("<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=gb_2312-80\">"));
		fileOut.write(str2byte("<STYLE>"));
		fileOut.write(str2byte(".inputstring {border-style:none;border-width:thin;border-color:#e9e9e9}"));
		fileOut.write(str2byte(".table {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}"));
		fileOut.write(str2byte(".td  {  font-family:\u5B8B\u4F53; font-size: 9pt; text-decoration: none; border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}"));
		fileOut.write(str2byte("td   {  font-family:\u5B8B\u4F53; font-size: 9pt; text-decoration: none; }"));
		fileOut.write(str2byte(".tdH {  font-family:\u5B8B\u4F53; font-size: 9pt; text-decoration: none; background-color:#B4B4B4; }"));
		fileOut.write(str2byte(".tdV {  font-family:\u5B8B\u4F53; font-size: 9pt; text-decoration: none; }"));
		fileOut.write(str2byte(".tdS {  font-family:\u5B8B\u4F53; font-size: 9pt; text-decoration: none; background-color:#CCCCCC; }"));
		fileOut.write(str2byte(".inputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}"));
		fileOut.write(str2byte(".pt16songud{font-family: '\u9ED1\u4F53','\u5B8B\u4F53';font-size: 16pt;font-weight:bold;text-decoration: none}"));
		fileOut.write(str2byte(".myfont{font-family: '\u9ED1\u4F53','\u5B8B\u4F53';font-size: 9pt;font-weight:bold;text-decoration: none}"));
		fileOut.write(str2byte("</STYLE>"));
		fileOut.write(str2byte("</HEAD>"));
		fileOut.write(str2byte("<BODY bgcolor='#DEDFCE' >    "));
		if (Style.equals("1")) {
			String as[][] = new String[colSize][22];
			String myAlign2[] = { "", "left", "center", "right" };
			double mytj[] = new double[colSize];
			for (j = 0; j < colSize; j++)
				mytj[j] = 0.0D;

			for (int l = 0; l < colSize; l++) {
				as[l][0] = DataObject.getColumnAttribute(l, "Header");
				as[l][2] = DataObject.getColumnAttribute(l, "Visible");
				as[l][8] = DataObject.getColumnAttribute(l, "Align");
				as[l][12] = DataObject.getColumnAttribute(l, "CheckFormat");
				as[l][14] = DataObject.getColumnAttribute(l, "ColumnType");
				as[l][17] = DataObject.getColumnAttribute(l, "Unit");
				as[l][21] = DataObject.getColumnAttribute(l, "Type");
				if (as[l][12] != null
						&& (as[l][12].equals("2") || as[l][12].equals("5") || Integer
								.valueOf(as[l][12]).intValue() > 10))
					as[l][21] = "Number";
			}

			fileOut.write(str2byte("<table align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF>"));
			fileOut.write(str2byte("<TBODY>"));
			fileOut.write(str2byte("<TR bgColor=#cccccc height=24>"));
			fileOut.write(str2byte("<TD nowrap class=tdH noWrap width=30 align=middle>ÐòºÅ</TD>"));
			System.out.println("\u5E8F\u53F7"+"@\u5408\u8BA1");
			for (i = 0; i < colSize; i++)
				if (!as[i][2].equals("0"))
					fileOut.write(str2byte((new StringBuilder())
							.append("<TD nowrap class=tdH align=middle >")
							.append(as[i][0]).append(as[i][17]).append("</TD>")
							.toString()));

			fileOut.write(str2byte("</TR>"));
			j = 0;
			ASResultSet LSResultSet;
			for (LSResultSet = retrieve(sArgumentValue); LSResultSet.next()
					&& j < iRows; j++) {
				fileOut.write(str2byte("<tr>"));
				fileOut.write(str2byte((new StringBuilder())
						.append("<TD nowrap   bgcolor=#E4E4E4 noWrap align=right width=35 ><font style='font-size:9pt'>")
						.append(j + 1).append("</font></TD>").toString()));
				for (int k1 = 0; k1 < colSize; k1++) {
					if (as[k1][2].equals("0"))
						continue;
					String s6 = LSResultSet.getString(k1 + 1);
					if (s6 != null) {
						s6 = StringX.trimEnd(s6);
						s6 = StringFunction.replace(s6, "\\", "\\\\");
						s6 = StringFunction.replace(s6, "\\\\r\\\\n", "\\r\\n");
						s6 = StringFunction.replace(s6, "\"", "\\\"");
					}
					if (LSResultSet.wasNull())
						s6 = "";
					if (as[k1][21].equalsIgnoreCase("String")) {
						if (as[k1][12] != null
								&& (as[k1][12].equals("3") || as[k1][12]
										.equals("4")))
							s6 = s6;
						else
							s6 = (new StringBuilder()).append("&nbsp;")
									.append(s6).append("").toString();
					} else if (as[k1][21].equalsIgnoreCase("Number")
							&& s6.equals(""))
						s6 = "";
					int ii = Integer.valueOf(as[k1][8]).intValue();
					if (ii > 1)
						fileOut.write(str2byte((new StringBuilder())
								.append("<td nowrap align=")
								.append(myAlign2[ii])
								.append(" >")
								.append(amarMoney2(s6,
										Integer.valueOf(as[k1][12]).intValue()))
								.append("</td>").toString()));
					else
						fileOut.write(str2byte((new StringBuilder())
								.append("<td nowrap >")
								.append(amarMoney2(s6,
										Integer.valueOf(as[k1][12]).intValue()))
								.append("</td>").toString()));
					if (!as[k1][14].equals("1"))
						mytj[k1] += LSResultSet.getDouble(k1 + 1);
				}

				fileOut.write(str2byte("</tr>"));
			}

			if (ShowSummary.equals("1")) {
				fileOut.write(str2byte("<tr>"));
				fileOut.write(str2byte("<td nowrap align=right >\u5408\u8BA1</td>"));
				for (i = 0; i < colSize; i++) {
					if (as[i][2].equals("0"))
						continue;
					if (j > 0) {
						int ii = Integer.valueOf(as[i][8]).intValue();
						if (as[i][14].equals("2")) {
							fileOut.write(str2byte((new StringBuilder())
									.append("<td nowrap  align=")
									.append(myAlign2[ii])
									.append(" >")
									.append(amarMoney2(String.valueOf(mytj[i]),
											Integer.valueOf(as[i][12])
													.intValue()))
									.append("</td>").toString()));
							continue;
						}
						if (as[i][14].equals("3")) {
							fileOut.write(str2byte((new StringBuilder())
									.append("<td nowrap  align=")
									.append(myAlign2[ii])
									.append(" >")
									.append(amarMoney2(String.valueOf(mytj[i]
											/ (double) j), 2)).append("</td>")
									.toString()));
							continue;
						}
						if (as[i][14].equals("4"))
							fileOut.write(str2byte((new StringBuilder())
									.append("<td nowrap  align=")
									.append(myAlign2[ii]).append(" >")
									.append(amarMoney2(String.valueOf(j), 5))
									.append("</td>").toString()));
						else
							fileOut.write(str2byte("<td nowrap  >&nbsp;</td>"));
					} else {
						fileOut.write(str2byte("<td nowrap  >&nbsp;</td>"));
					}
				}

				fileOut.write(str2byte("</tr>"));
			}
			fileOut.write(str2byte("</TBODY>"));
			fileOut.write(str2byte("</TABLE>"));
			fileOut.write(str2byte("</BODY>"));
			fileOut.write(str2byte("</HTML>"));
			LSResultSet.getStatement().close();
		}
		fileOut.close();
		ZipFileEx(sPath, sSourceName, sFileZipName);
		return sFileZipName;
	}

	public String Name;
	public int Width;
	public int Height;
	public ASDataObject DataObject;
	public Transaction Sqlca;
	public String Style;
	public String HTMLStyle;
	public String ReadOnly;
	public String ShowSummary;
	public String ArrayName;
	public String Events[][] = { { "BeforeInsert", "" }, { "AfterInsert", "" },
			{ "BeforeDelete", "" }, { "AfterDelete", "" },
			{ "BeforeUpdate", "" }, { "AfterUpdate", "" } };
	public ASDataWindowHarbor harbor;
	public static int iChange = 0;
	public static int iDebugMode = 0;
	public static int iTransMode = 1;
	public boolean bSaveLog;
	public static int iMaxRows = 1000000;
	public boolean bFirstInvoke;
	public int iPageSize;
	public int iRowCount;
	public int iPageCount;
	public int iCurPage;
	public ASComponent CurComp;
	public ASPage CurPage;
	public String sArgumentValue;
	public AmarInterpreter interpreter;
	private boolean isAuditChanged;
	private String sSortField;
	private String sSortOrder;
	public ASColumn ascSortField;
	private String sDataSourceName;

}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 437 ms
	Jad reported messages/errors:
Overlapped try statements detected. Not all exception handlers will be resolved in the method update
Couldn't fully decompile method update
Couldn't resolve all exception handlers in method update
	Exit status: 0
	Caught exceptions:
*/