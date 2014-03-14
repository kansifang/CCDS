<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content:示例模块主页面
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
		String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;未命名模块&nbsp;&nbsp;"; //默认的内容区标题
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
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"未命名","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
		tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

		//定义树图结构
		String sFolder1=tviTemp.insertFolder("root","示例信息","",1);
		tviTemp.insertPage(sFolder1,"所有的示例信息","",1);
		tviTemp.insertPage(sFolder1,"我的示例信息","",2);
		tviTemp.insertPage(sFolder1,"他的示例信息","",3);
		//String sFolder2=tviTemp.insertFolder("root","示例信息2","",2);
		//tviTemp.insertPage(sFolder2,"所有的示例信息","",1);
		
		
		//另一种定义树图结构的方法：SQL
		//String sSqlTreeView = "from EXAMPLE_INFO";
		//tviTemp.initWithSql("SortNo","ExampleName","ExampleID","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//tviTemp.initWithCode("BusinessInspectMain",Sqlca);
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
		
		if(sCurItemname=='所有的示例信息'){
			OpenComp("ExampleList","/Frame/CodeExamples/ExampleList.jsp","","right");

		}
		else if(sCurItemname=='我的示例信息'){
			OpenComp("LoadExcelFileList","/Test/zywei/LoadExcelFileList.jsp","","right");						
			//OpenComp("ExampleList","/Frame/CodeExamples/ExampleList.jsp","InputUser=<%=CurUser.UserID%>");						
		}
		else if(sCurItemname=='他的示例信息'){
		alert("hello");

		}
		else{
			return;
		}
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
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
