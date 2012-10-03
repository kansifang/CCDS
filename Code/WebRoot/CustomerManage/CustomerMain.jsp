<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:	  BYao	  2004.12.07
		Content: 客户主界面
		Input Param:
			                CustomerType：客户类型
			                				010	公司客户
			                				020	关联集团
			                				030	个人客户
			                				035	个体工商户
			                				040	农户
			                				050	联保小组
			                ComponentName:组件名称
			                CustomerListTemplet:客户列表模板代码
			                以上参数统一由代码表:MainMenu主菜单得到配置
		Output param:
			                CustomerType：客户类型
			                ComponentName:组件名称
			                CustomerListTemplet:客户列表模板代码
			                以上参数统一由代码表:MainMenu主菜单得到配置
		History Log: 
			2004-12-13	cchang	增加个体工商户操作
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;客户管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	String sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
	String sCustomerListTemplet = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerListTemplet"));
	
	//获得页面参数	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script language=javascript> 
	
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script language="JavaScript">
	//startMenu();
	//expandNode('root');
	sCustomerType = "<%=sCustomerType%>";
	sComponentName = "<%=sComponentName%>"
	sCustomerListTemplet = "<%=sCustomerListTemplet%>"
	myleft.width=1;
	OpenComp("CustomerList","/CustomerManage/CustomerList.jsp","ComponentName=公司客户列表&OpenerFunctionName="+sComponentName+"&CustomerType="+sCustomerType+"&CustomerListTemplet="+sCustomerListTemplet,"right");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
