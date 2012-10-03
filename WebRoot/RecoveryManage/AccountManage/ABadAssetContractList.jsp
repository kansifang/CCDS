<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/10/09
*	Tester:
*	Describe: 不良资产合同台帐信息列表
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产合同台帐信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sRetractType = "";
	//获得组件参数
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";
	//获得页面参数
			
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义标题
	String sHeaders[][] = {
							{"SerialNo","合同流水号"},
							{"CustomerName","客户名称"},
							{"BusinessTypeName","业务品种"},
							{"VouchTypeName","主要担保方式"},
							{"BusinessCurrencyName","币种"},
							{"CAVSum","核销金额"},
							{"CAVSum1","置换金额"},
							{"BusinessSum","合同金额"},
							{"Balance","合同余额"},	
							{"ClassifyResultName","风险分类"},
							{"PutOutDate","合同起始日"},
							{"Maturity","合同到期日"},
							{"OccurTypeName","发生类型"},
							{"FinishDate","核销时间"},
							{"FinishDate1","置换时间"},
							{"CancelReason","核销理由"},
							{"BorrowerTypeName","借款人性质"},
							{"BorrowerManageStatusName","借款人经营状况"},
							{"BorrowerAssetStatusName","借款人资产状况"},
							{"BorrowerAttitudeName","借款人态度"},
							{"DebtInstanceName","债务落实情况"},
							{"FactVouchDegreeName","实际担保程度"},
							{"VouchEffectDate","担保时效"},
							{"LawEffectDate","诉讼时效"},
							{"CancelBadType","已核销呆账类别"},
							{"CancelSumSource","核销资金来源"},
							{"CancelType","类别"},
							{"RetractSum","货币资金收回金额"},
							{"OtherRetractSum","其他收回金额"},
							{"TextDocStatusName","文本档案情况"},
							{"ExistNewTypeName","(存量/新增)类别"},
							{"InterestBalance1","表内"},
							{"InterestBalance2","表外"},
							{"InterestBalance","结欠利息"},
							{"ManageUserName","管户人"},
							{"ManageOrgName","管户机构"}
						}; 

 	sSql = " select SerialNo," + 	
			   " CustomerID,CustomerName," + 
			   " getBusinessName(BusinessType) as BusinessTypeName," +
			   " getItemName('VouchType',VouchType) as VouchTypeName,"+
			   " getItemName('Currency',BusinessCurrency) as BusinessCurrencyName,"+
			   " BusinessSum,nvl(Balance,0) as Balance,"+
			   " getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,"+
			   " PutOutDate,Maturity,"+
			   " getItemName('OccurType',OccurType) as OccurTypeName,"+
			   " FinishDate as FinishDate,FinishDate as FinishDate1,' ' as CancelReason,"+
			   " getItemName('BorrowerType',BorrowerType) as BorrowerTypeName," + 
			   " getItemName('BorrowerManageStatus',BorrowerManageStatus) as BorrowerManageStatusName," + 
			   " getItemName('BorrowerAssetStatus',BorrowerAssetStatus) as BorrowerAssetStatusName," + 
			   " getItemName('BorrowerAttitude',BorrowerAttitude) as BorrowerAttitudeName," + 
			   " getItemName('DebtInstance',DebtInstance) as DebtInstanceName," + 
			   " getItemName('FactVouchDegree',FactVouchDegree) as FactVouchDegreeName," + 
			   " VouchEffectDate,LawEffectDate," + 
			   " '' as CancelBadType,' ' as CancelSumSource,' ' as CancelType,"+
			   " getRetractSum(SerialNo) as RetractSum,"+
			   " getOtherRetractSum(SerialNo) as OtherRetractSum,"+
			   " getItemName('TextDocStatus',TextDocStatus) as TextDocStatusName," + 
			   " getItemName('ExistNewType',ExistNewType) as ExistNewTypeName," + 
			   " nvl(InterestBalance1,0) as InterestBalance1,"+
			   " nvl(InterestBalance2,0) as InterestBalance2,"+
			   " nvl(InterestBalance1+InterestBalance2,0) as InterestBalance,"+
			   " nvl(Cancelsum+CancelInterest,0) as CAVSum,"+
			   " nvl(Cancelsum+CancelInterest,0) as CAVSum1,"+
			   " ClassifyResult," + 
			   " getOrgName(ManageOrgID) as ManageOrgName, " + 
			   " getUserName(ManageUserID) as ManageUserName " + 
		    " from BUSINESS_CONTRACT "+
		    " where RecoveryUserID='"+CurUser.UserID+"'"+
		    " and RecoveryOrgID ='"+CurOrg.OrgID+"'"+
		    " and substr(ClassifyResult,1,2)>'02'";
		   
	//根据树图取不同结果集	 
	/*
		BadBizFinishType 终结类型:
					010:核销类
					020:票据置换类
					030:股金置换类
					040:其他类					
	*/
	if(sDealType.equals("010"))//不良贷款台账
	{
		sSql+= " and (FinishDate is  null or FinishDate ='')  ";
	}else if(sDealType.equals("030"))//已核销贷款台账
	{
		sSql+= " and BadBizFinishType='010' ";
		sRetractType = "010";
	}else if(sDealType.equals("040"))//央行票据置换不良贷款台账
	{
		sSql+= " and BadBizFinishType='020' ";
		sRetractType = "020";
	}else if(sDealType.equals("050"))//股金置换不良贷款台账
	{
		sSql+= " and BadBizFinishType='030' ";
		sRetractType = "030";
	}else
	{
		sSql+= " and 1=2";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("InterestBalance,InterestBalance2,InterestBalance1,ExistNewTypeName,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerTypeName,BusinessSum,Balance,ClassifyResultName,VouchTypeName,OtherRetractSum,RetractSum,CancelSumSource,CancelBadType,CancelType,FinishDate1,FinishDate,CancelReason,OccurTypeName,RecoveryOrgName,RecoveryUserName,ShiftBalance,CAVSum,CAVSum1,ShiftType,CustomerID,FinishType,FinishDate,ClassifyResult",false);
	//doTemp.setKeyFilter("SerialNo");		
    if(sDealType.equals("010"))//不良贷款台账
	{
    	doTemp.setVisible("InterestBalance,InterestBalance2,InterestBalance1,ExistNewTypeName,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerTypeName,VouchTypeName,BusinessSum,Balance,ClassifyResultName",true);
	}else if(sDealType.equals("030"))//已核销贷款台账
	{
		doTemp.setVisible("CAVSum,OccurTypeName,FinishDate,CancelReason,CancelBadType,CancelSumSource,CancelType,RetractSum,OtherRetractSum",true);
	}else if(sDealType.equals("040"))//央行票据置换不良贷款台账
	{
		doTemp.setVisible("CAVSum1,OccurTypeName,FinishDate1,RetractSum,OtherRetractSum",true);
	}else if(sDealType.equals("050"))//股金置换不良贷款台账
	{
		doTemp.setVisible("CAVSum1,OccurTypeName,FinishDate1,RetractSum,OtherRetractSum",true);
	}
	//设置行宽
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName,Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("CAVSum,CAVSum1,OtherRetractSum,RetractSum,BusinessSum,InterestBalance1,InterestBalance2,InterestBalance"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");

	//设置金额为三位一逗数字
	doTemp.setType("CAVSum,CAVSum1,OtherRetractSum,RetractSum,BusinessSum,ShiftBalance,Balance,ActualPutOutSum,InterestBalance1,InterestBalance2,InterestBalance","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("CAVSum,CAVSum1,OtherRetractSum,RetractSum,BusinessSum,Balance,ActualPutOutSum,CAVSum,InterestBalance1,InterestBalance2,InterestBalance","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("CAVSum,CAVSum1,OtherRetractSum,RetractSum,BusinessSum,CAVSum,Balance,ActualPutOutSum,InterestBalance1,InterestBalance2,InterestBalance","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,BusinessCurrencyName","2");
	
	//生成查询框
	doTemp.setColumnAttribute("SerialNo,CustomerName,BusinessTypeName,Balance,ClassifyResultName,PutOutDate,Maturity,BorrowerTypeName,BorrowerAssetStatusName,BorrowerAssetStatusName,BorrowerAttitudeName,DebtInstanceName,FactVouchDegreeName,VouchEffectDate,LawEffectDate,TextDocStatusName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(20); 	//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

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
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		{"false","","Button","导出EXCEL","导出EXCEL","export_Excel()",sResourcesPath},
		{"false","","Button","核销后回收信息登记","核销后回收信息登记","receive_Record()",sResourcesPath},
		{"false","","Button","置换后回收信息登记","置换后回收信息登记","receive_Record()",sResourcesPath}
		};
	//根据不同树图显示按钮
	if(sDealType.equals("010"))//不良贷款台账
	{
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("030"))//已核销贷款台账
	{
		sButtons[getBtnIdxByName(sButtons,"核销后回收信息登记")][0]="true";
	}else if(sDealType.equals("040"))//央行票据置换不良贷款台账
	{
		sButtons[getBtnIdxByName(sButtons,"置换后回收信息登记")][0]="true";
	}else if(sDealType.equals("050"))//股金置换不良贷款台账
	{
		sButtons[getBtnIdxByName(sButtons,"置换后回收信息登记")][0]="true";
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
	/*~[Describe=一般监控报告;InputParam=无;OutPutParam=无;]~*/    
	function receive_Record()
	{
		//获得合同编号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			popComp("WrtnOffList","/RecoveryManage/AccountManage/WrtnOffList.jsp","ComponentName=台帐维护回收信息登记列表&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>&RetractType=<%=sRetractType%>","","");
		}
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