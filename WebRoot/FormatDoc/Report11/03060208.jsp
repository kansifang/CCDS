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
	int iDescribeCount = 4;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	
	//��ñ��
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,j=0;
	String sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '050_' and ObjectType = '"+sObjectType+"'";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(j=0;j<sNo.length;j++)
	{		
		sNo1[j] = "6."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(j=0;j<sNo.length;j++)
	{
		if(sNo[j].equals(sTreeNo.substring(0,4)))  break;
	}
	

	//��õ��鱨������
	sSql = "select GuarantyNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	String sGuarangtorID = "";//�����ͻ�ID��
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sGuarangtorID = rs2.getString(1);
	rs2.getStatement().close();
	
	int k = 0;   
	String sRowSubject = "";		//������ 
	String sNewReportDate1 = "���������";		//����ʲ���ծ������
	String sYear="",sMonth="";	

	String [] sYearReportDate = {"������","������","������"};  	 //�ʲ���ծ���걨����
	String [] sYearReportNo = {"","",""};     			//�ʲ���ծ���걨��
	String [] sYearReportNo2 = {"","",""};  //����ָ����걨��
	
	String sNewReportNo1 = "";		//����ʲ���ծ���
	String sNewReportNo2 = "";      //�������ָ����
	
	int iMoneyUnit = 10000 ;  //��λ��Ԫ
	double dValue = 0 ;  //����±��ʲ���ծ�����ʲ��ܼ�
	double dFValue = 0 ; //����±��ʲ���ծ���и�ծ�ϼ�
	//����±��ʲ���ծ�������ʲ�,�ܸ�ծ,������Ȩ��,�ʲ���ծ��,��������,�ֽ����,�ٶ�����,ծ���峥�� ֵ
	String[] sValue = {"","","","","","","",""};
	String[] sProportion = {"","","","","","","",""};

	//����걨�ʲ���ծ�������ʲ�,�ܸ�ծ,������Ȩ��,�ʲ���ծ��,��������,�ֽ����,�ٶ�����,ծ���峥�� ֵ
	String[] sValue1 = {"","","","","","","",""};
	String[] sProportion1 = {"","","","","","","",""};

	//����ڶ��걨�ʲ���ծ�������ʲ�,�ܸ�ծ,������Ȩ��,�ʲ���ծ��,��������,�ֽ����,�ٶ�����,ծ���峥�� ֵ
	String[] sValue2 = {"","","","","","","",""};
	String[] sProportion2 = {"","","","","","","",""};

	//��������걨�ʲ���ծ�������ʲ�,�ܸ�ծ,������Ȩ��,�ʲ���ծ��,��������,�ֽ����,�ٶ�����,ծ���峥�� ֵ
	String[] sValue3 = {"","","","","","","",""};
	String[] sProportion3 = {"","","","","","","",""};

	String sReportDate[] = {"","","",""};
	
//****************************�ʲ���ծ��***********************************************

	//ȡ���±�������
    String lastDate = Sqlca.getString("select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sGuarangtorID+"'");
    
    //ȡ�����ʲ���ծ������
	rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo "+
						" from REPORT_RECORD "+
						" where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%1' and ReportScope = GETEVALUATESCOPE('"+sGuarangtorID+"',ReportDate)"+
	                    " and Reportdate ='"+lastDate+"'" );

    rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo "+
			" from REPORT_RECORD "+
			" where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%1' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%1') and ReportScope = GETEVALUATESCOPE('"+sGuarangtorID+"',ReportDate)");
	if(rs2.next())
	{
		sYear = rs2.getString("Year");	//����
		if(sYear == null) 
		{
			sNewReportDate1 = "���������";
		}
		else
		{
			sMonth = rs2.getString("Month");	//����
			sNewReportDate1 = sYear + " ��" +sMonth+" ��";
		}
		sNewReportNo1 = rs2.getString("ReportNo");	//����ʲ���ծ���
		sReportDate[0] = rs2.getString("ReportDate");
	}	
	rs2.getStatement().close();	
	
	 //ȡ����ָ�������
    rs2 = Sqlca.getResultSet("select ReportNo "+
			" from REPORT_RECORD "+
			" where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%9' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%9') and ReportScope = GETEVALUATESCOPE('"+sGuarangtorID+"',ReportDate)");
    if(rs2.next())
	{
    	sNewReportNo2 = rs2.getString("ReportNo");	//����ʲ���ծ���
	}
    rs2.getStatement().close();	
	if(!sNewReportDate1.equals("���������"))
	{
		//�ʲ��ܼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject ='804'");
		if(rs2.next())
		{
			
			sValue[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion[0] = "100";
			dValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		//��ծ�ܼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject ='807'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject in ('808')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("808"))	//������Ȩ��
				{
					sValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
			}
			rs2.getStatement().close();
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo2+"' And RowSubject in ('911','915','917','916')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if(sRowSubject.equals("911"))//�ʲ���ծ��
				{
					sValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("915"))//��������
				{
					sValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("917"))//�ֽ����
				{
					sValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("916"))//�ٶ�����
				{
					sValue[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				
			}
			rs2.getStatement().close();
			
		}
	}
	
//�걨
	//ȡ�����ʲ���ծ���걨����
	rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sGuarangtorID+"' and ModelNo like '%1'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sGuarangtorID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sGuarangtorID+"',ReportDate)"+
		" order by Year Desc");  

	k = 2;
	while (k >= 0)
	{
		if(rs2.next())
		{
			sYear = rs2.getString("Year");	//����
			if(sYear == null) 
			{
				sYearReportDate[k] = "������";
			}
			else
			{
				sYearReportDate[k] = sYear + " ��";
			}
			sYearReportNo[k] = rs2.getString("ReportNo");	//�ʲ���ծ���걨�� 
			sReportDate[k+1] = rs2.getString("ReportDate");
		}
		k --;
	}
	rs2.getStatement().close();

	rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
			" where ObjectNo ='"+sGuarangtorID+"' and ModelNo like '%9'"+
			" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sGuarangtorID+"' ) and ReportScope = GETFSREPORTSCOPE('"+sGuarangtorID+"',ReportDate)"+
			" order by Year Desc");  

	k = 2;
	while (k >= 0)
	{
		if(rs2.next())
		{
			sYearReportNo2[k] = rs2.getString("ReportNo");	//
		}
		k --;

	}
	rs2.getStatement().close();
    //��һ��
	if(!sYearReportDate[0].equals("������"))
	{
		//�ʲ��ܼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject ='804'");
		if(rs2.next())
		{
			
			sValue1[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion1[0] = "100";
			dValue = rs2.getDouble("Col2value");
		}
		else sProportion1[0] = "100";
		rs2.getStatement().close();
		//��ծ�ܼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject ='807'");
		
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject in ('808')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("808"))	//������Ȩ��
				{
					sValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
			}
			rs2.getStatement().close();
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo2[0]+"' And RowSubject in ('911','915','917','916')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if(sRowSubject.equals("911"))//�ʲ���ծ��
				{
					sValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("915"))//��������
				{
					sValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("917"))//�ֽ����
				{
					sValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("916"))//�ٶ�����
				{
					sValue1[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				
			}
			rs2.getStatement().close();
			
		}
	}
