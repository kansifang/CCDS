<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  hxli 2004.02.19
 * Tester:
 *
 * Content: 待处理业务转授权（后台对数据库的操作）
 * Input Param:
 * 			 SerialNo：合同编号
 *           FromOrgID：转移前机构代码
 *           FromOrgName：转移前机构名称
 * 			 FromUserID：转移前客户经理代码
 *           FromUserName：转移前客户经理名称
 *           ToUserID：转移后客户经理代码
 * 			 ToUserName：转移后客户经理名称
 * Output param:
 *
 * History Log:
 *  		zywei 2005.8.16	 修改页面
 */%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//获取参数：转移合同、转移前机构代码、转移前机构名称、转移前客户经理代码、转移前客户经理名称、转移后客户经理代码、转移后客户经理名称
    String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));
	String sFromUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserID"));
	String sFromUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromUserName"));	
	String sToUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserID"));
	String sToUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToUserName"));

	//转移后机构代码和名称
	String sToOrgID = "",sToOrgName = "";	
	String sInputDate   = StringFunction.getToday();
	//转移日志信息
	String sChangeReason = "待处理业务转授权操作人员代码:"+CurUser.UserID+"   姓名："+CurUser.UserName+"   机构代码："+CurOrg.OrgID+"   机构名称："+CurOrg.OrgName;
	//SQL语句、是否成功标志
	String sSql = "",sFlag = "";
	//查询结果集
	ASResultSet rs = null;
   
	//查询交接后客户经理所在机构代码和名称
    sSql =  " select BelongOrg,getOrgName(BelongOrg) as BelongOrgName "+
        	" from USER_INFO " +
        	" where UserID = '"+sToUserID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
	    sToOrgID = DataConvert.toString(rs.getString("BelongOrg"));
	    sToOrgName = DataConvert.toString(rs.getString("BelongOrgName"));
	}
	rs.getStatement().close();

	//事务处理开始	
    boolean bOld = Sqlca.conn.getAutoCommit();
    Sqlca.conn.setAutoCommit(false);
	try{
		//在MANAGE_CHANGE表中插入记录，用于记录这次变更操作
        String sSerialNo1 =  DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca);
        sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
        		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
                " VALUES('FlowTask','"+sSerialNo+"','"+sSerialNo1+"','"+sFromOrgID+"','"+sFromOrgName+"','"+sToOrgID+"', "+
                " '"+sToOrgName+"','"+sFromUserID+"','"+sFromUserName+"','"+sToUserID+"','"+sToUserName+"','"+sChangeReason+"', "+
                " '"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sInputDate+"')";
        Sqlca.executeSQL(sSql);

        //变更合同的管户人和机构
		sSql = " update FLOW_TASK set OrgID='"+sToOrgID+"',OrgName='"+sToOrgName+"',UserID='"+sToUserID+"',UserName='"+sToUserName+"' where "+
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
		throw new Exception("待处理业务转授权处理失败！"+e.getMessage());
	}
%>

<script language=javascript>
	self.returnValue = "<%=sFlag%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>