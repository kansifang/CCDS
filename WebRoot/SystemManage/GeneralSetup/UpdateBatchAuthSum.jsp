<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: zwhu
 * Tester:
 *
 * Content: ������Ȩ
 * Input Param:
 *			
 *
 * History Log:
 *
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>������Ȩ</title>

<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open����window.open
	
	String	sOrgIDArr = DataConvert.toRealString(iPostChange,(String)request.getParameter("OrgIDArr"));
	String	sBusinessTypeArr = DataConvert.toRealString(iPostChange,(String)request.getParameter("BusinessTypeArr"));
	String	sRoleIDArr = DataConvert.toRealString(iPostChange,(String)request.getParameter("RoleIDArr"));
	String  sSetUnit = DataConvert.toRealString(iPostChange,(String)request.getParameter("SetUnit"));

	if (sOrgIDArr == null) sOrgIDArr="";
	if (sBusinessTypeArr == null) sBusinessTypeArr = "";
	if (sRoleIDArr == null) sRoleIDArr = "";
	if (sSetUnit == null) sSetUnit = "";
	int updateItems = 0;
	updateItems = Sqlca.executeSQL("update Org_Auth set "+sSetUnit+",UpdateDate ='"+StringFunction.getToday()+"' where OrgID in ("+sOrgIDArr+") and BusinessType in ("+sBusinessTypeArr+") and roleid in ("+sRoleIDArr+") ");
	
%>

<script language=javascript>
	self.returnValue = "<%=updateItems%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
