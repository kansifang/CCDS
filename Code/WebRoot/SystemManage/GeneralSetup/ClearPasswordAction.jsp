<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:  ndeng 2005.04.04
 * Tester:
 *
 * Content: 初始化当前用户密码：1
 * Input Param: 
 * 			 UserID：      －所选用户代码。
 * Output param:
 *
 *
 * History Log:  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%  
    String sUserID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
    MD5 md5 = new MD5();
	String sPassword = md5.getMD5ofStr("000000als6");
    String sSql = "update user_info set password='"+sPassword+"' where userid='"+sUserID+"'";
    Sqlca.executeSQL(sSql);	
%>
<script language=javascript>
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>