<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2005/11/23
		Tester:
		Content:授信额度最终审批意见详情
		Input Param:
			ObjectType：对象类型
			ObjectNo：对象编号
		Output param:
		
		History Log: 
		
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信额度最终审批意见详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授信额度最终审批意见详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = "";//Sql语句
	String sCustomerID = "";//客户代码
	String sCreditLineID = "";//综合授信编号
	String sFolder1 = "";	
	int iOrder1 = 1;
	int iOrder2 = 1;

	//获得页面参数		
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%	
	//根据最终审批意见编号获得客户代码
	sSql = " select CustomerID from BUSINESS_APPROVE where SerialNo = '"+sObjectNo+"' ";
	sCustomerID = Sqlca.getString(sSql);  
	//根据最终审批意见编号获得综合授信额度编号
	sSql = " select LineID from CL_INFO where ApproveSerialNo = '"+sObjectNo+"' ";
	sCreditLineID = Sqlca.getString(sSql);
			
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务详情","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	tviTemp.insertPage("root","授信额度基本信息","",iOrder1++);
	tviTemp.insertPage("root","授信额度分配","",iOrder1++);
	
	sFolder1 = tviTemp.insertFolder("root","担保信息","",iOrder1++);
	tviTemp.insertPage(sFolder1,"新增的担保信息","",iOrder2++);
	tviTemp.insertPage(sFolder1,"拟引入的担保合同","",iOrder2++);
	tviTemp.insertPage("root","业务文档信息","",iOrder1++);
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	
	//treeview单击选中事件	
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=="授信额度基本信息")
		{
			OpenComp("CreditInfo","/CreditManage/CreditApply/CreditInfo.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="授信额度分配")
		{
			OpenComp("SubCreditLineList","/CreditManage/CreditLine/SubCreditLineList.jsp","ParentLineID=<%=sCreditLineID%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="新增的担保信息")
		{
			OpenComp("ApproveAssureList1","/CreditManage/CreditAssure/ApproveAssureList1.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="拟引入的担保合同")
		{
			OpenComp("ApproveAssureList2","/CreditManage/CreditAssure/ApproveAssureList2.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="业务文档信息")
		{
			OpenComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}		
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
	selectItem('1');
	expandNode('root');
	expandNode('<%=sFolder1%>');
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
