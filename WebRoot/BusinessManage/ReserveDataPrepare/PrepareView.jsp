<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/%>
	<%
	/*
		Author:	jjwang  2008-10-06
		Tester:
		Content:  新会计准则《数据采集》
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "数据采集"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;数据采集&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	//String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	//if(sCustomerID==null) sCustomerID="";
	//获得页面参数	
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"数据采集","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	String sSqlTreeView = "";
	//定义树图结构
	if(CurUser.hasRole("608") && CurUser.hasRole("611")){
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='PrepareView' and IsInUse='1'";
	}else if(CurUser.hasRole("611")){
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='PrepareView' and IsInUse='1' and itemno like '0030%' ";
	}else{
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='PrepareView' and IsInUse='1' and itemno not like '0030%'";
	}
	tviTemp.initWithSql("SortNo","ItemName","ItemName","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview单击选中事件--关联客户在本行的业务活动信息
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemID=="0010010")
		{
			openChildComp("ReserveDataEntList","/BusinessManage/ReserveDataPrepare/ReserveDataEntList.jsp","");
		}else if(sCurItemID=="0010020")
		{
			openChildComp("ReserveDataIndList","/BusinessManage/ReserveDataPrepare/ReserveDataIndList.jsp","");
		}else if(sCurItemID=="0010030")
		{
			openChildComp("ReserveDataList","/BusinessManage/ReserveDataPrepare/ReserveDataList.jsp","");
		}else if(sCurItemID=="0010040")
		{
			openChildComp("ReserveDataWithDrawList","/BusinessManage/ReserveDataPrepare/ReserveDataWithDrawList.jsp","");
		}else if(sCurItemID=="0020")
		{
			openChildComp("ReportList","/BusinessManage/ReserveDataPrepare/ReportList.jsp","");
		}else if(sCurItemID=="0030010")
		{
			openChildComp("DataBaseList","/BusinessManage/ReserveDataPrepare/DataBaseList.jsp","");
		}else if(sCurItemID=="0030020")
		{
			openChildComp("DataBaseIndList","/BusinessManage/ReserveDataPrepare/DataBaseIndList.jsp","");
		}else if(sCurItemID=="0040010")
		{
			openChildComp("ReserveDataBaseList","/BusinessManage/ReserveDataPrepare/ReserveDataBaseList.jsp","Type=Ent");
		}else if(sCurItemID=="0040020")
		{
			openChildComp("ReserveDataBaseList","/BusinessManage/ReserveDataPrepare/ReserveDataBaseList.jsp","Type=Ind");
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
	expandNode('0010');
	expandNode('0030');
	expandNode('0040');
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
