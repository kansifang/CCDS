<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.finance.*" %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jbye  2004-12-20 9:14
		Tester:
		Content: 报表更新操作
		Input Param:
             ObjectNo ：   对象编号 目前默认为客户编号
             ObjectType ： 报表类型 目前默认CustomerFS
             ReportDate ： 报表截止日期    
		Output param:
		History Log: 
			利用改造过的类一次性新增或删除一套报表
			对多表操作增加事务处理 zywei 2007/10/10
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>报表更新操作</title>
<%
	String sObjectType = "",sObjectNo = "",sWhere = "",sReportDate = "",sOrgID = "",sUserID = "",sActionType = "";
	String sReportScope = "",sSql = "",sSql1 = "",sSql2 = "",sNewReportDate = "";
	//zywei 2007/10/10 增加事务处理标志
	String sDealFlag = "";
	//对象编号 暂时为客户号
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//对象类型 暂时都为CustomerFS
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	sReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportDate"));
	sReportScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportScope"));
	sWhere = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Where"));
	sNewReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NewReportDate"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null)	sObjectType = "";
	if(sReportDate == null)	sReportDate = "";
	if(sReportScope == null) sReportScope = "";
	if(sWhere == null)	sWhere = "";
	if(sNewReportDate == null)	sNewReportDate = "";
	sWhere = StringFunction.replace(sWhere,"^","=");
	
	//报表操作类型
	sActionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ActionType"));
	if(sActionType==null)	sActionType = "";	
	
	sOrgID = CurOrg.OrgID;
	sUserID = CurUser.UserID;
	
	//设置事务
	boolean bOld = Sqlca.conn.getAutoCommit();
    Sqlca.conn.setAutoCommit(false);

    try
    {
		if(sActionType.equals("AddNew"))
		{
			// 根据指定MODEL_CATALOG的where条件增加一批新报表		
			Report.newReports(sObjectType,sObjectNo,sReportScope,sWhere,sReportDate,sOrgID,sUserID,Sqlca);
		}else if(sActionType.equals("Delete"))
		{
			// 删除指定关联对象和日期的一批报表 
			Report.deleteReports(sObjectType,sObjectNo,sReportScope,sReportDate,Sqlca);	
			sSql2 = " delete from CUSTOMER_FSRECORD "+
					" where CustomerID = '"+sObjectNo+"' "+
					" and ReportDate = '"+sReportDate+"' "+
					" and ReportScope = '"+sReportScope+"' ";
			Sqlca.executeSQL(sSql2);
		}else if(sActionType.equals("ModifyReportDate"))
		{
			// 更新指定报表的会计月份 
			sSql = 	" update CUSTOMER_FSRECORD "+
					" set ReportDate='"+sNewReportDate+"' "+
					" where CustomerID='"+sObjectNo+"' "+
					" and ReportDate='"+sReportDate+"' "+
					" and ReportScope = '"+sReportScope+"' ";
			Sqlca.executeSQL(sSql);
			
			// 更新指定报表的会计月份
			sSql1 = " update REPORT_RECORD "+
					" set ReportDate='"+sNewReportDate+"' "+
					" where ObjectNo='"+sObjectNo+"' "+
					" and ReportDate='"+sReportDate+"'"+
					" and ReportScope = '"+sReportScope+"' ";    	
	    	Sqlca.executeSQL(sSql1);
		}
		
		//事物提交
		Sqlca.conn.commit();
		Sqlca.conn.setAutoCommit(bOld);
		sDealFlag = "ok";		
    }catch(Exception e)
    {
        Sqlca.conn.rollback();
        Sqlca.conn.setAutoCommit(bOld);
        sDealFlag = "error";        
        throw new Exception("事务处理失败！"+e.getMessage());
    }
%>

<script language=javascript>
	self.returnValue = "<%=sDealFlag%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>