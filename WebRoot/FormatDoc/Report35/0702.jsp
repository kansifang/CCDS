<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu 2009/08/20
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
	String sNewReportDate1 = "���������";		//
	String sYear="",sMonth="";	

	String [] sYearReportDate = {"������","������","������"};  	 
	String [] sYearReportNo = {"0","0","0"};     			

	String sNewReportNo1 = "";	
	
	int iMoneyUnit = 10000 ;  //��λ��Ԫ
	double dValue = 0 ;  //����ϼ�
	double dFValue = 0 ; //֧���ϼ�
	//����ϼ�,������������,�ϼ���������,������λ����,��ҵ����,��Ӫ����,����ר��,��������,֧���ϼ�,��������,����ר��,ר��֧��,��ҵ֧��,��Ӫ֧��,�ɱ�����,����˰��,�Ͻ��ϼ�֧��,�Ը�����λ����,��ת�Գ����,��֧��� ֵ
	String[] sValue = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//����ϼ�,������������,�ϼ���������,������λ����,��ҵ����,��Ӫ����,����ר��,��������,֧���ϼ�,��������,����ר��,ר��֧��,��ҵ֧��,��Ӫ֧��,�ɱ�����,����˰��,�Ͻ��ϼ�֧��,�Ը�����λ����,��ת�Գ����,��֧��� ֵ
	String[] sValue1 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion1 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//����ϼ�,������������,�ϼ���������,������λ����,��ҵ����,��Ӫ����,����ר��,��������,֧���ϼ�,��������,����ר��,ר��֧��,��ҵ֧��,��Ӫ֧��,�ɱ�����,����˰��,�Ͻ��ϼ�֧��,�Ը�����λ����,��ת�Գ����,��֧��� ֵ
	String[] sValue2 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion2 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//����ϼ�,������������,�ϼ���������,������λ����,��ҵ����,��Ӫ����,����ר��,��������,֧���ϼ�,��������,����ר��,ר��֧��,��ҵ֧��,��Ӫ֧��,�ɱ�����,����˰��,�Ͻ��ϼ�֧��,�Ը�����λ����,��ת�Գ����,��֧��� ֵ
	String[] sValue3 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion3 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	String sReportDate[] = {"","",""};


	
