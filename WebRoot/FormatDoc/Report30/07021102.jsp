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
	String sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	String sGuarangtorID = "";//�����ͻ�ID��
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();
	
	int k = 0;   
	String sRowSubject = "";		//������ 
	String sNewReportDate2 = "���������";		//������������
	String sYear="",sMonth="";	

	String [] ssyYearReportDate = {"������","������","������"};   //������걨����
	String [] ssyYearReportNo = {"0","0","0"};     			//������걨��


	String sNewReportNo2 = "";		//����������
	

	//���������±�
	double dsyValue = 0;
	String ssyValue[] = {"0","0","0","0","0","0","0","0","0"};
	String ssyProportion[] = {"0","0","0","0","0","0","0","0","0"};

	//�����һ��������걨
	String ssyValue1[] = {"0","0","0","0","0","0","0","0","0"};
	String ssyProportion1[] = {"0","0","0","0","0","0","0","0","0"};

	//����ڶ���������걨
	String ssyValue2[] = {"0","0","0","0","0","0","0","0","0"};
	String ssyProportion2[] = {"0","0","0","0","0","0","0","0","0"};

	//���������������걨
	String ssyValue3[] = {"0","0","0","0","0","0","0","0","0"};
	String ssyProportion3[] = {"0","0","0","0","0","0","0","0","0"};

