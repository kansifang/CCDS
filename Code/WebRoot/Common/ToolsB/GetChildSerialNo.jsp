<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: lpzhang 2009-8-8 
 * Tester:
 *
 * Content: 获取子协议流水号
 * Input Param:
 *			表名:	TableName
 *			列名:	ColumnName
 * Output param:
 *		  流水号:	SerialNo
 *
 * History Log:
 *
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>获得序列号</title>

<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window.open
	//获取表名、列名和格式
	String	sTableName		 = DataConvert.toRealString(iPostChange,(String)request.getParameter("TableName"));
	String	sColumnName 	 = DataConvert.toRealString(iPostChange,(String)request.getParameter("ColumnName"));
	String  sObjectNo			 = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	if(sTableName == null) sTableName="";
	if(sColumnName == null) sColumnName="";
	if(sObjectNo == null) sObjectNo="";

	String	sSerialNo = "",maxSerialNo=""; //流水号
	String  sSql = "";
	String index = "";
	DecimalFormat decimalformat = new DecimalFormat("00");
	
	sSql = "select Max(SerialNo) from "+sTableName+" where ObjectNo ='"+sObjectNo+"'";
	maxSerialNo = Sqlca.getString(sSql);
	if(maxSerialNo == null) maxSerialNo = "";
	if(!"".equals(maxSerialNo))
	{
		index = decimalformat.format(Integer.parseInt(maxSerialNo.substring(maxSerialNo.length()-2,maxSerialNo.length())) + 1);
	}else
	{
		index = "01";
	}
	sSerialNo = sObjectNo + index;
	
%>
<script language=javascript>
	self.returnValue = "<%=sSerialNo%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
