<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.21
		Tester:
		Content: ����ĵ�?ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   ���� 1:display;2:save;3:preview;4:export
				FirstSection: �ж��Ƿ�Ϊ����ĵ�һҳ
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 3;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	//��õ��鱨������
	
	String sDate = StringFunction.getToday();
	String sYear = sDate.substring(0,4);
	int iYear = Integer.parseInt(sYear);
	String sxjYearReportDate[] = {"","","",""};
	String sYearN[] ={"","",""};
	/* ��Ž����������*/
	String sCol2Value[]={"","","","","","","","","","","","",""};
	String sCol2Value1[]={"","","","","","","","","","","","",""};
	String sCol2Value2[]={"","","","","","","","","","","","",""};
	
	/*----------------------------- ���ӯ����������-------------------------------------*/
	//901 ��Ӫҵ�������� 948 Ϣ˰ǰӪҵ������ 975���ʲ������� 932 ���ʲ�������
	// 908 �����ת�� 907 Ӧ���˿���ת��   905 ���ʲ���ת��
	//915 ��������    916 �ٶ����� 911 �ʲ���ծ����
	String sRowName[] = {"901","948","975","932","908","907","","905","","915","916","911",""};//
	//502 ��Ӫҵ��ɱ�����  203 Ӧ���˿� ������Ȩ�� 710 ���ڸ�ծ 708 �̶��ʲ� 703 ����Ͷ�� 702
	String sRowName1[] = {"502","203","710","708","703","702"}; 
	/*---------��õ��������-----------*/
			  
	ASResultSet rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%9'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
		" order by Year Desc");	
	int k = 0;
	while (k < 3)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//����
			if(sYear == null) 
			{
				sxjYearReportDate[k] = "������"+"12��";
			}
			else
			{
				sxjYearReportDate[k] = sYear + " ��12��";
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
	/*---------���ǰһ�������-----------*/
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

	
	/*---------���ǰ���������-----------*/
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
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >9.2������˲������-����ָ��</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=15% height='34' align=center class=td1 >ָ������</td>");
  	sTemp.append("   <td width=30% height='34' align=center class=td1 >ָ������</td>");
	sTemp.append("   <td width=20% align=center class=td1 >"+sxjYearReportDate[0]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=center class=td1 >"+sxjYearReportDate[1]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=center class=td1 >"+sxjYearReportDate[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	//ӯ����������
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='4' width=10% align=left class=td1 >ӯ������</td>");
  	sTemp.append("   <td width=30% align=left class=td1 > ��Ӫҵ��������(%) </td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[0]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[0]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[0]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 > ˰ϢǰӪҵ������(%) </td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[1]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[1]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[1]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 > ���ʲ�������(%) </td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[2]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[2]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 > ���ʲ�������(%) </td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[3]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[3]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[3]+"&nbsp;</td>");
	sTemp.append("   </tr>");

	// ��ӪЧ�ʷ���
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='4' width=10% align=left class=td1 >��ӪЧ��</td>");
  	sTemp.append("   <td width=30% align=left class=td1 > �����ת��(%) </td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[4]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[4]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[4]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >Ӧ���˿���ת��(%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[5]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[5]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[5]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >Ӧ���˿���ת�� (%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[6]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[6]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[6]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >���ʲ���ת�� (%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[7]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[7]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[7]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	// �����ԺͶ��ڳ�ծ����	
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='3' width=10% align=left class=td1 >�����ԺͶ��ڳ�ծ����</td>");
  	sTemp.append("   <td width=30% align=left class=td1 >�����ʲ��ʺ���(%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[8]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[8]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[8]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >��������(%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[9]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[9]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[9]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >�ٶ�����(%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[10]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[10]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[10]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	//���ڳ�ծ��������
	sTemp.append("   <tr>");
	sTemp.append("   <td rowspan='2' width=10% align=left class=td1 >���ڳ�ծ����</td>"); 
  	sTemp.append("   <td width=30% align=left class=td1 >�ʲ���ծ��(%)</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value[11]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value1[11]+"&nbsp;</td>");
	sTemp.append("   <td width=20% align=right class=td1 >"+sCol2Value2[11]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=30% align=left class=td1 >�������ʲ���ծ��(%)</td>");
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
	//�ͻ���3
	var config = new Object();    
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>