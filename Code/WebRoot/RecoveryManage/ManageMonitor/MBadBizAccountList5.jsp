<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin1.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2010/05/25
*	Tester:
*	Describe: 抵债资产台账
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产台账监控"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
						{"SerialNo","流水号"},
						{"BelongOrgID","抵债资产所属机构"},
						{"BelongOrgName","抵债资产所属机构"},		
						{"AssetName","抵债资产名称"},
						{"GainDate","取得时间"},
						{"GainType","取得方式"},
						{"SitAddress","坐落（保管）地点"},
						{"AssetStatus","报告日抵债资产现状"},
						{"FormerManageName","原管理责任人"},
						{"AssetAna","土地性质"},
						{"AssetArea","土地面积(亩)"},
						{"PropertyFlag","是否有土地证"},
						{"GroundTransferFlag","土地是否过户"},
						{"ConstructionType","房产主体建筑结构"},
						{"HousePurpose","房产用途"},
						{"ConstructionArea","房产面积(平方米)"},
						{"PropertyFlag1","是否有房产证"},
						{"HouseTransferFlag","房产是否过户"},
						{"AssetType","抵债动产类别"},
						{"EffectsName","抵债动产名称、品牌"},
						{"AssetAmount","抵债动产实存数量"},
						{"ExistOrNewFLag","(存量/新增)初始类别"},
						{"InitializeBalance","抵债资产账面初始金额"},
						{"DisposeTotalSum","报告期抵债资产处置合计"},
						{"SaleSum","报告期抵债资产出售"},
						{"HireSum","报告期抵债资产出租"},
						{"OtherDisposeSum","报告期抵债资产其他方式处置"},
						{"LostSum","报告期抵债资产处置损失"},
						{"ReceiveSum","报告期抵债资产处置收现"},
						{"FinalAccountBalance","期末结存抵债资产账面余额"},
						{"FactValue","抵债资产估算实际价值"},
						{"CustomerName","抵债人名称"},
						{"CertType","抵债人证件类型"},
						{"CertTypeName","抵债人证件类型"},
						{"CertID","抵债人证件号码"},
						{"AccountManageDate","账务信息最后维护日期"},
						{"BasicManageDate","基本信息最后维护日期"},
						{"BadBizFinishDate","处置终结日期"},
						{"RecoverOrgID","现抵债资产管理机构"},
						{"RecoverOrgName","现抵债资产管理机构"},
						{"RecoverUserID","现抵债资产管理员"},
						{"RecoverUserName","现抵债资产管理员"},
						{"AccountNeedManage","账务信息是否待维护"},
						{"AccountNeedManageName","账务信息是否待维护"},
						{"BasicNeedManage","基本信息是否待维护"},
						{"BasicNeedManageName","基本信息是否待维护"},
						{"IsFinish","是否处置终结"},
						{"IsFinishName","是否处置终结"},
					}; 

	sSql = " select SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,"+
			" AssetName,GainDate,getItemName('PDAGainType',GainType) as GainType,SitAddress,"+
			" getItemName('BorrowerAssetStatus',AssetStatus) as AssetStatus,"+
			" FormerManageName,"+
			" getItemName('SoilProperty',AssetAna) as AssetAna,AssetArea,"+
			" getItemName('YesNo',PropertyFlag) as PropertyFlag,"+
			" getItemName('YesNo',GroundTransferFlag) as GroundTransferFlag,"+
			" getItemName('AssetAna',ConstructionType) as ConstructionType,"+
			" getItemName('HousePurpose',HousePurpose) as HousePurpose,ConstructionArea,"+
			" getItemName('YesNo',PropertyFlag1) as PropertyFlag1,"+
			" getItemName('YesNo',HouseTransferFlag) as HouseTransferFlag,"+
			" getItemName('PDAAssetType2',AssetType) as AssetType,EffectsName,AssetAmount,"+
			" getItemName('ExistNewType',ExistOrNewFLag) as ExistOrNewFLag,"+
			" InitializeBalance,DisposeTotalSum,"+
			" SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,"+
			" CustomerName,CertType,getItemName('CertType',CertType) as CertTypeName,CertID,"+
			" AccountManageDate,BasicManageDate,"+
			" BadBizFinishDate,RecoverOrgID,getOrgName(RecoverOrgID) as RecoverOrgName,"+
			" RecoverUserID,getUserName(RecoverUserID) as RecoverUserName,"+
			" CompareDate(AccountManageDate,30,'1','2','1') as AccountNeedManage,CompareDate(AccountManageDate,30,'是','否','是') as AccountNeedManageName,"+
			" CompareDate(BasicManageDate,90,'1','2','1') as BasicNeedManage,CompareDate(BasicManageDate,90,'是','否','是') as BasicNeedManageName, "+
			" IsFinish,getItemName('YesNo',IsFinish) as IsFinishName "+
		" from BADBIZ_ACCOUNT "+
		" where AccountType='050' and StateFlag='10' "+
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
	doTemp.setVisible("BelongOrgID,RelativeContractNo,LoanType,CertType,RecoverOrgID,RecoverUserID,IsFinish,AccountNeedManage,BasicNeedManage",false);
	doTemp.UpdateTable="BADBIZ_ACCOUNT";
	doTemp.setKey("SerialNo",true);	
    
	//设置行宽
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");

	//设置金额为三位一逗数字
	doTemp.setType("OtherReturnSum,AssetArea,ConstructionArea,SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("OtherReturnSum,AssetArea,ConstructionArea,SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","2");
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("OtherReturnSum,AssetArea,ConstructionArea,SaleSum,HireSum,OtherDisposeSum,LostSum,ReceiveSum,FinalAccountBalance,FactValue,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest","3");
	
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
	CurComp.setAttribute("SqlWhereClause1"," where AccountType='050' and StateFlag='10' ");
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
	}else if(CurUser.hasRole("2G1")||CurUser.hasRole("203"))//中心支行保全部经理；中心支行分管行长（不良资产处置委员会主任
	{
		sButtons[getBtnIdxByName(sButtons,"待审查业务申请")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"不良资产待指定管理人")][0]="true";
	}else if(CurUser.hasRole("0G1")||CurUser.hasRole("003"))//总行保全部总经理；总行分管行长（不良资产处置委员会主任）
	{
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
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=1&AccountType=050","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=超过90天未催收;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum2()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=2&AccountType=050","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=诉讼时效将到期;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum3()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=3&AccountType=050","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=担保时效将到期;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum4()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=4&AccountType=050","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=未登记台账;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum5()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=5&AccountType=050","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=未审查审批的业务申请;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum6()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=6&AccountType=050","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=未指定管理机构的不良贷款;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum7()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=7&AccountType=050","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=未指定管理人的不良贷款;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum8()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=8&AccountType=050","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	
	/*~[Describe=账务信息待维护;InputParam=无;OutPutParam=无;]~*/
	function BadBizListSum9()
	{
		popComp("BadBizSumList","/RecoveryManage/ManageMonitor/BadBizSumList.jsp","SumFlag=9&AccountType=050","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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