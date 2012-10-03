<%@ page import="com.amarsoft.are.util.StringFunction" %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 我的工作台
		Input Param:
			          
		Output param:
			      
		History Log: 
	 */
	%>
<%/*~END~*/%>
<%
     String sSql ;
     ASResultSet rs;
%>

<html>
<head>
<title>日常工作提示</title>

<link rel="stylesheet" href="Style.css">

</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
 <tr valign="top">
    <td>
      <div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
        <table align='center' cellspacing=0 cellpadding=0 border=0 width=95% height="95%">
          <tr>
            <td align='center' valign='top'>
              <table border=0 width='100%' height='100%'>
                <tr>
                  <td valign='top'>
                    <table width="100%" border="0" cellspacing="0" cellpadding="4">
                      <tr>
                        <td width="20%" valign="top" align="center">
                          <p><br>
                          <%
	                          String sPic = StringFunction.getNow().substring(7);
	                          sPic+=".gif";
                          %>
                          <img src="<%=sResourcesPath%>/DailyPics/<%=sPic%>">
                          </p>
                          <p><a href="javascript:self.location.reload();">刷新</a></p>  
                        </td>
                        <td valign="top">
                          <table align='left' border="0" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" width="100%" >
							<!-------------------我自己安排的工作------------------------------------------------->
							 <tr hight="1">
                                <td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif" >
		                          <table border="0" cellspacing="0" cellpadding="0">
									<tr><td onclick="WorkPlan();">
									<img style="display: "  class="FilterIcon" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="PlanPlus" >
									<img style="display:none " class="FilterIcon2" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="PlanMinus" >
									</td><td onclick="WorkPlan();"><b><a href="#" >我自己安排的工作计划&nbsp;<span id="PlanSpan"></span>&nbsp;件</a></b>&nbsp;&nbsp;&nbsp;&nbsp;
							    </td><!-- td><b><a href="newTask();">新增</a></b></td--></tr></table>
	                           </td>
                           </tr>
							<tr>
								<td align="left" colspan="2" id="WorkPlanInfo"></td>
							</tr>
	                        <tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
			                 
			                <%
	                        	//客户经理，总行信贷风险审查员，总行信贷风险审批岗 
							    if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")||
							    	CurUser.hasRole("450") || CurUser.hasRole("250") || CurUser.hasRole("050")||
							    	CurUser.hasRole("451") || CurUser.hasRole("251") || CurUser.hasRole("051")
							    	)
							    {
							%> 
	                        <tr>
							    <td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif" >
		                          <table border="0" cellspacing="0" cellpadding="0">
									<tr><td onclick="ApplyUnfinished();">
									<img style="display:" class="FilterIcon" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="ApplyUnfinishedPlus" >
									<img style="display:none" class="FilterIcon2" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="ApplyUnfinishedMinus" >
									</td><td onclick="ApplyUnfinished();"><b><a href="#" >待处理的授信业务申请&nbsp;<span id="ApplayUnfinishedSpan"></span>&nbsp;件</a></b></td></tr></table>
	                           </td>
	                        </tr>
							<tr>
	                        	<td align="left" colspan="2" id="ApplayUnfinished"></td>
	                        </tr>
				           	<tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
			                
	                        <%
	                			}
	                        	//客户经理，放款录入员，放款审查员，放款审核员
							    if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")||
							    	CurUser.hasRole("458") || CurUser.hasRole("258") || CurUser.hasRole("058")||
							    	CurUser.hasRole("457") || CurUser.hasRole("257") || CurUser.hasRole("057")||
							    	CurUser.hasRole("410") || CurUser.hasRole("210") || CurUser.hasRole("060") ||
							    	CurUser.hasRole("460") || CurUser.hasRole("260") || CurUser.hasRole("259") ||
							    	CurUser.hasRole("059") || CurUser.hasRole("2C1") || CurUser.hasRole("0C1") ||
							    	CurUser.hasRole("0E5")  
							    	)
							    {
							%>  
	                       <tr>
	                           <td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif" >
		                          <table border="0" cellspacing="0" cellpadding="0">
									<tr><td onclick="LoanAjaxInf();">
									<img style="display:" class="FilterIcon" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="LoanPlus" >
									<img style="display:none" class="FilterIcon2" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="LoanMinus" >
									</td><td onclick="LoanAjaxInf();"><b><a href="#" >待处理的放款&nbsp;<span id="LoanAjaxInfSpan"></span>&nbsp;件</a></b></td></tr></table>
	                           </td>
	                        </tr>
	                        <tr>
	                        	<td align="left" colspan="2" id="LoanInfo"></td>
	                        </tr>
	                         <tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
	                        <%
	                			}
	                        	//预警登记员,预警认定员
							    if(CurUser.hasRole("2D3") || CurUser.hasRole("080") || CurUser.hasRole("280") 
							    		|| CurUser.hasRole("2A5") || CurUser.hasRole("480") || CurUser.hasRole("2J4")
							    		|| CurUser.hasRole("083") || CurUser.hasRole("283") || CurUser.hasRole("483") 
							    		|| CurUser.hasRole("084") || CurUser.hasRole("284") || CurUser.hasRole("484") 
							    		|| CurUser.hasRole("410") || CurUser.hasRole("2C4") || CurUser.hasRole("2C3") 
							    		|| CurUser.hasRole("2C1") || CurUser.hasRole("0C1") || CurUser.hasRole("210") 
							    		|| CurUser.hasRole("211") || CurUser.hasRole("011") || CurUser.hasRole("2D1") 
							    		|| CurUser.hasRole("0C3") || CurUser.hasRole("0C4") || CurUser.hasRole("0J0") 
							    		|| CurUser.hasRole("012") || CurUser.hasRole("010") || CurUser.hasRole("2J2") 
							    		|| CurUser.hasRole("0Q1") || CurUser.hasRole("289") || CurUser.hasRole("089") 
							    		|| CurUser.hasRole("208") || CurUser.hasRole("2A1")
							    	)
							    {
							%>  
	                       <tr>
	                           <td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif" >
		                          <table border="0" cellspacing="0" cellpadding="0">
									<tr><td onclick="RiskSignalAjaxInf();">
									<img style="display:" class="FilterIcon" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="RiskSignalPlus" >
									<img style="display:none" class="FilterIcon2" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="RiskSignalMinus" >
									</td><td onclick="RiskSignalAjaxInf();"><b><a href="#" >待处理的预警申请&nbsp;<span id="RiskSignalAjaxInfSpan"></span>&nbsp;件</a></b></td></tr></table>
	                           </td>
	                        </tr>
	                        <tr>
	                        	<td align="left" colspan="2" id="RiskSignalInfo"></td>
	                        </tr>
	                         <tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
	                        
	                        <%
	                			}
	                        	//客户经理，信用等级审查员 2D3,2D1,480,080,0J0,410,210,2C4,059,041,241
							    if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")||
							    	CurUser.hasRole("441") || CurUser.hasRole("241") || CurUser.hasRole("041")|| 
							    	CurUser.hasRole("0J0") ||   CurUser.hasRole("2D3") || CurUser.hasRole("2D1") ||
							    	CurUser.hasRole("2C4") ||  CurUser.hasRole("210") ||  CurUser.hasRole("410")||
							    	CurUser.hasRole("243") || CurUser.hasRole("043") || CurUser.hasRole("2A1")||
							    	CurUser.hasRole("2A5")
							    	)
							    {
							%>  
	                       <tr>
	                           <td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif" >
		                          <table border="0" cellspacing="0" cellpadding="0">
									<tr>
									<td /*onclick="UnFinishClassifyAjaxInf();"*/><b><a href="#" onClick=ClassifyLink()>待处理的风险分类业务申请&nbsp;<span id="UnFinishClassifySpan"></span>&nbsp;件</a></b></td></tr></table>
	                           </td>
	                        </tr>
	                        <tr>
	                        	<td align="left" colspan="2" id="UnFinishClassify"></td>
	                        </tr>
	                         <tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
	                        
	                        <%
	                			}
	                        	//客户经理，信用等级审查员
							  /* remarked by lpzhang  if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")||CurUser.hasRole("442") || CurUser.hasRole("242") || CurUser.hasRole("042"))
							    {
							%>  
	                       <tr>
	                           <td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif" >
		                          <table border="0" cellspacing="0" cellpadding="0">
									<tr><td onclick="UnFinishEvaluateAjaxInf();">
									<img style="display:" class="FilterIcon" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="EvaluatePlus" >
									<img style="display:none" class="FilterIcon2" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="EvaluateMinus" >
									</td><td onclick="UnFinishEvaluateAjaxInf();"><b><a href="#" >待处理的信用等级申请&nbsp;<span id="UnFinishEvaluateSpan"></span>&nbsp;件</a></b></td></tr></table>
	                           </td>
	                        </tr>
	                        <tr>
	                        	<td align="left" colspan="2" id="UnFinishEvaluate"></td>
	                        </tr>
	                         <tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
	                       	<%
							   	}*/
							    /* 	//不良业务审查员
							    if(CurUser.hasRole("0G3"))
							    {
							%>  
	                        <tr>
	                           <td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif" >
		                          <table border="0" cellspacing="0" cellpadding="0">
									<tr><td onclick="BadBizApplyAjaxInf();">
									<img style="display:" class="FilterIcon" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="BadBizPlus" >
									<img style="display:none" class="FilterIcon2" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="BadBizMinus" >
									</td><td onclick="BadBizApplyAjaxInf();"><b><a href="#" >待审批的不良业务申请&nbsp;<span id="BadBizApplySpan"></span>&nbsp;件</a></b></td></tr></table>
	                           </td>
	                        </tr>
	                        <tr>
	                        	<td align="left" colspan="2" id="BadBizApply"></td>
	                        </tr>
	                         <tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
							<%
							    }
							   	*/
								//具有支行客户经理、分行客户经理、总行客户经理角色的用户可以从日常工作提示中直接进入贷后检查报告
							    if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
							    {
							%> 
							<tr>
					 	      <td align="left" >&nbsp;&nbsp;<a href="#" onClick=Inspect4()><font color=blue>已审批通过未登记合同&nbsp;<span id="NotRegistryBCSpan"></span>&nbsp;件</font>&nbsp;</td>	   
						    </tr>
						    <tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
	                        
					        <tr>
					 	      <td align="left" >&nbsp;&nbsp;<a href="#" onClick=Inspect1()><font color=blue>风险检查报告</font>&nbsp;</td>	   
						    </tr>
						    <tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
	                        
						    
							<%   
							    }
							    //具有支行信贷风险贷后检查员、分行信贷风险贷后检查员、总行信贷风险贷后检查员角色的用户可以从日常工作提示中直接进入贷后检查报告
							    if(CurUser.hasRole("040") || CurUser.hasRole("240") || CurUser.hasRole("440"))
							    {
							%>
					        <tr>
					 	      <td align="left" >&nbsp;&nbsp;<a href="#" onClick=Inspect2()><font color=blue>风险检查报告</font>&nbsp;</td>	   
						    </tr>
							<%
								}
								//具有支行客户权限审查员、分行客户权限审查员、总行客户权限审查员角色的用户可以从日常工作提示中直接进入客户权限管理
								if(CurUser.hasRole("028") || CurUser.hasRole("228") || CurUser.hasRole("428") || CurUser.hasRole("0A0") || CurUser.hasRole("0D0"))
								{
							%>
						    <tr>
						 	   <td align="left" >&nbsp;&nbsp;<a href="#" onClick=Inspect3()><font color=blue>客户权限管理未处理申请&nbsp;<span id="RightModifySpan"></span>&nbsp;件</font>&nbsp;</td>	   
							</tr>
							<%
							   	}
							//具有不良业务审查员
							if(CurUser.hasRole("0G3"))
							{
							%>
						    <tr>
						 	   <td align="left" >&nbsp;&nbsp;<b>待审查审批的不良业务申请&nbsp;<span id="BadBizApplySpan"></span>&nbsp;件</b>&nbsp;</td>	   
							</tr>
							<%
						   	}
							 //1、各级（支行、中心支行、总行）不良资产管理员：
								if(CurUser.hasRole("064") || CurUser.hasRole("264") || CurUser.hasRole("464"))
								{
							%>
						    <tr>
						 	   <td align="left" >&nbsp;&nbsp;<b>[不良资产]台账基本信息超过90天未维护：&nbsp;<span id="BasicBBAccountSpan"></span>&nbsp;</b>&nbsp;</td>
						 	</tr>
						 	<tr>
						 	   <td align="left" >&nbsp;&nbsp;<b>[不良资产]不良贷款超过90天未催收：&nbsp;<span id="BadBizDunSpan"></span>&nbsp;</b>&nbsp;</td>
						 	</tr>
						 	<tr>
						 	   <td align="left" >&nbsp;&nbsp;<b>[不良资产]诉讼时效到期提示：&nbsp;<span id="BadBizLawSpan"></span>&nbsp;</b>&nbsp;</td>
						 	</tr>
						 	<tr>
						 	   <td align="left" >&nbsp;&nbsp;<b>[不良资产]担保时效到期提示：&nbsp;<span id="BadBizVouchSpan"></span>&nbsp;</b>&nbsp;</td>	   
							</tr>
							<%
							   	}
							 //1、各级（支行、中心支行、总行）不良资产内勤综合员：
								if(CurUser.hasRole("095") || CurUser.hasRole("295") || CurUser.hasRole("495") )
								{
							%>
						    <tr>
						 	   <td align="left" >&nbsp;&nbsp;<b>[不良资产]不良资产台账待登记：&nbsp;<span id="WaitForAccountSpan"></span>&nbsp;</b>&nbsp;</td>
						 	</tr>
						 	<tr>
						 	   <td align="left" >&nbsp;&nbsp;<b>[不良资产]台账账务信息超过30天未维护：&nbsp;<span id="BadBizAccountSpan"></span>&nbsp;</b>&nbsp;</td>
						 	</tr>
						 	<%
							   	}
							 //1、中心支行资产保全部（总）经理；
								 if(CurUser.hasRole("2G1") )
								{
							%>
						    <tr>
						 	   <td align="left" >&nbsp;&nbsp;<b>[不良资产]待指定管理机构：&nbsp;<span id="WaitBadBizOrgSpan"></span>&nbsp;</b>&nbsp;</td>
						 	</tr>
							<%
							   	}
							 //1、总行、中心支行资产保全部（总）经理；支行行长
								 if(CurUser.hasRole("410") || CurUser.hasRole("0G1") || CurUser.hasRole("2G1") )
								{
							%>
						 	<tr>
						 	   <td align="left" >&nbsp;&nbsp;<b>[不良资产]待指定管理人：&nbsp;<span id="WaitBadBizUserSpan"></span>&nbsp;</b>&nbsp;</td>
						 	</tr>
							<%
							   	}
							 %>							
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </div>
    </td>
  </tr>
