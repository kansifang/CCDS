<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: 		zywei 2007.06.19
 * Tester:
 * Content: 	给角色赋予主菜单操作权限
 * Input Param:
 *              RoleID   : 角色编号
 *				ItemNo   : 主菜单编号
 *
 * Output param:    
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window_open

	String sRoleID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RoleID"));
	String sItemNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));   
	String sMenuNo = "";
	String sSql = "";
	String sTemp = "";
	String[] ItemNoTmp = sItemNo.split("@");
	
	sTemp = "," + sRoleID;
	sSql = " update CODE_LIBRARY set RelativeCode = replace(RelativeCode,'"+sTemp+"','') where CodeNo = 'MainMenu' and IsInUse = '1'";
	Sqlca.executeSQL(sSql);
	for(int i=0;i<ItemNoTmp.length;i++)
	{
	    sMenuNo = ItemNoTmp[i];
	    if(!sMenuNo.equals(""))
	    {
	        sSql = " update CODE_LIBRARY set RelativeCode = trim(RelativeCode) || ',' || '"+sRoleID+"' where ItemNo = '"+sMenuNo+"'";
	Sqlca.executeSQL(sSql);
	    }
	}
%>
<script language=javascript>
    alert("菜单授权成功！");
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>