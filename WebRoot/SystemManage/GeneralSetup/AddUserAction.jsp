<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: 		bliu 2004.12.19
 * Tester:
 * Content: 	引入人员操作
 * Input Param:
 *              UserID   : 人员编号
 *				OrgID    : 机构编号
 *
 * Output param:    
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window_open

	String sUserID   = DataConvert.toRealString(iPostChange,(String)request.getParameter("UserID"));
	String sOrgID   = DataConvert.toRealString(iPostChange,(String)request.getParameter("OrgID"));   
	 
    Sqlca.executeSQL("update USER_INFO set BelongOrg='"+sOrgID+"',Status='1' where UserID='"+sUserID+"' " );
%>
<script language=javascript>
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>