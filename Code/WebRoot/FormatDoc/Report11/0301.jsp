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
	//��õ��鱨������
	int k = 0;   
	String sRowSubject = "";		//������ 
	String sNewReportDate1 = "���������";		//����ʲ���ծ������
	String sYear="",sMonth="";	

	String [] sYearReportDate = {"������","������","������"};  	 //�ʲ���ծ���걨����
	String [] sYearReportNo = {"0","0","0"};     			//�ʲ���ծ���걨��
	String [] sYearReportNo2 = {"0","0","0"};  //����ָ����걨��
	
	String sNewReportNo1 = "";		//����ʲ���ծ���
	String sNewReportNo2 = "";      //�������ָ����
	
	int iMoneyUnit = 10000 ;  //��λ��Ԫ
	double dValue = 0 ;  //����±��ʲ���ծ�����ʲ��ܼ�
	double dFValue = 0 ; //����±��ʲ���ծ���и�ծ�ϼ�
	//����±��ʲ���ծ�������ʲ�,�ܸ�ծ,������Ȩ��,�ʲ���ծ��,��������,�ֽ����,�ٶ�����,ծ���峥�� ֵ
	String[] sValue = {"0","0","0","0","0","0","0","0"};
	String[] sProportion = {"0","0","0","0","0","0","0","0"};

	//����걨�ʲ���ծ�������ʲ�,�ܸ�ծ,������Ȩ��,�ʲ���ծ��,��������,�ֽ����,�ٶ�����,ծ���峥�� ֵ
	String[] sValue1 = {"0","0","0","0","0","0","0","0"};
	String[] sProportion1 = {"0","0","0","0","0","0","0","0"};

	//����ڶ��걨�ʲ���ծ�������ʲ�,�ܸ�ծ,������Ȩ��,�ʲ���ծ��,��������,�ֽ����,�ٶ�����,ծ���峥�� ֵ
	String[] sValue2 = {"0","0","0","0","0","0","0","0"};
	String[] sProportion2 = {"0","0","0","0","0","0","0","0"};

	//��������걨�ʲ���ծ�������ʲ�,�ܸ�ծ,������Ȩ��,�ʲ���ծ��,��������,�ֽ����,�ٶ�����,ծ���峥�� ֵ
	String[] sValue3 = {"0","0","0","0","0","0","0","0"};
	String[] sProportion3 = {"0","0","0","0","0","0","0","0"};

	String sReportDate[] = {"","","",""};
	
//****************************�ʲ���ծ��***********************************************

	
    //ȡ���±�������
    String lastDate = Sqlca.getString("select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' ");
    //ȡ�����ʲ���ծ������
    ASResultSet rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo "+
						" from REPORT_RECORD "+
						" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%1' and ReportScope = GETEVALUATESCOPE('"+sCustomerID+"',ReportDate) "+
						" and Reportdate ='"+lastDate+"'" );
    
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
			" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%9' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%9') and ReportScope = GETEVALUATESCOPE('"+sCustomerID+"',ReportDate)");
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
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%1'"+
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
			" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%9'"+
			" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
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
	sTemp.append("	<form method='post' action='0301.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >(��)����˲�������Ҫ����ָ��</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=5 ><font style=' font-size: 15pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;' >1���ʲ���ծ��ṹ��Ա�</font></td> ");	
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
    //sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[7]+"&nbsp;</td>");
  	//sTemp.append(" <td width=20% align=center class=td1 >"+sValue1[7]+"&nbsp;</td>");
    //sTemp.append(" <td width=20% align=left class=td1 >"+sValue1[7]+"&nbsp;</td>");
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

