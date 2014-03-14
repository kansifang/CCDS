<%/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-05-18
 * Tester:
 *
 * Content: 
 *          预警处理提示处理
 *           
 * Input Param:
 *      ScenarioNo:	预警的场景ID，如审批等
 *      ObjectType:	参数类型，如类型为审批流水号
 *      ObjectNo: 	参数值，如审批流水号
 *		OneStepRun: yes/no 是否可以单步提交，默认为否
 *		IgnoreStop:	yes/no 是否忽略禁止办理，继续检查，默认为否
 *		OnlyNextStep:	yes/no 是否总认为下一步成功，取消关闭等都返回判断结果
 *      
 * Output param:
 *      ReturnValue:    预警检查处理通过否
 * History Log:  
 */%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<!--使用实例
        //提交前预警
        var sReturn3;
        sReturn3 = popComp("ScenarioAlarm.jsp","/PublicInfo/ScenarioAlarm.jsp","IgnoreStop=no&OneStepRun=no&ScenarioNo=001&ObjectType=ApplySerialNo&ObjectNo="+sSerialNo,"dialogWidth=50;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no","");
        if (typeof(sReturn3)== 'undefined' || sReturn3.length == 0) 
        {
            //alert("好像是个奇怪的错误！");
            return;
        }else if (sReturn3 >= 0) //成功 
        {
            //alert("成功啦，庆祝一下！"+sReturn3);    
                if( sReturn3 == 10 )//禁止办理
                	return;
        }else  //取消了
        {
            //alert("呜呜，又取消了 :..( ");
            return;
        }
            
-->
<%
	boolean bOnlyNext = false;
	boolean bOneStep = false;
	boolean bIgnoreStop = false;
	//获得组件参数	
	String sScenarioNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ScenarioNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sOneStepRun = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OneStepRun"));
	String sIgnoreStop = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("IgnoreStop"));
	String sOnlyNextStep = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OnlyNextStep"));
	//将空值转化为空字符串
	if(sScenarioNo == null) sScenarioNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sOneStepRun == null) sOneStepRun = "";
	if(sIgnoreStop == null) sIgnoreStop = "";
	if(sOnlyNextStep == null) sOnlyNextStep = "";
	
	if( !sOneStepRun.equals("") && sOneStepRun.equalsIgnoreCase("yes") )
		bOneStep = true;	
	if( !sIgnoreStop.equals("") && sIgnoreStop.equalsIgnoreCase("yes") )
		bIgnoreStop = true;	
	if( !sOnlyNextStep.equals("") && sOnlyNextStep.equalsIgnoreCase("yes") )
		bOnlyNext = true;

	//风险提示	
	ASAlarmScenario altsce = new ASAlarmScenario(sScenarioNo,sObjectType,sObjectNo,Sqlca,CurUser,bOneStep);
	String sScenarioName = "",sScenarioDescribe = "";
	sScenarioName = altsce.getName();
	sScenarioDescribe = altsce.getDescribe();
	if(sScenarioDescribe == null) sScenarioDescribe = "";
	int i=0,num=0;
	String []sHighRisk;
	
  	sHighRisk = new String[40];
%>
<html>
	
<head>
<title>符合性条件判断</title>
<script language="javascript">
	</script>
<style type="text/css">
<!--
textarea {  height: 60px; width: 100%; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px}
-->
</style>
</head>
<body bgcolor="#EAEAEA" >
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
<tr>
<table>
<tr>
<%
	if(bOneStep){
%>
  <span >
	<td id=al_run disabled=disabled >
          <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","运行","单步提交运行","javascript:runAlarmModel();",sResourcesPath)%>
	</td>
  </span>
<%
	}
%>
<%
	if(!bOnlyNext){
%>
	<td id=al_exit >
          <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","取消","放弃预警检查结果","javascript:alarm_exit();",sResourcesPath)%>
	</td>
<%
	}
