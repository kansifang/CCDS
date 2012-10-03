package com.amarsoft.app.lending.bizlets;
/**
 * 变更前备份合同信息到合同历史表 2012-3-22 wangdw
 * 
 * */
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.ASResultSet;


public class BackUpContract extends Bizlet 
{



 public Object  run(Transaction Sqlca) throws Exception
	 {			
		
		String sObjectType = (String)this.getAttribute("ObjectType");							//操作类型
		String sObjectNo = (String)this.getAttribute("ObjectNo");								//新申请编号
		String sSerialNo = (String)this.getAttribute("SerialNo");								//待变更合同号或申请号
		String sBusinessType = (String)this.getAttribute("BusinessType");						//业务品种id
		String sChangeType = (String)this.getAttribute("ChangeType");							//变更类型
		String sSql = "";																		//定义变量:用于把合同信息插入合同历史表
		String sSql1 = "";																		//定义变量:用于查询变更前合同信息
		String sSql2 = "";																		//定义变量:用于查询变更前抵质押物信息
		String sSql3 = "";																		//定义变量:用于复制担保物信息
		String order="";																		//历史合同信息表的主键id
		String sNewSerialNo="";																	//新的担保合同号
		String newGuarantyId = "";																//新的担保物id
		ASResultSet rs = null;
		ASResultSet rs1 = null;
		//如果是公积金组合贷款变更
		if(sBusinessType.equals("1110027"))
		{
			//复制变更合同信息到历史合同信息表
			order = DBFunction.getSerialNo("BUSINESS_CONTRACT_HISTORY","ORDER");	
			sSql =  "insert into BUSINESS_CONTRACT_HISTORY (SerialNo,ORDER,ArtificialNo,RelativeSerialNo,BusinessSum," +
					"InputOrgID,InputUserID,InputDate,UpdateDate,PutOutOrgID,ManageOrgID,ManageUserID,TempSaveFlag," +
					"OccurDate,CustomerID,CustomerName,BusinessType,BusinessSubType,OccurType,FundSource,OperateType," +
					"CurrenyList,CurrencyMode,BusinessTypeList,CalculateMode,UseOrgList,FlowReduceFlag,ContractFlag," +
					"SubContractFlag,SelfUseFlag,CreditAggreement,RelativeAgreement,LoanFlag,TotalSum,OurRole,Reversibility," +
					"BillNum,HouseType,LCTermType,RiskAttribute,SureType,SafeGuardType,BusinessCurrency,BusinessProp," +
					"TermYear,TermMonth,TermDay,LGTerm,BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate,ICType," +
					"ICCyc,PDGRatio,PDGSum,PDGPayMethod,PDGPayPeriod,PromisesFeeRatio,PromisesFeeSum,PromisesFeePeriod," +
					"PromisesFeeBegin,MFeeRatio,MFeeSum,MFeePayMethod,AgentFee,DealFee,TotalCast,DiscountInterest," +
					"PurchaserInterest,BargainorInterest,DiscountSum,BailRatio,BailCurrency,BailSum,BailAccount," +
					"FineRateType,FineRate,DrawingType,FirstDrawingDate,DrawingPeriod,PayTimes,PayCyc,GracePeriod," +
					"OverDraftPeriod,OldLCNo,OldLCTermType,OldLCCurrency,OldLCSum,OldLCLoadingDate,OldLCValidDate," +
					"Direction,Purpose,PlanalLocation,ImmediacyPaySource,PaySource,CorpusPayMethod,InterestPayMethod," +
					"ThirdParty1,ThirdPartyID1,ThirdParty2,ThirdPartyID2,ThirdParty3,ThirdPartyID3,ThirdPartyRegion," +
					"ThirdPartyAccounts,CargoInfo,ProjectName,OperationInfo,ContextInfo,SecuritiesType,SecuritiesRegion," +
					"ConstructionArea,UseArea,Flag1,Flag2,Flag3,TradeContractNo,InvoiceNo,TradeCurrency,TradeSum," +
					"PaymentDate,OperationMode,VouchClass,VouchType,VouchType1,VouchType2,VouchFlag,Warrantor,WarrantorID," +
					"OtherCondition,GuarantyValue,GuarantyRate,BaseEvaluateResult,RiskRate,LowRisk,NationRisk,OtherAreaLoan," +
					"LowRiskBailSum,OriginalPutOutDate,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes,BaseClassifyResult," +
					"ApplyType,BailRate,FinishOrg,OperateOrgID,OperateUserID,OperateDate,Remark,Flag4,PayCurrency,PayDate," +
					"ClassifyResult,ClassifyDate,ClassifyFrequency,AdjustRateType,AdjustRateTerm,FixCyc,RateAdjustCyc," +
					"FZANBalance,ThirdPartyAdd2,ThirdPartyZIP2,ThirdPartyAdd1,ThirdPartyZIP1,TermDate1,TermDate2,TermDate3," +
					"AcceptIntType,Ratio,Describe2,Describe1,ApproveDate,FreezeFlag,CycleFlag ,AssureAgreement,CommunityAgreement ," +
					"AGRILOANCLASSIFY,COMMUNITYTYPE,THIRDPARTY4,INVOICESUM,INVOICECURRENCY,FEECURRENCY,EXPOSURESUM ," +
					"CREDITMANAGEMODE,PROJECTFLAG,AUCTIONFLAG,DEALERCOOPFLAG,CONSTRUCTCONTRACTNO,TRADENAME,COMPPROVIDENTFLAG," +
					"VOUCHCORPFLAG,VOUCHAGGREEMENT,VOUCHCORPNAME,EquipmentSum,CropName,BuildAgreement,ThirdPartyAdd3," +
					"ThirdPartyZIP3,EstateUseYears,OperateYears,RentRatio,LoanType,OldBusinessRate,BAAgreement," +
					"BankGroupFlag,AgriLoanFlag,AFALoanFlag,ApprovalNo,CreditUseInfo,OverdueTerms,UnusualRecord,OverdueTermsSum," +
					"UnusualDeal,ReCreditUseInfo,ReOverdueTerms,ReUnusualRecord,ReOverdueTermsSum,ReUnusualDeal," +
					"CommercialNo,GDSerialNo,RetireLoanType,IsUseConsortPact,TermUseType,MostTermMonth,MostLoanValue," +
					"AccumulationNo,TotalBusinessSum,RiseFallRate,MonthReturnSum,Flowover,PracticeSum,ChangType,ChangeReason) "+
					"select" +
					" SerialNo,'"+order+"',ArtificialNo,RelativeSerialNo,BusinessSum,InputOrgID,InputUserID,InputDate,UpdateDate," +
					"PutOutOrgID,ManageOrgID,ManageUserID,TempSaveFlag,OccurDate,CustomerID,CustomerName,BusinessType,BusinessSubType," +
					"OccurType,FundSource,OperateType,CurrenyList,CurrencyMode,BusinessTypeList,CalculateMode,UseOrgList,FlowReduceFlag," +
					"ContractFlag,SubContractFlag,SelfUseFlag,CreditAggreement,RelativeAgreement,LoanFlag,TotalSum,OurRole,Reversibility," +
					"BillNum,HouseType,LCTermType,RiskAttribute,SureType,SafeGuardType,BusinessCurrency,BusinessProp,TermYear,TermMonth," +
					"TermDay,LGTerm,BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate,ICType,ICCyc,PDGRatio,PDGSum,PDGPayMethod," +
					"PDGPayPeriod,PromisesFeeRatio,PromisesFeeSum,PromisesFeePeriod,PromisesFeeBegin,MFeeRatio,MFeeSum,MFeePayMethod," +
					"AgentFee,DealFee,TotalCast,DiscountInterest,PurchaserInterest,BargainorInterest,DiscountSum,BailRatio,BailCurrency," +
					"BailSum,BailAccount,FineRateType,FineRate,DrawingType,FirstDrawingDate,DrawingPeriod,PayTimes,PayCyc,GracePeriod," +
					"OverDraftPeriod,OldLCNo,OldLCTermType,OldLCCurrency,OldLCSum,OldLCLoadingDate,OldLCValidDate,Direction,Purpose," +
					"PlanalLocation,ImmediacyPaySource,PaySource,CorpusPayMethod,InterestPayMethod,ThirdParty1,ThirdPartyID1,ThirdParty2," +
					"ThirdPartyID2,ThirdParty3,ThirdPartyID3,ThirdPartyRegion,ThirdPartyAccounts,CargoInfo,ProjectName,OperationInfo," +
					"ContextInfo,SecuritiesType,SecuritiesRegion,ConstructionArea,UseArea,Flag1,Flag2,Flag3,TradeContractNo,InvoiceNo," +
					"TradeCurrency,TradeSum,PaymentDate,OperationMode,VouchClass,VouchType,VouchType1,VouchType2,VouchFlag,Warrantor," +
					"WarrantorID,OtherCondition,GuarantyValue,GuarantyRate,BaseEvaluateResult,RiskRate,LowRisk,NationRisk,OtherAreaLoan," +
					"LowRiskBailSum,OriginalPutOutDate,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes,BaseClassifyResult,ApplyType,BailRate," +
					"FinishOrg,OperateOrgID,OperateUserID,OperateDate,Remark,Flag4,PayCurrency,PayDate,ClassifyResult,ClassifyDate," +
					"ClassifyFrequency,AdjustRateType,AdjustRateTerm,FixCyc,RateAdjustCyc,FZANBalance,ThirdPartyAdd2,ThirdPartyZIP2," +
					"ThirdPartyAdd1,ThirdPartyZIP1,TermDate1,TermDate2,TermDate3,AcceptIntType,Ratio,Describe2,Describe1,ApproveDate," +
					"FreezeFlag,CycleFlag ,AssureAgreement,CommunityAgreement ,AGRILOANCLASSIFY,COMMUNITYTYPE,THIRDPARTY4,INVOICESUM," +
					"INVOICECURRENCY,FEECURRENCY,EXPOSURESUM ,CREDITMANAGEMODE,PROJECTFLAG,AUCTIONFLAG,DEALERCOOPFLAG,CONSTRUCTCONTRACTNO," +
					"TRADENAME,COMPPROVIDENTFLAG,VOUCHCORPFLAG,VOUCHAGGREEMENT,VOUCHCORPNAME,EquipmentSum,CropName,BuildAgreement," +
					"ThirdPartyAdd3,ThirdPartyZIP3,EstateUseYears,OperateYears,RentRatio,LoanType,OldBusinessRate,BAAgreement,BankGroupFlag," +
					"AgriLoanFlag,AFALoanFlag,ApprovalNo,CreditUseInfo,OverdueTerms,UnusualRecord,OverdueTermsSum,UnusualDeal," +
					"ReCreditUseInfo,ReOverdueTerms,ReUnusualRecord,ReOverdueTermsSum,ReUnusualDeal,CommercialNo,GDSerialNo,RetireLoanType," +
					"IsUseConsortPact,TermUseType,MostTermMonth,MostLoanValue,AccumulationNo,TotalBusinessSum,RiseFallRate,MonthReturnSum," +
					"Flowover,PracticeSum,ChangType,ChangeReason " +
					" from BUSINESS_CONTRACT as BC " +
					"where BC.SerialNo='"+sSerialNo+"'";
			Sqlca.executeSQL(sSql);
			//更新表APPLY_RELATIVE关联申请编号与新生成的历史合同号order		
			sSql =  " update APPLY_RELATIVE set OBJECTNO = '"+order+"' where SERIALNO='"+sObjectNo+"'" ;
			Sqlca.executeSQL(sSql);
			//更新business_apply的"变更对象"为合同变更ChangeObject=02 add by wangdw 2012-05-31
			sSql =  " update business_apply set ChangeObject = '02' where SERIALNO='"+sObjectNo+"'" ;
			Sqlca.executeSQL(sSql);
		    return "1";
	
		}
		//如果是非公基金贷款
		//合同信息变更
		else if(sObjectType.equals("ContractChange"))
		{
			//从合同表里复制申请信息到新的申请信息中
			sSql = "update business_apply set (BusinessSum,CustomerID,CustomerName,BusinessType,BusinessSubType,OccurType,FundSource," +
					"OperateType,CurrenyList,CurrencyMode,BusinessTypeList,CalculateMode,UseOrgList,FlowReduceFlag,ContractFlag," +
					"SubContractFlag,SelfUseFlag,CreditAggreement,RelativeAgreement,LoanFlag,TotalSum,OurRole,Reversibility,BillNum," +
					"HouseType,LCTermType,RiskAttribute,SureType,SafeGuardType,BusinessCurrency,BusinessProp,TermYear,TermMonth,TermDay," +
					"LGTerm,BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate,ICType,ICCyc,PDGratio,PDGSum,PDGPayMethod," +
					"PDGPayPeriod,PromisesFeeRatio,PromisesFeeSum,PromisesFeePeriod,PromisesFeeBegin,MFeeRatio,MFeeSum,MFeePayMethod," +
					"AgentFee,DealFee,TotalCast,DiscountInterest,PurchaserInterest,BargainorInterest,DiscountSum,BailRatio,BailCurrency," +
					"BailSum,BailAccount,FineRateType,FineRate,DrawingType,FirstDrawingDate,DrawingPeriod,PayTimes,PayCyc,GracePeriod," +
					"OverDraftPeriod,OldLCNo,OldLCTermType,OldLCCurrency,OldLCSum,OldLCLoadingDate,OldLCValidDate,Direction,Purpose," +
					"PlanalLocation,ImmediacyPaySource,PaySource,CorpusPayMethod,InterestPayMethod,ThirdParty1,ThirdPartyID1,ThirdParty2," +
					"ThirdPartyID2,ThirdParty3,ThirdPartyID3,ThirdPartyRegion,ThirdPartyAccounts,CargoInfo,ProjectName,OperationInfo," +
					"ContextInfo,SecuritiesType,SecuritiesRegion,ConstructionArea,UseArea,Flag1,Flag2,Flag3,TradeContractNo,InvoiceNo," +
					"TradeCurrency,TradeSum,PaymentDate,OperationMode,VouchClass,VouchType,VouchType1,VouchType2,VouchFlag,Warrantor," +
					"WarrantorID,OtherCondition,GuarantyValue,GuarantyRate,BaseEvaluateResult,RiskRate,LowRisk,NationRisk,OtherAreaLoan," +
					"LowRiskBailSum,OriginalPutOutDate,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes,BaseClassifyResult,ApplyType,BailRate," +
					"FinishOrg,OperateOrgID,OperateUserID,OperateDate,Remark,Flag4,PayCurrency,PayDate,ClassifyResult,ClassifyDate," +
					"ClassifyFrequency,AdjustRateType,AdjustRateTerm,FixCyc,RateAdjustCyc,FZANBalance,ThirdPartyAdd2,ThirdPartyZIP2," +
					"ThirdPartyAdd1,ThirdPartyZIP1,TermDate1,TermDate2,TermDate3,AcceptIntType,Ratio,Describe2,Describe1,ApproveDate," +
					"CycleFlag,AssureAgreement,CommunityAgreement ,AGRILOANCLASSIFY,COMMUNITYTYPE,THIRDPARTY4,INVOICESUM,INVOICECURRENCY," +
					"FEECURRENCY,EXPOSURESUM ,CREDITMANAGEMODE,PROJECTFLAG,AUCTIONFLAG,DEALERCOOPFLAG,CONSTRUCTCONTRACTNO,TRADENAME," +
					"COMPPROVIDENTFLAG,VOUCHCORPFLAG,VOUCHAGGREEMENT,VOUCHCORPNAME,EquipmentSum,CropName,BuildAgreement,ThirdPartyAdd3," +
					"ThirdPartyZIP3,EstateUseYears,OperateYears,RentRatio,LoanType,OldBusinessRate,BAAgreement,BankGroupFlag,AgriLoanFlag," +
					"AFALoanFlag,ApprovalNo,CreditUseInfo,OverdueTerms,UnusualRecord,OverdueTermsSum,UnusualDeal,ReCreditUseInfo,ReOverdueTerms," +
					"ReUnusualRecord,ReOverdueTermsSum,ReUnusualDeal,CommercialNo,GDSerialNo,RetireLoanType,IsUseConsortPact,TermUseType," +
					"MostTermMonth,MostLoanValue,AccumulationNo,TotalBusinessSum,RiseFallRate,MonthReturnSum,Flowover,PracticeSum,ChangType," +
					"ChangeReason,ERateDate,ChangeObject)" +
					"=(select BusinessSum,CustomerID,CustomerName,BusinessType," +
					"BusinessSubType,'120',FundSource,OperateType,CurrenyList,CurrencyMode,BusinessTypeList,CalculateMode," +
					"UseOrgList,FlowReduceFlag,ContractFlag,SubContractFlag,SelfUseFlag,CreditAggreement,RelativeAgreement,LoanFlag," +
					"TotalSum,OurRole,Reversibility,BillNum,HouseType,LCTermType,RiskAttribute,SureType,SafeGuardType,BusinessCurrency," +
					"BusinessProp,TermYear,TermMonth,TermDay,LGTerm,BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate," +
					"ICType,ICCyc,PDGRatio,PDGSum,PDGPayMethod,PDGPayPeriod,PromisesFeeRatio,PromisesFeeSum,PromisesFeePeriod," +
					"PromisesFeeBegin,MFeeRatio,MFeeSum,MFeePayMethod,AgentFee,DealFee,TotalCast,DiscountInterest,PurchaserInterest," +
					"BargainorInterest,DiscountSum,BailRatio,BailCurrency,BailSum,BailAccount,FineRateType,FineRate,DrawingType," +
					"FirstDrawingDate,DrawingPeriod,PayTimes,PayCyc,GracePeriod,OverDraftPeriod,OldLCNo,OldLCTermType,OldLCCurrency," +
					"OldLCSum,OldLCLoadingDate,OldLCValidDate,Direction,Purpose,PlanalLocation,ImmediacyPaySource,PaySource," +
					"CorpusPayMethod,InterestPayMethod,ThirdParty1,ThirdPartyID1,ThirdParty2,ThirdPartyID2,ThirdParty3,ThirdPartyID3," +
					"ThirdPartyRegion,ThirdPartyAccounts,CargoInfo,ProjectName,OperationInfo,ContextInfo,SecuritiesType,SecuritiesRegion," +
					"ConstructionArea,UseArea,Flag1,Flag2,Flag3,TradeContractNo,InvoiceNo,TradeCurrency,TradeSum,PaymentDate,OperationMode," +
					"VouchClass,VouchType,VouchType1,VouchType2,VouchFlag,Warrantor,WarrantorID,OtherCondition,GuarantyValue,GuarantyRate," +
					"BaseEvaluateResult,RiskRate,LowRisk,NationRisk,OtherAreaLoan,LowRiskBailSum,OriginalPutOutDate,ExtendTimes,LNGOTimes," +
					"GOLNTimes,DRTimes,BaseClassifyResult,ApplyType,BailRate,FinishOrg,OperateOrgID,OperateUserID,OperateDate,Remark,Flag4," +
					"PayCurrency,PayDate,ClassifyResult,ClassifyDate,ClassifyFrequency,AdjustRateType,AdjustRateTerm,FixCyc,RateAdjustCyc," +
					"FZANBalance,ThirdPartyAdd2,ThirdPartyZIP2,ThirdPartyAdd1,ThirdPartyZIP1,TermDate1,TermDate2,TermDate3,AcceptIntType," +
					"Ratio,Describe2,Describe1,ApproveDate,CycleFlag ,AssureAgreement,CommunityAgreement ,AGRILOANCLASSIFY," +
					"COMMUNITYTYPE,THIRDPARTY4,INVOICESUM,INVOICECURRENCY,FEECURRENCY,EXPOSURESUM ,CREDITMANAGEMODE,PROJECTFLAG," +
					"AUCTIONFLAG,DEALERCOOPFLAG,CONSTRUCTCONTRACTNO,TRADENAME,COMPPROVIDENTFLAG,VOUCHCORPFLAG,VOUCHAGGREEMENT,VOUCHCORPNAME," +
					"EquipmentSum,CropName,BuildAgreement,ThirdPartyAdd3,ThirdPartyZIP3,EstateUseYears,OperateYears,RentRatio,LoanType," +
					"OldBusinessRate,BAAgreement,BankGroupFlag,AgriLoanFlag,AFALoanFlag,ApprovalNo,CreditUseInfo,OverdueTerms,UnusualRecord," +
					"OverdueTermsSum,UnusualDeal,ReCreditUseInfo,ReOverdueTerms,ReUnusualRecord,ReOverdueTermsSum,ReUnusualDeal," +
					"CommercialNo,GDSerialNo,RetireLoanType,IsUseConsortPact,TermUseType,MostTermMonth,MostLoanValue,AccumulationNo," +
					"TotalBusinessSum,RiseFallRate,MonthReturnSum,Flowover,PracticeSum,'"+sChangeType+"',ChangeReason,ERateDate,'02' " +
					"from BUSINESS_CONTRACT where SerialNo= '"+sSerialNo+"')where serialno='"+sObjectNo+"'";
			Sqlca.executeSQL(sSql);
			//复制变更合同信息到历史合同信息表
			order = DBFunction.getSerialNo("BUSINESS_CONTRACT_HISTORY","ORDER");
			sSql =  "insert into BUSINESS_CONTRACT_HISTORY (SerialNo,ORDER,ArtificialNo,RelativeSerialNo,BusinessSum," +
			"InputOrgID,InputUserID,InputDate,UpdateDate,PutOutOrgID,ManageOrgID,ManageUserID,TempSaveFlag," +
			"OccurDate,CustomerID,CustomerName,BusinessType,BusinessSubType,OccurType,FundSource,OperateType," +
			"CurrenyList,CurrencyMode,BusinessTypeList,CalculateMode,UseOrgList,FlowReduceFlag,ContractFlag," +
			"SubContractFlag,SelfUseFlag,CreditAggreement,RelativeAgreement,LoanFlag,TotalSum,OurRole,Reversibility," +
			"BillNum,HouseType,LCTermType,RiskAttribute,SureType,SafeGuardType,BusinessCurrency,BusinessProp," +
			"TermYear,TermMonth,TermDay,LGTerm,BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate,ICType," +
			"ICCyc,PDGRatio,PDGSum,PDGPayMethod,PDGPayPeriod,PromisesFeeRatio,PromisesFeeSum,PromisesFeePeriod," +
			"PromisesFeeBegin,MFeeRatio,MFeeSum,MFeePayMethod,AgentFee,DealFee,TotalCast,DiscountInterest," +
			"PurchaserInterest,BargainorInterest,DiscountSum,BailRatio,BailCurrency,BailSum,BailAccount," +
			"FineRateType,FineRate,DrawingType,FirstDrawingDate,DrawingPeriod,PayTimes,PayCyc,GracePeriod," +
			"OverDraftPeriod,OldLCNo,OldLCTermType,OldLCCurrency,OldLCSum,OldLCLoadingDate,OldLCValidDate," +
			"Direction,Purpose,PlanalLocation,ImmediacyPaySource,PaySource,CorpusPayMethod,InterestPayMethod," +
			"ThirdParty1,ThirdPartyID1,ThirdParty2,ThirdPartyID2,ThirdParty3,ThirdPartyID3,ThirdPartyRegion," +
			"ThirdPartyAccounts,CargoInfo,ProjectName,OperationInfo,ContextInfo,SecuritiesType,SecuritiesRegion," +
			"ConstructionArea,UseArea,Flag1,Flag2,Flag3,TradeContractNo,InvoiceNo,TradeCurrency,TradeSum," +
			"PaymentDate,OperationMode,VouchClass,VouchType,VouchType1,VouchType2,VouchFlag,Warrantor,WarrantorID," +
			"OtherCondition,GuarantyValue,GuarantyRate,BaseEvaluateResult,RiskRate,LowRisk,NationRisk,OtherAreaLoan," +
			"LowRiskBailSum,OriginalPutOutDate,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes,BaseClassifyResult," +
			"ApplyType,BailRate,FinishOrg,OperateOrgID,OperateUserID,OperateDate,Remark,Flag4,PayCurrency,PayDate," +
			"ClassifyResult,ClassifyDate,ClassifyFrequency,AdjustRateType,AdjustRateTerm,FixCyc,RateAdjustCyc," +
			"FZANBalance,ThirdPartyAdd2,ThirdPartyZIP2,ThirdPartyAdd1,ThirdPartyZIP1,TermDate1,TermDate2,TermDate3," +
			"AcceptIntType,Ratio,Describe2,Describe1,ApproveDate,FreezeFlag,CycleFlag ,AssureAgreement,CommunityAgreement ," +
			"AGRILOANCLASSIFY,COMMUNITYTYPE,THIRDPARTY4,INVOICESUM,INVOICECURRENCY,FEECURRENCY,EXPOSURESUM ," +
			"CREDITMANAGEMODE,PROJECTFLAG,AUCTIONFLAG,DEALERCOOPFLAG,CONSTRUCTCONTRACTNO,TRADENAME,COMPPROVIDENTFLAG," +
			"VOUCHCORPFLAG,VOUCHAGGREEMENT,VOUCHCORPNAME,EquipmentSum,CropName,BuildAgreement,ThirdPartyAdd3," +
			"ThirdPartyZIP3,EstateUseYears,OperateYears,RentRatio,LoanType,OldBusinessRate,BAAgreement," +
			"BankGroupFlag,AgriLoanFlag,AFALoanFlag,ApprovalNo,CreditUseInfo,OverdueTerms,UnusualRecord,OverdueTermsSum," +
			"UnusualDeal,ReCreditUseInfo,ReOverdueTerms,ReUnusualRecord,ReOverdueTermsSum,ReUnusualDeal," +
			"CommercialNo,GDSerialNo,RetireLoanType,IsUseConsortPact,TermUseType,MostTermMonth,MostLoanValue," +
			"AccumulationNo,TotalBusinessSum,RiseFallRate,MonthReturnSum,Flowover,PracticeSum,ChangType,ChangeReason) "+
			"select" +
			" SerialNo,'"+order+"',ArtificialNo,RelativeSerialNo,BusinessSum,InputOrgID,InputUserID,InputDate,UpdateDate," +
			"PutOutOrgID,ManageOrgID,ManageUserID,TempSaveFlag,OccurDate,CustomerID,CustomerName,BusinessType,BusinessSubType," +
			"OccurType,FundSource,OperateType,CurrenyList,CurrencyMode,BusinessTypeList,CalculateMode,UseOrgList,FlowReduceFlag," +
			"ContractFlag,SubContractFlag,SelfUseFlag,CreditAggreement,RelativeAgreement,LoanFlag,TotalSum,OurRole,Reversibility," +
			"BillNum,HouseType,LCTermType,RiskAttribute,SureType,SafeGuardType,BusinessCurrency,BusinessProp,TermYear,TermMonth," +
			"TermDay,LGTerm,BaseRateType,BaseRate,RateFloatType,RateFloat,BusinessRate,ICType,ICCyc,PDGRatio,PDGSum,PDGPayMethod," +
			"PDGPayPeriod,PromisesFeeRatio,PromisesFeeSum,PromisesFeePeriod,PromisesFeeBegin,MFeeRatio,MFeeSum,MFeePayMethod," +
			"AgentFee,DealFee,TotalCast,DiscountInterest,PurchaserInterest,BargainorInterest,DiscountSum,BailRatio,BailCurrency," +
			"BailSum,BailAccount,FineRateType,FineRate,DrawingType,FirstDrawingDate,DrawingPeriod,PayTimes,PayCyc,GracePeriod," +
			"OverDraftPeriod,OldLCNo,OldLCTermType,OldLCCurrency,OldLCSum,OldLCLoadingDate,OldLCValidDate,Direction,Purpose," +
			"PlanalLocation,ImmediacyPaySource,PaySource,CorpusPayMethod,InterestPayMethod,ThirdParty1,ThirdPartyID1,ThirdParty2," +
			"ThirdPartyID2,ThirdParty3,ThirdPartyID3,ThirdPartyRegion,ThirdPartyAccounts,CargoInfo,ProjectName,OperationInfo," +
			"ContextInfo,SecuritiesType,SecuritiesRegion,ConstructionArea,UseArea,Flag1,Flag2,Flag3,TradeContractNo,InvoiceNo," +
			"TradeCurrency,TradeSum,PaymentDate,OperationMode,VouchClass,VouchType,VouchType1,VouchType2,VouchFlag,Warrantor," +
			"WarrantorID,OtherCondition,GuarantyValue,GuarantyRate,BaseEvaluateResult,RiskRate,LowRisk,NationRisk,OtherAreaLoan," +
			"LowRiskBailSum,OriginalPutOutDate,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes,BaseClassifyResult,ApplyType,BailRate," +
			"FinishOrg,OperateOrgID,OperateUserID,OperateDate,Remark,Flag4,PayCurrency,PayDate,ClassifyResult,ClassifyDate," +
			"ClassifyFrequency,AdjustRateType,AdjustRateTerm,FixCyc,RateAdjustCyc,FZANBalance,ThirdPartyAdd2,ThirdPartyZIP2," +
			"ThirdPartyAdd1,ThirdPartyZIP1,TermDate1,TermDate2,TermDate3,AcceptIntType,Ratio,Describe2,Describe1,ApproveDate," +
			"FreezeFlag,CycleFlag ,AssureAgreement,CommunityAgreement ,AGRILOANCLASSIFY,COMMUNITYTYPE,THIRDPARTY4,INVOICESUM," +
			"INVOICECURRENCY,FEECURRENCY,EXPOSURESUM ,CREDITMANAGEMODE,PROJECTFLAG,AUCTIONFLAG,DEALERCOOPFLAG,CONSTRUCTCONTRACTNO," +
			"TRADENAME,COMPPROVIDENTFLAG,VOUCHCORPFLAG,VOUCHAGGREEMENT,VOUCHCORPNAME,EquipmentSum,CropName,BuildAgreement," +
			"ThirdPartyAdd3,ThirdPartyZIP3,EstateUseYears,OperateYears,RentRatio,LoanType,OldBusinessRate,BAAgreement,BankGroupFlag," +
			"AgriLoanFlag,AFALoanFlag,ApprovalNo,CreditUseInfo,OverdueTerms,UnusualRecord,OverdueTermsSum,UnusualDeal," +
			"ReCreditUseInfo,ReOverdueTerms,ReUnusualRecord,ReOverdueTermsSum,ReUnusualDeal,CommercialNo,GDSerialNo,RetireLoanType," +
			"IsUseConsortPact,TermUseType,MostTermMonth,MostLoanValue,AccumulationNo,TotalBusinessSum,RiseFallRate,MonthReturnSum," +
			"Flowover,PracticeSum,ChangType,ChangeReason " +
			" from BUSINESS_CONTRACT as BC " +
			"where BC.SerialNo='"+sSerialNo+"'";
			Sqlca.executeSQL(sSql);
			//更新表APPLY_RELATIVE关联申请编号与新生成的历史合同号order		
			sSql =  " update APPLY_RELATIVE set OBJECTNO = '"+order+"' where SERIALNO='"+sObjectNo+"'" ;
			Sqlca.executeSQL(sSql);
			return "1";
		}
		//申请信息变更
		else if(sObjectType.equals("ApplyChange"))
		{
			//复制原申请信息到变更后的申请信息号
			sSql = "update business_apply set" +
					" (RELATIVESERIALNO, CUSTOMERNAME, OCCURDATE, CUSTOMERID, BUSINESSTYPE, BUSINESSSUBTYPE, OCCURTYPE, " +
					"FUNDSOURCE, OPERATETYPE, CURRENYLIST, CURRENCYMODE, BUSINESSTYPELIST, CALCULATEMODE, USEORGLIST, CYCLEFLAG," +
					" FLOWREDUCEFLAG, CONTRACTFLAG, SUBCONTRACTFLAG, SELFUSEFLAG, CREDITAGGREEMENT, RELATIVEAGREEMENT, LOANFLAG, " +
					"TOTALSUM, OURROLE, REVERSIBILITY, BILLNUM, HOUSETYPE, LCTERMTYPE, RISKATTRIBUTE, SURETYPE, SAFEGUARDTYPE, BUSINESSCURRENCY," +
					" BUSINESSSUM, BUSINESSPROP, TERMYEAR, TERMMONTH, TERMDAY, LGTERM, BASERATETYPE, BASERATE, RATEFLOATTYPE, RATEFLOAT, BUSINESSRATE," +
					" ICTYPE, ICCYC, PDGRATIO, PDGSUM, PDGPAYMETHOD, PDGPAYPERIOD, PROMISESFEERATIO, PROMISESFEESUM, PROMISESFEEPERIOD, PROMISESFEEBEGIN," +
					" MFEERATIO, MFEESUM, MFEEPAYMETHOD, AGENTFEE, DEALFEE, TOTALCAST, DISCOUNTINTEREST, PURCHASERINTEREST, BARGAINORINTEREST, DISCOUNTSUM, " +
					"BAILRATIO, BAILCURRENCY, BAILSUM, BAILACCOUNT, FINERATETYPE, FINERATE, DRAWINGTYPE, FIRSTDRAWINGDATE, DRAWINGPERIOD, PAYTIMES, PAYCYC, GRACEPERIOD, " +
					"OVERDRAFTPERIOD, OLDLCNO, OLDLCTERMTYPE, OLDLCCURRENCY, OLDLCSUM, OLDLCLOADINGDATE, OLDLCVALIDDATE, DIRECTION, PURPOSE, PLANALLOCATION, IMMEDIACYPAYSOURCE, " +
					"PAYSOURCE, CORPUSPAYMETHOD, INTERESTPAYMETHOD, THIRDPARTY1, THIRDPARTYID1, THIRDPARTY2, THIRDPARTYID2, THIRDPARTY3, THIRDPARTYID3, THIRDPARTYREGION, THIRDPARTYACCOUNTS, " +
					"CARGOINFO, PROJECTNAME, OPERATIONINFO, CONTEXTINFO, SECURITIESTYPE, SECURITIESREGION, CONSTRUCTIONAREA, USEAREA, FLAG1, FLAG2, FLAG3, TRADECONTRACTNO, INVOICENO, TRADECURRENCY, " +
					"TRADESUM, PAYMENTDATE, OPERATIONMODE, VOUCHCLASS, VOUCHTYPE, VOUCHTYPE1, VOUCHTYPE2, VOUCHFLAG, WARRANTOR, WARRANTORID, OTHERCONDITION, GUARANTYVALUE, GUARANTYRATE, BASEEVALUATERESULT, " +
					"RISKRATE, LOWRISK, OTHERAREALOAN, LOWRISKBAILSUM, ORIGINALPUTOUTDATE, EXTENDTIMES, LNGOTIMES, GOLNTIMES, DRTIMES, BASECLASSIFYRESULT, APPLYTYPE, BAILRATE, FINISHORG, OPERATEORGID, OPERATEUSERID, " +
					"OPERATEDATE, INPUTORGID, INPUTUSERID, INPUTDATE, UPDATEDATE, PIGEONHOLEDATE, REMARK, FLAG4, PAYCURRENCY, PAYDATE, DESCRIBE1, DESCRIBE2, CLASSIFYRESULT, CLASSIFYDATE, CLASSIFYFREQUENCY, " +
					"VOUCHNEWFLAG, ADJUSTRATETYPE, ADJUSTRATETERM, RATEADJUSTCYC, FZANBALANCE, ACCEPTINTTYPE, FIXCYC, THIRDPARTYADD1, THIRDPARTYZIP1, THIRDPARTYADD2, THIRDPARTYZIP2, THIRDPARTYADD3, THIRDPARTYZIP3," +
					" EFFECTAREA, TERMDATE1, TERMDATE2, TERMDATE3, RATIO, TEMPSAVEFLAG, CONTRACTEXSITFLAG, AGRILOANCLASSIFY, COMMUNITYTYPE, THIRDPARTY4, INVOICESUM, INVOICECURRENCY, FEECURRENCY, EXPOSURESUM," +
					" CREDITMANAGEMODE, PROJECTFLAG, AUCTIONFLAG, DEALERCOOPFLAG, CONSTRUCTCONTRACTNO, TRADENAME, COMPPROVIDENTFLAG, VOUCHCORPFLAG, VOUCHAGGREEMENT, VOUCHCORPNAME, ORGFLAG, CROPNAME, EQUIPMENTSUM, " +
					"BUILDAGREEMENT, OLDBUSINESSRATE, NATIONRISK, ESTATEUSEYEARS, OPERATEYEARS, RENTRATIO, ASSUREAGREEMENT, COMMUNITYAGREEMENT, LOANTYPE, BAAGREEMENT, BANKGROUPFLAG, APPROVEDATE, AGRILOANFLAG, COMMERCIALNO," +
					" ACCUMULATIONNO, AFALOANFLAG, APPROVEUSERID, APPROVEORGID, APPROVALNO, FINISHAPPROVEUSERID, ISAPPROVEFLAG, GDSERIALNO, RETIRELOANTYPE, CREDITUSEINFO, OVERDUETERMS, UNUSUALRECORD, OVERDUETERMSSUM, UNUSUALDEAL, " +
					"RECREDITUSEINFO, REOVERDUETERMS, REUNUSUALRECORD, REOVERDUETERMSSUM, REUNUSUALDEAL, ISUSECONSORTPACT, TERMUSETYPE, MOSTTERMMONTH, MOSTLOANVALUE, TOTALBUSINESSSUM, RISEFALLRATE, MONTHRETURNSUM, FLOWOVER, PRACTICESUM," +
					" ERATEDATE, CHANGTYPE, CHANGEREASON,ChangeObject)" +
					"=(select RELATIVESERIALNO, CUSTOMERNAME, OCCURDATE, CUSTOMERID, BUSINESSTYPE, BUSINESSSUBTYPE, '120', " +
					"FUNDSOURCE, OPERATETYPE, CURRENYLIST, CURRENCYMODE, BUSINESSTYPELIST, CALCULATEMODE, USEORGLIST, CYCLEFLAG," +
					" FLOWREDUCEFLAG, CONTRACTFLAG, SUBCONTRACTFLAG, SELFUSEFLAG, CREDITAGGREEMENT, RELATIVEAGREEMENT, LOANFLAG, " +
					"TOTALSUM, OURROLE, REVERSIBILITY, BILLNUM, HOUSETYPE, LCTERMTYPE, RISKATTRIBUTE, SURETYPE, SAFEGUARDTYPE, BUSINESSCURRENCY," +
					" BUSINESSSUM, BUSINESSPROP, TERMYEAR, TERMMONTH, TERMDAY, LGTERM, BASERATETYPE, BASERATE, RATEFLOATTYPE, RATEFLOAT, BUSINESSRATE," +
					" ICTYPE, ICCYC, PDGRATIO, PDGSUM, PDGPAYMETHOD, PDGPAYPERIOD, PROMISESFEERATIO, PROMISESFEESUM, PROMISESFEEPERIOD, PROMISESFEEBEGIN," +
					" MFEERATIO, MFEESUM, MFEEPAYMETHOD, AGENTFEE, DEALFEE, TOTALCAST, DISCOUNTINTEREST, PURCHASERINTEREST, BARGAINORINTEREST, DISCOUNTSUM, " +
					"BAILRATIO, BAILCURRENCY, BAILSUM, BAILACCOUNT, FINERATETYPE, FINERATE, DRAWINGTYPE, FIRSTDRAWINGDATE, DRAWINGPERIOD, PAYTIMES, PAYCYC, GRACEPERIOD, " +
					"OVERDRAFTPERIOD, OLDLCNO, OLDLCTERMTYPE, OLDLCCURRENCY, OLDLCSUM, OLDLCLOADINGDATE, OLDLCVALIDDATE, DIRECTION, PURPOSE, PLANALLOCATION, IMMEDIACYPAYSOURCE, " +
					"PAYSOURCE, CORPUSPAYMETHOD, INTERESTPAYMETHOD, THIRDPARTY1, THIRDPARTYID1, THIRDPARTY2, THIRDPARTYID2, THIRDPARTY3, THIRDPARTYID3, THIRDPARTYREGION, THIRDPARTYACCOUNTS, " +
					"CARGOINFO, PROJECTNAME, OPERATIONINFO, CONTEXTINFO, SECURITIESTYPE, SECURITIESREGION, CONSTRUCTIONAREA, USEAREA, FLAG1, FLAG2, FLAG3, TRADECONTRACTNO, INVOICENO, TRADECURRENCY, " +
					"TRADESUM, PAYMENTDATE, OPERATIONMODE, VOUCHCLASS, VOUCHTYPE, VOUCHTYPE1, VOUCHTYPE2, VOUCHFLAG, WARRANTOR, WARRANTORID, OTHERCONDITION, GUARANTYVALUE, GUARANTYRATE, BASEEVALUATERESULT, " +
					"RISKRATE, LOWRISK, OTHERAREALOAN, LOWRISKBAILSUM, ORIGINALPUTOUTDATE, EXTENDTIMES, LNGOTIMES, GOLNTIMES, DRTIMES, BASECLASSIFYRESULT, APPLYTYPE, BAILRATE, FINISHORG, OPERATEORGID, OPERATEUSERID, " +
					"OPERATEDATE, INPUTORGID, INPUTUSERID, INPUTDATE, UPDATEDATE, PIGEONHOLEDATE, REMARK, FLAG4, PAYCURRENCY, PAYDATE, DESCRIBE1, DESCRIBE2, CLASSIFYRESULT, CLASSIFYDATE, CLASSIFYFREQUENCY, " +
					"VOUCHNEWFLAG, ADJUSTRATETYPE, ADJUSTRATETERM, RATEADJUSTCYC, FZANBALANCE, ACCEPTINTTYPE, FIXCYC, THIRDPARTYADD1, THIRDPARTYZIP1, THIRDPARTYADD2, THIRDPARTYZIP2, THIRDPARTYADD3, THIRDPARTYZIP3," +
					" EFFECTAREA, TERMDATE1, TERMDATE2, TERMDATE3, RATIO, TEMPSAVEFLAG, CONTRACTEXSITFLAG, AGRILOANCLASSIFY, COMMUNITYTYPE, THIRDPARTY4, INVOICESUM, INVOICECURRENCY, FEECURRENCY, EXPOSURESUM," +
					" CREDITMANAGEMODE, PROJECTFLAG, AUCTIONFLAG, DEALERCOOPFLAG, CONSTRUCTCONTRACTNO, TRADENAME, COMPPROVIDENTFLAG, VOUCHCORPFLAG, VOUCHAGGREEMENT, VOUCHCORPNAME, ORGFLAG, CROPNAME, EQUIPMENTSUM, " +
					"BUILDAGREEMENT, OLDBUSINESSRATE, NATIONRISK, ESTATEUSEYEARS, OPERATEYEARS, RENTRATIO, ASSUREAGREEMENT, COMMUNITYAGREEMENT, LOANTYPE, BAAGREEMENT, BANKGROUPFLAG, APPROVEDATE, AGRILOANFLAG, COMMERCIALNO," +
					" ACCUMULATIONNO, AFALOANFLAG, APPROVEUSERID, APPROVEORGID, APPROVALNO, FINISHAPPROVEUSERID, ISAPPROVEFLAG, GDSERIALNO, RETIRELOANTYPE, CREDITUSEINFO, OVERDUETERMS, UNUSUALRECORD, OVERDUETERMSSUM, UNUSUALDEAL, " +
					"RECREDITUSEINFO, REOVERDUETERMS, REUNUSUALRECORD, REOVERDUETERMSSUM, REUNUSUALDEAL, ISUSECONSORTPACT, TERMUSETYPE, MOSTTERMMONTH, MOSTLOANVALUE, TOTALBUSINESSSUM, RISEFALLRATE, MONTHRETURNSUM, FLOWOVER, PRACTICESUM," +
					" ERATEDATE, '"+sChangeType+"', CHANGEREASON,'01' " +
					"from business_apply where SerialNo= '"+sSerialNo+"') where serialno='"+sObjectNo+"'";
			Sqlca.executeSQL(sSql);
/*	临时取消 复制担保信息		
			//复制原担保信息生成新的担保合同信息
			//查询原申请信息对应的担保信息
			sSql1 = "select OBJECTNO from APPLY_RELATIVE where objecttype='GuarantyContract' and SERIALNO = '"+sSerialNo+"'";
			rs = Sqlca.getASResultSet(sSql1);
			while(rs.next())
			{
				//复制担保合同信息
				sNewSerialNo = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo","GC",Sqlca);
				sSql = "insert into GUARANTY_CONTRACT (SERIALNO, CONTRACTTYPE, GUARANTYTYPE, CONTRACTSTATUS, CONTRACTNO, SIGNDATE, BEGINDATE, " +
						"ENDDATE, CUSTOMERID, GUARANTORID, GUARANTORNAME, CREDITORGID, CREDITORGNAME, GUARANTYCURRENCY, GUARANTYVALUE, GUARANTYINFO, " +
						"OTHERDESCRIBE, CHECKGUARANTY, RECEPTION, RECEPTIONDUTY, GUARANRYOPINION, CHECKGUARANTYMAN1, CHECKGUARANTYMAN2, INPUTORGID, " +
						"INPUTUSERID, INPUTDATE, UPDATEUSERID, UPDATEDATE, REMARK, CERTTYPE, CERTID, OTHERNAME, LOANCARDNO, GUARANTEEFORM, COMMONDATE, " +
						"VOUCHMETHOD, BAILSUM, CHANNEL, APPLYGUARANTYCONTRACT) " +
						"select '"+sNewSerialNo+"', CONTRACTTYPE, GUARANTYTYPE, CONTRACTSTATUS, CONTRACTNO, SIGNDATE, BEGINDATE, " +
						"ENDDATE, CUSTOMERID, GUARANTORID, GUARANTORNAME, CREDITORGID, CREDITORGNAME, GUARANTYCURRENCY, GUARANTYVALUE, GUARANTYINFO, " +
						"OTHERDESCRIBE, CHECKGUARANTY, RECEPTION, RECEPTIONDUTY, GUARANRYOPINION, CHECKGUARANTYMAN1, CHECKGUARANTYMAN2, INPUTORGID, " +
						"INPUTUSERID, INPUTDATE, UPDATEUSERID, UPDATEDATE, REMARK, CERTTYPE, CERTID, OTHERNAME, LOANCARDNO, GUARANTEEFORM, COMMONDATE, " +
						"VOUCHMETHOD, BAILSUM, CHANNEL, APPLYGUARANTYCONTRACT " +
						"from GUARANTY_CONTRACT where SERIALNO = '"+rs.getString("OBJECTNO")+"'";
				System.out.println("sql===>>"+sSql);
				Sqlca.executeSQL(sSql);
				
				//生成申请编号与担保合同关系信息
				sSql = "insert into APPLY_RELATIVE (SERIALNO,OBJECTTYPE,OBJECTNO) values('"+sObjectNo+"','GuarantyContract','"+sNewSerialNo+"') ";
				Sqlca.executeSQL(sSql);
				//复制担保物信息
				sSql2 = "select GuarantyID,Status,Type from GUARANTY_RELATIVE where CONTRACTNO = '"+rs.getString("OBJECTNO")+"'";
				rs1 = Sqlca.getASResultSet(sSql2);
				while(rs1.next())
				{
						newGuarantyId = DBFunction.getSerialNo("GUARANTY_INFO","GuarantyID","GI",Sqlca);
						sSql3 = "insert into GUARANTY_INFO (GUARANTYID, GUARANTYTYPE, GUARANTYSTATUS, OWNERID, OWNERNAME, OWNERTYPE, RATE, CUSTGUARANTYTYPE, " +
								"SUBJECTNO, RELATIVEACCOUNT, GUARANTYRIGHTID, OTHERGUARANTYRIGHT, GUARANTYNAME, GUARANTYSUBTYPE, GUARANTYOWNWAY, GUARANTYUSING, " +
								"GUARANTYLOCATION, GUARANTYAMOUNT, GUARANTYAMOUNT1, GUARANTYAMOUNT2, GUARANTYRESOUCE, GUARANTYDATE, BEGINDATE, OWNERTIME, " +
								"GUARANTYDESCRIPT, ABOUTOTHERID1, ABOUTOTHERID2, ABOUTOTHERID3, ABOUTOTHERID4, PURPOSE, ABOUTSUM1, ABOUTSUM2, ABOUTRATE, " +
								"GUARANTYANA, GUARANTYPRICE, EVALMETHOD, EVALORGID, EVALORGNAME, EVALDATE, EVALNETVALUE, CONFIRMVALUE, GUARANTYRATE, THIRDPARTY1, " +
								"THIRDPARTY2, THIRDPARTY3, GUARANTYDESCRIBE1, GUARANTYDESCRIBE2, GUARANTYDESCRIBE3, FLAG1, FLAG2, FLAG3, FLAG4, GUARANTYREGNO, " +
								"GUARANTYREGORG, GUARANTYREGDATE, GUARANTYWODATE, INSURECERTNO, OTHERASSUMPSIT, INPUTORGID, INPUTUSERID, INPUTDATE, UPDATEUSERID, " +
								"UPDATEDATE, REMARK, SAPVOUCHTYPE, CERTTYPE, CERTID, LOANCARDNO, GUARANTYCURRENCY, EVALCURRENCY, GUARANTYDESCRIBE4, EVALUNITPRICE, " +
								"HOUSEOWNERTYPE, MACHINETYPE, GOODSUNIT, DEPOTTYPE, REGISTERORGID, DUEPAYTYPE, HOLDTYPE, INSURANCEID, INSURERNAME, INSURANCETYPE, " +
								"BUSINESSNATURE, INSURANCEPROJECT, INSURANCESUM, INSURANCERATIO, INSURANCESUM1, INSURANCESUM2, INSURANCEDAY, INSURANCEBEGINDATE, " +
								"INSURANCEBEGINTIME, INSURANCEENDDATE, INSURANCEENDTIME, PAYDATE, BENEFITPERSON1, SPECIALPROMISE, CLAUSE, INSURANCEREMARK, " +
								"SHARECUSTOMERNAME, SHAREPHONE, SHAREPOSTALCODE, SHAREADDRESS, SHARECONSORTCERTID, SHARECONSORTNAME, SHARECERTID) " +
								"select '"+newGuarantyId+"', GUARANTYTYPE, GUARANTYSTATUS, OWNERID, OWNERNAME, OWNERTYPE, RATE, CUSTGUARANTYTYPE, " +
								"SUBJECTNO, RELATIVEACCOUNT, GUARANTYRIGHTID, OTHERGUARANTYRIGHT, GUARANTYNAME, GUARANTYSUBTYPE, GUARANTYOWNWAY, GUARANTYUSING, " +
								"GUARANTYLOCATION, GUARANTYAMOUNT, GUARANTYAMOUNT1, GUARANTYAMOUNT2, GUARANTYRESOUCE, GUARANTYDATE, BEGINDATE, OWNERTIME, " +
								"GUARANTYDESCRIPT, ABOUTOTHERID1, ABOUTOTHERID2, ABOUTOTHERID3, ABOUTOTHERID4, PURPOSE, ABOUTSUM1, ABOUTSUM2, ABOUTRATE, " +
								"GUARANTYANA, GUARANTYPRICE, EVALMETHOD, EVALORGID, EVALORGNAME, EVALDATE, EVALNETVALUE, CONFIRMVALUE, GUARANTYRATE, THIRDPARTY1, " +
								"THIRDPARTY2, THIRDPARTY3, GUARANTYDESCRIBE1, GUARANTYDESCRIBE2, GUARANTYDESCRIBE3, FLAG1, FLAG2, FLAG3, FLAG4, GUARANTYREGNO, " +
								"GUARANTYREGORG, GUARANTYREGDATE, GUARANTYWODATE, INSURECERTNO, OTHERASSUMPSIT, INPUTORGID, INPUTUSERID, INPUTDATE, UPDATEUSERID, " +
								"UPDATEDATE, REMARK, SAPVOUCHTYPE, CERTTYPE, CERTID, LOANCARDNO, GUARANTYCURRENCY, EVALCURRENCY, GUARANTYDESCRIBE4, EVALUNITPRICE, " +
								"HOUSEOWNERTYPE, MACHINETYPE, GOODSUNIT, DEPOTTYPE, REGISTERORGID, DUEPAYTYPE, HOLDTYPE, INSURANCEID, INSURERNAME, INSURANCETYPE, " +
								"BUSINESSNATURE, INSURANCEPROJECT, INSURANCESUM, INSURANCERATIO, INSURANCESUM1, INSURANCESUM2, INSURANCEDAY, INSURANCEBEGINDATE, " +
								"INSURANCEBEGINTIME, INSURANCEENDDATE, INSURANCEENDTIME, PAYDATE, BENEFITPERSON1, SPECIALPROMISE, CLAUSE, INSURANCEREMARK, " +
								"SHARECUSTOMERNAME, SHAREPHONE, SHAREPOSTALCODE, SHAREADDRESS, SHARECONSORTCERTID, SHARECONSORTNAME, SHARECERTID " +
								"from GUARANTY_INFO where GUARANTYID='"+rs1.getString("GUARANTYID")+"'";
						Sqlca.executeSQL(sSql3);
						//生成担保合同与抵质押物关系信息
						sSql3 = " insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) values ('"+sObjectType+"','"+sObjectNo+"','"+sNewSerialNo+"','"+newGuarantyId+"','Copy','"+rs1.getString("Status")+"','"+rs1.getString("Type")+"')";
						Sqlca.executeSQL(sSql3);
				}
			}
			rs1.getStatement().close();
			rs.getStatement().close();
*/			
			return "1";
		}
		else
		{
			return "0";
		}
	    
	 }

}
