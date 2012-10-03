<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 20100506
		Tester:
		Content: 报告的第0页
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
	int iDescribeCount = 9;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='02.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >三、借款人主体资格是否符合我行相关管理办法要求的条件</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >提供基础材料是否齐全，合规");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:100'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >四、贷款用途的合理合规性审查</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >申请贷款业务品种与我行目前开办业务是否相符，申请贷款用途是否符合上报业务品种要求。存量贷款需明确原始贷款日期、原始贷款用途、该笔贷款的倒贷流程，");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >五、第一还款来源分析</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >借款人第一还款来源是什么？<br/>借款人以前年度经营情况分析/借款人收入情况分析");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:100'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >六、第二还款来源分析</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >抵押物情况分析<br/>"+
		"抵押物坐落地址、房号、土地性质、评估单位、评估（预评估）时间、评估（预评估）价值、评估单价、抵押率、抵押单价。<br/>"+
		"保证人、保证人情况分析<br/>"+
		"担保人姓名、从事行业、经营情况<br/>"+
		"担保单位名称、担保单位上年度资产、负债、所有者权益、经营收入、净利润情况，企业资产负债率、资信等级、授信风险限额。");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:100'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >七、其它情况说明</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1 "+myShowTips(sMethod)+" >1、借款人及共有人在本系统及人行征信情况：（含个贷系统数据）<br/>"+
		"2、担保人及共有人在本系统及人行征信情况：（含个贷系统数据）<br/>"+
		"3、其他情况说明：");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:100'",getUnitData("describe5",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >八、授信风险点及风险防范措施</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:100'",getUnitData("describe6",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >九、收益分析</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe7' style='width:100%; height:100'",getUnitData("describe7",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=2 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >十、 审查意见</font></td>"); 	
	sTemp.append("   </tr>");
 	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1>审查意见:");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe8' style='width:100%; height:100'",getUnitData("describe8",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
  	sTemp.append("   <tr>");   
  	sTemp.append("<td align=left class=td1>贷款发放前需要落实的条件：");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe9' style='width:100%; height:100'",getUnitData("describe9",sData)));
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>"); 
 	sTemp.append("   <tr>");
  	sTemp.append("   <td  align=right class=td1 >审查人员："+CurUser.UserName+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	sTemp.append("日期："+StringFunction.getToday()+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br/><br/><br/></td>");
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
	editor_generate('describe1');
	editor_generate('describe2');
	editor_generate('describe3');
	editor_generate('describe4');
	editor_generate('describe5');
	editor_generate('describe6');
	editor_generate('describe7');
	editor_generate('describe8');
	editor_generate('describe9');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
