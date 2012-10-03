<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  xhyong 2012/05/28
		Tester:
		Content: 公司类客户表内授信台账
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：
					Flag:
						030:未结清授信业务
						040:已结清授信业务
						050:零本金挂息授信业务
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "公司类客户表内授信台账"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql
	String sComponentName = "";//--组件名称
	String sFlag = "";//标识
	String PG_CONTENT_TITLE = "";//--题头
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数
	sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));	//获得页面参数
	if(sFlag==null) sFlag = "";
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 
							{"OperateOrgName","出账机构"},
							{"SerialNo","借据编号"},
							{"CustomerID","客户编号"},
							{"CustomerName","客户名称"},
							{"CorpID","客户证件号码"},
							{"RegisterAdd","客户注册地址"},
							{"IndustryTypeName","客户所属行业"},
							{"OrgNature","客户机构类型"},
							{"ScopeName","企业规模"},
							{"CreditLevel","客户信用等级"},
							{"ECGroupFlagName","是否集团客户"},
							{"DirectionName","贷款行业投向"},
							{"AgriLoanClassifyName","涉农贷款分类"},
							{"AgriLoanFlag","是否涉农"},
							{"AgriLoanFlagName","是否涉农"},
							{"OccurType","发生类型"},
							{"OccurTypeName","发生类型"},
							{"BusinessTypeName","业务品种"},
							{"BusinessType","业务品种"},
							{"ActualBusinessRate","执行利率（‰）"},
							{"RateFloatTypeName","利率浮动方式"},
							{"RateFloat","利率浮动值"},
							{"VouchTypeName","主要担保方式"},
							{"VouchType","主要担保方式"},
							{"BCBusinessSum","合同金额"},
							{"BCPutOutDate","合同起始日期"},
							{"BCMaturity","合同到期日期"},
							{"BusinessSum","借据金额"},
							{"Balance","借据余额"},
							{"PutOutdate","借据起始日期"},
							{"Maturity","借据到期日期"},
							{"SubjectNo","会计科目"},
							{"OverDueDays","逾期天数"},
							{"Interestbalance1","表内欠息"},
							{"Interestbalance2","表外欠息"},
							{"ClassifyResult","当前风险分类结果（账面）"},
							{"ClassifyResultName","当前风险分类结果（账面）"},
							{"BaseClassifyResult","当前风险分类结果（实际）"},
							{"BaseClassifyResultName","当前风险分类结果（实际）"},
							{"ManageUserName","管户人"},
							{"ManageOrgName","管户机构"},
							{"MFOrgName","记账单位"}
							}; 					
	sSql =	"select "+
				"BD.SerialNo,"+
				"BC.CustomerID,BC.CustomerName,EI.CorpID,EI.RegisterAdd, "+
				"getItemName('IndustryType',EI.IndustryType) as IndustryTypeName,"+
				"getItemName('CustomerType',EI.OrgNature) as OrgNature,"+
				"getItemName('Scope',EI.Scope) as ScopeName,"+
				"EI.CreditLevel,"+
				"getItemName('YesNo',EI.ECGroupFlag) as ECGroupFlagName,"+
				"getItemName('IndustryType',BC.Direction) as DirectionName,"+
				"getItemName('AgriLoanClassify1',BC.AgriLoanClassify) as AgriLoanClassifyName,"+
				"BC.AgriLoanFlag,getItemName('YesNo',BC.AgriLoanFlag) as AgriLoanFlagName,"+
				"BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
				"BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
				"BD.ActualBusinessRate,"+
				"getItemName('RateFloatType',BC.RateFloatType) as RateFloatTypeName,"+
				"BC.RateFloat,"+
				"BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
				"BC.BusinessSum as BCBusinessSum,"+
				"BC.PutOutdate as BCPutoutDate,BC.Maturity as BCMaturity,"+
				"BD.BusinessSum,BD.Balance,"+
				"BD.PutOutdate,BD.Maturity,"+
				"BD.SubjectNo,BD.OverDueDays,"+
				"BD.Interestbalance1,BD.Interestbalance2,"+
				"BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				"BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName,"+
				"getUserName(BC.ManageUserID) as ManageUserName,"+
				"getOrgName(BC.ManageOrgID) as ManageOrgName,"+
				"getOrgName(BD.MFOrgID) as MFOrgName, "+
				"getOrgName(BD.MFOrgID) as OperateOrgName "+
			" from ENT_INFO EI ,BUSINESS_DUEBILL BD,BUSINESS_CONTRACT BC"+
			" where EI.CustomerID=BC.CustomerID and BC.SerialNo=BD.RelativeSerialNo2 "+
				" and BC.BusinessType like '1%'"+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	
	if("030".equals(sFlag))//未结清
	{
		sSql = sSql+" and  BD.Balance>0 and (BD.FinishDate is null or BD.FinishDate ='') ";
	}else if("040".equals(sFlag))//已结清
	{
		sSql = sSql+" and BD.FinishDate is not null and BD.FinishDate !=''";
	}else if("050".equals(sFlag))//零本金挂息
	{
		sSql = sSql+" and  nvl(BD.Balance,0)=0 and (BD.FinishDate is null or BD.FinishDate ='')";
	}
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("EI.CustomerID");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置关键字
	//doTemp.setKey("SerialNo",true);	
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("ManageOrgName,MFOrgName,OperateOrgName","style={width:250px} ");  
	doTemp.setHTMLStyle("BCMaturity,ClassifyResultName,BaseClassifyResultName","style={width:50px} ");
	//设置对齐方式
	doTemp.setAlign("OverDueDays,ActualBusinessRate,RateFloat,BCBusinessSum,BusinessSum,Balance,Interestbalance1,Interestbalance2","3");
	doTemp.setVisible("AgriLoanFlag,AgriLoanClassifyName,OccurType,VouchType,BaseClassifyResult,ClassifyResult,BusinessType",false);
	//小数为2，整数为5
	doTemp.setCheckFormat("ActualBusinessRate,RateFloat,BCBusinessSum,BusinessSum,Balance,Interestbalance1,Interestbalance2","2");
	doTemp.setCheckFormat("OverDueDays","5");
	doTemp.setType("ActualBusinessRate,RateFloat,BCBusinessSum,BusinessSum,Balance,Interestbalance1,Interestbalance2","Number");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and Length(ItemNo)>3");
	doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' ");
	doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%1%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)>2");	
	doTemp.setDDDWCode("AgriLoanFlag","YesNo");
	//生成查询框
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","CorpID","");
	doTemp.setFilter(Sqlca,"4","OccurType","");
	doTemp.setFilter(Sqlca,"5","BusinessType","");
	doTemp.setFilter(Sqlca,"6","DirectionName","");
	doTemp.setFilter(Sqlca,"7","ScopeName","");
	doTemp.setFilter(Sqlca,"8","AgriLoanFlag","");
	doTemp.setFilter(Sqlca,"9","BusinessSum","");
	doTemp.setFilter(Sqlca,"10","Balance","");
	doTemp.setFilter(Sqlca,"11","PutOutdate","");
	doTemp.setFilter(Sqlca,"12","Maturity","");
	doTemp.setFilter(Sqlca,"13","ClassifyResult","");
	doTemp.setFilter(Sqlca,"14","BaseClassifyResult","");
	doTemp.setFilter(Sqlca,"15","VouchType","");
	doTemp.setFilter(Sqlca,"16","ManageUserName","");
	doTemp.setFilter(Sqlca,"17","ManageOrgName","");
	doTemp.setFilter(Sqlca,"18","MFOrgName","");
	doTemp.setFilter(Sqlca,"19","OperateOrgName","");
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
			{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
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