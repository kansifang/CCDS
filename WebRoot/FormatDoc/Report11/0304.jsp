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
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	double dValue = 0;//应收总额
	double Unit=10000;//金额（单位）,默认为万元
	
	double d010 = 0.0;//应收账款总额
	String[] sysValue = {"0","0","0","0"};
	String[] sProportion = {"0","0","0","0"};
	double d015 = 0.0;//其他应收款总额
	String[] sysValue1 = {"0","0","0","0"};
	String[] sProportion1 = {"0","0","0","0"};
	String sReportDate = "";  	 //资产负债表年报日期
	String sYear = "xx";
	String sMonth = "xx";
	String sNewReportDate3 = "";
	
	ASResultSet rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportDate from CUSTOMER_FSRECORD "+
			" where CustomerID ='"+sCustomerID+"' "+
			//" and ReportPeriod='04' and AuditFlag in ('2','3')"+
			" order by ReportDate Desc");  
	
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
		sReportDate = rs2.getString("ReportDate");
	}
	rs2.getStatement().close();
    
    
	//获得应收总额
	rs2 = Sqlca.getResultSet("select sum(FOASum) from ENT_FOA where FOAType in ('01','02') and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'");
	if(rs2.next())
	{
		dValue = rs2.getDouble(1)/Unit;
	}
	rs2.getStatement().close();
	
	if(dValue >0 )
	{
	String sAccountYears = "";
	//应收账款分析(应收账款总额)
	String sSql1="select sum(FOASum) from ENT_FOA" 
		         +" where FOAType='01'"
		         +" and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
	rs2 = Sqlca.getResultSet(sSql1);
	if(rs2.next())
	{
		d010 = rs2.getDouble(1)/Unit;
		sysValue[3] = DataConvert.toMoney(d010);
		sProportion[3] = DataConvert.toMoney(d010/dValue*100);
	}
	rs2.getStatement().close();   
	     
	String sSql2="select AccountYears,sum(FOASum) from ENT_FOA" 
		         +" where FOAType='01'"
		         +" and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'" 
		         +" group by AccountYears";
	if(d010>0)
	{
		rs2 = Sqlca.getResultSet(sSql2);
		while(rs2.next()) 
		{
			sAccountYears = rs2.getString(1);
			double dysValue = 0.0;
			if(sAccountYears.equals("01"))
			{
				sysValue[0] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion[0] = DataConvert.toMoney(dysValue/d010*100);
			}
			else if(sAccountYears.equals("02"))
			{
				sysValue[1] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion[1] = DataConvert.toMoney(dysValue/d010*100);
			}
			else if(sAccountYears.equals("03"))
			{
				sysValue[2] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion[2] = DataConvert.toMoney(dysValue/d010*100);
			}
		}
		rs2.getStatement().close();
	}
	
	//应收账款分析(其他应收款)
	String sSql3="select sum(FOASum) from ENT_FOA" 
		         +" where FOAType='02'"
		         +" and CustomerID = '"+sCustomerID+"'";  
	rs2 = Sqlca.getResultSet(sSql3);
	if(rs2.next())
	{
		d015 = rs2.getDouble(1)/Unit;
		sysValue1[3] = DataConvert.toMoney(d015);
		sProportion1[3] = DataConvert.toMoney(d015/dValue*100);
	}
	rs2.getStatement().close(); 
	
	String sSql4="select AccountYears,sum(FOASum) from ENT_FOA" 
		         +" where FOAType='02'"
		         +" and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'"  
		         +" group by AccountYears";
	if(d015>0)
	{         
		rs2 = Sqlca.getResultSet(sSql4);
		while(rs2.next())
		{
			sAccountYears = rs2.getString(1);
			double dysValue = 0.0;
			if(sAccountYears.equals("01"))
			{
				sysValue1[0] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion1[0] = DataConvert.toMoney(dysValue/d015*100);
			}
			else if(sAccountYears.equals("02"))
			{
				sysValue1[1] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion1[1] = DataConvert.toMoney(dysValue/d015*100);
			}
			else if(sAccountYears.equals("03"))
			{
				sysValue1[2] = DataConvert.toMoney(rs2.getDouble(2)/Unit);
				dysValue = rs2.getDouble(2)/Unit;
				sProportion1[2] = DataConvert.toMoney(dysValue/d015*100);
			}
		}
		rs2.getStatement().close();
	}
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0304.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=9 ><font style=' font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >4、应收款项分析("+sNewReportDate3+")</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >账龄分析&nbsp;</td>");
    sTemp.append(" <td colspan=2 align=center class=td1 >1年（含）以下&nbsp;</td>");
  	sTemp.append(" <td colspan=2 align=center class=td1 >1-2年（含）&nbsp;</td>");
    sTemp.append(" <td colspan=2 align=center class=td1 >2年以上&nbsp;</td>");
  	sTemp.append(" <td colspan=2 align=center class=td1 >合计&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >&nbsp;</td>");
    sTemp.append(" <td width=15% align=center class=td1 >金额（万元）&nbsp;</td>");
  	sTemp.append(" <td width=5% align=center class=td1 >%&nbsp;</td>");
  	sTemp.append(" <td width=15% align=center class=td1 >金额（万元）&nbsp;</td>");
  	sTemp.append(" <td width=5% align=center class=td1 >%&nbsp;</td>");
  	sTemp.append(" <td width=15% align=center class=td1 >金额（万元）&nbsp;</td>");
  	sTemp.append(" <td width=5% align=center class=td1 >%&nbsp;</td>");
  	sTemp.append(" <td width=15% align=center class=td1 >金额（万元）&nbsp;</td>");
  	sTemp.append(" <td width=5% align=center class=td1 >%&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <td align=center class=td1 > 应收账款</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue[0]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sProportion[0]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue[1]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sProportion[1]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue[2]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sProportion[2]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue[3]+"</td>");
	sTemp.append("	 <td align=center class=td1 >"+sProportion[3]+"</td>");
    sTemp.append("  </tr>");
   	
	sTemp.append("  <tr>");
	sTemp.append("   <td  align=center class=td1 > 其他应收款</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue1[0]+"</td>");
    sTemp.append("   <td  align=center class=td1 >"+sProportion1[0]+"</td>");
    sTemp.append("   <td  align=center class=td1 >"+sysValue1[1]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sProportion1[1]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue1[2]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sProportion1[2]+"</td>");
    sTemp.append("   <td align=center class=td1 >"+sysValue1[3]+"</td>");
	sTemp.append("	 <td align=center class=td1 >"+sProportion1[3]+"</td>");
    sTemp.append("  </tr>");
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

