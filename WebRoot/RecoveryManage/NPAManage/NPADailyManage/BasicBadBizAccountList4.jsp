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
	String PG_TITLE = "资金置换不良贷款台账"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
						{"Status","请选择"},
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

	sSql = " select '' as Status,SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,FirstPutOutDate,LastMaturity,LoanAccountNo,"+
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
		" where AccountType='040' and StateFlag='10' "+
		" and RecoverUserID='"+CurUser.UserID+"'"+
		" and RecoverOrgID='"+CurOrg.OrgID+"'";
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
	//设置html风格
	doTemp.setAlign("Status","2");
	doTemp.appendHTMLStyle("Status"," style={width:60px} ondblclick=\"javascript:parent.onDBClick()\" ");
	//设置行宽
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");

	//设置金额为三位一逗数字
	doTemp.setType("CleanInterest,OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest,ReformSBSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("CleanInterest,OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest,ReformSBSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("CleanInterest,OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,ReformUpSum,NotReformUpSum,PayDebtSum,CVSum,MetathesisSum,CleanInterest1,CleanInterest2,FinalBalance,FinalInterest,ReturnLawSum,ReturnLawInterest,ReformSBSum","3");
	
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWCode("IsFinish","YesNo");
	doTemp.setDDDWCode("AccountNeedManage","YesNo");
	doTemp.setDDDWCode("BasicNeedManage","YesNo");
	//doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
	//生成查询框
	doTemp.setColumnAttribute("NeedDun,VDMature,LdMature,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,AccountNeedManage,BasicNeedManage,IsFinish,NeedDun,VDMature,LdMature","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(20); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//汇总			
	String[][] sListSumHeaders = {	{"Sum1","报告期清收处置本金合计"},
									{"Sum2","报告期货币资金收回"},
									{"Sum3","报告期重组转回"},
									{"Sum4","报告期其他方式收回"},
									{"Sum5","报告期清收利息"},
									{"Sum6","期末结欠本金余额"},
									{"Sum7","期末结欠利息余额"},
		 };
	String sListSumSql = "Select "
						+"Sum(DisposeTotalSum) as Sum1,"
						+"Sum(MoneyReturnSum) as Sum2,"
						+"Sum(ReformSBSum) as Sum3,"
						+"Sum(OtherReturnSum) as Sum4,"
						+"Sum(CleanInterest) as Sum5,"
						+"Sum(FinalBalance) as Sum6,"
						+"Sum(FinalInterest) as Sum7 "
						+ " From BADBIZ_ACCOUNT "
						+ doTemp.WhereClause;
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);
					

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
		{"true","","Button","基本信息维护","基本信息维护","bAccount_Maintenance()",sResourcesPath},
		//{"true","","Button","退 回","退回","untread_Account()",sResourcesPath},
		{"true","","Button","催收登记","催收登记","dun_Note()",sResourcesPath},
		{"true","","Button","汇总","汇总","listSum()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","export_Excel()",sResourcesPath},
		};
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
	/*~[Describe=右击选择的台帐;InputParam=无;OutPutParam=无;]~*/
	function onDBClick()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus)=="undefined" || sStatus=="")
			setItemValue(0,getRow(),"Status","√");
		else
			setItemValue(0,getRow(),"Status","");

	}
	
	
	/*~[Describe=基本信息维护;InputParam=无;OutPutParam=无;]~*/
	function bAccount_Maintenance()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			popComp("BadBizAccountInfo","/RecoveryManage/AccountManage/BadBizAccountInfo.jsp","ComponentName=不良贷款台帐详情&SerialNo="+sSerialNo+"&StateFlag=<%=sStateFlag%>&AccountType=040&AccountEditFlag=02","","");
			reloadSelf();
		}
	}
	
	
	/*~[Describe=退回;InputParam=无;OutPutParam=无;]~*/
	function untread_Account()
	{
		if(!selectRecord()) return;	
		//需判定选择了多少条。把有的找出来
		var b = getRowCount(0);
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"Status");
			if(a == "√")
			{	
				sSerialNo = getItemValue(0,i,"SerialNo");
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverUserID@None@String@ReturnFlag@1,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			}
		}
		reloadSelf();
	}
	
	
	/*~[Describe=选择记录;InputParam=无;OutPutParam=无;]~*/
	function selectRecord()
	{
		var b = getRowCount(0);
		var iCount = 0;				
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"Status");
			if(a == "√")
				iCount = iCount + 1;
		}
		
		if(iCount == 0)
		{
			alert("请打√选择记录!");
			return false;
		}
		
		return true;
	}
	
	
	/*~[Describe=催收函管理;InputParam=无;OutPutParam=无;]~*/
	function dun_Note()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("DunList","/RecoveryManage/DunManage/DunList.jsp","ObjectType=BadBizAccount&ObjectNo="+sSerialNo,"_blank",OpenStyle);
			reloadSelf();
		}
	}
	
	
	/*~[Describe=导出Excel;InputParam=无;OutPutParam=无;]~*/
	function export_Excel()
	{
		amarExport("myiframe0");
	}
	
	
	/*~[Describe=金额汇总;InputParam=无;OutPutParam=无;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
	}
	</script>
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