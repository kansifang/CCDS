package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateTrade6030 extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
	 	//�Զ���ô���Ĳ���ֵ ��ҵ����������ˮ�ţ�ί������ţ��̴������
		ASResultSet rs = null;
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sCommercialNo   = (String)this.getAttribute("CommercialNo");
		String sAccumulationNo   = (String)this.getAttribute("AccumulationNo");
		if(sObjectNo==null) sObjectNo="";
		if(sCommercialNo==null) sCommercialNo="";
		if(sAccumulationNo==null) sAccumulationNo="";
		//�������,����ί������ţ�������Ŀͻ���,�ͻ����
		String sApplyMFCustomerID="",sApplyCustomerID = "";
		String sSql = "";
		String sSql1 = "";
		String sMessage ="";
		String sMFCustomerID = ""; //�ͻ���
 		String sCertType = ""; //֤������
 		String sCertID = ""; //֤������
 		String sCustomerName = ""; //����
 		String sBusinessType = ""; //�̴�����ҵ������
 		String sBusinessCurrency = ""; //����
 		double dBusinessSum1 = 0.00; //�̴�������
 		double dBusinessSum2 = 0.00; //ί��������
 		int iTermMonth = 0;//�������ޣ��£�
 		int iTermDay = 0;//�������ޣ��죩
 		String sCorpusPayMethod = "";//���ʽ
 		String sPayCyc = ""; //������
 		String sPayDateType = "";//��������ȷ����ʽ
 		String sType1 = "";//�����˺�����
 		String sAccountNo = "";//�����˺�
 		String sInterestCType = "";//��Ϣ�����־
 		String sloanType = ""; //�ſʽ
 		String sType3 = "";//�����
 		String sType2 = "";//�����˺�����
 		String sLoanAccountNo = "";//�����˺�
 		double dRateFloat1 = 0.00; //�̴����ʸ�����
 		String sBaseRateType1 = "";//�̴���׼��������
 		double dRateFloat2 = 0.00; //ί�����ʸ�����
 		String sBaseRateType2 = "";//ί����׼��������
 		String sOverdueAddRate = ""; //���ڼӷ���
 		String sInputOrgID = ""; //������
 		String sOperateUserID = "";//������Ա
 		String sInputUserID = ""; //������Ա
 		String sdescribe1 = "";//���ݴ�������
 		
 		String sGDInputOrgID = "";//����а�����֧�л�������
 		String sGDSerialNo = "";//�������
 		String ssex = "";//������Ա�
 		String sRetireAge = "";//��������
 		String sRetireLoanType = "";//�������
 		String sIsLocalFlag = "";//����˻����Ƿ��ڱ���
 		String sEduDegree = "";//�Ļ��̶�
 		String sOccupation = "";//ְҵ
 		String sNativePlace = "";//�������ڵ���ϸ��ַ
 		String sFamilyAdd = "";//��ͥ��ַ
 		String sFamilyZIP = "";//��ͥ��������
 		String sFamilyTel = "";//��ͥ�绰
 		String sMobileTelephone = "";//������ֻ�����
 		String sWorkCorp = "";//������λ����
 		String sWorkAdd = "";//��λ��ַ
 		String sWorkZip = "";//��λ��������
 		String sWorkTel = "";//��λ�绰
 		String sCommAdd = "";//ͨѶ��ַ
 		String sConsortInstanceFlag = "";//�������ż���
 		String sConsortShareHouse = "";//��ż�Ƿ�Ϊ��ͬ������
 		String sConsortName = "";//��ż����
 		String sConsortCertID = "";//��ż���֤��
 		String sConsortOtherCertID = "";//��ż����֤������
 		String sConsortTel = "";//��ż�ֻ�����
 		String sConsortWorkCorp = "";//��ż������λ
 		String sConsortWorkAdd = "";//��ż��λ��ַ
 		String sConsortWorkZip = "";//��ż��λ�ʱ�
 		String sConsortWorkTel = "";//��ż��λ�绰
 		String sShareName1 = "";//������ͬ������1����
 		String sShareCertID1 = "";//������ͬ������1���֤��
 		String sShareConsortName1 = "";//������ͬ������1��ż����
 		String sShareConsortCertID1 = "";//������ͬ������1��ż���֤��
 		String sShareConsortSH1 = "";//������ͬ������1��ż�Ƿ�Ϊ��ͬ������
 		String sShareName2 = "";//������ͬ������2����
 		String sShareCertID2 = "";//������ͬ������2���֤��
 		String sShareConsortName2 = "";//������ͬ������2��ż����
 		String sShareConsortCertID2 = "";//������ͬ������2��ż���֤��
 		String sShareConsortSH2 = "";//������ͬ������2��ż�Ƿ�Ϊ��ͬ������
 		String sCreditSource1 = "";//������Ϣ��׼���ǿ�͸֧180���������
 		String sCreditSource2 = "";//������Ϣ�д��ǿ���ǰ��������
 		String sCreditSource3 = "";//������Ϣ�д��ǿ�12������δ������ͻ�������
 		String sCreditSource4 = "";//������Ϣ�е�ǰ���������ܶ�
 		String sCreditSource5 = "";//������Ϣ�б��´���Ӧ�����
 		String sCreditSource6 = "";//������Ϣ��24�����ڴ���������������
 		String sCreditSource7 = "";//������Ϣ��ס���������
 		String sCreditSource8 = "";//������Ϣ�����24���������⽻��
 		String sCreditSource9 = "";//������Ϣ���ر��¼
 		String sCreditSource10 = "";//������ۼ���������
 		String sCCreditSource1 = "";//�������ż������Ϣ��׼���ǿ�͸֧180���������
 		String sCCreditSource2 = "";//�������ż������Ϣ�д��ǿ���ǰ��������
 		String sCCreditSource3 = "";//�������ż������Ϣ�д��ǿ�12������δ������ͻ�������
 		String sCCreditSource4 = "";//�������ż������Ϣ�е�ǰ���������ܶ�
 		String sCCreditSource5 = "";//�������ż������Ϣ�б��´���Ӧ�����
 		String sCCreditSource6 = "";//�������ż������Ϣ��24�����ڴ���������������
 		String sCCreditSource7 = "";//�������ż������Ϣ��ס���������
 		String sCCreditSource8 = "";//�������ż������Ϣ�����24���������⽻��
 		String sCCreditSource9 = "";//�������ż������Ϣ����ʷ�ر��¼
 		String sCCreditSource10 = "";//�������ż�ۼ���������
 		String sBuyHouseUseType = "";//������޷���;����
 		String sBuyContractNo = "";//������ͬЭ����
 		String sHouseSeller = "";//������
 		String sSellOpenBank = "";//�����˿�����
 		String sSellAccountNo = "";//�������˺�
 		String sBuyItemName = "";//������Ŀ����
 		String sBuyHouseAdd1 = "";//�����޷���������
 		String sBuyHouseAdd2 = "";//�����޷���ϸ��ַ��(·����)
 		String sBuyHouseAdd3 = "";//��������ϸ��ַ��С�������ַ
 		String sBuyHouseAdd4 = "";//��������ϸ��ַ��¥��
 		String sBuyHouseAdd5 = "";//����Һ�(¥�ź����ݺŵ���'-'�ָ�)
 		double dBuildArea = 0.00;//�������
 		double dHousePrice = 0.00;//�����ۼ�
 		double dSelfPrice = 0.00;//�Գ��ʽ��
 		String sSelfAccounts = "";//�Գ�����ʺ�
 		double dRightRate = 0.00;//����˼�ͥ��ռ��Ȩ����
 		double dEvaluateValue = 0.00;//�����۸�
 		double dBudgetValue = 0.00;//���޷�Ԥ���ֵ
 		String sIsUseConsortPact = "";//�Ƿ�ʹ����ż���
 		String sTermUseType = "";//����������ȷ����ʽ
 		int iMostTermMonth=0;//���ȷ������������(��)
 		double dMostLoanValue = 0.00;//��ߣ�ȷ����ס�������������
 		double dTotalBusinessSum = 0.00;//������ϼ�
 		String sStartDate = "";//��������(������)
 		String sEndDate = "";//����ֹ��(������)
 		double dRiseFallRate = 0.00;//�ȶϢ������ݼ�����
 		double dMonthReturnSum = 0.00;//�»����
 		String sCreditUseInfo = "";//����˹��������ʹ�����
 		int iOverdueTerms = 0;//��������24������������������
 		String sUnusualRecord = "";//����˹���������Ƿ�����ر��¼
 		double dOverdueTermsSum = 0.00;//�����ס������������ۼ���������
 		String sUnusualDeal = "";//�����ס��������������24�������⽻�����
 		String sReCreditUseInfo = "";//��ż���������ʹ�����
 		int iReOverdueTerms = 0;//��ż�����24������������������
 		String sReUnusualRecord = "";//��ż����������Ƿ�����ر��¼
 		double dReOverdueTermsSum = 0.00;//��żס������������ۼ���������
 		String sReUnusualDeal = "";//��żס��������������24�������⽻�����
 		String sVouchType = "";//������ʽ
 		String sLoanHappenDate = "";//�����������
 		String sGuarantorID = "";//�����ͻ�ID
 		String sGuarantyCertType = "";//������֤������
 		String sGuarantLoanCardNo = "";//�����˴��翨
 		String sApplyInputUserID = "";//������
 		String sApplyBusinessType = "";//ҵ������ҵ��Ʒ��
 		String sChangType = "";//�������
 		
 		//Ϊ��ֹ�ظ������������ɾ����Ϣ
 		//ɾ��������Ϣ:
		Sqlca.executeSQL("delete from HOUSE_INFO where serialno in(select ObjectNo from apply_relative where ObjectType='HouseInfo' and SerialNo='"+sObjectNo+"')");
		Sqlca.executeSQL("delete from Apply_relative where ObjectType='HouseInfo' and SerialNo='"+sObjectNo+"'");
		//ɾ��������Ϣ:
		Sqlca.executeSQL("delete from GUARANTY_INFO where GuarantyId in(select guarantyID from GUARANTY_RELATIVE where ObjectType='CreditApply' and objectno='"+sObjectNo+"')");
		Sqlca.executeSQL("delete from GUARANTY_Contract where SerialNo in(select ContractNo from GUARANTY_RELATIVE where ObjectType='CreditApply' and objectno='"+sObjectNo+"')");
		Sqlca.executeSQL("delete from Apply_relative where ObjectType='GuarantyContract' and SerialNo='"+sObjectNo+"'");
		
		
		//���߲�����ȡ��Ҫ��ֵ
		//��ȡ�̴����������Ϣ
		sSql= " select getMFCustomerID(CustomerID) as MFCustomerID,CustomerID,InputUserID,BusinessType from BUSINESS_APPLY"+
			  " where SerialNo = '"+sObjectNo+"'";
		rs = Sqlca.getResultSet(sSql);
	    if(rs.next())
	    {
	    	sApplyMFCustomerID = rs.getString("MFCustomerID");
	    	sApplyCustomerID = rs.getString("CustomerID");
	    	sApplyInputUserID = rs.getString("InputUserID");
	    	sApplyBusinessType = rs.getString("BusinessType");
	    }
	    rs.getStatement().close();
	    
 		//��ȡ����������м��������Ϣ
		sSql = " select MFCustomerID,getFromGDCode('CertType',CertType,'Ind11') as CertType,CertID," +
			"CustomerName,BusinessType,getFromGDCode('Currency',BusinessCurrency,'01') as BusinessCurrency" +
			",BusinessSum1,BusinessSum2," +
			"TermMonth,TermDay,getFromGDCode('CorpusPayMethod2',CorpusPayMethod,'') as CorpusPayMethod," +
			"getFromGDCode('GDPayCyc',PayCyc,'') as PayCyc,PayDateType," +
			"getFromGDCode('GDAccountType',Type1,'') as Type1,AccountNo,InterestCType,loanType," +
			"getFromGDCode('GDPayDirection',Type3,'') as Type3," +
			"getFromGDCode('GDAccountType',Type2,'') as Type2,LoanAccountNo,RateFloat1," +
			"getFromGDCode('BaseRateType',BaseRateType1,'') as BaseRateType1,RateFloat2," +
			"getFromGDCode('BaseRateType',BaseRateType2,'') as BaseRateType2,OverdueAddRate," +
			"InputOrgID,OperateUserID,InputUserID, "+
			
			"GDInputOrgID,GDSerialNo,getFromGDCode('Sex',sex,'') as sex,RetireAge,"+
			"getFromGDCode('RetireLoanType',RetireLoanType,'') as RetireLoanType," +
			"getFromGDCode('YesNo',IsLocalFlag,'') as IsLocalFlag," +
			"getFromGDCode('EducationExperience',EduDegree,'') as EduDegree,getFromGDCode('Occupation',Occupation,'0') as Occupation,NativePlace," +
			"FamilyAdd,FamilyZIP,FamilyTel,MobileTelephone,WorkCorp," +
			"WorkAdd,WorkZip,WorkTel,getFromGDCode('CommAddFlag',CommAdd,'') as CommAdd,ConsortInstanceFlag," +
			"getFromGDCode('YesNo',ConsortShareHouse,'') as ConsortShareHouse," +
			"ConsortName,ConsortCertID,ConsortOtherCertID," +
			"ConsortTel,ConsortWorkCorp,ConsortWorkAdd,ConsortWorkZip,ConsortWorkTel," +
			"ShareName1,ShareCertID1,ShareConsortName1,ShareConsortCertID1," +
			"getFromGDCode('YesNo',ShareConsortSH1,'') as ShareConsortSH1,ShareName2,ShareCertID2,ShareConsortName2,ShareConsortCertID2," +
			"getFromGDCode('YesNo',ShareConsortSH2,'') as ShareConsortSH2,CreditSource1,CreditSource2,CreditSource3,CreditSource4," +
			"CreditSource5,CreditSource6,CreditSource7,CreditSource8,CreditSource9," +
			"CreditSource10,CCreditSource1,CCreditSource2,CCreditSource3,CCreditSource4," +
			"CCreditSource5,CCreditSource6,CCreditSource7,CCreditSource8,CCreditSource9," +
			"CCreditSource10,getFromGDCode('HouseUseType',BuyHouseUseType,'') as BuyHouseUseType," +
			"BuyContractNo,HouseSeller,SellOpenBank," +
			"SellAccountNo,BuyItemName," +
			"getFromGDCode('AreaCode',BuyHouseAdd1,'') as BuyHouseAdd1,BuyHouseAdd2,BuyHouseAdd3," +
			"BuyHouseAdd4,BuyHouseAdd5,BuildArea,HousePrice,SelfPrice,SelfAccounts," +
			"RightRate ,EvaluateValue,BudgetValue," +
			"getFromGDCode('YesNo',IsUseConsortPact,'') as IsUseConsortPact," +
			"getFromGDCode('TermUseType',TermUseType,'') as TermUseType," +
			"MostTermMonth,MostLoanValue,TotalBusinessSum,StartDate,EndDate," +
			"RiseFallRate,MonthReturnSum," +
			"getFromGDCode('CreditUseInfo',CreditUseInfo,'') as CreditUseInfo,OverdueTerms," +
			"getFromGDCode('UnusualRecord',UnusualRecord,'') as UnusualRecord," +
			"OverdueTermsSum," +
			"getFromGDCode('UnusualDeal',UnusualDeal,'') as UnusualDeal," +
			"getFromGDCode('CreditUseInfo',ReCreditUseInfo,'') as ReCreditUseInfo,ReOverdueTerms," +
			"getFromGDCode('UnusualRecord',ReUnusualRecord,'') as ReUnusualRecord," +
			"ReOverdueTermsSum," +
			"getFromGDCode('UnusualDeal',ReUnusualDeal,'') as ReUnusualDeal," +
			"VouchType,LoanHappenDate,ChangType "+
			" from GD_BUSINESSAPPLY"+
			" where CommercialNo = '"+sCommercialNo+"' and AccumulationNo='"+sAccumulationNo+"'";
		rs = Sqlca.getResultSet(sSql);
	    if(rs.next())
	    {
	    	sMFCustomerID    = rs.getString("MFCustomerID");
	    	sCertType        = rs.getString("CertType");
	    	sCertID          = rs.getString("CertID");
	    	sCustomerName    = rs.getString("CustomerName");
	    	sBusinessType    = rs.getString("BusinessType");
	    	if(sBusinessType.equals("102")||sBusinessType.equals("106"))
			{
	    		sBusinessType = "1110010";
	    		sdescribe1 = "01";
			}else if(sBusinessType.equals("104")||sBusinessType.equals("113"))
			{
				sBusinessType = "1110020";
				sdescribe1 = "02";	
			}
	    	sBusinessCurrency= rs.getString("BusinessCurrency");
	    	dBusinessSum1    = rs.getDouble("BusinessSum1");
	    	dBusinessSum2    = rs.getDouble("BusinessSum2");
	    	iTermMonth       = rs.getInt("TermMonth");
	    	iTermDay         = rs.getInt("TermDay");
	    	sCorpusPayMethod = rs.getString("CorpusPayMethod");
	    	sPayCyc          = rs.getString("PayCyc");
	    	sPayDateType     = rs.getString("PayDateType");
	    	sType1           = rs.getString("Type1");
	    	sAccountNo       = rs.getString("AccountNo");
	    	sInterestCType   = rs.getString("InterestCType");
	    	sloanType        = rs.getString("loanType");
	    	sType3           = rs.getString("Type3");
	    	sType2           = rs.getString("Type2");
	    	sLoanAccountNo   = rs.getString("LoanAccountNo");
	    	dRateFloat1      = rs.getDouble("RateFloat1");
	    	sBaseRateType1   = rs.getString("BaseRateType1");
	    	dRateFloat2      = rs.getDouble("RateFloat2");
	    	sBaseRateType2   = rs.getString("BaseRateType2");
	    	sOverdueAddRate  = rs.getString("OverdueAddRate");
	    	sInputOrgID      = rs.getString("InputOrgID");
	    	sOperateUserID   = rs.getString("OperateUserID");
	    	sInputUserID     = rs.getString("InputUserID");
	    	
	    	
	    	sGDInputOrgID			=rs.getString("GDInputOrgID");
	    	sGDSerialNo             =rs.getString("GDSerialNo");
	    	ssex                    =rs.getString("sex");
	    	sRetireAge              =rs.getString("RetireAge");
	    	sRetireLoanType         =rs.getString("RetireLoanType");
	    	sIsLocalFlag            =rs.getString("IsLocalFlag");
	    	sEduDegree              =rs.getString("EduDegree");
	    	sOccupation             =rs.getString("Occupation");
	    	sNativePlace            =rs.getString("NativePlace");
	    	sFamilyAdd              =rs.getString("FamilyAdd");
	    	sFamilyZIP              =rs.getString("FamilyZIP");
	    	sFamilyTel              =rs.getString("FamilyTel");
	    	sMobileTelephone        =rs.getString("MobileTelephone");
	    	sWorkCorp               =rs.getString("WorkCorp");
	    	sWorkAdd                =rs.getString("WorkAdd");
	    	sWorkZip                =rs.getString("WorkZip");
	    	sWorkTel                =rs.getString("WorkTel");
	    	sCommAdd                =rs.getString("CommAdd");
	    	sConsortInstanceFlag    =rs.getString("ConsortInstanceFlag");
	    	sConsortShareHouse      =rs.getString("ConsortShareHouse");
	    	sConsortName            =rs.getString("ConsortName");
	    	sConsortCertID          =rs.getString("ConsortCertID");
	    	sConsortOtherCertID     =rs.getString("ConsortOtherCertID");
	    	sConsortTel             =rs.getString("ConsortTel");
	    	sConsortWorkCorp        =rs.getString("ConsortWorkCorp");
	    	sConsortWorkAdd         =rs.getString("ConsortWorkAdd");
	    	sConsortWorkZip         =rs.getString("ConsortWorkZip");
	    	sConsortWorkTel         =rs.getString("ConsortWorkTel");
	    	sShareName1             =rs.getString("ShareName1");
	    	sShareCertID1           =rs.getString("ShareCertID1");
	    	sShareConsortName1      =rs.getString("ShareConsortName1");
	    	sShareConsortCertID1    =rs.getString("ShareConsortCertID1");
	    	sShareConsortSH1        =rs.getString("ShareConsortSH1");
	    	sShareName2             =rs.getString("ShareName2");
	    	sShareCertID2           =rs.getString("ShareCertID2");
	    	sShareConsortName2      =rs.getString("ShareConsortName2");
	    	sShareConsortCertID2    =rs.getString("ShareConsortCertID2");
	    	sShareConsortSH2        =rs.getString("ShareConsortSH2");
	    	sCreditSource1          =rs.getString("CreditSource1");
	    	sCreditSource2          =rs.getString("CreditSource2");
	    	sCreditSource3          =rs.getString("CreditSource3");
	    	sCreditSource4          =rs.getString("CreditSource4");
	    	sCreditSource5          =rs.getString("CreditSource5");
	    	sCreditSource6          =rs.getString("CreditSource6");
	    	sCreditSource7          =rs.getString("CreditSource7");
	    	sCreditSource8          =rs.getString("CreditSource8");
	    	sCreditSource9          =rs.getString("CreditSource9");
	    	sCreditSource10         =rs.getString("CreditSource10");
	    	sCCreditSource1         =rs.getString("CCreditSource1");
	    	sCCreditSource2         =rs.getString("CCreditSource2");
	    	sCCreditSource3         =rs.getString("CCreditSource3");
	    	sCCreditSource4         =rs.getString("CCreditSource4");
	    	sCCreditSource5         =rs.getString("CCreditSource5");
	    	sCCreditSource6         =rs.getString("CCreditSource6");
	    	sCCreditSource7         =rs.getString("CCreditSource7");
	    	sCCreditSource8         =rs.getString("CCreditSource8");
	    	sCCreditSource9         =rs.getString("CCreditSource9");
	    	sCCreditSource10        =rs.getString("CCreditSource10");
	    	sBuyHouseUseType        =rs.getString("BuyHouseUseType");
	    	sBuyContractNo          =rs.getString("BuyContractNo");
	    	sHouseSeller            =rs.getString("HouseSeller");
	    	sSellOpenBank           =rs.getString("SellOpenBank");
	    	sSellAccountNo          =rs.getString("SellAccountNo");
	    	sBuyItemName            =rs.getString("BuyItemName");
	    	sBuyHouseAdd1           =rs.getString("BuyHouseAdd1");
	    	sBuyHouseAdd2           =rs.getString("BuyHouseAdd2");
	    	sBuyHouseAdd3           =rs.getString("BuyHouseAdd3");
	    	sBuyHouseAdd4           =rs.getString("BuyHouseAdd4");
	    	sBuyHouseAdd5           =rs.getString("BuyHouseAdd5");
	    	dBuildArea              =rs.getDouble("BuildArea")/10000.00;
	    	dHousePrice             =rs.getDouble("HousePrice")/10000.00;
	    	dSelfPrice              =rs.getDouble("SelfPrice")/10000.00;
	    	sSelfAccounts           =rs.getString("SelfAccounts");
	    	dRightRate              =rs.getDouble("RightRate")/10000.00;
	    	dEvaluateValue          =rs.getDouble("EvaluateValue")/10000.00;
	    	dBudgetValue            =rs.getDouble("BudgetValue")/10000.00;
	    	sIsUseConsortPact       =rs.getString("IsUseConsortPact");
	    	sTermUseType            =rs.getString("TermUseType");
	    	iMostTermMonth          =Integer.parseInt(rs.getString("MostTermMonth").equals("")?"0":rs.getString("MostTermMonth"))/10000;
	    	dMostLoanValue          =rs.getDouble("MostLoanValue")/10000.00;
	    	dTotalBusinessSum       =rs.getDouble("TotalBusinessSum")/10000.00;
	    	sStartDate              =rs.getString("StartDate");
	    	sEndDate                =rs.getString("EndDate");
	    	dRiseFallRate           =Double.parseDouble(rs.getString("RiseFallRate").equals("")?"0":rs.getString("RiseFallRate"))/10000.00;
	    	dMonthReturnSum         =rs.getDouble("MonthReturnSum")/10000.00;
	    	sCreditUseInfo          =rs.getString("CreditUseInfo");
	    	iOverdueTerms           =rs.getInt("OverdueTerms")/10000;
	    	sUnusualRecord          =rs.getString("UnusualRecord");
	    	dOverdueTermsSum        =rs.getDouble("OverdueTermsSum")/10000.00;
	    	sUnusualDeal            =rs.getString("UnusualDeal");
	    	sReCreditUseInfo        =rs.getString("ReCreditUseInfo");
	    	iReOverdueTerms         =rs.getInt("ReOverdueTerms")/10000;
	    	sReUnusualRecord        =rs.getString("ReUnusualRecord");
	    	dReOverdueTermsSum      =rs.getDouble("ReOverdueTermsSum")/10000.00;
	    	sReUnusualDeal          =rs.getString("ReUnusualDeal");
	    	sVouchType              =rs.getString("VouchType");
	    	sChangType				=rs.getString("ChangType");
	    	if("1".equals(sVouchType))
	    	{
	    		sVouchType = "020";
	    	}else if("2".equals(sVouchType))
	    	{
	    		sVouchType = "040";
	    	}else if("3".equals(sVouchType))
	    	{
	    		sVouchType = "010";
	    	}else{
	    		sVouchType = "005";
	    	}
	    	sLoanHappenDate         =rs.getString("LoanHappenDate");
	    	if(sLoanHappenDate.length()>=8)
	    	{
	    		sLoanHappenDate = sLoanHappenDate.substring(0,4)+"/"+sLoanHappenDate.substring(4,6)+"/"+sLoanHappenDate.substring(6,8);
	    	}else{
	    		sLoanHappenDate="";
	    	}
	    	
	    }
	    rs.getStatement().close();
	    if("".equals(sApplyMFCustomerID))
	    {
	    	sMessage="���Ȼ�ȡ���Ŀͻ��ţ�";
	    	return sMessage;
	    }else if(!sMFCustomerID.equals(sApplyMFCustomerID))
	    {
	    	sMessage="������ͻ��빫����ϵͳ�ͻ���һ�£�����������!";
	    	return sMessage;
	    }
	    //�����̴�������Ϣ
	    sSql=" update BUSINESS_APPLY set " +
	    			//" BusinessType='"+sBusinessType+"',"+
					" describe1='"+sdescribe1+"',"+
			        " BusinessCurrency='"+sBusinessCurrency+"',"+
			        " BusinessSum="+("1110027".equals(sApplyBusinessType)?dBusinessSum1:dBusinessSum2)+","+
			        " TermMonth="+iTermMonth+","+
			        " TermDay="+iTermDay+","+
			        " CorpusPayMethod='"+sCorpusPayMethod+"',"+
			        " RateFloatType='0',"+
			        " RateFloat="+dRateFloat1+","+
			        " BaseRateType='"+sBaseRateType1+"', "+
			        
			        " PayCyc='"+sCorpusPayMethod+"',"+
			        " EquipmentSum="+dBusinessSum1+", "+
			        " InvoiceSum="+dBusinessSum2+", "+
			        " GDSerialNo='"+sGDSerialNo+"', "+
			        " RetireLoanType='"+sRetireLoanType+"', "+
			        " IsUseConsortPact='"+sIsUseConsortPact+"', "+
			        " TermUseType='"+sTermUseType+"', "+
			        " MostTermMonth="+iMostTermMonth+", "+
			        " MostLoanValue="+dMostLoanValue+", "+
			        " TotalBusinessSum="+dTotalBusinessSum+", "+
			        " RiseFallRate="+dRiseFallRate+", "+
			        " MonthReturnSum="+dMonthReturnSum+", "+
			        " CreditUseInfo='"+sCreditUseInfo+"', "+
			        " OverdueTerms="+iOverdueTerms+", "+
			        " UnusualRecord='"+sUnusualRecord+"', "+
			        //" StartDate='"+sStartDate+"', "+
			        //" EndDate='"+sEndDate+"', "+
			        " OverdueTermsSum="+dOverdueTermsSum+", "+
			        " UnusualDeal='"+sUnusualDeal+"', "+
			        " ReCreditUseInfo='"+sReCreditUseInfo+"', "+
			        " ReOverdueTerms="+iReOverdueTerms+", "+
			        " ReUnusualRecord='"+sReUnusualRecord+"', "+
			        " ReOverdueTermsSum="+dReOverdueTermsSum+", "+
			        " ReUnusualDeal='"+sReUnusualDeal+"', "+
			        " VouchType='"+sVouchType+"',  "+
			        " OccurDate='"+sLoanHappenDate+"', "+
			        " ChangType='"+sChangType+"' "+
			   "where SerialNo='"+sObjectNo+"'";
	    Sqlca.executeSQL(sSql);

	    //���¿ͻ���Ϣ:CustomerID
	    sSql=" update IND_INFO set " +
			" sex ='"+ssex+"',"+
			" RetiringAge='"+sRetireAge+"',"+
	        " IsLocalFlag='"+sIsLocalFlag+"',"+
	        " EduDegree='"+sEduDegree+"',"+
	        " Occupation='"+sOccupation+"',"+
	        " NativePlace='"+sNativePlace+"',"+
	        " FamilyAdd='"+sFamilyAdd+"',"+
	        " FamilyTel='"+sFamilyTel+"',"+
	        " FamilyZIP='"+sFamilyZIP+"',"+
	        " MobileTelephone='"+sMobileTelephone+"',"+
	        " WorkCorp='"+sWorkCorp+"',"+
	        " WorkAdd='"+sWorkAdd+"',"+
	        " WorkZip='"+sWorkZip+"',"+
	        " WorkTel='"+sWorkTel+"',"+
	        " CommAdd='"+sCommAdd+"',"+
	       // " ConsortInstanceFlag='"+sConsortInstanceFlag+"',"+
	        " ConsortSHFLag='"+sConsortShareHouse+"' "+
        "where CustomerID='"+sApplyCustomerID+"'";
	    Sqlca.executeSQL(sSql);
	    
	    //������ż��Ϣ �Ƿ�����
	    sSql=" update CUSTOMER_RELATIVE set " +
	        " Describe='"+sConsortWorkCorp+"',"+
	        " WorkAdd='"+sConsortWorkAdd+"',"+
	        " WorkZip='"+sConsortWorkZip+"',"+
	        " WorkTel='"+sConsortWorkTel+"'"+
        "where CertType='Ind01' and CertID ='"+sConsortCertID+"'";
	    Sqlca.executeSQL(sSql);
	    // ���빺����Ϣ
	    String sHISerialNo1 = DBFunction.getSerialNo("HOUSE_INFO","SerialNo","",Sqlca);
	    sSql = "insert into HOUSE_INFO " +
	    		"(SerialNO,HouseUseType,ShareName1,ShareCertID1,ShareConsortName1,ShareConsortCertID1," +
	    		"ShareConsortSH1,ShareName2,ShareCertID2,ShareConsortName2," +
	    		"ShareConsortCertID2,ShareConsortSH2,HouseContractNo,HouseSeller," +
	    		"SellOpenBank,SellAccountNo,ItemName,HouseAdd1," +
	    		"HouseAdd2,HouseAdd3,HouseAdd4,HouseAdd5,BuildArea," +
	    		"HousePrice,SelfPrice,SelfAccounts,RightRate,EvaluateValue,BudgetValue)"+
	    		"values("+
	    		"'"+sHISerialNo1+"',"+
	    		"'"+sBuyHouseUseType+"',"+
	    		"'"+sShareName1+"',"+
	    		"'"+sShareCertID1+"',"+
	    		"'"+sShareConsortName1+"',"+
	    		"'"+sShareConsortCertID1+"',"+
	    		"'"+sShareConsortSH1+"',"+
	    		"'"+sShareName2+"',"+
	    		"'"+sShareCertID2+"',"+
	    		"'"+sShareConsortName2+"',"+
	    		"'"+sShareConsortCertID2+"',"+
	    		"'"+sShareConsortSH2+"',"+
	    		"'"+sBuyContractNo+"',"+
	    		"'"+sHouseSeller+"',"+
	    		"'"+sSellOpenBank+"',"+
	    		"'"+sSellAccountNo+"',"+
	    		"'"+sBuyItemName+"',"+
	    		"'"+sBuyHouseAdd1+"',"+
	    		"'"+sBuyHouseAdd2+"',"+
	    		"'"+sBuyHouseAdd3+"',"+
	    		"'"+sBuyHouseAdd4+"',"+
	    		"'"+sBuyHouseAdd5+"',"+
	    		""+dBuildArea+","+
	    		""+dHousePrice+","+
	    		""+dSelfPrice+","+
	    		"'"+sSelfAccounts+"',"+
	    		""+dRightRate+","+
	    		""+dEvaluateValue+","+
	    		""+dBudgetValue+" "+
	    		")";
	    Sqlca.executeSQL(sSql);
	    
	    //�������������Ϣ
	    sSql = "insert into apply_relative " +
			"(SerialNO,ObjectType,ObjectNo)values('"+sObjectNo+"','HouseInfo','"+sHISerialNo1+"')";
	    Sqlca.executeSQL(sSql);
	    //���뵣����ͬ��Ϣ       1.��Ѻ��2.��Ѻ��3.��֤
	    String sFlag2 = "", sSql4 = "";
	    String wSerialNo = Sqlca.getString("select serialno from business_apply where serialno <> '"+sObjectNo+"' and CommercialNo = '"+sCommercialNo+"' and AccumulationNo='"+sAccumulationNo+"' ");
	    
	    sSql1 = " select SEQUENCENUMBER,OWNERNAME,CERTTYPE,CERTID,GUARANTYTYPE,GUARANTYNAME,EVALCURRENCY,GUARANTYRIGHTID," +
	    		" LOSTDATE,ABOUTSUM1,ABOUTSUM2,GUARANTYRATE,GUARANTYLOCATION,INPUTUSERID,INPUTDATE,GARANTYTYPE,EVALDATE," +
	    		" EVALORGNAME,POLICYHOLDFLAG,BENEFITPERSON1,INSURANCEID,INSURANCEBEGINDATE,INSURANCEENDDATE,CONFIRMVALUE," +
	    		" OTHERGUARANTYRIGHT,QUALITYSTATUS,GUARANTYAMOUNT,GUARANTYUSING,INPUTDEPARTMENT,ASSUREAGREEMENTFLAG," +
	    		" ASSURERTYPE,GUARANTYVALUE,BEGINDATE,ENDDATE,INPUTORGID,EMERGEDATE,CUSTOMERNAME,GUARANTYCONTRACTNO," +
	    		" MFCUSTOMERID,GUARANTYINFOFLAG,"+
	    		" GuarantyRightID1,ShareCustomerName,ShareCertID,ShareConsortName," +
	    		" ShareConsortCertID,ShareAddress,SharePostalCode,SharePhone "+
	    		" from gd_guarantyinfo " +
	    		" where CommercialNo = '"+sCommercialNo+"' and AccumulationNo='"+sAccumulationNo+"' ";
	    rs = Sqlca.getASResultSet(sSql1);
	    while(rs.next())
	    {
	    	String sGuarantyType = rs.getString("GUARANTYTYPE");
	    	if("1".equals(sGuarantyType))
	    	{
	    		sFlag2 = "1";
	    	}else if("2".equals(sGuarantyType))
	    	{
	    		sFlag2 = "2";
	    	}
	    	String sGuarantyInfoFlag = rs.getString("GUARANTYINFOFLAG");
	    	//��ȡ�����˶�Ӧ�Ŵ��ͻ����
	    	if("3".equals(sGuarantyInfoFlag))//��֤
	    	{
	    		sGuarantyCertType=rs.getString("CERTTYPE");
	    		if("0".equals(sGuarantyCertType))
	    		{
	    			sGuarantyCertType="Ent01";
	    		}else if("2".equals(sGuarantyCertType))
	    		{
	    			sGuarantyCertType="Ind01";
	    		}
	    	}else
	    	{
	    		sGuarantyCertType=getCertType(rs.getString("CERTTYPE"));
	    	}
	    	sGuarantorID = Sqlca.getString("select CustomerID from CUSTOMER_INFO" +
	    	 		" where CertID='"+rs.getString("CERTID")+"' and CertType='"+sGuarantyCertType+"' ");
	 	    if(sGuarantorID == null) sGuarantorID = "";
	 	    sGuarantLoanCardNo = Sqlca.getString("select LoanCardNo from CUSTOMER_INFO" +
	    	 		" where CertID='"+rs.getString("CERTID")+"' and CertType='"+sGuarantyCertType+"' ");
	 	    if(sGuarantLoanCardNo == null) sGuarantLoanCardNo = "";
	 	    
	    	if("1".equals(sGuarantyInfoFlag))    //��Ѻ
	    	{
	    		String sSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo","GC",Sqlca);
	    		String sSql2 = "insert into GUARANTY_CONTRACT " +
		    				" (LoanCardNo,InputUserID,UpdateDate,CustomerID,CertType,InputOrgID," +
		    				" GuarantyType,GuarantorName,SerialNo,InputDate,GuarantorID,GuarantyValue," +
		    				" ContractType,CertID,ContractStatus,GuarantyCurrency,SignDate,BeginDate,EndDate) " +
		    				" values ('"+sGuarantLoanCardNo+"','"+sApplyInputUserID+"','','"+sApplyCustomerID+"'," +  //�ͻ����
		    				"'"+sGuarantyCertType+"','','060','"+rs.getString("OWNERNAME")+"'," +
		    				"'"+sSerialNo1+"','"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"','"+sGuarantorID+"'," +  //�����˱��
		    				""+rs.getDouble("ABOUTSUM1")+",'010','"+rs.getString("CERTID")+"','010','"+rs.getString("EVALCURRENCY")+"'," +
		    				"''," +
		    				"''," +
		    				"'')";
	    		Sqlca.executeSQL(sSql2);
	    		String sSql3 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+sObjectNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql3);
	    		String sSql8 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+wSerialNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql8);
	    		String sSerialNo2 = DBFunction.getSerialNo("GUARANTY_INFO","GuarantyID","GI",Sqlca);
	    		if("1".equals(sGuarantyType) || "2".equals(sGuarantyType))
	    		{
	    			sSql4 = "insert into GUARANTY_INFO (InputOrgID,OwnerType,GuarantyLocation,GuarantyCurrency," +
		    				"GuarantyID,OwnerID,AboutSum1,InputDate,OwnerTime,GuarantyRate,LoanCardNo,GuarantyStatus," +
		    				"EvalNetValue,CertID,ThirdParty1,BeginDate,ConfirmValue,GuarantyType,InputUserID,OwnerName," +
		    				"Flag2,UpdateDate,EvalCurrency,GuarantyOwnWay,CertType,GuarantyRightID,GuarantyDescribe3)" +
		    				" values ('','','"+("2".equals(sFlag2)?rs.getString("GUARANTYLOCATION"):"")+"','01','"+sSerialNo2+"','',"+rs.getDouble("ABOUTSUM1")+"," +
		    				"'"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"','',"+rs.getDouble("GUARANTYRATE")+"," +
		    				"'','01',"+rs.getDouble("ABOUTSUM1")+",'"+rs.getString("CERTID")+"','','"+"'," +
		    				""+rs.getDouble("ABOUTSUM1")*rs.getDouble("GUARANTYRATE")/100+",'020010'," +
		    				"'"+sApplyInputUserID+"','"+rs.getString("OWNERNAME")+"'," +
		    				"'"+sFlag2+"','','01','','"+sGuarantyCertType+"','"+rs.getString("GUARANTYRIGHTID")+"','"+("1".equals(sFlag2)?rs.getString("GuarantyLocation"):"")+"')";
	    		}else if("0".equals(sGuarantyType))
	    		{
	    			sSql4 = "insert into GUARANTY_INFO (InputDate,OwnerType,GuarantyDate,GuarantyCurrency," +
		    				"GuarantyID,OwnerID,GuarantyRate,LoanCardNo,AboutSum1,GuarantyStatus," +
		    				"EvalNetValue,InputUserID,CertID,GuarantyRightID,UpdateDate,BeginDate,ConfirmValue," +
		    				"GuarantyType,InputOrgID,OwnerName,ThirdParty2,EvalCurrency,Remark,CertType,GuarantyName) values (" +
		    				"'"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"','',''," +
		    				"'01','"+sSerialNo2+"','',"+rs.getDouble("GUARANTYRATE")+",'',"+rs.getDouble("ABOUTSUM1")+"," +
		    				"'01',"+rs.getDouble("ABOUTSUM1")+",'"+sApplyInputUserID+"'," +
		    				"'"+rs.getString("CERTID")+"','"+rs.getString("GUARANTYRIGHTID")+"','',''," +
		    				""+rs.getDouble("ABOUTSUM1")*rs.getDouble("GUARANTYRATE")/100+",'020040',''," +
		    				"'"+rs.getString("OWNERNAME")+"','"+rs.getString("EVALCURRENCY")+"','"+rs.getString("EVALCURRENCY")+"'," +
		    				"'','"+sGuarantyCertType+"','"+rs.getString("GUARANTYNAME")+"')";
	    		}else if("3".equals(sGuarantyType))
	    		{
	    			sSql4 = "into GUARANTY_INFO (InputDate,OwnerType,BeginDate,GuarantyRate,GuarantyID,OwnerID,ThirdParty2," +
		    				"ConfirmValue,LoanCardNo,GuarantyDate,GuarantyStatus,EvalNetValue,InputUserID,CertID,GuarantyName," +
		    				"UpdateDate,GuarantyCurrency,GuarantyType,InputOrgID,OwnerName,AboutSum1,EvalCurrency,Remark," +
		    				"CertType,GuarantyRightID) values (" +
		    				"'"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"','',''," +
		    				""+rs.getDouble("GUARANTYRATE")+",'"+sSerialNo2+"','','"+rs.getString("EVALCURRENCY")+"'," +
		    				""+rs.getDouble("ABOUTSUM1")*rs.getDouble("GUARANTYRATE")/100+",'','2010/12/20','01',"+rs.getDouble("ABOUTSUM1")+"," +
		    				"'"+sApplyInputUserID+"','"+rs.getString("CERTID")+"','"+rs.getString("+GUARANTYNAME+")+"'," +
		    				"'','"+rs.getString("EVALCURRENCY")+"','020210','','"+rs.getString("OWNERNAME")+"'," +
		    				""+rs.getDouble("ABOUTSUM1")+",'"+rs.getString("EVALCURRENCY")+"','','"+sGuarantyCertType+"','"+rs.getString("GUARANTYRIGHTID")+"')";
	    		}
	    		Sqlca.executeSQL(sSql4);
	    		Sqlca.executeSQL("insert into GUARANTY_RELATIVE(objecttype,objectno,contractno,guarantyid,channel,status,type) values('CreditApply','"+sObjectNo+"','"+sSerialNo1+"','"+sSerialNo2+"','New','1','Add')");
	    	}else if("2".equals(sGuarantyInfoFlag))  //��Ѻ
	    	{
	    		String sSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo","GC",Sqlca);
	    		String sSql2 = "insert into GUARANTY_CONTRACT (LoanCardNo,InputUserID,UpdateDate,CustomerID," +
	    				" CertType,InputOrgID,GuarantyType,GuarantorName,SerialNo,InputDate,GuarantorID," +
	    				" GuarantyValue,ContractType,CertID,ContractStatus,GuarantyCurrency,SignDate,BeginDate,EndDate) values " +
	    				" ('"+sGuarantLoanCardNo+"','"+sApplyInputUserID+"'," +
	    				"'','"+sApplyCustomerID+"'," +
	    				"'"+sGuarantyCertType+"'," +
	    				"'','050','"+rs.getString("OWNERNAME")+"'," +
	    				"'"+sSerialNo1+"'," +
	    				"'"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"'," +
	    				"'"+sGuarantorID+"',"+rs.getDouble("ABOUTSUM1")+",'020','"+rs.getString("CERTID")+"','010','"+rs.getString("EVALCURRENCY")+"'," +
	    				"'"+StringFunction.replace(rs.getString("BEGINDATE"), "-", "/")+"'," +
	    				"'"+StringFunction.replace(rs.getString("BEGINDATE"), "-", "/")+"'," +
	    				"'"+StringFunction.replace(rs.getString("ENDDATE"), "-", "/")+"')";
	    		Sqlca.executeSQL(sSql2);
	    		String sSql3 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+sObjectNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql3);
	    		String sSql8 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+wSerialNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql8);
	    		String sSerialNo2 = DBFunction.getSerialNo("GUARANTY_INFO","GuarantyID","GI",Sqlca);
	    		String sSql7 = "insert into GUARANTY_INFO (GuarantyID,GuarantyLocation,GuarantyCurrency,LoanCardNo,HouseOwnerType," +
	    				"HoldType,InputOrgID,EvalOrgName,CertType,GuarantyDescribe1,GuarantyRate,GuarantyStatus,GuarantySubType," +
	    				"EvalNetValue,OwnerName,GuarantyAmount2,EvalMethod,AboutOtherID1,AboutSum2,OwnerTime,UpdateDate," +
	    				"GuarantyRightID,EvalCurrency,OwnerID,GuarantyDescribe3,InputUserID,GuarantyDescript," +
	    				"GuarantyType,GuarantyAmount,ConfirmValue,ThirdParty1,OwnerType,InputDate,EvalDate,CertID,GuarantyDescribe2," +
	    				"AboutOtherID2," +
	    				//"GuarantyRightID1," +
	    				"ShareCustomerName,ShareCertID,ShareConsortName,ShareConsortCertID," +
	    				"ShareAddress,SharePostalCode,SharePhone ) values " +
	    				"('"+sSerialNo2+"','"+rs.getString("GUARANTYLOCATION")+"'," +
	    				"'01','',''," +
	    				"'','','"+rs.getString("EVALORGNAME")+"','"+sGuarantyCertType+"'," +
	    				"''," +
	    				""+rs.getDouble("GUARANTYRATE")+",'01'," +
	    				"'',100000,'"+rs.getString("OWNERNAME")+"',"
	    				+Double.parseDouble(rs.getString("GUARANTYAMOUNT").equals("")?"0":rs.getString("GUARANTYAMOUNT"))/10000.00
	    				+",'01'," +
	    				"'',"+rs.getDouble("CONFIRMVALUE")*rs.getDouble("GUARANTYRATE")/100+"," +
	    				"'','','"+rs.getString("GUARANTYRIGHTID")+"','01'," +
	    				"'',''," +
	    				"'"+sApplyInputUserID+"',''," +
	    				"'010010',"
	    				+Double.parseDouble(rs.getString("GUARANTYAMOUNT").equals("")?"0":rs.getString("GUARANTYAMOUNT"))/10000.00
	    				+","
	    				+Double.parseDouble(rs.getString("CONFIRMVALUE").equals("")?"0":rs.getString("CONFIRMVALUE"))/10000.00
	    				+",'','','"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"'," +
	    				"'"+StringFunction.replace(rs.getString("EVALDATE"), "-", "/")+"','"+rs.getString("CERTID")+"','',''," +
	    				//"'"+rs.getString("GuarantyRightID1")+"',"+
	    				"'"+rs.getString("ShareCustomerName")+"',"+
	    				"'"+rs.getString("ShareCertID")+"',"+
	    				"'"+rs.getString("ShareConsortName")+"',"+
	    				"'"+rs.getString("ShareConsortCertID")+"',"+
	    				"'"+rs.getString("ShareAddress")+"',"+
	    				"'"+rs.getString("SharePostalCode")+"',"+
	    				"'"+rs.getString("SharePhone")+"' "+
	    				")";
	    		System.out.println(sSql7);
	    		Sqlca.executeSQL(sSql7);
	    		Sqlca.executeSQL("insert into GUARANTY_RELATIVE(objecttype,objectno,contractno,guarantyid,channel,status,type) values('CreditApply','"+sObjectNo+"','"+sSerialNo1+"','"+sSerialNo2+"','New','1','Add')");
	    	}else if("3".equals(sGuarantyInfoFlag))  //��֤
	    	{
	    		String sSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo","GC",Sqlca);
	    		String sSql2 = "insert into GUARANTY_CONTRACT (InputOrgID,CertType,EndDate,CustomerID,ContractStatus,LoanCardNo," +
	    				"InputDate,GuarantyValue,GuarantyType,GuarantorID,BeginDate,SerialNo,OtherDescribe,GuaranteeForm," +
	    				"GuarantorName,GuarantyCurrency,ContractType,InputUserID,SignDate,UpdateDate,VouchMethod,CertID) values " +
	    				"('"+rs.getString("INPUTORGID")+"'," +
	    				"'"+sGuarantyCertType+"'," +
	    				"'"+StringFunction.replace(rs.getString("ENDDATE"), "-", "/")+"'," +
	    				"'"+sApplyCustomerID+"','010','"+sGuarantLoanCardNo+"','"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"'," +
	    				""+rs.getDouble("GUARANTYVALUE")+",'010010'," +
	    				"'"+sGuarantorID+"','"+StringFunction.replace(rs.getString("BEGINDATE"), "-", "/")+"'," +
	    				"'"+sSerialNo1+"','','1'," +
	    				"'"+rs.getString("CustomerName")+"'," +
	    				"'01','010'," +
	    				"'"+sApplyInputUserID+"','"+StringFunction.replace(rs.getString("BEGINDATE"), "-", "/")+"','','','"+rs.getString("CERTID")+"')";
	    		Sqlca.executeSQL(sSql2);
	    		String sSql3 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+sObjectNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql3);
	    		String sSql8 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+wSerialNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql8);
	    	}
	    		
	    }
	    rs.close();
	    return sMessage;
	 }

 	public String getCertType(String CertType)
 	{
 		String sTemp = "";
 		if("".equals(CertType) || CertType == null)
 		{
 			sTemp = "";
 		}else if("0".equals(CertType))
 		{
 			sTemp = "Ind01";
 		}else if("1".equals(CertType))
 		{
 			sTemp = "Ind04";
 		}else if("2".equals(CertType))
 		{
 			sTemp = "Ind10";
 		}else if("3".equals(CertType))
 		{
 			sTemp = "Ind03";
 		}else if("5".equals(CertType))
 		{
 			sTemp = "Ind05";
 		}else if("6".equals(CertType))
 		{
 			sTemp = "Ind02";
 		}else if("7".equals(CertType))
 		{
 			sTemp = "Ind06";
 		}else if("8".equals(CertType))
 		{
 			sTemp = "Ind11";
 		}
 		return sTemp;
 	}
}
