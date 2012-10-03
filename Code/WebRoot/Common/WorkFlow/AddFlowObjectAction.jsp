<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: byhu 2004-12-06 
		Tester:
		Describe: 新增流程对象
		Input Param:
			ObjectType： 对象类型
			sObjectNo：对象代码
			sDescribe：描述
		Output Param:
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%> 
<html>
<head>
<title>新增流程对象</title>

<%	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sApplyType   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ApplyType"));
	String sDescribe = DataConvert.toRealString(iPostChange,(String)request.getParameter("Describe"));
	String sInitFlowNo = "",sInitPhaseNo = "";

	String sSql = "";
	ASResultSet rs;
	try{
		
		//创建流程对象映像
				 		
		sSql="select Attribute2 from CODE_LIBRARY where CodeNo='ApplyType' and ItemNo='"+sApplyType+"'";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next()){
			sInitFlowNo = rs.getString(1);
		}
		rs.getStatement().close();

		sSql="select InitPhase from FLOW_CATALOG where FlowNo='"+sInitFlowNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next()){
			sInitPhaseNo = rs.getString(1);
		}
		rs.getStatement().close();

		//修改阶段		
		FlowObject foTemp = new FlowObject(sObjectType,sObjectNo,Sqlca);
		FlowPhase fpTemp = new FlowPhase(sInitFlowNo,sInitPhaseNo,Sqlca);
		foTemp.changePhase(fpTemp,CurUser);
		
		%>
		<script language=javascript>
			self.returnValue = "succeeded";
			self.close();
		</script>
		<%	
	}catch(Exception ex){
			out.println(ex.toString());
		%>
		<script language=javascript>
			self.returnValue = "failed";
			//self.close();
		</script>
		<%	
	}
%>
<%@ include file="/IncludeEnd.jsp"%>