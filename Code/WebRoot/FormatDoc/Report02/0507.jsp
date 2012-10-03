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
	int iDescribeCount = 1;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//获得调查报告数据
	
	String sDate = StringFunction.getToday();
	String sYear = sDate.substring(0,4);
	int iYear = Integer.parseInt(sYear);
	String sYearN = String.valueOf(iYear - 1)+"/12";
	String sYearN_1 = String.valueOf(iYear - 2)+"/12";
	String sYearN_2 = String.valueOf(iYear - 3)+"/12";
	String sSql = " select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
				  +" where reportdate = '"+sYearN+"' and objectno = '"+sCustomerID+"' and ReportName ='财务指标表' and ReportScope = GETEVALUATESCOPE('"+sCustomerID+"','"+sYearN+"'))";
	//out.println(sSql);
	String sRowName[] = {"907","908","905"," ","906"};
	String sCol2Value[]={"","","","",""};
	String sCol2Value1[]={"","","","",""};
	String sCol2Value2[]={"","","","",""};
	
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		String RowName = rs2.getString("RowSubject");
		if(RowName.equals(sRowName[0])) sCol2Value[0]=DataConvert.toMoney(365/rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[1])) sCol2Value[1]=DataConvert.toMoney(365/rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[2])) sCol2Value[2]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[3])) sCol2Value[3]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[4])) sCol2Value[4]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
	}
	rs2.getStatement().close();	
	
	sSql = " select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
				  +" where reportdate = '"+sYearN_1+"' and objectno = '"+sCustomerID+"' and ReportName ='财务指标表' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sYearN_1+"'))";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		String RowName = rs2.getString("RowSubject");
		if(RowName.equals(sRowName[0])) sCol2Value1[0]=DataConvert.toMoney(365/rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[1])) sCol2Value1[1]=DataConvert.toMoney(365/rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[2])) sCol2Value1[2]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[3])) sCol2Value1[3]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[4])) sCol2Value1[4]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
	}
	rs2.getStatement().close();
	
	sSql = " select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
				  +" where reportdate = '"+sYearN_2+"' and objectno = '"+sCustomerID+"' and ReportName ='财务指标表' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sYearN_2+"'))";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		String RowName = rs2.getString("RowSubject");
		if(RowName.equals(sRowName[0])) sCol2Value2[0]=DataConvert.toMoney(365/rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[1])) sCol2Value2[1]=DataConvert.toMoney(365/rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[2])) sCol2Value2[2]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[3])) sCol2Value2[3]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
		else if(RowName.equals(sRowName[4])) sCol2Value2[4]=DataConvert.toMoney(rs2.getDouble("Col2Value"));
	}
	rs2.getStatement().close();	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0507.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.7、营运能力分析</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% height=34 align=center class=td1 >项目</td>");
	sTemp.append("   <td width=23% align=center class=td1 >"+(iYear-1)+"年</td>");
	sTemp.append("   <td width=23% align=center class=td1 >"+(iYear-2)+"年</td>");
	sTemp.append("   <td width=24% align=center class=td1 >"+(iYear-3)+"年</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 >应收账款周转天数</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value[0]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value1[0]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value2[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 >存货周转天数</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value[1]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value1[1]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value2[1]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 >总资产周转率</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value[2]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value1[2]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value2[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 >流动资产周转率</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value[3]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value1[3]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value2[3]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=25% align=left class=td1 >固定资产周转率</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value[4]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value1[4]+"&nbsp;</td>");
	sTemp.append("   <td width=25% align=right class=td1 >"+sCol2Value2[4]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 "+myShowTips(sMethod)+" > 分析： <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
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
	editor_generate('describe1');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>