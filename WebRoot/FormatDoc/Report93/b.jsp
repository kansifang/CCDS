<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hldu  20120731
		Tester:
		Content: 授信及担保信息
		Input Param:
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
	sButtons[1][0] = "false";
%>
<%
    //定义变量
    ASResultSet rs = null;            // 结果集
    ASResultSet rs3 = null;
    ASResultSet rs5 = null;
	String sRelativeID = "";          // 
	String sCustomerName = "";
	String sBusinessTypeName = "";
	int iMoneyUnit = 10000; 
	String sBalance = "";
	double dBalance = 0.0;
	String sCurrencyName = "";
	String sTermMonth2 = "";
	String sBailRatio = "";
	String sBusinessRate2 = "";
	String sClassifyResult = "";
	String sBalanceSum = "";
	double dBalanceSum = 0.0;
	String whereClause = "''";
	String sSql4 = "";
	String sSql3 = "";
	String sSql5 = "" ;
	String sGuarantorID = "";
	String sBusinessSum = "";
	double dBusinessSum = 0.0;
	String sVouchType = "";
	String sMaturity = "" ; 
	String sOccurOrg = "";
	String sBusinessType = "";
	String sGuarantyTypeName = "";
	String sBeginDate = "";
	String sCurrencyType = "";
%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();

	sTemp.append("<form method='post' action='b.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	sTemp.append("<table class=table1 width='640'  align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	//当前客户ID
	sCustomerID = Sqlca.getString(" select CustomerID from Business_Apply where SerialNo = '"+sObjectNo+"' ");
	//该客户担保人ID
	sSql4 = " select GC.GuarantorID as GuarantorID from GUARANTY_CONTRACT GC where exists (Select AR.ObjectNo from APPLY_RELATIVE AR where AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo)  and ContractStatus = '010' ";
	rs = Sqlca.getASResultSet(sSql4);
	//if(!rs.next())
	//{
	//	out.println("该客户无担保人信息");
	//}
	//while (rs.next())
	{
		sGuarantorID = rs.getString("GuarantorID");
		if(sGuarantorID == null) sGuarantorID = "";
		if("".equals(sGuarantorID))
		{
			sTemp.append("   <tr>");	
			sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >该客户无担保人信息</font></td>"); 	
			sTemp.append("   </tr>");	
		}else{
			sSql3 = " select RelativeID from Customer_Relative where CustomerID = '"+sGuarantorID+"' and RelationShip = '0301'" ;
			rs3 = Sqlca.getASResultSet(sSql3);
			if (rs3.next())
			{
				sRelativeID = rs3.getString("RelativeID");
				if(sRelativeID == null) sRelativeID = "";
			}	
			rs3.getStatement().close();
				sSql5 = " select getCustomerName(CustomerID) as CustomerName,getBusinessName(BusinessType) as BusinessTypeName, "
				       + " Balance,getItemName('Currency',BusinessCurrency) as CurrencyName,TermMonth,BailRatio,BusinessRate,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult "
				       + " from Business_Contract where CustomerID in ('"+sGuarantorID+"','"+sRelativeID+"') order by CustomerID ";
				rs5 = Sqlca.getASResultSet(sSql5);
				sTemp.append("   <tr>");	
				sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >担保人及配偶授信及担保情况（全部：每个担保人一份表）</font></td>"); 	
				sTemp.append("   </tr>");
				sTemp.append("   <tr>");	
				sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >担保人及配偶在我行授信情况</font></td>"); 	
				sTemp.append("   </tr>");
				sTemp.append("   <tr>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >姓名</td>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >授信业务品种</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >余额（万元）</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >币种</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >授信期限（月）</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >保证金比例%</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >月利率‰</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >五级分类</td>");
				sTemp.append("   </tr>");
				while (rs5.next())
				{
					sCustomerName = rs5.getString("CustomerName");
					if(sCustomerName == null) sCustomerName = "";
					sBusinessTypeName = rs5.getString("BusinessTypeName");
					if(sBusinessTypeName == null) sBusinessTypeName = "";
					dBalance = rs5.getDouble("Balance");
					sBalance = DataConvert.toMoney(dBalance/iMoneyUnit);
					sCurrencyName = rs5.getString("CurrencyName");
					if(sCurrencyName == null) sCurrencyName = "";
					sTermMonth2 = rs5.getString("TermMonth");
					if(sTermMonth2 == null) sTermMonth2 = "";
					sBailRatio = rs5.getString("BailRatio");
					if(sBailRatio == null) sBailRatio = "";
					sBusinessRate2 = rs5.getString("BusinessRate");
					if(sBusinessRate2 == null) sBusinessRate2 = "";
					sClassifyResult = rs5.getString("ClassifyResult");
					if(sClassifyResult == null) sClassifyResult = "";
					sTemp.append("   <tr>");
					sTemp.append("   <td  colspan=2 align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
					sTemp.append("   <td  colspan=2 align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
					sTemp.append("   <td  colspan=1 align=center class=td1 >"+sBalance+"&nbsp;</td>");
					sTemp.append("   <td  colspan=1 align=center class=td1 >"+sCurrencyName+"&nbsp;</td>");
					sTemp.append("   <td  colspan=1 align=center class=td1 >"+sTermMonth2+"&nbsp;</td>");
					sTemp.append("   <td  colspan=1 align=center class=td1 >"+sBailRatio+"&nbsp;</td>");
					sTemp.append("   <td  colspan=1 align=center class=td1 >"+sBusinessRate2+"&nbsp;</td>");
					sTemp.append("   <td  colspan=1 align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
					sTemp.append("   </tr>");
				}
				rs5.getStatement().close();	
				dBalanceSum = Sqlca.getDouble(" select sum(Balance) from Business_Contract where CustomerID in ('"+sGuarantorID+"','"+sRelativeID+"') ");
				sBalanceSum = DataConvert.toMoney(dBalanceSum/iMoneyUnit);
				sTemp.append("   <tr>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >合计</td>");
				sTemp.append("   <td  colspan=8 align=left class=td1 >&nbsp;人民币&nbsp;"+sBalanceSum+"</td>");
				sTemp.append("   </tr>");
				sTemp.append("   <tr>");
				sTemp.append("   <tr>");	
				sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >担保人及配偶在我行的对外担保情况</font></td>"); 	
				sTemp.append("   </tr>");
				sTemp.append("   <tr>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >被担保人</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >币种</td>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >担保合同金额（万元）</td>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >担保合同余额（万元）</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >担保方式</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >合同到期日</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >五级分类</td>");
				sTemp.append("   </tr>");
				sTemp.append("   <tr>");
				sSql5 = " select getCustomerName(GC.CustomerID) as CustomerName,getItemName('Currency',GC.GuarantyCurrency) as CurrencyName,BC.BusinessSum as BusinessSum, "
			        + " BC.Balance as Balance,getItemName('VouchType',BC.VouchType) as VouchType,BC.Maturity as Maturity,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResult "
			        + " from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR "
			        + " where CR.ObjectNo = GC.serialNo and CR.ObjectType = 'GuarantyContract' and BC.SerialNo=CR.SerialNo and GC.GuarantorID in ('"+sGuarantorID+"','"+sRelativeID+"') and ContractStatus = '020' order by GC.CustomerID ";
				rs5 = Sqlca.getASResultSet(sSql5);
				while (rs5.next())
				{
					sCustomerName = rs5.getString("CustomerName");
					if(sCustomerName == null) sCustomerName = "";
					sCurrencyName = rs5.getString("CurrencyName");
					if(sCurrencyName == null) sCurrencyName = "";
					dBusinessSum = rs5.getDouble("BusinessSum");
					sBusinessSum = DataConvert.toMoney(dBusinessSum/iMoneyUnit);
					dBalance = rs5.getDouble("Balance");
					sBalance = DataConvert.toMoney(dBalance/iMoneyUnit);
					sVouchType = rs5.getString("VouchType");
					if(sVouchType == null) sVouchType = "";
					sMaturity = rs5.getString("Maturity");
					if(sMaturity == null) sMaturity = "";
					sClassifyResult = rs5.getString("ClassifyResult");
					if(sClassifyResult == null) sClassifyResult = "";
					sTemp.append("   <tr>");
					sTemp.append("   <td  colspan=2 align=center class=td1 >"+sCustomerName+"&nbsp;</td>");
					sTemp.append("   <td  colspan=1 align=center class=td1 >"+sCurrencyName+"&nbsp;</td>");
					sTemp.append("   <td  colspan=2 align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
					sTemp.append("   <td  colspan=2 align=center class=td1 >"+sBalance+"&nbsp;</td>");
					sTemp.append("   <td  colspan=1 align=center class=td1 >"+sVouchType+"&nbsp;</td>");
					sTemp.append("   <td  colspan=1 align=center class=td1 >"+sMaturity+"&nbsp;</td>");
					sTemp.append("   <td  colspan=1 align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
					sTemp.append("   </tr>");
				}
				rs5.getStatement().close();
				sSql5 = " select sum(BC.BusinessSum) as BusinessSum,sum(BC.Balance) as Balance from BUSINESS_CONTRACT BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR where CR.ObjectNo = GC.serialNo and CR.ObjectType = 'GuarantyContract' and BC.SerialNo=CR.SerialNo and GC.GuarantorID in ('"+sGuarantorID+"','"+sRelativeID+"') and ContractStatus = '020' ";
				rs5= Sqlca.getASResultSet(sSql5);
				if(rs5.next())
				{
					dBusinessSum = rs5.getDouble("BusinessSum");
					sBusinessSum = DataConvert.toMoney(dBusinessSum/iMoneyUnit);
					dBalance = rs5.getDouble("Balance"); 
					sBalance = DataConvert.toMoney(dBalance/iMoneyUnit);
				}
				rs5.getStatement().close();
				sTemp.append("   </tr>");
				sTemp.append("   <tr>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >合计</td>");
				sTemp.append("   <td  colspan=1 align=left class=td1 >币种</td>");
				sTemp.append("   <td  colspan=2 align=left class=td1 >"+sBusinessSum+"</td>");
				sTemp.append("   <td  colspan=2 align=left class=td1 >"+sBalance+"</td>");
				sTemp.append("   <td  colspan=3 align=left class=td1 >&nbsp;</td>");
				sTemp.append("   </tr>");
				sTemp.append("   <tr>");	
				sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >担保人及配偶在他行未结清授信情况</font></td>"); 	
				sTemp.append("   </tr>");
				sTemp.append("   <tr>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >行名</td>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >品种</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >授信额度（万元）</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >余额（万元）</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >起始日</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >到期日</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >担保方式</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >五级分类</td>");
				sTemp.append("   </tr>");
				//获得调查报告数据
			    sSql5 = "select OccurOrg,BusinessType,getItemName('OtherBusinessType',BusinessType) as BusinessTypeName, "+
				              "Balance,BeginDate,Maturity,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,BusinessSum ,getItemName('VouchType',VouchType) "+
				              "from CUSTOMER_OACTIVITY where CustomerID in ('"+sGuarantorID+"','"+sRelativeID+"') and BusinessType <>'08' and Balance >0" ;
			    rs5= Sqlca.getASResultSet(sSql5);
				while(rs5.next())
				{
					sOccurOrg = rs5.getString(1);
					if(sOccurOrg == null) sOccurOrg = " ";
					sBusinessType = rs5.getString(2);
					sBusinessTypeName = rs5.getString(3);
					if(sBusinessTypeName == null) sBusinessTypeName = " ";
					sBalance = DataConvert.toMoney(rs5.getDouble(4)/10000);
					sBeginDate = rs5.getString(5);
					if(sBeginDate == null) sBeginDate = " ";
					sMaturity = rs5.getString(6);
					if(sMaturity == null) sMaturity = " ";
					sClassifyResult = rs5.getString(7);
					if(sClassifyResult == null) sClassifyResult = " ";
					sBusinessSum = DataConvert.toMoney(rs5.getDouble(8)/10000);
					sGuarantyTypeName = rs5.getString(9);
					if(sGuarantyTypeName == null) sGuarantyTypeName = " ";
					sTemp.append("   <tr>");
				  	sTemp.append("   <td colspan=2  align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
				    sTemp.append("   <td colspan=2 align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
				    sTemp.append("   <td colspan=1 align=center class=td1 >"+sBusinessSum+"&nbsp; </td>");
				    sTemp.append("   <td colspan=1 align=center class=td1 >"+sBalance+"&nbsp;</td>");
				    sTemp.append("   <td colspan=1 align=center class=td1 >"+sBeginDate+"&nbsp;</td>");
				    sTemp.append("   <td colspan=1 align=center class=td1 >"+sMaturity+"&nbsp;</td>");
				    sTemp.append("   <td colspan=1 align=center class=td1 >"+sGuarantyTypeName+"/&nbsp;</td>");    
				    sTemp.append("   <td colspan=1 align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
					sTemp.append("   </tr>");
				}
				rs5.getStatement().close();
				sSql5 = "select sum(BusinessSum),sum(Balance) "+
	              "from CUSTOMER_OACTIVITY where CustomerID in ('"+sGuarantorID+"','"+sRelativeID+"') and BusinessType <>'08' and Balance >0";
	            rs5 = Sqlca.getResultSet(sSql5);
	            String sSum = "";
				String sSum1 = "" ;
				while(rs5.next())
				{
					sSum += DataConvert.toMoney(rs5.getDouble(1)/10000); 
					sSum1 +=DataConvert.toMoney(rs5.getDouble(2)/10000);
				}	
				rs5.getStatement().close();
				sTemp.append("   <tr>");
				sTemp.append("   	<td colspan=4 align=center class=td1 > 合计: </td>");
				sTemp.append("   	<td colspan=1 align=center class=td1 >"+sSum+"&nbsp</td>");
				sTemp.append("   	<td colspan=1 align=center class=td1 >"+sSum1+"&nbsp</td>");
				sTemp.append("   	<td colspan=4 align=left class=td1 >"+"/"+"&nbsp;</td>");
				sTemp.append("</tr>");
				sTemp.append("   <tr>");	
				sTemp.append("   <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >担保人及配偶在他行的对外担保情况</font></td>"); 	
				sTemp.append("   </tr>");
				sTemp.append("   <tr>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >行名</td>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >被担保人</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >币种</td>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >担保金额（万元）</td>");
				sTemp.append("   <td  colspan=1 align=center class=td1 >担保到期日</td>");
				sTemp.append("   <td  colspan=2 align=center class=td1 >主债权五级分类</td>");
				sTemp.append("   </tr>");
				sSql5 = "select OccurOrg,BusinessSum,Maturity,"+
	              "getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,getItemName('Currency',CURRENCY) as currencyType "+
	              "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID in ('"+sGuarantorID+"','"+sRelativeID+"') ";
				rs5 = Sqlca.getResultSet(sSql5);
				while(rs5.next())
				{
					sOccurOrg = rs5.getString(1);
					dBusinessSum += rs5.getDouble(2);
					sBusinessSum = DataConvert.toMoney(rs5.getDouble(2)/10000);;
					sMaturity = rs5.getString(3);
					sClassifyResult = rs5.getString(4);
					if(sClassifyResult == null) sClassifyResult = " ";
					sCurrencyType =rs5.getString(5);
					sTemp.append("   <tr>");
				  	sTemp.append("   <td colspan=2 align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
				    sTemp.append("   <td colspan=2 align=right class=td1 >"+""+"&nbsp;</td>");
				    sTemp.append("   <td colspan=1 align=center class=td1 >"+sCurrencyType+"&nbsp;</td>");
				   	sTemp.append("   <td colspan=2 align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
				    sTemp.append("   <td colspan=1 align=center class=td1 >"+sMaturity+"&nbsp;</td>");
					sTemp.append("   <td colspan=2 align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
					sTemp.append("   </tr>");
				}
				rs5.getStatement().close();	
				sSql5 = "select sum(nvl(BusinessSum,0)) "+
		           "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID in ('"+sGuarantorID+"','"+sRelativeID+"') ";
			    rs5 = Sqlca.getResultSet(sSql5);
				if(rs5.next())
				{
					sSum = DataConvert.toMoney(rs5.getDouble(1)/10000); 		
				}	
				rs5.getStatement().close();	
				sTemp.append("   <tr>");
			  	sTemp.append("   <td colspan=4 align=left class=td1 > 合计：  </td>");
			  	sTemp.append("   <td colspan=1 align=center class=td1 > 人民币 </td>");
			    sTemp.append("   <td colspan=2 align=center class=td1 >"+sSum+"&nbsp;</td>");
			    sTemp.append("   <td colspan=3 align=left class=td1 >"+"/ "+"</td>");
			    sTemp.append("   </tr>");
				sTemp.append("<tr>");
				sTemp.append("<td colspan=10 align=left class=td1 >&nbsp</td>");
				sTemp.append("</tr>"); 	
		}
	}
	rs.getStatement().close();	

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
	//editor_generate('describe1');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
