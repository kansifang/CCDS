<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin1.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2010/05/25
*	Tester:
*	Describe: 已核销不良贷款台账
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "已核销不良贷款台账"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
						{"ReturnFlag","是否退回"},
						{"ReturnFlagName","是否退回"},
						{"OrgChangeFlag","是否机构变更"},
						{"OrgChangeFlagName","是否机构变更"},
						{"UserChangeFlag","是否管理人变更"},
						{"UserChangeFlagName","是否管理人变更"},
						{"SerialNo","台帐流水号"},
						{"BelongOrgID","不良资产所属机构"},
						{"BelongOrgName","不良资产所属机构"},
						{"CustomerName","借款人名称"},
						{"CustomerManageStatus","担保人经营现状"},
						{"AssetStatus","担保人资产现状"},
						{"FirstPutOutDate","首次发放时间"},
						{"LastMaturity","最后到期日"},
						{"CVDate","核销时间"},
						{"CVReason","核销理由"},
						{"TextDocStatus","文本档案情况"},
						{"LawEffectDate","诉讼时效"},
						{"VouchEffectDate","担保时效"},
						{"CVBadDebtType","已核销呆账类别"},
						{"FormerManageName","原管理责任人"},
						{"CVSource","核销资金来源"},
						{"ExistOrNewFLag","(存量/新增)初始类别"},
						{"InitializeBalance","已核销呆账本金"},
						{"DisposeTotalSum","报告期收回已核销呆账本金合计"},
						{"MoneyReturnSum","报告期货币资金收回"},
						{"OtherReturnSum","报告期其他方式收回"},
						{"FinalBalance","期末已核销呆账本金余额"},
						{"CleanInterest","报告期收回已核销呆账利息"},
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

	sSql = " select '' as Status,ReturnFlag,getItemName('YesNo',ReturnFlag) as ReturnFlagName,"+
				" OrgChangeFlag,getItemName('YesNo',OrgChangeFlag) as OrgChangeFlagName,"+
				" UserChangeFlag,getItemName('YesNo',UserChangeFlag) as UserChangeFlagName,"+
				" SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,FirstPutOutDate,LastMaturity,"+
				" CVDate,getItemName('CAVReason',CVReason) as CVReason,CustomerName,"+
				" getItemName('BorrowerManageStatus',CustomerManageStatus) as CustomerManageStatus,"+
				" getItemName('BorrowerAssetStatus',AssetStatus) as AssetStatus,"+
				" getItemName('AlreadyCAVType',CVBadDebtType) as CVBadDebtType,"+
				" FormerManageName,getItemName('FundSource',CVSource) as CVSource,"+
				" getItemName('ExistNewType',ExistOrNewFLag) as ExistOrNewFLag,"+
				" getItemName('TextDocStatus',TextDocStatus) as TextDocStatus,"+
				" CompareDate(VouchMaturity,0,'','有效') as VouchEffectDate,"+
				" CompareDate(LastMaturity,600,'','有效') as LawEffectDate,"+
				" InitializeBalance,"+
				" DisposeTotalSum,"+
				" MoneyReturnSum,"+
				" OtherReturnSum,"+
				" FinalBalance,CleanInterest,FactUser,"+
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
		    " where AccountType='030' and StateFlag='"+sStateFlag+"' ";
		   
	//根据树图取不同结果集	 
	/*
		StateFlag 台账阶段:
					01:未登记
					10:已登记
					03:已取消
					80:已终结		
	*/
	if(sDealType.substring(0,3).equals("110"))//指定不良资产管理机构
	{
		sSql +=" and (RecoverOrgID is null or RecoverOrgID='')  and BelongOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}else if(sDealType.substring(0,3).equals("120"))//不良资产管理机构变更
	{
		sSql +=" and RecoverOrgID is not null and RecoverOrgID!='' ";
	}else if(sDealType.substring(0,3).equals("130"))//指定不良资产管理人
	{
		sSql +=" and RecoverOrgID ='"+CurOrg.OrgID+"' and (RecoverUserID is null or RecoverUserID='') ";
	}else if(sDealType.substring(0,3).equals("140"))//不良资产管理人变更
	{
		sSql +=" and RecoverOrgID ='"+CurOrg.OrgID+"'"+
				" and RecoverUserID is not null and  RecoverUserID!='' ";
	}else if(sDealType.substring(0,3).equals("150"))//不良资产转出
	{
		sSql +=" and RecoverOrgID ='"+CurOrg.OrgID+"'"+
		" and RecoverUserID is not null and  RecoverUserID!='' ";
	}
	
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("OrgChangeFlagName,UserChangeFlagName,ReturnFlagName,OrgChangeFlag,UserChangeFlag,ReturnFlag,BelongOrgID,RelativeContractNo,CertType,RecoverOrgID,RecoverUserID,IsFinish,AccountNeedManage,BasicNeedManage",false);
	if(sDealType.substring(0,3).equals("110"))//指定不良资产管理机构
	{
		 doTemp.setVisible("ReturnFlagName",true);
	}else if(sDealType.substring(0,3).equals("120"))//不良资产管理机构变更
	{
		 doTemp.setVisible("OrgChangeFlagName",true);
	}else if(sDealType.substring(0,3).equals("130"))//指定不良资产管理人
	{
		 doTemp.setVisible("ReturnFlagName",true);
	}else if(sDealType.substring(0,3).equals("140"))//不良资产管理人变更
	{
		doTemp.setVisible("UserChangeFlagName",true);
	}
	doTemp.UpdateTable="BADBIZ_ACCOUNT";
	doTemp.setKey("SerialNo",true);	
	//设置html风格
	doTemp.setAlign("Status","2");
	doTemp.appendHTMLStyle("Status"," style={width:60px} ondblclick=\"javascript:parent.onDBClick()\" ");
	//设置行宽
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");
	doTemp.setHTMLStyle("OrgChangeFlagName,UserChangeFlagName,ReturnFlag,ReturnFlagName,OrgChangeFlag,UserChangeFlag"," style={width:80px} ");
	
	//设置金额为三位一逗数字
	doTemp.setType("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,FinalBalance,CleanInterest","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,FinalBalance,CleanInterest","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("OtherReturnSum,InitializeBalance,DisposeTotalSum,MoneyReturnSum,FinalBalance,CleanInterest","3");
	
	doTemp.setDDDWCode("CertType","CertType");
	doTemp.setDDDWCode("IsFinish","YesNo");
	doTemp.setDDDWCode("AccountNeedManage","YesNo");
	doTemp.setDDDWCode("BasicNeedManage","YesNo");
	doTemp.setDDDWCode("ReturnFlag","YesNo");
	doTemp.setDDDWCode("OrgChangeFlag","YesNo");
	doTemp.setDDDWCode("UserChangeFlag","YesNo");
	//doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
	//生成查询框
	if(sDealType.substring(0,3).equals("110"))//指定不良资产管理机构
	{
		doTemp.setColumnAttribute("ReturnFlag,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID","IsFilter","1");
	}else if(sDealType.substring(0,3).equals("120"))//不良资产管理机构变更
	{
		doTemp.setColumnAttribute("OrgChangeFlag,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,RecoverOrgName","IsFilter","1");
	}else if(sDealType.substring(0,3).equals("130"))//指定不良资产管理人
	{
		doTemp.setColumnAttribute("ReturnFlag,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID","IsFilter","1");
	}else if(sDealType.substring(0,3).equals("140"))//不良资产管理人变更
	{
		doTemp.setColumnAttribute("UserChangeFlag,BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,RecoverOrgName,RecoverUserName","IsFilter","1");
	}else if(sDealType.substring(0,3).equals("150"))//不良资产转出
	{
		doTemp.setColumnAttribute("BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FinalBalance,FinalInterest,RecoverOrgName,RecoverUserName","IsFilter","1");
	}else{
		doTemp.setColumnAttribute("SerialNo","IsFilter","1");
	}
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
	String[][] sListSumHeaders = {	{"Sum1","已核销呆账本金"},
									{"Sum2","报告期收回已核销呆账本金合计"},
									{"Sum3","报告期货币资金收回"},
									{"Sum4","报告期其他方式收回"},
									{"Sum5","期末已核销呆账本金余额"},
									{"Sum6","报告期收回已核销呆账利息"},
		 };
	String sListSumSql = "Select sum(InitializeBalance) as Sum1,"
						+"Sum(DisposeTotalSum) as Sum2,"
						+"Sum(MoneyReturnSum) as Sum3,"
						+"Sum(OtherReturnSum) as Sum4,"
						+"Sum(FinalBalance) as Sum5,"
						+"Sum(CleanInterest) as Sum6 "
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
		{"false","","Button","责任认定详情","责任认定详情","dutyCogn_Info()",sResourcesPath},
		{"false","","Button","风险认定详情","风险认定详情","classify_Info()",sResourcesPath},
		{"true","","Button","台账详情","台账详情","account_Info()",sResourcesPath},
		{"false","","Button","指定管理机构","指定管理机构","designate_Org()",sResourcesPath},
		{"false","","Button","指定管理人","指定管理人","designate_User()",sResourcesPath},
		{"false","","Button","变更管理机构","变更管理机构","org_Change()",sResourcesPath},
		{"false","","Button","变更管理人","变更管理人","user_Change()",sResourcesPath},
		{"false","","Button","查看管理机构变更记录","查看管理机构变更记录","view_OrgChange()",sResourcesPath},
		{"false","","Button","查看管理人变更记录","查看管理人变更记录","view_UserChange()",sResourcesPath},
		{"false","","Button","退 回","退回","untread_Account()",sResourcesPath},
		{"false","","Button","转 出","转出","transfer_Out()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","export_Excel()",sResourcesPath},
		{"true","","Button","汇总","汇总","listSum()",sResourcesPath},
		};
	//根据不同树图显示按钮
	if(sDealType.substring(0,3).equals("110"))//指定不良资产管理机构
	{
		sButtons[getBtnIdxByName(sButtons,"指定管理机构")][0]="true";
	}else if(sDealType.substring(0,3).equals("120"))//不良资产管理机构变更
	{
		sButtons[getBtnIdxByName(sButtons,"变更管理机构")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"查看管理机构变更记录")][0]="true";
	}else if(sDealType.substring(0,3).equals("130"))//指定不良资产管理人
	{
		sButtons[getBtnIdxByName(sButtons,"指定管理人")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"退 回")][0]="true";
	}else if(sDealType.substring(0,3).equals("140"))//不良资产管理人变更
	{
		sButtons[getBtnIdxByName(sButtons,"变更管理人")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"查看管理人变更记录")][0]="true";
	}else if(sDealType.substring(0,3).equals("150"))//不良资产转出
	{
		sButtons[getBtnIdxByName(sButtons,"转 出")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"退 回")][0]="true";
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
	/*~[Describe=右击选择需指定机构的台帐;InputParam=无;OutPutParam=无;]~*/
	function onDBClick()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus)=="undefined" || sStatus=="")
			setItemValue(0,getRow(),"Status","√");
		else
			setItemValue(0,getRow(),"Status","");

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
	
	
	/*~[Describe=责任认定;InputParam=无;OutPutParam=无;]~*/
	function dutyCogn_Info()
	{
		sLoanAccountNo = getItemValue(0,getRow(),"LoanAccountNo");		
		if (typeof(sLoanAccountNo)=="undefined" || sLoanAccountNo.length==0)
		{
			alert("无责任认定信息!");
		}else
		{	
			sRelativeContactNo = sLoanAccountNo;
			sCompID = "NPAssetDutyList";
			sCompURL = "/CreditManage/CreditPutOut/NPADutyList.jsp";
			sParamString = "EditRight=2&ObjectType=BusinessContract&ObjectNo="+sRelativeContactNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	
	/*~[Describe=风险分类详情;InputParam=无;OutPutParam=无;]~*/
	function classify_Info()
	{
		sLoanAccountNo = getItemValue(0,getRow(),"LoanAccountNo");		
		if (typeof(sLoanAccountNo)=="undefined" || sLoanAccountNo.length==0)
		{
			alert("无风险认定信息");
		}else
		{
			sRelativeContactNo = sLoanAccountNo;
			sCompID = "ClassifyHistoryList";
			sCompURL = "/CreditManage/CreditPutOut/ClassifyHistoryList.jsp";
			sParamString = "ObjectType=BusinessContract&ObjectNo="+sRelativeContactNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	
	/*~[Describe=台帐详情;InputParam=无;OutPutParam=无;]~*/
	function account_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			popComp("BadBizAccountInfo","/RecoveryManage/AccountManage/BadBizAccountInfo.jsp","ComponentName=不良贷款台帐详情&SerialNo="+sSerialNo+"&StateFlag=<%=sStateFlag%>&AccountType=030&AccountEditFlag=03","","");
		}
	}
	
	
	/*~[Describe=退回;InputParam=无;OutPutParam=无;]~*/
	function untread_Account()
	{	
		if(!selectRecord()) return;
		sDealType = "<%=sDealType%>";
		if(sDealType.substr(0,3)=="110")//指定不良资产管理机构
		{	
			//需判定选择了多少条。把有的找出来
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "√")
				{	
					ssSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@01,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
		}else if(sDealType.substr(0,3)=="120")//不良资产管理机构变更
		{
			//需判定选择了多少条。把有的找出来
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "√")
				{	
					sSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverOrgID@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
		}else if(sDealType.substr(0,3)=="130")//指定不良资产管理人
		{
			//需判定选择了多少条。把有的找出来
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "√")
				{
					sSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverOrgID@None@String@ReturnFlag@1,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
		}else if(sDealType.substr(0,3)=="140")//不良资产管理人变更
		{
			//需判定选择了多少条。把有的找出来
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "√")
				{
					sSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverUserID@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
		}else if(sDealType.substr(0,3)=="150")//不良资产转出
		{
			//需判定选择了多少条。把有的找出来
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "√")
				{
					sSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverUserID@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
		}
		reloadSelf();
	}
	
	
	/*~[Describe=转出;InputParam=无;OutPutParam=无;]~*/   
	function transfer_Out()
	{
		if(!selectRecord()) return;
		if(confirm("您确定转出吗?"))//您真的想删除该信息吗？
		{
			//需判定选择了多少条。把有的找出来
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "√")
				{	
						sSerialNo = getItemValue(0,i,"SerialNo");	
						sReturnValue=RunMethod("BadBizManage","DeleteBadBizAccount","BADBIZ_ACCOUNT,SerialNo,"+sSerialNo);
				}
			}
		}
		reloadSelf();
	}
	
	
	/*~[Describe=指定保全部管理机构;InputParam=无;OutPutParam=无;]~*/   
	function designate_Org()
	{
		if(!selectRecord()) return;
		//弹出对话选择框
		var sRecovery = PopPage("/RecoveryManage/DistributeManage/RecoveryOrgChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
		{
			sRecover = sRecovery.split("@");
			var sRecoverOrgID = sRecover[0];
			//需判定选择了多少条。把有的找出来
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "√")
				{	
					sSerialNo = getItemValue(0,i,"SerialNo");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverOrgID@"+sRecoverOrgID+"@String@ReturnFlag@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);	
				}
			}
			reloadSelf();
		}
	}
	
	
	/*~[Describe=更改保全部机构;InputParam=无;OutPutParam=无;]~*/
	function org_Change()
	{
		/*
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{
			sOldOrgID = getItemValue(0,getRow(),"RecoverOrgID");
			sOldOrgName	= getItemValue(0,getRow(),"RecoverOrgName");
			popComp("ChangeOrgInfo","/RecoveryManage/DistributeManage/ChangeOrgInfo.jsp","ComponentName=变更机构详情&OldOrgName="+sOldOrgName+"&OldOrgID="+sOldOrgID+"&ObjectNo="+sSerialNo+"&ObjectType=BadBizChangOrg","","");
			reloadSelf();
		}
		*/
		if(!selectRecord()) return;
		//弹出对话选择框
		var sRecovery = PopPage("/RecoveryManage/DistributeManage/RecoveryOrgChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
		{
			sRecover = sRecovery.split("@");
			var sRecoverOrgID = sRecover[0];
			//需判定选择了多少条。把有的找出来
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "√")
				{	
					sSerialNo = getItemValue(0,i,"SerialNo");
					sOldRecoverOrgID = getItemValue(0,i,"RecoverOrgID");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverOrgID@"+sRecoverOrgID+"@String@RecoverUserID@None@String@OrgChangeFlag@1,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
					sReturn = PopPage("/RecoveryManage/DistributeManage/ChangeManageAction.jsp?OldOrgID="+sOldRecoverOrgID+"&NewOrgID="+sRecoverOrgID+"&ObjectNo="+sSerialNo+"&ObjectType=BadBizChangOrg","","");	
				}
			}
			reloadSelf();
		}
	}
	
	
	 /*~[Describe=查看管理机构历次变更记录;InputParam=无;OutPutParam=无;]~*/
	function view_OrgChange()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			popComp("ChangeOrgList","/RecoveryManage/DistributeManage/ChangeOrgList.jsp","ComponentName=查看管理机构历次变更记录&ObjectType=BadBizChangOrg&ObjectNo="+sSerialNo,"","");			
		}
	}
	
	
	/*~[Describe=指定保全部管理人;InputParam=无;OutPutParam=无;]~*/   
	function designate_User()
	{
		if(!selectRecord()) return;
		//弹出对话选择框
		var sRecovery = PopPage("/RecoveryManage/DistributeManage/RecoveryUserChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
		{
			sRecover = sRecovery.split("@");
			var sRecoverUserID = sRecover[0];
			//需判定选择了多少条。把有的找出来
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "√")
				{	
					sSerialNo = getItemValue(0,i,"SerialNo");	
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoverUserID@"+sRecoverUserID+"@String@ReturnFlag@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
				}
			}
			reloadSelf();
		}
	}
	
	
	/*~[Describe=更改保全管理人;InputParam=无;OutPutParam=无;]~*/
	function user_Change()
	{
		/*
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{
			sOldUserID = getItemValue(0,getRow(),"RecoverUserID");
			sOldUserName	= getItemValue(0,getRow(),"RecoverUserName");
			popComp("ChangeUserInfo","/RecoveryManage/DistributeManage/ChangeUserInfo.jsp","ComponentName=变更管理人详情&OldUserName="+sOldUserName+"&OldUserID="+sOldUserID+"&ObjectNo="+sSerialNo+"&ObjectType=BadBizChangUser","","");
			reloadSelf();
		}
		*/
		if(!selectRecord()) return;
		//弹出对话选择框
		var sRecovery = PopPage("/RecoveryManage/DistributeManage/RecoveryUserChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
		{
			sRecover = sRecovery.split("@");
			var sRecoverUserID = sRecover[0];
			//需判定选择了多少条。把有的找出来
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "√")
				{	
					sSerialNo = getItemValue(0,i,"SerialNo");	
					sOldRecoverUserID = getItemValue(0,i,"RecoverUserID");
					sReturnValue=RunMethod("PublicMethod","UpdateColValue","@String@RecoverUserID@"+sRecoverUserID+"@String@UserChangeFlag@1,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
					sReturn = PopPage("/RecoveryManage/DistributeManage/ChangeManageAction.jsp?OldUserID="+sOldRecoverUserID+"&NewUserID="+sRecoverUserID+"&ObjectNo="+sSerialNo+"&ObjectType=BadBizChangUser","","");	
				}
			}
			reloadSelf();
		}
	}
	
	
	 /*~[Describe=查看管理机构历次变更记录;InputParam=无;OutPutParam=无;]~*/
	function view_UserChange()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			popComp("ChangeUserList","/RecoveryManage/DistributeManage/ChangeUserList.jsp","ComponentName=查看管理人历次变更记录&ObjectType=BadBizChangUser&ObjectNo="+sSerialNo,"","");			
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