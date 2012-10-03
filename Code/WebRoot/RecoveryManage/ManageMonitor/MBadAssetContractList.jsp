<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/09/27
*	Tester:
*	Describe: 不良资产合同监控信息列表
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产合同监控信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sSql1 = "";
	ASResultSet rs1 = null;
	String sOrgFlag = "",sReportType = "";
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
							{"BusinessTypeName","业务品种"},
							{"CustomerName","客户名称"},
							//{"GuarantorName","担保人名称"},
							{"VouchTypeName","担保方式"},
							{"BusinessSum","合同金额"},
							{"BorrowerManageStatusName","借款人经营状况"},
							{"BorrowerAssetStatusName","借款人资产状况"},
							{"BorrowerAttitudeName","借款人态度"},
							{"DebtInstanceName","债务落实情况"},
							{"FactVouchDegreeName","实际担保程度"},
							{"VouchEffectDate","担保时效"},
							{"LawEffectDate","诉讼时效"},
							{"ExistNewTypeName","新增类型"},
							{"Balance","当前余额"},					
							{"ClassifyResultName","风险分类"},
							{"BadLoanCaliberName","不良贷款口径"},
							{"ShiftTypeName","移交类型"},
							{"RecoveryUserName","管理人"},
							{"RecoveryOrgName","管理机构"},
							{"ManageUserName","原管户人"},
							{"ManageOrgName","原管户机构"},
							{"UpdateDate","最后补登时间"},
							{"CMonitorDate","最后监控时间"}
						}; 

 	sSql =  " select SerialNo," + 	
			   " CustomerID,CustomerName," + 
			   " '' as GuarantorName,"+
			   " getItemName('VouchType',VouchType) as VouchTypeName,"+
			   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," +
			   " BusinessSum,nvl(Balance,0) as Balance,"+
			   " getItemName('BorrowerManageStatus',BorrowerManageStatus) as BorrowerManageStatusName," + 
			   " getItemName('BorrowerAssetStatus',BorrowerAssetStatus) as BorrowerAssetStatusName," + 
			   " getItemName('BorrowerAttitude',BorrowerAttitude) as BorrowerAttitudeName," + 
			   " getItemName('DebtInstance',DebtInstance) as DebtInstanceName," + 
			   " getItemName('FactVouchDegree',FactVouchDegree) as FactVouchDegreeName," + 
			   " VouchEffectDate,LawEffectDate," + 
			   " getItemName('ExistNewType',ExistNewType) as ExistNewTypeName," + 
			   " Cancelsum+CancelInterest as CAVSum,"+
			   " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,getItemName('BadLoanCaliber',BadLoanCaliber) as BadLoanCaliberName," + 
			   " ShiftType,getItemName('ShiftType',ShiftType) as ShiftTypeName," + 
			   " getOrgName(RecoveryOrgID) as RecoveryOrgName, " + 
			   " getUserName(RecoveryUserID) as RecoveryUserName," + 
			   " getUserName(ManageUserID) as ManageUserName," + 
			   " getOrgName(ManageOrgID) as ManageOrgName,UpdateDate,CMonitorDate " + 
		    " from BUSINESS_CONTRACT "+
		    " where substr(ClassifyResult,1,2)>'02'";
		   
	//根据树图取不同结果集	 
	/*
		BadLoanCaliber 不良贷款口径标识:
					010:账面不良贷款
					020:票据置换不良贷款
					030:股金置换不良贷款
					040:已核销不良贷款
		BadBizProjectFlag 不良贷款项目标识:
					010:一般项目
					020:重点项目
		EMonitorDate 最近一次重点项目监控时间
		CMonitorDate 最近一次一般项目监控时间
						
	*/
	if(sDealType.equals("010010"))//台账信息补登未补登
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and ManageFlag='010' ";
	}else if(sDealType.equals("010020"))//台账信息补登已补登
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and ManageFlag='080' ";
	}else if(sDealType.equals("030010010"))//账面不良贷款一般监控未监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='')  and BadLoanCaliber='010' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "010";
	}else if(sDealType.equals("030010020"))//账面不良贷款一般监控已监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-90 ";
	}else if(sDealType.equals("030020010"))//账面不良贷款重点监控未监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "020";
	}else if(sDealType.equals("030020020"))//账面不良贷款重点监控已监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-90";
	}else if(sDealType.equals("050010010"))//股金置换不良贷款一般监控未监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "010";
	}else if(sDealType.equals("050010020"))//股金置换不良贷款一般监控已监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020'"+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-90";
	}else if(sDealType.equals("050020010"))//股金置换不良贷款重点监控未监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "020";
	}else if(sDealType.equals("050020020"))//股金置换不良贷款重点监控已监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-90 ";
	}else if(sDealType.equals("060010010"))//央行票据置换不良贷款一般监控未监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "010";
	}else if(sDealType.equals("060010020"))//央行票据置换不良贷款一般监控已监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-180 ";
	}else if(sDealType.equals("060020010"))//央行票据置换不良贷款重点监控未监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "020";
	}else if(sDealType.equals("060020020"))//央行票据置换不良贷款重点监控已监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-180";
	}else if(sDealType.equals("040010010"))//已核销不良贷款一般监控未监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-180 )";
		sReportType = "010";
	}else if(sDealType.equals("040010020"))//已核销不良贷款一般监控已监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040'"+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-180 ";
	}else if(sDealType.equals("040020010"))//已核销不良贷款重点监控未监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "020";
	}else if(sDealType.equals("040020020"))//已核销不良贷款重点监控已监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-180";
	}else if(sDealType.equals("100"))//诉讼时效管理监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='')  "+
				" and LawEffectDate is not null and LawEffectDate!='' "+
				" and days(replace(LawEffectDate,'/','-'))<days(current date)";
	}else if(sDealType.equals("110"))//担保时效管理监控
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') "+
		" and VouchEffectDate is not null and VouchEffectDate!='' "+
		" and days(replace(VouchEffectDate,'/','-'))<days(current date)";
	}else
	{
		sSql+=" and 1=2";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("GuarantorName,VouchTypeName,CMonitorDate,ManageUserName,ManageOrgName,RecoveryUserID,RecoveryOrgID,CAVSum,ShiftType,CustomerID,BusinessType,FinishType,FinishDate,ClassifyResult,ShiftType,ShiftTypeName",false);
	doTemp.setKeyFilter("SerialNo");		
    
	if(sDealType.equals("100") || sDealType.equals("110"))
	{
		doTemp.setVisible("CMonitorDate,VouchTypeName",true);
		doTemp.setVisible("UpdateDate,BorrowerManageStatusName,BorrowerAssetStatusName,BorrowerAttitudeName,DebtInstanceName,ExistNewTypeName",false);
	}
	//设置行宽
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName,Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,Balance,ActualPutOutSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum,CAVSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,CAVSum,Balance,ActualPutOutSum","3");
	doTemp.setAlign("BusinessTypeName","2");
	
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName","IsFilter","1");
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
		{"false","","Button","一般监控报告","一般监控报告","cMonitor_Report()",sResourcesPath},
		{"false","","Button","重点监控报告","重点监控报告","eMonitor_Report()",sResourcesPath},
		{"true","","Button","客户详情","客户详情","customer_Info()",sResourcesPath},
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		{"false","","Button","台账信息详情","台账信息详情","account_Vindicate()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","export_Excel()",sResourcesPath},
		};
	//根据不同树图显示按钮
	if(sDealType.equals("010010"))//台账信息补登未补登
	{
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
	}else if(sDealType.equals("010020"))//台账信息补登已补登
	{
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
	}else if(sDealType.equals("030010010"))//账面不良贷款一般监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告")][0]="true";
	}else if(sDealType.equals("030010020"))//账面不良贷款一般监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告")][0]="true";
	}else if(sDealType.equals("030020010"))//账面不良贷款重点监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告")][0]="true";
	}else if(sDealType.equals("030020020"))//账面不良贷款重点监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告")][0]="true";
	}else if(sDealType.equals("050010010"))//股金置换不良贷款一般监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告")][0]="true";	
	}else if(sDealType.equals("050010020"))//股金置换不良贷款一般监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告")][0]="true";	
	}else if(sDealType.equals("050020010"))//股金置换不良贷款重点监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告")][0]="true";	
	}else if(sDealType.equals("050020020"))//股金置换不良贷款重点监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告")][0]="true";
	}else if(sDealType.equals("060010010"))//央行票据置换不良贷款一般监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告")][0]="true";
		
	}else if(sDealType.equals("060010020"))//央行票据置换不良贷款一般监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"客户详情")][0]="true";
	}else if(sDealType.equals("060020010"))//央行票据置换不良贷款重点监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"客户详情")][0]="true";
	}else if(sDealType.equals("060020020"))//央行票据置换不良贷款重点监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"客户详情")][0]="true";
	}else if(sDealType.equals("040010010"))//已核销不良贷款一般监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"客户详情")][0]="true";
	}else if(sDealType.equals("040010020"))//已核销不良贷款一般监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"客户详情")][0]="true";
	}else if(sDealType.equals("040020010"))//已核销不良贷款重点监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"客户详情")][0]="true";
	}else if(sDealType.equals("040020020"))//已核销不良贷款重点监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"客户详情")][0]="true";
	}else if(sDealType.equals("100"))//诉讼时效管理监控
	{
		sButtons[getBtnIdxByName(sButtons,"客户详情")][0]="true";
	}else if(sDealType.equals("110"))//担保时效管理监控
	{
		sButtons[getBtnIdxByName(sButtons,"客户详情")][0]="true";
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
	function cMonitor_Report()
	{
		//获得还款流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			popComp("MonitorReportList","/RecoveryManage/NPAManage/NPADailyManage/MonitorReportList.jsp","ComponentName=一般监控报告列表&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
	}
	
	/*~[Describe=重点监控报告;InputParam=无;OutPutParam=无;]~*/    
	function eMonitor_Report()
	{
		//获得还款流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			popComp("eMonitorReport","/RecoveryManage/NPAManage/NPADailyManage/eMonitorReportList.jsp","ComponentName=重点检查报告列表&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
	}
	
	/*~[Describe=台帐信息维护;InputParam=无;OutPutParam=无;]~*/
	function account_Vindicate()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/AccountVindicateInfo.jsp?SerialNo="+sSerialNo+"&DealType=<%=sDealType%>","_self",""); 
		}
	}
	
	/*~[Describe=查看客户详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function customer_Info()
	{
		//获得客户编号
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");
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