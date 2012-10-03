<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/09/16
*	Tester:
*	Describe: 不良资产合同信息列表
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产合同信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
							{"PutOutDate","合同起始日"},
							{"Maturity","合同到期日"},
							{"BusinessTypeName","业务品种"},
							{"OccurTypeName","发生类型"},
							{"CustomerName","客户名称"},
							{"BusinessCurrencyName","币种"},
							{"BusinessSum","合同金额"},
							{"ShiftBalance","移交余额"},
							{"FactUser","实际用款人"},
							{"FirstPutoutDate","首次发放日"},
							{"LastMaturity","最后到期日"},
							{"BorrowerTypeName","借款人性质"},
							{"BorrowerManageStatusName","借款人经营状况"},
							{"BorrowerAssetStatusName","借款人资产状况"},
							{"BorrowerAttitudeName","借款人态度"},
							{"DebtInstanceName","债务落实情况"},
							{"FactVouchDegreeName","实际担保程度"},
							{"VouchEffectDate","担保时效"},
							{"LawEffectDate","诉讼时效"},
							{"TextDocStatus","文本档案情况"},
							{"ExistNewTypeName","存量/新增类型"},
							{"Balance","当前余额"},					
							{"ClassifyResultName","风险分类"},
							{"BadLoanCaliberName","不良贷款口径"},
							{"InterestBalance1","表内欠息"},
							{"InterestBalance2","表外欠息"},
							{"ShiftTypeName","移交类型"},
							{"MendInputUserName","登记人"},
							{"MendInputOrgName","登记机构"},
							{"BadBizProjectFlagName","项目类型"},
							{"BadBizFinishTypeName","终结类型"},
							{"RecoveryUserName","管理责任人"},
							{"RecoveryOrgName","管理机构"},
							{"ManageUserName","原管户人"},
							{"ManageOrgName","原管户机构"},
							{"DunTimes","催收次数"},
							{"RecentDunDate","最近催收日期"},
							{"ApplyDate","申请日期"},
							{"FinishDate","审批日期"},
							{"CMonitorDate","监控时间"},
							{"EMonitorDate","监控时间"}
						}; 

 	sSql = " select SerialNo,RelativeSerialNo,PutOutDate,Maturity," + 	
		   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
		   " getItemName('OccurType',OccurType) as OccurTypeName," + 
		   " CustomerID,CustomerName,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
		   " BusinessSum,ShiftBalance,nvl(Balance,0) as Balance,FactUser,"+
		   " FirstPutoutDate,LastMaturity,getItemName('BorrowerType',BorrowerType) as BorrowerTypeName,"+
		   " getItemName('BorrowerManageStatus',BorrowerManageStatus) as BorrowerManageStatusName," + 
		   " getItemName('BorrowerAssetStatus',BorrowerAssetStatus) as BorrowerAssetStatusName," + 
		   " getItemName('BorrowerAttitude',BorrowerAttitude) as BorrowerAttitudeName," + 
		   " getItemName('DebtInstance',DebtInstance) as DebtInstanceName," + 
		   " getItemName('FactVouchDegree',FactVouchDegree) as FactVouchDegreeName," + 
		   " VouchEffectDate,LawEffectDate,getItemName('TextDocStatus',TextDocStatus) as TextDocStatus," + 
		   " getItemName('ExistNewType',ExistNewType) as ExistNewTypeName," + 
		   " Cancelsum+CancelInterest as CAVSum,"+
		   " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,getItemName('BadLoanCaliber',BadLoanCaliber) as BadLoanCaliberName," + 
		   " nvl(InterestBalance1,0) as InterestBalance1,nvl(InterestBalance2,0) as InterestBalance2,"+
		   " ShiftType,getItemName('ShiftType',ShiftType) as ShiftTypeName," + 
		   " getUserName(RecoveryUserID) as MendInputUserName," + 
		   " getOrgName(RecoveryOrgID) as MendInputOrgName,"+
		   " getItemName('BadBizProjectFlag',BadBizProjectFlag) as BadBizProjectFlagName,"+
		   " getItemName('BadBizFinishType',BadBizFinishType) as BadBizFinishTypeName,"+
		   " getUserName(RecoveryUserID) as RecoveryUserName," + 
		   " getOrgName(RecoveryOrgID) as RecoveryOrgName,"+
		   " getUserName(ManageUserID) as ManageUserName," + 
		   " getOrgName(ManageOrgID) as ManageOrgName,getDunTimes(SerialNo) as DunTimes,"+
		   " getRecentDunDate(SerialNo) as RecentDunDate,getFCApplyDate(SerialNo) as ApplyDate,FinishDate, " +
		   " CMonitorDate,EMonitorDate "+
		   " from BUSINESS_CONTRACT BC"+
		   " where RecoveryUserID='"+CurUser.UserID+"'"+
		   " and RecoveryOrgID ='"+CurOrg.OrgID+"'";
		   
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
	if(sDealType.equals("010"))//已终结分管不良贷款信息
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and FinishDate is not null and FinishDate !=''  ";
	}else if(sDealType.equals("020"))//  未终结分管不良贷款信息
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') ";
	}else if(sDealType.equals("020002"))//  日常催收管理
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') ";
	}else if(sDealType.equals("020010010"))//台账信息补登未补登
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and ManageFlag='010' ";
	}else if(sDealType.equals("020010020"))//台账信息补登已补登
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and ManageFlag='080' ";
	}else if(sDealType.equals("020020010"))//还款方式补登未补登
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') ";
	}else if(sDealType.equals("020020020"))//还款方式补登已补登
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') ";
	}else if(sDealType.equals("020030010010010"))//账面不良贷款一般监控未监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='')  and BadLoanCaliber='010' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "010";
	}else if(sDealType.equals("020030010010020"))//账面不良贷款一般监控已监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-90 ";
	}else if(sDealType.equals("020030010020010"))//账面不良贷款重点监控未监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "020";
	}else if(sDealType.equals("020030010020020"))//账面不良贷款重点监控已监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='010' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-90";
	}else if(sDealType.equals("020030020010010"))//股金置换不良贷款一般监控未监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "010";
	}else if(sDealType.equals("020030020010020"))//股金置换不良贷款一般监控已监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020'"+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-90";
	}else if(sDealType.equals("020030020020010"))//股金置换不良贷款重点监控未监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-90)";
		sReportType = "020";
	}else if(sDealType.equals("020030020020020"))//股金置换不良贷款重点监控已监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-90 ";
	}else if(sDealType.equals("020030030010010"))//央行票据置换不良贷款一般监控未监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "010";
	}else if(sDealType.equals("020030030010020"))//央行票据置换不良贷款一般监控已监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-180 ";
	}else if(sDealType.equals("020030030020010"))//央行票据置换不良贷款重点监控未监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "020";
	}else if(sDealType.equals("020030030020020"))//央行票据置换不良贷款重点监控已监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-180";
	}else if(sDealType.equals("020030040010010"))//已核销不良贷款一般监控未监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-180 )";
		sReportType = "010";
	}else if(sDealType.equals("020030040010020"))//已核销不良贷款一般监控已监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040'"+
				" and CMonitorDate is not null and CMonitorDate!='' "+
				" and days(replace(CMonitorDate,'/','-'))>days(current date)-180 ";
	}else if(sDealType.equals("020030040020010"))//已核销不良贷款重点监控未监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and BadBizProjectFlag='020' and (EMonitorDate is  null or EMonitorDate ='' or "+
				" days(replace(EMonitorDate,'/','-'))<=days(current date)-180)";
		sReportType = "020";
	}else if(sDealType.equals("020030040020020"))//已核销不良贷款重点监控已监控
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and EMonitorDate is not null and EMonitorDate!='' "+
				" and BadBizProjectFlag='020' and days(replace(EMonitorDate,'/','-'))>days(current date)-180";
	}else if(sDealType.equals("020040010"))//未转出
	{
		sSql+=" and substr(ClassifyResult,1,2) in('01','02') ";
	}else if(sDealType.equals("020040020"))//已转出
	{
		sSql+=" and ManageFlag = '090' ";
	}else
	{
		sSql+=" and 1=2";
	}
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	doTemp.setVisible("RelativeSerialNo,CMonitorDate,EMonitorDate,MendInputUserName,MendInputOrgName,TextDocStatus,BorrowerTypeName,FirstPutoutDate,LastMaturity,FactUser,ApplyDate,FinishDate,BadBizFinishTypeName,RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName,ExistNewTypeName,LawEffectDate,VouchEffectDate,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerAssetStatusName,BorrowerManageStatusName,CAVSum,BusinessSum,BadLoanCaliberName,InterestBalance1,InterestBalance2,BusinessCurrencyName,BusinessTypeName,PutOutDate,Maturity,RecentDunDate,DunTimes,ManageUserName,ManageOrgName,OccurTypeName,ShiftBalance,ShiftType,CustomerID,BusinessType,FinishType,FinishDate,ClassifyResult,ShiftType,ShiftTypeName",false);
	doTemp.setKeyFilter("SerialNo");		
    //设置不共用格式
    if(sDealType.equals("010"))
    {
    	doTemp.setHeader("Balance","终结余额");
    	doTemp.setVisible("ApplyDate,FinishDate,BadBizFinishTypeName,RecoveryUserName,RecoveryOrgName",true);
    }else if(sDealType.equals("020"))//  未终结分管不良贷款信息
	{
    	doTemp.setVisible("RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName,OccurTypeName,BusinessSum,InterestBalance1,InterestBalance2,BusinessCurrencyName,BusinessTypeName,PutOutDate,Maturity,RecentDunDate,DunTimes",true);
	}else if(sDealType.equals("020002"))//  日常催收管理
	{
    	doTemp.setVisible("RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName,OccurTypeName,BusinessSum,InterestBalance1,InterestBalance2,BusinessCurrencyName,BusinessTypeName,PutOutDate,Maturity,RecentDunDate,DunTimes",true);
	}else if(sDealType.equals("020010010"))//台账信息补登未补登
	{
		doTemp.setVisible("MendInputUserName,MendInputOrgName,RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName,ExistNewTypeName,TextDocStatus,LawEffectDate,VouchEffectDate,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerAssetStatusName,BorrowerManageStatusName,BorrowerTypeName,FirstPutoutDate,LastMaturity,FactUser,BusinessSum,BadLoanCaliberName",true);
	}else if(sDealType.equals("020010020"))//台账信息补登已补登
	{
		doTemp.setHeader("MendInputUserName","维护人");
		doTemp.setHeader("MendInputOrgName","维护机构");
		doTemp.setVisible("MendInputUserName,MendInputOrgName,RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName,ExistNewTypeName,TextDocStatus,LawEffectDate,VouchEffectDate,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerAssetStatusName,BorrowerManageStatusName,BorrowerTypeName,FirstPutoutDate,LastMaturity,FactUser,BusinessSum,BadLoanCaliberName",true);
	}else if(sDealType.length()>6&&sDealType.substring(0,6).equals("020030"))//日常监控管理
	{	
		doTemp.setHeader("MendInputUserName","监控人");
		doTemp.setHeader("MendInputOrgName","监控机构");
		doTemp.setVisible("MendInputUserName,MendInputOrgName,ExistNewTypeName,TextDocStatus,LawEffectDate,VouchEffectDate,FactVouchDegreeName,DebtInstanceName,BorrowerAttitudeName,BorrowerAssetStatusName,BorrowerManageStatusName,BorrowerTypeName,FirstPutoutDate,LastMaturity,FactUser,BusinessSum,BadLoanCaliberName",true);
		System.out.println(sDealType.substring(9,12)+"@@@@@@@@@@");
		if(sDealType.length()>12&&sDealType.substring(9,12).equals("010"))
		{
			doTemp.setVisible("CMonitorDate",true);
		}else
		{
			doTemp.setVisible("EMonitorDate",true);
		}
	}
	//设置行宽
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance,InterestBalance1,InterestBalance2"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("MendInputOrgName,RecoveryOrgName,ManageOrgName"," style={width:250px} ");
	doTemp.setHTMLStyle("MendInputUserName,RecoveryUserName,ManageUserName"," style={width:60px} ");

	//设置金额为三位一逗数字
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum,InterestBalance1,InterestBalance2","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum,InterestBalance1,InterestBalance2","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BusinessSum,Balance,ActualPutOutSum,InterestBalance1,InterestBalance2","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,BusinessCurrencyName","2");
	
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
		{"false","","Button","新增催收登记","新增催收登记","dun_Note()",sResourcesPath},
		{"false","","Button","信息补登及维护","信息补登及维护","account_Vindicate()",sResourcesPath},
		{"false","","Button","新增一般监控报告","新增一般监控报告","cMonitor_Report()",sResourcesPath},
		{"false","","Button","一般监控报告详情","一般监控报告详情","cMonitor_Report()",sResourcesPath},
		{"false","","Button","新增重点监控报告","新增重点监控报告","eMonitor_Report()",sResourcesPath},
		{"false","","Button","重点监控报告详情","重点监控报告详情","eMonitor_Report()",sResourcesPath},
		{"false","","Button","客户详情","客户详情","customer_Info()",sResourcesPath},
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		{"false","","Button","台账信息详情","台账信息详情","account_Vindicate()",sResourcesPath},
		{"false","","Button","终结申请详情","终结申请详情","finishApply_Info()",sResourcesPath},
		{"false","","Button","终结审批详情","终结审批详情","finishApprove_Info()",sResourcesPath},
		{"true","","Button","审查审批详情","审查审批详情","view_Opinions()",sResourcesPath},
		{"false","","Button","补登完成","补登完成","mend_Complete()",sResourcesPath},
		{"false","","Button","完成监控","完成监控","monitor_Complete()",sResourcesPath},
		{"false","","Button","导出EXCEL","导出EXCEL","export_Excel()",sResourcesPath},
		{"false","","Button","转出","将合同退回给原管户人","my_ReverseHandover()",sResourcesPath}
		};
	//根据不同树图显示按钮
	if(sDealType.equals("010"))//已终结分管不良贷款信息
	{
		sButtons[getBtnIdxByName(sButtons,"终结申请详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"终结审批详情")][0]="true";
	}else if(sDealType.equals("020002"))//  日常催收管理
	{
		sButtons[getBtnIdxByName(sButtons,"新增催收登记")][0]="true";
	}else if(sDealType.equals("020010010"))//台账信息补登未补登
	{
		sButtons[getBtnIdxByName(sButtons,"信息补登及维护")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"补登完成")][0]="true";
	}else if(sDealType.equals("020010020"))//台账信息补登已补登
	{
		sButtons[getBtnIdxByName(sButtons,"信息补登及维护")][0]="true";
	}else if(sDealType.equals("020030010010010"))//账面不良贷款一般监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"新增一般监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"完成监控")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020030010010020"))//账面不良贷款一般监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020030010020010"))//账面不良贷款重点监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"新增重点监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"完成监控")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020030010020020"))//账面不良贷款重点监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020030020010010"))//股金置换不良贷款一般监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"新增一般监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"完成监控")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";	
	}else if(sDealType.equals("020030020010020"))//股金置换不良贷款一般监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";	
	}else if(sDealType.equals("020030020020010"))//股金置换不良贷款重点监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"新增重点监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"完成监控")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";	
	}else if(sDealType.equals("020030020020020"))//股金置换不良贷款重点监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020030030010010"))//央行票据置换不良贷款一般监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"新增一般监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"完成监控")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
		
	}else if(sDealType.equals("020030030010020"))//央行票据置换不良贷款一般监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020030030020010"))//央行票据置换不良贷款重点监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"新增重点监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"完成监控")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020030030020020"))//央行票据置换不良贷款重点监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020030040010010"))//已核销不良贷款一般监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"新增一般监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"完成监控")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020030040010020"))//已核销不良贷款一般监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"一般监控报告详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020030040020010"))//已核销不良贷款重点监控未监控
	{
		sButtons[getBtnIdxByName(sButtons,"新增重点监控报告")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"完成监控")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020030040020020"))//已核销不良贷款重点监控已监控
	{
		sButtons[getBtnIdxByName(sButtons,"重点监控报告详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"台账信息详情")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"导出EXCEL")][0]="true";
	}else if(sDealType.equals("020040010"))//未转出
	{
		sButtons[getBtnIdxByName(sButtons,"转出")][0]="true";
	}else if(sDealType.equals("020040020"))//已转出
	{
		
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
	/*~[Describe=催收函管理;InputParam=无;OutPutParam=无;]~*/
	function dun_Note()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("DunList","/RecoveryManage/DunManage/DunList.jsp","ObjectType=BusinessContract&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=指定保全部管理人;InputParam=无;OutPutParam=无;]~*/   
	function my_Distribute()
	{
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else
		{
			//弹出对话选择框
			var sRecovery = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserChoice.jsp?ShowFlag=010","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
			{
				sRecovery = sRecovery.split("@");
				var sRecoveryUserID = sRecovery[0];
				var sRecoveryUserName = sRecovery[1];
				var sRecoveryOrgID = sRecovery[2];
				var sBadBizProjectFlag = sRecovery[3];
				
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoveryUserID@"+sRecoveryUserID+"@String@RecoveryOrgID@"+sRecoveryOrgID+"@String@BadBizProjectFlag@"+sBadBizProjectFlag+"@String@ManageFlag@010,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
						alert("该不良资产成功分发给『"+sRecoveryUserName+"』管户！");
						self.location.reload();
				}
			}
		}
	}
	
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
	
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function view_Opinions()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"RelativeSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	    popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","ObjectType=CreditApply&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=补登完成;InputParam=无;OutPutParam=无;]~*/   
	function mend_Complete()
	{
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			//验证补登信息是否填写
			sReturn=RunMethod("PublicMethod","GetColValue","BadLoanCaliber,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null") 
			{	
				alert("请进行台账信息补登后再点击!");
				return;
			}else
			{
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ManageFlag@080,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
					alert(getHtmlMessage('71'));//操作成功
					self.location.reload();
				}
			}
		}
	}
	
	/*~[Describe=完成监控;InputParam=无;OutPutParam=无;]~*/   
	function monitor_Complete()
	{
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{	
			//完成监控
			sReturnValue=RunMethod("BadBizManage","FinishMonitor",sSerialNo+",<%=sReportType%>");
			if(sReturnValue=="True")
			{
				alert(getHtmlMessage('71'));//操作成功
				self.location.reload();
			}else if(sReturnValue=="None")
			{
				alert("没有填写检查报告信息,请填写后点击!");
			}else
			{
				alert(getHtmlMessage('72'));//操作失败
			}
			
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
	
	/*~[Describe=转出;InputParam=无;OutPutParam=无;]~*/	
	function my_ReverseHandover()
	{ 
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else
		{	
			if(confirm(getBusinessMessage('785')))//您真的想将此不良资产退回给原管户人吗？
    		{	
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoveryUserID@None@String@RecoveryOrgID@None@String@ManageFlag@090,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")//刷新页面
				{
					alert(getBusinessMessage('784')); //该不良资产已成功退回给原管户人！
					self.location.reload();
				}
			}
		}
	}
	
	/*~[Describe=使用OpenComp打开终结申请详情;InputParam=无;OutPutParam=无;]~*/
	function finishApply_Info()
	{
		//获得申请类型、申请流水号
		sObjectType = "BadBizApply";
		sContractNo = getItemValue(0,getRow(),"SerialNo");
		sReturnValue = RunMethod("PublicMethod","GetColValue","SerialNo,BADBIZ_RELATIVE,String@ObjectType@FinishContract@String@ObjectNo@"+sContractNo);
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "") 
		{			
			sReturnValue = sReturnValue.split('@');
		}
		sObjectNo = sReturnValue[1];
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=查看终结审批意见;InputParam=无;OutPutParam=无;]~*/
	function finishApprove_Info()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = "BadBizApply";
		sContractNo = getItemValue(0,getRow(),"SerialNo");
		sReturnValue = RunMethod("PublicMethod","GetColValue","SerialNo,BADBIZ_RELATIVE,String@ObjectType@FinishContract@String@ObjectNo@"+sContractNo);
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "") 
		{			
			sReturnValue = sReturnValue.split('@');
		}
		sObjectNo = sReturnValue[1];
		sFlowNo = "BadBizFlow";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("ViewBadBizOpinions","/Common/WorkFlow/ViewBadBizOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