//�ڶ���
	if(!sYearReportDate[1].equals("������"))
	{
		//�ʲ��ܼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='804'");
		if(rs2.next())
		{
			
			sValue2[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion2[0] = "100";
			dValue = rs2.getDouble("Col2value");
		}
		else sProportion2[0] = "100";
 		rs2.getStatement().close();
		//��ծ�ܼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='807'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('808')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("808"))	//������Ȩ��
				{
					sValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
			}
			rs2.getStatement().close();
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo2[1]+"' And RowSubject in ('911','915','917','916')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if(sRowSubject.equals("911"))//�ʲ���ծ��
				{
					sValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("915"))//��������
				{
					sValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("917"))//�ֽ����
				{
					sValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("916"))//�ٶ�����
				{
					sValue2[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				
			}
			rs2.getStatement().close();
			
		}
	}
//������
	if(!sYearReportDate[2].equals("������"))
	{
		//�ʲ��ܼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject ='804'");
		if(rs2.next())
		{
			
			sValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion3[0] = "100";
			dValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		//��ծ�ܼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject ='807'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
			sProportion3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject in ('808')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("808"))	//������Ȩ��
				{
					sValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
			}
			rs2.getStatement().close();
			
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo2[2]+"' And RowSubject in ('911','915','917','916')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if(sRowSubject.equals("911"))//�ʲ���ծ��
				{
					sValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("915"))//��������
				{
					sValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("917"))//�ֽ����
				{
					sValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}else if(sRowSubject.equals("916"))//�ٶ�����
				{
					sValue3[6] = DataConvert.toMoney(rs2.getDouble("Col2value"));
					sProportion3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				
			}
			rs2.getStatement().close();
			
		}
	}

	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
   
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='03060208.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >8�������˲�����</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >(1)���ʲ���ծ��ṹ��Ա�</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+sYearReportDate[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sYearReportDate[1]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+sYearReportDate[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sNewReportDate1+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��Ŀ&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >���ʲ�&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[0]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[0]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >�ܸ�ծ&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[1]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[1]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[1]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[1]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >������Ȩ��&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[2]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[2]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >�ʲ���ծ��&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[3]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[3]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[3]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[3]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��������&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[4]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[4]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[4]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[4]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >�ֽ����&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[5]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[5]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[5]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[5]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >�ٶ�����&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[6]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue2[6]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=left class=td1 >"+sValue3[6]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sValue[6]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >ծ���峥��&nbsp;</td>");
    sTemp.append("   	<td width=20%  align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:25'",getUnitData("describe1",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=20%  align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:25'",getUnitData("describe2",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=20%  align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:25'",getUnitData("describe3",sData)));
	sTemp.append("      &nbsp;</td>");
	sTemp.append("   	<td width=20%  align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:25'",getUnitData("describe4",sData)));
	sTemp.append("      &nbsp;</td>");
    sTemp.append(" </tr>");
    
    //
	String sNewReportDate2 = "���������";		//������������
	String [] ssyYearReportDate = {"������","������","������"};   //������걨����
	String [] ssyYearReportNo = {"","",""};     			//������걨��
	
	
	String sNewReportNo4 = "";		//����������
	
	
	//���������±�
	double dsyValue = 0;
	String ssyValue[] = {"","","","",""};
	String ssyProportion[] = {"","","","",""};
	
	//�����һ��������걨
	String ssyValue1[] = {"","","","",""};
	String ssyProportion1[] = {"","","","",""};
	
	//����ڶ���������걨
	String ssyValue2[] = {"","","","",""};
	String ssyProportion2[] = {"","","","",""};
	
	//���������������걨
	String ssyValue3[] = {"","","","",""};
	String ssyProportion3[] = {"","","","",""};
	
	//*****************************************�����ṹ�ͶԱ�*****************************
	//ȡ������������
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%2' and ReportScope = GETEVALUATESCOPE('"+sGuarangtorID+"',ReportDate)"+
	" and Reportdate ='"+lastDate+"'" );
	
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
		sNewReportNo4 = rs2.getString("ReportNo");	//���������
	}	
	rs2.getStatement().close();
	
	rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo4+"' And RowSubject in ('501','502','505','515','517')");
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
		else if (sRowSubject.equals("515"))	//�����ܶ�
		{
			ssyValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
		else if (sRowSubject.equals("517"))	//������
		{
			ssyValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
			ssyProportion[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
		}
	}
	rs2.getStatement().close();
	
	//�걨
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sGuarangtorID+"' and ModelNo like '%2'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sGuarangtorID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sGuarangtorID+"',ReportDate)"+
		" order by Year Desc"); 
	
	k = 2;
	while (k >= 0)
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
				ssyYearReportDate[k] = sYear + " ��";
			}
			ssyYearReportNo[k] = rs2.getString("ReportNo");	//�ʲ���ծ���걨��
		}
		k --;
	}
	rs2.getStatement().close();
	
	//��һ��
	if (!ssyYearReportDate[0].equals("������"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[0]+"' And RowSubject in ('501','502','505','515','517')");
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
			else if (sRowSubject.equals("515"))	//�����ܶ�
			{
				ssyValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//������
			{
				ssyValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
		rs2.getStatement().close();
	}
	//�ڶ���	
	if (!ssyYearReportDate[1].equals("������"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[1]+"' And RowSubject in ('501','502','505','515','517')");
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
			else if (sRowSubject.equals("515"))	//�����ܶ�
			{
				ssyValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//������
			{
				ssyValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
	    rs2.getStatement().close();
	}
    
	//������	
	if (!ssyYearReportDate[2].equals("������"))
	{
		rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+ssyYearReportNo[2]+"' And RowSubject in ('501','502','505','515','517') order by RowSubject ");
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
			else if (sRowSubject.equals("515"))	//�����ܶ�
			{
				ssyValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
			else if (sRowSubject.equals("517"))	//������
			{
				ssyValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);
				ssyProportion3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dsyValue*100);		
			}
		}
		rs2.getStatement().close();
	}
		

    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >(2)�������ṹ�ͶԱ�</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+ssyYearReportDate[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyYearReportDate[1]+"&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >"+ssyYearReportDate[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+sNewReportDate2+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��Ŀ&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
    sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >��ֵ����Ԫ��&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��Ӫҵ������&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[0]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[0]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[0]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[0]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��Ӫҵ��ɱ�&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[1]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[1]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[1]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[1]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >��Ӫҵ������&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[2]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[2]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[2]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[2]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >�����ܶ�&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[3]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[3]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[3]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[3]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append("   <tr>");
  	sTemp.append(" <td width=20% align=center class=td1 >������&nbsp;</td>");
  	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue1[4]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue2[4]+"&nbsp;</td>");
	sTemp.append("<td width=20% align=right class=td1 >"+ssyValue3[4]+"&nbsp;</td>");
  	sTemp.append(" <td width=20% align=center class=td1 >"+ssyValue[4]+"&nbsp;</td>");
    sTemp.append(" </tr>");
    
    
	

	String sNewReportDate3 = "���������";		//����ֽ�����������
	String [] sxjYearReportDate = {"������","������","������"};   //�ֽ��������걨����
	String [] sxjYearReportNo = {"","",""};     			//�ֽ��������걨��

	String sNewReportNo3 = "";		//����ֽ��������
	
	//����ֽ��������±�
	String sxjValue[] = {"","","","","","","","","",""};

	//�����һ���ֽ��������걨
	String sxjValue1[] = {"","","","","","","","","",""};

	//����ڶ����ֽ��������걨
	String sxjValue2[] = {"","","","","","","","","",""};

	//����������ֽ��������걨
	String sxjValue3[] = {"","","","","","","","","",""};

//*****************************************�ֽ�������*****************************
	//ȡ����ֽ�����������
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sGuarangtorID+"' And ModelNo like '%8'  and ReportScope = GETEVALUATESCOPE('"+sGuarangtorID+"',ReportDate)"+
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
		" where ObjectNo ='"+sGuarangtorID+"' and ModelNo like '%8'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sGuarangtorID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sGuarangtorID+"',ReportDate)"+
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
		
    sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >(3)���ֽ����Ա�</font></td> ");	
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

