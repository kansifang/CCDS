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
	int iDescribeCount = 23;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='030301.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3、企业保证:(保证人为借款人贷款用途所指向的经营类贷款企业做保证时不填)</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3.1、企业经营及年检情况：</font></td>"); 	
	sTemp.append("   </tr>");	
	

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3.1.1、企业经营情况总体描述：</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3.1.1.1、行业背景、企业规模、融资能力</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' colspan=2 align=center class=td1 >经营产品</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >资产规模（万元）</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' colspan=2 align=center class=td1 >其中固定资产（万元）</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:25'",getUnitData("describe3",sData)));
  	sTemp.append("&nbsp;</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >流动资产（万元）</td>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >");
  	sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
  	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left height='34' colspan=20>银行负债情况</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='20' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");

    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3.1.1.2、所处发展阶段和行业地位、产品的特性以及主要产品在总销售收入和毛利占比情况</font></td>"); 	
	sTemp.append("   </tr>");	

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left height='34' colspan=20>企业所处阶段</font></td>"); 	
	sTemp.append("   </tr>");	

	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=20 class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe6'",getUnitData("describe6",sData),"创业期@成长期@成熟期@衰退期@其他"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");


    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3.1.1.3、企业竞争能力分析</font></td>"); 	
	sTemp.append("   </tr>");	

	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=20 class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe11'",getUnitData("describe11",sData),"区域范围内竞争能力强@区域范围内竞争能力一般@区域范围内竞争能力差@其他"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3.1.1.4、产品市场分析</font></td>"); 	
	sTemp.append("   </tr>");	

	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td colspan=20 class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe15'",getUnitData("describe15",sData),"市场同类产品多，但性价比较高@市场同类产品少，替代产品少@其他"));
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >3.3.2、企业近3年的年检情况、纳税情况</font></td>"); 	
	sTemp.append("   </tr>");	
	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td  class=td1 >按年年检：");
	
	sTemp.append("   </td>");
    sTemp.append(" 	 <td colspan=20 class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe18'",getUnitData("describe18",sData),"是@否@其他"));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
    sTemp.append(" 	 <td  class=td1 >按期纳税：");
	
	sTemp.append("   </td>");
    sTemp.append(" 	 <td  colspan=20  class=td1 >");
	sTemp.append(myOutPutCheck("3",sMethod,"name='describe21'",getUnitData("describe21",sData),"是@否@其他"));
	sTemp.append("   &nbsp;</td>");
	sTemp.append("   </tr>");

	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20  >&nbsp</font></td>"); 	
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