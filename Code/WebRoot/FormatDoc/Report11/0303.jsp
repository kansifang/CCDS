<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bqliu 2011-04-29
		Tester:
		Content: ����ĵ�0ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   
				FirstSection: 
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//��õ��鱨������
		
	int k = 0;   
	String sRowSubject = "";		//������ 
	String sNewReportDate3 = "���������";		//����ֽ�����������
	String sYear="",sMonth="";	

	String [] sxjYearReportDate = {"������","������","������"};   //�ֽ��������걨����
	String [] sxjYearReportNo = {"0","0","0"};     			//�ֽ��������걨��

	String sNewReportNo3 = "";		//����ֽ��������
	
	//����ֽ��������±�
	String sxjValue[] = {"0","0","0","0","0","0","0","0","0","0"};

	//�����һ���ֽ��������걨
	String sxjValue1[] = {"0","0","0","0","0","0","0","0","0","0"};

	//����ڶ����ֽ��������걨
	String sxjValue2[] = {"0","0","0","0","0","0","0","0","0","0"};

	//����������ֽ��������걨
	String sxjValue3[] = {"0","0","0","0","0","0","0","0","0","0"};

//*****************************************�ֽ�������*****************************
    //ȡ���±�������
    String lastDate = Sqlca.getString("select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' ");

	//ȡ����ֽ�����������
	ASResultSet rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%8' and ReportScope = GETEVALUATESCOPE('"+sCustomerID+"',ReportDate)"+
	" and Reportdate ='"+lastDate+"'" );
	
	if(rs2.next())
	{
		sYear = rs2.getString("Year");	//����
		if(sYear == null) 
		{
			sNewReportDate3 = "���������";
		}
		else
		{
			sMonth = rs2.getString("Month");	//����
			sNewReportDate3 = sYear + " ��"+sMonth+" ��";
		}
		sNewReportNo3 = rs2.getString("ReportNo");	//����ֽ��������
	}
	
	rs2.getStatement().close();

	if (!sNewReportDate3.equals("���������"))
	{
	 	//��Ӫ��ֽ�������	RowSubject Ϊa20
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo3+"' And RowSubject ='a20'");
		if(rs2.next())
		{
			sxjValue[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		//��Ӫ��ֽ�������	RowSubject Ϊa27
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo3+"' And RowSubject ='a27'");
		if(rs2.next())
		{
			sxjValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo3+"' And RowSubject in ('810','a33','a38','a43','a50','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//��Ӫ��ֽ�������
			{
				sxjValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a33"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a38"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a43"))	//���ʻ�ֽ�������
			{
				sxjValue[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a50"))	//���ʻ�ֽ�������
			{
				sxjValue[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//���ʻ�ֽ�������
			{
				sxjValue[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//�ֽ��ֽ�ȼ��ﾻ���Ӷ�
			{
				sxjValue[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
	
		rs2.getStatement().close();
	}
//�걨
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%8'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
		" order by Year Desc");

	k = 2;
	while (k >= 0)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//����
			if(sYear == null) 
			{
				sxjYearReportDate[k] = "������";
			}
			else
			{
				sxjYearReportDate[k] = sYear + " ��";
			}
			sxjYearReportNo[k] = rs2.getString("ReportNo");	//�ʲ���ծ���걨��
		}
		k --;
	}
	rs2.getStatement().close();

//��һ��
	if (!sxjYearReportDate[0].equals("������"))
	{
	 	//��Ӫ��ֽ�������	RowSubject Ϊa20
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[0]+"' And RowSubject = 'a20'");
		if(rs2.next())
		{
			sxjValue1[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		//��Ӫ��ֽ�������	RowSubject Ϊa27
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[0]+"' And RowSubject = 'a27'");
		if(rs2.next())
		{
			sxjValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[0]+"' And RowSubject in ('810','a33','a38','a43','a50','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//��Ӫ��ֽ�������
			{
				sxjValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a33"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a38"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a43"))	//���ʻ�ֽ�������
			{
				sxjValue1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a50"))	//���ʻ�ֽ�������
			{
				sxjValue1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//���ʻ�ֽ�������
			{
				sxjValue1[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//�ֽ��ֽ�ȼ��ﾻ���Ӷ�
			{
				sxjValue1[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
	
		rs2.getStatement().close();
	}
//�ڶ���
	if (!sxjYearReportDate[1].equals("������"))
	{
	 	//��Ӫ��ֽ�������	RowSubject Ϊa20
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[1]+"' And RowSubject = 'a20'");
		if(rs2.next())
		{
			sxjValue2[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		//��Ӫ��ֽ�������	RowSubject Ϊa27
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[1]+"' And RowSubject = 'a27'");
		if(rs2.next())
		{
			sxjValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[1]+"' And RowSubject in ('810','a33','a38','a43','a50','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//��Ӫ��ֽ�������
			{
				sxjValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a33"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a38"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a43"))	//���ʻ�ֽ�������
			{
				sxjValue2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a50"))	//���ʻ�ֽ�������
			{
				sxjValue2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//���ʻ�ֽ�������
			{
				sxjValue2[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//�ֽ��ֽ�ȼ��ﾻ���Ӷ�
			{
				sxjValue2[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
		rs2.getStatement().close();
	}
//������
	if (!sxjYearReportDate[2].equals("������"))
	{
	 	//��Ӫ��ֽ�������	RowSubject Ϊa20
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[2]+"' And RowSubject = 'a20'");
		if(rs2.next())
		{
			sxjValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		//��Ӫ��ֽ�������	RowSubject Ϊa27
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sxjYearReportNo[2]+"' And RowSubject = 'a27'");
		if(rs2.next())
		{
			sxjValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[2]+"' And RowSubject in ('810','a33','a38','a43','a50','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//��Ӫ��ֽ�������
			{
				sxjValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a33"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a38"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a43"))	//���ʻ�ֽ�������
			{
				sxjValue3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("a50"))	//���ʻ�ֽ�������
			{
				sxjValue3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//���ʻ�ֽ�������
			{
				sxjValue3[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//�ֽ��ֽ�ȼ��ﾻ���Ӷ�
			{
				sxjValue3[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
		rs2.getStatement().close();
	}
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0303.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >3���ֽ���</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% rowspan=2 align=center class=td1 >��Ŀ&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+sxjYearReportDate[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjYearReportDate[1]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+sxjYearReportDate[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sNewReportDate3+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
    sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��Ӫ��ֽ�������&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[0]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[0]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��Ӫ��ֽ�������&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[1]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[1]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[1]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[1]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 ><font style='FONT-FAMILY:����;FONT-WEIGHT: bold;' >��Ӫ��ֽ�������&nbsp;</font></td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[2]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[2]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >Ͷ�ʻ�ֽ�������&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[3]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[3]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[3]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[3]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >Ͷ�ʻ�ֽ�������&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[4]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[4]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[4]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[4]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 ><font style='FONT-FAMILY:����;FONT-WEIGHT: bold;' >Ͷ�ʻ�ֽ�������&nbsp;</font></td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[5]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[5]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[5]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[5]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >���ʻ�ֽ�������&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[6]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[6]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[6]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[6]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >���ʻ�ֽ�������&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[7]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[7]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[7]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[7]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 ><font style='FONT-FAMILY:����;FONT-WEIGHT: bold;' >���ʻ�ֽ�������&nbsp;</font></td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[8]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[8]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[8]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[8]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 ><font style='FONT-FAMILY:����;FONT-WEIGHT: bold;' >�ֽ��ֽ�ȼ��ﾻ���Ӷ�&nbsp;</font></td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue1[9]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue2[9]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sxjValue3[9]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sxjValue[9]+"&nbsp;</td>");
    sTemp.append(" </tr>");
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

