<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.lmt.baseapp.flow.*" %>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
<%
	/*
		Author: byhu 2004-12-06 
		Tester:
		Describe: 提交选择框
		Input Param:
	SerialNo：任务流水号
		Output Param:
		HistoryLog: zywei 2005/08/01			
	 */
%>
<%
	/*~END~*/
%> 


<%
 	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
 %>
<%
	//获取参数：任务流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//从上个页面得到传入的任务流水号
	//定义变量：流程编号、阶段编号、对象编号
	String sFlowNo = "",sPhaseNo = "",sObjectNo = "";
	//定义变量：动作、动作列表、阶段的类型、动作提示、阶段的属性
	String sPhaseAction = "",sActionList[],sSelectStyle = "",sActionDescribe = "",sPhaseAttribute = "",sPhaseOpinion1[]; 
	String sSql="";
	ASResultSet rsTemp = null;
%>
<%
	/*~END~*/
%>	


<%
		/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义业务逻辑主体;]~*/
	%>
<%
	//从任务流程表FLOW_TASK中查询出流程编号、阶段编号
	sSql = "select FlowNo,PhaseNo from FLOW_TASK where SerialNo = '"+sSerialNo+"' ";
	rsTemp = Sqlca.getASResultSet(sSql);
	if (rsTemp.next())
	{
		sFlowNo  = DataConvert.toString(rsTemp.getString("FlowNo"));
		sPhaseNo  = DataConvert.toString(rsTemp.getString("PhaseNo"));
		//将空值转化成空字符串
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";				
	}
	rsTemp.getStatement().close();
	
	//从流程模型表FLOW_MODEL中查询出阶段属性、阶段描述
	sSql = "select PhaseAttribute,ActionDescribe from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"' ";
	rsTemp = Sqlca.getASResultSet(sSql);
	if (rsTemp.next())
	{
		sPhaseAttribute  = DataConvert.toString(rsTemp.getString("PhaseAttribute"));
		sActionDescribe = DataConvert.toString(rsTemp.getString("ActionDescribe"));
		//将空值转化成空字符串
		if(sPhaseAttribute == null) sPhaseAttribute = "";
		if(sActionDescribe == null) sActionDescribe = "";
		sSelectStyle = StringFunction.getProfileString(sPhaseAttribute,"ActionStyle");
		//将空值转化成空字符串
		if(sSelectStyle == null) sSelectStyle = "";
	}
	rsTemp.getStatement().close();

	//初始化任务对象
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);

	sPhaseOpinion1 = ftBusiness.getChoiceList();
	if (sPhaseOpinion1 == null){
		sPhaseOpinion1 = new String[1];
		sPhaseOpinion1[0] = "";
	}

	//获取动作选择列表
	sActionList = ftBusiness.getActionList("");
	if (sActionList == null){
		sActionList = new String[1];
		sActionList[0] = "";
	}
	

	String sActionValue[];
	String sTempString1 = "";
	int iCount=sActionList.length;
	sActionValue = new String[iCount];

	for(int i=0;i<iCount;i++){
		sSql = "select LoginID||'  '||UserName from USER_INFO where UserID = '"+sActionList[i]+"' ";
		rsTemp = Sqlca.getASResultSet(sSql);
		if(rsTemp.next()){
			sActionValue[i] = rsTemp.getString(1);
		}
		rsTemp.getStatement().close();
	}
	if(sActionValue[0] == null)
		sActionValue = sActionList;
%>
<%
	/*~END~*/
%>	
<%
		/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义选择提交动作界面风格;]~*/
	%>
	<html>
	<head>
		<title>提交动作选择列表</title>
	</head>
	<body class="ShowModalPage" leftmargin="0" topmargin="0" onload="" >
	<form name="Phase" method="post" target="_top">
	<%
		if (!sPhaseOpinion1[0].equals("")){//当前页就是为了展示PhaseOpinion1内容，不知为啥搞个if else
	%>
		 <table width="100%" align="center">
		  		<tr width="100%" >
		  		<td width="100%"  valign="top" >
		  			<table >
					<tr>
						<td>
						<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","提  交","提交","javascript:commitAction()",sResourcesPath)%>
						</td>
						<td>
						<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","放  弃","放弃","javascript:doCancel()",sResourcesPath)%>
						</td>			
					</tr>
		       		</table>
		        </td>
		        </tr>
		        <tr height=1> 
		          <td colspan="5" valign="top" ><hr></td>
		        </tr>	
		        <tr>
		        <td>				
					<table align="center">							
						<tr>
							 <!--<td valign="top" width=1><img src="<%=sResourcesPath%>/TN_031.gif" width="123" height="80"></td>-->
							 <td colspan=5>
								<select size=8  name="PhaseOpinion1"  class="select1">
								<option value='' style='color:white'>------------------------</option>
								<%=HTMLControls.generateDropDownSelect(sPhaseOpinion1,sPhaseOpinion1,"")%>
								</select>
							 </td>
						</tr>							
					</table>
				</td>
			</tr>
		</table>
		<p>		
		<div style="visibility:hidden;">
			<table align="right">
				<tr>
					<td colspan=4>
						<select size=8 <%=sSelectStyle%>  name="PhaseAction"  class="select1">
						<option value='' style='color:white'>------------------------</option>
						<%=HTMLControls.generateDropDownSelect(sActionList,sActionValue,"")%>
						</select>
					</td>
				</tr>
			</table>
		</div>
<%
	}else{
%>
			<table align="center">
				<tr>
					<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","提  交","提交","javascript:commitAction()",sResourcesPath)%>
					</td>
					<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","放  弃","放弃","javascript:doCancel()",sResourcesPath)%>
					</td>			
				</tr>
		        <tr height=1> 
		          <td colspan="5" valign="top" ><hr></td>
		        </tr>
		        <br>	
				<tr>
					 <td valign="top" width=1><img src="<%=sResourcesPath%>/TN_031.gif" width="123" height="80"></td>
					 <td colspan=4>
						<select size=8 <%=sSelectStyle%> <%=sSelectStyle%> name="PhaseAction"  class="select1">
						<option value='' style='color:white'>------------------------</option>
						<%=HTMLControls.generateDropDownSelect(sActionList,sActionValue,"")%>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan=4>
					</td>
				</tr>
			</table>
		<p>		
		<div style="visibility:hidden;">
			<table align="right">
					<tr>
						<td colspan=4>
							<select size=8 <%=sSelectStyle%>  name="PhaseOpinion1"  class="select1">
							<option value='' style='color:white'>------------------------</option>
							<%=HTMLControls.generateDropDownSelect(sPhaseOpinion1,sPhaseOpinion1,"")%>
							</select>
						</td>
					</tr>
			</table>
		</div>
<%
	}
