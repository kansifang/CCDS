<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: pliu 2011/06/22
		Tester:
		Describe: 打印审批意见
		Input Param:	
			
		Output Param:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "打印审批意见列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
							{"PhaseName","当前阶段"},
							{"Currency","币种"},									
							{"BusinessSum","金额"},
							{"TermMonth","期限(月)"},
							{"DirectionName","行业投向"},
							{"VouchType","主要担保方式"},
							{"VouchTypeName","主要担保方式"},
							{"OperateOrgName","经办机构"},
							{"OperateUserName","经办人"},
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"FinancePlatformFlag","是否融资平台"}
							}; 
						
		sSql =	" select BA.SerialNo,BA.CustomerID,BA.CustomerName,BA.BusinessType,getBusinessName(BA.BusinessType) as BusinessTypeName, "+
		" FO.PhaseName,getItemName('Currency',BA.BusinessCurrency) as Currency,BA.BusinessSum,BA.TermMonth, " +
		" getItemName('IndustryType',BA.Direction) as DirectionName, "+
		" BA.VouchType, getItemName('VouchType',BA.VouchType) as VouchTypeName, " +
		" getOrgName(BA.OperateOrgID) as OperateOrgName, "+
		" getUserName(BA.OperateUserID) as OperateUserName, "+
		" getOrgName(BA.InputOrgID) as InputOrgName, "+
		" FO.ObjectType,FO.PhaseNo,FO.FlowNo,"+
		" getUserName(BA.InputUserID) as InputUserName, "+
		" GETCustomerFPFlag(BA.CustomerID) as FinancePlatformFlag "+
		" from BUSINESS_APPLY BA ,FLOW_OBJECT FO ,BUSINESS_TYPE BT"+
		" where BA.SerialNo = FO.ObjectNo and FO.ObjectType='CreditApply' "+
		" and BT.TypeNo = BA.BusinessType  "+
		" and FO.PhaseNo<>'0010' "+
		" and BA.OperateOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	

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
	doTemp.setVisible("VouchType,BusinessType,FinancePlatformFlag,ObjectType,PhaseNo,FlowNo",false);
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWCode("FinancePlatformFlag","YesNo");
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%1%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}else if("3".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%2%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}
	

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
		{"true","","Button","查看审批意见","查看审批意见","viewOpinions()",sResourcesPath}
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------


	/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","IsPrintFlag=true&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
