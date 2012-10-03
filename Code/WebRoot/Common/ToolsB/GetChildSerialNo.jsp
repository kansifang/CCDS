<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: lpzhang 2009-8-8 
 * Tester:
 *
 * Content: ��ȡ��Э����ˮ��
 * Input Param:
 *			����:	TableName
 *			����:	ColumnName
 * Output param:
 *		  ��ˮ��:	SerialNo
 *
 * History Log:
 *
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>������к�</title>

<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open����window.open
	//��ȡ�����������͸�ʽ
	String	sTableName		 = DataConvert.toRealString(iPostChange,(String)request.getParameter("TableName"));
	String	sColumnName 	 = DataConvert.toRealString(iPostChange,(String)request.getParameter("ColumnName"));
	String  sObjectNo			 = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	if(sTableName == null) sTableName="";
	if(sColumnName == null) sColumnName="";
	if(sObjectNo == null) sObjectNo="";

	String	sSerialNo = "",maxSerialNo=""; //��ˮ��
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
