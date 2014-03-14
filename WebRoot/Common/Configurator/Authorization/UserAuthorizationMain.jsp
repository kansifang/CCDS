<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/
%>
	<%
		/*
			~Author=wlu;
			~Tester=;
			~Describe=定义页面属性;
			~InputParam=;
			~OutputParam=;
			~LastModifyTime=;
			~HistoryLog=;
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "授权管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;授权管理&nbsp;&nbsp;"; //默认的内容区标题
		String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
		String PG_LEFT_WIDTH = "1";//默认的treeview宽度
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/
%>
	<%
		//定义变量
		
		//获得页面参数
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/
%>
	<%
		
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/
%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/
%>
	<script language=javascript> 

	</script> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/
%>
	<script language="JavaScript">
	OpenComp("AuthorizationList","/Common/Configurator/Authorization/AuthorizationList.jsp","","right");			
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
