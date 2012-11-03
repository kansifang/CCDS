<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  --fbkang 2005.7.25
		Tester:
		Content: --客户视图主界面
		Input Param:
			  ObjectNo  ：--客户号
		Output param:
			               
		History Log: 
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户管理"; //-- 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //--默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//--默认的内容区文字
	String PG_LEFT_WIDTH = "200";//--默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = "";	//--存放sql语句
	String sItemAttribute = "",sItemDescribe = "",sAttribute2 = "",sAttribute3 = "";//--客户类型	
	String sCustomerType = "";//--客户类型	
	String sCustomerScale = "";//--客户规模
	String sTreeViewTemplet = "";//--存放custmerview页面树图的CodeNo
	ASResultSet rs = null;//--存放结果集
	int iCount = 0;//记录数
	//获得组件参数	,客户代码
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//获得页面参数	

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	
	//客户经理岗位（总行/分行/支行）的人员：从客户所属信息表中查询出本机构自己具有当前客户的信息查看权或信息维护权的记录数
	if(CurUser.hasRole("080") || CurUser.hasRole("280") || CurUser.hasRole("480"))
	{
		sSql = 	" select Count(*) from CUSTOMER_BELONG  "+
				" where CustomerID = '"+sCustomerID+"' "+
				" and OrgID = '"+CurOrg.OrgID+"' "+
				" and UserID = '"+CurUser.UserID+"' "+
				" and (BelongAttribute1 = '1' "+
				" or BelongAttribute2 = '1')";
	}else//非客户经理岗位的人员：从客户所属信息表中查询出本机构及其下属机构具有当前客户的信息查看权或信息维护权的记录数
	{	
		sSql =  " select sortno||'%' from org_info where orgid='"+CurUser.OrgID+"' ";
		String sSortNo = Sqlca.getString(sSql);
		sSql = 	" select Count(*) from CUSTOMER_BELONG  "+
				" where CustomerID = '"+sCustomerID+"' "+
				" and OrgID in (select orgid from org_info where sortno like '"+sSortNo+"') "+
				" and (BelongAttribute1 = '1' "+
				" or BelongAttribute2 = '1')";
	}
	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
		iCount = rs.getInt(1);
	//关闭结果集
	rs.getStatement().close();
	
	//如果用户没有上述相关权限，则给出相应的提示
	if( iCount  <= 0 && false)//改为谁都可以看，modified by zrli
	{
%>
		<script>
			//用户不具备当前客户查看权
			alert( getHtmlMessage(15));				
		    self.close();			        
		</script>
<%
	}
	
	//取得客户类型
	sSql = "select CustomerType,CustomerScale from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerType = rs.getString("CustomerType");	
		sCustomerScale = rs.getString("CustomerScale");	
	}
	rs.getStatement().close();
	
	if(sCustomerType == null) sCustomerType = "";

	//取得视图模板类型	
	sSql = " select ItemDescribe,ItemAttribute,Attribute2,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = '"+sCustomerType+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sItemDescribe = DataConvert.toString(rs.getString("ItemDescribe"));		//客户详情树图类型
		sAttribute2 = DataConvert.toString(rs.getString("Attribute2"));		//中小企业客户详情树图类型
	}
	rs.getStatement().close(); 
	
	if(sCustomerScale!=null&&sCustomerScale.startsWith("02"))
	{
		sTreeViewTemplet = sAttribute2;		//中小公司客户详情树图类型
	}else
	{
		sTreeViewTemplet = sItemDescribe;		//公司客户详情树图类型
	}
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"客户信息管理","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sTreeViewTemplet+"' and isinuse = '1' ";
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
		var sObjectType = "Customer";
		var sCurItemID = getCurTVItem().id;//--获得树图的节点号码
		var sCurItemName = getCurTVItem().name;//--获得树图的节点名称
		var sCurItemDescribe = getCurTVItem().value;//--获得连接下个页面的路径及相关的参数
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];//--获得连接下个页面的路径
		sCurItemDescribe2=sCurItemDescribe[1];//--存放下个页面的的页面名称
		sCurItemDescribe3=sCurItemDescribe[2];//--现在没有
		sCurItemDescribe4=sCurItemDescribe[3];//--现在没有

		sCustomerID = "<%=sCustomerID%>";//--获得客户代码
		
		//add by xhyong 2009/08/24 授信风险限额用CustomerLimit标示
		if(sCurItemDescribe4 == "080")//授信风险限额
		{
			sObjectType = 'CustomerLimit';
		}
	    //add by hldu 并行信用等级评估设定CustomerType
		if(sCurItemDescribe3 == "NewEvaluate" )
		{
			sObjectType = 'NewEvaluate';
		}
		//add end 
		if(sCurItemDescribe2 == "Back")
		{
			top.close();
		}
		else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
		{
			openChildComp(sCurItemDescribe2,sCurItemDescribe1,"&CustomerType=<%=sCustomerType%>&ModelType="+sCurItemDescribe4+"&ObjectNo="+sCustomerID+"&ComponentName="+sCurItemName+"&CustomerID="+sCustomerID+"&ObjectType="+sObjectType+"&NoteType="+sCurItemDescribe3);
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
	selectItem('010');
	sCustomerType = "<%=sCustomerType%>";
	sCustomerScale = "<%=sCustomerScale%>";
	if(sCustomerType != '0201')
	{
		expandNode('010');
	}
	if(sCustomerScale!=null&&sCustomerScale.substring(0,2)=="02")
	{
		selectItem('010005');//自动点击树图，目前写死，也可以设置到 code_library中进行设定
	}else 
	{
		selectItem('010010');//自动点击树图，目前写死，也可以设置到 code_library中进行设定
	}
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
