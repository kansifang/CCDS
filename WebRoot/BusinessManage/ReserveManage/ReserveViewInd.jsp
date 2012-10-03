<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/%>
	<%
	/*
		Author:	jjwang  2008-10-06
		Tester:
		Content:  新会计准则《个人业务》
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "个人业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;个人业务&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	//String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	//if(sCustomerID==null) sCustomerID="";
	//获得页面参数	
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"个人业务","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "";
	if(CurUser.hasRole("604"))
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' and ItemNo in ('0020') ";
	else if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' and ItemNo in ('0010','0010010','0010011') ";
	else if(CurUser.hasRole("601"))
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' and ItemNo in ('0010','0010012','0010013') ";
	else if(CurUser.hasRole("602"))
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' and ItemNo in ('0010','0010014','0010015') ";
	else if(CurUser.hasRole("603"))
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' and ItemNo in ('0010','0010016','0010017') ";
	else 
		sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveView' and IsInUse='1' ";//add by zrli 20091021 开发方便，无角色全显示，上线后需屏蔽
	tviTemp.initWithSql("SortNo","ItemName","ItemName","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview单击选中事件--关联客户在本行的业务活动信息
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemID=="0010010" || sCurItemID=="0010012" || sCurItemID=="0010014" || sCurItemID=="0010016")
		{
			if(<%=CurUser.hasRole("601")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=UnFinished&Type=Confirm&Grade=02");
			}else if(<%=CurUser.hasRole("602")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=UnFinished&Type=Confirm&Grade=03");
			}else if(<%=CurUser.hasRole("603")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=UnFinished&Type=Confirm&Grade=04");
			}else if(<%=CurUser.hasRole("480")%> || <%=CurUser.hasRole("280")%> || <%=CurUser.hasRole("080")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=UnFinished&Type=Input&Grade=01");
			}
		}else if(sCurItemID=="0010011" || sCurItemID=="0010013" || sCurItemID=="0010015" || sCurItemID=="0010017")
		{
			if(<%=CurUser.hasRole("601")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=Finished&Type=Confirm&Grade=02");
			}else if(<%=CurUser.hasRole("602")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=Finished&Type=Confirm&Grade=03");
			}else if(<%=CurUser.hasRole("603")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=Finished&Type=Confirm&Grade=04");
			}else if(<%=CurUser.hasRole("480")%> || <%=CurUser.hasRole("280")%> || <%=CurUser.hasRole("080")%>)
			{
				openChildComp("InputIndList","/BusinessManage/ReserveManage/InputIndList.jsp","Action=Finished&Type=Input&Grade=01");
			}
		}
		else if(sCurItemID=="0020")
		{
			openChildComp("ResultConfirmIndList","/BusinessManage/ReserveManage/ResultConfirmIndList.jsp","Action=Finished&Type=Audit&Grade=05");
		}else if(sCurItemID=="0030")
		{
			openChildComp("ManualConfirmIndList","/BusinessManage/ReserveManage/ManualConfirmIndList.jsp","");
		}
		
		setTitle(getCurTVItem().name);
	}
	function startMenu() 
	{
		if((<%=CurUser.hasRole("480")%> || <%=CurUser.hasRole("280")%> || <%=CurUser.hasRole("080")%>) && (<%=CurUser.hasRole("601")%> || <%=CurUser.hasRole("602")%> || <%=CurUser.hasRole("603")%>))
		{
			alert("由于该用户具有信贷经理和认定员双重角色!不可以进行减值准备流程预测或认定.\n请与系统管理员联系，重新分配角色！");
			OpenComp("Main","/Main.jsp","","_self","");
		}
		<%=tviTemp.generateHTMLTreeView()%>
	}	
	</script> 
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');
	expandNode('0010');
	expandNode('0030');
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
