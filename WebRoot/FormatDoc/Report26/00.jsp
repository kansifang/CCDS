<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2011/03/21
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 33;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据
	String sInputOrgName = "";
	String sCustomerName = "";
	String sCorpID = "";
	String sRegisterCapital = "";//RCCurrency 注册资本币种
	String sRegisterAdd = "";//注册地址
	String sApplyType = "";//授信方式
	String sBusinessTypeName = "";
	String sBusinessSum = "";
	String sBusinessCurrencyName = "";
	String sTermMonth = "";
	String sBusinessRate = "";//利率/费率
	String sBailRatio = "";
	String sCycleFlag = "";//是否可循环
	String sVouchTypeName = "";
	String sPurpose = "";
	String sActualBusiness = "";
	String sIndustryTypeName = "";//国标行业分类
	String sScopeName = "";//企业规模
	String sSetupDate = "";//企业成立时间
	String sOwnStockholder="否";//是否我行股东
	String sCustomerType = "";//客户类型
	String[] sGuarantyTypeNameValue = {"","",""};//质押物名称
	String[] sOwnerNameValue = {"","",""};//出质人
	String[] sCertIDValue = {"","",""};//出质人证件号码
	String[] sEvalNetValue = {"","",""};//质押物价值
	String[] sGuarantyRightID = {"","",""};//质押凭证编号
	String[] sBeginDate = {"","",""};//质押到期日
	String sTempBeginDate = "";//质押到期日
	String[] sGuarantyRate = {"","",""};//质押率
	String sSex = "";//性别
	String sBirthday = "";//出生日期
	String sNativePlace = "";//籍贯
	String sIndCertID = "";//身份证
	String sFamilyAdd = "";//家庭住址
	String sEduExperience = "";//学历
	String sMarriage = "";//婚姻状况
	String sPopulationNum = "";//家庭人口数
	String sWorkCorp = "";//单位名称
	String sUnitKind = "";//单位所属行业
	String sHeadShip = "";//职务
	String sMonthIncome = "";//个人月收入
	String sFamilyMonthIncome = "";//家庭月收入
	String sWorkCorpUnitKind = "";
	int iAge = 0;//年龄
	int iGuarantyCount = 0;//质押物计数
	String sReportNo = "";//最近一期财务报表编号
	String sTotalAssetSum = "";//总资产
	String sTotalDebtSum = "";//总负债
	String sOwnerInterests = "";//所有者权益
	double dAssetDebtRate = 0.00;//资产负债率
	String sRetainedProfits = "";//净利润
	String sLastReportNo = "";//上一年财务报表编号
	String sMainIncome = "";//上一年主营业务收入
	//申请信息
	String sSql = " select CustomerID,getCustomerType(CustomerID) as CustomerType ,"+
				  " getItemName('BusinessApplyType',ApplyType) as ApplyType,"+
				  " getBusinessName(BusinessType) as BusinessTypeName, "+
				  " BusinessSum/10000 as BusinessSum,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName,TermMonth,"+
				  " nvl(BusinessRate,PdgRatio) as BusinessRate, BailRatio,getItemName('VouchType',VouchType) as VouchTypeName,"+
				  " Purpose,getItemName('YesNo',CycleFlag) as CycleFlag,getOrgName(InputOrgID) as InputOrgName "+
				  " from Business_Apply where SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
		if(sCustomerID == null) sCustomerID = "";
		sApplyType = rs.getString("ApplyType");
		if(sApplyType == null) sApplyType = " ";
		sBusinessTypeName = rs.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum"));
		if(sBusinessSum == null) sBusinessSum = "";
		sBusinessCurrencyName = rs.getString("BusinessCurrencyName");
		if(sBusinessCurrencyName == null) sBusinessCurrencyName = "";
		sTermMonth = rs.getString("TermMonth");
		if(sTermMonth == null) sTermMonth = "";
		sBusinessRate = DataConvert.toString(rs.getDouble("BusinessRate"));
		if(sBusinessRate == null) sBusinessRate = "";
		sBailRatio = DataConvert.toString(rs.getDouble("BailRatio"));
		if(sBailRatio == null) sBailRatio = "";
		sVouchTypeName = rs.getString("VouchTypeName");
		if(sVouchTypeName == null) sVouchTypeName = "";
		sPurpose = rs.getString("Purpose");
		if(sPurpose == null) sPurpose = "";
		sCycleFlag = rs.getString("CycleFlag");
		if(sCycleFlag == null) sCycleFlag = "";	
		sInputOrgName = rs.getString("InputOrgName");
		if(sInputOrgName == null) sInputOrgName = "";
		sCustomerType =  rs.getString("CustomerType");
		if(sCustomerType == null) sCustomerType = "";
	}
	rs.getStatement().close();	
	//客户基本信息
	if(sCustomerType.startsWith("01"))//公司客户
	{
		//公司客户信息
		sSql = " select getCustomerName(CustomerID) as CustomerName,CorpID,nvl(RegisterCapital,0)*getErate(RCCurrency,'01','') as RegisterCapital, "+
			   " RegisterAdd,ActualBusiness,getItemName('IndustryType',IndustryType) as IndustryTypeName,"+
			   " getItemName('Scope',Scope)  as ScopeName,SetupDate "+
			   " from Ent_Info where CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			if(sCustomerName == null) sCustomerName = "";
			sCorpID = rs.getString("CorpID");
			if(sCorpID == null) sCorpID = "";
			sRegisterCapital = DataConvert.toMoney(rs.getDouble("RegisterCapital"));
			if(sRegisterCapital == null) sRegisterCapital = "";
			sRegisterAdd = rs.getString("RegisterAdd");
			if(sRegisterAdd == null) sRegisterAdd = "";
			sActualBusiness = rs.getString("ActualBusiness");
			if(sActualBusiness == null) sActualBusiness = "";	
			sIndustryTypeName = rs.getString("IndustryTypeName");
			if(sIndustryTypeName == null) sIndustryTypeName = "";
			sScopeName = rs.getString("ScopeName");
			if(sScopeName == null) sScopeName = "";
			sSetupDate = rs.getString("SetupDate");
			if(sSetupDate == null) sSetupDate = "";
			
		}	   
		rs.getStatement().close();
		//是否我行股东
		sSql = " select 1 from CUSTOMER_SPECIAL where SectionType='50' and CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sOwnStockholder="是";
		}	   
		rs.getStatement().close();
		//公司客户最近一期的财务情况资产负债表
		ASResultSet rs2 = Sqlca.getResultSet("select ReportNo from REPORT_RECORD " +
		" where ObjectNo ='"+sCustomerID+"' And ReportDate = (select max(Reportdate) "+
		"from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' and  ModelNo like '%1') "+
		" and ModelNo like '%1' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)");
		if(rs2.next())
		{
			sReportNo = rs2.getString("ReportNo");	//最近现金流量表号
		}
		rs2.getStatement().close();
		
		//总资产
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sReportNo+"' And RowSubject ='804'");
		if(rs2.next())
		{
			sTotalAssetSum = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
		//总负债
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sReportNo+"' And RowSubject ='807'");
		if(rs2.next())
		{
			sTotalDebtSum = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
		//所有者权益
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sReportNo+"' And RowSubject ='808'");
		if(rs2.next())
		{
			sOwnerInterests = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
		
		//公司客户最近一期的财务情况财务指标表
		 rs2 = Sqlca.getResultSet("select ReportNo from REPORT_RECORD " +
		" where ObjectNo ='"+sCustomerID+"' And ReportDate = (select max(Reportdate) "+
		"from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' and  ModelNo like '%9') "+
		" and ModelNo like '%9' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)");
		if(rs2.next())
		{
			sReportNo = rs2.getString("ReportNo");	//最近现金流量表号
		}
		rs2.getStatement().close();

		//资产负债率
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sReportNo+"' And RowSubject ='911'");
		if(rs2.next())
		{
			dAssetDebtRate = rs2.getDouble("Col2value");		
		}
		rs2.getStatement().close();
		
		//公司客户最近一期的财务情况损益表
		 rs2 = Sqlca.getResultSet("select ReportNo from REPORT_RECORD " +
		" where ObjectNo ='"+sCustomerID+"' And ReportDate = (select max(Reportdate) "+
		"from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' and  ModelNo like '%2') "+
		" and ModelNo like '%2' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)");
		if(rs2.next())
		{
			sReportNo = rs2.getString("ReportNo");	//最近现金流量表号
		}
		rs2.getStatement().close();
		//净利润
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sReportNo+"' And RowSubject ='517'");
		if(rs2.next())
		{
			sRetainedProfits = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
		
		//上一年主营业务收入损益表
		//上年年报
		rs2 = Sqlca.getResultSet("select ReportNo from REPORT_RECORD "+
			" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%2'"+
			" and ReportDate like '"+(Integer.parseInt(StringFunction.getToday().substring(0,4))-1)+"%'"+
			" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04')  and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
			" order by ReportDate Desc");
		if(rs2.next())
		{
			sLastReportNo = rs2.getString("ReportNo");	//最近现金流量表号
		}
		rs2.getStatement().close();
		//主营业务收入
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sLastReportNo+"' And RowSubject ='501'");
		if(rs2.next())
		{
			sMainIncome= DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	}else{//个人客户
		sSql = " select getCustomerName(CustomerID) as CustomerName,Birthday,getItemName('Sex',Sex) as Sex,NativePlace,CertID,FamilyAdd,"+
				" getItemName('EducationExperience',EduExperience) as EduExperience,"+
				" getItemName('Marriage',Marriage) as Marriage,"+
				" PopulationNum,WorkCorp,getItemName('IndustryType',UnitKind) as UnitKind,"+
				" getItemName('HeadShip',HeadShip) as HeadShip,YearIncome,FamilyMonthIncome "+
			   " from IND_INFO where CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			if(sCustomerName == null) sCustomerName = "";
			sBirthday = rs.getString("Birthday");
			if(sBirthday == null) sBirthday = "";
			if(!"".equals(sBirthday) && !" ".equals(sBirthday))
			{
				iAge = Integer.parseInt(StringFunction.getToday().substring(0,4))-Integer.parseInt(sBirthday.substring(0,4));
			}		
			sSex = rs.getString("Sex");
			if(sSex == null) sSex = "";
			sNativePlace = rs.getString("NativePlace");
			if(sNativePlace == null) sNativePlace = "";
			sIndCertID = rs.getString("CertID");
			if(sIndCertID == null) sIndCertID = "";
			sFamilyAdd = rs.getString("FamilyAdd");
			if(sFamilyAdd == null) sFamilyAdd = "";
			sEduExperience = rs.getString("EduExperience");
			if(sEduExperience == null) sEduExperience = "";	
			sMarriage = rs.getString("Marriage");
			if(sMarriage == null) sMarriage = "";
			sPopulationNum = rs.getString("PopulationNum");
			if(sPopulationNum == null) sPopulationNum = "";
			sWorkCorp = rs.getString("WorkCorp");
			if(sWorkCorp == null) sWorkCorp = "";
			sUnitKind = rs.getString("UnitKind");
			if(sUnitKind == null) sUnitKind = "";
			sWorkCorpUnitKind = sWorkCorp+"/"+sUnitKind;
			sHeadShip = rs.getString("HeadShip");
			if(sHeadShip == null) sHeadShip = "";
			sMonthIncome = DataConvert.toMoney(rs.getDouble("YearIncome")/12);
			if(sMonthIncome == null) sMonthIncome = "";
			sFamilyMonthIncome = DataConvert.toMoney(rs.getDouble("FamilyMonthIncome"));
			if(sFamilyMonthIncome == null) sFamilyMonthIncome = "";
			
		}	   
		rs.getStatement().close();
		//是否我行股东
		sSql = " select 1 from CUSTOMER_SPECIAL where SectionType='50' and CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sOwnStockholder="是";
		}	   
		rs.getStatement().close();
	}
	//质押物详情
	sSql = " select getItemName('GuarantyList',GI.GuarantyType) as GuarantyTypeName, "+
		" GI.OwnerName,GI.CertID,GI.EvalNetValue,GI.GuarantyRightID,GI.BeginDate,GI.OwnerTime,GI.GuarantyRate "+
		" from GUARANTY_RELATIVE GR,GUARANTY_INFO GI "+
		" where GR.GuarantyID=GI.GuarantyID and GR.ObjectType='CreditApply'"+
		" and GuarantyType like '020%' "+
		" and ObjectNo='"+sObjectNo+"' fetch first 3 rows only";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sGuarantyTypeNameValue[iGuarantyCount] = rs.getString("GuarantyTypeName");
		sOwnerNameValue[iGuarantyCount] = rs.getString("OwnerName");
		sCertIDValue[iGuarantyCount] = rs.getString("CertID");
		sEvalNetValue[iGuarantyCount] = DataConvert.toMoney(rs.getDouble("EvalNetValue")/10000);
		sGuarantyRightID[iGuarantyCount] = rs.getString("GuarantyRightID");
		sTempBeginDate = rs.getString("OwnerTime");
		if(sTempBeginDate == null) sTempBeginDate = "";
		sBeginDate[iGuarantyCount] = sTempBeginDate;
		sGuarantyRate[iGuarantyCount] = rs.getString("GuarantyRate");
		iGuarantyCount =iGuarantyCount+1;
	}	   
	rs.getStatement().close();
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=16 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >天津农村商业银行股份有限公司</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=16 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >低风险授信业务调查暨审批报告</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >呈报行：</td>");
    sTemp.append(" <td colspan=16' align=left class=td1 >"+sInputOrgName+"&nbsp;&nbsp;</td>");
    sTemp.append(" </tr>");
    
    
    
	if(sCustomerType.startsWith("01"))//公司客户
	{ 
	    //公司客户详情
	    sTemp.append("   <tr>");	
	    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >公司客户基本信息</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='2' align=center class=td1 >客户名称</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >客户组织机构代码</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sCorpID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='2' align=center class=td1 >注册地点</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sRegisterAdd+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >注册资本（万元）</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sRegisterCapital+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='2' align=center class=td1 >行业分类</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sIndustryTypeName+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >企业规模</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sScopeName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='2' align=center class=td1 >成立时间</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sSetupDate+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >是否为我行股东</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sOwnStockholder+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='2' align=center class=td1 >主营业务</td>");
		sTemp.append(" 		<td colspan='14' align=left class=td1 >"+sActualBusiness+"&nbsp;</td>");
		sTemp.append("   </tr>");
		
		 //财务情况概述 （单位：万元）
	    sTemp.append("   <tr>");	
	    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >财务情况概述 （单位：万元）</font></td>");
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >总资产</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >总负债</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >所有者权益</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >资产负债率</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >上一年主营业务收入</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >净利润</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >"+sTotalAssetSum+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sTotalDebtSum+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >"+sOwnerInterests+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+dAssetDebtRate+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >"+sMainIncome+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sRetainedProfits+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}else{
		 //个人客户详情
	    sTemp.append("   <tr>");	
	    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >个人客户基本信息</font></td>");
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >申请人姓名</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >年龄</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+iAge+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >性别</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sSex+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >户籍所在地</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sNativePlace+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >身份证号</td>");
		sTemp.append(" 		<td colspan='8' align=left class=td1 >"+sIndCertID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >家庭住址</td>");
		sTemp.append(" 		<td colspan='13' align=left class=td1 >"+sFamilyAdd+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >学历</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sEduExperience+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >婚姻状况</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sMarriage+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >家庭人口</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sPopulationNum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >工作单位/行业</td>");
		sTemp.append(" 		<td colspan='7' align=left class=td1 >"+sWorkCorpUnitKind+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >职务/经营规模</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sHeadShip+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >月收入</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sMonthIncome+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >家庭月收入</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sFamilyMonthIncome+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >家庭月支出</td>");
		sTemp.append("   <td  colspan='3' align=left class=td1>");
		sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:100%; height:30'",getUnitData("describe0",sData)));
		sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	
	
	 //申请人在我行现有授信
    sTemp.append("   <tr>");	
    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >申请人在我行现有授信</font></td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='4' align=center class=td1 >授信品种</td>");
	sTemp.append(" 		<td colspan='3' align=left class=td1 >金额（万元）</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >币种</td>");
	sTemp.append(" 		<td colspan='2' align=left class=td1 >期限（月）</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >利/费率</td>");
	sTemp.append(" 		<td colspan='3' align=left class=td1 >保证金比例（%）</td>");
	sTemp.append("   </tr>");
	//未结清授信业务
	sSql = " select getBusinessName(BusinessType) as BusinessTypeName, "+
			" BusinessSum,getItemName('Currency',BusinessCurrency) as Currency,"+
			" TermMonth,BusinessRate,BailRatio "+
		" from BUSINESS_CONTRACT  where  (FinishDate = '' or FinishDate is null)  and (BusinessType like '1%'  or BusinessType like '2%' ) and CustomerID = '"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sTemp.append("   <tr>");
		sTemp.append(" 		<td colspan='4' align=left class=td1 >"+rs.getString(1)+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+DataConvert.toMoney(rs.getDouble(2)/10000)+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+rs.getString(3)+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+rs.getInt(4)+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+rs.getDouble(5)+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+rs.getDouble(6)+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}	   
	rs.getStatement().close();
	
	
	  //申请信息
    sTemp.append("   <tr>");	
    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >申请信息</font></td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='4' align=center class=td1 >授信品种</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >金额(万元)</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >币种</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >期限(月)</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >利/费</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >保证金比例（%）</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan='4' align=left class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sBusinessCurrencyName+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sTermMonth+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sBusinessRate+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sBailRatio+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append(" <td colspan='2' align=left class=td1 height=30 >授信用途：</td>");
	sTemp.append(" <td colspan='14' align=left class=td1 height=30 >"+sPurpose+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >申请授信与经营情况是否相符</td>");
    sTemp.append(" 		<td colspan='5' align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe1'",getUnitData("describe1",sData),"是&nbsp;&nbsp;&nbsp;&nbsp;@否"));
	sTemp.append("      </td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >贸易（工程）合同是否真实</td>");
    sTemp.append(" 		<td colspan='5' align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe2'",getUnitData("describe2",sData),"是&nbsp;&nbsp;&nbsp;&nbsp;@否"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" <td colspan='2' align=left class=td1 height=30 >还款来源：</td>");
  	sTemp.append("   <td  colspan='14' align=left class=td1 height=30 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:100%'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" <td colspan='7' align=left class=td1 height=30 >按规定对流动资金需求量测算结果（万元）：（流动资金贷款必须填写）</td>");
	sTemp.append("   <td  colspan='9' align=left class=td1 height=30 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:100%'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	
	//质押物情况
	sTemp.append("   <tr>");	
    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >质押物情况</font></td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >名称</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >出质人</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >出质人</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >出质人</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >质押物名称</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sGuarantyTypeNameValue[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyTypeNameValue[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyTypeNameValue[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >出质人</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sOwnerNameValue[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sOwnerNameValue[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sOwnerNameValue[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >出质人组织代码</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sCertIDValue[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sCertIDValue[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sCertIDValue[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >出质意愿是否真实</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:30'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:30'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:30'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >共有人是否同意出质</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:30'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:30'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:30'",getUnitData("describe10",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >质押物金额（万元）</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sEvalNetValue[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sEvalNetValue[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sEvalNetValue[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >质押凭证编号</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sGuarantyRightID[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyRightID[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyRightID[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >质押物到期日</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sBeginDate[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sBeginDate[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sBeginDate[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >质押率（%）</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sGuarantyRate[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyRate[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyRate[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >质物权属是否清晰</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:30'",getUnitData("describe11",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:30'",getUnitData("describe12",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:30'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >是否办理质押手续</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:30'",getUnitData("describe14",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:30'",getUnitData("describe15",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:30'",getUnitData("describe16",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	
	
	//保证金情况
	sTemp.append("   <tr>");	
    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >保证金情况</font></td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='4' align=center class=td1 >保证金金额（万元）</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >保证金存入行</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >保证金存入日期</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >保证金到期日</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >单位定期存款开户证实书编号</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:30'",getUnitData("describe17",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='3' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:100%; height:30'",getUnitData("describe18",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='2' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:100%; height:30'",getUnitData("describe19",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='3' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:100%; height:30'",getUnitData("describe20",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:100%; height:30'",getUnitData("describe21",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	
	
	//委托贷款情况
	sTemp.append("   <tr>");	
    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >委托贷款情况</font></td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >委托人</td>");
	sTemp.append("   <td  colspan='13' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:100%; height:30'",getUnitData("describe22",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >组织代码</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe23' style='width:100%; height:30'",getUnitData("describe23",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >注册资金（万元）</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe24' style='width:100%; height:30'",getUnitData("describe24",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >本行开户行</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe25' style='width:100%; height:30'",getUnitData("describe25",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >账号</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe26' style='width:100%; height:30'",getUnitData("describe26",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >账户余额（万元）</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe27' style='width:100%; height:30'",getUnitData("describe27",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >账户余额是否大于委托贷款金额</td>");
    sTemp.append(" 		<td colspan='5' align=center class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe28' style='width:100%; height:30'",getUnitData("describe28",sData)));
	//sTemp.append(myOutPutCheck("5",sMethod,"name='describe28'",getUnitData("describe28",sData),"是&nbsp;&nbsp;&nbsp;&nbsp;@否"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >借款人</td>");
	sTemp.append("   <td  colspan='13' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe29' style='width:100%; height:30'",getUnitData("describe29",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >组织代码</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe30' style='width:100%; height:30'",getUnitData("describe30",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >注册资金（万元）</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe31' style='width:100%; height:30'",getUnitData("describe31",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >本行开户行</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe32' style='width:100%; height:30'",getUnitData("describe32",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >账号</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe33' style='width:100%; height:30'",getUnitData("describe33",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=16 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >调查、审查、审批意见</font></td> ");	
	sTemp.append("   </tr>");	
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >主办客户经理调查意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >协办客户经理意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >二级支行行长意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字（盖章）:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >中心支行风险管理部审查人员意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >中心支行风险管理部负责人意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >中心支行授信执行官意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字（盖章）:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >直属支行审查人员意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >直属支行行长意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字（盖章）:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >国际业务部审查人员意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >国际业务部门负责人意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字（盖章）:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >总行授信管理部审查人员意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >总行授信管理部负责人意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字（盖章）:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >总行分管行长意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字（盖章）:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >行长意见</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >签字（盖章）:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >日期:</td>");
    sTemp.append(" </tr>");
    
	
    
    
	sTemp.append("</table>");
	sTemp.append("<br/><br/><br/><br/>");
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='"+CurComp.ClientID+"'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='"+CurPage.ClientID+"'>");
	sTemp.append("</form>");	



	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludeFDFooter.jsp"%>

<script language=javascript>
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//客户化3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