//ȡ�����ʲ���ծ������

	ASResultSet rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo "+
						" from REPORT_RECORD "+
						" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%192' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%192') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)");
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
	
	if(!sNewReportDate1.equals("���������"))
	{
		//����ϼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject ='824'");
		if(rs2.next())
		{
			dValue = rs2.getDouble("Col2value");
			sValue[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
		}
		sProportion[0] = "100";
		rs2.getStatement().close();
		
		//֧���ϼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject ='821'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
		}
		sProportion[8] = "100";
		rs2.getStatement().close();
		
		//��֧���
		sValue[19] = DataConvert.toMoney(DataConvert.toDouble(sValue[0])-DataConvert.toDouble(sValue[8]));
		sValue[19] = "100";
		if (dValue > 0.008 || dFValue > 0.008)
		{							
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo1+
									 "' And RowSubject in ('559','560','565','562','587','561','571','548','549','550','551','552','554','z84','581','557','558')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("559"))	//������������ 
				{
					sValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("560"))	//�ϼ���������
				{		
					sValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("565"))	//������λ�ɿ�
				{
					sValue[3] = DataConvert.toMoney(sValue2[2]+rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("562"))	//��ҵ����
				{
					sValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("587"))	//��Ӫ����
				{
					sValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("561"))	//����ר��
				{
					sValue[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("571"))	//��������
				{
					sValue[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("548"))	//��������
				{
					sValue[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("549"))	//����ר��
				{
					sValue[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("550"))	//ר��֧��
				{
					sValue[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("551"))	//��ҵ֧��
				{
					sValue[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[162] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("552"))	//��Ӫ֧��
				{
					sValue[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("554"))	//�ɱ�����
				{
					sValue[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("z84"))	//����˰��
				{
					sValue[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("581"))	//�Ͻ��ϼ�֧��
				{
					sValue[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("557"))	//�Ը�����λ����
				{
					sValue[17] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[17] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("558"))	//��ת�Գ����
				{
					sValue[18] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[18] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}																								
			}
			rs2.getStatement().close();
		}
	}
	
//�걨

	rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,ReportNo from REPORT_RECORD "+
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%192'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
//		" and  ReportDate <>(select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%192')"+
		" order by Year Desc");  

	k = 0;
	while (k < 3)
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
				sYearReportDate[k] = sYear + " ��12��";
			}
			sYearReportNo[k] = rs2.getString("ReportNo");
		}
		k ++;
	}
	rs2.getStatement().close();

//��һ��
	if(!sYearReportDate[0].equals("���������"))
	{
		//����ϼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject ='824'");
		if(rs2.next())
		{
			dValue = rs2.getDouble("Col2value");
			sValue1[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
		}
		sProportion1[0] = "100";
		rs2.getStatement().close();
		
		//֧���ϼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject ='821'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue1[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
		}
		sProportion1[8] = "100";
		rs2.getStatement().close();
		
		//��֧���
		sValue1[19] = DataConvert.toMoney(DataConvert.toDouble(sValue1[0])-DataConvert.toDouble(sValue1[8]));
		sProportion1[19] = "100";
		if (dValue > 0.008 || dFValue > 0.008)
		{							
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+
									 "' And RowSubject in ('559','560','565','562','587','561','571','548','549','550','551','552','554','z84','581','557','558')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("559"))	//������������ 
				{
					sValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("560"))	//�ϼ���������
				{		
					sValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("565"))	//������λ�ɿ�
				{
					sValue1[3] = DataConvert.toMoney(sValue2[2]+rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("562"))	//��ҵ����
				{
					sValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("587"))	//��Ӫ����
				{
					sValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("561"))	//����ר��
				{
					sValue1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("571"))	//��������
				{
					sValue1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("548"))	//��������
				{
					sValue1[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("549"))	//����ר��
				{
					sValue1[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("550"))	//ר��֧��
				{
					sValue1[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("551"))	//��ҵ֧��
				{
					sValue1[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[162] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("552"))	//��Ӫ֧��
				{
					sValue1[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("554"))	//�ɱ�����
				{
					sValue1[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("z84"))	//����˰��
				{
					sValue1[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("581"))	//�Ͻ��ϼ�֧��
				{
					sValue1[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("557"))	//�Ը�����λ����
				{
					sValue1[17] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[17] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("558"))	//��ת�Գ����
				{
					sValue1[18] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[18] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}																								
			}
			rs2.getStatement().close();
		}
	}
//�ڶ���
	if(!sYearReportDate[1].equals("���������"))
	{
		//����ϼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='824'");
		if(rs2.next())
		{
			dValue = rs2.getDouble("Col2value");
			sValue2[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
		}
		sProportion2[0] = "100";
		rs2.getStatement().close();
		
		//֧���ϼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='821'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue2[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
		}
		sProportion2[8] = "100";
		rs2.getStatement().close();
		
		//��֧���
		sValue[19] = DataConvert.toMoney(DataConvert.toDouble(sValue2[0])-DataConvert.toDouble(sValue2[8]));
		sProportion2[19] = "100";
		
		if (dValue > 0.008 || dFValue > 0.008)
		{							
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+
									 "' And RowSubject in ('559','560','565','562','587','561','571','548','549','550','551','552','554','z84','581','557','558')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("559"))	//������������ 
				{
					sValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("560"))	//�ϼ���������
				{		
					sValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("565"))	//������λ�ɿ�
				{
					sValue2[3] = DataConvert.toMoney(sValue2[2]+rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("562"))	//��ҵ����
				{
					sValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("587"))	//��Ӫ����
				{
					sValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("561"))	//����ר��
				{
					sValue2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("571"))	//��������
				{
					sValue2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("548"))	//��������
				{
					sValue2[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("549"))	//����ר��
				{
					sValue2[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("550"))	//ר��֧��
				{
					sValue2[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("551"))	//��ҵ֧��
				{
					sValue2[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[162] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("552"))	//��Ӫ֧��
				{
					sValue2[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("554"))	//�ɱ�����
				{
					sValue2[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("z84"))	//����˰��
				{
					sValue2[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("581"))	//�Ͻ��ϼ�֧��
				{
					sValue2[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("557"))	//�Ը�����λ����
				{
					sValue2[17] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[17] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("558"))	//��ת�Գ����
				{
					sValue2[18] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[18] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}																								
			}
			rs2.getStatement().close();
		}
	}	
//�ڶ���
	if(!sYearReportDate[1].equals("���������"))
	{
		//����ϼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='824'");
		if(rs2.next())
		{
			dValue = rs2.getDouble("Col2value");
			sValue3[0] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
		}
		sProportion2[0] = "100";
		rs2.getStatement().close();
		
		//֧���ϼ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='821'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
			sValue3[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
		}
		sProportion3[8] = "100";
		rs2.getStatement().close();
		
		//��֧���
		sValue3[19] = DataConvert.toMoney(DataConvert.toDouble(sValue3[0])-DataConvert.toDouble(sValue3[8]));
		sProportion3[19] = "100";
		
		if (dValue > 0.008 || dFValue > 0.008)
		{							
			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+
									 "' And RowSubject in ('559','560','565','562','587','561','571','548','549','550','551','552','554','z84','581','557','558')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("559"))	//������������ 
				{
					sValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("560"))	//�ϼ���������
				{		
					sValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("565"))	//������λ�ɿ�
				{
					sValue3[3] = DataConvert.toMoney(sValue2[2]+rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("562"))	//��ҵ����
				{
					sValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("587"))	//��Ӫ����
				{
					sValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("561"))	//����ר��
				{
					sValue3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("571"))	//��������
				{
					sValue3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("548"))	//��������
				{
					sValue3[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("549"))	//����ר��
				{
					sValue3[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("550"))	//ר��֧��
				{
					sValue3[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("551"))	//��ҵ֧��
				{
					sValue3[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[162] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("552"))	//��Ӫ֧��
				{
					sValue3[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("554"))	//�ɱ�����
				{
					sValue3[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("z84"))	//����˰��
				{
					sValue3[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("581"))	//�Ͻ��ϼ�֧��
				{
					sValue3[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[16] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("557"))	//�Ը�����λ����
				{
					sValue3[17] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[17] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("558"))	//��ת�Գ����
				{
					sValue3[18] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion3[18] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}																								
			}
			rs2.getStatement().close();
		}		
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0702.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=7 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7.2������֧���ṹ�ͶԱ�</font></td>");
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
    sTemp.append("<td rowspan=2 align=center class=td1 > ��Ŀ</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sYearReportDate[0]+"&nbsp;</td>"); 
	sTemp.append("<td colspan=2 align=center class=td1 >"+sYearReportDate[1]+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sYearReportDate[2]+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=15% align=center class=td1 > ��ֵ����Ԫ��</td>");
	sTemp.append("<td width=10% align=center class=td1 >%</td>");
	sTemp.append("<td width=15% align=center class=td1 > ��ֵ����Ԫ��</td>");
	sTemp.append("<td width=10% align=center class=td1 >%</td>");
	sTemp.append("<td width=15% align=center class=td1 >��ֵ����Ԫ��</td>");
	sTemp.append("<td width=10% align=center class=td1 >%</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("   <td class=td1 align=left colspan=1 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >����ϼ�</font></td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue1[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion1[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue2[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion2[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue3[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion3[0]+"</td>");
	sTemp.append("</tr>");			
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ������������ </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[1]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > �ϼ��������� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ������λ�ɿ�Ͻ����룩</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[3]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ��ҵ���� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[4]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ��Ӫ���� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[5]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ����ר�� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[6]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > �������� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[7]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("   <td class=td1 align=left colspan=1 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >֧���ϼ�</font></td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[8]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > �������� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[9]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ����ר��</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[10]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ר��֧�� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[11]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ��ҵ֧�� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[12]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ��Ӫ֧�� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[13]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > �ɱ����� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[14]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ����˰�� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[15]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > �Ͻ��ϼ�֧�� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[16]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > �Ը�����λ���� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[17]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[17]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[17]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[17]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[17]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ��ת�Գ���� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[18]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[18]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[18]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[18]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[18]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[18]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("   <td class=td1 align=left colspan=1>��֧���</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[19]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[19]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[19]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[19]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[19]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[19]+"</td>");
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
	