<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/27
		Tester:
		Describe: 风险分类历史认定列表;
		Input Param:			
			ObjectNo：合同编号
		Output Param:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "风险分类认定列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo = "";
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType == null) sObjectType="";
	if(sObjectNo == null) sObjectNo="";
	
	//获得页面参数 对象类型,合同编号
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	sTempletNo = "ClassifyHistoryList";
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	
	if(sDBName.startsWith("INFORMIX"))
		doTemp.WhereClause += " and CLASSIFY_RECORD.FinishDate <> '' and CLASSIFY_RECORD.FinishDate is not null ";
	else if(sDBName.startsWith("ORACLE"))
		doTemp.WhereClause += " and CLASSIFY_RECORD.FinishDate <> ' ' and CLASSIFY_RECORD.FinishDate is not null ";
	else if(sDBName.startsWith("DB2"))
		doTemp.WhereClause += " and CLASSIFY_RECORD.FinishDate <> '' and CLASSIFY_RECORD.FinishDate is not null ";
	
	doTemp.setType("BusinessSum,Balance","Number");	
	//设置查询条件
	doTemp.setColumnAttribute("AccountMonth","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
    dwTemp.setPageSize(10);

	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+",BusinessContract");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	
	String sButtons[][] = {		
		{"false","","Button","模型分类详情","查看模型分类详情","Model()",sResourcesPath},			
		{"true","","Button","合同详情","查看合同详情","ContractInfo()",sResourcesPath},
		};
	

	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
			
	/*~[Describe=查看模型分类详情;InputParam=无;OutPutParam=无;]~*/
	function Model()
	{				
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		OpenComp("ClassifyDetails","/CreditManage/CreditCheck/ClassifyDetail.jsp","ComponentName=风险分类参考模型&Action=_DISPLAY_&ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&AccountMonth="+sAccountMonth+"&SerialNo="+sSerialNo+"&ModelNo=Classify1&ClassifyType=020","_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{			
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		OpenPage("/CreditManage/CreditCheck/ClassifyCognInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=BusinessContract&ObjectNo="+sObjectNo+"&ClassifyType=020", "_self","");
	}
	
	/*~[Describe=合同详情;InputParam=无;OutPutParam=无;]~*/
	function ContractInfo()
	{ 
		//合同流水号
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //请选择一条信息！
			return;
		}
		
		openObject("AfterLoan",sSerialNo,"002");
	}
	


	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
