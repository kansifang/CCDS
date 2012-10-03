<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
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
   int iDescribeCount = 26;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//获得调查报告数据
//Add by zhaominglei 060308
    double dEvaluateModulus = 0.0; //资信评级系数
	double dVouchModulus = 0.0;    //担保方式系数
    double dRiskEvaluate = 0.0;    //授信风险度
    String sCustomerName = "";     //客户名称
    String sEvaluateScore = "";   //资信报告评级分数
	//申请人基本信息
	sCustomerName = Sqlca.getString("select FullName from IND_INFO where CustomerID = (select CustomerID from BUSINESS_APPLY where SerialNo ='"+sObjectNo+"')");
	ASResultSet rs2 = Sqlca.getResultSet("select VouchModulus,RiskEvaluate,EvaluateModulus from Risk_Evaluate where ObjectNo ='"+sObjectNo+"' and ObjectType='CreditApply'");
	if(rs2.next())
	{
		dVouchModulus = rs2.getDouble("VouchModulus");
		dRiskEvaluate = rs2.getDouble("RiskEvaluate");
		dEvaluateModulus = rs2.getDouble("EvaluateModulus");
	}
	rs2.getStatement().close();	
    sEvaluateScore=DataConvert.toMoney(Sqlca.getString("select EvaluateScore from Evaluate_Record where ObjectNo='"+sCustomerID+"'  order by AccountMonth DESC fetch first 1 row only "));

	//select TermModulus,RiskEvaluate from Risk_Evaluate where ObjectNo ='BA2012013000000001' and ObjectType='CreditApply'
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
StringBuffer sTemp=new StringBuffer();
sTemp.append("	<form method='post' action='02.jsp' name='reportInfo'>");	
sTemp.append("<div id=reporttable style=' FONT-FAMILY:宋体; '>");	

	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >1、借款申请及相关资料</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=10 align=left class=td1 >");
	sTemp.append("   本人对借款人<u>"+sCustomerName+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("的借款申请及有关资料已经审核，情况如实反映如下：");
	

	sTemp.append("   <br>");

    sTemp.append("   (1)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe0'",getUnitData("describe0",sData),"本地居民"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"本市工作"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"非本市工作"));

	sTemp.append("   <br>");
	//sTemp.append("   <td colspan=2 align=left class=td1 >(2)</td>");

    sTemp.append("   (2)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"外地居民"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"本市工作"));
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe5'",getUnitData("describe5",sData),"非本市工作"));	
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe6'",getUnitData("describe6",sData),"有本市居住证明"));
    sTemp.append(myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"无本市居住证明"));

	sTemp.append("   <br>");
	//sTemp.append("   <td colspan=2 align=left class=td1 >(3)</td>");

    sTemp.append("   (3)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"境外人士"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe9'",getUnitData("describe9",sData),"本市工作"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe10'",getUnitData("describe10",sData),"非本市工作"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe11'",getUnitData("describe11",sData),"有本市居住证明"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe12'",getUnitData("describe12",sData),"无本市居住证明"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2、根据申请人借款期限计算</font></td>"); 	
	sTemp.append(" </tr>");	
	sTemp.append(" <tr>");
    sTemp.append(" <td colspan=10 align=left class=td1 > 借款到期时申请人年龄为：");
	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:15%; height:25'",getUnitData("describe13",sData)));   
	sTemp.append(" 周岁");
    sTemp.append(" </tr>"); 
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3、经查询个人资信资料，申请人、配偶、共有人资信情况如下：</font></td>"); 	
	sTemp.append(" </tr>");
    sTemp.append(" <tr>");
    //sTemp.append(" <td colspan=1 align=left class=td1 >(1)</td>");
	sTemp.append(" <td colspan=10 align=left class=td1 >");
	sTemp.append(" (1)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe14'",getUnitData("describe14",sData),"无不良信用记录"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe15'",getUnitData("describe15",sData),"无其他借款"));
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe16'",getUnitData("describe16",sData),"在个人征信系统中无记录"));
    //sTemp.append(" <td colspan=1 align=left class=td1 >(2)</td>");
	sTemp.append(" <br>");
	sTemp.append(" (2)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe17'",getUnitData("describe17",sData),"有其他借款，合计"));
	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:15%; height:25'",getUnitData("describe18",sData)));
	sTemp.append("  笔，合计月还款");
	sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:15%; height:25'",getUnitData("describe19",sData)));
	sTemp.append("  元 ");	
    sTemp.append("  <br>");
   // sTemp.append("  <td colspan=1 align=left class=td1 >(3)</td>");
	sTemp.append(" (3)&nbsp");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe20'",getUnitData("describe20",sData),"有借款逾期，逾期金额合计"));
	sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:15%; height:25'",getUnitData("describe21",sData)));
	sTemp.append("  元"); 	  
    sTemp.append("  <br>");
    //sTemp.append("  <td colspan=1 align=left class=td1 >(4)</td>");
    sTemp.append("  (4)&nbsp申请人资信报告信用分数:<u>"+sEvaluateScore+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:15%; height:25'",getUnitData("describe22",sData)));	
	sTemp.append("  分");
	sTemp.append("  &nbsp;</td>");   
    sTemp.append("  </tr>"); 
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=20 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4、本笔业务授信风险度</font></td>"); 	
	sTemp.append("   </tr>");		
	sTemp.append("   <tr>");     	   
    sTemp.append("   <td  colspan=20 align=left class=td1 > 本笔业务授信风险度R：<u>"+dRiskEvaluate+"</u>");	
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("   资信评级系数：<u>"+dEvaluateModulus+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("   担保方式系数：<u>"+dVouchModulus+"</u>");
	//sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:15%; height:25'",getUnitData("describe9",sData)));
	sTemp.append("   &nbsp;</td>");   
    sTemp.append("   </tr>"); 
	
	sTemp.append("  <tr>");	
	sTemp.append("  <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5、经系统查询，申请人、家庭目前在我行贷款情况（包含已发放未结清的、尚在办理中的）</font></td>"); 	
	sTemp.append("  </tr>");		
	sTemp.append("  <tr>");
    //sTemp.append("  <td colspan=1 align=left class=td1 >(1)</td>");
    sTemp.append("  <td colspan=10  align=left class=td1 > (1)&nbsp申请人：个人贷款累计授信余额");
	sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:15%; height:25'",getUnitData("describe22",sData)));
	sTemp.append("  万元；&nbsp&nbsp累计建筑面积");    	
	sTemp.append(myOutPut("2",sMethod,"name='describe23' style='width:15%; height:25'",getUnitData("describe23",sData)));
	sTemp.append("  平方米 ");  
    //sTemp.append("  <td colspan=1 align=left class=td1 >(2)</td>");
    sTemp.append("  <br>");
    sTemp.append("  (2)&nbsp家&nbsp&nbsp庭：个人贷款累计授信余额");
	sTemp.append(myOutPut("2",sMethod,"name='describe24' style='width:15%; height:25'",getUnitData("describe24",sData)));  
	sTemp.append("  万元；&nbsp&nbsp累计建筑面积");	    
	sTemp.append(myOutPut("2",sMethod,"name='describe25' style='width:15%; height:25'",getUnitData("describe25",sData))); 
	sTemp.append("  平方米 ");	
	sTemp.append("  &nbsp;</td>");    
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
