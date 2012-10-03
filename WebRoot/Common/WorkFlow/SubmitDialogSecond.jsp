<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author: byhu 2004-12-06 
		Tester:
		Describe: 提交选择框
		Input Param:
			SerialNo：任务流水号
			PhaseOpinion1：意见
		Output Param:
		HistoryLog: zywei 2005/08/01	
					cdeng 2009-02-17
					lpzhang 2009-8-14 for TJ
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<% 
	//获取参数：任务流水号、意见
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//String sPhaseOpinion1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseOpinion1"));
	
	//定义变量：流程编号、阶段编号、对象编号
	String sFlowNo = "",sPhaseNo = "",sObjectNo = "";
	//定义变量：动作、动作列表、阶段的类型、动作提示、阶段的属性
	String sPhaseAction = "",sActionList[],sSelectStyle = "",sActionDescribe = "",sPhaseAttribute = ""; 
	String sSql="";
	ASResultSet rsTemp = null;
%>
<%/*~END~*/%>	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义业务逻辑主体;]~*/%>
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
	
	System.out.println("sFlowNO:"+sFlowNo+"%sPhaseNo:"+sPhaseNo);
	
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
	//获取动作选择列表
	sActionList = ftBusiness.getActionList("");
	if (sActionList == null) 
	{ 
		sActionList = new String[1];
		sActionList[0] = "";
	}	
	
	String sActionValue[];
	String sTempString1 = "";
	int iCount=sActionList.length;
	sActionValue = new String[iCount];

	for(int i=0;i<iCount;i++)
	{
		
		sSql = "select LoginID||'  '||UserName from USER_INFO where UserID = '"+sActionList[i]+"' ";
		rsTemp = Sqlca.getASResultSet(sSql);
		if(rsTemp.next())
		{
			sActionValue[i] = rsTemp.getString(1);
		}
		rsTemp.getStatement().close();
	}
	if(sActionValue[0] == null)
	{
		sActionValue = sActionList;
	}
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义选择提交动作界面风格;]~*/%>
	<html>
	<head> 
		<link rel="stylesheet" href="<%=sResourcesPath%>/style.css">
		<title>提交动作选择列表</title>
	</head>
	<body class="ShowModalPage" leftmargin="0" topmargin="0" onload="" >

	<form name="Phase" method="post" target="_top">
 		<table width="100%"> 
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
		           <tr height=1> 
			          <td colspan="5" valign="top" ><hr></td>
			       </tr>	 		       
	               <table align="center">						
							<tr>
								<td valign="top" width=1><img src="<%=sResourcesPath%>/TN_031.gif" width="123" height="80"></td>
					  		    <td colspan=4>
									<select size=8 <%=sSelectStyle%> <%=sSelectStyle%> name="PhaseAction"  class="select1">
			                  		<!-- 	<option value='' style='color:white'>------------------------</option>remarked by lpzhang 防止该项被选中 -->
			                  			<%=HTMLControls.generateDropDownSelect(sActionList,sActionValue,"")%> 
									</select>
								</td>
							</tr> 
	                	 	<tr>
	                	 	    <td colspan=4></td>
	                	 	</tr> 
					</table>
				</td>
			</tr>
		</table> 
	 <p>	       
	 <input name="SelectedCount" readonly type="text" style="font-size: 9pt;background-color:#DEDFCE;border-style=none" > 
	</form>	
	<!-- 未通过额度检查提示 
	<form name="Phase1"  target="_top">
 		<table width="100%" align="center" border="2" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF"> 
		  	<tr width="100%" > 
		  		<td width="100%"  valign="top" >
	 		       <table width="100%" border="1" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">
					<tr>
						<font color='blue'>对不起，您没有权限审批该业务！</font>
					</tr>
		           </table>
		           
				</td>
			</tr>
		</table>       
	</form>	
	-->
	</body>
	</html>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

		var thisPhaseAction  = "";
		var thisPhaseOpinion1  = "";
		//提交任务
		function commitAction()
		{
			var sReturnValue = "";
			var thisPhaseAction = "";
			var FlowNo = "<%=sFlowNo%>";		
			var PhaseNo = "<%=sPhaseNo%>";	
			var n = 0 ;//add by lpzhang  2009-8-18 分发人员分发数量控制		
			iLength  = document.forms("Phase").PhaseAction.length;
			
			for(i = 0;i <= iLength - 1;i++)
			{	
				if (document.forms("Phase").PhaseAction.item(i).selected)
				{
					var thisPhaseAction1 = thisPhaseAction.length;
					var tempPhaseAction=document.forms("Phase").PhaseAction.item(i);// add by cdeng 2009-02-17
					var index=tempPhaseAction.value.indexOf(" ",0);	
					if(index>=0)//下阶段有角色，只取用户ID
						thisPhaseAction += "," + tempPhaseAction.value.substring(0,index);
					else//下阶段无角色
						thisPhaseAction += "," + tempPhaseAction.value;
					if(thisPhaseAction.length>1 && thisPhaseAction.length != thisPhaseAction1) n++;
				}
			}	
			thisPhaseAction = thisPhaseAction.substring(1);
			if(thisPhaseAction.length == 0) alert("请先进行提交动作选择 !");
			else if (thisPhaseAction == '<%=CurUser.UserID%>')
			{
				alert("提交对象不能为当前用户！");
			}//支行审批小组分发员、分行贷审会秘书、总行贷前秘书分发业务人员控制  
			
			else if(n<3 && ((FlowNo.indexOf("EntCreditFlowTJ01") == 0 && PhaseNo.indexOf("0030") == 0) || 
			                //(FlowNo.indexOf("EntCreditFlowTJ01") == 0 && PhaseNo.indexOf("0150") == 0) ||
			                //(FlowNo.indexOf("EntCreditFlowTJ01") == 0 && PhaseNo.indexOf("0280") == 0) ||
			                (FlowNo.indexOf("IndCreditFlowTJ01") == 0 && PhaseNo.indexOf("0030") == 0) ||
			                //(FlowNo.indexOf("IndCreditFlowTJ01") == 0 && PhaseNo.indexOf("0150") == 0) ||
			                //(FlowNo.indexOf("IndCreditFlowTJ01") == 0 && PhaseNo.indexOf("0280") == 0) ||
			                (FlowNo.indexOf("CreditFlow03") == 0 && PhaseNo.indexOf("0250") == 0) 
			                )
			      )
		     {
			      alert("分发人员不能低于3人！");
			      return;
			 }	
			 		
			else {
				/*
				if( (FlowNo.indexOf("EntCreditFlowTJ01") == 0 && PhaseNo.indexOf("0150") == 0) ||
				(FlowNo.indexOf("IndCreditFlowTJ01") == 0 && PhaseNo.indexOf("0150") == 0) ){
					dReturn = PopPage("/Common/WorkFlow/CheckBusinessSubmit.jsp?PhaseAction="+thisPhaseAction+"&RoleID=218&rand="+randomNumber(),"_blank","");
					if(dReturn < 1){
						alert("没有选择提交给“区县行社信审会主任委员”，请重新选择！");
						return;
					}	
				}
				else if( (FlowNo.indexOf("EntCreditFlowTJ01") == 0 && PhaseNo.indexOf("0280") == 0) || 	                 
		                 (FlowNo.indexOf("IndCreditFlowTJ01") == 0 && PhaseNo.indexOf("0280") == 0) ||
				         (FlowNo.indexOf("CreditFlow03") == 0 && PhaseNo.indexOf("0250") == 0)){
					dReturn = PopPage("/Common/WorkFlow/CheckBusinessSubmit.jsp?PhaseAction="+thisPhaseAction+"&RoleID=016&rand="+randomNumber(),"_blank","");
					if(dReturn < 1){
						alert("没有选择提交给“总行授信审查委员会主任委员”，请重新选择！");
						return;
					}
				}
				*/
				var sPhaseInfo = PopPage("/Common/WorkFlow/GetNextFlowPhaseAction.jsp?SerialNo=<%=sSerialNo%>&PhaseAction="+thisPhaseAction+"&PhaseOpinion1="+thisPhaseOpinion1+"&rand="+randomNumber(),"_blank","");
				if (confirm(sPhaseInfo+"\r\n 确定提交吗？"))
				{
					sReturnValue = PopPage("/Common/WorkFlow/SubmitAction.jsp?SerialNo=<%=sSerialNo%>&PhaseOpinion1="+thisPhaseOpinion1+"&PhaseAction="+thisPhaseAction+"&rand="+randomNumber(),"","");
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
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>	