%>
	 <input name="SelectedCount" readonly type="text" style="font-size: 9pt;background-color:#DEDFCE;border-style=none" >
	</form>
	</body>
	</html>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>		
		//提交任务
		function commitAction(){
			var thisPhaseAction  = "";
			var thisPhaseOpinion1 = "";
			iLength  = document.forms("Phase").PhaseAction.length;
			for(var i = 0;i <= iLength - 1;i++)
			{
				if (document.forms("Phase").PhaseAction.item(i).selected)
				{
					if(document.forms("Phase").PhaseAction.item(i).value != "")
					{
			    			thisPhaseAction += "," + document.forms("Phase").PhaseAction.item(i).value;
			    	}
			    }
			}
			
			iLength =  document.forms("Phase").PhaseOpinion1.length;
			//有下面这些情况，就不要提交，进入下一个选择提交对象对话框
			for(var i = 0;i <= iLength - 1;i++)
			{
				if (document.forms("Phase").PhaseOpinion1.item(i).selected)
				{
					if(document.forms("Phase").PhaseOpinion1.item(i).value != "")
					{
			    		thisPhaseOpinion1 += "," + document.forms("Phase").PhaseOpinion1.item(i).value;	
			    		if (document.forms("Phase").PhaseOpinion1.item(i).value.search("提交")>=0)
			    		{
			    			self.returnValue = document.forms("Phase").PhaseOpinion1.item(i).value;
			    			self.close();	
			    			return;			    		
			    		}		    		
			    		if (document.forms("Phase").PhaseOpinion1.item(i).value.search("同意")>=0)
			    		{
			    			self.returnValue = document.forms("Phase").PhaseOpinion1.item(i).value;
			    			self.close();	
			    			return;			    		
			    		}
			    		if (document.forms("Phase").PhaseOpinion1.item(i).value.search("分配")>=0)
			    		{
			    			self.returnValue = document.forms("Phase").PhaseOpinion1.item(i).value;
			    			self.close();	
			    			return;			    		
			    		}
			    		if (document.forms("Phase").PhaseOpinion1.item(i).value.search("申请")>=0)
			    		{
			    			self.returnValue = document.forms("Phase").PhaseOpinion1.item(i).value;
			    			self.close();	
			    			return;			    		
			    		}
			    		if (document.forms("Phase").PhaseOpinion1.item(i).value.search("补充完全")>=0)
			    		{
			    			self.returnValue = document.forms("Phase").PhaseOpinion1.item(i).value;
			    			self.close();	
			    			return;			    		
			    		}
		    		}
		    	}
			}
			thisPhaseAction = thisPhaseAction.substring(1);			
			thisPhaseOpinion1 = thisPhaseOpinion1.substring(1);	
						
			if(thisPhaseAction.length == 0 && thisPhaseOpinion1.length == 0)
			{				
				alert("请先进行提交动作选择 ！");
			}else if(thisPhaseAction.length > 0 && thisPhaseOpinion1.length > 0)
			{
				alert("不能同时选择两个提交动作！");
				document.forms("Phase").PhaseAction.item(0).selected = true;
				document.forms("Phase").PhaseOpinion1.item(0).selected = true;
			}else if (thisPhaseAction == '<%=CurUser.UserID%>')
			{
				alert("提交对象不能为当前用户！");
				return;
			}else
			{						
				var sPhaseInfo = PopPage("/Common/BusinessFlow/GetNextFlowPhaseAction.jsp?SerialNo=<%=sSerialNo%>&PhaseAction="+thisPhaseAction+"&PhaseOpinion1="+thisPhaseOpinion1+"&rand="+randomNumber(),"_blank","");
				if (confirm(sPhaseInfo+"\r\n 确定提交吗？"))
				{
					sReturnValue = PopPage("/Common/BusinessFlow/SubmitAction.jsp?SerialNo=<%=sSerialNo%>&PhaseOpinion1="+thisPhaseOpinion1+"&PhaseAction="+thisPhaseAction,"","");
					self.returnValue = sReturnValue;   				
					self.close();
				}
			}	
		}
		//取消提交
		function doCancel()
		{
			if (confirm("将要放弃该次提交，确定吗？"))
			{
				self.returnValue = "_CANCEL_";
				self.close();
			}
		}
</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
