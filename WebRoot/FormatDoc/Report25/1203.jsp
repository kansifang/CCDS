<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu  2009.08.13
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
	int iDescribeCount = 3;	//这个是页面需要输入的个数，必须写对：客户化1
%>
<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	String sBusinessTypeName = "";		//业务品种
	String sBusinessSum = "";			//金额
	double dBusinessSum=0.0;
	String sTermMonth ="";            //期限
	String sCurrencyType = "";		//币种
	String sBailRatio = "";		//保证金比例
	String sBusinessRate = "";	//利率
	String sCycleFlag = "";	//是否循环
	String sVouchTypeName = "";
	ASResultSet rs2 = Sqlca.getASResultSet(" select BusinessType,getBusinessName(BusinessType) as BusinessTypeName,BusinessSum,"
										+" TermMonth,getItemName('Currency',BusinessCurrency) as CurrencyType,BailRatio,BusinessRate,"
										+" getItemName('YesNo',CYCLEFLAG) as CycleFlagName ,getItemName('VouchType',VouchType) as VouchTypeName "
										+" from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	while(rs2.next()){
		sBusinessTypeName = rs2.getString(2);
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		
		sBusinessSum = DataConvert.toMoney(rs2.getDouble(3));
		if(sBusinessSum == null) sBusinessSum = "0";	
		
		sTermMonth = rs2.getString(4);
		if(sTermMonth == null) sTermMonth = "";	
		
		sCurrencyType = rs2.getString(5);
		if(sCurrencyType == null) sCurrencyType = "";	
		
		sBailRatio = rs2.getString(6);
		if(sBailRatio == null) sBailRatio = "";	
		
		sBusinessRate = rs2.getString(7);
		if(sBusinessRate == null) sBusinessRate = "";
			
		sCycleFlag = rs2.getString(8);
		if(sCycleFlag == null) sCycleFlag = "";	
		
		sVouchTypeName = rs2.getString(9);
		if(sVouchTypeName == null) sVouchTypeName = "";
	}												
	rs2.getStatement().close();
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	//sTemp.append("<form method='post' action='0201.jsp' name='reportInfo'>");
	sTemp.append("<form method='post' action='1203.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>	");
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >");	
	sTemp.append("   <tr>	");
	sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >12.3、综合以上分析，同意按照以下方式给予授信</font></td> ");	
	sTemp.append("   </tr>");
		
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=left class=td1 > 额度类型 </td>");
    sTemp.append(" 		<td colspan='2' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td  align=left class=td1 > 授信方式 </td>");
    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
	sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=left class=td1 > 授信额度（元） </td>");
    sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
    sTemp.append(" 		<td  align=left class=td1 > 授信期限（月） </td>");
    sTemp.append(" 		<td  align=left class=td1 >"+sTermMonth+"&nbsp;</td>");
    sTemp.append(" 	</tr>"); 
       
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=left class=td1 > 授信品种 </td>");
    sTemp.append(" 		<td  align=left class=td1 >币种 </td>");
    sTemp.append(" 		<td  align=left class=td1 > 金额（元） </td>");
//    sTemp.append(" 		<td  align=left class=td1 >保证金比例 </td>");
    sTemp.append(" 		<td  align=left class=td1 >期限（月）</td>");
    sTemp.append(" 		<td  align=left class=td1 >执行月利率</td>");
//    sTemp.append(" 		<td  align=left class=td1 >是否循环</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=left class=td1 > "+sBusinessTypeName+"&nbsp; </td>");
    sTemp.append(" 		<td  align=left class=td1 >"+sCurrencyType+"&nbsp;</td>");
    sTemp.append(" 		<td   align=left class=td1 > "+sBusinessSum+"&nbsp; </td>");
//    sTemp.append(" 		<td  align=left class=td1 >"+sBailRatio+"&nbsp;</td>");
    sTemp.append(" 		<td  align=left class=td1 >"+sTermMonth+"&nbsp;</td>");
	sTemp.append(" 		<td  align=left class=td1 >"+sBusinessRate+"&nbsp;</td>");
//    sTemp.append(" 		<td  align=left class=td1 >"+sCycleFlag+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
//    sTemp.append(" 		<td  align=left class=td1 > 贷款性质</td>");
//    sTemp.append(" 		<td colspan='2' align=left class=td1 >"+""+"&nbsp;</td>");
  	sTemp.append(" 		<td  align=left class=td1 > 本次授信敞口（万元）</td>");
    sTemp.append(" 		<td  colspan='2' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td  align=left class=td1 > 授信总敞口（万元） </td>");
    sTemp.append(" 		<td  align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  align=left class=td1 > 主要担保方式 </td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sVouchTypeName+"&nbsp;</td>");
    sTemp.append(" 	</tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td  colspan='7' align=left class=td1 > <p>备注:</p> </td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='7' align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td   colspan='7' align=left class=td1 > 协办客户经理意见</td>");
    sTemp.append("	 </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='7' align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:100'",getUnitData("describe2",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td   colspan='7' align=left class=td1 > 是否同意主办客户经理意见 </td>");
    sTemp.append("	 </tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='7' align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:50'",getUnitData("describe3",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
    
    sTemp.append("   <tr>");
  	sTemp.append(" 		<td   colspan='7' align=left class=td1 > 客户经理对真实性负责，无重大遗漏 </td>");
    sTemp.append("	 </tr>");
    
    sTemp.append("   <tr>");
	sTemp.append("     <td  colspan='7' height='85' align=right class=td1 > <p> 主办人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> <p> 协办人：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p></td>");
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
	editor_generate('describe1');
	editor_generate('describe2');
	editor_generate('describe3');	
<%
	}
%>	
</script>	

	
<%@ include file="/IncludeEnd.jsp"%>
