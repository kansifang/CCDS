<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.18
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
	int iDescribeCount = 33;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	//sButtons[1][0] = "false";
%>
<%
	//获得调查报告数据
	String sCustomerName = "";			//申请人名称
	String sBusinessType = "";			//业务品种
	String sBusinessTypeName = "";		//授信业务品种名称
	String sBusinessSum = "";			//金额
	double dBusinessSum = 0.0;
	String sCurrency = "";				//币种
	String sBailRatio = "";				//保证金比例％
	String sBusinessRate = "";			//利率
	String sPdgRatio = "";				//手续费率
	String sClassifyResult = "";		//五级分类
	String sVouchType = "";				//担保方式
	String sPurpose = "";				//资金用途
	
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,BusinessType,getBusinessName(BusinessType)as BusinessTypeName,BusinessSum,"
										+"getitemname('Currency',BusinessCurrency) as CurrencyName ,BailRatio,BusinessRate,PdgRatio, "
										+"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"
										+"getitemname('VouchType',VouchType) as VouchTypeName,purpose "
										+"from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "&nbsp;";
		
		sBusinessType = rs2.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = " ";
		
		sBusinessTypeName = rs2.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = " ";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum"));
		if(sBusinessSum == null) sBusinessSum = "0";
		
		sCurrency = rs2.getString("CurrencyName");
		if(sCurrency == null) sCurrency = " ";
		
		sBailRatio = DataConvert.toMoney(rs2.getDouble("BailRatio"));

		//sBusinessRate = DataConvert.toMoney(rs2.getDouble("BusinessRate"));
		//利率保留6位小数
        NumberFormat nf = NumberFormat.getInstance();
        nf.setMinimumFractionDigits(6);
        nf.setMaximumFractionDigits(6);
		sBusinessRate = nf.format(rs2.getDouble("BusinessRate"));
		
		sPdgRatio = DataConvert.toMoney(rs2.getDouble("PdgRatio"));
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == null) sClassifyResult = " ";
		
		sVouchType = rs2.getString("VouchTypeName");
		if(sVouchType == null) sVouchType = " ";
		
		sPurpose = rs2.getString("purpose");
		if(sPurpose == null) sPurpose = "  ";
	}
	
	rs2.getStatement().close();	
	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='01.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >一、申请人基本信息</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 >本人对借款人<u>"+sCustomerName+"</u>的借款申请及有关资料已经审核，情况如实反映如下：</td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 >1、申请人为：</td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=10 class=td1 >&nbsp;&nbsp;");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"本地居民"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"本市工作"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"非本市工作"));
	sTemp.append("   <br>&nbsp;&nbsp;");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"外地居民"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe5'",getUnitData("describe5",sData),"本市工作"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe6'",getUnitData("describe6",sData),"非本市工作"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"有本市居住证明"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"无本市居住证明"));
	sTemp.append("   <br>&nbsp;&nbsp;");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe9'",getUnitData("describe9",sData),"境外居民"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe10'",getUnitData("describe10",sData),"本市工作"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe11'",getUnitData("describe11",sData),"非本市工作"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe12'",getUnitData("describe12",sData),"有本市居住证明"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe13'",getUnitData("describe13",sData),"无本市居住证明"));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 >2、根据申请人借款期限计算，借款到期时申请人年龄为<u>");	
	sTemp.append(myOutPut("2",sMethod,"name='describe14' ",getUnitData("describe14",sData))+"&nbsp;</u>周岁");
	sTemp.append("  </td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 >3、经查询个人资信资料，申请人，配偶，共有人资信情况如下：</td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 	 <td colspan=10 class=td1 >（1）");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe15'",getUnitData("describe15",sData),"无不良信用记录"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe16'",getUnitData("describe16",sData),"无其他借款"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe17'",getUnitData("describe17",sData),"在个人征信系统中无记录"));
	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >（2）");
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe18'",getUnitData("describe18",sData),"有其他借款，合计<u>"));
    sTemp.append(myOutPut("2",sMethod,"name='describe19' ",getUnitData("describe19",sData))+"&nbsp;</u>笔，合计月还款<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe20' ",getUnitData("describe20",sData))+"&nbsp;</u>元");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >（3）");
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe21'",getUnitData("describe21",sData),"有借款逾期，逾期金额合计<u>"));
    sTemp.append(myOutPut("2",sMethod,"name='describe22' ",getUnitData("describe22",sData))+"&nbsp;</u>元");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    
    String sEvaluateScore=DataConvert.toMoney(Sqlca.getString("select EvaluateScore from Evaluate_Record where ObjectNo='"+sCustomerID+"'  order by AccountMonth DESC fetch first 1 row only "));
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >（4）申请人资信报告信用分数：<u>"+sEvaluateScore+"&nbsp;</u>分");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    
    String sRiskEvaluate = "";		//授信风险度
	String sEvaluateModulus = "";	//资信评级系数
	String sVouchModulus = "";      //担保方式系数
	String sSql = "select RiskEvaluate,EvaluateModulus,VouchModulus from Risk_Evaluate where ObjectNo ='"+sObjectNo+"'";
    rs2 = Sqlca.getResultSet(sSql);
    if(rs2.next())
    {
    	sRiskEvaluate = rs2.getString("RiskEvaluate");
		if(sRiskEvaluate == null) sRiskEvaluate = " ";
		sEvaluateModulus = rs2.getString("EvaluateModulus");
		if(sEvaluateModulus == null) sEvaluateModulus = " ";
		sVouchModulus = rs2.getString("VouchModulus");
		if(sVouchModulus == null) sVouchModulus = " ";
    }
    rs2.getStatement().close();	
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >4、本笔业务授信风险度R：<u>"+sRiskEvaluate);
    sTemp.append("&nbsp;</u>&nbsp;&nbsp;资信评级系数：<u>"+sEvaluateModulus);
    sTemp.append("&nbsp;</u>&nbsp;&nbsp;担保方式系数：<u>"+sVouchModulus+"&nbsp;</u>");
    //sTemp.append(myOutPut("2",sMethod,"name='describe26' style='width:10%; '",getUnitData("describe26",sData))+"&nbsp;");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >5、经系统查询，申请人、家庭目前在我行贷款情况（包含已发放未结清的、尚在办理中的）：");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >（1）申请人：个人贷款累计授信余额<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe27' ",getUnitData("describe27",sData))+"&nbsp;</u>万元；累计建筑面积<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe28' ",getUnitData("describe28",sData))+"&nbsp;</u>平方米");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >（2）家庭：个人贷款累计授信余额<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe29' ",getUnitData("describe29",sData))+"&nbsp;</u>万元；累计建筑面积<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe30' ",getUnitData("describe30",sData))+"&nbsp;</u>平方米");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >本次申请住房套数认定<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe31' ",getUnitData("describe31",sData))+"&nbsp;</u>(仅限住房贷款)");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >（3）本次申请贷款的月均还款额<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe32' ",getUnitData("describe32",sData))+"&nbsp;</u>元,月还贷比<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe33' ",getUnitData("describe33",sData))+"&nbsp;</u>%");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;家庭房屋贷款支出<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe34' ",getUnitData("describe34",sData))+"&nbsp;元,</u>合计支出与收入比<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe35' ",getUnitData("describe35",sData))+"&nbsp;</u>%");
    sTemp.append("  </td> ");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=10 class=td1 >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;家庭负债总额<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe36' ",getUnitData("describe36",sData))+"&nbsp;</u>元,全部债务月均还款额与月收入比<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe37' ",getUnitData("describe37",sData))+"&nbsp;</u>%");
    sTemp.append("  </td> ");
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

