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
	String PG_TITLE = "贷款用途检查报告"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	

	//获得页面参数	
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sReportType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportType"));
	String sViewOnly = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewOnly"));
	if(sViewOnly == null) sViewOnly = "";
	if(sReportType == null) sReportType="";
	String sType=""; //区分客户类型
	String sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sObjectNo+"'");
	if(sCustomerType == null) sCustomerType="";
	else if (sCustomerType.startsWith("03"))  sType = "2";//个人客户办理业务
	else sType = "1";//公司客户办理业务	
	%>
<%/*~END~*/%>     

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sSql = "";
		String sItemName = "";
		String sCustomerID = "";
		String sTitle="";
	  	String sAddStringArray[] = null;
	  	String sTabStrip[][] = new String[20][3];
		int initTab = 1;//设定默认的 tab ，数值代表第几个tab

		if("Customer".equals(sObjectType)){
			sItemName = "常规性检查报告";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('Inspect','"+sSerialNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			//设定标题
			sTitle = "常规性检查报告";
		}else if("CustomerRisk".equals(sObjectType)){
			sItemName = "风险预警检查报告";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('CustomerRisk','"+sSerialNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			//设定标题
			sTitle = "风险预警检查报告";	
			
		}else if("CustomerRisk16".equals(sObjectType)){
			sItemName = "风险预警报告审批表";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('CustomerRisk16','"+sSerialNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			//设定标题
			sTitle = "风险预警报告审批表";	
			
		}else if("CreditApply".equals(sObjectType)){
			sItemName = "批复报告";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('CreditApply','"+sObjectNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			//设定标题
			sTitle = "批复报告";
		}	

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
  		if (sObjectType=="Customer") {
			sViewID = "002";
			openObjectInFrame(sObjectType,sObjectNo,sViewID,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="BusinessContract") {
			sCompID = "CustomerLoanAfterList";
			sCompURL = "/CustomerManage/EntManage/CustomerLoanAfterList.jsp";
			sParamString = "CustomerID=<%=sCustomerID%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}

  		else if (sObjectType=="Inspect") {
  			sReportType = "<%=sReportType%>";
  			if(sReportType=="01"){//公司客户一般风险常规检查报告
				sCompID = "BusinessInspect07";
				sCompURL = "/FormatDoc/BusinessInspect/07.jsp";
			}else if(sReportType=="02"){//公司客户低风险常规检查报告
				sCompID = "BusinessInspect08";
				sCompURL = "/FormatDoc/BusinessInspect/08.jsp";
			}else if(sReportType=="03"){
				sCompID = "BusinessInspect09";//个人客户常规检查报告
				sCompURL = "/FormatDoc/BusinessInspect/09.jsp";
			}else{
				sCompID = "BusinessInspect15";//微小企业常规检查报告
				sCompURL = "/FormatDoc/BusinessInspect/15.jsp";
			}		
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}  
  		else if(sObjectType=="CustomerRisk"){
			sCompID = "BusinessInspect10";//风险预警检查报告
			sCompURL = "/FormatDoc/BusinessInspect/10.jsp";	
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>&viewOnly=<%=sViewOnly%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		
  		else if(sObjectType=="CustomerRisk16"){
			sCompID = "BusinessInspect16";//风险预警报告审批表
			sCompURL = "/FormatDoc/CreditAlarm/16.jsp";	
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>&viewOnly=<%=sViewOnly%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		
  		else if(sObjectType == "CreditApply"){
  			sReportType = "<%=sReportType%>";
  			if(sReportType=="11"){//由授信审批部总经理、分管风险副行长审批通过的业务报告
				sCompID = "BusinessInspect11";
				sCompURL = "/FormatDoc/BusinessInspect/11.jsp";
			}else if(sReportType=="12"){//授信审批部总经理、分管风险副行长审批否决报告
				sCompID = "BusinessInspect12";
				sCompURL = "/FormatDoc/BusinessInspect/12.jsp";
			}else if(sReportType=="13"){
				sCompID = "BusinessInspect13";//市合行行长审批通过的业务报告
				sCompURL = "/FormatDoc/BusinessInspect/13.jsp";
			}else{
				sCompID = "BusinessInspect14";//市合行行长审批否决的业务报告
				sCompURL = "/FormatDoc/BusinessInspect/14.jsp";				
			}		
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="PrintInspectResume") {		
			sCompID = "BusinessInspect00";
			sCompURL = "/FormatDoc/BusinessInspect/00.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}  		
  		else if (sObjectType=="PrintInspectResum1") {			
			sCompID = "BusinessInspect03";
			sCompURL = "/FormatDoc/BusinessInspect/03.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="PrintInspectResum2") {	
			sCompID = "BusinessInspect04";
			sCompURL = "/FormatDoc/BusinessInspect/04.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="PrintInspectResum3") {		
			sCompID = "BusinessInspect05";
			sCompURL = "/FormatDoc/BusinessInspect/05.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}  		
  		else if (sObjectType=="PrintInspectResum4") {
			sCompID = "CustomerFAList";
			sCompURL = "/CustomerManage/FinanceAnalyse/CustomerFAList.jsp";
			sParamString = "CustomerID=<%=sObjectNo%>";
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