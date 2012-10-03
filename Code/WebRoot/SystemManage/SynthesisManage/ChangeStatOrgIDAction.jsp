<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  hxli 2004.02.19
 * Tester:
 *
 * Content: 转移合同（后台对数据库的操作）
 * Input Param:
 * 			 UserID:接受客户经理
 *           OrgID:接受机构
 *           SerialNo:合同编号
 * Output param:
 *
 * History Log:
 *  		gecg 2005.3.01	 修改页面
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
    //获取参数：转移合同、转移前机构代码、转移前机构名称、转移前客户经理代码、转移前客户经理名称、转移后客户经理代码、转移后客户经理名称
    String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));		
	String sToOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgID"));
	String sToOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgName"));

	//转移日期
	String sInputDate   = StringFunction.getToday();	
	//转移日志信息
	String sChangeReason = "业务入账机构交接操作人员代码:"+CurUser.UserID+"   姓名："+CurUser.UserName+"   机构代码："+CurOrg.OrgID+"   机构名称："+CurOrg.OrgName;
	String sSql = "",sFlag = "";
	//事务处理开始	
	boolean bOld = Sqlca.conn.getAutoCommit();
	Sqlca.conn.setAutoCommit(false);
	try{
		//在MANAGE_CHANGE表中插入记录，用于记录这次变更操作
	    String sSerialNo1 =  DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca);
	    sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
	    		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
	            " VALUES('BusinessContract','"+sSerialNo+"','"+sSerialNo1+"','"+sFromOrgID+"','"+sFromOrgName+"','"+sToOrgID+"', "+
	            " '"+sToOrgName+"','','','','','"+sChangeReason+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sInputDate+"')";
	    Sqlca.executeSQL(sSql);

	    //变更合同的入账机构
		sSql = " update BUSINESS_CONTRACT set StatOrgID='"+sToOrgID+"' where "+
			   " SerialNo = '"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);	
						
		sFlag = "TRUE";
		
		//事务提交
	    Sqlca.conn.commit();
	    Sqlca.conn.setAutoCommit(bOld);
	}catch(Exception e)
	{
		sFlag = "FALSE";
		//事务失败回滚
	    Sqlca.conn.rollback();
	    Sqlca.conn.setAutoCommit(bOld);
		throw new Exception("合同转移处理失败！"+e.getMessage());
	}
%>

<script language=javascript>
	self.returnValue = "<%=sFlag%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>