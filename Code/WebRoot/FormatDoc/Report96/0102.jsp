<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   wangdw 2009.08.21
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
	int iDescribeCount = 13;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	String sMonthIncome    = "";			//本人工资月收入
	String sOverDueBalance = "";			//逾期金额
	String sEvaluateScore  = "";			//信用分数
	String sFamilyStatus   = "";			//居住状况
	double dOverDueBalance = 0.0;			//逾期金额
	double dEvaluateScore  = 0.0;
    double dEvaluateModulus= 0.0; 			//资信评级系数
	double dVouchModulus   = 0.0;    		//担保方式系数
    double dRiskEvaluate   = 0.0;    		//授信风险度

	int    otherdk		   = 0;				//几笔其他贷款
	//月收入、居住状况
	String sSql1 = " select YearIncome,FamilyStatus  from IND_INFO where CustomerID = '"+sCustomerID+"'";
	ASResultSet rs1 = Sqlca.getResultSet(sSql1);
	if(rs1.next())
	{
		sMonthIncome = DataConvert.toMoney(rs1.getDouble("YearIncome")/12);
		if(sMonthIncome == null) sMonthIncome = "";
		
		sFamilyStatus = rs1.getString("FamilyStatus");
		if(sFamilyStatus == null) sFamilyStatus = "";
	}
	rs1.getStatement().close();		
	//其他借款笔数
	String sSql3 = "select count(*) as otherdk from Business_Contract  where customerid = '"+sCustomerID+"'  and (FinishDate is  null or FinishDate ='') ";
	ASResultSet rs3 = Sqlca.getResultSet(sSql3);
	if(rs3.next())
	{
		otherdk = rs3.getInt("otherdk");
	}
	rs3.getStatement().close();
	//逾期金额
	String sSql4 = "select sum(OverDueBalance) as OverDueBalance from Business_Contract where CustomerID ='"+sCustomerID+"' and  ( FinishDate = ''  or FinishDate IS NULL)  and OverDueBalance>0";
	ASResultSet rs4 = Sqlca.getResultSet(sSql4);
	if(rs4.next())
	{
		dOverDueBalance = rs4.getDouble("OverDueBalance");
		sOverDueBalance = DataConvert.toMoney(dOverDueBalance);
		if(sOverDueBalance == null) sOverDueBalance = "";
	}
	rs4.getStatement().close();
	//资信报告信用分数
	String sSql5 = "select EvaluateScore from Evaluate_Record where ObjectType = 'Customer' and ObjectNo='"+sCustomerID+"' order by AccountMonth DESC fetch first 1 row only ";
	ASResultSet rs5 = Sqlca.getResultSet(sSql5);
	if(rs5.next())
	{
		dEvaluateScore = rs5.getDouble("EvaluateScore");
		sEvaluateScore = DataConvert.toMoney(dEvaluateScore);
		if(sEvaluateScore == null) sEvaluateScore = "";
	}
	rs5.getStatement().close();
	//资信评级系数、担保方式系数、授信风险度
	String sSql6 = "select VouchModulus,RiskEvaluate,EvaluateModulus from Risk_Evaluate where ObjectNo ='"+sObjectNo+"' and ObjectType='CreditApply'";
	ASResultSet rs6 = Sqlca.getResultSet(sSql6);
	if(rs6.next())
	{
		dVouchModulus    = rs6.getDouble("VouchModulus");
		dRiskEvaluate 	 = rs6.getDouble("RiskEvaluate");
		dEvaluateModulus = rs6.getDouble("EvaluateModulus");
	}
	rs6.getStatement().close();
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0102.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1.2、经查询个人资信资料，申请人、共同还款人、共有人资信情况如下：</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=20 height='34' class=td1 >");
	sTemp.append(" 	 （1）");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"无不良信用记录"));
	sTemp.append("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"无其他借款"));
	sTemp.append("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"在个人征信系统中无记录"));
	sTemp.append("   </td>");  	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=20 height='34' class=td1 >");
	sTemp.append(" 	 （2）");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"无其他借款"));
	sTemp.append("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
  	sTemp.append("   合计：<u>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:5%; height:25'",getUnitData("describe5",sData)));
	sTemp.append("</u>笔&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
  	sTemp.append("   合计月还款：<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:15%; height:25'",getUnitData("describe6",sData)));
	sTemp.append("</u>      元&nbsp;</td>");
	sTemp.append("   </tr>");


	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% colspan=20  height='34' align=left class=td1 >（3）");
  	sTemp.append("   合计月还款占合计月收入比例：");

	sTemp.append("&nbsp;<u>");  	
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:20%; height:25'",getUnitData("describe7",sData)));
	sTemp.append("</u>      %&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=20 height='34'class=td1 >");
	sTemp.append(" 	 （4）");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"有借款逾期"));
  	sTemp.append("   逾期金额合计：<u>");
  	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("</u>      元&nbsp;</td>");
 	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% colspan=20 height='34' align=left class=td1 >（5）");
  	sTemp.append("   申请人资信报告信用分数：<u>");
	sTemp.append(sEvaluateScore);
	sTemp.append("</u>分");
	sTemp.append("</td>");
 	sTemp.append("   </tr>");
 	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1.3、申请人现住房情况：</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=20 class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe10'",getUnitData("describe10",sData),"自有产权@租赁@其他"));
	sTemp.append("   </td>");  	
	sTemp.append("   </tr>");
		

	sTemp.append(" <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1.4、个人资产情况：</font></td>"); 	
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='6' align=left class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:150'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");

	sTemp.append(" <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1.5</font></td>"); 	
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >本笔业务授信风险度R：</td>");
  	sTemp.append("   	<td width=15%  align=right class=td1 >");
	sTemp.append(dRiskEvaluate);
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >资信评级系数：</td>");
  	sTemp.append("   	<td width=15%  align=right class=td1 >");
	sTemp.append(dEvaluateModulus);
	sTemp.append("      &nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >担保方式系数：</td>");
  	sTemp.append("   	<td width=15%  align=right class=td1 >");
	sTemp.append(dVouchModulus);
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 height='34' align=left colspan=20 >&nbsp</font></td>"); 	
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