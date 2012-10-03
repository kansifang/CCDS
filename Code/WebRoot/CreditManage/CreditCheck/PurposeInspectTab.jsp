<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang 2004-12-16 20:35
		Tester:
		Content: 显示授信业务信息
		Input Param:
            ObjectNo:代号
            InspectType:报告类型
                010	贷款用途报告
				020	贷款检查报告
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "显示授信业务信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//获得组件参数	
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sViewOnly = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewOnly"));
	String sViewPrint = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewPrint"));
	//将null转换为""
	if(sSerialNo==null) sSerialNo="";
	if(sObjectNo==null) sObjectNo="";
	if(sObjectType==null) sObjectType="";
	if(sViewOnly==null) sViewOnly="";
	if(sViewPrint==null) sViewPrint="";
	
	%>
<%/*~END~*/%>     


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sSql = "";
		String sItemName = "";
		String sContractSerialNo = "";
		String sTitle="";
	  	String sAddStringArray[] = null;
	  	String sTabStrip[][] = new String[20][3];
		int initTab = 1;//设定默认的 tab ，数值代表第几个tab
		String sPhaseNo = "";//批复申请申请阶段
		
		 //设定标题
		if("RiskSignalDispose".equals(sObjectType)){
			sTitle = "预警处置报告";
			sItemName = "预警处置报告";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('RiskSignalDispose','"+sObjectNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			
		}		
		//设定标题
		else if("RehearForm".equals(sObjectType)){
			sTitle = "复审申请表";
			sItemName = "复审申请表";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('RehearForm','"+sObjectNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			
		}		
		//设定标题
		else if("ApproveApproval".equals(sObjectType)){
			sTitle = "授信业务批复报告";
			sItemName = "授信业务批复报告";
			sSql = "select PhaseNo from FLOW_OBJECT where ObjectType='CreditApply' and ObjectNo ='"+sObjectNo+"'";
			sPhaseNo = Sqlca.getString(sSql);
			sAddStringArray = new String[] {"",sItemName,"doTabAction('ApproveApproval','"+sObjectNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			
		}		
		//设定标题
		else if("RiskSignal".equals(sObjectType)){
			sTitle = "预警报告审批表";
			sItemName = "预警报告审批表";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('RiskSignal','"+sObjectNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			
		}		
		//设定标题
		else if("FreeRiskSignal".equals(sObjectType)){
			sTitle = "预警解除申请表";
			sItemName = "预警解除申请表";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('FreeRiskSignal','"+sObjectNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			
		}else {

		//设定标题
		sTitle = "贷款用途报告";

		sItemName = "贷款用途检查内容";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('Inspect','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		sSql = "select ObjectNo from INSPECT_INFO where SerialNo ='"+sSerialNo+"'";
		sContractSerialNo = Sqlca.getString(sSql);

		sItemName = "业务详情";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('BusinessContract','"+sContractSerialNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		}

		/*
		sItemName = "报告打印预览";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('PrintPurpose','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		*/	
		//根据定义组生成 tab
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.all('tabtd')"));

		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=yes";
	%>

</script>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title><%=sTitle%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script language=javascript>
  	function doTabAction(sObjectType,sObjectNo)
  	{		  
		if (sObjectType=="BusinessContract") 
		{
			sViewID = "002";
			openObjectInFrame(sObjectType,sObjectNo,sViewID,"<%=sIframeName%>");
			return true;
		}
		else if (sObjectType=="Inspect") 
		{ 			
			sCompID = "PurposeView";
			sCompURL = "/CreditManage/CreditCheck/PurposeView.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
		}
		else if (sObjectType=="PrintPurpose") 
		{ 			
			sCompID = "PurposeInspect01";
			sCompURL = "/FormatDoc/PurposeInspect/01.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
		}
		else if (sObjectType=="ApproveApproval") 
		{ 	
			if("<%=sPhaseNo%>"=="1000")//申请批复
			{	
				sCompID = "CreditApproval";
				sCompURL = "/FormatDoc/ApproveApproval/01.jsp";
			}else if("<%=sPhaseNo%>"=="8000"){//否决批复
				sCompID = "CreditApproval01";
				sCompURL = "/FormatDoc/ApproveApproval/02.jsp";
			}else{
				sCompID = "CreditApproval";
				sCompURL = "/FormatDoc/ApproveApproval/01.jsp";
			}
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>&viewOnly=<%=sViewOnly%>&viewPrint=<%=sViewPrint%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
			/*
			OpenPage("/FormatDoc/ApproveApproval/01.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>","_blank02","<%=sIframeName%>"); 
			*/
		}
		else if (sObjectType=="RiskSignal") 
		{ 		
			sCompID = "CreditAlarm16";
			sCompURL = "/FormatDoc/CreditAlarm/16.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>&viewOnly=<%=sViewOnly%>&viewPrint=<%=sViewPrint%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
		}
		else if (sObjectType=="FreeRiskSignal") 
		{ 		
			sCompID = "CreditAlarm17";
			sCompURL = "/FormatDoc/CreditAlarm/17.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>&viewOnly=<%=sViewOnly%>&viewPrint=<%=sViewPrint%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
		}else if (sObjectType=="RehearForm") 
		{ 		
			sCompID = "RehearForm";
			sCompURL = "/FormatDoc/RehearForm/01.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>&viewOnly=<%=sViewOnly%>&viewPrint=<%=sViewPrint%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
		}else if(sObjectType='RiskSignalDispose')	
		{
			sCompID = "RiskSignalDispose";
			sCompURL = "/FormatDoc/CreditAlarm/18.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>&viewOnly=<%=sViewOnly%>&viewPrint=<%=sViewPrint%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
		}
  	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script language=javascript>
	//参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,<%=initTab%>,document.all('<%=sTabID%>'));
	//设定默认页面
	<%=sTabStrip[initTab-1][2]%>;
	</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>