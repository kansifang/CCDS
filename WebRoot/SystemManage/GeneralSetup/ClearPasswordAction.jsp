<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:  ndeng 2005.04.04
 * Tester:
 *
 * Content: ��ʼ����ǰ�û����룺1
 * Input Param: 
 * 			 UserID��      ����ѡ�û����롣
 * Output param:
 *
 *
 * History Log:  
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sUserID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sPassword = MessageDigest.getDigestAsUpperHexString("MD5", "oooo0000");
    String sSql = "update user_info set password='"+sPassword+"' where userid='"+sUserID+"'";
    Sqlca.executeSQL(sSql);
%>
<script language=javascript>
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>