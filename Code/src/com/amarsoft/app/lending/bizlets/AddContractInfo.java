/*
		Author: --zywei 2005-08-09
		Tester:
		Describe: --������������Ϣ���������Ϣ���Ƶ���ͬ��
		Input Param:
				ObjectType: ��������
				ObjectNo: ������ˮ��
				UserID���û�����
		Output Param:
				SerialNo����ͬ��ˮ��
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import java.text.DecimalFormat;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.util.*;
import com.amarsoft.context.*;
import com.amarsoft.app.util.*;

public class AddContractInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�����������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//���������ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");		
		//��ȡ��ǰ�û�
		String sUserID = (String)this.getAttribute("UserID");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";		
		if(sUserID == null) sUserID = "";
		
		//��ú�ͬ��ˮ��
	    //String sSerialNo = DBFunction.getSerialNo("BUSINESS_CONTRACT","SerialNo","BC",Sqlca);
		
		//���������SQL��䡢������ˮ��1��������ˮ��2���ֶ���ֵ
		String sSql = "",sRelativeSerialNo1 = "",sFieldValue = "",sContractObjectType = "",sBusinessType="",sCustomerID="",sCustomerType="";
		//�������: GD��ʼ��,GD������
		String sGDPutOutdate = "",sGDMaturity = "";
		//�������� 120���
		String sOccurType = "";	
		//�������������Ϣ01����ͬ��Ϣ02
		String sChangeObject = "";	
		//ԭ������
		String sObjectNoOld	= "";		
		//�������:��������������1���ֶ�������
		int iColumnCount = 0,iFieldType = 0;
		//�����������ѯ���������ѯ�����1
		ASResultSet rs = null,rs1 = null;
		//ʵ�����û�����
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		String sObjectTable = "",sRelativeTable = "",sCLSerialNo = "";
		if(sObjectType.equals("CreditApply")){ 
			sObjectTable = "BUSINESS_APPLY";
			sRelativeTable = "APPLY_RELATIVE";
			sCLSerialNo = "ApplySerialNo";
			
		}
		else {
			sObjectTable = "BUSINESS_APPROVE";
			sRelativeTable = "APPROVE_RELATIVE";
			sCLSerialNo = "ApproveSerialNo";
		}
		sSql = "select BusinessType,CustomerID,getCustomerType(CustomerID) as CustomerType from "+sObjectTable+" where SerialNo ='"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sBusinessType = rs.getString("BusinessType");
			sCustomerID = rs.getString("CustomerID");
			sCustomerType = rs.getString("CustomerType");
			if(sBusinessType == null) sBusinessType ="";
			if(sCustomerID == null) sCustomerID ="";
			if(sCustomerType == null) sCustomerType ="";
		}
		rs.getStatement().close();
		
		//���պ�ͬ�����ɹ��������º�ͬ����
		String sSerialNo = BCSerialNoGenerator.getBCSerialNo(sBusinessType,sCustomerType,CurUser.OrgID,Sqlca);
		
		//���ú�ͬ����
		sContractObjectType = "BusinessContract";
		//����ֵת���ɿ��ַ���
		if(sContractObjectType == null) sContractObjectType = "";
		
		//------------------------------��һ������������������Ϣ����ͬ��--------------------------------------
		//��������Ϣ���Ƶ���ͬ��Ϣ��
		sSql =  "insert into BUSINESS_CONTRACT ( "+
					"SerialNo, " +  
					"ArtificialNo, " +  
					"RelativeSerialNo, " + 
					"BusinessSum, " + 
					"InputOrgID, " +
					"InputUserID, " + 
					"InputDate, " + 
					"UpdateDate, " + 					
					"PutOutOrgID, " + 
					"ManageOrgID, " + 
					"ManageUserID, " + 
					"TempSaveFlag, " +
					"OccurDate, " +
					"CustomerID, " +
					"CustomerName, " +
					"BusinessType, " +
					"BusinessSubType, " +
					"OccurType, " +
					"FundSource, " +
					"OperateType, " +
					"CurrenyList, " +
					"CurrencyMode, " +
					"BusinessTypeList, " +
					"CalculateMode, " +
					"UseOrgList, " +					
					"FlowReduceFlag, " +
					"ContractFlag, " +
					"SubContractFlag, " +
					"SelfUseFlag, " +
					"CreditAggreement, " +
					"RelativeAgreement, " +
					"LoanFlag, " +
					"TotalSum, " +
					"OurRole, " +
					"Reversibility, " +
					"BillNum, " +
					"HouseType, " +
					"LCTermType, " +
					"RiskAttribute, " +
					"SureType, " +
					"SafeGuardType, " +
					"BusinessCurrency, " +
					"BusinessProp, " +
					"TermYear, " +
					"TermMonth, " +
					"TermDay, " +
					"LGTerm, " +
					"BaseRateType, " +
					"BaseRate, " +
					"RateFloatType, " +
					"RateFloat, " +
					"BusinessRate, " +
					"ICType, " +
					"ICCyc, " +
					"PDGRatio, " +
					"PDGSum, " +
					"PDGPayMethod, " +
					"PDGPayPeriod, " +
					"PromisesFeeRatio, " +
					"PromisesFeeSum, " +
					"PromisesFeePeriod, " +
					"PromisesFeeBegin, " +
					"MFeeRatio, " +
					"MFeeSum, " +
					"MFeePayMethod, " +
					"AgentFee, " +
					"DealFee, " +
					"TotalCast, " +
					"DiscountInterest, " +
					"PurchaserInterest, " +
					"BargainorInterest, " +
					"DiscountSum, " +
					"BailRatio, " +
					"BailCurrency, " +
					"BailSum, " +
					"BailAccount, " +
					"FineRateType, " +
					"FineRate, " +
					"DrawingType, " +
					"FirstDrawingDate, " +
					"DrawingPeriod, " +
					"PayTimes, " +
					"PayCyc, " +
					"GracePeriod, " +
					"OverDraftPeriod, " +
					"OldLCNo, " +
					"OldLCTermType, " +
					"OldLCCurrency, " +
					"OldLCSum, " +
					"OldLCLoadingDate, " +
					"OldLCValidDate, " +
					"Direction, " +
					"CreditSteel, " +
					"Purpose, " +
					"PlanalLocation, " +
					"ImmediacyPaySource, " +
					"PaySource, " +
					"CorpusPayMethod, " +
					"InterestPayMethod, " +
					"ThirdParty1, " +
					"ThirdPartyID1, " +
					"ThirdParty2, " +
					"ThirdPartyID2, " +
					"ThirdParty3, " +
					"ThirdPartyID3, " +
					"ThirdPartyRegion, " +
					"ThirdPartyAccounts, " +
					"CargoInfo, " +
					"ProjectName, " +
					"OperationInfo, " +
					"ContextInfo, " +
					"SecuritiesType, " +
					"SecuritiesRegion, " +
					"ConstructionArea, " +
					"UseArea, " +
					"Flag1, " +
					"Flag2, " +
					"Flag3, " +
					"TradeContractNo, " +
					"InvoiceNo, " +
					"TradeCurrency, " +
					"TradeSum, " +
					"PaymentDate, " +
					"OperationMode, " +
					"VouchClass, " +
					"VouchType, " +
					"VouchType1, " +
					"VouchType2, " +
					"VouchFlag, " +
					"Warrantor, " +
					"WarrantorID, " +
					"OtherCondition, " +
					"GuarantyValue, " +
					"GuarantyRate, " +
					"BaseEvaluateResult, " +
					"RiskRate, " +
					"LowRisk, " +
					"NationRisk, " +
					"OtherAreaLoan, " +
					"LowRiskBailSum, " +
					"OriginalPutOutDate, " +
					"ExtendTimes, " +
					"LNGOTimes, " +
					"GOLNTimes, " +
					"DRTimes, " +
					"BaseClassifyResult, " +
					"ApplyType, " +
					"BailRate, " +
					"FinishOrg, " +
					"OperateOrgID, " +
					"OperateUserID, " +
					"OperateDate, " +
					"Remark, " +
					"Flag4, " +
					"PayCurrency, " +
					"PayDate, "+
					"ClassifyResult, "+
					"ClassifyDate, "+
					"ClassifyFrequency, "+
					"AdjustRateType, "+ 
					"AdjustRateTerm, "+ 
					"FixCyc, "+ 
					"RateAdjustCyc, "+ 
					"FZANBalance, "+ 
					"ThirdPartyAdd2, "+ 
					"ThirdPartyZIP2, "+ 
					"ThirdPartyAdd1, "+ 
					"ThirdPartyZIP1, "+ 
					"TermDate1, "+ 
					"TermDate2, "+ 
					"TermDate3, "+
					"AcceptIntType, "+ 
					"Ratio, "+ 
					"Describe2, "+
					"Describe1, "+
					"ApproveDate, " +
					"FreezeFlag, " +					
					"CycleFlag ," +	
					"AssureAgreement, " +					
					"CommunityAgreement ," +	
					"AGRILOANCLASSIFY,"+
					"COMMUNITYTYPE,"+
					"THIRDPARTY4,"+
					"INVOICESUM,"+
					"INVOICECURRENCY,"+
					"FEECURRENCY,"+
					"EXPOSURESUM ,"+
					"CREDITMANAGEMODE,"+
					"PROJECTFLAG,"+
					"AUCTIONFLAG,"+
					"DEALERCOOPFLAG,"+
					"CONSTRUCTCONTRACTNO,"+
					"TRADENAME,"+
					"COMPPROVIDENTFLAG,"+
					"VOUCHCORPFLAG,"+
					"VOUCHAGGREEMENT,"+
					"VOUCHCORPNAME,"+
					"EquipmentSum,"+
					"CropName,"+
					"BuildAgreement,"+
					"ThirdPartyAdd3, "+
					"ThirdPartyZIP3,"+
					"EstateUseYears, "+
					"OperateYears, "+
					"RentRatio, "+
					"LoanType, "+
					"OldBusinessRate, "+
					"BAAgreement, "+
					"BankGroupFlag, "+
					"AgriLoanFlag, "+
					"AFALoanFlag, "+
					"ApprovalNo, "+
					"CreditUseInfo, " +
					"OverdueTerms, " +
					"UnusualRecord, " +
					"OverdueTermsSum, " +
					"UnusualDeal, " +
					"ReCreditUseInfo, " +
					"ReOverdueTerms, " +
					"ReUnusualRecord, " +
					"ReOverdueTermsSum, " +
					"ReUnusualDeal, " +
					"CommercialNo, "+
					"GDSerialNo, " +
					"RetireLoanType, " +
					"IsUseConsortPact, " +
					"TermUseType, " +
					"MostTermMonth, " +
					"MostLoanValue, " +
					"AccumulationNo, "+
					"TotalBusinessSum, " +
					"RiseFallRate, " +
					"MonthReturnSum, " +
					"Flowover, " +
					"PracticeSum, " +
					"ChangType, " +
					"ChangeReason," +
					"ChangeObject," +
					"ERateDate, "+
					"LCNo " +
					") "+
					"select "+ 
					"'"+sSerialNo+"', " +  
					"'"+sSerialNo+"', " + 
					"SerialNo, " +
					"BusinessSum, " + 
					"'"+CurUser.OrgID+"', " + 
					"'"+CurUser.UserID+"', " + 
					"'"+StringFunction.getToday()+"', " + 
					"'"+StringFunction.getToday()+"', " + 					
					"'"+CurUser.OrgID+"', " + 
					"'"+CurUser.OrgID+"', " + 
					"'"+CurUser.UserID+"', " + 
					"'1', " + 
					"'"+StringFunction.getToday()+"', " +
					"CustomerID, " +
					"CustomerName, " +
					"BusinessType, " +
					"BusinessSubType, " +
					"OccurType, " +
					"FundSource, " +
					"OperateType, " +
					"CurrenyList, " +
					"CurrencyMode, " +
					"BusinessTypeList, " +
					"CalculateMode, " +
					"UseOrgList, " +					
					"FlowReduceFlag, " +
					"ContractFlag, " +
					"SubContractFlag, " +
					"SelfUseFlag, " +
					"CreditAggreement, " +
					"RelativeAgreement, " +
					"LoanFlag, " +
					"TotalSum, " +
					"OurRole, " +
					"Reversibility, " +
					"BillNum, " +
					"HouseType, " +
					"LCTermType, " +
					"RiskAttribute, " +
					"SureType, " +
					"SafeGuardType, " +
					"BusinessCurrency, " +
					"BusinessProp, " +
					"TermYear, " +
					"TermMonth, " +
					"TermDay, " +
					"LGTerm, " +
					"BaseRateType, " +
					"BaseRate, " +
					"RateFloatType, " +
					"RateFloat, " +
					"BusinessRate, " +
					"ICType, " +
					"ICCyc, " +
					"PDGratio, " +
					"PDGSum, " +
					"PDGPayMethod, " +
					"PDGPayPeriod, " +
					"PromisesFeeRatio, " +
					"PromisesFeeSum, " +
					"PromisesFeePeriod, " +
					"PromisesFeeBegin, " +
					"MFeeRatio, " +
					"MFeeSum, " +
					"MFeePayMethod, " +
					"AgentFee, " +
					"DealFee, " +
					"TotalCast, " +
					"DiscountInterest, " +
					"PurchaserInterest, " +
					"BargainorInterest, " +
					"DiscountSum, " +
					"BailRatio, " +
					"BailCurrency, " +
					"BailSum, " +
					"BailAccount, " +
					"FineRateType, " +
					"FineRate, " +
					"DrawingType, " +
					"FirstDrawingDate, " +
					"DrawingPeriod, " +
					"PayTimes, " +
					"PayCyc, " +
					"GracePeriod, " +
					"OverDraftPeriod, " +
					"OldLCNo, " +
					"OldLCTermType, " +
					"OldLCCurrency, " +
					"OldLCSum, " +
					"OldLCLoadingDate, " +
					"OldLCValidDate, " +
					"Direction, " +
					"CreditSteel, " +
					"Purpose, " +
					"PlanalLocation, " +
					"ImmediacyPaySource, " +
					"PaySource, " +
					"CorpusPayMethod, " +
					"InterestPayMethod, " +
					"ThirdParty1, " +
					"ThirdPartyID1, " +
					"ThirdParty2, " +
					"ThirdPartyID2, " +
					"ThirdParty3, " +
					"ThirdPartyID3, " +
					"ThirdPartyRegion, " +
					"ThirdPartyAccounts, " +
					"CargoInfo, " +
					"ProjectName, " +
					"OperationInfo, " +
					"ContextInfo, " +
					"SecuritiesType, " +
					"SecuritiesRegion, " +
					"ConstructionArea, " +
					"UseArea, " +
					"Flag1, " +
					"Flag2, " +
					"Flag3, " +
					"TradeContractNo, " +
					"InvoiceNo, " +
					"TradeCurrency, " +
					"TradeSum, " +
					"PaymentDate, " +
					"OperationMode, " +
					"VouchClass, " +
					"VouchType, " +
					"VouchType1, " +
					"VouchType2, " +
					"VouchFlag, " +
					"Warrantor, " +
					"WarrantorID, " +
					"OtherCondition, " +
					"GuarantyValue, " +
					"GuarantyRate, " +
					"BaseEvaluateResult, " +
					"RiskRate, " +
					"LowRisk, " +
					"NationRisk, " +
					"OtherAreaLoan, " +
					"LowRiskBailSum, " +
					"OriginalPutOutDate, " +
					"ExtendTimes, " +
					"LNGOTimes, " +
					"GOLNTimes, " +
					"DRTimes, " +
					"BaseClassifyResult, " +
					"ApplyType, " +
					"BailRate, " +
					"FinishOrg, " +
					"OperateOrgID, " +
					"OperateUserID, " +
					"OperateDate, " +
					"Remark, " +
					"Flag4, " +
					"PayCurrency, " +
					"PayDate, "+
					"ClassifyResult, "+
					"ClassifyDate, "+
					"ClassifyFrequency, "+
					"AdjustRateType, "+ 
					"AdjustRateTerm, "+ 
					"FixCyc, "+ 
					"RateAdjustCyc, "+ 
					"FZANBalance, "+ 
					"ThirdPartyAdd2, "+ 
					"ThirdPartyZIP2, "+ 
					"ThirdPartyAdd1, "+ 
					"ThirdPartyZIP1, "+ 
					"TermDate1, "+ 
					"TermDate2, "+ 
					"TermDate3, "+ 
					"AcceptIntType, "+ 
					"Ratio, "+ 
					"Describe2, "+
					"Describe1, "+
					"ApproveDate, "+
					"'1', " +
					"CycleFlag, " +
					"AssureAgreement, " +					
					"CommunityAgreement ," +	
					"AGRILOANCLASSIFY,"+
					"COMMUNITYTYPE,"+
					"THIRDPARTY4,"+
					"INVOICESUM,"+
					"INVOICECURRENCY,"+
					"FEECURRENCY,"+
					"EXPOSURESUM ,"+
					"CREDITMANAGEMODE,"+
					"PROJECTFLAG,"+
					"AUCTIONFLAG,"+
					"DEALERCOOPFLAG,"+
					"CONSTRUCTCONTRACTNO,"+
					"TRADENAME,"+
					"COMPPROVIDENTFLAG,"+
					"VOUCHCORPFLAG,"+
					"VOUCHAGGREEMENT,"+
					"VOUCHCORPNAME, "+
					"EquipmentSum,"+
					"CropName,"+
					"BuildAgreement, "+
					"ThirdPartyAdd3, "+
					"ThirdPartyZIP3, "+
					"EstateUseYears, "+
					"OperateYears, "+
					"RentRatio,"+
					"LoanType, "+
					"OldBusinessRate, "+
					"BAAgreement, "+
					"BankGroupFlag, "+
					"AgriLoanFlag, "+
					"AFALoanFlag, "+
					"ApprovalNo, "+
					"CreditUseInfo, " +
					"OverdueTerms, " +
					"UnusualRecord, " +
					"OverdueTermsSum, " +
					"UnusualDeal, " +
					"ReCreditUseInfo, " +
					"ReOverdueTerms, " +
					"ReUnusualRecord, " +
					"ReOverdueTermsSum, " +
					"ReUnusualDeal, " +
					"CommercialNo, "+
					"GDSerialNo, " +
					"RetireLoanType, " +
					"IsUseConsortPact, " +
					"TermUseType, " +
					"MostTermMonth, " +
					"MostLoanValue, " +
					"AccumulationNo, "+
					"TotalBusinessSum, " +
					"RiseFallRate, " +
					"MonthReturnSum, " +
					"Flowover, " +
					"PracticeSum, " +
					"ChangType, " +
					"ChangeReason," +
					"ChangeObject," +
					"ERateDate, "+
					"LCNo " +
					" from "+sObjectTable+" " +
					" where SerialNo='"+sObjectNo+"'";
		
		Sqlca.executeSQL(sSql);		
		
		// ------------------------��������е��������������������ͬ����------------ add by zwhu 2009/12/08
		String sBusinessCurrencyOpinion ="",sRateFloatTypeOpinion ="",sBaseRateTypeOpinion ="",sBailCurrencyOpinion="";
		sSql = " select BusinessCurrency,BusinessSum,TermYear,TermMonth,TermDay,BaseRate,RateFloatType,"+
		   " BaseRateType,BusinessRate,PDGRatio,PDGSum,BailSum,BailRatio,BailCurrency,RateFloat "+
		   " From FLOW_OPINION where SerialNo = " +
		   " (select RelativeSerialno from FLOW_TASK where Objectno = '"+sObjectNo+"' and phasetype='1040' and "+
		   " (ObjectType = 'CreditApply' or ObjectType = 'CreditLineApply')) "; 
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sBusinessCurrencyOpinion = rs.getString("BusinessCurrency");
			sRateFloatTypeOpinion = rs.getString("RateFloatType");
			sBaseRateTypeOpinion = rs.getString("BaseRateType");
			sBailCurrencyOpinion = rs.getString("BailCurrency");
			if(sBusinessCurrencyOpinion ==null) sBusinessCurrencyOpinion="";
			if(sRateFloatTypeOpinion ==null) sRateFloatTypeOpinion="";
			if(sBaseRateTypeOpinion ==null) sBaseRateTypeOpinion="";
			if(sBailCurrencyOpinion ==null) sBailCurrencyOpinion="";
			
			sSql = " update BUSINESS_CONTRACT set Businesscurrency = '"+sBusinessCurrencyOpinion+"',"+
				   " BusinessSum ="+rs.getDouble(2)+",TermYear = "+rs.getInt(3)+",TermMonth = "+rs.getInt(4)+","+
				   " TermDay = "+rs.getInt(5)+",BaseRate = "+rs.getDouble(6)+",RateFloatType = '"+sRateFloatTypeOpinion+"',"+
				   " BusinessRate = "+rs.getDouble(9)+","+
				   " PDGRatio = "+rs.getDouble(10)+",PDGSum = "+rs.getDouble(11)+",BailSum ="+rs.getDouble(12)+","+
				   " BailRatio = "+rs.getDouble(13)+",BailCurrency ='"+sBailCurrencyOpinion+"',RateFloat ="+rs.getDouble(15)+""+
				   " where serialno = '"+sSerialNo+"'";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();
		
		//------------------------------�ڶ���������������Ϣ����Ӧ�ĵ�����Ϣ����ͬ��--------------------------------------
		/*��ע�⣺�������ĵ�����Ϣ�д��������ĵ�����Ϣ��������߶�ĵ�����Ϣ������ڽ��е�����Ϣ����ʱ��
		         ��������Ϣȫ����*/
		//���ҳ��������������߶����ͬ��Ϣ������������������
		//(��ͬ״̬��ContractStatus��010��δǩ��ͬ��020����ǩ��ͬ��030����ʧЧ)	
		sSql =  " select GC.SerialNo from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from "+sRelativeTable+" AR "+
				" where AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and ContractStatus = '020' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
					" values('"+sSerialNo+"','GuarantyContract','"+rs.getString("SerialNo")+"') ";
			Sqlca.executeSQL(sSql);
			
			//���������׶ε�����Ϣ����ˮ�Ų��ҵ���Ӧ�ĵ�������Ϣ
			sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
					" where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' "+
					" and ContractNo = '" +rs.getString("SerialNo")+"' ";
			rs1 = Sqlca.getASResultSet(sSql);				
			while(rs1.next())
			{
				sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
						" values('"+sContractObjectType+"','"+sSerialNo+"','"+rs.getString("SerialNo")+"', "+
						" '"+rs1.getString("GuarantyID")+"','Copy','"+rs1.getString("Status")+"','"+rs1.getString("Type")+"') ";
				Sqlca.executeSQL(sSql);	
			}
			rs1.getStatement().close();
		}
		rs.getStatement().close();
		
		//���ҳ�����������δǩ��ͬ�ĵ�����Ϣ���������׶������ĵ�����Ϣ����Ҫȫ��������	
		sSql =  " select GC.* from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from "+sRelativeTable+" AR "+
				" where AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and GC.ContractStatus = '010' ";
		System.out.println("sSql::::::::::::::::::WWQQ "+sSql); 
		rs = Sqlca.getASResultSet(sSql);
		//��õ�����Ϣ������
		iColumnCount = rs.getColumnCount(); 
		double index = 0;//������ 
		String sGCType = "";
		DecimalFormat decimalformat = new DecimalFormat("00");
		while(rs.next())
		{
			//��õ�����Ϣ���
			//sRelativeSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo","GC",Sqlca);
			String sGuarantyType = rs.getString("GuarantyType");
			if(sGuarantyType == null) sGuarantyType = "";
			if(sGuarantyType.equals("050"))//��Ѻ
				sGCType ="2";
			else if(sGuarantyType.equals("060"))//��Ѻ
				sGCType ="3";
			else
				sGCType ="1";
			
			index++;
			
			sRelativeSerialNo1 = sSerialNo+sGCType+decimalformat.format(index);
			System.out.println("sRelativeSerialNo1:"+sRelativeSerialNo1);
			//���뵣����Ϣ
			sSql = " insert into GUARANTY_CONTRACT values('"+sRelativeSerialNo1+"'";
			for(int i=2;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0"; 
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
			
			//���ĵ�����ͬ״̬
			//sSql =	" update GUARANTY_CONTRACT set ContractStatus='020' where SerialNo = '"+sRelativeSerialNo1+"' ";
			//Sqlca.executeSQL(sSql);
			
			//���¿����ĵ�����Ϣ���ͬ��������
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
					" values('"+sSerialNo+"','GuarantyContract','"+sRelativeSerialNo1+"')";
			Sqlca.executeSQL(sSql);
						
			//���������׶ε�����Ϣ����ˮ�Ų��ҵ���Ӧ�ĵ�������Ϣ
			sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
					" where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' "+
					" and ContractNo = '" +rs.getString("SerialNo")+"' ";
			rs1 = Sqlca.getASResultSet(sSql);				
			while(rs1.next())
			{
				sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
						" values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"', "+
						" '"+rs1.getString("GuarantyID")+"','Copy','"+rs1.getString("Status")+"','"+rs1.getString("Type")+"') ";
				Sqlca.executeSQL(sSql);	
			}
			rs1.getStatement().close();
		}
		rs.getStatement().close();
		
		//------------------------------������������������Ϣ����Ӧ�Ĺ�ͬ��������Ϣ����ͬ��--------------------------------------		
		//��ѯ��������Ϣ��Ӧ�Ĺ�ͬ��������Ϣ
		sSql =  " select * from BUSINESS_APPLICANT where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//��ù�ͬ������Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("BUSINESS_APPLICANT","SerialNo",Sqlca);
			//���빲ͬ��������Ϣ
			sSql = " insert into BUSINESS_APPLICANT values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();

		//------------------------------���Ĳ�������������Ϣ����Ӧ���ĵ���Ϣ����ͬ��--------------------------------------				
		//ֻ��������Ϣ��Ӧ���ĵ�������Ϣ��������ͬ��
		sSql =  " insert into DOC_RELATIVE(DocNo,ObjectType,ObjectNo) "+
				" select DocNo,'"+sContractObjectType+"','"+sSerialNo+"' from DOC_RELATIVE "+
				" where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);
		
		//------------------------------���岽������������Ϣ����Ӧ����Ŀ��Ϣ����ͬ��--------------------------------------			
		//ֻ��������Ϣ��Ӧ����Ŀ������Ϣ��������ͬ��
		sSql =  " insert into PROJECT_RELATIVE(ProjectNo,ObjectType,ObjectNo) "+
				" select ProjectNo,'"+sContractObjectType+"','"+sSerialNo+"' from PROJECT_RELATIVE "+
				" where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);

		//------------------------------������������������Ϣ����Ӧ��Ʊ����Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ��Ʊ����Ϣ
		sSql =  " select * from BILL_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//���Ʊ����Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("BILL_INFO","SerialNo",Sqlca);
			//����Ʊ����Ϣ
			sSql = " insert into BILL_INFO values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();		
		
		//------------------------------���߲�������������Ϣ����Ӧ������֤��Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ������֤��Ϣ
		sSql =  " select * from LC_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//�������֤��Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("LC_INFO","SerialNo",Sqlca);
			//��������֤��Ϣ
			sSql = " insert into LC_INFO values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();
		
		//------------------------------�ڰ˲�������������Ϣ����Ӧ��ó�׺�ͬ��Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ��ó�׺�ͬ��Ϣ
		sSql =  " select * from CONTRACT_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//���ó�׺�ͬ��Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("CONTRACT_INFO","SerialNo",Sqlca);
			//����ó�׺�ͬ��Ϣ
			sSql = " insert into CONTRACT_INFO values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();		
		
		//------------------------------�ھŲ�������������Ϣ����Ӧ����ֵ˰��Ʊ��Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ����ֵ˰��Ʊ��Ϣ
		sSql =  " select * from INVOICE_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//�����ֵ˰��Ʊ��Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("INVOICE_INFO","SerialNo",Sqlca);
			//������ֵ˰��Ʊ��Ϣ
			sSql = " insert into INVOICE_INFO values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();				
		
		//------------------------------��ʮ��������������Ϣ����Ӧ�������ṩ��������Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ�������ṩ��������Ϣ
		sSql =  " select * from BUSINESS_PROVIDER where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//��������ṩ��������Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("BUSINESS_PROVIDER","SerialNo",Sqlca);
			//���������ṩ��������Ϣ
			sSql = " insert into BUSINESS_PROVIDER values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();		
		
		//------------------------------��ʮһ��������������Ϣ����Ӧ�ı�����Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ�ı�����Ϣ
		sSql =  " select * from LG_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//��ñ�����Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("LG_INFO","SerialNo",Sqlca);
			//���뱣����Ϣ
			sSql = " insert into LG_INFO values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();			
		
		//------------------------------��ʮ����������������Ϣ����Ӧ���н���Ϣ����ͬ��--------------------------------------			
		//����������Ϣ��ѯ�����Ӧ���н���Ϣ
		sSql =  " select * from AGENCY_INFO where SerialNo in (select ObjectNo from "+sRelativeTable+" "+
				" where SerialNo = '"+sObjectNo+"' and ObjectType='AGENCY_INFO') ";
		rs = Sqlca.getASResultSet(sSql);
		//��õ�����Ϣ������
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//����н���Ϣ���
			sRelativeSerialNo1 = DBFunction.getSerialNo("AGENCY_INFO","SerialNo",Sqlca);
			//�����н���Ϣ
			sSql = " insert into AGENCY_INFO values('"+sRelativeSerialNo1+"'";
			for(int i=2;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
			
			//���¿������н���Ϣ���ͬ��������
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
					" values('"+sSerialNo+"','AGENCY_INFO','"+sRelativeSerialNo1+"')";
			Sqlca.executeSQL(sSql);	
		}
		rs.getStatement().close();		
		
		//------------------------------��ʮ����������������Ϣ����Ӧ���ᵥ��Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ���ᵥ��Ϣ
		sSql =  " select * from BOL_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//����ᵥ��Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("BOL_INFO","SerialNo",Sqlca);
			//�����ᵥ��Ϣ
			sSql = " insert into BOL_INFO values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();				
		
		//------------------------------��ʮ�Ĳ�������������Ϣ����Ӧ�ķ�������װ����Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ�ķ�������װ����Ϣ
		sSql =  " select * from BUILDING_DEAL where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//��÷�������װ����Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("BUILDING_DEAL","SerialNo",Sqlca);
			//���뷿������װ����Ϣ
			sSql = " insert into BUILDING_DEAL values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();				
		
		//------------------------------��ʮ�岽������������Ϣ����Ӧ��������Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ��������Ϣ
		sSql =  " select * from VEHICLE_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//���������Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("VEHICLE_INFO","SerialNo",Sqlca);
			//����������Ϣ
			sSql = " insert into VEHICLE_INFO values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();					
		
		//------------------------------��ʮ����������������Ϣ����Ӧ��������Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ��������Ϣ
		sSql =  " select * from CONSUME_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//���������Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("CONSUME_INFO","SerialNo",Sqlca);
			//����������Ϣ
			sSql = " insert into CONSUME_INFO values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();			
		
		//------------------------------��ʮ�߲�������������Ϣ����Ӧ���豸��Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ���豸��Ϣ
		sSql =  " select * from EQUIPMENT_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//����豸��Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("EQUIPMENT_INFO","SerialNo",Sqlca);
			//�����豸��Ϣ
			sSql = " insert into EQUIPMENT_INFO values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();				
		
		//------------------------------��ʮ�˲�������������Ϣ����Ӧ������ѧ��Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ������ѧ��Ϣ
		sSql =  " select * from STUDY_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//�������ѧ��Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("STUDY_INFO","SerialNo",Sqlca);
			//��������ѧ��Ϣ
			sSql = " insert into STUDY_INFO values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();					
	
		//------------------------------��ʮ�Ų�������������Ϣ����Ӧ�Ŀ�����¥����Ϣ����ͬ��--------------------------------------					
		//��ѯ��������Ϣ��Ӧ�Ŀ�����¥����Ϣ
		sSql =  " select * from BUILDING_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//��ÿ�����¥����Ϣ��ˮ��
			sRelativeSerialNo1 = DBFunction.getSerialNo("BUILDING_INFO","SerialNo",Sqlca);
			//���뿪����¥����Ϣ
			sSql = " insert into BUILDING_INFO values('"+sContractObjectType+"','"+sSerialNo+"','"+sRelativeSerialNo1+"'";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			Sqlca.executeSQL(sSql);
		}
		rs.getStatement().close();	
		
		//------------------------------�ڶ�ʮ��������������Ϣ����Ӧ��ֱ�ӹ�����Ϣ����ͬ��--------------------------------------	
		//��������������ֱ�ӹ�������Ϣ����ȥ������Ϣ����������ͬ��
		sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
				" select '"+sSerialNo+"',ObjectType,ObjectNo from "+sRelativeTable+" "+
				" where SerialNo = '"+sObjectNo+"' and ObjectType <> 'GuarantyContract' ";
		Sqlca.executeSQL(sSql);
		
		//------------------------------�ڶ�ʮһ���������ۺ�������������Ӧ�ķ�����ϸ��Ϣ����ͬ��--------------------------------------					
		sSql =  " update CL_INFO set BCSerialNo = '"+sSerialNo+"' where "+sCLSerialNo+" = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);	
		
		//------------------------------�ڶ�ʮ������������������ѵǼǺ�ͬ��־--------------------------------------
		if(sObjectType.equals("CreditApply")){
			sSql =  " update BUSINESS_APPLY set ContractExsitFlag = '1' where SerialNo = '"+sObjectNo+"' ";
			Sqlca.executeSQL(sSql);	
		}
		//------------------------------�ڶ�ʮ��������������ϴ�����ҵ���Ҳ������Ӻ�ͬ��ʼ�յ����ո���--------------------------------------
		if("1110027".equals(sBusinessType)||"2110020".equals(sBusinessType)){
			//��ѯ������ϵͳ���������м����Ϣ
			sSql =  " select StartDate,EndDate from GD_BUSINESSAPPLY GB"+
					" where Exists(select 1 from BUSINESS_APPLY where " +
					//"CommercialNo =GB.CommercialNo and " +
					"AccumulationNo=GB.AccumulationNo and SerialNo='"+sObjectNo+"') ";
			rs1 = Sqlca.getASResultSet(sSql);				
			if(rs1.next())
			{
				sGDPutOutdate = rs1.getString("StartDate");
				if(sGDPutOutdate.length()>=8)
		    	{
					sGDPutOutdate = sGDPutOutdate.substring(0,4)+"/"+sGDPutOutdate.substring(4,6)+"/"+sGDPutOutdate.substring(6,8);
		    	}else{
		    		sGDPutOutdate="";
		    	}
				sGDMaturity = rs1.getString("EndDate");
				if(sGDMaturity.length()>=8)
		    	{
					sGDMaturity = sGDMaturity.substring(0,4)+"/"+sGDMaturity.substring(4,6)+"/"+sGDMaturity.substring(6,8);
		    	}else{
		    		sGDMaturity="";
		    	}
			}
			rs1.getStatement().close();
			sSql =  " update BUSINESS_CONTRACT set PutOutDate = '"+sGDPutOutdate+"',Maturity = '"+sGDMaturity+"' where SerialNo = '"+sSerialNo+"' ";
			Sqlca.executeSQL(sSql);	
		}
		//------------------------------�ڶ�ʮ�Ĳ��������������Ϣ������ԭ������Ϣ��Ϊ�鵵 add by wangdw--------------------------------------
		sSql = "select OCCURTYPE,ChangeObject from "+sObjectTable+" where SerialNo ='"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sOccurType    = rs.getString("OCCURTYPE");
			sChangeObject = rs.getString("ChangeObject");
		}
		sSql = "select OBJECTNO from "+sRelativeTable+" where SerialNo ='"+sObjectNo+"' and objecttype = 'ApplyChange'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sObjectNoOld = rs.getString("OBJECTNO");
		}
		rs.getStatement().close();
		if("120".equals(sOccurType)&&"01".equals(sChangeObject))
		{
			Sqlca.executeSQL("Update BUSINESS_APPLY set PigeonholeDate='"+StringFunction.getToday()+"' where SerialNo='"+sObjectNoOld+"'");
		}
		return sSerialNo;
	}
	
	//�ж��ֶ������Ƿ�Ϊ��������
	private static boolean isNumeric(int iType) 
	{
		if (iType==java.sql.Types.BIGINT ||iType==java.sql.Types.INTEGER || iType==java.sql.Types.SMALLINT || iType==java.sql.Types.DECIMAL || iType==java.sql.Types.NUMERIC || iType==java.sql.Types.DOUBLE || iType==java.sql.Types.FLOAT ||iType==java.sql.Types.REAL)
			return true;
		return false;
	}

}
