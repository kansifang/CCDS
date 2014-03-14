<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   --wlu 2009-2-17
			Tester:	  
			Content: --核心科目管理
			Input Param:
		     --ComponentName：组件名称    
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
		String PG_TITLE = "核心科目管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;核心科目管理&nbsp;&nbsp;"; //默认的内容区标题
		String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
		String PG_LEFT_WIDTH = "1";//默认的treeview宽度,不显示树图
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
		 String sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));
		//获得页面参数	
		
		PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
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
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/
%>
   <script language="JavaScript">
	OpenComp("SubjectList","/Common/Configurator/SubjectPolicy/SubjectList.jsp","ComponentName=核心科目管理列表","right");
	</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
