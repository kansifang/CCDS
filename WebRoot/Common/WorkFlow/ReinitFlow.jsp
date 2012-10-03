<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.lending.bizlets.*" %>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: lpzhang 2009-8-14 
		Tester:
		Describe: 获取任务流水号
		Input Param:
			ObjectNo:对象号码
			ObjectType：对象类型
			TaskNo：流程号
		Output Param:
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%> 


<% 
	//获取参数：对象号码,对象类型
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sTaskNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TaskNo"));
	//将空值转化成空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sTaskNo == null) sTaskNo = "";
	//初始化流程对象
	CreditFlowBusiness CB = new CreditFlowBusiness(sObjectNo,sObjectType,Sqlca);
	CB.InitWorkFlow(sTaskNo);
	
%>


<script language=javascript>
    self.close();    
</script>


<%@ include file="/IncludeEnd.jsp"%>
