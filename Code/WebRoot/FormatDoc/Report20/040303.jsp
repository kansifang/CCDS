<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu 2009.08.22
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
	String sxjValue[] = {"0","0","0","0","0","0"};

	//�����һ���ֽ��������걨
	String sxjValue1[] = {"0","0","0","0","0","0"};

	//����ڶ����ֽ��������걨
	String sxjValue2[] = {"0","0","0","0","0","0"};

	//����������ֽ��������걨
	String sxjValue3[] = {"0","0","0","0","0","0"};

//*****************************************�ֽ�������*****************************
	//ȡ����ֽ�����������
	ASResultSet rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%8' And ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%8') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)");
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
			sNewReportDate3 = sYear + " ��" +sMonth+" ��";
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
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo3+"' And RowSubject in ('810','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//��Ӫ��ֽ�������
			{
				sxjValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//���ʻ�ֽ�������
			{
				sxjValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//���ֽ�����
			{
				sxjValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
	
		rs2.getStatement().close();
	}
//�걨
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%8'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04')  and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
		" order by Year Desc");

	k = 0;
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
			}
			sxjYearReportNo[k] = rs2.getString("ReportNo");	//�ʲ���ծ���걨��
		}
		k ++;
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
	
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[0]+"' And RowSubject in ('810','811','812','813')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("810"))		//��Ӫ��ֽ�������
			{
				sxjValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("811"))	//Ͷ�ʻ�ֽ�������
			{
				sxjValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("812"))	//���ʻ�ֽ�������
			{
				sxjValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
			else if (sRowSubject.equals("813"))	//���ֽ�����
			{
				sxjValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
			}
		}
	
		rs2.getStatement().close();

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
		
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[1]+"' And RowSubject in ('810','811','812','813')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("810"))		//��Ӫ��ֽ�������
				{
					sxjValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				}
				else if (sRowSubject.equals("811"))	//Ͷ�ʻ�ֽ�������
				{
					sxjValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				}
				else if (sRowSubject.equals("812"))	//���ʻ�ֽ�������
				{
					sxjValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				}
				else if (sRowSubject.equals("813"))	//���ֽ�����
				{
					sxjValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
				}
			}
			rs2.getStatement().close();

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
			
				rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sxjYearReportNo[2]+"' And RowSubject in ('810','811','812','813')");
				while(rs2.next())
				{
					sRowSubject = rs2.getString("RowSubject");
					if (sRowSubject.equals("810"))		//��Ӫ��ֽ�������
					{
						sxjValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
					}
					else if (sRowSubject.equals("811"))	//Ͷ�ʻ�ֽ�������
					{
						sxjValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
					}
					else if (sRowSubject.equals("812"))	//���ʻ�ֽ�������
					{
						sxjValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
					}
					else if (sRowSubject.equals("813"))	//���ֽ�����
					{
						sxjValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
					}
				}
				rs2.getStatement().close();
			}
		}
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='040303.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.3.3���ֽ���</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td rowspan=2 align=center class=td1 > ��Ŀ </td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[0]+"</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[1]+"</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[2]+"&nbsp;</td>");	
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td colspan=2 align=center class=td1 >��ֵ(��Ԫ)</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >��ֵ(��Ԫ)</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >��ֵ(��Ԫ)</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> ��Ӫ��ֽ������� </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[0]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[0]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[0]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> ��Ӫ��ֽ������� </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[1]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[1]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[1]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> ��Ӫ��ֽ������� </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[2]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[2]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> Ͷ�ʻ�ֽ������� </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[3]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[3]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[3]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 nowrap> ���ʻ�ֽ������� </td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue1[4]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue2[4]+"</td>");
	sTemp.append("<td colspan=2 align=right class=td1 >"+sxjValue3[4]+"</td>");
	sTemp.append("</tr>");
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
	