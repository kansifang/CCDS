<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2011/03/21
		Tester:
		Content: ����ĵ�0ҳ
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
	int iDescribeCount = 33;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//��õ��鱨������
	String sInputOrgName = "";
	String sCustomerName = "";
	String sCorpID = "";
	String sRegisterCapital = "";//RCCurrency ע���ʱ�����
	String sRegisterAdd = "";//ע���ַ
	String sApplyType = "";//���ŷ�ʽ
	String sBusinessTypeName = "";
	String sBusinessSum = "";
	String sBusinessCurrencyName = "";
	String sTermMonth = "";
	String sBusinessRate = "";//����/����
	String sBailRatio = "";
	String sCycleFlag = "";//�Ƿ��ѭ��
	String sVouchTypeName = "";
	String sPurpose = "";
	String sActualBusiness = "";
	String sIndustryTypeName = "";//������ҵ����
	String sScopeName = "";//��ҵ��ģ
	String sSetupDate = "";//��ҵ����ʱ��
	String sOwnStockholder="��";//�Ƿ����йɶ�
	String sCustomerType = "";//�ͻ�����
	String[] sGuarantyTypeNameValue = {"","",""};//��Ѻ������
	String[] sOwnerNameValue = {"","",""};//������
	String[] sCertIDValue = {"","",""};//������֤������
	String[] sEvalNetValue = {"","",""};//��Ѻ���ֵ
	String[] sGuarantyRightID = {"","",""};//��Ѻƾ֤���
	String[] sBeginDate = {"","",""};//��Ѻ������
	String sTempBeginDate = "";//��Ѻ������
	String[] sGuarantyRate = {"","",""};//��Ѻ��
	String sSex = "";//�Ա�
	String sBirthday = "";//��������
	String sNativePlace = "";//����
	String sIndCertID = "";//���֤
	String sFamilyAdd = "";//��ͥסַ
	String sEduExperience = "";//ѧ��
	String sMarriage = "";//����״��
	String sPopulationNum = "";//��ͥ�˿���
	String sWorkCorp = "";//��λ����
	String sUnitKind = "";//��λ������ҵ
	String sHeadShip = "";//ְ��
	String sMonthIncome = "";//����������
	String sFamilyMonthIncome = "";//��ͥ������
	String sWorkCorpUnitKind = "";
	int iAge = 0;//����
	int iGuarantyCount = 0;//��Ѻ�����
	String sReportNo = "";//���һ�ڲ��񱨱���
	String sTotalAssetSum = "";//���ʲ�
	String sTotalDebtSum = "";//�ܸ�ծ
	String sOwnerInterests = "";//������Ȩ��
	double dAssetDebtRate = 0.00;//�ʲ���ծ��
	String sRetainedProfits = "";//������
	String sLastReportNo = "";//��һ����񱨱���
	String sMainIncome = "";//��һ����Ӫҵ������
	//������Ϣ
	String sSql = " select CustomerID,getCustomerType(CustomerID) as CustomerType ,"+
				  " getItemName('BusinessApplyType',ApplyType) as ApplyType,"+
				  " getBusinessName(BusinessType) as BusinessTypeName, "+
				  " BusinessSum/10000 as BusinessSum,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName,TermMonth,"+
				  " nvl(BusinessRate,PdgRatio) as BusinessRate, BailRatio,getItemName('VouchType',VouchType) as VouchTypeName,"+
				  " Purpose,getItemName('YesNo',CycleFlag) as CycleFlag,getOrgName(InputOrgID) as InputOrgName "+
				  " from Business_Apply where SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
		if(sCustomerID == null) sCustomerID = "";
		sApplyType = rs.getString("ApplyType");
		if(sApplyType == null) sApplyType = " ";
		sBusinessTypeName = rs.getString("BusinessTypeName");
		if(sBusinessTypeName == null) sBusinessTypeName = "";
		sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum"));
		if(sBusinessSum == null) sBusinessSum = "";
		sBusinessCurrencyName = rs.getString("BusinessCurrencyName");
		if(sBusinessCurrencyName == null) sBusinessCurrencyName = "";
		sTermMonth = rs.getString("TermMonth");
		if(sTermMonth == null) sTermMonth = "";
		sBusinessRate = DataConvert.toString(rs.getDouble("BusinessRate"));
		if(sBusinessRate == null) sBusinessRate = "";
		sBailRatio = DataConvert.toString(rs.getDouble("BailRatio"));
		if(sBailRatio == null) sBailRatio = "";
		sVouchTypeName = rs.getString("VouchTypeName");
		if(sVouchTypeName == null) sVouchTypeName = "";
		sPurpose = rs.getString("Purpose");
		if(sPurpose == null) sPurpose = "";
		sCycleFlag = rs.getString("CycleFlag");
		if(sCycleFlag == null) sCycleFlag = "";	
		sInputOrgName = rs.getString("InputOrgName");
		if(sInputOrgName == null) sInputOrgName = "";
		sCustomerType =  rs.getString("CustomerType");
		if(sCustomerType == null) sCustomerType = "";
	}
	rs.getStatement().close();	
	//�ͻ�������Ϣ
	if(sCustomerType.startsWith("01"))//��˾�ͻ�
	{
		//��˾�ͻ���Ϣ
		sSql = " select getCustomerName(CustomerID) as CustomerName,CorpID,nvl(RegisterCapital,0)*getErate(RCCurrency,'01','') as RegisterCapital, "+
			   " RegisterAdd,ActualBusiness,getItemName('IndustryType',IndustryType) as IndustryTypeName,"+
			   " getItemName('Scope',Scope)  as ScopeName,SetupDate "+
			   " from Ent_Info where CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			if(sCustomerName == null) sCustomerName = "";
			sCorpID = rs.getString("CorpID");
			if(sCorpID == null) sCorpID = "";
			sRegisterCapital = DataConvert.toMoney(rs.getDouble("RegisterCapital"));
			if(sRegisterCapital == null) sRegisterCapital = "";
			sRegisterAdd = rs.getString("RegisterAdd");
			if(sRegisterAdd == null) sRegisterAdd = "";
			sActualBusiness = rs.getString("ActualBusiness");
			if(sActualBusiness == null) sActualBusiness = "";	
			sIndustryTypeName = rs.getString("IndustryTypeName");
			if(sIndustryTypeName == null) sIndustryTypeName = "";
			sScopeName = rs.getString("ScopeName");
			if(sScopeName == null) sScopeName = "";
			sSetupDate = rs.getString("SetupDate");
			if(sSetupDate == null) sSetupDate = "";
			
		}	   
		rs.getStatement().close();
		//�Ƿ����йɶ�
		sSql = " select 1 from CUSTOMER_SPECIAL where SectionType='50' and CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sOwnStockholder="��";
		}	   
		rs.getStatement().close();
		//��˾�ͻ����һ�ڵĲ�������ʲ���ծ��
		ASResultSet rs2 = Sqlca.getResultSet("select ReportNo from REPORT_RECORD " +
		" where ObjectNo ='"+sCustomerID+"' And ReportDate = (select max(Reportdate) "+
		"from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' and  ModelNo like '%1') "+
		" and ModelNo like '%1' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)");
		if(rs2.next())
		{
			sReportNo = rs2.getString("ReportNo");	//����ֽ��������
		}
		rs2.getStatement().close();
		
		//���ʲ�
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sReportNo+"' And RowSubject ='804'");
		if(rs2.next())
		{
			sTotalAssetSum = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
		//�ܸ�ծ
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sReportNo+"' And RowSubject ='807'");
		if(rs2.next())
		{
			sTotalDebtSum = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
		//������Ȩ��
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sReportNo+"' And RowSubject ='808'");
		if(rs2.next())
		{
			sOwnerInterests = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
		
		//��˾�ͻ����һ�ڵĲ����������ָ���
		 rs2 = Sqlca.getResultSet("select ReportNo from REPORT_RECORD " +
		" where ObjectNo ='"+sCustomerID+"' And ReportDate = (select max(Reportdate) "+
		"from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' and  ModelNo like '%9') "+
		" and ModelNo like '%9' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)");
		if(rs2.next())
		{
			sReportNo = rs2.getString("ReportNo");	//����ֽ��������
		}
		rs2.getStatement().close();

		//�ʲ���ծ��
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sReportNo+"' And RowSubject ='911'");
		if(rs2.next())
		{
			dAssetDebtRate = rs2.getDouble("Col2value");		
		}
		rs2.getStatement().close();
		
		//��˾�ͻ����һ�ڵĲ�����������
		 rs2 = Sqlca.getResultSet("select ReportNo from REPORT_RECORD " +
		" where ObjectNo ='"+sCustomerID+"' And ReportDate = (select max(Reportdate) "+
		"from REPORT_RECORD Where ObjectNo ='"+sCustomerID+"' and  ModelNo like '%2') "+
		" and ModelNo like '%2' and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)");
		if(rs2.next())
		{
			sReportNo = rs2.getString("ReportNo");	//����ֽ��������
		}
		rs2.getStatement().close();
		//������
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sReportNo+"' And RowSubject ='517'");
		if(rs2.next())
		{
			sRetainedProfits = DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
		
		//��һ����Ӫҵ�����������
		//�����걨
		rs2 = Sqlca.getResultSet("select ReportNo from REPORT_RECORD "+
			" where ObjectNo ='"+sCustomerID+"' and ModelNo like '%2'"+
			" and ReportDate like '"+(Integer.parseInt(StringFunction.getToday().substring(0,4))-1)+"%'"+
			" and  ReportDate in(select ReportDate from CUSTOMER_FSRECORD where CustomerID= '"+sCustomerID+"' and ReportPeriod='04')  and ReportScope = GETFSREPORTSCOPE('"+sCustomerID+"',ReportDate)"+
			" order by ReportDate Desc");
		if(rs2.next())
		{
			sLastReportNo = rs2.getString("ReportNo");	//����ֽ��������
		}
		rs2.getStatement().close();
		//��Ӫҵ������
		rs2 = Sqlca.getResultSet("select Col2value from REPORT_DATA where ReportNo = '"+sLastReportNo+"' And RowSubject ='501'");
		if(rs2.next())
		{
			sMainIncome= DataConvert.toMoney(rs2.getDouble("Col2value")/10000);		
		}
		rs2.getStatement().close();
	}else{//���˿ͻ�
		sSql = " select getCustomerName(CustomerID) as CustomerName,Birthday,getItemName('Sex',Sex) as Sex,NativePlace,CertID,FamilyAdd,"+
				" getItemName('EducationExperience',EduExperience) as EduExperience,"+
				" getItemName('Marriage',Marriage) as Marriage,"+
				" PopulationNum,WorkCorp,getItemName('IndustryType',UnitKind) as UnitKind,"+
				" getItemName('HeadShip',HeadShip) as HeadShip,YearIncome,FamilyMonthIncome "+
			   " from IND_INFO where CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			if(sCustomerName == null) sCustomerName = "";
			sBirthday = rs.getString("Birthday");
			if(sBirthday == null) sBirthday = "";
			if(!"".equals(sBirthday) && !" ".equals(sBirthday))
			{
				iAge = Integer.parseInt(StringFunction.getToday().substring(0,4))-Integer.parseInt(sBirthday.substring(0,4));
			}		
			sSex = rs.getString("Sex");
			if(sSex == null) sSex = "";
			sNativePlace = rs.getString("NativePlace");
			if(sNativePlace == null) sNativePlace = "";
			sIndCertID = rs.getString("CertID");
			if(sIndCertID == null) sIndCertID = "";
			sFamilyAdd = rs.getString("FamilyAdd");
			if(sFamilyAdd == null) sFamilyAdd = "";
			sEduExperience = rs.getString("EduExperience");
			if(sEduExperience == null) sEduExperience = "";	
			sMarriage = rs.getString("Marriage");
			if(sMarriage == null) sMarriage = "";
			sPopulationNum = rs.getString("PopulationNum");
			if(sPopulationNum == null) sPopulationNum = "";
			sWorkCorp = rs.getString("WorkCorp");
			if(sWorkCorp == null) sWorkCorp = "";
			sUnitKind = rs.getString("UnitKind");
			if(sUnitKind == null) sUnitKind = "";
			sWorkCorpUnitKind = sWorkCorp+"/"+sUnitKind;
			sHeadShip = rs.getString("HeadShip");
			if(sHeadShip == null) sHeadShip = "";
			sMonthIncome = DataConvert.toMoney(rs.getDouble("YearIncome")/12);
			if(sMonthIncome == null) sMonthIncome = "";
			sFamilyMonthIncome = DataConvert.toMoney(rs.getDouble("FamilyMonthIncome"));
			if(sFamilyMonthIncome == null) sFamilyMonthIncome = "";
			
		}	   
		rs.getStatement().close();
		//�Ƿ����йɶ�
		sSql = " select 1 from CUSTOMER_SPECIAL where SectionType='50' and CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sOwnStockholder="��";
		}	   
		rs.getStatement().close();
	}
	//��Ѻ������
	sSql = " select getItemName('GuarantyList',GI.GuarantyType) as GuarantyTypeName, "+
		" GI.OwnerName,GI.CertID,GI.EvalNetValue,GI.GuarantyRightID,GI.BeginDate,GI.OwnerTime,GI.GuarantyRate "+
		" from GUARANTY_RELATIVE GR,GUARANTY_INFO GI "+
		" where GR.GuarantyID=GI.GuarantyID and GR.ObjectType='CreditApply'"+
		" and GuarantyType like '020%' "+
		" and ObjectNo='"+sObjectNo+"' fetch first 3 rows only";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sGuarantyTypeNameValue[iGuarantyCount] = rs.getString("GuarantyTypeName");
		sOwnerNameValue[iGuarantyCount] = rs.getString("OwnerName");
		sCertIDValue[iGuarantyCount] = rs.getString("CertID");
		sEvalNetValue[iGuarantyCount] = DataConvert.toMoney(rs.getDouble("EvalNetValue")/10000);
		sGuarantyRightID[iGuarantyCount] = rs.getString("GuarantyRightID");
		sTempBeginDate = rs.getString("OwnerTime");
		if(sTempBeginDate == null) sTempBeginDate = "";
		sBeginDate[iGuarantyCount] = sTempBeginDate;
		sGuarantyRate[iGuarantyCount] = rs.getString("GuarantyRate");
		iGuarantyCount =iGuarantyCount+1;
	}	   
	rs.getStatement().close();
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=16 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���ũ����ҵ���йɷ����޹�˾</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=16 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ͷ�������ҵ���������������</font></td> ");	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append(" <td align=center class=td1 >�ʱ��У�</td>");
    sTemp.append(" <td colspan=16' align=left class=td1 >"+sInputOrgName+"&nbsp;&nbsp;</td>");
    sTemp.append(" </tr>");
    
    
    
	if(sCustomerType.startsWith("01"))//��˾�ͻ�
	{ 
	    //��˾�ͻ�����
	    sTemp.append("   <tr>");	
	    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >��˾�ͻ�������Ϣ</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='2' align=center class=td1 >�ͻ�����</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >�ͻ���֯��������</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sCorpID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='2' align=center class=td1 >ע��ص�</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sRegisterAdd+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >ע���ʱ�����Ԫ��</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sRegisterCapital+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='2' align=center class=td1 >��ҵ����</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sIndustryTypeName+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >��ҵ��ģ</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sScopeName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='2' align=center class=td1 >����ʱ��</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sSetupDate+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >�Ƿ�Ϊ���йɶ�</td>");
		sTemp.append(" 		<td colspan='6' align=left class=td1 >"+sOwnStockholder+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='2' align=center class=td1 >��Ӫҵ��</td>");
		sTemp.append(" 		<td colspan='14' align=left class=td1 >"+sActualBusiness+"&nbsp;</td>");
		sTemp.append("   </tr>");
		
		 //����������� ����λ����Ԫ��
	    sTemp.append("   <tr>");	
	    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >����������� ����λ����Ԫ��</font></td>");
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >���ʲ�</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >�ܸ�ծ</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >������Ȩ��</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >�ʲ���ծ��</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >��һ����Ӫҵ������</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >������</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >"+sTotalAssetSum+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sTotalDebtSum+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >"+sOwnerInterests+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+dAssetDebtRate+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >"+sMainIncome+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sRetainedProfits+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}else{
		 //���˿ͻ�����
	    sTemp.append("   <tr>");	
	    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >���˿ͻ�������Ϣ</font></td>");
		sTemp.append("   </tr>");	
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >����������</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sCustomerName+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >����</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+iAge+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >�Ա�</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sSex+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >�������ڵ�</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sNativePlace+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >���֤��</td>");
		sTemp.append(" 		<td colspan='8' align=left class=td1 >"+sIndCertID+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >��ͥסַ</td>");
		sTemp.append(" 		<td colspan='13' align=left class=td1 >"+sFamilyAdd+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >ѧ��</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sEduExperience+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >����״��</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sMarriage+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >��ͥ�˿�</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sPopulationNum+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >������λ/��ҵ</td>");
		sTemp.append(" 		<td colspan='7' align=left class=td1 >"+sWorkCorpUnitKind+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >ְ��/��Ӫ��ģ</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sHeadShip+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");	
		sTemp.append(" 		<td colspan='3' align=center class=td1 >������</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sMonthIncome+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=center class=td1 >��ͥ������</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sFamilyMonthIncome+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=center class=td1 >��ͥ��֧��</td>");
		sTemp.append("   <td  colspan='3' align=left class=td1>");
		sTemp.append(myOutPut("2",sMethod,"name='describe0' style='width:100%; height:30'",getUnitData("describe0",sData)));
		sTemp.append("   <br>");
		sTemp.append("&nbsp;</td>");
		sTemp.append("   </tr>");
	}
	
	
	 //��������������������
    sTemp.append("   <tr>");	
    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >��������������������</font></td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='4' align=center class=td1 >����Ʒ��</td>");
	sTemp.append(" 		<td colspan='3' align=left class=td1 >����Ԫ��</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >����</td>");
	sTemp.append(" 		<td colspan='2' align=left class=td1 >���ޣ��£�</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >��/����</td>");
	sTemp.append(" 		<td colspan='3' align=left class=td1 >��֤�������%��</td>");
	sTemp.append("   </tr>");
	//δ��������ҵ��
	sSql = " select getBusinessName(BusinessType) as BusinessTypeName, "+
			" BusinessSum,getItemName('Currency',BusinessCurrency) as Currency,"+
			" TermMonth,BusinessRate,BailRatio "+
		" from BUSINESS_CONTRACT  where  (FinishDate = '' or FinishDate is null)  and (BusinessType like '1%'  or BusinessType like '2%' ) and CustomerID = '"+sCustomerID+"'";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sTemp.append("   <tr>");
		sTemp.append(" 		<td colspan='4' align=left class=td1 >"+rs.getString(1)+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+DataConvert.toMoney(rs.getDouble(2)/10000)+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+rs.getString(3)+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+rs.getInt(4)+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='2' align=left class=td1 >"+rs.getDouble(5)+"&nbsp;</td>");
		sTemp.append(" 		<td colspan='3' align=left class=td1 >"+rs.getDouble(6)+"&nbsp;</td>");
		sTemp.append("   </tr>");
	}	   
	rs.getStatement().close();
	
	
	  //������Ϣ
    sTemp.append("   <tr>");	
    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >������Ϣ</font></td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='4' align=center class=td1 >����Ʒ��</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >���(��Ԫ)</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >����</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >����(��)</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >��/��</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >��֤�������%��</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan='4' align=left class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sBusinessSum+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sBusinessCurrencyName+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sTermMonth+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='2' align=left class=td1 >"+sBusinessRate+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=left class=td1 >"+sBailRatio+"&nbsp;</td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append(" <td colspan='2' align=left class=td1 height=30 >������;��</td>");
	sTemp.append(" <td colspan='14' align=left class=td1 height=30 >"+sPurpose+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >���������뾭Ӫ����Ƿ����</td>");
    sTemp.append(" 		<td colspan='5' align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe1'",getUnitData("describe1",sData),"��&nbsp;&nbsp;&nbsp;&nbsp;@��"));
	sTemp.append("      </td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >ó�ף����̣���ͬ�Ƿ���ʵ</td>");
    sTemp.append(" 		<td colspan='5' align=center class=td1 >");
	sTemp.append(myOutPutCheck("5",sMethod,"name='describe2'",getUnitData("describe2",sData),"��&nbsp;&nbsp;&nbsp;&nbsp;@��"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" <td colspan='2' align=left class=td1 height=30 >������Դ��</td>");
  	sTemp.append("   <td  colspan='14' align=left class=td1 height=30 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:100%'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" <td colspan='7' align=left class=td1 height=30 >���涨�������ʽ�����������������Ԫ�����������ʽ���������д��</td>");
	sTemp.append("   <td  colspan='9' align=left class=td1 height=30 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:100%'",getUnitData("describe4",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	
	//��Ѻ�����
	sTemp.append("   <tr>");	
    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >��Ѻ�����</font></td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >����</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >������</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >������</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >������</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >��Ѻ������</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sGuarantyTypeNameValue[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyTypeNameValue[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyTypeNameValue[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >������</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sOwnerNameValue[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sOwnerNameValue[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sOwnerNameValue[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >��������֯����</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sCertIDValue[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sCertIDValue[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sCertIDValue[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >������Ը�Ƿ���ʵ</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe5' style='width:100%; height:30'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe6' style='width:100%; height:30'",getUnitData("describe6",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe7' style='width:100%; height:30'",getUnitData("describe7",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >�������Ƿ�ͬ�����</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe8' style='width:100%; height:30'",getUnitData("describe8",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe9' style='width:100%; height:30'",getUnitData("describe9",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe10' style='width:100%; height:30'",getUnitData("describe10",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >��Ѻ�����Ԫ��</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sEvalNetValue[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sEvalNetValue[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sEvalNetValue[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >��Ѻƾ֤���</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sGuarantyRightID[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyRightID[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyRightID[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >��Ѻ�ﵽ����</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sBeginDate[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sBeginDate[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sBeginDate[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >��Ѻ�ʣ�%��</td>");
	sTemp.append(" 		<td colspan='5' align=center class=td1 >"+sGuarantyRate[0]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyRate[1]+"&nbsp;</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >"+sGuarantyRate[2]+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >����Ȩ���Ƿ�����</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe11' style='width:100%; height:30'",getUnitData("describe11",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe12' style='width:100%; height:30'",getUnitData("describe12",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe13' style='width:100%; height:30'",getUnitData("describe13",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >�Ƿ������Ѻ����</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe14' style='width:100%; height:30'",getUnitData("describe14",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe15' style='width:100%; height:30'",getUnitData("describe15",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe16' style='width:100%; height:30'",getUnitData("describe16",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	
	
	//��֤�����
	sTemp.append("   <tr>");	
    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >��֤�����</font></td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='4' align=center class=td1 >��֤�����Ԫ��</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >��֤�������</td>");
	sTemp.append(" 		<td colspan='2' align=center class=td1 >��֤���������</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >��֤������</td>");
	sTemp.append(" 		<td colspan='4' align=center class=td1 >��λ���ڴ���֤ʵ����</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe17' style='width:100%; height:30'",getUnitData("describe17",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='3' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe18' style='width:100%; height:30'",getUnitData("describe18",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='2' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe19' style='width:100%; height:30'",getUnitData("describe19",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='3' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe20' style='width:100%; height:30'",getUnitData("describe20",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   <td  colspan='4' align=left class=td1>");
	sTemp.append(myOutPut("2",sMethod,"name='describe21' style='width:100%; height:30'",getUnitData("describe21",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	
	
	//ί�д������
	sTemp.append("   <tr>");	
    sTemp.append(" <td colspan='16' align=center class=td1 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;' >ί�д������</font></td>");
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >ί����</td>");
	sTemp.append("   <td  colspan='13' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe22' style='width:100%; height:30'",getUnitData("describe22",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >��֯����</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe23' style='width:100%; height:30'",getUnitData("describe23",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >ע���ʽ���Ԫ��</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe24' style='width:100%; height:30'",getUnitData("describe24",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >���п�����</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe25' style='width:100%; height:30'",getUnitData("describe25",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >�˺�</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe26' style='width:100%; height:30'",getUnitData("describe26",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >�˻�����Ԫ��</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe27' style='width:100%; height:30'",getUnitData("describe27",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >�˻�����Ƿ����ί�д�����</td>");
    sTemp.append(" 		<td colspan='5' align=center class=td1 >");
	sTemp.append(myOutPut("2",sMethod,"name='describe28' style='width:100%; height:30'",getUnitData("describe28",sData)));
	//sTemp.append(myOutPutCheck("5",sMethod,"name='describe28'",getUnitData("describe28",sData),"��&nbsp;&nbsp;&nbsp;&nbsp;@��"));
	sTemp.append("      </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >�����</td>");
	sTemp.append("   <td  colspan='13' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe29' style='width:100%; height:30'",getUnitData("describe29",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >��֯����</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe30' style='width:100%; height:30'",getUnitData("describe30",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >ע���ʽ���Ԫ��</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe31' style='width:100%; height:30'",getUnitData("describe31",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append(" 		<td colspan='3' align=center class=td1 >���п�����</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe32' style='width:100%; height:30'",getUnitData("describe32",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append(" 		<td colspan='3' align=center class=td1 >�˺�</td>");
	sTemp.append("   <td  colspan='5' align=left class=td1  >");
	sTemp.append(myOutPut("2",sMethod,"name='describe33' style='width:100%; height:30'",getUnitData("describe33",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	
	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=center colspan=16 bgcolor=#aaaaaa height=30><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >���顢��顢�������</font></td> ");	
	sTemp.append("   </tr>");	
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����ͻ�����������</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ��:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >Э��ͻ��������</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ��:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����֧���г����</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ�֣����£�:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����֧�з��չ��������Ա���</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ��:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����֧�з��չ������������</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ��:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����֧������ִ�й����</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ�֣����£�:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>"); 
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >ֱ��֧�������Ա���</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ��:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >ֱ��֧���г����</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ�֣����£�:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����ҵ�������Ա���</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ��:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����ҵ���Ÿ��������</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ�֣����£�:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >�������Ź��������Ա���</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ��:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >�������Ź������������</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ�֣����£�:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >���зֹ��г����</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ�֣����£�:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>");
   	sTemp.append(" <tr height=80>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >�г����</td>");
    sTemp.append(" 		<td colspan='6' align=left class=td1 >"+""+"&nbsp;</td>");
    sTemp.append(" 		<td colspan='4' align=left class=td1 >ǩ�֣����£�:</td>");
    sTemp.append(" 		<td colspan='3' align=left class=td1 >����:</td>");
    sTemp.append(" </tr>");
    
	
    
    
	sTemp.append("</table>");
	sTemp.append("<br/><br/><br/><br/>");
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

