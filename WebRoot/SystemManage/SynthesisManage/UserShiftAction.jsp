<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  kfb 2005.03.08
 * Tester:
 *
 * Content: 交接用户动作
 * Input Param:
 *
 * Output param:
 *
 *
 * History Log:
 *			
 *
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%
	//获取参数：转移前用户编号、转移前机构代码、转移前机构名称、转移后机构代码、转移后机构名称
    String sFromUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
    String sFromOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgID"));
	String sFromOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromOrgName"));	
	String sToOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgID"));
	String sToOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToOrgName"));
	
	//转移日志信息
	String sChangeReason = "用户转移操作人员代码:"+CurUser.UserID+"   姓名："+CurUser.UserName+"   机构代码："+CurOrg.OrgID+"   机构名称："+CurOrg.OrgName;
	//SQL语句，是否成功标志
	String sSql = "",sFlag = "";
	String sInputDate   = StringFunction.getToday();
	boolean bOld = Sqlca.conn.getAutoCommit();
	Sqlca.conn.setAutoCommit(false);
	try
	{
		 //将当前用户对应该客户和的所有业务（的相关内容）改为目标机构；
		sSql =  " update AGENCY_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update AGENT_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ALARM_ARGS set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ALARM_LIBRARY set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ALARM_METHOD set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ALARM_MODEL set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ALARM_RECORD set AlarmOrgID = '"+sToOrgID+"' where AlarmUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ALARM_SCENARIO set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  "update ALERT_HANDLE set OrgID='"+sToOrgID+"' where  UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  "update ALERT_LOG set OrgID='"+sToOrgID+"' where  UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  "update ALERT_LOG set InputOrg='"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where  InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);				
		sSql =  " update ASSET_CONTRACT set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update ASSET_INFO set OperateOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ASSET_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update BILL_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BOL_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update BUG_REPORT set OrgID = '"+sToOrgID+"' where USERID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUILDING_DEAL set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_APPLICANT set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update BUSINESS_APPLY set OperateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_APPLY set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update BUSINESS_APPROVE set OperateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_APPROVE set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);				
		sSql =  " update BUSINESS_CONTRACT set RecoveryOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where RecoveryUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_CONTRACT set RecoveryCognOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where RecoveryCognUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_CONTRACT set ManageOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where ManageUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_CONTRACT set StatOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where StatUserID ='"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_CONTRACT set OperateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_CONTRACT set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update BUSINESS_DUEBILL set OperateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_DUEBILL set mforgid=getcoreorgid('"+sToOrgID+"'),InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_EXTENSION set OrgID = '"+sToOrgID+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_PROVIDER set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update BUSINESS_PUTOUT set OperateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_PUTOUT set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_TYPE set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update BUSINESS_WASTEBOOK set OrgID = '"+sToOrgID+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update BUSINESS_WASTEBOOK set MFOrgID = '"+sToOrgID+"' where MFUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CASHFLOW_RECORD set OrgID = '"+sToOrgID+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CLASS_ATTRIBUTE set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CLASS_CATALOG set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CLASS_METHOD set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CLASSIFY_RECORD set OrgID = '"+sToOrgID+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update CODE_CATALOG set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update CODE_HIERARCHY set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update CODE_LIBRARY set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update CONSUME_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CONTRACT_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update COST_INFO set OperateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update COST_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CREDIT_PROVE set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update CUSTOMER_ANARECORD set OrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CUSTOMER_ANARECORD set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update CUSTOMER_BELONG set OrgID = '"+sToOrgID+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CUSTOMER_BELONG set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update CUSTOMER_BOND set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update CUSTOMER_FSRECORD set OrgID = '"+sToOrgID+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CUSTOMER_IMASSET set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update CUSTOMER_INFO set InputOrgID = '"+sToOrgID+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CUSTOMER_MEMO set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);			
		sSql =  " update CUSTOMER_OACCOUNT set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CUSTOMER_OACTIVITY set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update CUSTOMER_REALTY set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CUSTOMER_RELATIVE set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		 sSql =  " update CUSTOMER_SPECIAL set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CUSTOMER_STOCK set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update CUSTOMER_TAXPAYING set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update CUSTOMER_VEHICLE set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update DOC_ATTACHMENT set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update DOC_LIBRARY set OrgID = '"+sToOrgID+"',OrgName = '"+sToOrgName+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update DOC_LIBRARY set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update DUN_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update ENT_ASSETDEBT set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ENT_AUTH set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ENT_BONDISSUE set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ENT_ENTRANCEAUTH set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ENT_FIXEDASSETS set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ENT_FOA set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update ENT_INFO set UpdateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where UpdateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ENT_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ENT_INVENTORY set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ENT_IPO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);			
		sSql =  " update ENT_PROJECT set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ENT_REALTYAUTH set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update EQUIPMENT_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update EVALUATE_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update EVALUATE_RECORD set OrgID = '"+sToOrgID+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update EXAMPLE_INFO set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update EXAMPLE_INFO set AuditOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where AuditUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update FLOW_OBJECT set OrgID = '"+sToOrgID+"',OrgName = '"+sToOrgName+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update FLOW_TASK set OrgID = '"+sToOrgID+"',OrgName = '"+sToOrgName+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update FLOW_TASK_CLOSED set OrgID = '"+sToOrgID+"',OrgName = '"+sToOrgName+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update FORMATDOC_CATALOG set OrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update FORMATDOC_DATA set OrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update FORMATDOC_DEF set OrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update GUARANTY_CONTRACT set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update GUARANTY_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update HRUSER_INFO set BelongOrg = '"+sToOrgID+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update IND_BI set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);			
	    sSql =  " update IND_EDUCATION set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
	    Sqlca.executeSQL(sSql);		
		sSql =  " update IND_INFO set UpdateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where UpdateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update IND_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update IND_OASSET set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update IND_ODEBT set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update IND_RESUME set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update IND_SI set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update INSPECT_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update INSPECT_INFO set InspectOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InspectUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update INVOICE_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update LAWCASE_BOOK set OperateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update LAWCASE_BOOK set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);			
		sSql =  "update LAWCASE_COGNIZANCE set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update LAWCASE_INFO set OperateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update LAWCASE_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update LAWCASE_PERSONS set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update LC_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update LG_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update MANAGE_CHANGE set OldOrgID = '"+sToOrgID+"' where OldUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update MANAGE_CHANGE set NewOrgID = '"+sToOrgID+"' where NewUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update MANAGE_CHANGE set ChangeOrgID = '"+sToOrgID+"' where ChangeUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update MESSAGE_INFO set SendOrgID = '"+sToOrgID+"' where SendUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		 sSql =  " update MESSAGE_INFO set ReceiveOrgID = '"+sToOrgID+"' where ReceiveUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update OBJECT_ATTRIBUTE set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update OBJECT_LEVEL set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update OBJECT_RES_List set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update OBJECT_USER set OrgID = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update OBJECT_USER set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update OBJECTTYPE_CATALOG set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ORG_INFO set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update OTHERCHANGE_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update PRODUCT_DEF set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update PROJECT_BUDGET set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update PROJECT_FUNDS set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update PROJECT_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update PROJECT_PROGRESS set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update PROVE_CHANGE set InputOrgID = '"+sToOrgID+"',UpdateDate='"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update RECLAIM_INFO set OperateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update RECLAIM_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);		
		sSql =  " update REG_COMMENT_ITEM set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql); 
		sSql =  " update REG_COMP_DEF set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql); 
		sSql =  " update REG_FUNCTION_DEF set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql); 
		sSql =  " update REG_PAGE_DEF set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql); 
		sSql =  " update REPORT_RECORD set OrgID = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql); 
		sSql =  " update RIGHT_INFO set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql); 
		sSql =  " update RISK_SIGNAL set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update ROLE_INFO set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update ROLE_RIGHT set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update SCORECARD_RECORD set OrgID = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql); 
		sSql =  " update SEPERATOR_CATALOG set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update SYSTEM_LOG set OrgID = '"+sToOrgID+"',OrgName = '"+sToOrgName+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql); 
		sSql =  " update TEAM_INFO set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update TRACER_MANAGE set TraceOrgID = '"+sToOrgID+"' where TraceUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update TRACER_MANAGE set InputOrgID = '"+sToOrgID+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update TRADE_LOG set OperateOrgID = '"+sToOrgID+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update USER_CHANGEINFO set OrgID = '"+sToOrgID+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update USER_INFO set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update USER_INFO set BelongOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"',UpdateDate = '"+StringFunction.getToday()+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update USER_LIST set OrgID = '"+sToOrgID+"',OrgName = '"+sToOrgName+"' where UserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update USER_PREF_DEF set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update USER_RELATIVE set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update USER_RIGHT set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update USER_ROLE set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update VEHICLE_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);	
		sSql =  " update VIEW_CATALOG set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update VIEW_LIBRARY set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update VILLAGE_INFO set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update WORK_RECORD set OperateOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where OperateUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update WORK_RECORD set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update WORK_REMIND set InputOrgID = '"+sToOrgID+"',UpdateDate = '"+StringFunction.getToday()+"' where InputUserID = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		sSql =  " update WZD_MISSION set InputOrg = '"+sToOrgID+"',UpdateTime = '"+StringFunction.getToday()+"' where InputUser = '"+sFromUserID+"' ";
		Sqlca.executeSQL(sSql);
		//在MANAGE_CHANGE表中插入记录，用于记录这次变更操作
        String sSerialNo1 =  DBFunction.getSerialNo("MANAGE_CHANGE","SerialNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca);
        sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
        		" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
                " VALUES('User','"+sFromUserID+"','"+sSerialNo1+"','"+sFromOrgID+"','"+sFromOrgName+"','"+sToOrgID+"', "+
                " '"+sToOrgName+"','','','','','"+sChangeReason+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sInputDate+"')";
        Sqlca.executeSQL(sSql);
		
		//事务提交
		Sqlca.conn.commit();		
		Sqlca.conn.setAutoCommit(bOld);
		sFlag = "TRUE";
	}
	catch(Exception e)
	{
		sFlag = "FALSE";
		//事务失败回滚
		Sqlca.conn.rollback();
		Sqlca.conn.setAutoCommit(bOld);
	}
%>

<script language=javascript>
	self.returnValue = "<%=sFlag%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>