<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin1.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2010/05/25
*	Tester:
*	Describe: 资金置换不良贷款台账
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "资金置换不良贷款台账监控"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%
	//定义变量	    
	String sSql = "";
	//定义变量：SQL语句,查询结果集,机构直属、区县标志
	//获得组件参数:树图节点,不良资产台账状态
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";
	String sStateFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("StateFlag"));
	if(sStateFlag == null) sStateFlag="";
	//获得页面参数
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义标题
	String sHeaders[][] = {
						{"SerialNo","台帐流水号"},
						{"BelongOrgID","不良资产所属机构"},
						{"BelongOrgName","不良资产所属机构"},
						{"FirstPutOutDate","首次发放日"},
						{"LastMaturity","最后到期日"},
						{"loanAccountNo","贷款帐号"},
						{"LoanType","贷款方式"},
						{"CustomerName","借款人名称"},
						{"CustomerType","借款人类别"},
						{"CustomerTypeName","借款人类别"},
						{"CustomerProperty","借款人性质"},
						{"CustomerManageStatus","借款人经营状况"},
						{"AssetStatus","借款人资产状况"},
						{"CustomerAttitude","借款人态度"},
						{"DebtInstance","债务落实情况"},
						{"FactVouchDegree","实际担保程度"},
						{"VouchEffectDate","担保时效"},
						{"LawEffectDate","诉讼时效"},
						{"TextDocStatus","文本档案情况"},
						{"FormerManageName","原管理责任人"},
						{"MetathesisType","置换资金类别"},
						{"InitializeBalance","资金置换不良贷款本金期初余额"},
						{"ClassifyResult","风险分类初始情况"},
						{"DisposeTotalSum","报告期清收处置本金合计"},
						{"MoneyReturnSum","报告期货币资金收回"},
						{"ReformSBSum","报告期重组转回"},
						{"OtherReturnSum","报告期其他方式收回"},
						{"CleanInterest","报告期清收利息"},
						{"FinalBalance","期末结欠本金余额"},
						{"FinalInterest","期末结欠利息余额"},
						{"FactUser","实际用款人"},
						{"CertType","借款人证件类型"},
						{"CertTypeName","借款人证件类型"},
						{"CertID","借款人证件号码"},
						{"VouchMaturity","担保到期日"},
						{"LastDunDate","最后催收日期"},
						{"AccountManageDate","账务信息最后维护日期"},
						{"BasicManageDate","基本信息最后维护日期"},
						{"BadBizFinishDate","终结日期"},
						{"RecoverOrgID","现不良资产管理机构"},
						{"RecoverOrgName","现不良资产管理机构"},
						{"RecoverUserID","现不良资产管理员"},
						{"RecoverUserName","现不良资产管理员"},
						{"IsFinish","是否终结"},
						{"IsFinishName","是否终结"},
						{"AccountNeedManage","账务信息是否待维护"},
						{"AccountNeedManageName","账务信息是否待维护"},
						{"BasicNeedManage","基本信息是否待维护"},
						{"BasicNeedManageName","基本信息是否待维护"},
						{"NeedDun","是否待催收贷款"},
						{"VDMature","诉讼时效是否到期"},
						{"LdMature","担保时效是否到期"},
					}; 

	sSql = " select SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,FirstPutOutDate,LastMaturity,LoanAccountNo,"+
			" getItemName('VouchType2',LoanType) as LoanType,CustomerName,"+
			" getItemName('CustomerType1',CustomerType) as CustomerTypeName,"+
			" getItemName('BorrowerType',CustomerProperty) as CustomerProperty,"+
			" getItemName('BorrowerManageStatus',CustomerManageStatus) as CustomerManageStatus,"+
			" getItemName('BorrowerAssetStatus',AssetStatus) as AssetStatus,"+
			" getItemName('BorrowerAttitude',CustomerAttitude) as CustomerAttitude,"+
			" getItemName('DebtInstance',DebtInstance) as DebtInstance,"+
			" getItemName('FactVouchDegree',FactVouchDegree) as FactVouchDegree,"+
			" CompareDate(VouchMaturity,0,'','有效') as VouchEffectDate,"+
			" CompareDate(LastMaturity,600,'','有效') as LawEffectDate,"+
			" getItemName('TextDocStatus',TextDocStatus) as TextDocStatus,"+
			" getItemName('MetathesisType',MetathesisType) as MetathesisType,FormerManageName,InitializeBalance,"+
			" getItemName('ClassifyResult1',ClassifyResult) as ClassifyResult,DisposeTotalSum,"+
			" MoneyReturnSum,ReformSBSum,"+
			" OtherReturnSum,CleanInterest,"+
			" FinalBalance,FinalInterest,FactUser,"+
			" CertType,getItemName('CertType',CertType) as CertTypeName,CertID,"+
			" VouchMaturity,LastDunDate,AccountManageDate,BasicManageDate,"+
			" BadBizFinishDate,RecoverOrgID,getOrgName(RecoverOrgID) as RecoverOrgName,"+
			" RecoverUserID,getUserName(RecoverUserID) as RecoverUserName,"+
			" IsFinish,getItemName('YesNo',IsFinish) as IsFinishName,"+
			" CompareDate(AccountManageDate,30,'1','2','1') as AccountNeedManage,CompareDate(AccountManageDate,30,'是','否','是') as AccountNeedManageName,"+
			" CompareDate(BasicManageDate,90,'1','2','1') as BasicNeedManage,CompareDate(BasicManageDate,90,'是','否','是') as BasicNeedManageName,"+
			" case when LastDunDate is null then CompareDate(LastMaturity,90,'是','否') else CompareDate(LastDunDate,90,'是','否') end as NeedDun,"+
			" case when LastDunDate is null then CompareDate(LastMaturity,600,'是','否') else CompareDate(LastDunDate,600,'是','否') end as VDMature," +
			" CompareDate(VouchMaturity,600,'是','否') as LdMature "+
		" from BADBIZ_ACCOUNT "+
		" where AccountType='040'  and StateFlag='10' "+
	    " and BelongOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	//根据树图取不同结果集	 
	/*
		StateFlag 台账阶段:
					01:未登记
					10:已登记
					03:已取消
					80:已终结		
	*/
	
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("BelongOrgID,RelativeContractNo,CertType,RecoverOrgID,RecoverUserID,IsFinish,AccountNeedManage,BasicNeedManage",false);
	doTemp.UpdateTable="BADBIZ_ACCOUNT";
	doTemp.setKey("SerialNo",true);	
    
	//设置行宽
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");

	//设置金额为三位一逗数字
	doTemp.setType("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest,ReformSBSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest,ReformSBSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest,ReformSBSum","3");
	
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWCode("IsFinish","YesNo");
	doTemp.setDDDWCode("AccountNeedManage","YesNo");
	doTemp.setDDDWCode("BasicNeedManage","YesNo");
	//doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
	//生成查询框
		doTemp.setColumnAttribute("RecoverUserName,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,AccountNeedManage,BasicNeedManage,IsFinish,NeedDun,VDMature,LdMature","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(20); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
	CurComp.setAttribute("SqlWhereClause",doTemp.WhereClause);
	CurComp.setAttribute("SqlWhereClause1"," where AccountType='040' and StateFlag='10' ");
	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
	{"true","","Button","台账基本信息待维护","台账基本信息待维护","BadBizListSum1()",sResourcesPath},
	{"true","","Button","账务信息待维护","账务信息待维护","BadBizListSum9()",sResourcesPath},
	{"false","","Button","不良贷款待催收","不良贷款待催收","BadBizListSum2()",sResourcesPath},
	{"false","","Button","诉讼时效将到期","诉讼时效将到期","BadBizListSum3()",sResourcesPath},
	{"false","","Button","担保时效将到期","担保时效将到期","BadBizListSum4()",sResourcesPath},
	{"true","","Button","台账待登记","台账待登记","BadBizListSum5()",sResourcesPath},
	{"false","","Button","待审查业务申请","待审查业务申请","BadBizListSum6()",sResourcesPath},
	{"false","","Button","不良资产待指定管理机构","不良资产待指定管理机构","BadBizListSum7()",sResourcesPath},
	{"false","","Button","不良资产待指定管理人","不良资产待指定管理人","BadBizListSum8()",sResourcesPath},
	};
	//根据不同树图显示按钮
	if(CurUser.hasRole("410"))//支行行长
	{
		sButtons[getBtnIdxByName(sButtons,"不良贷款待催收")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"诉讼时效将到期")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"担保时效将到期")][0]="true";
	}else if(CurUser.hasRole("2G1")||CurUser.hasRole("203"))//中心支行保全部经理；中心支行分管行长（不良资产处置委员会主任
	{
		sButtons[getBtnIdxByName(sButtons,"不良贷款待催收")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"诉讼时效将到期")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"担保时效将到期")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"待审查业务申请")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"不良资产待指定管理人")][0]="true";
	}else if(CurUser.hasRole("0G1")||CurUser.hasRole("003"))//总行保全部总经理；总行分管行长（不良资产处置委员会主任）
	{
		sButtons[getBtnIdxByName(sButtons,"不良贷款待催收")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"诉讼时效将到期")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"担保时效将到期")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"待审查业务申请")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"不良资产待指定管理机构")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"不良资产待指定管理人")][0]="true";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=超过90天未维护台账;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum1()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=1&AccountType=040","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=超过90天未催收;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum2()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=2&AccountType=040","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=诉讼时效将到期;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum3()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=3&AccountType=040","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=担保时效将到期;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum4()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=4&AccountType=040","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=未登记台账;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum5()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=5&AccountType=040","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=未审查审批的业务申请;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum6()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=6&AccountType=040","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=未指定管理机构的不良贷款;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum7()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=7&AccountType=040","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=未指定管理人的不良贷款;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum8()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=8&AccountType=040","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=账务信息待维护;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum9()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=9&AccountType=040","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=导出Excel;InputParam=无;OutPutParam=无;]~*/
	function export_Excel()
	{
		amarExport("myiframe0");
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