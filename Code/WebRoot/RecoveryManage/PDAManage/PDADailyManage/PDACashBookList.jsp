<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
	/*
		Author: FSGong  2004-12-14
		Tester:
		Describe: 抵债资产收现台帐;
		Input Param:
				ObjectType：对象类型（ASSET_INFO）
				ObjectNo：对象编号（资产流水号）
		Output param:	          
		HistoryLog:zywei 2005/09/07 重检代码
	*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产收现台帐列表;"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";	
	
	//获得页面参数

%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义表头文件
	String sHeaders[][] = {
							{"ObjectType","对象类型"},
							{"ObjectNo","资产流水号"},
							{"SerialNo","收现流水号"},						
							{"AssetName","资产名称"},
							{"CashBackType","收回方式"},
							{"FormerCurrency","原币种"},
							{"ReclaimCurrency","收现币种"},
							{"ReclaimSum","收现金额"},
							{"EnterAccountDate","入账日期"},			
							{"ReclaimDate","收现日期"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"},
							{"InputDate","登记日期"}
						 };  
						 
	sSql = 	" select RECLAIM_INFO.ObjectType as ObjectType,"+
			" RECLAIM_INFO.ObjectNo as ObjectNo,"+
			" RECLAIM_INFO.SerialNo as SerialNo,"+		
			" ASSET_INFO.AssetName as AssetName,"+
			" getItemName('CashBackType1',RECLAIM_INFO.CashBackType) as CashBackType,"+
			" getItemName('Currency',RECLAIM_INFO.FormerCurrency) as FormerCurrency,"+
			" getItemName('Currency',RECLAIM_INFO.ReclaimCurrency) as ReclaimCurrency,"+
			" RECLAIM_INFO.ReclaimSum as ReclaimSum,"+
			" RECLAIM_INFO.EnterAccountDate as EnterAccountDate,"+			
			" RECLAIM_INFO.ReclaimDate as ReclaimDate,"+
			" getUserName(RECLAIM_INFO.InputUserID) as InputUserName, " +	
			" getOrgName(RECLAIM_INFO.InputOrgID) as InputOrgName ,"+			
			" RECLAIM_INFO.InputDate as InputDate"+
			" from RECLAIM_INFO,ASSET_INFO " +
			" where RECLAIM_INFO.OBJECTTYPE = '"+sObjectType+"' "+
			" and RECLAIM_INFO.objectno = '"+sObjectNo+"' "+
			" and ASSET_INFO.SerialNo = RECLAIM_INFO.ObjectNo "+
			" order by RECLAIM_INFO.InputDate desc";
   
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "RECLAIM_INFO";	
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 
	//设置不可见项
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo",false);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CashBackType,FormerCurrency,ReclaimCurrency,EnterAccountDate,ReclaimDate,InputUserName,InputDate","style={width:80px} ");  
	doTemp.setHTMLStyle("ReclaimSum,AssetName","style={width:100px} ");  
	doTemp.setUpdateable("CashBackType,FormerCurrency,ReclaimCurrency",false); 
	//设置对齐方式
	doTemp.setAlign("ReclaimSum","3");
	doTemp.setType("ReclaimSum","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("ReclaimSum","2");	
	//生成查询框
	doTemp.setColumnAttribute(",AssetNo,AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","新增","新增抵债资产收现记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看抵债资产收现详细信息","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除抵债资产收现信息","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACashBookInfo.jsp?ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACashBookInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right");
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
</script>
<%/*~END~*/%>


<%@include file="/IncludeEnd.jsp"%>
