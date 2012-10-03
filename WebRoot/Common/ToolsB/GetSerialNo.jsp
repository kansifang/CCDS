<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: ZYWei 2003.8.17
 * Tester:
 *
 * Content: ��ȡ��ˮ��
 * Input Param:
 *			����:	TableName
 *			����:	ColumnName
 			��ʽ��	SerialNoFormate
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
	String	sSerialNoFormate = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNoFormate"));
	String  sPrefix			 = DataConvert.toRealString(iPostChange,(String)request.getParameter("Prefix"));

	if (sSerialNoFormate == null) sSerialNoFormate="";
	if (sPrefix == null) sPrefix = "";

	String	sSerialNo = ""; //��ˮ��

	if(sSerialNoFormate.equals(""))
	{
		if (sPrefix.equals(""))	sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,Sqlca);
		else sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,sPrefix,Sqlca);

	}else
	{
		sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,sSerialNoFormate,Sqlca);
	}
%>

<script language=javascript>
	self.returnValue = "<%=sSerialNo%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>