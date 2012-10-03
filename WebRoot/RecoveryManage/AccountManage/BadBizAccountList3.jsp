
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

	sSql = " select '' as Status,SerialNo,RelativeContractNo,BelongOrgID,getOrgName(BelongOrgID) as BelongOrgName,FirstPutOutDate,LastMaturity,"+
				" CVDate,getItemName('CAVReason',CVReason) as CVReason,CustomerName,"+
				" getItemName('BorrowerManageStatus',CustomerManageStatus) as CustomerManageStatus,"+
				" getItemName('BorrowerAssetStatus',AssetStatus) as AssetStatus,"+
				" getItemName('AlreadyCAVType',CVBadDebtType) as CVBadDebtType,"+
				" FormerManageName,getItemName('FundSource',CVSource) as CVSource,"+
				" getItemName('ExistNewType',ExistOrNewFLag) as ExistOrNewFLag,"+
				" getItemName('TextDocStatus',TextDocStatus) as TextDocStatus,"+
				" CompareDate(VouchMaturity,0,'','有效') as VouchEffectDate,"+
				" CompareDate(LastDunDate,0,'','有效') as LawEffectDate,"+
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
		    " where AccountType='030' and StateFlag='"+sStateFlag+"' "+
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
	sSql+= "order by SerialNo";
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("BelongOrgID,RelativeContractNo,CertType,RecoverOrgID,RecoverUserID,IsFinish,AccountNeedManage,BasicNeedManage",false);
	doTemp.UpdateTable="BADBIZ_ACCOUNT";
	doTemp.setKey("SerialNo",true);	
	if(sStateFlag.equals("10"))//未登记
	{
		doTemp.setVisible("Status",true);
	}
	//设置行宽
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:250px} ");
	doTemp.setHTMLStyle("Status"," style={width:50px} ");
	doTemp.setAlign("Status","2");
	doTemp.appendHTMLStyle("Status"," style={width:60px} ondblclick=\"javascript:parent.onDBClick()\" ");
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
	//doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
	//生成查询框
	if(sStateFlag.equals("01"))//未登记
	{
		doTemp.setColumnAttribute("BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID","IsFilter","1");
	}else if(sStateFlag.equals("10"))//已登记
	{
		doTemp.setColumnAttribute("BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,AccountNeedManage,BasicNeedManage,IsFinish,RecoverOrgName,RecoverUserName","IsFilter","1");
	}else if(sStateFlag.equals("03"))//已取消
	{
		doTemp.setColumnAttribute("BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,RecoverOrgName,RecoverUserName","IsFilter","1");
	}else if(sStateFlag.equals("80"))//已终结
	{
		doTemp.setColumnAttribute("BelongOrgName,CustomerName,LoanAccountNo,CertType,CertID,FactUser,FinalBalance,RecoverOrgName,RecoverUserName,BadBizFinishDate","IsFilter","1");
	}else
	{
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
		{"false","","Button","申请详情","申请详情","viewTab()",sResourcesPath},
		{"false","","Button","查看意见","查看意见","viewOpinions()",sResourcesPath},
		{"false","","Button","台账详情","台账详情","account_Info()",sResourcesPath},
		{"false","","Button","账务信息维护","账务信息维护","account_Maintenance()",sResourcesPath},
		{"false","","Button","台账信息新增","台账信息新增","new_Account()",sResourcesPath},
		{"false","","Button","台账信息取消","台账信息取消","cancel_Account()",sResourcesPath},
		{"false","","Button","登记完成","登记完成","register_Complete()",sResourcesPath},
		{"false","","Button","终 结","终结","finish_Account()",sResourcesPath},
		{"false","","Button","退 回","退回","untread_Account()",sResourcesPath},
		{"false","","Button","还 原","还原","revert_Account()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","export_Excel()",sResourcesPath},
		{"true","","Button","汇总","汇总","listSum()",sResourcesPath},
		};
	//根据不同树图显示按钮
	if(sStateFlag.equals("01"))//未登记
	{
		sButtons[getBtnIdxByName(sButtons,"账务信息维护")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息新增")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息取消")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"登记完成")][0]="true";
	}else if(sStateFlag.equals("10"))//已登记
	{
		sButtons[getBtnIdxByName(sButtons,"账务信息维护")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"终 结")][0]="true";
	}else if(sStateFlag.equals("03"))//已取消
	{
		sButtons[getBtnIdxByName(sButtons,"台账详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"还 原")][0]="true";
	}else if(sStateFlag.equals("80"))//已终结
	{
		sButtons[getBtnIdxByName(sButtons,"申请详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"查看意见")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"还 原")][0]="true";
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
	
	
	/*~[Describe=账务信息维护;InputParam=无;OutPutParam=无;]~*/
	function account_Maintenance()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			popComp("BadBizAccountInfo","/RecoveryManage/AccountManage/BadBizAccountInfo.jsp","ComponentName=不良贷款台帐详情&SerialNo="+sSerialNo+"&StateFlag=<%=sStateFlag%>&AccountType=030&AccountEditFlag=01","","");
			reloadSelf();
		}
	}
	
	
	/*~[Describe=台账信息新增;InputParam=无;OutPutParam=无;]~*/
	function new_Account()
	{
		//使用GetSerialNo.jsp来抢占一个流水号
		var sTableName = "BADBIZ_ACCOUNT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
								
		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		popComp("BadBizAccountInfo","/RecoveryManage/AccountManage/BadBizAccountInfo.jsp","ComponentName=不良贷款台帐详情&SerialNo="+sSerialNo+"&StateFlag=<%=sStateFlag%>&AccountType=030&AccountEditFlag=01","","");
		reloadSelf();
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
	
	
	/*~[Describe=台帐信息取消;InputParam=无;OutPutParam=无;]~*/
	function cancel_Account()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else 
		{	
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@03,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//操作成功
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//操作失败
				return;
			}
		}
	}
		
	
	/*~[Describe=终结;InputParam=无;OutPutParam=无;]~*/
	function finish_Account()
	{
		if(!selectRecord()) return;
		if(confirm("您确定终结吗?"))//您真的想删除该信息吗？
		{
			//需判定选择了多少条。把有的找出来
			var b = getRowCount(0);
			for(var i = 0 ; i < b ; i++)
			{
				var a = getItemValue(0,i,"Status");
				if(a == "√")
				{	
						sSerialNo = getItemValue(0,i,"SerialNo");	
						sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@80@String@BadBizFinishDate@<%=StringFunction.getToday()%>,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
						reloadSelf();
				}
			}
		}
		/*
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else 
		{	
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@80@String@BadBizFinishDate@<%=StringFunction.getToday()%>,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//操作成功
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//操作失败
				return;
			}
		}
		*/
	}
	
	
	/*~[Describe=登记完成;InputParam=无;OutPutParam=无;]~*/
	function register_Complete()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else 
		{	
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@10,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//操作成功
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//操作失败
				return;
			}
		}
	}
	
	
	/*~[Describe=还原;InputParam=无;OutPutParam=无;]~*/
	function revert_Account()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if("<%=sStateFlag%>"=="03")//已取消
		{
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@01,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//操作成功
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//操作失败
				return;
			}
		}else//已终结
		{	
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@10@String@BadBizFinishDate@None,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//操作成功
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//操作失败
				return;
			}
		}
	}
	
	
	/*~[Describe=退回;InputParam=无;OutPutParam=无;]~*/
	function untread_Account()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if("<%=sStateFlag%>"=="10")//已登记
		{
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@StateFlag@01,BADBIZ_ACCOUNT,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{	
				alert(getHtmlMessage('71'));//操作成功
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('72'));//操作失败
				return;
			}
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{	
		
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}
	
	
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		//获得申请类型、申请流水号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//获取申请流水号
		sReturn=RunMethod("BadBizManage","GetFinishAccountApplyNo",sSerialNo);
		sReturnInfo=sReturn.split("@")
		if(typeof(sReturnInfo[0])=="undefined" || sReturnInfo[0].length==0 || sReturnInfo[0]=='Null') 
		{	
			alert("无申请信息!");
			return;
		}else
		{
			sObjectNo = sReturnInfo[0];
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=BadBizApply&ObjectNo="+sObjectNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}
	}
	
	
	/*~[Describe=查看审批意见;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//获取申请流水号
		sReturn=RunMethod("BadBizManage","GetFinishAccountApplyNo",sSerialNo);
		sReturnInfo=sReturn.split("@")
		if(typeof(sReturnInfo[0])=="undefined" || sReturnInfo[0].length==0 || sReturnInfo[0]=='Null') 
		{
			alert("无审批意见!");
			return;
		}else
		{
			sObjectNo = sReturnInfo[0];
			popComp("ViewBadBizOpinions","/Common/WorkFlow/ViewBadBizOpinions.jsp","FlowNo=BadBizFlow&PhaseNo=0010&ObjectType=BadBizApply&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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