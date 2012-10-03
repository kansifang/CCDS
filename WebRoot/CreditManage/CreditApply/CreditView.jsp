<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jytian  2004-12-10
		Tester:
		Content: 业务申请主界面
		Input Param:
			 	SerialNo：业务申请流水号
		Output param:
			      
		History Log: 
				2005.08.09 王业罡 整理代码，去掉window.open打开方法,删除无用代码，整合逻辑
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "业务申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;基本信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	
	//定义变量
	String sBusinessType = "",sCustomerID = "",sApplyType="",sChangeObject="",sChangtype="";
	String sOccurType = "";
	String sTable="";
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sIsCreditLine = (String)CurComp.compParentComponent.compParentComponent.getAttribute("IsCreditLine");
	if(sIsCreditLine == null) sIsCreditLine = "";
	//System.out.println("--------begin-------"+sObjectType+"/"+sObjectNo);
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	
	//根据sObjectType的不同，得到不同的关联表名和模版名
	String sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){ 
		sTable=DataConvert.toString(rs.getString("ObjectTable"));
	}
	rs.getStatement().close(); 
	
	sSql="select CustomerID,OccurType,BusinessType,ApplyType,ChangeObject,changtype from "+sTable+" where SerialNo='"+sObjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCustomerID=DataConvert.toString(rs.getString("CustomerID"));
		sOccurType=DataConvert.toString(rs.getString("OccurType"));
		sBusinessType=DataConvert.toString(rs.getString("BusinessType"));
		sApplyType=DataConvert.toString(rs.getString("ApplyType"));
		sChangeObject=DataConvert.toString(rs.getString("ChangeObject"));
		sChangtype=DataConvert.toString(rs.getString("Changtype"));
		System.out.println("sChangtype=====================>>"+sChangtype);
	}
	rs.getStatement().close(); 

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"业务详情","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构,根据阶段(RelativeCode)、发生类型(Attribute1)、业务品种(Attribute2)、排除的业务品种(Attribute3)、变更对象（Attribute5）、变更类型（Attribute6）生成不同的树图
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'CreditView' ";
	sSqlTreeView += "and (RelativeCode like '%"+sObjectType+"%' or RelativeCode='All') " +
	          " and ((Attribute1 like '%"+sOccurType+"%' or Attribute2 like '%"+sBusinessType+"%' ) "+	 
	          " or ((Attribute1='' or Attribute1 is null ) and (Attribute2='' or Attribute2 is null ) )) "+
	          " and (Attribute3 not like '%"+sBusinessType+"%' or Attribute3 is null or Attribute3='') "+
	          " and (Attribute4 not like '%"+sApplyType+"%' or Attribute4 is null or Attribute4='') "+
	          " and ((Attribute5 like '%"+sChangeObject+"%') or ((Attribute5='' or Attribute5 is null )  )) "+
	//          " and (Attribute6 <> '"+sChangtype+"' or Attribute6 is null or Attribute6='') "+
	          " and IsInUse = '1' " ;
	if("true".equals(sIsCreditLine)){
		sSqlTreeView +=" and ItemNo not in('040','040010','040020','040030','040040','041','041050','041060','080')";
	}          
	//System.out.println("---------------"+sSqlTreeView);
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
		
		sObjectType="<%=sObjectType%>";
		sObjectNo="<%=sObjectNo%>";
		sCustomerID="<%=sCustomerID%>";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		sParaStringTmp=sParaStringTmp.replace("#ObjectType",sObjectType);
		sParaStringTmp=sParaStringTmp.replace("#ObjectNo",sObjectNo);
		sParaStringTmp=sParaStringTmp.replace("#CustomerID",sCustomerID);
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}

	//treeview单击选中事件
	function TreeViewOnClick(){
		var AccountType="";
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root")	return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe0=sCurItemDescribe[0];
		sCurItemDescribe1=sCurItemDescribe[1];
		sCurItemDescribe2=sCurItemDescribe[2];
		
		if(sCurItemDescribe1 == "GuarantyList"){
			openChildComp("GuarantyList","/CreditManage/GuarantyManage/GuarantyList.jsp","ObjectType=<%=sObjectType%>&WhereType=Business_Guaranty&ObjectNo=<%=sObjectNo%>");
			setTitle(getCurTVItem().name);
		}else if(sCurItemDescribe1=="ApplyAssureList1")
		{
			openChildComp("ApplyAssureList1","/CreditManage/CreditAssure/ApplyAssureList1.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>");
			setTitle(getCurTVItem().name);
		}else if(sCurItemDescribe1 == "RelativeBusinessList"){
			openChildComp("RelativeBusinessList","/CreditManage/CreditApply/RelativeBusinessList.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&CustomerID=<%=sCustomerID%>&OccurType=<%=sOccurType%>");
			setTitle(getCurTVItem().name);
		}else if(sCurItemDescribe0 != "null"){
			openChildComp(sCurItemDescribe1,sCurItemDescribe0,"ComponentName="+sCurItemName+"&AccountType=ALL&"+sCurItemDescribe2);
			setTitle(getCurTVItem().name);
		}
	}

	//置右面详情的标题
	function setTitle(sTitle){
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}
	
	function startMenu() {
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script language="JavaScript">
	myleft.width=170;
	startMenu();
	expandNode('root');
	expandNode('01');
	expandNode('040');
	expandNode('041');	
	selectItem('010');
	setTitle("基本信息");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>