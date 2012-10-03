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
<%
/*~END~*/
%>

<%
int iDescribeCount = 5; //这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
		double dValue = 0;//应收总额
		double Unit = 10000;//金额（单位）,默认为万元
		String sReportDate = "";  	 //资产负债表年报日期
		String sYear = "xx";
		String sMonth = "xx";
		String sNewReportDate3 = "";
		
		ASResultSet rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportDate from CUSTOMER_FSRECORD "+
				" where CustomerID ='"+sCustomerID+"' "+
				//"  and ReportPeriod='04' and AuditFlag in ('2','3')"+
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
%>

<%
/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/
%>
<%
		StringBuffer sTemp = new StringBuffer();
		sTemp.append("	<form method='post' action='0305.jsp' name='reportInfo'>");
		sTemp.append("<div id=reporttable>");
		sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
		sTemp.append("   <tr>");
		sTemp.append("   <td class=td1 align=center colspan=9 ><font style=' font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >5、存货分析("+sNewReportDate3+")</font></td> ");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append(" <td width=30% align=center class=td1 >品种&nbsp;</td>");
		sTemp.append(" <td width=25% align=center class=td1 >金额（万元）&nbsp;</td>");
		sTemp.append(" <td width=20% align=center class=td1 >%&nbsp;</td>");
		sTemp.append(" <td width=25% align=center class=td1 >存货是否正常&nbsp;</td>");
		sTemp.append(" </tr>");

		//存货合计
		String sSql91 = "select  sum(ValueSum) from ENT_INVENTORY where InventoryType in('01','02','03','06') and CustomerID = '"
		                + sCustomerID + "' and UpToDate ='"+sReportDate+"'";
		rs2 = Sqlca.getResultSet(sSql91);
		double sum = 0.0;
		if (rs2.next()) {
			sum = rs2.getDouble(1) / Unit;
		}
		rs2.getStatement().close();

		//原材料
		String sSql11 = "select  ValueSum,getitemname('YesNo',QualityStatus) from ENT_INVENTORY where InventoryType = '01' and CustomerID = '"
		               + sCustomerID + "' and UpToDate ='"+sReportDate+"'";
		rs2 = Sqlca.getResultSet(sSql11);
		String sValueSum = "";
		String sQualityStatus = "";
		if (rs2.next()) {
			sValueSum = DataConvert.toMoney(rs2.getDouble(1) / Unit);
			sQualityStatus = rs2.getString(2);
			if (sQualityStatus == null) sQualityStatus = " ";
			String sProportions = "0.0";//占比
			if (sum != 0) sProportions = DataConvert.toMoney(rs2.getDouble(1)/ Unit / sum * 100);
			sTemp.append("  <tr>");
			sTemp.append("   <td align=center class=td1 > 原材料</td>");
			sTemp.append("   <td align=center class=td1 >" + sValueSum+ "&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >"+ sProportions + "&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >"+ sQualityStatus + "&nbsp;</td>");
			sTemp.append("  </tr>");
		} else {
			sTemp.append("  <tr>");
			sTemp.append("   <td align=center class=td1 > 原材料</td>");
			sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
			sTemp.append("  </tr>");
		}
		rs2.getStatement().close();

		//产成品
		String sSql9 = "select  ValueSum,getitemname('YesNo',QualityStatus) from ENT_INVENTORY where InventoryType = '02' and CustomerID = '"+ sCustomerID + "' and UpToDate ='"+sReportDate+"'";
		rs2 = Sqlca.getResultSet(sSql9);
		sValueSum = ""; //金额(万元)
		sQualityStatus = ""; //存货是否正常
		if (rs2.next()) {
			sValueSum = DataConvert.toMoney(rs2.getDouble(1) / Unit);
			sQualityStatus = rs2.getString(2);
			if (sQualityStatus == null) sQualityStatus = " ";
			String sProportions = "0.0";//占比
			if (sum != 0) sProportions = DataConvert.toMoney(rs2.getDouble(1)/ Unit / sum * 100);
			sTemp.append("  <tr>");
			sTemp.append("   <td align=center class=td1 > 产成品</td>");
			sTemp.append("   <td align=center class=td1 >" + sValueSum+ "&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >"+ sProportions + "&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >"+ sQualityStatus + "&nbsp;</td>");
			sTemp.append("  </tr>");
		} else {
			sTemp.append("  <tr>");
			sTemp.append("   <td align=center class=td1 > 产成品</td>");
			sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
			sTemp.append("  </tr>");
		}
		rs2.getStatement().close();

		//在产品
		String sSql10 = "select  ValueSum,getitemname('YesNo',QualityStatus) from ENT_INVENTORY where InventoryType = '03' and CustomerID = '"+ sCustomerID + "' and UpToDate ='"+sReportDate+"'";
		rs2 = Sqlca.getResultSet(sSql10);
		sValueSum = "";
		sQualityStatus = "";
		if (rs2.next()) {
			sValueSum = DataConvert.toMoney(rs2.getDouble(1) / Unit);
			sQualityStatus = rs2.getString(2);
			if (sQualityStatus == null) sQualityStatus = " ";
			String sProportions = "0.0";//占比
			if (sum != 0) sProportions = DataConvert.toMoney(rs2.getDouble(1)/ Unit / sum * 100);
			sTemp.append("  <tr>");
			sTemp.append("   <td align=center class=td1 > 在产品</td>");
			sTemp.append("   <td align=center class=td1 >" + sValueSum + "&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >" + sProportions + "&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >" + sQualityStatus + "&nbsp;</td>");
			sTemp.append("  </tr>");
		} else {
			sTemp.append("  <tr>");
			sTemp.append("   <td align=center class=td1 > 在产品</td>");
			sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
			sTemp.append("  </tr>");
		}
		rs2.getStatement().close();

		//其他
		String sSql123 = "select  ValueSum,getitemname('YesNo',QualityStatus) from ENT_INVENTORY where InventoryType = '06' and CustomerID = '"
	                     + sCustomerID + "' and UpToDate ='"+sReportDate+"'";
		rs2 = Sqlca.getResultSet(sSql123);
		sValueSum = "";
		sQualityStatus = "";
		if (rs2.next()) {
			sValueSum = DataConvert.toMoney(rs2.getDouble(1) / Unit);
			sQualityStatus = rs2.getString(2);
			if (sQualityStatus == null) sQualityStatus = " ";
			String sProportions = "0.0";//占比
			if (sum != 0) sProportions = DataConvert.toMoney(rs2.getDouble(1)/ Unit / sum * 100);
			sTemp.append("  <tr>");
			sTemp.append("   <td align=center class=td1 > 其他</td>");
			sTemp.append("   <td align=center class=td1 >" + sValueSum + "&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >" + sProportions + "&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >" + sQualityStatus + "&nbsp;</td>");
			sTemp.append("  </tr>");
		} else {
			sTemp.append("  <tr>");
			sTemp.append("   <td align=center class=td1 > 其他</td>");
			sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
			sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
			sTemp.append("  </tr>");
		}
		rs2.getStatement().close();
		//合计
		sTemp.append("  <tr>");
		sTemp.append("   <td align=center class=td1 > 合计</td>");
		sTemp.append("   <td align=center class=td1 >"+ DataConvert.toMoney(sum) + "&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("  </tr>");

		sTemp.append("</table>");
		sTemp.append("</div>");
		sTemp.append("<input type='hidden' name='Method' value='1'>");
		sTemp.append("<input type='hidden' name='SerialNo' value='"+ sSerialNo + "'>");
		sTemp.append("<input type='hidden' name='ObjectNo' value='"+ sObjectNo + "'>");
		sTemp.append("<input type='hidden' name='ObjectType' value='"+ sObjectType + "'>");
		sTemp.append("<input type='hidden' name='Rand' value=''>");
		sTemp.append("<input type='hidden' name='CompClientID' value='"+ CurComp.ClientID + "'>");
		sTemp.append("<input type='hidden' name='PageClientID' value='"+ CurPage.ClientID + "'>");
		sTemp.append("</form>");

		String sReportInfo = sTemp.toString();
		String sPreviewContent = "pvw" + java.lang.Math.random();
%>
<%
/*~END~*/
%>

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

