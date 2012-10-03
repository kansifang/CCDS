<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2005.1.2
		Tester:
		Content: 插入检查表
		Input Param:
			                sObjectNo:代号
			                sInspectType:报告类型
							                010	贷款用途报告
											020	贷款检查报告
		Output param:
		History Log: 
			2004-12-13	cchang	增加个体工商户操作
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>贷款用途检查客户信息</title>
<%
	String sSql;
	String sObjectNo="",sInspectType="",sSerialNo="";	
	ASResultSet rs = null;
	String sActionType=DataConvert.toRealString(iPostChange,(String)request.getParameter("ActionType"));
	String sReportType=DataConvert.toRealString(iPostChange,(String)request.getParameter("ReportType"));	
	if(sActionType==null) sActionType="";
	if(sReportType == null) sReportType = "";
	//如果是删除操作
	if(sActionType.equals("Del"))
	{
		sSerialNo=DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));

		sSql="delete from inspect_info where SerialNo='"+sSerialNo+"'";
		Sqlca.executeSQL(sSql);
		//删除该贷款用途报告的提款纪录、用款纪录
		sSql="delete from inspect_detail where ObjectNo='"+sSerialNo+"'";
		Sqlca.executeSQL(sSql);
	}
	//新增操作
	else
	{
		sObjectNo   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
		sInspectType   = DataConvert.toRealString(iPostChange,(String)request.getParameter("InspectType"));
		sSerialNo = DBFunction.getSerialNo("INSPECT_INFO","SerialNo",Sqlca);
		if(sInspectType.equals("020010") || sInspectType.equals("020020"))
		{
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate,ReportType) "+
				"values('Customer','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"','"+sReportType+"')";
			Sqlca.executeSQL(sSql);
			
			sSql = "update Check_Frequency set CheckTime ='"+StringFunction.getToday()+"',NextCheckTime = null where CustomerID = '"+sObjectNo+"'";	
			Sqlca.executeSQL(sSql);

			//sSql = "insert into inspect_detail(ObjectType,ObjectNo,SerialNo,ItemNo,ItemName)"+
			//" select 'Customer','"+sObjectNo+"','"+sSerialNo+"',ItemNo,ItemName from CODE_LIBRARY where CodeNo='InspectInfo'";
			//Sqlca.executeSQL(sSql);
		}
		else if(sInspectType.equals("040010") || sInspectType.equals("040020")){
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('Customer','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
			
			sSql = "update Check_Frequency set CheckTime ='"+StringFunction.getToday()+"',NextCheckTime = null where CustomerID = '"+sObjectNo+"'";	
			Sqlca.executeSQL(sSql);
		}
		//授信业务批复报告
		else if(sInspectType.equals("060")) {
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('ApproveApproval','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
			
			//sSql = "update Check_Frequency set CheckTime ='"+StringFunction.getToday()+"',NextCheckTime = null where CustomerID = '"+sObjectNo+"'";	
			//Sqlca.executeSQL(sSql);
		}
		//预警审批报告
		else if(sInspectType.equals("RiskSignal16")) {
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('RiskSignal','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
		}
		//预警解除申请表
		else if(sInspectType.equals("RiskSignal17")) {
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('FreeRiskSignal','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
		}//复审申请表
		else if(sInspectType.equals("065")) {
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('RehearForm','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
		}
		//预警处置报告
		else if(sInspectType.equals("RiskSignalDispose")) {
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
			"values('RiskSignalDispose','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
		Sqlca.executeSQL(sSql);
		}
		else
		{
			sSql = "insert into INSPECT_INFO(ObjectType,ObjectNo,SerialNo,InspectType,UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				"values('BusinessContract','"+sObjectNo+"','"+sSerialNo+"','"+sInspectType+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
		}
	}

	
%>
<script language=javascript>
	self.returnValue = "<%=sSerialNo%>";
	//alert(<%=sSerialNo%>);
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>