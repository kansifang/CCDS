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
	int iDescribeCount = 5;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	String sCustomerName = "";
	String sBusinessTypeName = "";
	String sBusinessSum = "0";
	String sCurrency = "";
	double dBailRatio = 0.0;
	double dBusinessRate = 0.0;
	String sClassifyResult = "";
	String sVouchType = "";
	String sPurpose = "";
	
	ASResultSet rs2 = Sqlca.getResultSet("select CustomerName,getBusinessName(BusinessType)as BusinessType,BusinessSum,"
										+"getitemname('Currency',BusinessCurrency) as CurrencyName ,BailRatio,BusinessRate,"
										+"getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"
										+"getitemname('VouchType',VouchType) as VouchTypeName,purpose "
										+"from business_Apply where SerialNo='"+sObjectNo+"'");
	
	if(rs2.next())
	{
		sCustomerName = rs2.getString("CustomerName");
		if(sCustomerName == null) sCustomerName = "&nbsp;";
		
		sBusinessTypeName = rs2.getString("BusinessType");
		if(sBusinessTypeName == "") sBusinessTypeName = "&nbsp;";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble("BusinessSum")/10000);
		
		sCurrency = rs2.getString("CurrencyName");
		if(sCurrency == "") sCurrency = "&nbsp;";
		
		dBailRatio = rs2.getDouble("BailRatio");
		
		dBusinessRate = rs2.getDouble("BusinessRate");
		
		sClassifyResult = rs2.getString("ClassifyResult");
		if(sClassifyResult == "") sClassifyResult = "&nbsp;";
		
		sVouchType = rs2.getString("VouchTypeName");
		if(sVouchType == "") sVouchType = "&nbsp;";
		
		sPurpose = rs2.getString("purpose");
		if(sPurpose == "") sPurpose = "&nbsp;";
	}
	
	rs2.getStatement().close();	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='05.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td colspan='4' class=td1 align=center bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >（五）结论</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("<td colspan='4' align=center class=td1 >对授信申请机构的总体评价</td>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>说明授信机构的优势；综合评述授信对象的履约能力，分析你对该企业的总体印象如何，识别该企业的风险点。</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append("<td colspan='4' align=center class=td1 >经办初评人意见</td>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("<td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" ><p>对授信申请人的行业情况、市场地位、经营情况、财务状况与我行合作情况、履约能力等全面分析总结</p>");
  	sTemp.append("     <p>1、对本次授信的风险是否可控以及效益与风险能否平衡做出明确的判断；</p>");
  	sTemp.append("     <p>2、就相关风险隐患，提出具体的防范措施。</p>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append("<td colspan='4' align=center class=td1 >综合以上分析，按照以下方式申请授信</td>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  width=25% align=left class=td1 > 授信类别:</td>");
    sTemp.append(" 		<td  width=25% align=left align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td  width=25% align=left class=td1 >额度类别：</td>");
    sTemp.append(" 		<td  width=25% align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>"); 
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  width=25% align=left class=td1 > 授信期限:</td>");
    sTemp.append(" 		<td  width=25% align=left align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td  width=25% align=left class=td1 >币种：</td>");
    sTemp.append(" 		<td  width=25% align=left class=td1 >"+sCurrency+"&nbsp;</td>");
    sTemp.append(" 	</tr>"); 
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  width=25% align=left class=td1 > 授信风险限额:</td>");
    sTemp.append(" 		<td  width=25% align=left align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td  width=25% align=left class=td1 >申请授信总额(万元)：</td>");
    sTemp.append(" 		<td  width=25% align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
    sTemp.append(" 	</tr>"); 
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  width=25% align=left class=td1 > 授信品种：</td>");
    sTemp.append(" 		<td  colspan='3' align=left align=left class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
    sTemp.append(" 	</tr>"); 
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  width=25% align=left class=td1 > 备注：</td>");
    sTemp.append("   <td colspan='3' align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:80'",getUnitData("describe3",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append(" 	</tr>"); 
    
    sTemp.append("   <tr>");
  	sTemp.append("<td colspan='4' align=center class=td1 >协办人意见</td>");
  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  width=25% align=left class=td1 > 是否同意主办人意见</td>");
    sTemp.append("   <td colspan='3' align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:50'",getUnitData("describe4",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append(" 	</tr>"); 
    sTemp.append("   <tr>");
	sTemp.append("     <td  colspan='6' height='85' align=right class=td1 > <p> 主办人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> <p> 协办人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p> 负责人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p></td>");
    sTemp.append("  </tr>");
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
	editor_generate('describe2');
	editor_generate('describe3');
	editor_generate('describe4');
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>