<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.21
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

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	int k = 0;
	int iMoneyUnit = 100000000;
	String sYearN = "××年×月";
	String sYear="",sMonth="";	
	String sYearNSerialNo = "";
	String sYearSerialNo[] = {"",""};
	String sYearReportDate[]  = {"××年×月","××年×月","××年×月"};
	String sValue[] = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String sValue1[] = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String sValue2[] = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
    
    ASResultSet rs = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,SerialNo "+
					" from CUSTOMER_FSRATION "+
					" where CustomerID ='"+sCustomerID+"'"+
					" And  ReportDate = (select max(ReportDate) as MaxReportDate from CUSTOMER_FSRATION where CustomerID = '"+sCustomerID+"')");	
	if(rs.next())
	{
		sYear = rs.getString("Year");	//日期
		if(sYear == null) 
		{
			sYearN = "××年×月";
		}
		else
		{
			sMonth = rs.getString("Month");	//日期
			sYearN = sYear + "年" +sMonth+"月";
		}
		sYearNSerialNo = rs.getString("SerialNo");	//最近资产负债表号
		sYearReportDate[0] = rs.getString("ReportDate");
	}	
	rs.getStatement().close();	
				
	if(!sYearN.equals("××年×月")){
		rs = Sqlca.getResultSet(" select TotalAsset,OwnEquities,TotalDeposit,TotalLoan,Taking,RetProfit,CapitalFullRate,CoreCapitalRate,"+
								 " OneLoanRate,TenLoanRate,BadLoanRate,DepositLoanRate,LiquidityRate,AssetIncomeRate,RetIncomeRate "+
								 " from CUSTOMER_FSRATION where SerialNo='"+sYearNSerialNo+"'");
		if(rs.next()){
			sValue[0] = DataConvert.toMoney(rs.getDouble("TotalAsset")/iMoneyUnit);          //总资产
			sValue[1] = DataConvert.toMoney(rs.getDouble("OwnEquities")/iMoneyUnit);  		//所有者权益
			sValue[2] = DataConvert.toMoney(rs.getDouble("TotalDeposit")/iMoneyUnit); 		//存款总额
			sValue[3] = DataConvert.toMoney(rs.getDouble("TotalLoan")/iMoneyUnit);    		//贷款总额
			sValue[4] = DataConvert.toMoney(rs.getDouble("Taking")/iMoneyUnit);       		//营业收入
			sValue[5] = DataConvert.toMoney(rs.getDouble("RetProfit")/iMoneyUnit);			//净利润
			sValue[6] = DataConvert.toMoney(rs.getDouble("CapitalFullRate"));		//资本充足率
			sValue[7] = DataConvert.toMoney(rs.getDouble("CoreCapitalRate"));		//核心资本充足率
			sValue[8] = DataConvert.toMoney(rs.getDouble("OneLoanRate"));			//单一客户贷款比率
			sValue[9] = DataConvert.toMoney(rs.getDouble("TenLoanRate"));			//十大客户贷款比率
			sValue[10] = DataConvert.toMoney(rs.getDouble("BadLoanRate"));		//不良贷款
			sValue[11] = DataConvert.toMoney(rs.getDouble("DepositLoanRate"));	//存贷比
			sValue[12] = DataConvert.toMoney(rs.getDouble("LiquidityRate"));		//流动性比率
			sValue[13] = DataConvert.toMoney(rs.getDouble("AssetIncomeRate"));	//资产收益率
			sValue[14] = DataConvert.toMoney(rs.getDouble("RetIncomeRate"));		//净资产收益率																					
		}	
		rs.getStatement().close();					 
	}
	if("".equals(sYear))
	{
		sYear = StringFunction.getToday().substring(1,4);
	}
	String sYearN_1 = String.valueOf(Integer.parseInt(sYear) - 1)+"/12";
	String sYearN_2 = String.valueOf(Integer.parseInt(sYear) - 2)+"/12";
	rs = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,SerialNo from CUSTOMER_FSRATION "+
	" where CustomerID ='"+sCustomerID+"'"+
	" and  ReportDate in('"+sYearN_1+"','"+sYearN_2+"')"+
	" order by Year Desc");
	k = 0;
	while (k < 2)
	{
		if(rs.next())
		{
			sYear = rs.getString("Year");	//日期
			if(sYear == null) 
			{
				sYearReportDate[k] = "××年";
			}
			else
			{
				sMonth = rs.getString("Month");	//日期
				sYearReportDate[k+1] = sYear + "年"+sMonth+"月";;
				sYearSerialNo[k] = rs.getString("SerialNo");	
				sYearReportDate[k+1] = rs.getString("ReportDate");
			}
		}
		k ++;
	}
	rs.getStatement().close();  

	if(!sYearReportDate[1].equals("××年××月")){
		rs = Sqlca.getResultSet(" select TotalAsset,OwnEquities,TotalDeposit,TotalLoan,Taking,RetProfit,CapitalFullRate,CoreCapitalRate,"+
								 " OneLoanRate,TenLoanRate,BadLoanRate,DepositLoanRate,LiquidityRate,AssetIncomeRate,RetIncomeRate"+
								 " from CUSTOMER_FSRATION where SerialNo='"+sYearSerialNo[0]+"'");
		if(rs.next()){
			sValue1[0] = DataConvert.toMoney(rs.getDouble("TotalAsset")/iMoneyUnit);          //总资产
			sValue1[1] = DataConvert.toMoney(rs.getDouble("OwnEquities")/iMoneyUnit);  		//所有者权益
			sValue1[2] = DataConvert.toMoney(rs.getDouble("TotalDeposit")/iMoneyUnit); 		//存款总额
			sValue1[3] = DataConvert.toMoney(rs.getDouble("TotalLoan")/iMoneyUnit);    		//贷款总额
			sValue1[4] = DataConvert.toMoney(rs.getDouble("Taking")/iMoneyUnit);       		//营业收入
			sValue1[5] = DataConvert.toMoney(rs.getDouble("RetProfit")/iMoneyUnit);			//净利润
			sValue1[6] = DataConvert.toMoney(rs.getDouble("CapitalFullRate"));		//资本充足率
			sValue1[7] = DataConvert.toMoney(rs.getDouble("CoreCapitalRate"));		//核心资本充足率
			sValue1[8] = DataConvert.toMoney(rs.getDouble("OneLoanRate"));			//单一客户贷款比率
			sValue1[9] = DataConvert.toMoney(rs.getDouble("TenLoanRate"));			//十大客户贷款比率
			sValue1[10] = DataConvert.toMoney(rs.getDouble("BadLoanRate"));		//不良贷款
			sValue1[11] = DataConvert.toMoney(rs.getDouble("DepositLoanRate"));	//存贷比
			sValue1[12] = DataConvert.toMoney(rs.getDouble("LiquidityRate"));		//流动性比率
			sValue1[13] = DataConvert.toMoney(rs.getDouble("AssetIncomeRate"));	//资产收益率
			sValue1[14] = DataConvert.toMoney(rs.getDouble("RetIncomeRate"));		//净资产收益率																			
		}	
		rs.getStatement().close();				
	}
	
	if(!sYearReportDate[2].equals("××年××月")){
		rs = Sqlca.getResultSet(" select TotalAsset,OwnEquities,TotalDeposit,TotalLoan,Taking,RetProfit,CapitalFullRate,CoreCapitalRate,"+
								 " OneLoanRate,TenLoanRate,BadLoanRate,DepositLoanRate,LiquidityRate,AssetIncomeRate,RetIncomeRate"+
								 " from CUSTOMER_FSRATION where SerialNo='"+sYearSerialNo[1]+"'");
		if(rs.next()){
			sValue2[0] = DataConvert.toMoney(rs.getDouble("TotalAsset")/iMoneyUnit);          //总资产
			sValue2[1] = DataConvert.toMoney(rs.getDouble("OwnEquities")/iMoneyUnit);  		//所有者权益
			sValue2[2] = DataConvert.toMoney(rs.getDouble("TotalDeposit")/iMoneyUnit); 		//存款总额
			sValue2[3] = DataConvert.toMoney(rs.getDouble("TotalLoan")/iMoneyUnit);    		//贷款总额
			sValue2[4] = DataConvert.toMoney(rs.getDouble("Taking")/iMoneyUnit);       		//营业收入
			sValue2[5] = DataConvert.toMoney(rs.getDouble("RetProfit")/iMoneyUnit);			//净利润
			sValue2[6] = DataConvert.toMoney(rs.getDouble("CapitalFullRate"));		//资本充足率
			sValue2[7] = DataConvert.toMoney(rs.getDouble("CoreCapitalRate"));		//核心资本充足率
			sValue2[8] = DataConvert.toMoney(rs.getDouble("OneLoanRate"));			//单一客户贷款比率
			sValue2[9] = DataConvert.toMoney(rs.getDouble("TenLoanRate"));			//十大客户贷款比率
			sValue2[10] = DataConvert.toMoney(rs.getDouble("BadLoanRate"));		//不良贷款
			sValue2[11] = DataConvert.toMoney(rs.getDouble("DepositLoanRate"));	//存贷比
			sValue2[12] = DataConvert.toMoney(rs.getDouble("LiquidityRate"));		//流动性比率
			sValue2[13] = DataConvert.toMoney(rs.getDouble("AssetIncomeRate"));	//资产收益率
			sValue2[14] = DataConvert.toMoney(rs.getDouble("RetIncomeRate"));		//净资产收益率																					
		}	
		rs.getStatement().close();		
	}		
