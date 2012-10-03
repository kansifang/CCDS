<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/%>
	<%
	/*
		Author:	jjwang  2008-10-12
		Tester:
		Content:  新会计准则《损失识别》
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "损失识别"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;损失识别&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	if(sLoanAccount==null) sLoanAccount="";
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));
	if(sCustomerName==null) sCustomerName="";
	String sMClassifyResult = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MClassifyResult"));
	if(sMClassifyResult==null) sMClassifyResult="";
	String sBalance = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Balance"));
	if(sBalance==null) sBalance="";
	String sPutoutDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PutoutDate"));
	if(sPutoutDate==null) sPutoutDate="";
	String sMaturityDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MaturityDate"));
	if(sMaturityDate==null) sMaturityDate="";
	
	//获得页面参数	
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"损失识别","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo='ReserveLossView' and IsInUse='1' ";
	tviTemp.initWithSql("SortNo","ItemName","ItemName","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
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
		openChildComp("ReserveLossInfo","/BusinessManage/ReserveManage/ReserveLossInfo.jsp","AccountMonth=<%=sAccountMonth%>"+"&LoanAccount=<%=sLoanAccount%>"+"&CustomerName=<%=sCustomerName%>"+"&MClassifyResult=<%=sMClassifyResult%>"+"&Balance=<%=sBalance%>"+"&PutoutDate=<%=sPutoutDate%>"+"&MaturityDate=<%=sMaturityDate%>");
		setTitle(getCurTVItem().name);
	}
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}	
	</script> 
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');
	openChildComp("ReserveLossInfo","/BusinessManage/ReserveManage/ReserveLossInfo.jsp","AccountMonth=<%=sAccountMonth%>"+"&LoanAccount=<%=sLoanAccount%>"+"&CustomerName=<%=sCustomerName%>"+"&MClassifyResult=<%=sMClassifyResult%>"+"&Balance=<%=sBalance%>"+"&PutoutDate=<%=sPutoutDate%>"+"&MaturityDate=<%=sMaturityDate%>");
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
