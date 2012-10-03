<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   bqliu 2011-04-29
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   
				FirstSection: 
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 4;	//这个是页面需要输入的个数，必须写对：客户化1
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
	String [] sYearReportNo2 = {"0","0","0"};  //财务指标表年报号
	
	String sNewReportNo1 = "";		//最近资产负债表号
	String sNewReportNo2 = "";      //最近财务指标表号
	
	int iMoneyUnit = 10000 ;  //单位万元
	double dValue = 0 ;  //最近月报资产负债表中资产总计
	double dFValue = 0 ; //最近月报资产负债表中负债合计
	//最近月报资产负债表中总资产,总负债,所有者权益,资产负债率,流动比率,现金比率,速动比率,债务清偿率 值
	String[] sValue = {"0","0","0","0","0","0","0","0"};
	String[] sProportion = {"0","0","0","0","0","0","0","0"};

	//最近年报资产负债表中总资产,总负债,所有者权益,资产负债率,流动比率,现金比率,速动比率,债务清偿率 值
	String[] sValue1 = {"0","0","0","0","0","0","0","0"};
	String[] sProportion1 = {"0","0","0","0","0","0","0","0"};

	//最近第二年报资产负债表中总资产,总负债,所有者权益,资产负债率,流动比率,现金比率,速动比率,债务清偿率 值
	String[] sValue2 = {"0","0","0","0","0","0","0","0"};
	String[] sProportion2 = {"0","0","0","0","0","0","0","0"};

	//最近第三年报资产负债表中总资产,总负债,所有者权益,资产负债率,流动比率,现金比率,速动比率,债务清偿率 值
	String[] sValue3 = {"0","0","0","0","0","0","0","0"};
	String[] sProportion3 = {"0","0","0","0","0","0","0","0"};

	String sReportDate[] = {"","","",""};
	
//****************************资产负债表***********************************************

	
    //取最新报表日期
    String lastDate = Sqlca.getString("select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' ");
    //取最新资产负债表日期
    ASResultSet rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo "+
						" from REPORT_RECORD "+
						" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%1' and ReportScope = GETEVALUATESCOPE('"+sCustomerID+"',ReportDate) "+
						" and Reportdate ='"+lastDate+"'" );
    
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
	
	 //取财务指标表日期
    rs2 = Sqlca.getResultSet("select ReportNo "+
			" from REPORT_RECORD "+
			" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%9' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%9') and ReportScope = GETEVALUATESCOPE('"+sCustomerID+"',ReportDate)");
    if(rs2.next())
	{
    	sNewReportNo2 = rs2.getString("ReportNo");	//最近资产负债表号
	}
    rs2.getStatement().close();	
    
	if(!sNewReportDate1.equals("××年×月"))
	{
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
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject ='807'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject in ('808')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("808"))	//所有者权益
				{
					sValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
			}
			rs2.getStatement().close();
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo2+"' And RowSubject in ('911','915','917','916')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if(sRowSubject.equals("911"))//资产负债率
				{
					sValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("915"))//流动比率
				{
					sValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("917"))//现金比率
				{
					sValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("916"))//速动比率
				{
					sValue[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
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
		" order by Year Desc");  

	k = 2;
	while (k >= 0)
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
				sYearReportDate[k] = sYear + " 年";
			}
			sYearReportNo[k] = rs2.getString("ReportNo");	//资产负债表年报号 
			sReportDate[k+1] = rs2.getString("ReportDate");
		}
		k --;
	}
	rs2.getStatement().close();

	rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
			" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%9'"+
			" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
			" order by Year Desc");  

	k = 2;
	while (k >= 0)
	{
		if(rs2.next())
		{
			sYearReportNo2[k] = rs2.getString("ReportNo");	//
		}
		k --;

	}
	rs2.getStatement().close();

    //第一年
	if(!sYearReportDate[0].equals("××年"))
	{
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
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject ='807'");
		
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject in ('808')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("808"))	//所有者权益
				{
					sValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
			}
			rs2.getStatement().close();
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo2[0]+"' And RowSubject in ('911','915','917','916')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if(sRowSubject.equals("911"))//资产负债率
				{
					sValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("915"))//流动比率
				{
					sValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("917"))//现金比率
				{
					sValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("916"))//速动比率
				{
					sValue1[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				
			}
			rs2.getStatement().close();
			
		}
	}
//第二年
	if(!sYearReportDate[1].equals("××年"))
	{
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
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='807'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('808')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("808"))	//所有者权益
				{
					sValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
			}
			rs2.getStatement().close();
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo2[1]+"' And RowSubject in ('911','915','917','916')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if(sRowSubject.equals("911"))//资产负债率
				{
					sValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("915"))//流动比率
				{
					sValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("917"))//现金比率
				{
					sValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("916"))//速动比率
				{
					sValue2[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				
			}
			rs2.getStatement().close();
			
		}
	}
//第三年
	if(!sYearReportDate[2].equals("××年"))
	{
		//资产总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject ='804'");
		if(rs2.next())
		{
			
			sValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion3[0] = "100";
			dValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		//负债总计
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject ='807'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject in ('808')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("808"))	//所有者权益
				{
					sValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
			}
			rs2.getStatement().close();
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo2[2]+"' And RowSubject in ('911','915','917','916')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if(sRowSubject.equals("911"))//资产负债率
				{
					sValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("915"))//流动比率
				{
					sValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("917"))//现金比率
				{
					sValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("916"))//速动比率
				{
					sValue3[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				
			}
			rs2.getStatement().close();
			
		}
	}
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0301.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >(三)借款人财务简表及主要财务指标</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >1、资产负债表结构与对比</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+sYearReportDate[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sYearReportDate[1]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+sYearReportDate[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sNewReportDate1+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >项目&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >总资产&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[0]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[0]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >总负债&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[1]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[1]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[1]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[1]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >所有者权益&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[2]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[2]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >资产负债率&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[3]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[3]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[3]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[3]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >流动比率&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[4]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[4]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[4]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[4]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >现金比率&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[5]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[5]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[5]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[5]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >速动比率&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[6]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[6]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[6]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[6]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >债务清偿率&nbsp;</td>");
    //sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[7]+"&nbsp;</td>");
  	//sTemp.append(" <td width=20% align=center class=td1 >"+sValue1[7]+"&nbsp;</td>");
    //sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[7]+"&nbsp;</td>");
    sTemp.append("   	<td width=20%  align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=20%  align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=20%  align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:25'",getUnitData("describe3",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=20%  align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
	sTemp.append("      &nbsp;</td>");
    sTemp.append(" </tr>");
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

