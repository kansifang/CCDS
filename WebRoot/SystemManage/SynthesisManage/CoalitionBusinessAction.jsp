<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:mfhu  2005-3-17
 * Tester:
 *
 * Content:   	业务合并
 * Input Param:
 *				
 * Output param:
 *			
 * 
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//获取变量：合并前客户编号、合并前客户名称、合并后的客户编号、合并后客户名称、合并后证件类型、合并后证件编号、合并后贷款卡编号
	String sFromCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromCustomerID"));	    
	String sFromCustomerName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromCustomerName"));
	String sToCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCustomerID"));	
	String sToCustomerName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCustomerName"));	
	String sToCertType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCertType"));	
	String sToCertID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCertID"));	
	String sToLoanCardNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToLoanCardNo"));	
	//将空值转化为空字符串
	if(sFromCustomerID == null) sFromCustomerID = "";
	if(sFromCustomerName == null) sFromCustomerName = "";
	if(sToCustomerID == null) sToCustomerID = "";
	if(sToCustomerName == null) sToCustomerName = "";
	if(sToCertType == null) sToCertType = "";
	if(sToCertID == null) sToCertID = "";
	if(sToLoanCardNo == null) sToLoanCardNo = "";
		
	//定义变量
	String sFlag = "";	
	String sSql = "";	
	//转移日志信息
	String sChangeReason = "业务合并操作人员代码:"+CurUser.UserID+"   姓名："+CurUser.UserName+"   机构代码："+CurOrg.OrgID+"   机构名称："+CurOrg.OrgName;
	String sInputDate   = StringFunction.getToday();

	//事物处理开始
	boolean bOld = Sqlca.conn.getAutoCommit();
	Sqlca.conn.setAutoCommit(false);
	try
	{
		//更新申请表
		Sqlca.executeSQL("update BUSINESS_APPLY set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//更新批复表
		Sqlca.executeSQL("update BUSINESS_APPROVE set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//更新合同表
		Sqlca.executeSQL("update BUSINESS_CONTRACT set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//更新授信额度表
		Sqlca.executeSQL("update CL_INFO set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//更新出账表
		Sqlca.executeSQL("update BUSINESS_PUTOUT set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//更新借据表
		Sqlca.executeSQL("update BUSINESS_DUEBILL set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"',UpdateDate='"+StringFunction.getToday()+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		//更新流水表
		Sqlca.executeSQL("update BUSINESS_WASTEBOOK set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		
		
		//更新担保合同和担保信息
		Sqlca.executeSQL("update GUARANTY_CONTRACT set GuarantorID = '"+sToCustomerID+"',GuarantorName = '"+sToCustomerName+"',CertType = '"+sToCertType+"',CertID = '"+sToCertID+"',LoanCardNo = '"+sToLoanCardNo+"' where GuarantorID = '"+sFromCustomerID+"' ");
		Sqlca.executeSQL("update GUARANTY_INFO set OwnerID='"+sToCustomerID+"',OwnerName='"+sToCustomerName+"',CertType = '"+sToCertType+"',CertID = '"+sToCertID+"',LoanCardNo = '"+sToLoanCardNo+"' where OwnerID = '"+sFromCustomerID+"' ");
		
		//如果还要合并其他数据表中的客户请在下边区域中自行增加
		
		
		//在MANAGE_CHANGE表中插入记录，用于记录这次变更操作
        String sSerialNo1 =  DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca);
        sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
        		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
                " VALUES('UniteBusiness','"+sFromCustomerID+"','"+sSerialNo1+"','"+sFromCustomerID+"','"+sFromCustomerName+"','"+sToCustomerID+"', "+
                " '"+sToCustomerName+"','','','','','"+sChangeReason+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sInputDate+"')";
        Sqlca.executeSQL(sSql);
		sFlag = "TRUE";
		//事物提交
		Sqlca.conn.commit();
		Sqlca.conn.setAutoCommit(bOld);
	}
	catch(Exception e)
	{
		//事物失败，数据回滚
		sFlag="FALSE";
		Sqlca.conn.rollback();
		Sqlca.conn.setAutoCommit(bOld);
		throw new Exception("事务处理失败！"+e.getMessage());
	}
%>
<script language=javascript>
	self.returnValue="<%=sFlag%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>