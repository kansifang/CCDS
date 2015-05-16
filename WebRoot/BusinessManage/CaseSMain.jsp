<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   --fbkang 2005-7-28
			Tester:	  
			Content: --产品主界面
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
		String PG_TITLE = "信贷产品管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;信贷产品管理&nbsp;&nbsp;"; //默认的内容区标题
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
		String sCodeNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo")));
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
	//myleft.width=1;
	OpenComp("CaseList","/BusinessManage/CaseList.jsp","ComponentName=案件查询","right");
	setTitle("案件查询");
	<%
	if(sCodeNo.startsWith("/")){
		out.println("parent.parent.newTab('"+sComponentName+"','"+sCodeNo+"');");
	}
%>
//setTitle("案件查询");
	</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
