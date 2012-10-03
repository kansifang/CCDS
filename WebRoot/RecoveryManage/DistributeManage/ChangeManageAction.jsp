<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   xhyong 2010/06/20
 * Tester:
 *
 * Content:  插入变更记录
 * Input Param:
 * Output param:
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%  
	//对象编号,对象类型,原机构,原管理人,新机构,新管理人
	String sObjectNo = DataConvert.toRealString(iPostChange,request.getParameter("ObjectNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,request.getParameter("ObjectType")); 
	String sOldOrgID = DataConvert.toRealString(iPostChange,request.getParameter("OldOrgID")); 
	String sOldUserID = DataConvert.toRealString(iPostChange,request.getParameter("OldUserID")); 
	String sNewOrgID = DataConvert.toRealString(iPostChange,request.getParameter("NewOrgID")); 
	String sNewUserID = DataConvert.toRealString(iPostChange,request.getParameter("NewUserID"));
	if(sObjectNo == null) sObjectNo="";
	if(sObjectType == null) sObjectType="";
	if(sOldOrgID == null) sOldOrgID="";
	if(sOldUserID == null) sOldUserID="";
	if(sNewOrgID == null) sNewOrgID="";
	if(sNewUserID == null) sNewUserID="";
	String sSql = "";
		
	try 
		{
			//向MANAGE_CHANGE表中数据
			String sSerialNo = DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo",Sqlca);
			sSql= " Insert into MANAGE_CHANGE(SerialNo,ObjectNo,ObjectType,OldOrgID,OldUserID,NewOrgID,NewUserID,ChangeOrgID,ChangeUserID,ChangeTime) "+
			       " Values('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','"+sOldOrgID+"','"+sOldUserID+"','"+sNewOrgID+"','"+sNewUserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+ StringFunction.getToday() + "') ";
			Sqlca.executeSQL(sSql);
		 	//事物提交
			Sqlca.conn.commit();
		}catch(Exception e)
		{
			Sqlca.conn.rollback();
			throw new Exception("事务处理失败！"+e.getMessage());
		}
%>

<script language=javascript>
    self.returnValue="true";
    self.close();    
</script>
<%@ include file="/IncludeEnd.jsp"%>
