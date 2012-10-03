<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: 申请信息快速查询
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：申请信息快速查询
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "申请信息快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "";//--题头
	String sCustomerType =""; //客户类型 1为公司客户 2为同业客户 3为个人客户 4为信用共同体
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数
	sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType="";	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","申请流水号"},
							{"CustomerID","客户编号"},
							{"CustomerName","客户名称"},
							{"BusinessType","业务品种"},
							{"BusinessTypeName","业务品种"},
							{"OccurType","发生类型"},										
							{"OccurTypeName","发生类型"},
							{"PhaseName","当前阶段"},
							{"Currency","币种"},									
							{"BusinessSum","金额"},
							{"TermMonth","期限(月)"},
							{"VouchType","主要担保方式"},
							{"VouchTypeName","主要担保方式"},
							{"OperateOrgName","经办机构"},
							{"OperateUserName","经办人"},
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"FinancePlatformFlag","是否融资平台"}
							}; 
	if(sCustomerType.equalsIgnoreCase("1")){						
		sSql =	" select BA.SerialNo,BA.CustomerID,BA.CustomerName,BA.BusinessType,getBusinessName(BA.BusinessType) as BusinessTypeName, "+
				" BA.OccurType,getItemName('OccurType',BA.OccurType) as OccurTypeName,"+
				" FO.PhaseName,getItemName('Currency',BA.BusinessCurrency) as Currency,BA.BusinessSum,BA.TermMonth, " +
				" BA.VouchType, getItemName('VouchType',BA.VouchType) as VouchTypeName, " +
				" getOrgName(BA.OperateOrgID) as OperateOrgName, "+
				" getUserName(BA.OperateUserID) as OperateUserName, "+
				" getOrgName(BA.InputOrgID) as InputOrgName, "+
				" getUserName(BA.InputUserID) as InputUserName, "+
				" GETCustomerFPFlag(BA.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_APPLY BA ,FLOW_OBJECT FO ,BUSINESS_TYPE BT"+
				" where BA.SerialNo = FO.ObjectNo and FO.ObjectType='CreditApply' "+
				" and BT.TypeNo = BA.BusinessType and BT.Attribute1 = '1' and BA.BusinessType not in ('3060','3015') "+
				" and OperateOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("2")){
		sSql =	" select BA.SerialNo,BA.CustomerID,BA.CustomerName,BA.BusinessType,getBusinessName(BA.BusinessType) as BusinessTypeName, "+
				" BA.OccurType,getItemName('OccurType',BA.OccurType) as OccurTypeName,"+
				" FO.PhaseName,getItemName('Currency',BA.BusinessCurrency) as Currency,BA.BusinessSum,BA.TermMonth, " +
				" BA.VouchType, getItemName('VouchType',BA.VouchType) as VouchTypeName, " +
				" getOrgName(BA.OperateOrgID) as OperateOrgName, "+
				" getUserName(BA.OperateUserID) as OperateUserName, "+
				" getOrgName(BA.InputOrgID) as InputOrgName, "+
				" getUserName(BA.InputUserID) as InputUserName, "+
				" GETCustomerFPFlag(BA.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_APPLY BA ,FLOW_OBJECT FO"+
				" where BA.SerialNo = FO.ObjectNo and FO.ObjectType='CreditApply' "+
				" and BA.BusinessType = '3015' "+
				" and OperateOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("3")){
		sSql =	" select BA.SerialNo,BA.CustomerID,BA.CustomerName,BA.BusinessType,getBusinessName(BA.BusinessType) as BusinessTypeName, "+
				" BA.OccurType,getItemName('OccurType',BA.OccurType) as OccurTypeName,"+
				" FO.PhaseName,getItemName('Currency',BA.BusinessCurrency) as Currency,BA.BusinessSum,BA.TermMonth, " +
				" BA.VouchType, getItemName('VouchType',BA.VouchType) as VouchTypeName, " +
				" getOrgName(BA.OperateOrgID) as OperateOrgName, "+
				" getUserName(BA.OperateUserID) as OperateUserName, "+
				" getOrgName(BA.InputOrgID) as InputOrgName, "+
				" getUserName(BA.InputUserID) as InputUserName, "+
				" GETCustomerFPFlag(BA.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_APPLY BA ,FLOW_OBJECT FO ,BUSINESS_TYPE BT"+
				" where BA.SerialNo = FO.ObjectNo and FO.ObjectType='CreditApply' "+
				" and BT.TypeNo = BA.BusinessType and BT.Attribute1 = '2' "+
				" and OperateOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("4")){
		sSql =	" select BA.SerialNo,BA.CustomerID,BA.CustomerName,BA.BusinessType,getBusinessName(BA.BusinessType) as BusinessTypeName, "+
				" BA.OccurType,getItemName('OccurType',BA.OccurType) as OccurTypeName,"+
				" FO.PhaseName,getItemName('Currency',BA.BusinessCurrency) as Currency,BA.BusinessSum,BA.TermMonth, " +
				" BA.VouchType, getItemName('VouchType',BA.VouchType) as VouchTypeName, " +
				" getOrgName(BA.OperateOrgID) as OperateOrgName, "+
				" getUserName(BA.OperateUserID) as OperateUserName, "+
				" getOrgName(BA.InputOrgID) as InputOrgName, "+
				" getUserName(BA.InputUserID) as InputUserName, "+
				" GETCustomerFPFlag(BA.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_APPLY BA ,FLOW_OBJECT FO ,BUSINESS_TYPE BT "+
				" where BA.SerialNo = FO.ObjectNo and FO.ObjectType='CreditApply' "+
				" and BT.TypeNo = BA.BusinessType and BT.Attribute1 = '1' and BA.BusinessType = '3060' "+
				" and OperateOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("BA.SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_APPLY";	
	//设置关键字
	doTemp.setKey("SerialNo",true);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("TermMonth,BusinessRate","style={width:60px} ");  	
	doTemp.setHTMLStyle("OperateOrgName,InputOrgName","style={width:250px} "); 	
	//设置对齐方式
	doTemp.setAlign("BusinessSum,TermMonth,BusinessRate","3");
	doTemp.setType("BusinessSum,BusinessRate","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum","2");
	doTemp.setCheckFormat("TermMonth","5");
	doTemp.setVisible("VouchType,BusinessType,FinancePlatformFlag,OccurType",false);
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWCode("FinancePlatformFlag","YesNo");
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%1%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}else if("3".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%2%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}
	doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' ");

	//生成查询框
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","BusinessType","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","TermMonth","Operators=BetweenNumber;DOFilterHtmlTemplate=Number");
	doTemp.setFilter(Sqlca,"6","OperateOrgName","");
	doTemp.setFilter(Sqlca,"7","OperateUserName","");
	doTemp.setFilter(Sqlca,"8","PhaseName","");
	doTemp.setFilter(Sqlca,"9","VouchType","");	
	if("1".equalsIgnoreCase(sCustomerType)){
	    doTemp.setFilter(Sqlca,"10","FinancePlatformFlag","Operators=EqualsString;");	
	}
	doTemp.setFilter(Sqlca,"11","OccurType","");
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
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
		{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","查看意见详情","查看意见详情","viewOpinions()",sResourcesPath},
		{"true","","Button","查看调查报告","查看调查报告","viewReport()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
	};
	if(CurUser.hasRole("095")||CurUser.hasRole("0A2")||CurUser.hasRole("0B5")||CurUser.hasRole("0C2")||
	 CurUser.hasRole("0D2")||CurUser.hasRole("0E9")||CurUser.hasRole("0F4")||CurUser.hasRole("0H5")||
	 CurUser.hasRole("0I4")||CurUser.hasRole("0J1")||CurUser.hasRole("282")||CurUser.hasRole("295")||
	 CurUser.hasRole("2A4")||CurUser.hasRole("2B9")||CurUser.hasRole("2C2")||CurUser.hasRole("2D4")||
	 CurUser.hasRole("2E4")||CurUser.hasRole("2G5")||CurUser.hasRole("2H5")||CurUser.hasRole("2I2")||
	 CurUser.hasRole("421")||CurUser.hasRole("495"))
	{
		sButtons[3][0] = "false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			openObject("CreditApply",sSerialNo,"002");
		}
	}	
    
    /*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	    popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","ObjectType=CreditApply&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*~[Describe=查看调查报告;InputParam=无;OutPutParam=无;]~*/
	function viewReport()
	{
		sObjectType = "CreditApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert("调查报告还未填写，请先填写调查报告再查看！");
			return;
		}
		
		sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
		if (sReturn == "false")
		{
			alert("调查报告还未生成，请先生成调查报告再查看！");
			return;  
		}
		
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
		OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
    }
    
    /*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
