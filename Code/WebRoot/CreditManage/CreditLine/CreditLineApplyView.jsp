<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2005/11/23
		Tester:
		Content:授信额度申请详情
		Input Param:
			ObjectType：对象类型
			ObjectNo：对象编号
		Output param:
		
		History Log: 
			zywei 2007/10/10 高亮显示第一个树型菜单项
			lpzhang 2009-8-11 增加工程机械按揭额度协议
	 */		
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信额度申请详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;授信额度申请详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = "";//Sql语句
	String sCustomerID = "";//客户代码
	String sBusinessType = "";//业务品种
	String sCreditLineID = "";//综合授信编号
	String sOccurType = "";	  //发生类型
	String sChangeObject = "";//变更对象
	String sFolder1 = "";	
	String sApplyType="";
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
	sSql = " select CustomerID,BusinessType,ApplyType,occurtype,ChangeObject from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
		sBusinessType = rs.getString("BusinessType");
		sApplyType = rs.getString("ApplyType");
		sOccurType = rs.getString("occurtype");
		sChangeObject = rs.getString("changeobject");
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sApplyType == null) sApplyType = "";
		if(sOccurType == null) sOccurType = "";
		if(sChangeObject == null) sChangeObject = "";
	}
	rs.getStatement().close();
	
	//根据申请编号获得综合授信额度编号
	sSql = " select LineID from CL_INFO where ApplySerialNo = '"+sObjectNo+"' and parentLineID is null or  parentLineID=''";
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
	}
	if(!"3020".equals(sBusinessType))
	{
		tviTemp.insertPage("root","授信额度基本信息","",iOrder1++);
		tviTemp.insertPage("root","授信额度分配","",iOrder1++);
		//tviTemp.insertPage("root","综授项下业务信息","",iOrder1++);
	}
	
	sFolder1 = tviTemp.insertFolder("root","担保信息","",iOrder1++);
	tviTemp.insertPage(sFolder1,"新增的担保信息","",iOrder2++);
	tviTemp.insertPage(sFolder1,"拟引入的担保合同","",iOrder2++);
	tviTemp.insertPage("root","业务文档信息","",iOrder1++);
	if((!sBusinessType.startsWith("30") || sBusinessType.equals("3040") ) && "1150020,1150010,1140030".indexOf(sBusinessType) < 0 )
	{
		tviTemp.insertPage("root","风险度评估","",iOrder1++);
	}
	//如果发生类型是120变更且变更对象是01申请信息
	if("120".equals(sOccurType)&&"01".equals(sChangeObject))
	{
		tviTemp.insertPage("root","变更原申请信息","",iOrder1++);
	}
	//如果发生类型是120变更且变更对象是02合同信息
	if("120".equals(sOccurType)&&"02".equals(sChangeObject))
	{
		tviTemp.insertPage("root","变更原合同信息","",iOrder1++);
	}
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
			OpenComp("SubCreditLineList","/CreditManage/CreditLine/SubCreditLineList.jsp","ParentLineID=<%=sCreditLineID%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="新增的担保信息")
		{
			OpenComp("ApplyAssureList1","/CreditManage/CreditAssure/ApplyAssureList1.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="拟引入的担保合同")
		{
			OpenComp("ApplyAssureList2","/CreditManage/CreditAssure/ApplyAssureList2.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="业务文档信息")
		{
			OpenComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		
		if(sCurItemname=="风险度评估")
		{
			OpenComp("RiskEvaluate","/CreditManage/CreditApply/RiskEvaluate.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&CustomerID=<%=sCustomerID%>&ModelType=030&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		
		if(sCurItemname=="工程机械按揭额度信息")
		{
			OpenComp("CreditInfo","/CreditManage/CreditApply/CreditInfo.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		if(sCurItemname=="工程机械按揭从协议信息")
		{
			OpenComp("DealerAgreementList","/CreditManage/CreditLine/DealerAgreementList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&Model=Credit&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}
		/*if(sCurItemname=="综授项下业务信息")
		{
			OpenComp("CreditLineApplyList","/CreditManage/CreditLine/CreditLineApplyList.jsp","ObjectType=<%=sObjectType%>&ParentLineID=<%=sCreditLineID%>&CustomerID=<%=sCustomerID%>&ObjectNo=<%=sObjectNo%>&Model=Credit&ToInheritObj=y&OpenerFunctionName="+sCurItemname,"right");
		}*/
		if(sCurItemname=="变更原合同信息")
		{
			OpenComp("OldContractList","/CreditManage/CreditApply/OldContractList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
		}
		if(sCurItemname=="变更原申请信息")
		{
			OpenComp("OldApplyList","/CreditManage/CreditApply/OldApplyList.jsp","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
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
	myleft.width=170;
	startMenu();
	expandNode('root');
	expandNode('<%=sFolder1%>');
	selectItem('1');
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
