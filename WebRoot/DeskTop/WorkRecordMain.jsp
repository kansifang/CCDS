<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   jytian  2004/12/28
			Content: 工作计划笔记框架(美化工作台)
			Input Param:
		                
			Output param:
		              
			History Log: 
		
		 */
	%>
<%
	/*~END~*/
%>



<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "工作计划笔记框架"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;工作计划笔记&nbsp;&nbsp;"; //默认的内容区标题
		String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
		String PG_LEFT_WIDTH = "200";//默认的treeview宽度
		String myleft_top_WIDTH = "0";//默认的treeview宽度
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/
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
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/
%>
	
	
	
<%
				/*~END~*/
			%>




<%
	/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/
%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/
%>
	
<%
		/*~END~*/
	%>




<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/
%>
	<script language="JavaScript">
		//屏蔽左侧区域
		myleft.width=1;
		OpenComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","NoteType=All","right");
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
