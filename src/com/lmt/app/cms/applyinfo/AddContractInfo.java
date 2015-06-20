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

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.util.*;
import com.amarsoft.context.*;

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
		String sSerialNo = DBFunction.getSerialNo("BUSINESS_CONTRACT","SerialNo","",Sqlca);
		//���������SQL��䡢������ˮ��1��������ˮ��2���ֶ���ֵ
		String sSql = "",sRelativeSerialNo1 = "",sFieldValue = "",sContractObjectType = "";
		//�������:��������������1���ֶ�������
		int iColumnCount = 0,iFieldType = 0;
		//�����������ѯ���������ѯ�����1
		ASResultSet rs = null,rs1 = null;
		//ʵ�����û�����
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		
		//���ú�ͬ����
		sContractObjectType = "BusinessContract";
		//����ֵת���ɿ��ַ���
		if(sContractObjectType == null) sContractObjectType = "";
		
		//------------------------------��һ������������������Ϣ����ͬ��--------------------------------------
		//��������Ϣ���Ƶ���ͬ��Ϣ��
		sSql =  "insert into BUSINESS_CONTRACT ( "+
					"SerialNo, " +  
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
					"PigeonholeDate, " +
					"Remark, " +
					"Flag4, " +
					"Flag5, " +//--added by wwhe 2009-09-04
					"Flag6, " +//--added by wwhe 2009-09-04
					"Flag7, " +//--added by wwhe 2009-09-04
					"Flag8, " +//--added by wwhe 2009-09-04
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
					"CycleFlag, " +	
					"RateType," +//--added by wwhe 2009-09-02 for:��������
					"UnitPrice," +//--added by wwhe 2009-09-02 for:����
					"HouseTotalPrices," +//--added by wwhe 2009-09-02 for:�����ܼ�
					"FirstSum," +//--added by wwhe 2009-09-02 for:�׸����
					"FirstProportion, "+//--added by wwhe 2009-09-02 for:�׸�����
					"CoreSystemBusinessType "+//--added by wwhe 2009-10-22 for�����Ĵ���������
					",ThirdPartyAdd3, "+ //add by hywu 20110225  ���ʽ���
					"isFirstBatch,"+//--added by ymwu 2012-02-27 for���Ƿ�����
					"TasksFirstBatch,"+//--addedby ymwu 2012-02-27 for����������
					"TotalSumFirstBatch, "+//--added by ymwu 2012-02-27 for�����������
					//"Describe3, "+//--added by ymwu 2012-04-01
					"Flag9,"+//added by ymwu 20130120 �Ƿ����Ѻ
					"AllyType, "+//added by ymwu 20130120 ������ʽ
					"ManageDepartFlag "+//add by ymwu 20130528 ҵ������
					") "+
					"select "+ 
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
					"PigeonholeDate, " +
					"Remark, " +
					"Flag4, " +
					"Flag5, " +//--added by wwhe 2009-09-04
					"Flag6, " +//--added by wwhe 2009-09-04
					"Flag7, " +//--added by wwhe 2009-09-04
					"Flag8, " +//--added by wwhe 2009-09-04
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
					"RateType," +//--added by wwhe 2009-09-02 for:��������
					"UnitPrice," +//--added by wwhe 2009-09-02 for:����
					"HouseTotalPrices," +//--added by wwhe 2009-09-02 for:�����ܼ�
					"FirstSum," +//--added by wwhe 2009-09-02 for:�׸����
					"FirstProportion, "+//--added by wwhe 2009-09-02 for:�׸�����
					"CoreSystemBusinessType "+//--added by wwhe 2009-10-22 for�����Ĵ���������
					",ThirdPartyAdd3, "+ //add by hywu 20110225  ���ʽ���
					"isFirstBatch,"+//--added by ymwu 2012-02-27 for���Ƿ�����
					"TasksFirstBatch,"+//--added by ymwu 2012-02-27 for����������
					"TotalSumFirstBatch, "+//--added by ymwu 2012-02-27 for�����������
					//"Describe3, "+//--added by ymwu 2012-04-01
					"Flag9,"+//added by ymwu 20130120 �Ƿ����Ѻ
					"AllyType, "+//added by ymwu 20130120 ������ʽ
					"ManageDepartFlag "+//add by ymwu 20130528 ҵ������
					"from BUSINESS_APPROVE " +
					"where SerialNo='"+sObjectNo+"'";
		
		Sqlca.executeSQL(sSql);		
		
		//------------------------------�ڶ���������������Ϣ����Ӧ�ĵ�����Ϣ����ͬ��--------------------------------------
		/*��ע�⣺�������ĵ�����Ϣ�д��������ĵ�����Ϣ��������߶�ĵ�����Ϣ������ڽ��е�����Ϣ����ʱ��
		         ��������Ϣȫ����*/
		//���ҳ��������������߶����ͬ��Ϣ������������������
		//(��ͬ״̬��ContractStatus��010��δǩ��ͬ��020����ǩ��ͬ��030����ʧЧ)	
		sSql =  " select GC.SerialNo,AR.IsImport from GUARANTY_CONTRACT GC ,APPROVE_RELATIVE AR "+
				" where ContractStatus = '020' and AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo ,IsImport) "+
					" values('"+sSerialNo+"','GuarantyContract','"+rs.getString("SerialNo")+"','"+DataConvert.toString(rs.getString("IsImport"))+"') ";
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
		sSql =  " select GC.* from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPROVE_RELATIVE AR "+
				" where AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and GC.ContractStatus = '010' ";
		rs = Sqlca.getASResultSet(sSql);
		//��õ�����Ϣ������
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//��õ�����Ϣ���
			sRelativeSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo",Sqlca);
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
		sSql =  " select * from AGENCY_INFO where SerialNo in (select ObjectNo from APPROVE_RELATIVE "+
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
				" select '"+sSerialNo+"',ObjectType,ObjectNo from APPROVE_RELATIVE "+
				" where SerialNo = '"+sObjectNo+"' and ObjectType <> 'GuarantyContract' ";
		Sqlca.executeSQL(sSql);
		
		//------------------------------�ڶ�ʮһ���������ۺ�������������Ӧ�ķ�����ϸ��Ϣ����ͬ��--------------------------------------					
		sSql =  " update CL_INFO set BCSerialNo = '"+sSerialNo+"' where ApproveSerialNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);	
		
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
