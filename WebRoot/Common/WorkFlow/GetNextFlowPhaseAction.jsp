<%
/* Author: byhu 2004.12.07
 * Tester:
 *
 * Content: 提示下一阶段信息 
 * Input Param:
 * 				SerialNo：	当前任务的流水号
 *				PhaseAction：	所选的下一步动作
 * Output param:
 *				PhaseInfo：	下阶段信息
 * History Log:
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>

<% 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//从上个页面得到传入的任务流水号
	String sPhaseAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseAction"));//从上个页面得到传入的动作信息
	String sPhaseOpinion1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseOpinion1"));//从上个页面得到传入的意见信息	
	//将空值转化成空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sPhaseAction == null) sPhaseAction = "";
	if(sPhaseOpinion1 == null) sPhaseOpinion1 = "";
	
	String sPhaseInfo="",sNextPhaseName="";//返回阶段信息、阶段名称
	
	//初始化任务对象
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
	//获得下一阶段的阶段名称
	sNextPhaseName = ftBusiness.getNextFlowPhase(sPhaseAction,sPhaseOpinion1).PhaseName;
	
	sPhaseInfo="下一阶段:";
	sPhaseInfo = sPhaseInfo+" " + sNextPhaseName;//拼出提示信息
%>
<script language=javascript>	
	self.returnValue = "<%=sPhaseInfo%>";
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>