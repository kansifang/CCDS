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

	String sUserID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sRolesID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RolesID"));   
	String sRoleID = "";
	String sSql = "";
	String[] RoleIDTmp = sRolesID.split("@");
	
	Sqlca.executeSQL("delete from user_role where userid='"+sUserID+"' and roleid<>'800'");
	
	for(int i=0;i<RoleIDTmp.length;i++)
	{
	    sRoleID = RoleIDTmp[i];
	    if(!sRoleID.equals(""))
	    {
	        sSql = "insert into USER_ROLE(UserID,roleid,grantor,begintime,status,inputuser,inputorg,inputtime,updateuser,updatetime)"+
                   " values('"+sUserID+"','"+sRoleID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','1','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+StringFunction.getToday()+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"')";
	        Sqlca.executeSQL(sSql);
	    }
	}
%>
<script language=javascript>
    alert("��ɫ�����ɹ���");
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>