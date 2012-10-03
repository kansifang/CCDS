<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   Author:   zwhu 2009.08.18
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
	int iDescribeCount = 12;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	//sButtons[0][0] = "false";
	sButtons[1][0] = "false";
%>
<%
	//获得调查报告数据
	String sOccurOrg = "";		//发生行
	String sBusinessType = "";			//业务品种
	String sVouchType = "";		//担保方式
	String sClassifyResult = "";		//五级分类
	String sBeginDate = "";	//起始日
	String sMaturity = "";	//到期日
	Double sBusinessSum = 0.0;			//申请金额
	Double sBalance = 0.0;		//余额
	Double  sSum = 0.0;
	Double  sSumBalance = 0.0;

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='03.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=16 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >三、借款人持股企业银企合作</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=16 align=left class=td1 >币种：（折）人民币&nbsp;&nbsp;单位：万元</td>");
	sTemp.append("	 </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=4 align=left class=td1 width='160' > 基本账户开户行 </td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 width='160' >");
    sTemp.append(myOutPut("2",sMethod,"name='describe1' style='width:100%; height:20' ",getUnitData("describe1",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=4 align=center class=td1 width='160' > 账号 </td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 width='160' >");
    sTemp.append(myOutPut("2",sMethod,"name='describe2' style='width:100%; height:20' ",getUnitData("describe2",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=4 align=left class=td1 width='160' > 其他主要开户行名称 </td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 width='160' >");
    sTemp.append(myOutPut("2",sMethod,"name='describe3' style='width:100%; height:20' ",getUnitData("describe3",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=4 align=center class=td1 width='160' > 账号 </td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 width='160' >");
    sTemp.append(myOutPut("2",sMethod,"name='describe4' style='width:100%; height:20' ",getUnitData("describe4",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
   
    sTemp.append("   <tr>");
    sTemp.append(" 		<td class=td1 align=left colspan=16 >借款人在他行未结清授信情况</td> ");	
	sTemp.append("	 </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'> 行名 </td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>品种</td>");
    sTemp.append(" 		<td colspan=2 align=center class=td1 width='80'> 授信额度</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>余额</td>");
  	sTemp.append(" 		<td colspan=2 align=center class=td1 width='80'> 起始日</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>到期日</td>");
    sTemp.append(" 		<td colspan=2 align=center class=td1 width='80'> 担保方式</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>五级分类</td>");
    sTemp.append(" 	</tr>"); 
    ASResultSet rs2 = Sqlca.getResultSet(" select OccurOrg," +
            " getItemName('OtherBusinessType',BusinessType) as BusinessType,getItemName('VouchType',VouchType) as VouchTypeName, " +
			" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,BeginDate,Maturity ,BusinessSum,Balance" +
			" from CUSTOMER_OACTIVITY " +
			" where Balance >0 and CustomerID='"+sCustomerID+"' ");
	
	while(rs2.next())
	{
		sOccurOrg = rs2.getString(1);
		if(sOccurOrg == null) sOccurOrg=" ";
		
		sBusinessType = rs2.getString(2);
		if(sBusinessType == null) sBusinessType=" ";
		
		sVouchType = rs2.getString(3);
		if(sVouchType == null) sVouchType=" ";
		sClassifyResult = rs2.getString(4);
		if(sClassifyResult == null) sClassifyResult=" ";
		
		sBeginDate = rs2.getString(5);
		
		sMaturity =rs2.getString(6);
		
		sBusinessSum =  rs2.getDouble(7);
		//if(sBusinessSum == null) sBusinessSum=" ";
		sSum+=sBusinessSum;
		sBalance =  rs2.getDouble(8);
		sSumBalance+=sBalance;
		//if(sBalance == null) sBalance=" ";
				
	
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>"+sOccurOrg+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>"+sBusinessType+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>"+sBusinessSum+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>"+sBalance+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>"+sBeginDate+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>"+sMaturity+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>"+sVouchType+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>"+sClassifyResult+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
	}
	rs2.getStatement().close();	
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 width='160'>合计</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>"+sSum+"&nbsp;</td>");
    
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>"+sSumBalance+"&nbsp;</td>");
    
    sTemp.append("  	<td colspan=8 align=left class=td1 width='320'>/&nbsp;</td>");
    sTemp.append(" 	</tr>"); 
    sTemp.append("   <tr>");
    sTemp.append(" 		<td class=td1 align=left colspan=16 >借款人在他行对外担保情况</td> ");	
	sTemp.append("	 </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td colspan=4 align=left class=td1 width='80'> 行名 </td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 width='80'>被担保企业</td>");
    sTemp.append(" 		<td colspan=2 align=center class=td1 width='80'> 币种</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>担保金额</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>担保到期日</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>主债权五级分类</td>");
    sTemp.append(" 	</tr>"); 
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:150%; height:20' ",getUnitData("describe5",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=4 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:150%; height:20' ",getUnitData("describe6",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:20' ",getUnitData("describe7",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:20' ",getUnitData("describe8",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:20' ",getUnitData("describe9",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:20' ",getUnitData("describe10",sData))+"&nbsp;</td>");
    sTemp.append(" 	</tr>"); 
    sTemp.append("   <tr>");
    sTemp.append(" 		<td colspan=8 align=left class=td1 width='80'>合计</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:20' ",getUnitData("describe11",sData))+"&nbsp;</td>");
    sTemp.append(" 		<td colspan=2 align=left class=td1 width='80'>");
    sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:20' ",getUnitData("describe12",sData))+"&nbsp;</td>");
    sTemp.append("  	<td colspan=4 align=left class=td1 width='80'>/");
    sTemp.append(" 	</tr>"); 
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
