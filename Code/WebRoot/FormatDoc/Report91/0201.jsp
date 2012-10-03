<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   wangdw 2012.05.21
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
	int iDescribeCount = 42;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2、贷款用途和第一还款来源分析</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.1、企业基本情况：</font></td>"); 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
  	sTemp.append("   <td height='34' width=10% align=left class=td1 >2.1.1</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >企业名称：</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >注册资本（万元）：</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td height='34' width=5% align=left class=td1 >2.1.2</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >企业成立时间：</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:25'",getUnitData("describe3",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >主营业务：</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td height='34' width=5% align=left class=td1 >2.1.3</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >基本账户开户行：</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:25'",getUnitData("describe5",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >帐号：</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:25'",getUnitData("describe6",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td height='34' width=5% align=left class=td1 >2.1.4</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >我行开户情况：</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:25'",getUnitData("describe7",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >当前存款余额</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:25'",getUnitData("describe8",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2、企业经营情况总体描述：</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.1、行业背景、企业规模、融资能力</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' colspan=2 align=center class=td1 >经营产品</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:25'",getUnitData("describe9",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >资产规模（万元）</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:25'",getUnitData("describe10",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' colspan=2 align=center class=td1 >其中固定资产（万元）</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:25'",getUnitData("describe11",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >流动资产（万元）</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:25'",getUnitData("describe12",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left height='34' colspan=20>银行负债情况</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='20' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe13' style='width:100%; height:150'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");

    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.2、所处发展阶段和行业地位、产品的特性以及主要产品在总销售收入和毛利占比情况</font></td>"); 	
	sTemp.append("   </tr>");	


	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=20 class=td1 >");
    sTemp.append("   企业所处阶段"); 
    sTemp.append(myOutPutCheck("3",sMethod,"name='describe14'",getUnitData("describe14",sData),"创业期@成长期@成熟期@衰退期@其他"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");


    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.3、企业竞争能力分析</font></td>"); 	
	sTemp.append("   </tr>");	

	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=20 class=td1 >");
    sTemp.append(myOutPutCheck("3",sMethod,"name='describe19'",getUnitData("describe19",sData),"区域范围内竞争能力强@区域范围内竞争能力一般@区域范围内竞争能力差@其他"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.2.4、产品市场分析</font></td>"); 	
	sTemp.append("   </tr>");	

	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=20 class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe23'",getUnitData("describe23",sData),"市场同类产品多，但性价比较高@市场同类产品少，替代产品少@其他"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.3、企业近3年的年检情况、纳税情况</font></td>"); 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td  colspan=20  class=td1 >按年年检：");
	
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe26'",getUnitData("describe26",sData),"是@否@其他"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=20   class=td1 >按期纳税：");
	
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe29'",getUnitData("describe29",sData),"是@否@其他"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >2.4、企业贷款用途具体说明及支付方式</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left height='34' colspan=20>贷款用途</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='20' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe32' style='width:100%; height:150'",getUnitData("describe32",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left height='34' colspan=20>支付方式</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan='20'  class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe33'",getUnitData("describe33",sData),"自主支付"));
	sTemp.append("   &nbsp;</td>");
	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan='20'  class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe34'",getUnitData("describe34",sData),"受托支付"));
    sTemp.append("&nbsp收款人名称<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe35' style='width:20%; height:25'",getUnitData("describe35",sData)));
	sTemp.append("</u>&nbsp开户行<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe36' style='width:20%; height:25'",getUnitData("describe36",sData)));
	sTemp.append("</u>&nbsp账号<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe37' style='width:20%; height:25'",getUnitData("describe37",sData)));
	sTemp.append("</u>   &nbsp;</td>");


	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan='20'  class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe38'",getUnitData("describe38",sData),"部分自主支付部分受托支付"));
    sTemp.append("&nbsp收款人名称<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe39' style='width:8%; height:25'",getUnitData("describe39",sData)));
    sTemp.append("</u>受托支付收款人名称<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe40' style='width:8%; height:25'",getUnitData("describe40",sData)));
	sTemp.append("</u>开户行<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe41' style='width:8%; height:25'",getUnitData("describe41",sData)));
	sTemp.append("</u>账号<u>");
	sTemp.append(myOutPut("2",sMethod,"name='describe42' style='width:8%; height:25'",getUnitData("describe42",sData)));
	sTemp.append("</u></td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=20 align=left class=td1 nowrap>&nbsp</td>");
	sTemp.append("</tr>");
	
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