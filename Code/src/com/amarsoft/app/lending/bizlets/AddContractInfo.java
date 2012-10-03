/*
		Author: --zywei 2005-08-09
		Tester:
		Describe: --将批复基本信息及其关联信息复制到合同中
		Input Param:
				ObjectType: 批复对象
				ObjectNo: 申请流水号
				UserID：用户代码
		Output Param:
				SerialNo：合同流水号
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
		//获得批复对象
		String sObjectType = (String)this.getAttribute("ObjectType");
		//获得批复流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");		
		//获取当前用户
		String sUserID = (String)this.getAttribute("UserID");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";		
		if(sUserID == null) sUserID = "";
		
		//获得合同流水号
	    //String sSerialNo = DBFunction.getSerialNo("BUSINESS_CONTRACT","SerialNo","BC",Sqlca);
		
		//定义变量：SQL语句、关联流水号1、关联流水号2、字段列值
		String sSql = "",sRelativeSerialNo1 = "",sFieldValue = "",sContractObjectType = "",sBusinessType="",sCustomerID="",sCustomerType="";
		//定义变量: GD起始日,GD到期日
		String sGDPutOutdate = "",sGDMaturity = "";
		//发生类型 120变更
		String sOccurType = "";	
		//变更对象：申请信息01、合同信息02
		String sChangeObject = "";	
		//原申请编号
		String sObjectNoOld	= "";		
		//定义变量:总列数、总列数1、字段列类型
		int iColumnCount = 0,iFieldType = 0;
		//定义变量：查询结果集、查询结果集1
		ASResultSet rs = null,rs1 = null;
		//实例化用户对象
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
		
		//按照合同号生成规则区最新合同号码
		String sSerialNo = BCSerialNoGenerator.getBCSerialNo(sBusinessType,sCustomerType,CurUser.OrgID,Sqlca);
		
		//设置合同对象
		sContractObjectType = "BusinessContract";
		//将空值转化成空字符串
		if(sContractObjectType == null) sContractObjectType = "";
		
		//------------------------------第一步：拷贝批复基本信息到合同中--------------------------------------
		//将批复信息复制到合同信息中
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
		
		// ------------------------将意见表中的最终审批意见拷贝到合同表中------------ add by zwhu 2009/12/08
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
		
		//------------------------------第二步：拷贝批复信息所对应的担保信息到合同中--------------------------------------
		/*请注意：在批复的担保信息中存在新增的担保信息和引入最高额的担保信息，因此在进行担保信息拷贝时，
		         将担保信息全拷贝*/
		//查找出批复中引入的最高额担保合同信息，并与批复建立关联
		//(合同状态：ContractStatus－010：未签合同；020－已签合同；030－已失效)	
		sSql =  " select GC.SerialNo from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from "+sRelativeTable+" AR "+
				" where AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and ContractStatus = '020' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
					" values('"+sSerialNo+"','GuarantyContract','"+rs.getString("SerialNo")+"') ";
			Sqlca.executeSQL(sSql);
			
			//根据批复阶段担保信息的流水号查找到相应的担保物信息
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
		
		//查找出批复关联的未签合同的担保信息，即批复阶段新增的担保信息，需要全部拷贝。	
		sSql =  " select GC.* from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from "+sRelativeTable+" AR "+
				" where AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and GC.ContractStatus = '010' ";
		System.out.println("sSql::::::::::::::::::WWQQ "+sSql); 
		rs = Sqlca.getASResultSet(sSql);
		//获得担保信息总列数
		iColumnCount = rs.getColumnCount(); 
		double index = 0;//计数器 
		String sGCType = "";
		DecimalFormat decimalformat = new DecimalFormat("00");
		while(rs.next())
		{
			//获得担保信息编号
			//sRelativeSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo","GC",Sqlca);
			String sGuarantyType = rs.getString("GuarantyType");
			if(sGuarantyType == null) sGuarantyType = "";
			if(sGuarantyType.equals("050"))//抵押
				sGCType ="2";
			else if(sGuarantyType.equals("060"))//质押
				sGCType ="3";
			else
				sGCType ="1";
			
			index++;
			
			sRelativeSerialNo1 = sSerialNo+sGCType+decimalformat.format(index);
			System.out.println("sRelativeSerialNo1:"+sRelativeSerialNo1);
			//插入担保信息
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
			
			//更改担保合同状态
			//sSql =	" update GUARANTY_CONTRACT set ContractStatus='020' where SerialNo = '"+sRelativeSerialNo1+"' ";
			//Sqlca.executeSQL(sSql);
			
			//将新拷贝的担保信息与合同建立关联
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
					" values('"+sSerialNo+"','GuarantyContract','"+sRelativeSerialNo1+"')";
			Sqlca.executeSQL(sSql);
						
			//根据批复阶段担保信息的流水号查找到相应的担保物信息
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
		
		//------------------------------第三步：拷贝批复信息所对应的共同申请人信息到合同中--------------------------------------		
		//查询出批复信息对应的共同申请人信息
		sSql =  " select * from BUSINESS_APPLICANT where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得共同申请信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("BUSINESS_APPLICANT","SerialNo",Sqlca);
			//插入共同申请人信息
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

		//------------------------------第四步：拷贝批复信息所对应的文档信息到合同中--------------------------------------				
		//只将批复信息对应的文档关联信息拷贝到合同中
		sSql =  " insert into DOC_RELATIVE(DocNo,ObjectType,ObjectNo) "+
				" select DocNo,'"+sContractObjectType+"','"+sSerialNo+"' from DOC_RELATIVE "+
				" where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);
		
		//------------------------------第五步：拷贝批复信息所对应的项目信息到合同中--------------------------------------			
		//只将批复信息对应的项目关联信息拷贝到合同中
		sSql =  " insert into PROJECT_RELATIVE(ProjectNo,ObjectType,ObjectNo) "+
				" select ProjectNo,'"+sContractObjectType+"','"+sSerialNo+"' from PROJECT_RELATIVE "+
				" where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);

		//------------------------------第六步：拷贝批复信息所对应的票据信息到合同中--------------------------------------					
		//查询出批复信息对应的票据信息
		sSql =  " select * from BILL_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得票据信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("BILL_INFO","SerialNo",Sqlca);
			//插入票据信息
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
		
		//------------------------------第七步：拷贝批复信息所对应的信用证信息到合同中--------------------------------------					
		//查询出批复信息对应的信用证信息
		sSql =  " select * from LC_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得信用证信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("LC_INFO","SerialNo",Sqlca);
			//插入信用证信息
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
		
		//------------------------------第八步：拷贝批复信息所对应的贸易合同信息到合同中--------------------------------------					
		//查询出批复信息对应的贸易合同信息
		sSql =  " select * from CONTRACT_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得贸易合同信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("CONTRACT_INFO","SerialNo",Sqlca);
			//插入贸易合同信息
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
		
		//------------------------------第九步：拷贝批复信息所对应的增值税发票信息到合同中--------------------------------------					
		//查询出批复信息对应的增值税发票信息
		sSql =  " select * from INVOICE_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得增值税发票信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("INVOICE_INFO","SerialNo",Sqlca);
			//插入增值税发票信息
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
		
		//------------------------------第十步：拷贝批复信息所对应的其它提供贷款人信息到合同中--------------------------------------					
		//查询出批复信息对应的其它提供贷款人信息
		sSql =  " select * from BUSINESS_PROVIDER where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得其它提供贷款人信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("BUSINESS_PROVIDER","SerialNo",Sqlca);
			//插入其它提供贷款人信息
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
		
		//------------------------------第十一步：拷贝批复信息所对应的保函信息到合同中--------------------------------------					
		//查询出批复信息对应的保函信息
		sSql =  " select * from LG_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得保函信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("LG_INFO","SerialNo",Sqlca);
			//插入保函信息
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
		
		//------------------------------第十二步：拷贝批复信息所对应的中介信息到合同中--------------------------------------			
		//根据批复信息查询出相对应的中介信息
		sSql =  " select * from AGENCY_INFO where SerialNo in (select ObjectNo from "+sRelativeTable+" "+
				" where SerialNo = '"+sObjectNo+"' and ObjectType='AGENCY_INFO') ";
		rs = Sqlca.getASResultSet(sSql);
		//获得担保信息总列数
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得中介信息编号
			sRelativeSerialNo1 = DBFunction.getSerialNo("AGENCY_INFO","SerialNo",Sqlca);
			//插入中介信息
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
			
			//将新拷贝的中介信息与合同建立关联
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
					" values('"+sSerialNo+"','AGENCY_INFO','"+sRelativeSerialNo1+"')";
			Sqlca.executeSQL(sSql);	
		}
		rs.getStatement().close();		
		
		//------------------------------第十三步：拷贝批复信息所对应的提单信息到合同中--------------------------------------					
		//查询出批复信息对应的提单信息
		sSql =  " select * from BOL_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得提单信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("BOL_INFO","SerialNo",Sqlca);
			//插入提单信息
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
		
		//------------------------------第十四步：拷贝批复信息所对应的房屋买卖装修信息到合同中--------------------------------------					
		//查询出批复信息对应的房屋买卖装修信息
		sSql =  " select * from BUILDING_DEAL where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得房屋买卖装修信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("BUILDING_DEAL","SerialNo",Sqlca);
			//插入房屋买卖装修信息
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
		
		//------------------------------第十五步：拷贝批复信息所对应的汽车信息到合同中--------------------------------------					
		//查询出批复信息对应的汽车信息
		sSql =  " select * from VEHICLE_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得汽车信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("VEHICLE_INFO","SerialNo",Sqlca);
			//插入汽车信息
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
		
		//------------------------------第十六步：拷贝批复信息所对应的消费信息到合同中--------------------------------------					
		//查询出批复信息对应的消费信息
		sSql =  " select * from CONSUME_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得消费信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("CONSUME_INFO","SerialNo",Sqlca);
			//插入消费信息
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
		
		//------------------------------第十七步：拷贝批复信息所对应的设备信息到合同中--------------------------------------					
		//查询出批复信息对应的设备信息
		sSql =  " select * from EQUIPMENT_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得设备信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("EQUIPMENT_INFO","SerialNo",Sqlca);
			//插入设备信息
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
		
		//------------------------------第十八步：拷贝批复信息所对应的留助学信息到合同中--------------------------------------					
		//查询出批复信息对应的留助学信息
		sSql =  " select * from STUDY_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得留助学信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("STUDY_INFO","SerialNo",Sqlca);
			//插入留助学信息
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
	
		//------------------------------第十九步：拷贝批复信息所对应的开发商楼盘信息到合同中--------------------------------------					
		//查询出批复信息对应的开发商楼盘信息
		sSql =  " select * from BUILDING_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得开发商楼盘信息流水号
			sRelativeSerialNo1 = DBFunction.getSerialNo("BUILDING_INFO","SerialNo",Sqlca);
			//插入开发商楼盘信息
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
		
		//------------------------------第二十步：拷贝批复信息所对应的直接关联信息到合同中--------------------------------------	
		//将与批复关联表直接关联的信息（除去担保信息）拷贝到合同中
		sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
				" select '"+sSerialNo+"',ObjectType,ObjectNo from "+sRelativeTable+" "+
				" where SerialNo = '"+sObjectNo+"' and ObjectType <> 'GuarantyContract' ";
		Sqlca.executeSQL(sSql);
		
		//------------------------------第二十一步：拷贝综合授信批复所对应的方案明细信息到合同中--------------------------------------					
		sSql =  " update CL_INFO set BCSerialNo = '"+sSerialNo+"' where "+sCLSerialNo+" = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);	
		
		//------------------------------第二十二步：更新申请表中已登记合同标志--------------------------------------
		if(sObjectType.equals("CreditApply")){
			sSql =  " update BUSINESS_APPLY set ContractExsitFlag = '1' where SerialNo = '"+sObjectNo+"' ";
			Sqlca.executeSQL(sSql);	
		}
		//------------------------------第二十三步：公积金组合贷款商业按揭部分增加合同起始日到期日更新--------------------------------------
		if("1110027".equals(sBusinessType)||"2110020".equals(sBusinessType)){
			//查询公积金系统传过来的中间表信息
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
		//------------------------------第二十四步：如果是申请信息变更则把原申请信息置为归档 add by wangdw--------------------------------------
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
	
	//判断字段类型是否为数字类型
	private static boolean isNumeric(int iType) 
	{
		if (iType==java.sql.Types.BIGINT ||iType==java.sql.Types.INTEGER || iType==java.sql.Types.SMALLINT || iType==java.sql.Types.DECIMAL || iType==java.sql.Types.NUMERIC || iType==java.sql.Types.DOUBLE || iType==java.sql.Types.FLOAT ||iType==java.sql.Types.REAL)
			return true;
		return false;
	}

}