//*****************************************�����ṹ�ͶԱ�*****************************
	//ȡ������������
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%2' And ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%2') and ReportScope = GETFSREPORTSCOPE('"+sGuarangtorID+"',ReportDate)");
	
	if(rs2.next())
	{
		sYear = rs2.getString("Year");	//����
		if(sYear == null) 
		{
			sNewReportDate2 = "���������";
		}
		else
		{
			sMonth = rs2.getString("Month");	//����
			sNewReportDate2 = sYear + " ��" +sMonth+" ��";
		}
		sNewReportNo2 = rs2.getString("ReportNo");	//���������
	}	
	rs2.getStatement().close();
	
	rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo2+"' And RowSubject in ('501','502','505','503','507','508','509','515','517')");
	while(rs2.next())
	{
		sRowSubject = rs2.getString("RowSubject");
		if (sRowSubject.equals("501"))		//��Ӫҵ������
		{
			ssyValue[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			dsyValue = rs2.getDouble("Col2value");
			ssyProportion[0] = "100";		
		}
		if( dsyValue == 0) continue;
		if (sRowSubject.equals("502"))	//��Ӫҵ��ɱ�
		{
			ssyValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);	
		}
		else if (sRowSubject.equals("505"))	//��Ӫҵ������
		{
			ssyValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
		else if (sRowSubject.equals("503"))	//Ӫҵ����
		{
			ssyValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
		else if (sRowSubject.equals("507"))	//�������
		{
			ssyValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
		else if (sRowSubject.equals("508"))	//�������
		{
			ssyValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
		else if (sRowSubject.equals("509"))	//Ӫҵ����
		{
			ssyValue[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
		else if (sRowSubject.equals("515"))	//�����ܶ�
		{
			ssyValue[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
		else if (sRowSubject.equals("517"))	//������
		{
			ssyValue[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
	}
	rs2.getStatement().close();
	
//�걨
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sGuarangtorID+"' and ModelNo like '%2'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sGuarangtorID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sGuarangtorID+"',ReportDate)"+
		" order by Year Desc"); 

	k = 0;
	while (k < 3)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//����
			if(sYear == null) 
			{
				ssyYearReportDate[k] = "������";
			}
			else
			{
				ssyYearReportDate[k] = sYear + " ��12��";
			}
			ssyYearReportNo[k] = rs2.getString("ReportNo");	//�ʲ���ծ���걨��
		}
		k ++;
	}
	rs2.getStatement().close();

//��һ��
	if (!ssyYearReportDate[0].equals("������"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[0]+"' And RowSubject in ('501','502','505','503','507','508','509','515','517')");
		while(rs2.next())
		{
			sRowSubject = rs2.getString("RowSubject");
			if (sRowSubject.equals("501"))		//��Ӫҵ������
			{
				ssyValue1[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				dsyValue = rs2.getDouble("Col2value");
				ssyProportion1[0] = "100";		
			}
			if( dsyValue == 0) continue;
			if (sRowSubject.equals("502"))	//��Ӫҵ��ɱ�
			{
				ssyValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("505"))	//��Ӫҵ������
			{
				ssyValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("503"))	//Ӫҵ����
			{
				ssyValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("507"))	//�������
			{
				ssyValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("508"))	//�������
			{
				ssyValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("509"))	//Ӫҵ����
			{
				ssyValue1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("515"))	//�����ܶ�
			{
				ssyValue1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//������
			{
				ssyValue1[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
		rs2.getStatement().close();
//�ڶ���	
		if (!ssyYearReportDate[1].equals("������"))
		{
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[1]+"' And RowSubject in ('501','502','505','503','507','508','509','515','517')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("501"))		//��Ӫҵ������
				{
					ssyValue2[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
					dsyValue = rs2.getDouble("Col2value");
					ssyProportion2[0] = "100";			
				}
				if( dsyValue == 0) continue;
				if (sRowSubject.equals("502"))	//��Ӫҵ��ɱ�
				{
					ssyValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
					ssyProportion2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("505"))	//��Ӫҵ������
				{
					ssyValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
					ssyProportion2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("503"))	//Ӫҵ����
				{
					ssyValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
					ssyProportion2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("507"))	//�������
				{
					ssyValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
					ssyProportion2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("508"))	//�������
				{
					ssyValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
					ssyProportion2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("509"))	//Ӫҵ����
				{
					ssyValue2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
					ssyProportion2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("515"))	//�����ܶ�
				{
					ssyValue2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
					ssyProportion2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
				else if (sRowSubject.equals("517"))	//������
				{
					ssyValue2[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
					ssyProportion2[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
				}
			}
//������		rs2.getStatement().close();

			if (!ssyYearReportDate[2].equals("������"))
			{
				rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[2]+"' And RowSubject in ('501','502','505','503','507','508','509','515','517') order by RowSubject ");
				while(rs2.next())
				{
					sRowSubject = rs2.getString("RowSubject");
					if (sRowSubject.equals("501"))		//��Ӫҵ������
					{
						ssyValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
						dsyValue = rs2.getDouble("Col2value");
						ssyProportion3[0] = "100";
					}
					if( dsyValue == 0) continue;
					if (sRowSubject.equals("502"))	//��Ӫҵ��ɱ�
					{
						ssyValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
						ssyProportion3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("505"))	//��Ӫҵ������
					{
						ssyValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
						ssyProportion3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);
					}
					else if (sRowSubject.equals("503"))	//Ӫҵ����
					{
						ssyValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
						ssyProportion3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("507"))	//�������
					{
						ssyValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
						ssyProportion3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("508"))	//�������
					{
						ssyValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
						ssyProportion3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("509"))	//Ӫҵ����
					{
						ssyValue3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
						ssyProportion3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("515"))	//�����ܶ�
					{
						ssyValue3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
						ssyProportion3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
					else if (sRowSubject.equals("517"))	//������
					{
						ssyValue3[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
						ssyProportion3[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
					}
				}
				rs2.getStatement().close();
			}
		}
	}


	//��ñ��
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,i=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '07__' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(i=0;i<sNo.length;i++)
	{		
		sNo1[i] = "8."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(i=0;i<sNo.length;i++)
	{
		if(sNo[i].equals(sTreeNo.substring(0,4)))  break;
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='07021102.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sNo1[i]+".11.2�������ṹ��Աȣ���λ����Ԫ��</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td rowspan=2 align=center class=td1 > ��Ŀ </td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+ssyYearReportDate[0]+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+ssyYearReportDate[1]+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+ssyYearReportDate[2]+"&nbsp;</td>");	
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=center class=td1 > ��ֵ����Ԫ��</td>");
	sTemp.append("<td align=center class=td1 >%</td>");
	sTemp.append("<td align=center class=td1 >��ֵ����Ԫ��</td>");
	sTemp.append("<td align=center class=td1 >%</td>");
	sTemp.append("<td align=center class=td1 >��ֵ����Ԫ��</td>");
	sTemp.append("<td align=center class=td1 >%</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ��Ӫҵ������ </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[0]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[0]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ��Ӫҵ��ɱ� </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[1]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ��Ӫҵ������ </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > Ӫҵ���� </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[3]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ������� </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[4]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ������� </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[5]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > Ӫҵ���� </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[6]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > �����ܶ� </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[7]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ������ </td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyValue3[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+ssyProportion3[8]+"</td>");
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
	