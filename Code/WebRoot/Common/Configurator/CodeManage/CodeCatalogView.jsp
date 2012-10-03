<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.06
		Tester:
		Content: 基础配置
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "基础配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;基础配置&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	

	//获得页面参数	

	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"代码目录","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSql = "select distinct CodeTypeOne from CODE_CATALOG";
	String sCodeTypeOne[][] = Sqlca.getStringMatrix(sSql);
	sSql = "select distinct CodeTypeOne,CodeTypeTwo from CODE_CATALOG";
	String sCodeTypeTwo[][] = Sqlca.getStringMatrix(sSql);

	int iTreeNode=1;
	String sFolders[][] = new String[sCodeTypeOne.length][2];
	for(int i=0;i<sFolders.length;i++){
		sFolders[i][0] = sCodeTypeOne[i][0];
		sFolders[i][1] =  tviTemp.insertFolder("root",sCodeTypeOne[i][0],"","",iTreeNode++);
		for(int j=0;j<sCodeTypeTwo.length;j++){
			if(sCodeTypeTwo[j][0]!=null && sCodeTypeTwo[j][0].equals(sCodeTypeOne[i][0])){
				tviTemp.insertPage(sFolders[i][1],sCodeTypeTwo[j][1],sCodeTypeTwo[j][0],"",iTreeNode++);
			}
		}	
	}
	tviTemp.insertPage("root","所有","","",iTreeNode++);	
    %>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;Describe=树图事件;]~*/%>
	<script language=javascript> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick()
	{
		var sCodeTypeOne="",sCodeTypeTwo="";
		sNodeValue = getCurTVItem().value;
		if(sNodeValue==""){
			sCodeTypeOne = getCurTVItem().name;
		}else{
			sCodeTypeOne = getCurTVItem().value;
			sCodeTypeTwo = getCurTVItem().name;
		}
		if(sCodeTypeOne=="所有") sCodeTypeOne="";
		javascript:parent.OpenComp("CodeCatalog","/Common/Configurator/CodeManage/CodeCatalogList.jsp","CodeTypeOne="+sCodeTypeOne+"&CodeTypeTwo="+sCodeTypeTwo,"right","");	
        setTitle(getCurTVItem().name);
	}


	/*~[Describe=置右面详情的标题;InputParam=sTitle:标题;OutPutParam=无;]~*/
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化;]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');		
	selectItemByName("基本信息");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
