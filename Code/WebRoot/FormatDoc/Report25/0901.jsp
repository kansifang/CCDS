<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu  200.09.18
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
	sButtons[1][0] = "false";
%>
<%
	//��õ��鱨������
	int k = 0;   
	String sRowSubject = "";		//������ 
	String sNewReportDate1 = "���������";		//����ʲ���ծ������
	String sNewReportDate2 = "���������";		//������������
	String sNewReportDate3 = "���������";		//����ֽ�����������
	String sYear="",sMonth="";	

	String [] sYearReportDate = {"������","������","������"};  	 //�ʲ���ծ���걨����
	String [] sYearReportNo = {"0","0","0"};     			//�ʲ���ծ���걨��
	String [] ssyYearReportDate = {"������","������","������"};   //������걨����
	String [] ssyYearReportNo = {"0","0","0"};     			//������걨��
	String [] sxjYearReportDate = {"������","������","������"};   //�ֽ��������걨����
	String [] sxjYearReportNo = {"0","0","0"};     			//�ֽ��������걨��

	String sNewReportNo1 = "";		//����ʲ���ծ���
	String sNewReportNo2 = "";		//����������
	String sNewReportNo3 = "";		//����ֽ��������
	
	int iMoneyUnit = 10000 ;  //��λ��Ԫ
	
	/*--------------------------------�ʲ�����------------------------------------*/
	
	double dValue = 0 ;  //����±��ʲ���ծ�����ʲ��ܼ�
	double dFValue = 0 ; //����±��ʲ���ծ���и�ծ�ϼ�
	//����±��ʲ���ծ�����ʲ��ܼ�,�����ʲ��ϼ�,�����ʽ�,Ӧ���˿��,����Ӧ�տ�,���,����Ͷ�ʜQ��,�̶��ʲ���ֵ,�����ʲ��Q��,������ծ,���ڽ�һ���ڵ��ڵĳ��ڸ�ծ,Ӧ��Ʊ��,Ӧ���˿�,���ڸ�ծ�ϼ�,������Ȩ��,ʵ���ʱ� δ���������Ӯ�๫�� ֵ
	String[] sValue = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//����걨�ʲ���ծ�����ʲ��ܼ�,�����ʲ��ϼ�,�����ʽ�,Ӧ���˿��,����Ӧ�տ�,���,����Ͷ�ʜQ��,�̶��ʲ���ֵ,�����ʲ��Q��,������ծ,���ڽ�һ���ڵ��ڵĳ��ڸ�ծ,Ӧ��Ʊ��,Ӧ���˿�,���ڸ�ծ�ϼ�,������Ȩ��,ʵ���ʱ� δ���������Ӯ�๫�� ֵ
	String[] sValue1 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion1 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//����ڶ��걨�ʲ���ծ�����ʲ��ܼ�,�����ʲ��ϼ�,�����ʽ�,Ӧ���˿��,����Ӧ�տ�,���,����Ͷ�ʜQ��,�̶��ʲ���ֵ,�����ʲ��Q��,������ծ,���ڽ�һ���ڵ��ڵĳ��ڸ�ծ,Ӧ��Ʊ��,Ӧ���˿�,���ڸ�ծ�ϼ�,������Ȩ��,ʵ���ʱ� δ���������Ӯ�๫�� ֵ
	String[] sValue2 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion2 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	//��������걨�ʲ���ծ�����ʲ��ܼ�,�����ʲ��ϼ�,�����ʽ�,Ӧ���˿��,����Ӧ�տ�,���,����Ͷ�ʜQ��,�̶��ʲ���ֵ,�����ʲ��Q��,������ծ,���ڽ�һ���ڵ��ڵĳ��ڸ�ծ,Ӧ��Ʊ��,Ӧ���˿�,���ڸ�ծ�ϼ�,������Ȩ��,ʵ���ʱ� δ���������Ӯ�๫�� ֵ
	String[] sValue3 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};
	String[] sProportion3 = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"};

	String sReportDate[] = {"","","",""};
	String sReportScopeName[] = {"","","",""};
	String sAuditOffice[] = {"","","",""};
	String sAuditFlag[] = {"","","",""};
	String sAuditOpinion[] = {"","","",""};
