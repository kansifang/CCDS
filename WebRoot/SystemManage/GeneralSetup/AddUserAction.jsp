<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: 		bliu 2004.12.19
 * Tester:
 * Content: 	������Ա����
 * Input Param:
 *              UserID   : ��Ա���
 *				OrgID    : �������
 *
 * Output param:    
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open����window_open

	String sUserID   = DataConvert.toRealString(iPostChange,(String)request.getParameter("UserID"));
	String sOrgID   = DataConvert.toRealString(iPostChange,(String)request.getParameter("OrgID"));   
	 
    Sqlca.executeSQL("update USER_INFO set BelongOrg='"+sOrgID+"',Status='1' where UserID='"+sUserID+"' " );
%>
<script language=javascript>
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>