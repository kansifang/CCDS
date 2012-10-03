<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
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
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;未命名模块&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	

	//获得页面参数	

	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"押品系统数据初始化","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	String sFolder1=tviTemp.insertFolder("root","数据初始化","",1);
	tviTemp.insertPage(sFolder1,"押品入库初始化（EXCEL）","",1);
	tviTemp.insertPage(sFolder1,"票据对应批次号初始化（TEXT）","",2);
	tviTemp.insertPage(sFolder1,"票据保证金初始化（EXCEL）","",3);
	tviTemp.insertPage(sFolder1,"额度信息初始化（TEXT）","",4);
	tviTemp.insertPage(sFolder1,"生成保证金合同信息","",5);
	
	
	
	
	//另一种定义树图结构的方法：SQL
	//String sSqlTreeView = "from EXAMPLE_INFO";
	//tviTemp.initWithSql("SortNo","ExampleName","ExampleID","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为： ID字段,Name字段,Value字段,Script字段,Picture字段,From子句,OrderBy子句,Sqlca
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
		if(sCurItemID==2){//押品入库初始化
			OpenComp("FileChooseDialog","/ImpawnManage/DataInit/FileChooseDialog.jsp","ItemID="+sCurItemID+"&FileType=Excel","right");
		}else if(sCurItemID==3){//票据对应批次号初始化
			OpenComp("FileChooseDialog","/ImpawnManage/DataInit/FileChooseDialog.jsp","ItemID="+sCurItemID+"&FileType=Text","right");					
		}else if(sCurItemID==4){//票据保证金信息初始化
			OpenComp("FileChooseDialog","/ImpawnManage/DataInit/FileChooseDialog.jsp","ItemID="+sCurItemID+"&FileType=Excel","right");					
		}else if(sCurItemID==5){//额度信息初始化
			OpenComp("FileChooseDialog","/ImpawnManage/DataInit/FileChooseDialog.jsp","ItemID="+sCurItemID+"&FileType=Text","right");
		}else if(sCurItemID==6){//保证金登记簿等币种更新及生成保证金质押合同
			ShowMessage("正在进行业务提交校验,请耐心等待.......",true,false);
			var sReturn = PopPage("/ImpawnManage/DataInit/FinalInfoHandler.jsp?SerialNo=","","dialogWidth=0;dialogHeight=0;minimize:yes");
			if(sReturn=="true") {
				try{hideMessage();}catch(e) {}
				alert("处理成功！");
			}
			try{hideMessage();}catch(e) {}
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
	<script language="javascript">
	startMenu();
	expandNode('root');		
	expandNode('1');
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