//****************************�ʲ���ծ��***********************************************

	
//ȡ�����ʲ���ծ������

	ASResultSet rs2 = Sqlca.getResultSet("select ReportDate,substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo "+
						" from REPORT_RECORD "+
						" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%1' And  ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%1') and ReportScope = GETEVALUATESCOPE('"+sCustomerID+"',ReportDate)");
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
		rs2 = Sqlca.getResultSet("select getItemName('ReportScope',ReportScope) as ReportScopeName,AuditOffice,"+
							" getItemName('AuditInstance',AuditFlag) as AuditFlag ,getItemName('AuditOpinion',AuditOpinion) as AuditOpinion "+
							" from CUSTOMER_FSRECORD Where CustomerID = '"+sCustomerID+"' And ReportDate = '"+sReportDate[0]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sReportDate[0]+"')");
		if(rs2.next()){
			sReportScopeName[0] = rs2.getString("ReportScopeName");
			if(sReportScopeName[0] == null) sReportScopeName[0] = "";
			sAuditOffice[0] = rs2.getString("AuditOffice");
			if(sAuditOffice[0] == null) sAuditOffice[0] = "";
			sAuditOpinion[0] = rs2.getString("AuditOpinion");
			if(sAuditOpinion[0] == null) sAuditOpinion[0] = "";
			sAuditFlag[0] = rs2.getString("AuditFlag");
			if(sAuditFlag[0] == null) sAuditFlag[0] = "";
		}
		rs2.getStatement().close();	
	
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
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject ='809'");
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			//���ڽ�һ���ڵ��ڵĳ��ڸ�ծ
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject in ('201','211')");
			if(rs2.next())
			{
				sValue[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();

			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sNewReportNo1+"' And RowSubject in ('801','101','106','108','110','116','119','19m','805','202','203','806','808','301','303','305')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("801"))	//�����ʲ��ϼ� 
				{
					sValue[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("101"))	//�����ʽ�
				{		
					sValue[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("106"))	//Ӧ���˿��
				{
					sValue[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("108"))	//����Ӧ�տ�
				{
					sValue[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("110"))	//���
				{
					sValue[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("116"))	//����Ͷ�ʜQ��
				{
					sValue[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("119"))	//�̶��ʲ���ֵ
				{
					sValue[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19m"))	//�����ʲ��Q��
				{
					sValue[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("805"))	//������ծ
				{
					sValue[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("202"))	//Ӧ��Ʊ��
				{
					sValue[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("203"))	//Ӧ���˿�
				{
					sValue[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("806"))	//���ڸ�ծ�ϼ�
				{
					sValue[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("808"))	//������Ȩ��
				{
					sValue[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("301"))	//ʵ���ʱ�
				{
					sValue[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("303"))
				{
					sValue[16] = DataConvert.toString(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[16] = DataConvert.toString(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("305"))
				{
					sValue[16] = DataConvert.toMoney(DataConvert.toDouble(sValue[16])+rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion[16] = DataConvert.toMoney(DataConvert.toDouble(sProportion[16])+rs2.getDouble("Col2value")/dValue*100);
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
//		" and  ReportDate <>(select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%1')"+
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
			sYearReportNo[k] = rs2.getString("ReportNo");	//�ʲ���ծ���걨�� 
			sReportDate[k+1] = rs2.getString("ReportDate");
		}
		k ++;
	}
	rs2.getStatement().close();

//��һ��
	if(!sYearReportDate[0].equals("������"))
	{
		rs2 = Sqlca.getResultSet("select getItemName('ReportScope',ReportScope) as ReportScopeName,AuditOffice,"+
							" getItemName('AuditInstance',AuditFlag) as AuditFlag ,getItemName('AuditOpinion',AuditOpinion) as AuditOpinion "+
							" from CUSTOMER_FSRECORD Where CustomerID = '"+sCustomerID+"' And ReportDate = '"+sReportDate[1]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sReportDate[1]+"')");
		if(rs2.next()){
			sReportScopeName[1] = rs2.getString("ReportScopeName");
			if(sReportScopeName[1] == null) sReportScopeName[1] = "";
			sAuditOffice[1] = rs2.getString("AuditOffice");
			if(sAuditOffice[1] == null) sAuditOffice[1] = "";
			sAuditOpinion[1] = rs2.getString("AuditOpinion");
			if(sAuditOpinion[1] == null) sAuditOpinion[1] = "";
			sAuditFlag[1] = rs2.getString("AuditFlag");
			if(sAuditFlag[1] == null) sAuditFlag[1] = "";
		}
		rs2.getStatement().close();	
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
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject ='809'");
		
		if(rs2.next())
		{
			dFValue = rs2.getDouble("Col2value");
		}
		rs2.getStatement().close();
		if (dValue > 0.008)
		{
			//���ڽ�һ���ڵ��ڵĳ��ڸ�ծ
			rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject in ('201','211')");
			if(rs2.next())
			{
				sValue1[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
				sProportion1[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
			}
			rs2.getStatement().close();

			rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[0]+"' And RowSubject in ('801','101','106','108','110','116','119','19m','805','202','203','806','808','301','303','305')");
			while(rs2.next())
			{
				sRowSubject = rs2.getString("RowSubject");
				if (sRowSubject.equals("801"))	//�����ʲ��ϼ� 
				{
					sValue1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("101"))	//�����ʽ�
				{		
					sValue1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("106"))	//Ӧ���˿��
				{
					sValue1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("108"))	//����Ӧ�տ�
				{
					sValue1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("110"))	//���
				{
					sValue1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("116"))	//����Ͷ�ʜQ��
				{
					sValue1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("119"))	//�̶��ʲ���ֵ
				{
					sValue1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("19m"))	//�����ʲ��Q��
				{
					sValue1[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("805"))	//������ծ
				{
					sValue1[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("202"))	//Ӧ��Ʊ��
				{
					sValue1[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("203"))	//Ӧ���˿�
				{
					sValue1[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("806"))	//���ڸ�ծ�ϼ�
				{
					sValue1[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("808"))	//������Ȩ��
				{
					sValue1[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				else if (sRowSubject.equals("301"))	//ʵ���ʱ�
				{
					sValue1[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("303"))
				{
					sValue1[16] = DataConvert.toString(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[16] = DataConvert.toString(rs2.getDouble("Col2value")/dValue*100);
				}
				else if (sRowSubject.equals("305"))
				{
					sValue1[16] = DataConvert.toMoney(DataConvert.toDouble(sValue1[16])+rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[16] = DataConvert.toMoney(DataConvert.toDouble(sProportion1[16])+rs2.getDouble("Col2value")/dValue*100);
				}
			}
			rs2.getStatement().close();
		}
//�ڶ���
		if(!sYearReportDate[1].equals("������"))
		{
			rs2 = Sqlca.getResultSet("select getItemName('ReportScope',ReportScope) as ReportScopeName,AuditOffice,"+
								" getItemName('AuditInstance',AuditFlag) as AuditFlag ,getItemName('AuditOpinion',AuditOpinion) as AuditOpinion "+
								" from CUSTOMER_FSRECORD Where CustomerID = '"+sCustomerID+"' And ReportDate = '"+sReportDate[2]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sReportDate[2]+"')");
			if(rs2.next()){
				sReportScopeName[2] = rs2.getString("ReportScopeName");
				if(sReportScopeName[2] == null) sReportScopeName[2] = "";
				sAuditOffice[2] = rs2.getString("AuditOffice");
				if(sAuditOffice[2] == null) sAuditOffice[2] = "";
				sAuditOpinion[2] = rs2.getString("AuditOpinion");
				if(sAuditOpinion[2] == null) sAuditOpinion[2] = "";
				sAuditFlag[2] = rs2.getString("AuditFlag");
				if(sAuditFlag[2] == null) sAuditFlag[2] = "";
			}
			rs2.getStatement().close();	
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
			rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject ='809'");
			if(rs2.next())
			{
				dFValue = rs2.getDouble("Col2value");
			}
			rs2.getStatement().close();
			if (dValue > 0.008)
			{
				//���ڽ�һ���ڵ��ڵĳ��ڸ�ծ
				rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('201','211')");
				if(rs2.next())
				{
					sValue2[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion2[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
				}
				rs2.getStatement().close();

				rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[1]+"' And RowSubject in ('801','101','106','108','110','116','119','19m','805','202','203','806','808','301','303','305')");
				while(rs2.next())
				{
					sRowSubject = rs2.getString("RowSubject");
					if (sRowSubject.equals("801"))	//�����ʲ��ϼ� 
					{
						sValue2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("101"))	//�����ʽ�
					{		
						sValue2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("106"))	//Ӧ���˿��
					{
						sValue2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("108"))	//����Ӧ�տ�
					{
						sValue2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("110"))	//���
					{
						sValue2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("116"))	//����Ͷ�ʜQ��
					{
						sValue2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("119"))	//�̶��ʲ���ֵ
					{
						sValue2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("19m"))	//�����ʲ��Q��
					{
						sValue2[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("805"))	//������ծ
					{
						sValue2[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					else if (sRowSubject.equals("202"))	//Ӧ��Ʊ��
					{
						sValue2[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					else if (sRowSubject.equals("203"))	//Ӧ���˿�
					{
						sValue2[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					else if (sRowSubject.equals("806"))	//���ڸ�ծ�ϼ�
					{
						sValue2[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					else if (sRowSubject.equals("808"))	//������Ȩ��
					{
						sValue2[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					else if (sRowSubject.equals("301"))	//ʵ���ʱ�
					{
						sValue2[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("303"))
					{
					sValue1[16] = DataConvert.toString(rs2.getDouble("Col2value")/iMoneyUnit);
					sProportion1[16] = DataConvert.toString(rs2.getDouble("Col2value")/dValue*100);
					}
					else if (sRowSubject.equals("305"))
					{
						sValue2[16] = DataConvert.toMoney(DataConvert.toDouble(sValue2[16])+rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion2[16] = DataConvert.toMoney(DataConvert.toDouble(sProportion2[16])+rs2.getDouble("Col2value")/dValue*100);
					}					
				}
				rs2.getStatement().close();
			}
//������
			if(!sYearReportDate[2].equals("������"))
			{
				rs2 = Sqlca.getResultSet("select getItemName('ReportScope',ReportScope) as ReportScopeName,AuditOffice,"+
									" getItemName('AuditInstance',AuditFlag) as AuditFlag ,getItemName('AuditOpinion',AuditOpinion) as AuditOpinion "+
									" from CUSTOMER_FSRECORD Where CustomerID = '"+sCustomerID+"' And ReportDate = '"+sReportDate[3]+"' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"','"+sReportDate[3]+"')");
				if(rs2.next()){
					sReportScopeName[3] = rs2.getString("ReportScopeName");
					if(sReportScopeName[3] == null) sReportScopeName[3] = "";
					sAuditOffice[3] = rs2.getString("AuditOffice");
					if(sAuditOffice[3] == null) sAuditOffice[3] = "";
					sAuditOpinion[3] = rs2.getString("AuditOpinion");
					if(sAuditOpinion[3] == null) sAuditOpinion[3] = "";
					sAuditFlag[3] = rs2.getString("AuditFlag");
					if(sAuditFlag[3] == null) sAuditFlag[3] = "";
				}
				rs2.getStatement().close();				
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
				rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject ='809'");
				if(rs2.next())
				{
					dFValue = rs2.getDouble("Col2value");
				}
				rs2.getStatement().close();
				if (dValue > 0.008)
				{
					//���ڽ�һ���ڵ��ڵĳ��ڸ�ծ
					rs2 = Sqlca.getResultSet("select sum(Col2value) as Col2value from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject in ('201','211')");
					if(rs2.next())
					{
						sValue3[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
						sProportion3[10] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
					}
					rs2.getStatement().close();
					
					rs2 = Sqlca.getResultSet("select Col2value,RowSubject from REPORT_DATA where ReportNo = '"+sYearReportNo[2]+"' And RowSubject in ('801','101','106','108','110','116','119','19m','805','202','203','806','808','301','303','305')");
					while(rs2.next())
					{
						sRowSubject = rs2.getString("RowSubject");
						if (sRowSubject.equals("801"))	//�����ʲ��ϼ� 
						{
							sValue3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[1] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("101"))	//�����ʽ�
						{		
							sValue3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[2] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("106"))	//Ӧ���˿��
						{
							sValue3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[3] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("108"))	//����Ӧ�տ�
						{
							sValue3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[4] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("110"))	//���
						{
							sValue3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[5] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("116"))	//����Ͷ�ʜQ��
						{
							sValue3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[6] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("119"))	//�̶��ʲ���ֵ
						{
							sValue3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[7] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("19m"))	//�����ʲ��Q��
						{
							sValue3[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[8] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("805"))	//������ծ
						{
							sValue3[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[9] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
						}
						else if (sRowSubject.equals("202"))	//Ӧ��Ʊ��
						{
							sValue3[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[11] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
						}
						else if (sRowSubject.equals("203"))	//Ӧ���˿�
						{
							sValue3[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[12] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
						}
						else if (sRowSubject.equals("806"))	//���ڸ�ծ�ϼ�
						{
							sValue3[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[13] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
						}
						else if (sRowSubject.equals("808"))	//������Ȩ��
						{
							sValue3[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[14] = DataConvert.toMoney(rs2.getDouble("Col2value")/dFValue*100);
						}
						else if (sRowSubject.equals("301"))	//ʵ���ʱ�
						{
							sValue3[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[15] = DataConvert.toMoney(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("303"))
						{
							sValue1[16] = DataConvert.toString(rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion1[16] = DataConvert.toString(rs2.getDouble("Col2value")/dValue*100);
						}
						else if (sRowSubject.equals("305"))
						{
							sValue3[16] = DataConvert.toMoney(DataConvert.toDouble(sValue3[16])+rs2.getDouble("Col2value")/iMoneyUnit);
							sProportion3[16] = DataConvert.toMoney(DataConvert.toDouble(sProportion3[16])+rs2.getDouble("Col2value")/dValue*100);
						}
					}
					rs2.getStatement().close();
				}
			}
		}
	}
	/*--------------------------------�����-----------------------------------------*/

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

	//ȡ������������
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
	" where ObjectNo ='"+sCustomerID+"' And ModelNo like '%2' And ReportDate = (select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%2') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)");
	
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
		" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%2'"+
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
//		" and  ReportDate <>(select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%2')"+
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
	
	/*-----------------------------------�ֽ���----------------------------------*/
	
	//����ֽ��������±�
	String sxjValue[] = {"0","0","0","0","0","0"};

	//�����һ���ֽ��������걨
	String sxjValue1[] = {"0","0","0","0","0","0"};

	//����ڶ����ֽ��������걨
	String sxjValue2[] = {"0","0","0","0","0","0"};

	//����������ֽ��������걨
	String sxjValue3[] = {"0","0","0","0","0","0"};

	//ȡ����ֽ�����������
	rs2 = Sqlca.getResultSet("select substr(ReportDate,1,4) as Year,substr(ReportDate,6,2) as Month,ReportNo from REPORT_RECORD " +
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
			sNewReportDate3 = sYear + " ��12��";
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
		" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04') and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
//		" and  ReportDate <>(select max(Reportdate) from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' And ModelNo like '%8')"+
		" order by Year Desc");

	k = 0;
	while (k < 3)
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
	sTemp.append("	<form method='post' action='0901.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >9.1���ʲ���ծ��ṹ��Ա�</font></td>"); 	
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("   <td width=18% colspan=12 align=center class=td1 > <br><strong>�ʲ���ծ���ṹ�ͶԱ�</strong> <br>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td rowspan=2 align=center class=td1 > ��Ŀ</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sYearReportDate[0]+"</td>"); 
	sTemp.append("<td colspan=2 align=center class=td1 >"+sYearReportDate[1]+"</td>");
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
	sTemp.append("<td width=20% align=left class=td1 > ����ھ� </td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sReportScopeName[1]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sReportScopeName[2]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sReportScopeName[3]+"&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > �Ƿ������ </td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditFlag[1]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditFlag[2]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditFlag[3]+"&nbsp;</td>");
	sTemp.append("</tr>");	
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > ������ </td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOpinion[1]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOpinion[2]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOpinion[3]+"&nbsp;</td>");
	sTemp.append("</tr>");	
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > ������������� </td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOffice[1]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOffice[2]+"&nbsp;</td>");
	sTemp.append("<td colspan='2' align=left class=td1 nowrap>"+sAuditOffice[3]+"&nbsp;</td>");
	sTemp.append("</tr>");				
	sTemp.append("<tr>");
	sTemp.append("<td width=20% align=left class=td1 > ���ʲ� </td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue1[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion1[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue2[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion2[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sValue3[0]+"</td>");
	sTemp.append("<td align=right class=td1 nowrap>"+sProportion3[0]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > �����ʲ� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[1]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[1]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > �����ʱ� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[2]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[2]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > Ӧ���˿�</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[3]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[3]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ����Ӧ�տ� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[4]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[4]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ��� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[5]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[5]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ����Ͷ�� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[6]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[6]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > �̶��ʲ���ֵ </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[7]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[7]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > �����ʲ� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[8]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[8]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ������ծ </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[9]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[9]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ���ڽ�һ���ڵ��ڵĳ��ڽ��</td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[10]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[10]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > Ӧ��Ʊ�� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[11]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[11]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > Ӧ���˿� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[12]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[12]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ���ڽ�� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[13]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[13]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ������Ȩ��ϼ� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[14]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[14]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > ʵ���ʱ� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[15]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[15]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td align=left class=td1 > δ���������Ӯ�๫�� </td>");
	sTemp.append("<td align=right class=td1 >"+sValue1[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion1[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue2[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion2[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sValue3[16]+"</td>");
	sTemp.append("<td align=right class=td1 >"+sProportion3[16]+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("   <td width=18% colspan=12 align=center class=td1 > <br><strong>�����ṹ�ͶԱ�</strong> <br>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td rowspan=2 align=center class=td1 > ��Ŀ </td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+ssyYearReportDate[0]+"</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+ssyYearReportDate[1]+"</td>");
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
	sTemp.append("<tr>");
	sTemp.append("   <td width=18% colspan=12 align=center class=td1 > <br><strong>�ֽ�������</strong> <br>&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("<td rowspan=2 align=center class=td1 > ��Ŀ </td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[0]+"&nbsp;</td>");
	sTemp.append("<td colspan=2 align=center class=td1 >"+sxjYearReportDate[1]+"&nbsp;</td>");
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
