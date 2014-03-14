<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content:
			Input Param:
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/
%>
	<%
		//定义变量
		
		//获得组件参数	

		//获得页面参数
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/
%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%//String sSqlTab = "select ItemNo,ItemName,Attribute1 from CODE_LIBRARY where CodeNo = 'VouchType' and ItemNo in('01','02')";
	  	//String sTabStrip[][] = HTMLTab.getTabArrayWithSql(sSqlTab,Sqlca);
	  	
	  	String sTabStrip[][] = {
								{"","abc","doTabAction(\'firstTab\')"},
								{"","def","doTabAction(\'secondTab\')"},
								{"","ghi","doTabAction(\'thirdTab\')"},
								{"","jkl","doTabAction(\'fourthTab\')"}
								};

		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.all('tabtd')"));

		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=no";%>

</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/
%>
<html>
<head>
<title><%=PG_TITLE%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/
%>
	<script language=javascript>

	/**
	 * 默认的tab执行函数
	 * 返回true，则切换tab页;
	 * 返回false，则不切换tab页
	 */
  	function doTabAction(sArg)
  	{
  		
  		if(sArg=="firstTab")
  		{
			OpenComp("Blank","/Blank.jsp","ComponentName=组件1&TextToShow="+sArg,"<%=sIframeName%>","");
			return true; 
		}else if(sArg=="secondTab")
  		{
			OpenComp("Blank","/Blank.jsp","ComponentName=组件1&TextToShow="+sArg,"<%=sIframeName%>","");
			return true;
		}else
		{
			alert("请先选择一个企业！");
			return false; 
		}
  	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/
%>

	<script language=javascript>
	
	//参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.all('<%=sTabID%>'));
	doTabAction('firstTab');

	</script>

<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
