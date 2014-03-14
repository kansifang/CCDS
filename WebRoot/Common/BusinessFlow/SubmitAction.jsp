<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.lmt.baseapp.flow.*" %>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   byhu  2004.12.6
			Tester:
			Content: 提示下一阶段信息
			Input Param:
		SerialNo：当前任务的流水号
		PhaseAction：所选的下一步动作
		PhaseOpinion1：意见
			Output param:
		sReturnValue:	返回值Commit表示完成操作
			History Log: zywei 2005/08/03  重检页面
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "任务提交"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//获取参数：任务流水号和下一步动作
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//从上个页面得到传入的任务流水号
	String sPhaseAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseAction"));//从上个页面得到传入的动作信息
	String sPhaseOpinion1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseOpinion1"));//从上个页面得到传入的意见信息
	//将空值转化成空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sPhaseAction == null) sPhaseAction = "";
	if(sPhaseOpinion1 == null) sPhaseOpinion1 = "";
	
	//定义变量：返回阶段信息、阶段名称
	String sPhaseInfo = "",sNextPhaseName = "",sNextPhaseNo = "";
%>
<%
	/*~END~*/
%>	


<%
		/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=处理业务逻辑;]~*/
	%>
<%
	//初始化任务对象
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
	//执行提交操作
	FlowPhase fpFlow = ftBusiness.commitAction(sPhaseAction,sPhaseOpinion1);
	//获取下一阶段的阶段名称
	sNextPhaseName = fpFlow.PhaseName;
	sNextPhaseNo = fpFlow.PhaseNo;
	//拼出提示信息
	sPhaseInfo="下一阶段:";
	sPhaseInfo = sPhaseInfo+" " + sNextPhaseName;		
	if (sPhaseInfo!=null && sPhaseInfo.trim().length()>0){
%>
		<script language=javascript>
			alert("<%=sPhaseInfo%>");
			self.returnValue = "Success";
			self.close();	
		</script>
<%
	}else
	{
%>
		<script language=javascript>			
			self.returnValue = "Failure";
			self.close();	
		</script>
<%
	}
%>
	
<%
		/*~END~*/
	%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List04;Describe=任务提交后返回其标志;]~*/
%>
<script language=javascript>
	//self.returnValue = "Commit";
	//self.close();	
</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>