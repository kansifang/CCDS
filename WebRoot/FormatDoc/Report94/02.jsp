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
	int iDescribeCount = 14;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
   //获得调查报告数据
    double dEvaluateModulus = 0.0; //资信评级系数
    double dVouchModulus = 0.0;  //担保方式系数
    double dRiskEvaluate = 0.0;  //授信风险度
	//申请人基本信息
	//sVouchModulus1 = Sqlca.getString("select CL.Attribute3 from code_library CL ,BUSINESS_APPLY BA where BA.VouchType =CL.ItemNo and CL.CodeNo='VouchType' and BA.SerialNo ='"+sObjectNo+"'");
	ASResultSet rs2 = Sqlca.getResultSet("select VouchModulus,RiskEvaluate,EvaluateModulus from Risk_Evaluate where ObjectNo ='"+sObjectNo+"' and ObjectType='CreditApply'");
	if(rs2.next())
	{
		dVouchModulus = rs2.getDouble("VouchModulus");
		dRiskEvaluate = rs2.getDouble("RiskEvaluate");
		dEvaluateModulus = rs2.getDouble("EvaluateModulus");
	}
	rs2.getStatement().close();
%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='02.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 colspan=20 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >4、本笔业务授信风险度</font></td>"); 	
	sTemp.append("   </tr>");		
	sTemp.append("   <tr>");     	   
    sTemp.append("   <td  colspan=20 align=left class=td1 > 本笔业务授信风险度R：<u>"+dRiskEvaluate+"</u>");	
	sTemp.append("   资信评级系数：<u>"+dEvaluateModulus+"</u>");
	sTemp.append("   担保方式系数：<u>"+dVouchModulus+"</u>");
	sTemp.append("   &nbsp;</td>");   
    sTemp.append("   </tr>");
    sTemp.append("  <tr>");	
	sTemp.append("  <td class=td1 colspan=10 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5、经系统查询，申请人、家庭目前在我行贷款情况（包含已发放未结清的、尚在办理中的）</font></td>"); 	
	sTemp.append("  </tr>");		
	sTemp.append("  <tr>");
    //sTemp.append("  <td colspan=1 align=left class=td1 >(1)</td>");
    sTemp.append("  <td colspan=10  align=left class=td1 > (1)&nbsp申请人：个人贷款累计授信余额<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:15%; height:25'",getUnitData("describe0",sData)));
	sTemp.append("</u>万元；&nbsp&nbsp累计建筑面积<u>");    	
	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:15%; height:25'",getUnitData("describe1",sData)));
	sTemp.append("</u>平方米 ");  

	sTemp.append("  <br>");
    //sTemp.append("  <td colspan=1 align=left class=td1 >(2)</td>");
    sTemp.append("  (2)&nbsp家&nbsp&nbsp庭：个人贷款累计授信余额<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:15%; height:25'",getUnitData("describe2",sData)));  
	sTemp.append("</u>万元；&nbsp&nbsp累计建筑面积<u>");	    
	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:15%; height:25'",getUnitData("describe3",sData))); 
	sTemp.append("</u>平方米 ");	

    sTemp.append("  <br>");
    sTemp.append("  (3)&nbsp本次申请贷款月均还款额<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:15%; height:25'",getUnitData("describe4",sData))); 
    sTemp.append("</u>元，月贷款比<u>");	
    sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:15%; height:25'",getUnitData("describe5",sData))); 
    sTemp.append("</u>%&nbsp;<br>"); 
    sTemp.append("  &nbsp&nbsp&nbsp&nbsp家庭房屋贷款支出<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:15%; height:25'",getUnitData("describe13",sData))); 
    sTemp.append("</u>元，合计支出与收入比<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:15%; height:25'",getUnitData("describe6",sData))); 
    sTemp.append("</u>%&nbsp;<br>"); 
    sTemp.append("  &nbsp&nbsp&nbsp&nbsp家庭负债总额<u>");
    sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:15%; height:25'",getUnitData("describe7",sData))); 
    sTemp.append("</u>元，全部债务月均还款额与月收入比<u>");	
    sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:15%; height:25'",getUnitData("describe8",sData))); 
    sTemp.append("</u>%&nbsp;</td>");     
    sTemp.append("  </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1  colspan=10 >注：如借款人做为企业最大股东、实际控制人或法人，持有企业一定比例股份的，可按照企业上一年度或截止申请日最新报表，企业可分配纯利润（应付股利）按借款人持股比例折算收入，纳入借款人的月收入后核定月收入和月供占比");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");    
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >6、借款人持股企业调查结论</font></td>"); 	
	sTemp.append("   </tr>");	
	//sTemp.append("   <tr>");
  	//sTemp.append("   <td width=15% align=left class=td1 "+myShowTips(sMethod)+" >明确授信业务发放的前提条件和要求，如限制性条约等等，提出贷后监控方面所需注意事项。");
  	//sTemp.append("   </td>");
    //sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=10  class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:75'",getUnitData("describe9",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");   
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7、其他情况说明</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1  colspan=10>(1)&nbsp借款人及其家庭其他资产情况</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td  align=left class=td1  colspan=10>");
  	sTemp.append(myOutPut("1",sMethod,"name='describe10' style='width:100%; height:50'",getUnitData("describe10",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 colspan=10>(2)&nbsp借款人及其家庭其他负债情况</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td  align=left class=td1  colspan=10>");
  	sTemp.append(myOutPut("1",sMethod,"name='describe11' style='width:100%; height:50'",getUnitData("describe11",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 colspan=10>(3)&nbsp其它需要说明的情况</td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
	sTemp.append("   <td  align=left class=td1  colspan=10>");
  	sTemp.append(myOutPut("1",sMethod,"name='describe12' style='width:100%; height:50'",getUnitData("describe12",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("</div>");
	sTemp.append("</table>");	
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
	editor_generate('describe9');		//需要html编辑,input是没必要
	editor_generate('describe10');	
	editor_generate('describe11');	
	editor_generate('describe12');	
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