%>
<!-- 
	<td id=al_next disabled=disabled >
          <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","下一步","预警检查通过","javascript:alarm_next();",sResourcesPath)%>
	</td>
-->
</tr>
</table>
</tr>
  <tr>
    <td width="100%" valign="top"> 
	场景名称：<%=sScenarioName%><br>场景描述：<%=sScenarioDescribe%>
	  <table width="100%" border="1" cellspacing="0" cellpadding="0"  bordercolordark="#FFFFFF">
<tr bgcolor=#fafafa>
	<td>正在处理</td>	
<!--
	<td width='0%' >序号</td>	
-->
	<td>选择执行</td>
	<td>处理的任务</td>
	<td>处理结果</td>
	<td>提示信息</td>
</tr>
        <%
        	String sModelNo,sDealMethod,sModelType,sModelName,sDescribe;
        	String[] sKeys = altsce.getModelKeys();
        	for (i=0;i< sKeys.length;i++)
        	{
        		sModelNo = sKeys[i];
        		sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
        		sModelName = altsce.getModelAttribute(sModelNo,"AlarmModelName");
        %>
<tr bgcolor=#fafafa>
	<td width='5%'>
		<span id=<%=i%>d style="display:none"><strong><img src=<%=sResourcesPath%>/logo.jpg></span>
	</td>	
<!--
	<td align=right width='0%'>
		<span ><font color=blue><%=i+1%></span>
	</td>	
-->
    <td align=center width='4%'>
		<%
			if(bOneStep){
		%>
        <INPUT ID="checkbox<%=i%>" TYPE="checkbox" NAME="checkbox<%=i%>">
		<%
			}else{
		%>
        <INPUT ID="checkbox<%=i%>" TYPE="checkbox" NAME="checkbox<%=i%>"
					checked disabled="disabled">
		<%
			}
		%>
    </td>
    <td width='37%'>
    	<%=sModelName%>
    </td>
	<td width='4%'>
		<span id=<%=i%>s style="display:none"><img id=<%=i%>simg src=<%=sResourcesPath%>/icon14.gif title="<%=sDealMethod%>"></span>
		<span id=<%=i%>f style="display:none"><font color=red><%=sDealMethod%></span> 
	</td>	
	<td width='50%'>
		<span id=<%=i%>i style="display:none"><font color=red><%=sDealMethod%></span> 
	</td>	
</tr>
		<%
			}
		%>
      </table>
</td>
</tr>
</table>


</body>
</html>

<script language=javascript >
<%if(bOneStep){%>
	document.all("al_run").disabled=false;
<%}%>
	oldRtn = 99;
	curRtn = 0;
		<%if(!bOneStep){%>
			runAlarmModel();
		<%}%>

