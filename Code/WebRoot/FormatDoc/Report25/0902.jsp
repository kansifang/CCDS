<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.21
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
	
	String sDate = StringFunction.getToday();
	String sYear = sDate.substring(0,4);
	int iYear = Integer.parseInt(sYear);
	String sxjYearReportDate[] = {"","","",""};
	String sYearN[] ={"","",""};
	/* 存放近三年的数据*/
	String sCol2Value[]={"","","","","","","","","","","","",""};
	String sCol2Value1[]={"","","","","","","","","","","","",""};
	String sCol2Value2[]={"","","","","","","","","","","","",""};
	
	/*----------------------------- 获得盈利能力数据-------------------------------------*/
	//901 主营业务利润率 948 息税前营业利润率 975总资产收益率 932 净资产收益率
	// 908 存货周转率 907 应收账款周转率   905 总资产周转率
	//915 流动比率    916 速动比率 911 资产负债比率
	String sRowName[] = {"901","948","975","932","908","907","","905","","915","916","911",""};//
	//502 主营业务成本净额  203 应付账款 所有者权益 710 长期负债 708 固定资产 703 长期投资 702
	String sRowName1[] = {"502","203","710","708","703","702"}; 
	/*---------获得当年的数据-----------*/
			  
	ASResultSet rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%9'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
		" order by Year Desc");	
	int k = 0;
	while (k < 3)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//日期
			if(sYear == null) 
			{
				sxjYearReportDate[k] = "××年"+"12月";
			}
			else
			{
				sxjYearReportDate[k] = sYear + " 年12月";
				sYearN[k]=sYear+"/12";
			}
		}
		k ++;
	}
	rs2.getStatement().close();
	String sSql = " select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
				  +" where objectno = '"+sCustomerID+"' and ModelNo like '%9' and reportdate = '"+sYearN[0]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sYearN[0]+"'))";
	rs2 = Sqlca.getResultSet(sSql);	
	while(rs2.next())
	{
		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName[0])) sCol2Value[0]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[1])) sCol2Value[1]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[2])) sCol2Value[2]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[3])) sCol2Value[3]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[4])) sCol2Value[4]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[5])) sCol2Value[5]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[6])) sCol2Value[6]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[7])) sCol2Value[7]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[8])) sCol2Value[8]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[9])) sCol2Value[9]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[10])) sCol2Value[10]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[11])) sCol2Value[11]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[12])) sCol2Value[12]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
	}
	rs2.getStatement().close();	
	
	sSql = "select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
				  +" where objectno = '"+sCustomerID+"' and ModelNo like '%2' and reportdate = '"+sYearN[0]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sYearN[0]+"'))";
	rs2 = Sqlca.getASResultSet(sSql);
	while(rs2.next()){
		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName1[0])) sCol2Value[6]=String.valueOf(rs2.getDouble("Col2Value"));
	}	
	rs2.getStatement().close();		  
  	sSql = "select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
				  +" where objectno = '"+sCustomerID+"' and ModelNo like '%1' and reportdate = '"+sYearN[0]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sYearN[0]+"'))";
	rs2 = Sqlca.getASResultSet(sSql);
	double dPayableDue1 = 0;
	double dPayableDue2 = 0;
	double dOwnerShip = 0 ,dIndebted = 0,dAssets = 0,dInvestmentSum =0;
	while(rs2.next()){

		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName1[1]))
		{
			dPayableDue1=rs2.getDouble("Col1Value");
			dPayableDue2=rs2.getDouble("Col2Value");
		}
		else if(RowName.equals(sRowName1[2])) dOwnerShip=rs2.getDouble("Col2Value");
		else if(RowName.equals(sRowName1[3])) dIndebted=rs2.getDouble("Col2Value");
		else if(RowName.equals(sRowName1[4])) dAssets=rs2.getDouble("Col2Value");
		else if(RowName.equals(sRowName1[5])) dInvestmentSum=rs2.getDouble("Col2Value");
	}	
	if((dPayableDue1 + dPayableDue2) != 0 && !("".equals(sCol2Value[6]) || sCol2Value[6] == null) ){
		sCol2Value[6] = DataConvert.toMoney((Double.valueOf(sCol2Value[6])/((dPayableDue1 + dPayableDue2)/2) *100)/100) ;
	}
	else{
		sCol2Value[6]= "0.00";
	}
	if((dAssets+dInvestmentSum)!=0){
		sCol2Value[8] = DataConvert.toMoney(((dOwnerShip + dIndebted)/(dAssets + dInvestmentSum))*100/100);
	}
	else
	{
		sCol2Value[8] = "0.00";
	}
	rs2.getStatement().close();
	/*---------获得前一年的数据-----------*/
	sSql = " select * from REPORT_DATA where reportno in(select reportno from REPORT_RECORD"+
		   " where objectno = '"+sCustomerID+"' and ModelNo like '%9' and reportdate = '"+sYearN[1]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sYearN[1]+"'))";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName[0])) sCol2Value1[0]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[1])) sCol2Value1[1]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[2])) sCol2Value1[2]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[3])) sCol2Value1[3]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[4])) sCol2Value1[4]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[5])) sCol2Value1[5]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[6])) sCol2Value1[6]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[7])) sCol2Value1[7]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[8])) sCol2Value1[8]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[9])) sCol2Value1[9]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[10])) sCol2Value1[10]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[11])) sCol2Value1[11]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[12])) sCol2Value1[12]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);						
	}
	rs2.getStatement().close();	
	sSql = "select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
				  +" where objectno = '"+sCustomerID+"' and ModelNo like '%2' and reportdate = '"+sYearN[1]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sYearN[1]+"'))";
	rs2 = Sqlca.getASResultSet(sSql);
	while(rs2.next()){
		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName1[0])) sCol2Value1[6]=String.valueOf(rs2.getDouble("Col2Value"));
	}	
	rs2.getStatement().close();		  
  	sSql = "select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
				  +" where objectno = '"+sCustomerID+"' and ModelNo like '%1' and reportdate = '"+sYearN[1]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sYearN[1]+"'))";
	rs2 = Sqlca.getASResultSet(sSql);
	while(rs2.next()){
		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName1[1]))
		{
			dPayableDue1=rs2.getDouble("Col1Value");
			dPayableDue2=rs2.getDouble("Col2Value");
		}
		else if(RowName.equals(sRowName1[2])) dOwnerShip=rs2.getDouble("Col2Value");
		else if(RowName.equals(sRowName1[3])) dIndebted=rs2.getDouble("Col2Value");
		else if(RowName.equals(sRowName1[4])) dAssets=rs2.getDouble("Col2Value");
		else if(RowName.equals(sRowName1[5])) dInvestmentSum=rs2.getDouble("Col2Value");
	}	
	
	if((dPayableDue1 + dPayableDue2) != 0 && !("".equals(sCol2Value1[6]) || sCol2Value1[6] == null) ){
		sCol2Value1[6] = DataConvert.toMoney((Double.valueOf(sCol2Value1[6])/((dPayableDue1 + dPayableDue2)) *100)/100) ;
	}
	else{
		sCol2Value1[6]= "0.00";
	}
	if((dAssets+dInvestmentSum)!=0){
		sCol2Value1[8] = DataConvert.toMoney(((dOwnerShip + dIndebted)/(dAssets + dInvestmentSum))*100/100);
	}
	else
	{
		sCol2Value1[8] = "0.00";
	}
	rs2.getStatement().close();

	
	/*---------获得前二年的数据-----------*/
	sSql = " select * from REPORT_DATA where reportno in(select reportno from REPORT_RECORD"+
		   " where objectno = '"+sCustomerID+"' and ModelNo like '%9' and reportdate = '"+sYearN[2]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sYearN[2]+"'))";
	rs2 = Sqlca.getResultSet(sSql);
	
	while(rs2.next())
	{
		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName[0])) sCol2Value2[0]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[1])) sCol2Value2[1]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[2])) sCol2Value2[2]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[3])) sCol2Value2[3]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[4])) sCol2Value2[4]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[5])) sCol2Value2[5]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[6])) sCol2Value2[6]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[7])) sCol2Value2[7]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[8])) sCol2Value2[8]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[9])) sCol2Value2[9]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[10])) sCol2Value2[10]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[11])) sCol2Value2[11]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);
		else if(RowName.equals(sRowName[12])) sCol2Value2[12]=DataConvert.toMoney(rs2.getDouble("Col2Value")*100);						
	}
	rs2.getStatement().close();	
	
	sSql = "select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
				  +" where objectno = '"+sCustomerID+"' and ModelNo like '%2' and reportdate = '"+sYearN[2]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sYearN[2]+"'))";
	rs2 = Sqlca.getASResultSet(sSql);
	while(rs2.next()){
		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName1[0])) sCol2Value2[6]=String.valueOf(rs2.getDouble("Col2Value"));
	}	
	rs2.getStatement().close();		  
  	sSql = "select * from REPORT_DATA where reportno in (select reportno from REPORT_RECORD"
				  +" where objectno = '"+sCustomerID+"' and ModelNo like '%1' and reportdate = '"+sYearN[2]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sYearN[2]+"'))";
	rs2 = Sqlca.getASResultSet(sSql);
	while(rs2.next()){
		String RowName = rs2.getString("Rowsubject");
		if(RowName.equals(sRowName1[1]))
		{
			dPayableDue1=rs2.getDouble("Col1Value");
			dPayableDue2=rs2.getDouble("Col2Value");
		}
		else if(RowName.equals(sRowName1[2])) dOwnerShip=rs2.getDouble("Col2Value");
		else if(RowName.equals(sRowName1[3])) dIndebted=rs2.getDouble("Col2Value");
		else if(RowName.equals(sRowName1[4])) dAssets=rs2.getDouble("Col2Value");
		else if(RowName.equals(sRowName1[5])) dInvestmentSum=rs2.getDouble("Col2Value");
	}	
	System.out.println((dPayableDue1 + dPayableDue2)+"::::::::::"+(dOwnerShip + dIndebted));
	if((dPayableDue1 + dPayableDue2) != 0 && !("".equals(sCol2Value2[6]) || sCol2Value2[6] == null) ){
		sCol2Value2[6] = DataConvert.toMoney((Double.valueOf(sCol2Value2[6])/((dPayableDue1 + dPayableDue2)) *100)/100) ;
	}
	else{
		sCol2Value2[6]= "0.00";
	}
	if((dAssets+dInvestmentSum)!=0){
		sCol2Value2[8] = DataConvert.toMoney(((dOwnerShip + dIndebted)/(dAssets + dInvestmentSum))*100/100);
	}
	else
	{
		sCol2Value2[8] = "0.00";
	}
	rs2.getStatement().close();	
	
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0902.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >9.2、借款人财务分析-财务指标</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >指标内容</td>");
  	sTemp.append("   <td width=30% height='34' align=center class=td1 >指标名称</td>");
	sTemp.append("   <td width=20% align=center class=td1 >"+sxjYearReportDate[0]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=center class=td1 >"+sxjYearReportDate[1]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=center class=td1 >"+sxjYearReportDate[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	//盈利能力分析
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='4' width=10% align=left class=td1 >盈利能力</td>");
  	sTemp.append("   <td width=30% align=left class=td1 > 主营业务利润率(%) </td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[0]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[0]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 > 税息前营业利润率(%) </td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[1]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[1]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[1]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 > 总资产收益率(%) </td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[2]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[2]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 > 净资产收益率(%) </td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[3]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[3]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[3]+"&nbsp;</td>");
	sTemp.append("   </tr>");

	// 经营效率分析
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='4' width=10% align=left class=td1 >经营效率</td>");
  	sTemp.append("   <td width=30% align=left class=td1 > 存货周转率(%) </td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[4]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[4]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[4]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >应收账款周转率(%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[5]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[5]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[5]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >应付账款周转率 (%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[6]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[6]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[6]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >总资产周转率 (%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[7]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[7]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[7]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	// 流动性和短期偿债能力	
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='3' width=10% align=left class=td1 >流动性和短期偿债能力</td>");
  	sTemp.append("   <td width=30% align=left class=td1 >长期资产适合率(%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[8]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[8]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[8]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >流动比率(%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[9]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[9]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[9]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >速动比率(%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[10]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[10]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[10]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	//长期偿债能力分析
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='2' width=10% align=left class=td1 >长期偿债能力</td>"); 
  	sTemp.append("   <td width=30% align=left class=td1 >资产负债率(%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[11]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[11]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[11]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >调整后资产负债率(%)</td>");
	sTemp.append("   	<td width=20%  align=right class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=20%  align=right class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=20%  align=right class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:25'",getUnitData("describe3",sData)));
	sTemp.append("      &nbsp;</td>");
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