</table>
</body>
</html>
<script language=javascript>
	//function newTask(){
	//	popComp("NewWork","/DeskTop/WorkRecordInfo.jsp","NoteType=All&PlanDate=<%=StringFunction.getToday()%>","dialogwidth:640px;dialogheight:480;");
	//}
	xmlHttpObject1 = null;
	xmlHttpObject2 = null;
	xmlHttpObject3 = null;
	xmlHttpObject4 = null;
	xmlHttpObject5 = null;
	function editWork(sSerialNo,sNoteType,sObjectNo){ 
		popComp("NewWork","/DeskTop/WorkRecordInfo.jsp","SerialNo="+sSerialNo,"dialogwidth:640px;dialogheight:480;");
	}
		
	function Inspect1()
	{
	    OpenComp("BusinessInspectMain","/CreditManage/CreditCheck/BusinessInspectMain.jsp","ComponentName=贷后检查&ComponentType=MainWindow&TreeviewTemplet=BusinessInspectMain","_top","");
	}
	function Inspect2()
	{
	    OpenComp("BusinessInspectMain","/CreditManage/CreditCheck/BusinessInspectMain.jsp","ComponentName=贷后检查&ComponentType=MainWindow&TreeviewTemplet=BusinessInspectMain","_top","");
	}
	function Inspect3()
	{
	    OpenComp("RightModifyMain","/SystemManage/GeneralSetup/RightModifyMain.jsp","ComponentName=客户管户权管理&ComponentType=MainWindow&TreeviewTemplet=RightModifyMain","_top","")
	}
	function Inspect4()
	{
	    OpenComp("BookInContractMain","/CreditManage/CreditPutOut/BookInContractMain.jsp","ComponentName=合同管理&ComponentType=MainWindow&TreeviewTemplet=BookInContractMain&DefaultTVItemName=待登记要素的合同","_top","")
	}
	
	function ClassifyLink(){
		if(<%=CurUser.hasRole("480")%> || <%=CurUser.hasRole("080")%>|| <%=CurUser.hasRole("280")%> || <%=CurUser.hasRole("2D3")%> )
			OpenComp("ClassifyApplyMain","/Common/WorkFlow/ApplyMain.jsp","ComponentName=风险分类&ComponentType=MainWindow&ApplyType=ClassifyApply","_top","")
		else 
			OpenComp("ApproveClassifyMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=风险分类认定&ComponentType=MainWindow&ApproveType=ApproveClassifyApply","_top","");
	}
	//ajax公用函数
	function getXmlHttpObject()
	{
		var xmlHttp = null;
		try {
			// Firefox, Opera 8.0+, Safari
			xmlHttp = new XMLHttpRequest();
		} catch (e) {
			// Internet Explorer
			try {
				xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
		}
		return xmlHttp;
	}
/*----------------------------------------------统计件数-----------------------------------------------------------*/
	//统计自己安排的工作计划件数
	function CountPlan()
	{
		xmlHttpObject1=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/WorkPlanAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject1.onreadystatechange = CountPlanAction;
		xmlHttpObject1.open("GET", url, true);
		xmlHttpObject1.send(null);
	}
	function CountPlanAction() 
	{
		var message = "";
		if (xmlHttpObject1.readyState == 4) {
			message = xmlHttpObject1.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("PlanSpan").innerHTML = message;
	}
	
	//统计待处理的信贷业务申请件数
	function CountUnfinishedApply()
	{
		xmlHttpObject2=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/ApplayAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject2.onreadystatechange = CountUnfinishedApplyAction;
		xmlHttpObject2.open("GET", url, true);
		xmlHttpObject2.send(null);
		return;
	}
	function CountUnfinishedApplyAction() 
	{
		var message = "";
		if (xmlHttpObject2.readyState == 4) {
			message = xmlHttpObject2.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("ApplayUnfinishedSpan").innerHTML = message;
	}
	
	//统计待处理的批复件数
	function CountUnfinishedSurvery()
	{
		xmlHttpObject3=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/ApplaySurveryAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject3.onreadystatechange = unfinishedSurvery2;
		xmlHttpObject3.open("GET", url, true);
		xmlHttpObject3.send(null);
		return;
	}
	function unfinishedSurvery2() 
	{
		var message = "";
		if (xmlHttpObject3.readyState == 4) {
			message = xmlHttpObject3.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("ApplaySurverySpan").innerHTML = message;
	}
	
	//统计待登记的合同件数
	function CountContractSpan()
	{
		var message = "";
		xmlHttpObject4=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/ContractAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject4.onreadystatechange = ContractSpan2;
		xmlHttpObject4.open("GET", url, true);
		xmlHttpObject4.send(null);
		return;
	}
	function ContractSpan2() 
	{
		var message = "";
		if (xmlHttpObject4.readyState == 4) {
			message = xmlHttpObject4.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
		    message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("ContractSpan").innerHTML = message;
	}
	
	//统计待处理的放款件数
	function CountUnfinishedLoan()
	{
		xmlHttpObject5=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/LoanAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject5.onreadystatechange = unfinishedLoan2;
		xmlHttpObject5.open("GET", url, true);
		xmlHttpObject5.send(null);
		return;
	}
	function unfinishedLoan2() 
	{
		var message = "";
		if (xmlHttpObject5.readyState == 4) {
			message = xmlHttpObject5.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("LoanAjaxInfSpan").innerHTML = message;
	}
	
	//统计待处理的信用等级申请
	function CountUnfinishedEvaluate()
	{
		xmlHttpObject6=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/UnFinishEvaluateAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject6.onreadystatechange = unfinishedEvaluate;
		xmlHttpObject6.open("GET", url, true);
		xmlHttpObject6.send(null);
		return;
	}
	function unfinishedEvaluate() 
	{
		var message = "";
		if (xmlHttpObject6.readyState == 4) {
			message = xmlHttpObject6.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("UnFinishEvaluateSpan").innerHTML = message;
	}
	
		//统计待处理的不良业务申请
	function CountBadBizApply()
	{
		xmlHttpObject7=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/BadBizApplyAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject7.onreadystatechange = BadBizApplyAction;
		xmlHttpObject7.open("GET", url, true);
		xmlHttpObject7.send(null);
		return;
	}
	function BadBizApplyAction() 
	{
		var message = "";
		if (xmlHttpObject7.readyState == 4) {
			message = xmlHttpObject7.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("BadBizApplySpan").innerHTML = message;
	}
	
	//统计待处理的风险分类申请
	function CountUnfinishedClassify()
	{
		xmlHttpObject8=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/UnFinishClassifyAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject8.onreadystatechange = unfinishedClassify;
		xmlHttpObject8.open("GET", url, true);
		xmlHttpObject8.send(null);
		return;
	}
	function unfinishedClassify() 
	{
		var message = "";
		if (xmlHttpObject8.readyState == 4) {
			message = xmlHttpObject8.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("UnFinishClassifySpan").innerHTML = message;
	}
	
	
	
	//台账基本信息超过90天未维护
	function CountBasicBBAccount()
	{
		xmlHttpObject9=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/BasicBBAccountAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject9.onreadystatechange = BasicBBAccountAction;
		xmlHttpObject9.open("GET", url, true);
		xmlHttpObject9.send(null);
		return;
	}
	function BasicBBAccountAction() 
	{
		var message = "";
		if (xmlHttpObject9.readyState == 4) {
			message = xmlHttpObject9.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("BasicBBAccountSpan").innerHTML = message;
	}
	
	//不良贷款超过90天未催收：
	function CountBadBizDun()
	{
		xmlHttpObject11=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/BadBizDunAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject11.onreadystatechange = BadBizDunAction;
		xmlHttpObject11.open("GET", url, true);
		xmlHttpObject11.send(null);
		return;
	}
	function BadBizDunAction() 
	{
		var message = "";
		if (xmlHttpObject11.readyState == 4) {
			message = xmlHttpObject11.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("BadBizDunSpan").innerHTML = message;
	}	
	
	
	//诉讼时效到期提示：
	function CountBadBizLaw()
	{
		xmlHttpObject12=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/BadBizLawAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject12.onreadystatechange = BadBizLawAction;
		xmlHttpObject12.open("GET", url, true);
		xmlHttpObject12.send(null);
		return;
	}
	function BadBizLawAction() 
	{
		var message = "";
		if (xmlHttpObject12.readyState == 4) {
			message = xmlHttpObject12.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("BadBizLawSpan").innerHTML = message;
	}	
	
	
	//担保时效到期提示：
	function CountBadBizVouch()
	{
		xmlHttpObject13=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/BadBizVouchAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject13.onreadystatechange = BadBizVouchAction;
		xmlHttpObject13.open("GET", url, true);
		xmlHttpObject13.send(null);
		return;
	}
	function BadBizVouchAction() 
	{
		var message = "";
		if (xmlHttpObject13.readyState == 4) {
			message = xmlHttpObject13.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("BadBizVouchSpan").innerHTML = message;
	}
	
	
	//不良资产台账待登记：
	function CountWaitForAccount()
	{
		xmlHttpObject14=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/WaitForAccountAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject14.onreadystatechange = WaitForAccountAction;
		xmlHttpObject14.open("GET", url, true);
		xmlHttpObject14.send(null);
		return;
	}
	function WaitForAccountAction() 
	{
		var message = "";
		if (xmlHttpObject14.readyState == 4) {
			message = xmlHttpObject14.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("WaitForAccountSpan").innerHTML = message;
	}
	
	//台账账务信息超过30天未维护： 
	function CountBadBizAccount()
	{
		xmlHttpObject15=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/BadBizAccountAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject15.onreadystatechange = BadBizAccountAction;
		xmlHttpObject15.open("GET", url, true);
		xmlHttpObject15.send(null);
		return;
	}
	function BadBizAccountAction() 
	{
		var message = "";
		if (xmlHttpObject15.readyState == 4) {
			message = xmlHttpObject15.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("BadBizAccountSpan").innerHTML = message;
	}
	
	
	//待指定管理机构 
	function CountWaitBadBizOrg()
	{
		xmlHttpObject16=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/WaitBadBizOrgAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject16.onreadystatechange = WaitBadBizOrgAction;
		xmlHttpObject16.open("GET", url, true);
		xmlHttpObject16.send(null);
		return;
	}
	function WaitBadBizOrgAction() 
	{
		var message = "";
		if (xmlHttpObject16.readyState == 4) {
			message = xmlHttpObject16.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("WaitBadBizOrgSpan").innerHTML = message;
	}
	
	//待指定管理人
	function CountWaitBadBizUser()
	{
		xmlHttpObject17=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/WaitBadBizUserAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject17.onreadystatechange = WaitBadBizUserAction;
		xmlHttpObject17.open("GET", url, true);
		xmlHttpObject17.send(null);
		return;
	}
	function WaitBadBizUserAction() 
	{
		var message = "";
		if (xmlHttpObject17.readyState == 4) {
			message = xmlHttpObject17.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("WaitBadBizUserSpan").innerHTML = message;
	}
	
	//统计待处理客户权限管理件数
	function CountRightModify()
	{
		xmlHttpObject18=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/RightModifyAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject18.onreadystatechange = CountRightModifyAction;
		xmlHttpObject18.open("GET", url, true);
		xmlHttpObject18.send(null);
		return;
	}
	function CountRightModifyAction() 
	{
		var message = "";
		if (xmlHttpObject18.readyState == 4) {
			message = xmlHttpObject18.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}	
		document.getElementById("RightModifySpan").innerHTML = message;
	}
	
	//统计审批通过未登记合同的件数
	function CountNotRegistryBC()
	{
		xmlHttpObject19=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/NotRegistryBCAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject19.onreadystatechange = CountNotRegistryBCAction;
		xmlHttpObject19.open("GET", url, true);
		xmlHttpObject19.send(null);
		return;
	}
	function CountNotRegistryBCAction() 
	{
		var message = "";
		if (xmlHttpObject19.readyState == 4) {
			message = xmlHttpObject19.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("NotRegistryBCSpan").innerHTML = message;
	}
	
	
	//统计待处理的预警件数
	function CountUnfinishedRiskSignal()
	{
		xmlHttpObject20=getXmlHttpObject();
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/RiskSignalAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=0";
		xmlHttpObject20.onreadystatechange = unfinishedRiskSignal2;
		xmlHttpObject20.open("GET", url, true);
		xmlHttpObject20.send(null);
		return;
	}
	function unfinishedRiskSignal2() 
	{
		var message = "";
		if (xmlHttpObject20.readyState == 4) {
			message = xmlHttpObject20.responseText;
			message="<font color=red>"+message+"</font>";
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
		}
		document.getElementById("RiskSignalAjaxInfSpan").innerHTML = message;
	}
	
	
/*----------------------------------------------列表展示-----------------------------------------------------------*/
	//我自己安排的工作计划
	function WorkPlan(){
		xmlHttp=getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(document.all("WorkPlanInfo").innerHTML == ""){
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/WorkPlanAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=1";
		xmlHttp.onreadystatechange = MyPlan;
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		document.getElementById("PlanPlus").style.display = "none";
		document.getElementById("PlanMinus").style.display = "";
		}else{
			document.all("WorkPlanInfo").innerHTML="";
			document.getElementById("PlanPlus").style.display = "";
			document.getElementById("PlanMinus").style.display = "none";
		}
	}
	function MyPlan() 
	{
		var message = "";
		if (xmlHttp.readyState == 4) {
			message = xmlHttp.responseText;
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/33.gif'>";
		}
		document.all("WorkPlanInfo").innerHTML = message;
	}
	
	//待处理的业务申请
	function ApplyUnfinished(){
		xmlHttp=getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(document.all("ApplayUnfinished").innerHTML == ""){
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/ApplayAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=1";
		xmlHttp.onreadystatechange = unfinishedApply;
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		document.getElementById("ApplyUnfinishedPlus").style.display = "none";
		document.getElementById("ApplyUnfinishedMinus").style.display = "";
		}else{
			document.all("ApplayUnfinished").innerHTML="";
			document.getElementById("ApplyUnfinishedPlus").style.display = "";
			document.getElementById("ApplyUnfinishedMinus").style.display = "none";
		}
	}
	function unfinishedApply() 
	{
		var message = "";
		if (xmlHttp.readyState == 4) {
			message = xmlHttp.responseText;
		}else{
			message = "<img border=0 bordercolordark='#CCCCCC' src='<%=sResourcesPath%>/33.gif'>";
		}
		document.all("ApplayUnfinished").innerHTML = message;
	}
	
	//待处理的批复
	function ApplySurvery(){
		xmlHttp=getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(document.all("ApplaySurvery").innerHTML == ""){
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/ApplaySurveryAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=1";
		xmlHttp.onreadystatechange = unfinishedSurvery;
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		document.getElementById("ApplySurveryPlus").style.display = "none";
		document.getElementById("ApplySurveryMinus").style.display = "";
		}else{
			document.all("ApplaySurvery").innerHTML="";
			document.getElementById("ApplySurveryPlus").style.display = "";
			document.getElementById("ApplySurveryMinus").style.display = "none";
		}
	}
	function unfinishedSurvery() 
	{
		var message = "";
		if (xmlHttp.readyState == 4) {
			message = xmlHttp.responseText;
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/33.gif'>";
		}
		document.all("ApplaySurvery").innerHTML = message;
	}
	
	//待登记的合同
	function Contract(){
		xmlHttp=getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(document.all("Contract").innerHTML == ""){
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/ContractAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=1";
		xmlHttp.onreadystatechange = ContractSign;
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		document.getElementById("ContractPlus").style.display = "none";
		document.getElementById("ContractMinus").style.display = "";
		}else{
			document.all("Contract").innerHTML="";
			document.getElementById("ContractPlus").style.display = "";
			document.getElementById("ContractMinus").style.display = "none";
		}
	}
	function ContractSign() 
	{
		var message = "";
		if (xmlHttp.readyState == 4) {
			message = xmlHttp.responseText;
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/33.gif'>";
		}
		document.all("Contract").innerHTML = message;
	}
	
	//待处理的放款
	function LoanAjaxInf(){
		xmlHttp=getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(document.all("LoanInfo").innerHTML == ""){
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/LoanAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=1";
		xmlHttp.onreadystatechange = unfinishedLoan;
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		document.getElementById("LoanPlus").style.display = "none";
		document.getElementById("LoanMinus").style.display = "";
		}else{
			document.all("LoanInfo").innerHTML="";
			document.getElementById("LoanPlus").style.display = "";
			document.getElementById("LoanMinus").style.display = "none";
		}
	}
	function unfinishedLoan() 
	{
		var message = "";
		if (xmlHttp.readyState == 4) {
			message = xmlHttp.responseText;
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/33.gif'>";
		}
		document.all("LoanInfo").innerHTML = message;
	}
	
	//待处理的放款
	function RiskSignalAjaxInf(){
		xmlHttp=getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(document.all("RiskSignalInfo").innerHTML == ""){
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/RiskSignalAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=1";
		xmlHttp.onreadystatechange = unfinishedRiskSignal;
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		document.getElementById("RiskSignalPlus").style.display = "none";
		document.getElementById("RiskSignalMinus").style.display = "";
		}else{
			document.all("RiskSignalInfo").innerHTML="";
			document.getElementById("RiskSignalPlus").style.display = "";
			document.getElementById("RiskSignalMinus").style.display = "none";
		}
	}
	function unfinishedRiskSignal() 
	{
		var message = "";
		if (xmlHttp.readyState == 4) {
			message = xmlHttp.responseText;
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/33.gif'>";
		}
		document.all("RiskSignalInfo").innerHTML = message;
	}
	
	
	//待处理的信用等级申请
	function UnFinishEvaluateAjaxInf(){
		xmlHttp=getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(document.all("UnFinishEvaluate").innerHTML == ""){
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/UnFinishEvaluateAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=1";
		xmlHttp.onreadystatechange = UnFinishEvaluate;
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		document.getElementById("EvaluatePlus").style.display = "none";
		document.getElementById("EvaluateMinus").style.display = "";
		}else{
			document.all("UnFinishEvaluate").innerHTML="";
			document.getElementById("EvaluatePlus").style.display = "";
			document.getElementById("EvaluateMinus").style.display = "none";
		}
	}
	function UnFinishEvaluate() 
	{
		var message = "";
		if (xmlHttp.readyState == 4) {
			message = xmlHttp.responseText;
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/33.gif'>";
		}
		document.all("UnFinishEvaluate").innerHTML = message;
	}

	//待处理的风险分类申请
	function UnFinishClassifyAjaxInf(){
		xmlHttp=getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(document.all("UnFinishClassify").innerHTML == ""){
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/UnFinishClassifyAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=1";
		xmlHttp.onreadystatechange = UnFinishClassify;
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		document.getElementById("ClassifyPlus").style.display = "none";
		document.getElementById("ClassifyMinus").style.display = "";
		}else{
			document.all("UnFinishClassify").innerHTML="";
			document.getElementById("ClassifyPlus").style.display = "";
			document.getElementById("ClassifyMinus").style.display = "none";
		}
	}
	function UnFinishClassify() 
	{
		var message = "";
		if (xmlHttp.readyState == 4) {
			message = xmlHttp.responseText;
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/33.gif'>";
		}
		document.all("UnFinishClassify").innerHTML = message;
	}
		
	//待处理的不良业务申请
	function BadBizApplyAjaxInf(){
		xmlHttp=getXmlHttpObject();
		if (xmlHttp==null){
		  alert ("Your browser does not support AJAX!");
		  return;
		}
		if(document.all("BadBizApply").innerHTML == ""){
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/BadBizApplyAJAX.jsp";
		url=url+"?CompClientID=<%=sCompClientID%>&Flag=1";
		xmlHttp.onreadystatechange = BadBizApply;
		xmlHttp.open("GET", url, true);
		xmlHttp.send(null);
		document.getElementById("BadBizPlus").style.display = "none";
		document.getElementById("BadBizMinus").style.display = "";
		}else{
			document.all("BadBizApply").innerHTML="";
			document.getElementById("BadBizPlus").style.display = "";
			document.getElementById("BadBizMinus").style.display = "none";
		}
	}
	function BadBizApply() 
	{
		var message = "";
		if (xmlHttp.readyState == 4) {
			message = xmlHttp.responseText;
		}else{
			message = "<img border=0 src='<%=sResourcesPath%>/33.gif'>";
		}
		document.all("BadBizApplySpan").innerHTML = message;
	}
	

		//统计待处理的信用等级申请件数
	if("<%=CurUser.hasRole("480")%>"=="true" || "<%=CurUser.hasRole("280")%>"=="true" || "<%=CurUser.hasRole("080")%>"=="true"
		||"<%=CurUser.hasRole("442")%>"=="true" || "<%=CurUser.hasRole("242")%>"=="true" || "<%=CurUser.hasRole("042")%>"=="true")
	{
		//CountUnfinishedEvaluate();
	}
	//统计待处理的风险分类申请件数 

	if("<%=CurUser.hasRole("480")%>"=="true" || "<%=CurUser.hasRole("280")%>"=="true" || "<%=CurUser.hasRole("080")%>"=="true"||
			"<%=CurUser.hasRole("441")%>"=="true" || "<%=CurUser.hasRole("241")%>"=="true" || "<%=CurUser.hasRole("041")%>"=="true"||
			"<%=CurUser.hasRole("0J0")%>"=="true"  || "<%=CurUser.hasRole("2D3")%>"=="true"|| "<%=CurUser.hasRole("2D1")%>"=="true"||
			"<%=CurUser.hasRole("2C4")%>"=="true" || "<%=CurUser.hasRole("210")%>"=="true" || "<%=CurUser.hasRole("410")%>"=="true" ||
			"<%=CurUser.hasRole("243")%>"=="true" || "<%=CurUser.hasRole("043")%>"=="true" ||  "<%=CurUser.hasRole("2A1")%>"=="true" ||
			"<%=CurUser.hasRole("2A5")%>"=="true" )
	{
		CountUnfinishedClassify();
	}
	//统计我自己安排的工作计划件数
	CountPlan();
	//统计出处理的信贷业务申请件数
	if("<%=CurUser.hasRole("480")%>"=="true" || "<%=CurUser.hasRole("280")%>"=="true" || "<%=CurUser.hasRole("080")%>"=="true"||
		"<%=CurUser.hasRole("450")%>"=="true" || "<%=CurUser.hasRole("250")%>"=="true" || "<%=CurUser.hasRole("050")%>"=="true"||
		"<%=CurUser.hasRole("451")%>"=="true" || "<%=CurUser.hasRole("251")%>"=="true" || "<%=CurUser.hasRole("051")%>"=="true"
							    	)
	{
		CountUnfinishedApply();
	}
	//统计待处理的批复件数
    //CountUnfinishedSurvery();
    //统计待登记的合同件数
	//CountContractSpan();
	//统计待处理的放款件数
	if("<%=CurUser.hasRole("480")%>"=="true" || "<%=CurUser.hasRole("280")%>"=="true" || "<%=CurUser.hasRole("080")%>"=="true" ||
		"<%=CurUser.hasRole("458")%>"=="true" || "<%=CurUser.hasRole("258")%>"=="true" || "<%=CurUser.hasRole("058")%>"=="true"||
		"<%=CurUser.hasRole("457")%>"=="true" || "<%=CurUser.hasRole("257")%>"=="true" || "<%=CurUser.hasRole("057")%>"=="true"||
		"<%=CurUser.hasRole("460")%>"=="true" || "<%=CurUser.hasRole("260")%>"=="true" || "<%=CurUser.hasRole("060")%>"=="true"||
		"<%=CurUser.hasRole("259")%>"=="true" || "<%=CurUser.hasRole("059")%>"=="true" || "<%=CurUser.hasRole("2C1")%>"=="true" || 
		"<%=CurUser.hasRole("0C1")%>"=="true" || "<%=CurUser.hasRole("0E5") %>"=="true" 
		)
	{
		CountUnfinishedLoan();
	}
	
	//统计待处理预警件数
	if("<%=CurUser.hasRole("2D3")%>"=="true" || "<%=CurUser.hasRole("080")%>"=="true" || "<%=CurUser.hasRole("280")%>"=="true" 
		|| "<%=CurUser.hasRole("2A5")%>"=="true" || "<%=CurUser.hasRole("480")%>"=="true" || "<%=CurUser.hasRole("2J4")%>"=="true"
		|| "<%=CurUser.hasRole("083")%>"=="true" || "<%=CurUser.hasRole("283")%>"=="true" || "<%=CurUser.hasRole("483")%>"=="true" 
		|| "<%=CurUser.hasRole("084")%>"=="true" || "<%=CurUser.hasRole("284")%>"=="true" || "<%=CurUser.hasRole("484")%>"=="true" 
		|| "<%=CurUser.hasRole("410")%>"=="true" || "<%=CurUser.hasRole("2C4")%>"=="true" || "<%=CurUser.hasRole("2C3")%>"=="true" 
		|| "<%=CurUser.hasRole("2C1")%>"=="true" || "<%=CurUser.hasRole("0C1")%>"=="true" || "<%=CurUser.hasRole("210")%>"=="true" 
		|| "<%=CurUser.hasRole("211")%>"=="true" || "<%=CurUser.hasRole("011")%>"=="true" || "<%=CurUser.hasRole("2D1")%>"=="true" 
		|| "<%=CurUser.hasRole("0C3")%>"=="true" || "<%=CurUser.hasRole("0C4")%>"=="true" || "<%=CurUser.hasRole("0J0")%>"=="true" 
		|| "<%=CurUser.hasRole("012")%>"=="true" || "<%=CurUser.hasRole("010")%>"=="true" || "<%=CurUser.hasRole("2J2")%>"=="true" 
		|| "<%=CurUser.hasRole("0Q1")%>"=="true" || "<%=CurUser.hasRole("289")%>"=="true" || "<%=CurUser.hasRole("089")%>"=="true" 
		|| "<%=CurUser.hasRole("208")%>"=="true" || "<%=CurUser.hasRole("2A1")%>"=="true"
		)
	{
		CountUnfinishedRiskSignal();
	}
	//不良业务审查员		
	if("<%=CurUser.hasRole("0G3")%>"=="true" )
	{
		CountBadBizApply();
	}
	//客户经理		
	if("<%=CurUser.hasRole("480")%>"=="true" || "<%=CurUser.hasRole("280")%>"=="true" || "<%=CurUser.hasRole("080")%>"=="true")
	{
		//统计审批通过未登记合同的件数
		CountNotRegistryBC();
	}
	
	//各级管户权审查员
	if("<%=CurUser.hasRole("028")%>"=="true" || "<%=CurUser.hasRole("228")%>"=="true" || "<%=CurUser.hasRole("428")%>"=="true" || "<%=CurUser.hasRole("0A0")%>"=="true" || "<%=CurUser.hasRole("0D0")%>"=="true")
	{
		//统计待处理客户权限管理件数
		CountRightModify();
	}
	
	//各级（支行、中心支行、总行）不良资产管理员：
	if("<%=CurUser.hasRole("064")%>"=="true" || "<%=CurUser.hasRole("264")%>"=="true" || "<%=CurUser.hasRole("464")%>"=="true" )
	{
		CountBasicBBAccount();
		CountBadBizLaw();
		CountBadBizDun();
		CountBadBizVouch();
	}
	
	//各级（支行、中心支行、总行）不良资产内勤综合员：
	if("<%=CurUser.hasRole("095")%>"=="true" || "<%=CurUser.hasRole("295")%>"=="true" || "<%=CurUser.hasRole("495")%>"=="true" )
	{
		CountWaitForAccount();
		CountBadBizAccount();
	}
	
	//中心支行资产保全部（总）经理；
	if( "<%=CurUser.hasRole("2G1")%>"=="true")
	{
		CountWaitBadBizOrg();
	}
	
	//总行、中心支行资产保全部（总）经理；支行行长
	if("<%=CurUser.hasRole("410")%>"=="true" || "<%=CurUser.hasRole("2G1")%>"=="true" || "<%=CurUser.hasRole("0G1")%>"=="true" )
	{
		CountWaitBadBizUser();
	}
</script>

<%@ include file="/IncludeEnd.jsp"%>