function runAlarmModel()
{
	var sReturn;
	var sReturn2;
	continueFlag = true;
<%if(bOneStep){%>
	document.all("al_run").disabled=true;
<%}%>
	<%//设置可能的补充参数
	//altsce.setArgValue(sArgNo,sArgValue);
	
	//将对象放置到session中
	session.setAttribute("CurAlarmSce",altsce);
	

	String sAModelNo,sAModelType,sRunCondition,sChkCondi;
	for (i=0;i< sKeys.length;i++)
	{
  		sAModelNo = sKeys[i];
		sAModelType = altsce.getModelAttribute(sAModelNo,"AlarmModelType");
		altsce.setArgValue("CurModelNo",sAModelNo);
		sRunCondition = altsce.getModelAttribute(sAModelNo,"RunCondition");
		sChkCondi = "";
  		if( sRunCondition.startsWith("###:") )
  		{
  			//判断是###开头的，则认为是需要实时根据以前的运行结果做判断后续条件运行
  			//暂时使用最后一次的结果curRtn作为判断源
  			//条件还是写在配置里，###:之后吧，随便写
  			//如：oldRtn<10
  			sChkCondi = " && "+sRunCondition.substring(4);
  		}%>
	if( continueFlag == true <%=sChkCondi%> && document.all("checkbox<%=i%>").checked)
	{
		document.all("checkbox<%=i%>").disabled="disabled";
		document.all("<%=i%>d").style.display="block";
		document.all("<%=i%>d").scrollIntoView(false);

		<%if( "01".equals(sAModelType) ){	//jsp方式
			String sCheckScript = altsce.getCheckScript(sAModelNo);
			System.out.println("sCheckScript==============="+sCheckScript);%>
			sReturn = <%=sCheckScript%>;
		<%}else{%>
			sReturn = PopPage("/PublicInfo/popAlarmDeal.jsp?AlarmModelNo=<%=sAModelNo%>&OneStepRun=<%=sOneStepRun%>","","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		<%}%>

		if (typeof(sReturn)== 'undefined' || sReturn.length == 0) 
		{
			alert("预警[<%=sAModelNo%>]计算错误!");
			oldRtn=10;
		}else{
			sColor = "black";
			saReturns = sReturn.split("$");
			sReturn1 = saReturns[0];	//状态
			sReturn2 = saReturns[1];	//信息
			curRtn = parseInt(sReturn1);
			if( curRtn < oldRtn && curRtn >= 10 ) oldRtn = curRtn;
			document.all("<%=i%>s").style.display = "block";
			if (sReturn1 == "99") //成功 ,不处理
			{
				//sColor = "blue";
				document.all("<%=i%>simg").src = "<%=sResourcesPath%>/icon7.gif";
				document.all("<%=i%>simg").title = "成功，不处理";
			}else if(sReturn1 == "81") //提示
			{
				sColor = "blue";
				document.all("<%=i%>simg").src = "<%=sResourcesPath%>/icon1.gif";
				document.all("<%=i%>simg").title = "提示";
			}else if(sReturn1 == "10" ) //失败,申请时禁止办理也可以通过
			{
				document.all("<%=i%>simg").src = "<%=sResourcesPath%>/icon10.gif";
				document.all("<%=i%>simg").title = "禁止办理";
				sColor = "red";				
			}else if(sReturn1 == "09" ) //停止后续检查，直接退出
			{
				sColor = "green";
				document.all("<%=i%>simg").src = "<%=sResourcesPath%>/icon14.gif";
				document.all("<%=i%>simg").title = "后续免检";
				//continueFlag = false;
			}else
			{
				document.all("<%=i%>s").style.display = "none";
				document.all("<%=i%>f").style.display = "block";
				document.all("<%=i%>f").outerText = sReturn1;
			}
			document.all("<%=i%>i").style.display = "block";
			document.all("<%=i%>i").style.color = sColor;
			document.all("<%=i%>i").innerText = amarsoft2Real(sReturn2);
			//document.all("<%=i%>i").outerHTML = "<font color=red>"+sReturn2+"</font>";
		}
		document.all("<%=i%>d").style.display="none";
		document.all("checkbox<%=i%>").checked=false;
	}
	<%}%>
	//清除Session中的Alarm对象
	PopPage("/PublicInfo/endAlarmRecord.jsp?SessionAttr=CurAlarmSce&OneStepRun=<%=sOneStepRun%>","myprint10","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");

	//
	<%if(bOnlyNext){%>
		top.returnValue = oldRtn;
	<%}else{%>
		top.returnValue = sReturn2;
	<%}%>
	<%if(!bOneStep){%>
	//document.all("al_next").disabled=false;
	<%}%>
	//document.all("al_next").scrollIntoView(false);
}

	function alarm_exit()
	{
		<%if(bOnlyNext){%>
			top.returnValue = oldRtn;
		<%}else{%>
			top.returnValue = -1;
		<%}%>
		self.close();
	}

	function alarm_next()
	{
		top.returnValue = oldRtn;
		self.close();
	}
	
</script>

<%@ include file="/IncludeEnd.jsp"%>