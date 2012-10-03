<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: 报告的第05页
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
	int iDescribeCount = 74;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader1.jsp"%>

<%
	//获得调查报告数据

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='05.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >五、租金分析</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >测算租金收入：对贷款期限内借款人的还款能力进行评测。其中，须按照租赁合同中对于税费、物业费等项目的约定，租金收入中须扣除由出租人承担的物业管理费及营业税等。</td> ");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >项目</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >1&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >2&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >3&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >4&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >5&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >6&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >7&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >8&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >9&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >10</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >11</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >12</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1  align=left class=td1 >一</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >租金流入</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%;' ",getUnitData("describe1",sData))+"");
    sTemp.append(" &nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%;' ",getUnitData("describe2",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%;' ",getUnitData("describe3",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%;' ",getUnitData("describe4",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%;' ",getUnitData("describe5",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%;' ",getUnitData("describe6",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%;' ",getUnitData("describe7",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%;' ",getUnitData("describe8",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%;' ",getUnitData("describe9",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%;' ",getUnitData("describe10",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%;' ",getUnitData("describe11",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%;' ",getUnitData("describe12",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1  align=left class=td1 >二</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >税费支出</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%;' ",getUnitData("describe13",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%;' ",getUnitData("describe14",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%;' ",getUnitData("describe15",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%;' ",getUnitData("describe16",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%;' ",getUnitData("describe17",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:100%;' ",getUnitData("describe18",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:100%;' ",getUnitData("describe19",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:100%;' ",getUnitData("describe20",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:100%;' ",getUnitData("describe21",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:100%;' ",getUnitData("describe22",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe23' style='width:100%;' ",getUnitData("describe23",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe24' style='width:100%;' ",getUnitData("describe24",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1  align=left class=td1 >1</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >税金支出</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe25' style='width:100%;' ",getUnitData("describe25",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe26' style='width:100%;' ",getUnitData("describe26",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe27' style='width:100%;' ",getUnitData("describe27",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe28' style='width:100%;' ",getUnitData("describe28",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe29' style='width:100%;' ",getUnitData("describe29",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe30' style='width:100%;' ",getUnitData("describe30",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe31' style='width:100%;' ",getUnitData("describe31",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe32' style='width:100%;' ",getUnitData("describe32",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe33' style='width:100%;' ",getUnitData("describe33",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe34' style='width:100%;' ",getUnitData("describe34",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe35' style='width:100%;' ",getUnitData("describe35",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe36' style='width:100%;' ",getUnitData("describe36",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1  align=left class=td1 >2</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >物业费支出</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe37' style='width:100%;' ",getUnitData("describe37",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe38' style='width:100%;' ",getUnitData("describe38",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe39' style='width:100%;' ",getUnitData("describe39",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe40' style='width:100%;' ",getUnitData("describe40",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe41' style='width:100%;' ",getUnitData("describe41",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe42' style='width:100%;' ",getUnitData("describe42",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe43' style='width:100%;' ",getUnitData("describe43",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe44' style='width:100%;' ",getUnitData("describe44",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe45' style='width:100%;' ",getUnitData("describe45",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe46' style='width:100%;' ",getUnitData("describe46",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe47' style='width:100%;' ",getUnitData("describe47",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe48' style='width:100%;' ",getUnitData("describe48",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1  align=left class=td1 >3</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >其它支出</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe49' style='width:100%;' ",getUnitData("describe49",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe50' style='width:100%;' ",getUnitData("describe50",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe51' style='width:100%;' ",getUnitData("describe51",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe52' style='width:100%;' ",getUnitData("describe52",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe53' style='width:100%;' ",getUnitData("describe53",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe54' style='width:100%;' ",getUnitData("describe54",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe55' style='width:100%;' ",getUnitData("describe55",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe56' style='width:100%;' ",getUnitData("describe56",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe57' style='width:100%;' ",getUnitData("describe57",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe58' style='width:100%;' ",getUnitData("describe58",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe59' style='width:100%;' ",getUnitData("describe59",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe60' style='width:100%;' ",getUnitData("describe60",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1  align=left class=td1 >三</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >净现金流量</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe61' style='width:100%;' ",getUnitData("describe61",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe62' style='width:100%;' ",getUnitData("describe62",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe63' style='width:100%;' ",getUnitData("describe63",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe64' style='width:100%;' ",getUnitData("describe64",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe65' style='width:100%;' ",getUnitData("describe65",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe66' style='width:100%;' ",getUnitData("describe66",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe67' style='width:100%;' ",getUnitData("describe67",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe68' style='width:100%;' ",getUnitData("describe68",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe69' style='width:100%;' ",getUnitData("describe69",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe70' style='width:100%;' ",getUnitData("describe70",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe71' style='width:100%;' ",getUnitData("describe71",sData))+"");
    sTemp.append("&nbsp;</td>");
    sTemp.append("   <td colspan=1  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe72' style='width:100%;' ",getUnitData("describe72",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1  align=left class=td1 >四</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >累计净现金流量</td>");
	sTemp.append("   <td colspan=12  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe73' style='width:100%;' ",getUnitData("describe73",sData))+"");
    sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=1  align=left class=td1 >五</td>");
	sTemp.append("   <td colspan=1  align=left class=td1 >累计应还本息</td>");
	sTemp.append("   <td colspan=12  align=left class=td1 >");
    sTemp.append(myOutPut("2",sMethod,"name='describe74' style='width:100%;' ",getUnitData("describe74",sData))+"");
    sTemp.append("&nbsp;</td>");
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
	//editor_generate('describe1');		//需要html编辑,input是没必要 
																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

