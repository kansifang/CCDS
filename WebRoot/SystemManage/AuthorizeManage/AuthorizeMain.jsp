<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: wwhe	2008-04-19
			Tester:
			Content:授权管理
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
		String PG_TITLE = "授权管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;授权管理&nbsp;&nbsp;"; //默认的内容区标题
		String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
		String PG_LEFT_WIDTH = "200";//默认的treeview宽度
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
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/
%>
	<%
		//定义Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"授权管理","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
		tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

		//定义树图结构
		tviTemp.insertPage("root","授权方案及业务品种设置","",1);
		//tviTemp.insertPage("root","授权方案计算公式设置","",1);
		tviTemp.insertPage("root","授权方案控制条件设置","",1);
		tviTemp.insertPage("root","机构授权维护","",1);
		tviTemp.insertPage("root","机构特别授权维护","",1);
		//tviTemp.insertPage("root","信用评级授权维护","",1);
		//tviTemp.insertPage("root","机构授权维护展示","",1);

		//另一种定义树图结构的方法：SQL
		//String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'MXQueryList' and Isinuse = '1'";
		//tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//参数从左至右依次为： ID字段,Name字段,Value字段,Script字段,Picture字段,From子句,OrderBy子句,Sqlca
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/
%>
	<script language=javascript>

	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/

	function TreeViewOnClick()
	{
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='授权方案及业务品种设置')
			OpenComp("AuthorizePreceptList","/SystemManage/AuthorizeManage/AuthorizePreceptList.jsp","Type=Precept","right");
		else if(sCurItemname=='授权方案计算公式设置')
			OpenComp("AuthorizePreceptList","/SystemManage/AuthorizeManage/AuthorizePreceptList.jsp","Type=Condition&Type2=Balance","right");
		else if(sCurItemname=='授权方案控制条件设置')
			OpenComp("AuthorizePreceptList","/SystemManage/AuthorizeManage/AuthorizePreceptList.jsp","Type=Condition","right");
		else if(sCurItemname=='机构授权维护')
			OpenComp("AuthorizeOrgList","/SystemManage/AuthorizeManage/AuthorizeOrgList.jsp","","right");
		else if(sCurItemname=='机构特别授权维护')
			OpenComp("AuthorizeOrgWithSpecialList","/SystemManage/AuthorizeManage/AuthorizeOrgWithSpecialList.jsp","AType=Special","right");
		else if(sCurItemname=='信用评级授权维护')
			OpenComp("AuthorizeEvaluateList2","/SystemManage/AuthorizeManage/AuthorizeEvaluateList.jsp","","right");
		//else if(sCurItemname=='机构授权维护展示')
			//OpenComp("AuthorizeOrgList2","/SystemManage/AuthorizeManage/AuthorizeOrgList2.jsp","","right");
		else
			return;

		setTitle(getCurTVItem().name);
	}

	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/
%>
	<script language="javascript">
	startMenu();
	expandNode('root');	
	expandNode('root');		
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
