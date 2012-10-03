
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   zywei  2005.07.26
	Tester:
	Content: 审批授权管理_Main
	Input Param:	
		               
	Output param:
	             
	History Log: 	 
	                
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "审批授权管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;审批授权管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"审批授权管理","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	String sFolder0 = tviTemp.insertFolder("root","基础设定","",1);	
	tviTemp.insertPage(sFolder0,"例外类型设定","",1);
	String sFolder1 = tviTemp.insertFolder("root","授权方案设定","",1);	
	tviTemp.insertPage(sFolder1,"增删授权方案","",1);
	tviTemp.insertPage(sFolder1,"为流程指定授权方案","",1);
	
	%>
<%/*~END~*/%>
 

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script language=javascript> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick()
	{
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=='授权计算器设定'){
			OpenComp("AjudicatorSettingList","/Common/Configurator/AAManage/AjudicatorSettingList.jsp","","right");
		}else if(sCurItemname=='例外类型设定'){
			OpenComp("ExceptionTypeSettingList","/Common/Configurator/AAManage/ExceptionTypeSettingList.jsp","","right");
		}else if(sCurItemname=='增删授权方案'){
			OpenComp("PolicySettingList","/Common/Configurator/AAManage/PolicySettingList.jsp","","right");
		}else if(sCurItemname=='为流程指定授权方案'){
			OpenComp("FlowPolicySettingList","/Common/Configurator/AAManage/FlowPolicySettingList.jsp","","right");
		}
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
			
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');	
	expandNode('<%=sFolder0%>');
	expandNode('<%=sFolder1%>');

	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
