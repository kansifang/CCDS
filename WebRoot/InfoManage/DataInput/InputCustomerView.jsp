<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: 客户主界面
		Input Param:
			                CustomerID：客户号
		Output param:
			                CustomerID：客户号
		History Log: 
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = "";	
	String sCustomerType = "";
	String sCustomerTemplet = "";
	String sCustomerInfoTemplet = "",sModelType = "";
	ASResultSet rs = null;
	//获得组件参数	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//获得页面参数	

	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	//取得客户类型
	sSql="select CustomerType  from CUSTOMER_INFO where CustomerID='"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
	   sCustomerType=DataConvert.toString(rs.getString("CustomerType"));
	}
	rs.getStatement().close(); 

	//取得视图模板类型
	sSql="select ItemDescribe,ItemAttribute  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = '"+sCustomerType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
	   sCustomerTemplet=DataConvert.toString(rs.getString("ItemDescribe"));
	   sCustomerInfoTemplet=DataConvert.toString(rs.getString("ItemAttribute"));
	}
	rs.getStatement().close(); 

	//判断使用信用等级评估模型的类型
	if(sCustomerType!=null&&("01,02").indexOf(sCustomerType.substring(0,2))>=0)// 公司客户、集团客户
	{
		sModelType = "010";
	}else if(sCustomerType!=null&&("03,04,05").indexOf(sCustomerType.substring(0,2))>=0)//个人客户、个体工商户、农户
	{
		sModelType = "015";
	}else	sModelType = "010";
	

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"客户信息","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sCustomerTemplet+"' and (isinuse is null or isinuse<>'2') and (ItemNo='010' or ItemNo='010010' or ItemNo='010020' or ItemNo='010030' or ItemNo='010040' or ItemNo='010050')";
	
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
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
	
	//treeview单击选中事件
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		sCurItemDescribe3=sCurItemDescribe[2];
		sCurItemDescribe4=sCurItemDescribe[3];

		sCustomerID = "<%=sCustomerID%>";
		sCustomerInfoTemplet = "<%=sCustomerInfoTemplet%>";

		if(sCurItemDescribe2 == "Back")
		{
			top.close();
		}
		else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
		{
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"ModelType="+sCurItemDescribe4+"&ObjectNo="+sCustomerID+"&ComponentName="+sCurItemName+"&CustomerID="+sCustomerID+"&ObjectType=Customer&CustomerInfoTemplet="+sCustomerInfoTemplet+"&NoteType="+sCurItemDescribe3);
			setTitle(getCurTVItem().name);
		}
	}



	//置右面详情的标题
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
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
	expandNode('010');
	sCustomerType = "<%=sCustomerType%>";
	if(sCustomerType != '02')
	{
		openChildComp("CustomerInfo","/CustomerManage/CustomerInfo.jsp","CustomerID=<%=sCustomerID%>&Types=Reinforce");
	}
	setTitle("客户概况");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
