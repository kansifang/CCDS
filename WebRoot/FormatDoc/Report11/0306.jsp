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

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0306.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=4 ><font style=' font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;' >6、固定资产及无形资产分析("+sNewReportDate3+")</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=30% align=center class=td1 >品种&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >金额（万元）&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >%&nbsp;</td>");
    sTemp.append(" <td width=25% align=center class=td1 >是否抵押&nbsp;</td>");
    sTemp.append(" </tr>");
    
    String sSql121 = "select sum(EvalValue) from ENT_FIXEDASSETS where FixedAssetsType in ('01','02','03','04') and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
    rs2 = Sqlca.getResultSet(sSql121);
    double sum = 0.0;
	if(rs2.next())
		sum = rs2.getDouble(1)/Unit;
	rs2.getStatement().close();
	
	String sSql12 = "select EvalValue,getItemName('DepreciationWay',Depreciation) as Depreciation,Rate,getItemName('ImpawnStatus',ImpawnStatus) as ImpawnStatus from ENT_FIXEDASSETS where FixedAssetsType = '01' and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
	rs2 = Sqlca.getResultSet(sSql12);
	String sEvalValue = "";				//固定资产金额(万元)
    String sImpawnStatus = "";//是否抵押
    
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
	    sImpawnStatus = rs2.getString("ImpawnStatus");
		sTemp.append("  <tr>");
		sTemp.append("   <td align=center class=td1 >房屋建筑物</td>");
	    sTemp.append("   <td align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sImpawnStatus+"&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td align=center class=td1 >房屋建筑物</td>");
	    sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
	//机器设备
	String sSql13 = "select EvalValue,getItemName('DepreciationWay',Depreciation) as Depreciation,Rate,getItemName('ImpawnStatus',ImpawnStatus)  as ImpawnStatus from ENT_FIXEDASSETS where FixedAssetsType = '02' and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
	rs2 = Sqlca.getResultSet(sSql13);
	sEvalValue = "";
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
	    sImpawnStatus = rs2.getString("ImpawnStatus");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >机器设备</td>");
	    sTemp.append("   <td align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sImpawnStatus+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td align=center class=td1 >机器设备</td>");
	    sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
	//运输工具
	String sSql14 = "select EvalValue,getItemName('DepreciationWay',Depreciation) as Depreciation,Rate,getItemName('ImpawnStatus',ImpawnStatus) as ImpawnStatus  from ENT_FIXEDASSETS where FixedAssetsType = '03' and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
	rs2 = Sqlca.getResultSet(sSql14);
	sEvalValue = "";
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
	    sImpawnStatus = rs2.getString("ImpawnStatus");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >运输工具</td>");
	    sTemp.append("   <td align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td  align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sImpawnStatus+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td align=center class=td1 >运输工具</td>");
	    sTemp.append("   <td  align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td  align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
    //土地
	sTemp.append("  <tr>");
	sTemp.append("   <td align=center class=td1 >土地</td>");
    sTemp.append("   <td  align=center class=td1 >0.0&nbsp;</td>");
    sTemp.append("   <td  align=center class=td1 >0.0&nbsp;</td>");
    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
	sTemp.append("  </tr>");
	
	//其他
	String sSql16 = "select EvalValue,getItemName('DepreciationWay',Depreciation) as Depreciation,Rate,getItemName('ImpawnStatus',ImpawnStatus) as ImpawnStatus  from ENT_FIXEDASSETS where FixedAssetsType = '04' and CustomerID = '"+sCustomerID+"' and UpToDate ='"+sReportDate+"'";
	rs2 = Sqlca.getResultSet(sSql16);
	sEvalValue = "";
    if(rs2.next())
    {
	    sEvalValue = DataConvert.toMoney(rs2.getDouble(1)/Unit);
	    String sProportions="0.0";//占比
	    if(sum!=0) sProportions=DataConvert.toMoney(rs2.getDouble(1)/Unit/sum*100);
	    sImpawnStatus = rs2.getString("ImpawnStatus");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=center class=td1 >其他</td>");
	    sTemp.append("   <td  align=center class=td1 >"+sEvalValue+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sProportions+"&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >"+sImpawnStatus+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	else
	{
		sTemp.append("  <tr>");
		sTemp.append("   <td  align=center class=td1 >其他</td>");
	    sTemp.append("   <td align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td  align=center class=td1 >0.0&nbsp;</td>");
	    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
		sTemp.append("  </tr>");
	}
	rs2.getStatement().close();
	
	//合计
	sTemp.append("  <tr>");
	sTemp.append("   <td  align=center class=td1 > 合计 </td>");
    sTemp.append("   <td  align=center class=td1 >"+DataConvert.toMoney(sum)+"&nbsp;</td>");
    sTemp.append("   <td  align=center class=td1 >&nbsp;</td>");
    sTemp.append("   <td align=center class=td1 >&nbsp;</td>");
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

