
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2005/08/28
		Tester:
		Content:授权方案详情查看
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权方案详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授权方案详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	String sPolicyID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sPolicyID == null) sPolicyID = "";
	
	//获得页面参数	

	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"授权点详情","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	int iOrder = 1;	
	tviTemp.insertPage("root","授权方案基本信息","",iOrder++);
	tviTemp.insertPage("root","授权点设定","",iOrder++);
	
	String sTestFolder = tviTemp.insertFolder("root","测试授权方案","",iOrder++);
		tviTemp.insertPage(sTestFolder,"授权点测试","",iOrder++);
		tviTemp.insertPage(sTestFolder,"授权点查找测试","",iOrder++);
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	
	//treeview单击选中事件	
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=="授权方案基本信息")
		{
			OpenComp("PolicySettingInfo","/Common/Configurator/AAManage/PolicySettingInfo.jsp","PolicyID=<%=sPolicyID%>","right");
		}else if(sCurItemname=="授权点设定")
		{
			OpenComp("AuthPointSettingList","/Common/Configurator/AAManage/AuthPointSettingList.jsp","PolicyID=<%=sPolicyID%>","right");
		}else if(sCurItemname=="授权点测试")
		{
			OpenComp("AAPointTest","/Common/Configurator/AAManage/AAPointTest.jsp","PolicyID=<%=sPolicyID%>","right");
		}else if(sCurItemname=="授权点查找测试")
		{
			//OpenComp("AAPointLookUpTest","/Common/Configurator/AAManage/AuthPointSettingList.jsp","PolicyID=<%=sPolicyID%>","right");
		}
		setTitle(getCurTVItem().name);
	}
		
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');	
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
