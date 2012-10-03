<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.22
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
	String sNewReportDate3 = "××年×月";		//最近现金流量表日期
	String sYear="",sMonth="";	

	String [] sxjYearReportDate = {"××年","××年","××年"};   //现金流量表年报日期
	String [] sxjYearReportNo = {"0","0","0"};     			//现金流量表年报号

	String sNewReportNo3 = "";		//最近现金流量表号
	
	//最近现金流量表月报
	String sxjValue[] = {"0","0","0","0","0","0"};

	//最近第一年现金流量表年报
	String sxjValue1[] = {"0","0","0","0","0","0"};

	//最近第二年现金流量表年报
	String sxjValue2[] = {"0","0","0","0","0","0"};

	//最近第三年现金流量表年报
	String sxjValue3[] = {"0","0","0","0","0","0"};

//*****************************************现金流量表*****************************
	//取最近现金流量表日期
	ASResultSet rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%8' And ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%8') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)");
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
			sNewReportDate3 = sYear + " 年" +sMonth+" 月";
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
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo3+"' And RowSubject in ('810','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//经营活动现金流净额
			{
				sxjValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//投资活动现金流净额
			{
				sxjValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//筹资活动现金流净额
			{
				sxjValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//净现金流量
			{
				sxjValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
	
		rs2.getStatement().close();
	}
//年报
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%8'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04')  and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
		" order by Year Desc");

	k = 0;
	while (k < 3)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//日期
			if(sYear == null) 
			{
				sxjYearReportDate[k] = "××年"+"12月";
			}
			else
			{
				sxjYearReportDate[k] = sYear + " 年12月";
			}
			sxjYearReportNo[k] = rs2.getString("ReportNo");	//资产负债表年报号
		}
		k ++;
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
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[0]+"' And RowSubject in ('810','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//经营活动现金流净额
			{
				sxjValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//投资活动现金流净额
			{
				sxjValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//筹资活动现金流净额
			{
				sxjValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//净现金流量
			{
				sxjValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
	
		rs2.getStatement().close();

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
		
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[1]+"' And RowSubject in ('810','811','812','813')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("810"))		//经营活动现金流净额
				{
					sxjValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				}
				else if (sRowSubject.equals("811"))	//投资活动现金流净额
				{
					sxjValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				}
				else if (sRowSubject.equals("812"))	//筹资活动现金流净额
				{
					sxjValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				}
				else if (sRowSubject.equals("813"))	//净现金流量
				{
					sxjValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				}
			}
			rs2.getStatement().close();

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
			
				rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[2]+"' And RowSubject in ('810','811','812','813')");
				while(rs2.next())
				{
					sRowSubject = rs2.getString("RowSubject");
					if (sRowSubject.equals("810"))		//经营活动现金流净额
					{
						sxjValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
					}
					else if (sRowSubject.equals("811"))	//投资活动现金流净额
					{
						sxjValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
					}
					else if (sRowSubject.equals("812"))	//筹资活动现金流净额
					{
						sxjValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
					}
					else if (sRowSubject.equals("813"))	//净现金流量
					{
						sxjValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
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
	sTemp.append("	<form method='post' action='040303.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.3.3、现金流</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td rowspan=2 align=center class=td1 > 项目 </td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[0]+"</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[1]+"</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[2]+"&nbsp;</td>");	
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=center class=td1 >数值(万元)</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >数值(万元)</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >数值(万元)</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 经营活动现金流入量 </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[0]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[0]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[0]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 经营活动现金流出量 </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[1]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[1]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[1]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 经营活动现金流净额 </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[2]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[2]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 投资活动现金流净额 </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[3]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[3]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[3]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> 筹资活动现金流净额 </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[4]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[4]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[4]+"</td>");
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
	