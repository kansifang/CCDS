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
	String sSerialNo   = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));
	%>
<%/*~END~*/%>     


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sTitle="";
	  	String sAddStringArray[] = null;
		int initTab = 1;//设定默认的 tab ，数值代表第几个tab
		ASResultSet rs1 = null;
		String sSql = " select ItemNo,ItemName,ItemAttribute from CODE_LIBRARY CL"+
					" where CodeNo = 'TabStrip'  and IsInUse = '1' ";
		//add by lzhang 2011/04/12 增加查看角色权限控制
		if(CurUser.UserID.equals("9999999")||CurUser.hasRole("062")||CurUser.hasRole("262")||CurUser.hasRole("462")){
			sSql += " order by SortNo ";
		}else{
			sSql += " and ItemNo <> '050'  Order by SortNo ";
		}				
		String sTabStrip[][] = HTMLTab.getTabArrayWithSql(sSql,Sqlca);
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.all('tabtd')"));
		String sTableStyle = "valign=middle align=center cellspacing=0 cellpadding=0 border=0 width=95% height=95%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "DeskTopTab";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=no";
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
	function doTabAction(sArg){
  		if(sArg=="WorkTips")
  		{
  			OpenComp("WorkTips","/DeskTop/WorkTips.jsp","","<%=sIframeName%>","");
  		}
  		else if(sArg=="BusinessAlert")
  		{
  			OpenComp("AlarmHandleMain","/CreditManage/CreditAlarm/AlarmHandleMain.jsp","","<%=sIframeName%>","");
  		}
  		else if(sArg=="WorkRecordMain")
  		{
  			OpenComp("WorkRecordMain","/DeskTop/WorkRecordMain.jsp","","<%=sIframeName%>","");
  		}
  		else if(sArg=="UserDefine")
  		{
  			OpenComp("UserDefineMain","/DeskTop/UserDefineMain.jsp","","<%=sIframeName%>","");
  		}
  		//add by lzhang 2011-03-21新增贷款发放和回收提示
  		else if(sArg=="BalanceAlert")
  		{
  			OpenComp("AlarmBalanceMain","/CreditManage/CreditAlarm/AlarmBalanceMain.jsp","","<%=sIframeName%>","");
  		}
  		  		
		//当日业务情况
    	if(sArg=="BusinessCurrenyDay")
  		{
  			OpenComp("BusinessCurrenyDay","/DeskTop/BusinessCurrenyDay.jsp","","<%=sIframeName%>","");
 	  	}
		//期间业务动态
    	else if(sArg=="BusinessDynamic")
  		{
  			OpenComp("BusinessDynamic","/DeskTop/BusinessDynamic.jsp","","<%=sIframeName%>","");
 	  	}
		//授信集中度（重大客户）
    	else if(sArg=="VipCustomerFrame")
  		{
  			OpenComp("VipCustomerFrame","/DeskTop/VipCustomerFrame.jsp","","<%=sIframeName%>","");
 	  	}
		//表内业务结构
    	else if(sArg=="LoanInq1")
  		{
  			OpenComp("LoanIndView","/DeskTop/LoanIndView.jsp","InOutFlag=1","<%=sIframeName%>","");
 	  	}
		//表外业务结构
  		else if(sArg=="LoanInq2")
  		{
  			OpenComp("LoanIndView","/DeskTop/LoanIndView.jsp","InOutFlag=2","<%=sIframeName%>","");
  		}
		//资产质量
  		else if(sArg=="LoanQuanlity")
  		{
  			OpenComp("LoanQuanlity","/DeskTop/LoanQuanlity.jsp","InOutFlag=2","<%=sIframeName%>","");
	  	}
  	}

	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1, document.getElementById('<%=sTabID%>'));
	<%=sTabStrip[0][2]%>;
	</script>	
<%/*~END~*/%>
	
<%@ include file="/IncludeEnd.jsp"%>