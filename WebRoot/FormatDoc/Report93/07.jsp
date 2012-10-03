<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: 报告的第07页
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
	int iDescribeCount = 25;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='07.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >七、风险点及风险缓释措施</font></td> ");	
	sTemp.append("   </tr>");
	/*
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >1.确认是否存在以下风险点，包括但不限于：</td> ");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >(1)关于真实性的风险点:</td> ");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe1'",getUnitData("describe1",sData),"★借款人与承租方之间是否存在关联关系，租金合同及租金价格是否真实可靠；"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe2'",getUnitData("describe2",sData),"★租金收付是否具有可信的收付凭证，与租赁合同中租金水平是否一致；</br>"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >(2)关于第一还款来源的风险点:</td> ");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe3'",getUnitData("describe3",sData),"★租赁合同是否存在租金抵扣、违约处罚等影响借款人租金收入的条款，或存在租金已提前支付等情况；"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe4'",getUnitData("describe4",sData),"★租赁期限是否可以覆盖贷款期限，如不能全部覆盖，则租赁合同到期后是否存在断租或租金下降的风险；"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe5'",getUnitData("describe5",sData),"★是否存在租金支付周期与还款周期错配的情况；"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe6'",getUnitData("describe6",sData),"★租金支付方式为现金支付还是转账支付，前期租赁收入是否能覆盖应还本息，是否存在租金监管账户无资金流入及不足的风险；"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe7'",getUnitData("describe7",sData),"★承租方的经营情况是否正常，是否具有稳定、可靠的租金支付能力；"));
	sTemp.append("   </br>");
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >(3)关于第二还款来源的风险点:</td> ");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe8'",getUnitData("describe8",sData),"★抵押物的土地使用权类型、土地用途和房屋用途，是否属于总行禁止叙做的范围，抵押物共有人中是否未成年人等影响抵押权利落实的情况；"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe9'",getUnitData("describe9",sData),"★抵押土地和房产是否存在产权纠纷、法律诉讼等影响我行抵押权利有效落实的情况；"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe10'",getUnitData("describe10",sData),"★租赁合同及补充协议中，是否存在约束抵押物转让、抵押的条款影响我行抵押权利有效落实的情况；"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe11'",getUnitData("describe11",sData),"★抵押物的评估价值或交易价值是否存在虚高嫌疑；"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe12'",getUnitData("describe12",sData),"★抵押物是否属于出险概率较高的抵押物（如台风、龙卷风高发的沿海地区临海房屋；泥石流高发地区的临山房屋；砖木结构容易发生火灾的房屋；用于储存易燃、易爆等物品的房屋）；"));
	sTemp.append("   	</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >(4)关于贷款用途的风险点:</td> ");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan=1 align=left class=td1 >");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe13'",getUnitData("describe13",sData),"★是否存在违反总行及外部监管机构相关规定的用途；"));
	sTemp.append("   </br>");
	sTemp.append(myOutPutCheck("4",sMethod,"name='describe14'",getUnitData("describe14",sData),"★是否存在影响贷后落实、监控贷款资金用途的情况；"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	*/
	
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >1.确认是否存在以下风险点，包括但不限于：</br> ");
	sTemp.append("   (1)关于真实性的风险点:</br> ");
	sTemp.append("★借款人与承租方之间是否存在关联关系，租金合同及租金价格是否真实可靠；</br>");
	sTemp.append("★租金收付是否具有可信的收付凭证，与租赁合同中租金水平是否一致；</br>");
	sTemp.append("   (2)关于第一还款来源的风险点:</br> ");
	sTemp.append("★租赁合同是否存在租金抵扣、违约处罚等影响借款人租金收入的条款，或存在租金已提前支付等情况；</br>");
	sTemp.append("★租赁期限是否可以覆盖贷款期限，如不能全部覆盖，则租赁合同到期后是否存在断租或租金下降的风险；</br>");
	sTemp.append("★是否存在租金支付周期与还款周期错配的情况；</br>");
	sTemp.append("★租金支付方式为现金支付还是转账支付，前期租赁收入是否能覆盖应还本息，是否存在租金监管账户无资金流入及不足的风险；</br>");
	sTemp.append("★承租方的经营情况是否正常，是否具有稳定、可靠的租金支付能力；</br>");
	sTemp.append("  (3)关于第二还款来源的风险点: </br>");
	sTemp.append("★抵押物的土地使用权类型、土地用途和房屋用途，是否属于总行禁止叙做的范围，抵押物共有人中是否未成年人等影响抵押权利落实的情况；</br>");
	sTemp.append("★抵押土地和房产是否存在产权纠纷、法律诉讼等影响我行抵押权利有效落实的情况；</br>");
	sTemp.append("★租赁合同及补充协议中，是否存在约束抵押物转让、抵押的条款影响我行抵押权利有效落实的情况；</br>");
	sTemp.append("★抵押物的评估价值或交易价值是否存在虚高嫌疑；</br>");
	sTemp.append("★抵押物是否属于出险概率较高的抵押物（如台风、龙卷风高发的沿海地区临海房屋；泥石流高发地区的临山房屋；砖木结构容易发生火灾的房屋；用于储存易燃、易爆等物品的房屋）；</br>");
	sTemp.append("   (4)关于贷款用途的风险点:</br> ");
	sTemp.append("★是否存在违反总行及外部监管机构相关规定的用途；</br>");
	sTemp.append("★是否存在影响贷后落实、监控贷款资金用途的情况；</br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=14 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=14  >2.风险缓释措施：根据上述存在的风险点，制定具有针对性的风险缓释措施。 ");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=14 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
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
	editor_generate('describe1');		//需要html编辑,input是没必要
	editor_generate('describe2');		//需要html编辑,input是没必要  
																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

