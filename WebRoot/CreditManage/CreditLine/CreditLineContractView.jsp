<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2005/11/23
		Tester:
		Content:授信额度合同详情
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
	String PG_TITLE = "授信额度合同详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授信额度合同详情&nbsp;&nbsp;"; //默认的内容区标题
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
	String sBusinessType = "";//业务品种
	String sFolder1 = "";	
	String sApplyType ="";
	int iOrder1 = 1;
	int iOrder2 = 1;
	
	ASResultSet rs = null;
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
	//根据申请编号获得客户代码
	sSql = " select CustomerID,BusinessType,ApplyType from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
		sBusinessType = rs.getString("BusinessType");
		sApplyType = rs.getString("ApplyType");
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sApplyType == null) sApplyType = "";
	}
	rs.getStatement().close();
	
	
	//根据合同编号获得综合授信额度编号
	sSql = " select LineID from CL_INFO where BCSerialNo = '"+sObjectNo+"' and (ParentLineID is null or ParentLineID='') ";
	sCreditLineID = Sqlca.getString(sSql);
			
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务详情","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	if("3020".equals(sBusinessType))
	{
		tviTemp.insertPage("root","工程机械按揭额度信息","",iOrder1++);
		tviTemp.insertPage("root","工程机械按揭从协议信息","",iOrder1++);
	}else
	{
		tviTemp.insertPage("root","授信额度基本信息","",iOrder1++);
		tviTemp.insertPage("root","授信额度分配","",iOrder1++);
		tviTemp.insertPage("root","额度项下业务合同信息","",iOrder1++);
	}
	
	sFolder1 = tviTemp.insertFolder("root","担保合同","",iOrder1++);
	tviTemp.insertPage(sFolder1,"一般担保合同","",iOrder2++);
	tviTemp.insertPage(sFolder1,"最高额担保合同","",iOrder2++);
	tviTemp.insertPage("root","业务文档信息","",iOrder1++);
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	var sCreditLineID="<%=sCreditLineID%>";
	
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
			OpenComp("SubCreditLineList","/CreditManage/CreditLine/SubCreditLineList.jsp","ParentLineID=<%=sCreditLineID%>&ObjectType=<%=sObjectType%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="一般担保合同")
		{
			OpenComp("ContractAssureList1","/CreditManage/CreditAssure/ContractAssureList1.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="最高额担保合同")
		{
			OpenComp("ContractAssureList2","/CreditManage/CreditAssure/ContractAssureList2.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="业务文档信息")
		{
			OpenComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}	
		
		if(sCurItemname=="工程机械按揭额度信息")
		{
			OpenComp("CreditInfo","/CreditManage/CreditApply/CreditInfo.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="工程机械按揭从协议信息")
		{
			OpenComp("DealerAgreementList","/CreditManage/CreditLine/DealerAgreementList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&Model=Credit&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="额度项下业务合同信息")
		{
			OpenComp("UnderCreditLineList","/CreditManage/CreditApply/UnderCreditLineList.jsp","ComponentName=额度项下业务信息&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&BusinessType=<%=sBusinessType%>&Model=Credit&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
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
