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
	
	//获得编号
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,j=0;
	String sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '050_' and ObjectType = '"+sObjectType+"'";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(j=0;j<sNo.length;j++)
	{		
		sNo1[j] = "6."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(j=0;j<sNo.length;j++)
	{
		if(sNo[j].equals(sTreeNo.substring(0,4)))  break;
	}
	

	//获得调查报告数据
	sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	String sGuarangtorID = "";//担保客户ID号
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();
	
	int k = 0;   
	String sRowSubject = "";		//列主题 
	String sNewReportDate1 = "××年×月";		//最近资产负债表日期
	String sYear="",sMonth="";	

	String [] sYearReportDate = {"××年","××年","××年"};  	 //资产负债表年报日期
	String [] sYearReportNo = {"","",""};     			//资产负债表年报号
	String [] sYearReportNo2 = {"","",""};  //财务指标表年报号
	
	String sNewReportNo1 = "";		//最近资产负债表号
	String sNewReportNo2 = "";      //最近财务指标表号
	
	int iMoneyUnit = 10000 ;  //单位万元
	double dValue = 0 ;  //最近月报资产负债表中资产总计
	double dFValue = 0 ; //最近月报资产负债表中负债合计
	//最近月报资产负债表中总资产,总负债,所有者权益,资产负债率,流动比率,现金比率,速动比率,债务清偿率 值
	String[] sValue = {"","","","","","","",""};
	String[] sProportion = {"","","","","","","",""};

	//最近年报资产负债表中总资产,总负债,所有者权益,资产负债率,流动比率,现金比率,速动比率,债务清偿率 值
	String[] sValue1 = {"","","","","","","",""};
	String[] sProportion1 = {"","","","","","","",""};

	//最近第二年报资产负债表中总资产,总负债,所有者权益,资产负债率,流动比率,现金比率,速动比率,债务清偿率 值
	String[] sValue2 = {"","","","","","","",""};
	String[] sProportion2 = {"","","","","","","",""};

	//最近第三年报资产负债表中总资产,总负债,所有者权益,资产负债率,流动比率,现金比率,速动比率,债务清偿率 值
	String[] sValue3 = {"","","","","","","",""};
	String[] sProportion3 = {"","","","","","","",""};

	String sReportDate[] = {"","","",""};
	
//****************************资产负债表***********************************************

	//取最新报表日期
    String lastDate = Sqlca.getString("select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sGuarangtorID+"'");
    
    //取最新资产负债表日期
	rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo "+
						" from REPORT_RECORD "+
						" where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%1' and ReportScope = GETEVALUATESCOPE('"+sGuarangtorID+"',ReportDate)"+
	                    " and Reportdate ='"+lastDate+"'" );

    rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo "+
			" from REPORT_RECORD "+
			" where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%1' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%1') and ReportScope = GETEVALUATESCOPE('"+sGuarangtorID+"',ReportDate)");
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
			" where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%9' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%9') and ReportScope = GETEVALUATESCOPE('"+sGuarangtorID+"',ReportDate)");
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
		" where ObjectNo ='"+sGuarangtorID+"' and ModelNo like '%1'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sGuarangtorID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sGuarangtorID+"',ReportDate)"+
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
			" where ObjectNo ='"+sGuarangtorID+"' and ModelNo like '%9'"+
			" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sGuarangtorID+"' ) and ReportScope = GETFSREPORTSCOPE('"+sGuarangtorID+"',ReportDate)"+
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
	sTemp.append("	<form method='post' action='03060208.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >8、担保人财务简表</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >(1)、资产负债表结构与对比</font></td> ");	
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
    
    //
	String sNewReportDate2 = "××年×月";		//最近损益表日期
	String [] ssyYearReportDate = {"××年","××年","××年"};   //损益表年报日期
	String [] ssyYearReportNo = {"","",""};     			//损益表年报号
	
	
	String sNewReportNo4 = "";		//最近损益表表号
	
	
	//最近损益表月报
	double dsyValue = 0;
	String ssyValue[] = {"","","","",""};
	String ssyProportion[] = {"","","","",""};
	
	//最近第一年损益表年报
	String ssyValue1[] = {"","","","",""};
	String ssyProportion1[] = {"","","","",""};
	
	//最近第二年损益表年报
	String ssyValue2[] = {"","","","",""};
	String ssyProportion2[] = {"","","","",""};
	
	//最近第三年损益表年报
	String ssyValue3[] = {"","","","",""};
	String ssyProportion3[] = {"","","","",""};
	
	//*****************************************损益表结构和对比*****************************
	//取最近损益表日期
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%2' and ReportScope = GETEVALUATESCOPE('"+sGuarangtorID+"',ReportDate)"+
	" and Reportdate ='"+lastDate+"'" );
	
	if(rs2.next())
	{
		sYear = rs2.getString("Year");	//日期
		if(sYear == null) 
		{
			sNewReportDate2 = "××年×月";
		}
		else
		{
			sMonth = rs2.getString("Month");	//日期
			sNewReportDate2 = sYear + " 年" +sMonth+" 月";
		}
		sNewReportNo4 = rs2.getString("ReportNo");	//最近损益表号
	}	
	rs2.getStatement().close();
	
	rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo4+"' And RowSubject in ('501','502','505','515','517')");
	while(rs2.next())
	{
		sRowSubject = rs2.getString("RowSubject");
		if (sRowSubject.equals("501"))		//主营业务收入
		{
			ssyValue[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			dsyValue = rs2.getDouble("Col2value");
			ssyProportion[0] = "100";		
		}
		if( dsyValue == 0) continue;
		if (sRowSubject.equals("502"))	//主营业务成本
		{
			ssyValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);	
		}
		else if (sRowSubject.equals("505"))	//主营业务利润
		{
			ssyValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
		else if (sRowSubject.equals("515"))	//利润总额
		{
			ssyValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
		else if (sRowSubject.equals("517"))	//净利润
		{
			ssyValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
	}
	rs2.getStatement().close();
	
	//年报
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sGuarangtorID+"' and ModelNo like '%2'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sGuarangtorID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sGuarangtorID+"',ReportDate)"+
		" order by Year Desc"); 
	
	k = 2;
	while (k >= 0)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//日期
			if(sYear == null) 
			{
				ssyYearReportDate[k] = "××年";
			}
			else
			{
				ssyYearReportDate[k] = sYear + " 年";
			}
			ssyYearReportNo[k] = rs2.getString("ReportNo");	//资产负债表年报号
		}
		k --;
	}
	rs2.getStatement().close();
	
	//第一年
	if (!ssyYearReportDate[0].equals("××年"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[0]+"' And RowSubject in ('501','502','505','515','517')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("501"))		//主营业务收入
			{
				ssyValue1[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				dsyValue = rs2.getDouble("Col2value");
				ssyProportion1[0] = "100";		
			}
			if( dsyValue == 0) continue;
			if (sRowSubject.equals("502"))	//主营业务成本
			{
				ssyValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("505"))	//主营业务利润
			{
				ssyValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("515"))	//利润总额
			{
				ssyValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//净利润
			{
				ssyValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
		rs2.getStatement().close();
	}
	//第二年	
	if (!ssyYearReportDate[1].equals("××年"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[1]+"' And RowSubject in ('501','502','505','515','517')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("501"))		//主营业务收入
			{
				ssyValue2[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				dsyValue = rs2.getDouble("Col2value");
				ssyProportion2[0] = "100";			
			}
			if( dsyValue == 0) continue;
			if (sRowSubject.equals("502"))	//主营业务成本
			{
				ssyValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("505"))	//主营业务利润
			{
				ssyValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("515"))	//利润总额
			{
				ssyValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//净利润
			{
				ssyValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
	    rs2.getStatement().close();
	}
    
	//第三年	
	if (!ssyYearReportDate[2].equals("××年"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[2]+"' And RowSubject in ('501','502','505','515','517') order by RowSubject ");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("501"))		//主营业务收入
			{
				ssyValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				dsyValue = rs2.getDouble("Col2value");
				ssyProportion3[0] = "100";
			}
			if( dsyValue == 0) continue;
			if (sRowSubject.equals("502"))	//主营业务成本
			{
				ssyValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("505"))	//主营业务利润
			{
				ssyValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				ssyProportion3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);
			}
			else if (sRowSubject.equals("515"))	//利润总额
			{
				ssyValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//净利润
			{
				ssyValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
		rs2.getStatement().close();
	}
		

    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >(2)、损益表结构和对比</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+ssyYearReportDate[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyYearReportDate[1]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+ssyYearReportDate[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sNewReportDate2+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >项目&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >主营业务收入&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[0]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[0]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[0]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >主营业务成本&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[1]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[1]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[1]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[1]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >主营业务利润&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[2]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[2]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[2]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >利润总额&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[3]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[3]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[3]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[3]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >净利润&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[4]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[4]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[4]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[4]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    
    
	

	String sNewReportDate3 = "××年×月";		//最近现金流量表日期
	String [] sxjYearReportDate = {"××年","××年","××年"};   //现金流量表年报日期
	String [] sxjYearReportNo = {"","",""};     			//现金流量表年报号

	String sNewReportNo3 = "";		//最近现金流量表号
	
	//最近现金流量表月报
	String sxjValue[] = {"","","","","","","","","",""};

	//最近第一年现金流量表年报
	String sxjValue1[] = {"","","","","","","","","",""};

	//最近第二年现金流量表年报
	String sxjValue2[] = {"","","","","","","","","",""};

	//最近第三年现金流量表年报
	String sxjValue3[] = {"","","","","","","","","",""};

//*****************************************现金流量表*****************************
	//取最近现金流量表日期
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%8'  and ReportScope = GETEVALUATESCOPE('"+sGuarangtorID+"',ReportDate)"+
	" and Reportdate ='"+lastDate+"'" );
	if(rs2.next())
	{
		sYear = rs2.getString("Year");	//日期
		if(sYear == null) 
		{
			sNewReportDate3 = "××年×月";
		}
		else
		{
			sMonth = rs2.getString("Month");	//日期
			sNewReportDate3 = sYear + " 年"+sMonth+" 月";
		}
		sNewReportNo3 = rs2.getString("ReportNo");	//最近现金流量表号
	}
	
	rs2.getStatement().close();

	if (!sNewReportDate3.equals("××年×月"))
	{
	 	//经营活动现金流入量	RowSubject 为a20
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo3+"' And RowSubject ='a20'");
		if(rs2.next())
		{
			sxjValue[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		//经营活动现金流出量	RowSubject 为a27
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo3+"' And RowSubject ='a27'");
		if(rs2.next())
		{
			sxjValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo3+"' And RowSubject in ('810','a33','a38','a43','a50','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//经营活动现金流净额
			{
				sxjValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a33"))	//投资活动现金流入量
			{
				sxjValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a38"))	//投资活动现金流出量
			{
				sxjValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//投资活动现金流净额
			{
				sxjValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a43"))	//筹资活动现金流入量
			{
				sxjValue[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a50"))	//筹资活动现金流出量
			{
				sxjValue[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//筹资活动现金流净额
			{
				sxjValue[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//现金及现金等价物净增加额
			{
				sxjValue[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
	
		rs2.getStatement().close();
	}
//年报
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sGuarangtorID+"' and ModelNo like '%8'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sGuarangtorID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sGuarangtorID+"',ReportDate)"+
		" order by Year Desc");

	k = 2;
	while (k >= 0)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//日期
			if(sYear == null) 
			{
				sxjYearReportDate[k] = "××年";
			}
			else
			{
				sxjYearReportDate[k] = sYear + " 年";
			}
			sxjYearReportNo[k] = rs2.getString("ReportNo");	//资产负债表年报号
		}
		k --;
	}
	rs2.getStatement().close();

//第一年
	if (!sxjYearReportDate[0].equals("××年"))
	{
	 	//经营活动现金流入量	RowSubject 为a20
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[0]+"' And RowSubject = 'a20'");
		if(rs2.next())
		{
			sxjValue1[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		//经营活动现金流出量	RowSubject 为a27
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[0]+"' And RowSubject = 'a27'");
		if(rs2.next())
		{
			sxjValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[0]+"' And RowSubject in ('810','a33','a38','a43','a50','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//经营活动现金流净额
			{
				sxjValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a33"))	//投资活动现金流入量
			{
				sxjValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a38"))	//投资活动现金流出量
			{
				sxjValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//投资活动现金流净额
			{
				sxjValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a43"))	//筹资活动现金流入量
			{
				sxjValue1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a50"))	//筹资活动现金流出量
			{
				sxjValue1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//筹资活动现金流净额
			{
				sxjValue1[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//现金及现金等价物净增加额
			{
				sxjValue1[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
	
		rs2.getStatement().close();
	}
//第二年
	if (!sxjYearReportDate[1].equals("××年"))
	{
	 	//经营活动现金流入量	RowSubject 为a20
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[1]+"' And RowSubject = 'a20'");
		if(rs2.next())
		{
			sxjValue2[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		//经营活动现金流出量	RowSubject 为a27
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[1]+"' And RowSubject = 'a27'");
		if(rs2.next())
		{
			sxjValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[1]+"' And RowSubject in ('810','a33','a38','a43','a50','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//经营活动现金流净额
			{
				sxjValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a33"))	//投资活动现金流入量
			{
				sxjValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a38"))	//投资活动现金流出量
			{
				sxjValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//投资活动现金流净额
			{
				sxjValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a43"))	//筹资活动现金流入量
			{
				sxjValue2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a50"))	//筹资活动现金流出量
			{
				sxjValue2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//筹资活动现金流净额
			{
				sxjValue2[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//现金及现金等价物净增加额
			{
				sxjValue2[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
		rs2.getStatement().close();
	}
//第三年
	if (!sxjYearReportDate[2].equals("××年"))
	{
	 	//经营活动现金流入量	RowSubject 为a20
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[2]+"' And RowSubject = 'a20'");
		if(rs2.next())
		{
			sxjValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		//经营活动现金流出量	RowSubject 为a27
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[2]+"' And RowSubject = 'a27'");
		if(rs2.next())
		{
			sxjValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[2]+"' And RowSubject in ('810','a33','a38','a43','a50','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//经营活动现金流净额
			{
				sxjValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a33"))	//投资活动现金流入量
			{
				sxjValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a38"))	//投资活动现金流出量
			{
				sxjValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//投资活动现金流净额
			{
				sxjValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a43"))	//筹资活动现金流入量
			{
				sxjValue3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a50"))	//筹资活动现金流出量
			{
				sxjValue3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//筹资活动现金流净额
			{
				sxjValue3[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//现金及现金等价物净增加额
			{
				sxjValue3[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
		rs2.getStatement().close();
	}
		
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >(3)、现金流对比</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% rowspan=2 align=center class=td1 >项目&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+sxjYearReportDate[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjYearReportDate[1]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+sxjYearReportDate[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sNewReportDate3+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >数值（万元）&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >经营活动现金流入量&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[0]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[0]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >经营活动现金流出量&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[1]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[1]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[1]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[1]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 ><font style='FONT-FAMILY:宋体;FONT-WEIGHT: bold;' >经营活动现金流净额&nbsp;</font></td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[2]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[2]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >投资活动现金流入量&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[3]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[3]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[3]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[3]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >投资活动现金流出量&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[4]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[4]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[4]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[4]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 ><font style='FONT-FAMILY:宋体;FONT-WEIGHT: bold;' >投资活动现金流净额&nbsp;</font></td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[5]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[5]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[5]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[5]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >筹资活动现金流入量&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[6]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[6]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[6]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[6]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >筹资活动现金流出量&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[7]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[7]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[7]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[7]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 ><font style='FONT-FAMILY:宋体;FONT-WEIGHT: bold;' >筹资活动现金流净额&nbsp;</font></td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[8]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[8]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[8]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[8]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 ><font style='FONT-FAMILY:宋体;FONT-WEIGHT: bold;' >现金及现金等价物净增加额&nbsp;</font></td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[9]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[9]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[9]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[9]+"&nbsp;</td>");
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

