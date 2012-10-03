<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang 2004-12-16 20:35
		Tester:
		Content: 显示授信业务信息
		Input Param:
			    TaskNo：任务编号
			    ObjectNo：对象编号
			    ObjectType：对象类型
			    FlowNo：流程编号
			    PhaseNo：阶段编号
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
	//定义变量
	
	//获得组件参数	
	String sTaskNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	
	//获得页面参数		
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	
	%>
	
	<%
		String  sEditFlag= "false";
		if(sFlowNo.equals("EntCreditFlowTJ01") && (sPhaseNo.equals("0130") || sPhaseNo.equals("0260")))//授信审查部审查员
		{
			sEditFlag="true";
		}
		if(sFlowNo.equals("IndCreditFlowTJ01") && (sPhaseNo.equals("0130") || sPhaseNo.equals("0200")))
		{
			sEditFlag="true";
		}
	
	%>
<%/*~END~*/%>     

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sSql = "";
		String sItemName = "";
		String sCustomerID = "";
		String sCustomerType = "",sBusinessType ="",sApplyType="",sEvaluateSerialNo="";
		String sTitle="";
	  	String sAddStringArray[] = null;
	  	String sTabStrip[][] = new String[20][3];	  	
		int initTab = 1;//设定默认的 tab ，数值代表第几个tab
		ASResultSet rs = null;
		
		//设定标题
		sSql = 	" select CustomerName||'-'||getBusinessName(BusinessType), "+
				" BusinessSum,BusinessRate,nvl(TermMonth,0), "+
				" getOrgName(InputOrgID),getUserName(InputUserID),CustomerID,BusinessType,ApplyType "+
				" from BUSINESS_APPLY where SerialNo='"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sTitle = "授信申请-[" + rs.getString(1) +"]";
			sTitle += "-金额[" + DataConvert.toMoney(rs.getString(2)) +"元]";
			sTitle += "-利率[" + rs.getDouble(3) +"‰]";
			sTitle += "-期限[" + rs.getString(4) +"]";
			sTitle += "-经办机构[" + rs.getString(5) +"]";
			sTitle += "-经办人[" + rs.getString(6) +"]";
			sCustomerID = rs.getString("CustomerID");
			sBusinessType = rs.getString("BusinessType");
			sApplyType = rs.getString("ApplyType");
			if(sCustomerID == null) sCustomerID ="";
			if(sBusinessType == null) sBusinessType ="";
			if(sApplyType == null) sApplyType ="";
		}
		rs.getStatement().close();
		
		//取得客户信用等级评估信息 add by lpzhang 2009-8-24
		sSql = "select CustomerType from Customer_Info where CustomerID ='"+sCustomerID+"'";
		sCustomerType = Sqlca.getString(sSql);
		if(sCustomerType == null) sCustomerType="";
		
		if(!sBusinessType.equals("3015") && !sApplyType.equals("DependentApply") && sObjectType.equals("CreditApply"))
		{
			sSql = " select SerialNo from Evaluate_Record where ObjectType ='Customer' "+
			       " and ObjectNo ='"+sCustomerID+"'  order by AccountMonth desc fetch first 1 rows only ";
			
			sEvaluateSerialNo = Sqlca.getString(sSql);
			if(sEvaluateSerialNo == null) sEvaluateSerialNo ="";
		}
		

		sItemName = "查看各级意见";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('ViewFlowOpinions','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "历史审查审批意见";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('viewHistoryOpinion','"+sCustomerID+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "业务申请信息";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('CreditApply','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "客户信息";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('Customer','"+sCustomerID+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		if(!"".equals(sEvaluateSerialNo))
		{
			sItemName = "信用等级评估信息";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('Evaluate','"+sCustomerID+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
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
	<%@include file="/Resources/CodeParts/Tab05.jsp"%>
</body>
</html>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script language=javascript>
	var bHidePrintButton = true;
  	function doTabAction(sObjectType,sObjectNo)
  	{
		if (sObjectType=="ViewFlowOpinions") 
		{ 			
			sCompID = "ViewApplyFlowOpinions";
			sCompURL = "/Common/WorkFlow/ViewApplyFlowOpinions.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			setDialogTitle("<%=sTitle%>");
			return true;
		}else  if (sObjectType=="viewHistoryOpinion") 
		{ 			
			sCompID = "HistoryApplyList";
			sCompURL = "/Common/WorkFlow/HistoryApplyList.jsp";
			sParamString = "CustomerID=<%=sCustomerID%>&ObjectNo=<%=sObjectNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			setDialogTitle("<%=sTitle%>");
			return true;
		}else  if (sObjectType=="Evaluate") 
		{ 			
			sCompID = "EvaluateDetail";
			sCompURL = "/Common/Evaluate/EvaluateDetail.jsp";
			sParamString = "Action=display&CustomerID=<%=sCustomerID%>&ObjectType=Customer&ObjectNo=<%=sCustomerID%>&SerialNo=<%=sEvaluateSerialNo%>&Editable=<%=sEditFlag%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			setDialogTitle("<%=sTitle%>");
			return true;
		}
		else {
			openObjectInFrame(sObjectType,sObjectNo,"002","<%=sIframeName%>");
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
	sCompID = "SignApplyTaskOpinionInfo";
	sCompURL = "/Common/WorkFlow/SignApplyTaskOpinionInfo.jsp";
	sParamString = "TaskNo=<%=sTaskNo%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>";
    OpenComp(sCompID,sCompURL,sParamString,"EditBlock");
	</script>	
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>