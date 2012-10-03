<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009/08/20
		Tester:
		Content: 报告的第?页
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
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	int k = 0;   
	String sRowSubject = "";		//列主题 
	String sNewReportDate1 = "××年×月";		//最近资产负债表日期
	String sYear="",sMonth="";	

	String [] sYearReportDate = {"××年","××年","××年"};  	 //资产负债表年报日期
	String [] sYearReportNo = {"0","0","0"};     			//资产负债表年报号

	String sNewReportNo1 = "";		//最近资产负债表号
	
	int iMoneyUnit = 10000 ;  //单位万元
	double dValue = 0 ;  //最近月报资产负债表中资产总计
	double dFValue = 0 ; //最近月报资产负债表中负债合计
	//最近月报资产负债表中资产总计,货币及银行存款,应收票据,应收账款,其他应收款,材料和产成品,对外投资,固定资产,无形资产,负债合计,借入款项,应付票据及应付账款,其它应付款,应激款项,,净资产合计,事业基金,固定基金 值
	String[] sValue = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//最近月报资产负债表中资产总计,货币及银行存款,应收票据,应收账款,其他应收款,材料和产成品,对外投资,固定资产,无形资产,负债合计,借入款项,应付票据及应付账款,其它应付款,应激款项,,净资产合计,事业基金,固定基金 值
	String[] sValue1 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion1 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//最近月报资产负债表中资产总计,货币及银行存款,应收票据,应收账款,其他应收款,材料和产成品,对外投资,固定资产,无形资产,负债合计,借入款项,应付票据及应付账款,其它应付款,应激款项,,净资产合计,事业基金,固定基金 值
	String[] sValue2 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion2 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//最近月报资产负债表中资产总计,货币及银行存款,应收票据,应收账款,其他应收款,材料和产成品,对外投资,固定资产,无形资产,负债合计,借入款项,应付票据及应付账款,其它应付款,应激款项,,净资产合计,事业基金,固定基金 值
	String[] sValue3 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion3= {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	String sReportDate[] = {"","","",""};
	String sReportScopeName[] = {"","","",""};
	String sAuditOffice[] = {"","","",""};
	String sAuditFlag[] = {"","","",""};
	String sAuditOpinion[] = {"","","",""};
//****************************资产负债表***********************************************

	
//取最新资产负债表日期

	ASResultSet rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo "+
						" from REPORT_RECORD "+
						" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%1' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%1') and ReportScope = GETEVALUATESCOPE('"+sCustomerID+"',ReportDate)");
	if(rs2.next())
	{
		sYear = rs2.getString("Year");	//日期
		if(sYear == null) 
		{
			sNewReportDate1 = "××年×月";
		}
		else
		{
			sMonth = rs2.getString("Month");	//日期
			sNewReportDate1 = sYear + " 年" +sMonth+" 月";
		}
		sNewReportNo1 = rs2.getString("ReportNo");	//最近资产负债表号
		sReportDate[0] = rs2.getString("ReportDate");
	}
	
	rs2.getStatement().close();	
	
	if(!sNewReportDate1.equals("××年×月"))
	{
		rs2 = Sqlca.getResultSet("select getItemName('ReportScope',ReportScope) as ReportScopeName,AuditOffice,"+
							" getItemName('AuditInstance',AuditFlag) as AuditFlag ,getItemName('AuditOpinion',AuditOpinion) as AuditOpinion "+
							" from CUSTOMER_FSRECORD Where CustomerID = '"+sCustomerID+"' And ReportDate = '"+sReportDate[0]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sReportDate[0]+"')");
		if(rs2.next()){
			sReportScopeName[0] = rs2.getString("ReportScopeName");
			if(sReportScopeName[0] == null) sReportScopeName[0] = "";
			sAuditOffice[0] = rs2.getString("AuditOffice");
			if(sAuditOffice[0] == null) sAuditOffice[0] = "";
			sAuditOpinion[0] = rs2.getString("AuditOpinion");
			if(sAuditOpinion[0] == null) sAuditOpinion[0] = "";
			sAuditFlag[0] = rs2.getString("AuditFlag");
			if(sAuditFlag[0] == null) sAuditFlag[0] = "";
		}
		rs2.getStatement().close();	
	
		//资产总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject ='804'");
		if(rs2.next())
		{
			
			sValue[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion[0] = "100";
			dValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		//负债总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject ='809'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			//货币及银行存款
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject in ('101','136')");
			if(rs2.next())
			{
				sValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
			
			//材料和产成品
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject in ('11001','11002')");
			if(rs2.next())
			{
				sValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
				
			//对外投资		
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject in ('188','188a')");
			if(rs2.next())
			{
				sValue[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
			
			//借入款项
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject in ('275','275a')");
			if(rs2.next())
			{
				sValue[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();			

			//应付票据及应付账款
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject in ('202','203')");
			if(rs2.next())
			{
				sValue[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();					
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo1+
									 "' And RowSubject in ('103','106','108','119','19m','806','209','','160','319','320')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("103"))	//应收票据 
				{
					sValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("106"))	//应收账款
				{		
					sValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("108"))	//其他应收款
				{
					sValue[4] = DataConvert.toMoney(sValue2[2]+rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("119"))	//固定资产
				{
					sValue[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19m"))	//无形资产
				{
					sValue[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("806"))	//负债合计
				{
					sValue[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("209"))	//其它应付款
				{
					sValue[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals(""))	//应激款项
				{
					sValue[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("160"))	//净资产合计
				{
					sValue[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("319"))	//事业基金
				{
					sValue[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("320"))	//固定基金
				{
					sValue[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
			}
			rs2.getStatement().close();
		}
	}
	
//年报
	//取最新资产负债表年报日期
	rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%1'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
//		" and  ReportDate <>(select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%1')"+
		" order by Year Desc");  

	k = 0;
	while (k < 3)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//日期
			if(sYear == null) 
			{
				sYearReportDate[k] = "××年";
			}
			else
			{
				sYearReportDate[k] = sYear + " 年12月";
			}
			sYearReportNo[k] = rs2.getString("ReportNo");	//资产负债表年报号 
			sReportDate[k+1] = rs2.getString("ReportDate");
		}
		k ++;
	}
	rs2.getStatement().close();

//第一年
	if(!sYearReportDate[0].equals("××年"))
	{
		rs2 = Sqlca.getResultSet("select getItemName('ReportScope',ReportScope) as ReportScopeName,AuditOffice,"+
							" getItemName('AuditInstance',AuditFlag) as AuditFlag ,getItemName('AuditOpinion',AuditOpinion) as AuditOpinion "+
							" from CUSTOMER_FSRECORD Where CustomerID = '"+sCustomerID+"' And ReportDate = '"+sReportDate[1]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sReportDate[1]+"')");
		if(rs2.next()){
			sReportScopeName[1] = rs2.getString("ReportScopeName");
			if(sReportScopeName[1] == null) sReportScopeName[1] = "";
			sAuditOffice[1] = rs2.getString("AuditOffice");
			if(sAuditOffice[1] == null) sAuditOffice[1] = "";
			sAuditOpinion[1] = rs2.getString("AuditOpinion");
			if(sAuditOpinion[1] == null) sAuditOpinion[1] = "";
			sAuditFlag[1] = rs2.getString("AuditFlag");
			if(sAuditFlag[1] == null) sAuditFlag[1] = "";
		}
		rs2.getStatement().close();	
		//资产总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject ='804'");
		if(rs2.next())
		{
			
			sValue1[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion1[0] = "100";
			dValue = rs2.getDouble("Col2value");
		}
		else sProportion1[0] = "100";
		rs2.getStatement().close();
		//负债总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject ='809'");
		
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			//货币及银行存款
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject in ('101','136')");
			if(rs2.next())
			{
				sValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
			
			//材料和产成品
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject in ('11001','11002')");
			if(rs2.next())
			{
				sValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
				
			//对外投资		
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject in ('188','188a')");
			if(rs2.next())
			{
				sValue1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
			
			//借入款项
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject in ('275','275a')");
			if(rs2.next())
			{
				sValue1[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion1[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();			

			//应付票据及应付账款
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject in ('202','203')");
			if(rs2.next())
			{
				sValue1[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion1[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();					
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+
									 "' And RowSubject in ('103','106','108','119','19m','806','209','','160','319','320')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("103"))	//应收票据 
				{
					sValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("106"))	//应收账款
				{		
					sValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("108"))	//其他应收款
				{
					sValue1[4] = DataConvert.toMoney(sValue2[2]+rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("119"))	//固定资产
				{
					sValue1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19m"))	//无形资产
				{
					sValue1[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("806"))	//负债合计
				{
					sValue1[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("209"))	//其它应付款
				{
					sValue1[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals(""))	//应缴款项
				{
					sValue1[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("160"))	//净资产合计
				{
					sValue1[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("319"))	//事业基金
				{
					sValue1[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("320"))	//固定基金
				{
					sValue1[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
			}
			rs2.getStatement().close();
		}	
//第二年
	if(!sYearReportDate[0].equals("××年"))
	{
		rs2 = Sqlca.getResultSet("select getItemName('ReportScope',ReportScope) as ReportScopeName,AuditOffice,"+
							" getItemName('AuditInstance',AuditFlag) as AuditFlag ,getItemName('AuditOpinion',AuditOpinion) as AuditOpinion "+
							" from CUSTOMER_FSRECORD Where CustomerID = '"+sCustomerID+"' And ReportDate = '"+sReportDate[2]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sReportDate[2]+"')");
		if(rs2.next()){
			sReportScopeName[2] = rs2.getString("ReportScopeName");
			if(sReportScopeName[2] == null) sReportScopeName[2] = "";
			sAuditOffice[2] = rs2.getString("AuditOffice");
			if(sAuditOffice[2] == null) sAuditOffice[2] = "";
			sAuditOpinion[2] = rs2.getString("AuditOpinion");
			if(sAuditOpinion[2] == null) sAuditOpinion[2] = "";
			sAuditFlag[2] = rs2.getString("AuditFlag");
			if(sAuditFlag[2] == null) sAuditFlag[2] = "";
		}
		rs2.getStatement().close();	
		//资产总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='804'");
		if(rs2.next())
		{
			
			sValue2[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion2[0] = "100";
			dValue = rs2.getDouble("Col2value");
		}
		else sProportion2[0] = "100";
		rs2.getStatement().close();
		//负债总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='809'");
		
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			//货币及银行存款
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('101','136')");
			if(rs2.next())
			{
				sValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
			
			//材料和产成品
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('11001','11002')");
			if(rs2.next())
			{
				sValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
				
			//对外投资		
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('188','188a')");
			if(rs2.next())
			{
				sValue2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
			
			//借入款项
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('275','275a')");
			if(rs2.next())
			{
				sValue2[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion2[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();			

			//应付票据及应付账款
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('202','203')");
			if(rs2.next())
			{
				sValue2[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion2[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();					
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+
									 "' And RowSubject in ('103','106','108','119','19m','806','209','','160','319','320')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("103"))	//应收票据 
				{
					sValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("106"))	//应收账款
				{		
					sValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("108"))	//其他应收款
				{
					sValue2[4] = DataConvert.toMoney(sValue2[2]+rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("119"))	//固定资产
				{
					sValue2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19m"))	//无形资产
				{
					sValue2[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("806"))	//负债合计
				{
					sValue2[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("209"))	//其它应付款
				{
					sValue2[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals(""))	//应缴款项
				{
					sValue2[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("160"))	//净资产合计
				{
					sValue2[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("319"))	//事业基金
				{
					sValue2[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("320"))	//固定基金
				{
					sValue2[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
			}
			rs2.getStatement().close();
		}
	}
	
	//第三年
	if(!sYearReportDate[0].equals("××年"))
	{
		rs2 = Sqlca.getResultSet("select getItemName('ReportScope',ReportScope) as ReportScopeName,AuditOffice,"+
							" getItemName('AuditInstance',AuditFlag) as AuditFlag ,getItemName('AuditOpinion',AuditOpinion) as AuditOpinion "+
							" from CUSTOMER_FSRECORD Where CustomerID = '"+sCustomerID+"' And ReportDate = '"+sReportDate[3]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sReportDate[3]+"')");
		if(rs2.next()){
			sReportScopeName[3] = rs2.getString("ReportScopeName");
			if(sReportScopeName[3] == null) sReportScopeName[3] = "";
			sAuditOffice[3] = rs2.getString("AuditOffice");
			if(sAuditOffice[3] == null) sAuditOffice[3] = "";
			sAuditOpinion[3] = rs2.getString("AuditOpinion");
			if(sAuditOpinion[3] == null) sAuditOpinion[3] = "";
			sAuditFlag[3] = rs2.getString("AuditFlag");
			if(sAuditFlag[3] == null) sAuditFlag[3] = "";
		}
		rs2.getStatement().close();	
		//资产总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject ='804'");
		if(rs2.next())
		{
			
			sValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion3[0] = "100";
			dValue = rs2.getDouble("Col2value");
		}
		else sProportion3[0] = "100";
		rs2.getStatement().close();
		//负债总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject ='809'");
		
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			//货币及银行存款
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('101','136')");
			if(rs2.next())
			{
				sValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
			
			//材料和产成品
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('11001','11002')");
			if(rs2.next())
			{
				sValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
				
			//对外投资		
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('188','188a')");
			if(rs2.next())
			{
				sValue3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
			}
			rs2.getStatement().close();
			
			//借入款项
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('275','275a')");
			if(rs2.next())
			{
				sValue3[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion3[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();			

			//应付票据及应付账款
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('202','203')");
			if(rs2.next())
			{
				sValue3[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion3[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();					
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+
									 "' And RowSubject in ('103','106','108','119','19m','806','209','','160','319','320')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("103"))	//应收票据 
				{
					sValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("106"))	//应收账款
				{		
					sValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("108"))	//其他应收款
				{
					sValue3[4] = DataConvert.toMoney(sValue2[2]+rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("119"))	//固定资产
				{
					sValue3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19m"))	//无形资产
				{
					sValue3[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("806"))	//负债合计
				{
					sValue3[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("209"))	//其它应付款
				{
					sValue3[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals(""))	//应缴款项
				{
					sValue3[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("160"))	//净资产合计
				{
					sValue3[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("319"))	//事业基金
				{
					sValue3[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("320"))	//固定基金
				{
					sValue3[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
			}
			rs2.getStatement().close();
		}
	}
}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0701.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7、借款人财务分析-财务简表</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7.1、资产负债表结构与对比（单位：万元）</font></td>");
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
    sTemp.append("<td rowspan=2 align=center class=td1 > 项目</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sYearReportDate[0]+"</td>"); 
	sTemp.append("<td colspan=2 align=center class=td1 >"+sYearReportDate[1]+"</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sYearReportDate[2]+"&nbsp;</td>");	
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=15% align=center class=td1 > 数值（万元）</td>");
	sTemp.append("<td width=10% align=center class=td1 >%</td>");
	sTemp.append("<td width=15% align=center class=td1 > 数值（万元）</td>");
	sTemp.append("<td width=10% align=center class=td1 >%</td>");
	sTemp.append("<td width=15% align=center class=td1 >数值（万元）</td>");
	sTemp.append("<td width=10% align=center class=td1 >%</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > 报表口径 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sReportScopeName[1]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sReportScopeName[2]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sReportScopeName[3]+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > 是否已审计 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditFlag[1]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditFlag[2]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditFlag[3]+"&nbsp;</td>");
	sTemp.append("</tr>");	
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > 审计意见 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOpinion[1]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOpinion[2]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOpinion[3]+"&nbsp;</td>");
	sTemp.append("</tr>");	
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > 审计事务所名称 </td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOffice[1]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOffice[2]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOffice[3]+"&nbsp;</td>");
	sTemp.append("</tr>");				
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > 总资产 </td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue1[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion1[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue2[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion2[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue3[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion3[0]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 货币及银行存款 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[1]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 应收票据 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 应收账款</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[3]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 其他应收款 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[4]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 材料和产成品 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[5]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 对外投资 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[6]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 固定资产 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[7]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 无形资产 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[8]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 负责合计 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[9]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 借入款项</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[10]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 应付票据及应付账款 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[11]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 其它应付款 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[12]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 应缴款项 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[13]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 净资产合计 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[14]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 事业基金 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[15]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > 固定基金 </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[16]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("</table>");	
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
	