%>
 
 
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan='4' bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（三）主要财务数据（单位：亿元、%）</font></td>"); 	
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 >"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sYearReportDate[2]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sYearReportDate[1]+"&nbsp;</td>");
     sTemp.append("  <td width=25% align=left class=td1 > "+sYearReportDate[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 总资产"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[0]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[0]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 所有者权益"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[1]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[1]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[1]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 存款总额"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[2]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[2]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 贷款总额"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[3]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[3]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[3]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 营业收入"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[4]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[4]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[4]+"&nbsp;</td>");
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 净利润"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[5]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[5]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[5]+"&nbsp;</td>");
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 资本充足率(≥8%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[6]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[6]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[6]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 核心资本充足率(≥4%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[7]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[7]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[7]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 单一客户贷款比率（≤10%）"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[8]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[8]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[8]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 十大客户贷款比率(≤50%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[9]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[9]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[9]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 不良贷款(≤4%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[10]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[10]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[10]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 存贷比(≤75%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[11]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[11]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[11]+"&nbsp;</td>");
	sTemp.append("   </tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 流动性比率(≥25%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[12]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[12]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[12]+"&nbsp;</td>");
	sTemp.append("   </tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 资产收益率(≥0.6%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[13]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[13]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[13]+"&nbsp;</td>");
	sTemp.append("   </tr>");
  	sTemp.append("   <td width=25% align=left class=td1 > 净资产收益率(≥11%)"+" "+"&nbsp;</td>");
  	sTemp.append("   <td width=25% align=left class=td1 > "+sValue2[14]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 > "+sValue1[14]+"&nbsp;</td>");
    sTemp.append("   <td width=25% align=left class=td1 >"+sValue[14]+"&nbsp;</td>");
	sTemp.append("   </tr>");			
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