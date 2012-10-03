<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ycsun 2008/10/04
		Tester:
		Describe: 
		Input Param:
		Output Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "报表/信息批露"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<% 
       String sReportType = DataConvert.toString(request.getParameter("ReportType"));
			//定义Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"固定报表查询列表","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
		String sSqlTreeView = "";
		if("0".equals(CurOrg.OrgLevel)){
			sSqlTreeView = "FROM R_SHEET_MODEL where (OrderNo like 'k%' or OrderNo like 'l%' or OrderNo like 'm%' or OrderNo like 'n%') and status = '1' and (OrderNo is not null and   OrderNo <> '') ";
		}else{
			sSqlTreeView = "FROM R_SHEET_MODEL where  OrderNo in ('n','n01') and status = '1' and (OrderNo is not null and   OrderNo <> '') ";
		}
		
		//tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
		tviTemp.initWithSql("OrderNo", "SheetTitle", "", "Describe", "", sSqlTreeView, Sqlca);  
		//out.println();
		Vector dd = tviTemp.Items;
%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>
<html>
<head>
<title>迁徙矩阵报表系统</title>


<script language=javascript>
	function doAction(sAction){
		if(sAction == "back"){
			if (confirm("您确定要退出报表系统吗？")){
				//window.open("<%=sWebRootPath%>/index.html","_top");  
				window.open("<%=sWebRootPath%>/Main.jsp","_top");
			}
		}else if(sAction == "Fix_k0101"){
			OpenPage("/FixStat/Fixk0101.jsp","right","");
		}else if(sAction == "Fix_k0201"){
			OpenPage("/FixStat/Fixk0201.jsp","right","");
		}else if(sAction == "Fix_l0101"){
			OpenPage("/FixStat/Fixl0101.jsp","right","");
		}else if(sAction == "Fix_l0102"){
			OpenPage("/FixStat/Fixl0102.jsp","right","");
		}else if(sAction == "Fix_l0201"){
			OpenPage("/FixStat/Fixl0201.jsp","right","");
		}
		else{
			OpenPage("/FixStat/FixSheetShowJZ.jsp?SheetID="+sAction+"&DisplayCriteria=true&rand="+randomNumber(),"right");
			setTitle(getCurTVItem().name);
		}
	}
	
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}	
</script> 

<script language="JavaScript">
	myleft.width=250;
	startMenu() ;
	expandNode('root');
	expandNode('k');
	expandNode('k1');
	expandNode('k2');
	expandNode('l');
	expandNode('m');
	expandNode('n');
</script>
<%@ include file="/IncludeEnd.jsp"%>