<%/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: 		ndeng  2005.06.30
 * Tester:
 * Content: 	������Ա����
 * Input Param:
 *              UsersID   : ��Ա���
 *				RolesID    : �������
 *
 * Output param:    
 */%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%!public String CheckSqlValue(String str)
    {
		if (str == null)
			return str;
        String cstr = str;
        int pos = cstr.indexOf("'");
        while (pos >= 0)
        {
            cstr = cstr.substring(0, pos+1) + "'" + cstr.substring(pos+1);
            pos = cstr.indexOf("'", pos + 2);
        }
        return cstr;
    }%><%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open����window_open

	String sUsersID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UsersID"));
	String sRolesID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RolesID")); 
	String sAction   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	String sRoleID = "";
	String sUserID = "";
	String sUserName = "";
	
	String sSqlIn = "";
	String sSqlSe = "";
	String sSql = "";
	
	String sReturnStr = "";
	String[] RoleIDTmp = sRolesID.split("@");
	String[] UserIDTmp = sUsersID.split("@");
	
	
	if(sAction.equals("Add"))
	{
    	sReturnStr = "��ɫ�����ɹ���";
    	for(int i=0;i<RoleIDTmp.length;i++)
    	{
    	    for(int j=0;j<UserIDTmp.length;j++)
    	    {
    	        sRoleID = RoleIDTmp[i];
    	        sUserID = UserIDTmp[j];
    	        sUserName = Sqlca.getString("select UserName from USER_INFO where UserID='"+sUserID+"'");
    	        sSqlSe = "Select * from User_Role where UserID='"+sUserID+"' and RoleID='"+sRoleID+"'";
    	        ASResultSet rs = Sqlca.getResultSet(sSqlSe);
                if (rs.next()) {
                    sSqlIn="delete from user_role where userid='"+sUserID+"' and roleid='"+sRoleID+"'";
                    Sqlca.executeSQL(sSqlIn);
                    sSql = "insert into LOG_AUDITINFO(AuditType,UserID,UserName,ChangeUserID,ChangeUserName,BeginTime,Remark,RunSql)";
                    sSql +="values('020','"+sUserID+"','"+sUserName+"','"+CurUser.UserID+"','"+CurUser.UserName+"','"+StringFunction.getToday()+" "+StringFunction.getNow()+"','��ɫ"+sRoleID+"ɾ��','"+CheckSqlValue(sSqlIn)+"')";
                    Sqlca.executeSQL(sSql);
                }
                rs.getStatement().close();
                
                if(!sRoleID.equals("") && !sUserID.equals(""))
    	        {
        	        sSqlIn = "insert into USER_ROLE(UserID,roleid,grantor,begintime,status,inputuser,inputorg,inputtime,updateuser,updatetime)"+
                           " values('"+sUserID+"','"+sRoleID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','1','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+StringFunction.getToday()+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"')";
        	        Sqlca.executeSQL(sSqlIn);
                    sSql = "insert into LOG_AUDITINFO(AuditType,UserID,UserName,ChangeUserID,ChangeUserName,BeginTime,Remark,RunSql)";
                    sSql +="values('020','"+sUserID+"','"+sUserName+"','"+CurUser.UserID+"','"+CurUser.UserName+"','"+StringFunction.getToday()+" "+StringFunction.getNow()+"','��ɫ"+sRoleID+"����','"+CheckSqlValue(sSqlIn)+"')";
                    Sqlca.executeSQL(sSql);
    	        }
    	    }
    	}
	}
    else if(sAction.equals("Del"))
    {
        sReturnStr = "��ɫɾ���ɹ���";
        for(int i=0;i<RoleIDTmp.length;i++)
    	{
    	    for(int j=0;j<UserIDTmp.length;j++)
    	    {
    	        sRoleID = RoleIDTmp[i];
    	        sUserID = UserIDTmp[j];
    	        sSqlSe = "Select * from User_Role where UserID='"+sUserID+"' and RoleID='"+sRoleID+"'";
    	        ASResultSet rs = Sqlca.getResultSet(sSqlSe);
                if (rs.next()) {
                    Sqlca.executeSQL("delete from user_role where userid='"+sUserID+"' and roleid='"+sRoleID+"'");
                    sSql = "insert into LOG_AUDITINFO(AuditType,UserID,UserName,ChangeUserID,ChangeUserName,BeginTime,Remark,RunSql)";
                    sSql +="values('020','"+sUserID+"',"+sUserName+"','"+CurUser.UserID+"','"+CurUser.UserName+"','"+StringFunction.getToday()+" "+StringFunction.getNow()+"','��ɫ"+sRoleID+"ɾ��','"+CheckSqlValue(sSqlIn)+"')";
                    Sqlca.executeSQL(sSql);
                }
                rs.getStatement().close();
    	    }
    	}
    }
%>
<script language=javascript>
    alert("<%=sReturnStr%>");
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>