package com.amarsoft.app.lending.bizlets;
/*
		Author: --hlzhang 2011/10/28
		Tester:
		Describe: --删除备份合同;
		Input Param:
				SerialNo:--合同流水号
		Output Param:
				return：返回值（SUCCEEDED --删除成功）

		HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;

public class DeleteBusinessContractBak extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sObjectType = (String)this.getAttribute("ObjectType");

		//将空值转化成空字符串,合同流水号
		if(sSerialNo == null) sSerialNo = "";
		String sSql = "";
		ASResultSet rs = null;
		String sIfEquals = "";//存放比较结果
		if(sObjectType.equals("GuarantyContract"))
		{
			sSql = " with R1 as (select " +
			   " SERIALNO,"+
	    	   " CONTRACTTYPE,"+
	    	   " GUARANTYTYPE,"+
	    	   " CONTRACTSTATUS,"+
	    	   " CONTRACTNO,"+
	    	   " SIGNDATE,"+
	    	   " BEGINDATE,"+
	    	   " ENDDATE,"+
	    	   " CUSTOMERID,"+
	    	   " GUARANTORID,"+            
	    	   " GUARANTORNAME,"+          
	    	   " CREDITORGID,"+            
	    	   " CREDITORGNAME,"+          
	    	   " GUARANTYCURRENCY,"+       
	    	   " GUARANTYVALUE,"+          
	    	   " GUARANTYINFO,"+           
	    	   " OTHERDESCRIBE,"+          
	    	   " CHECKGUARANTY,"+          
	    	   " RECEPTION,"+              
	    	   " RECEPTIONDUTY,"+          
	    	   " GUARANRYOPINION,"+        
	    	   " CHECKGUARANTYMAN1,"+      
	    	   " CHECKGUARANTYMAN2,"+      
	    	   " INPUTORGID,"+             
	    	   " INPUTUSERID,"+            
	    	   " INPUTDATE,"+              
	    	   " UPDATEUSERID,"+           
	    	   " UPDATEDATE,"+             
	    	   " REMARK,"+                 
	    	   " CERTTYPE,"+               
	    	   " CERTID,"+                 
	    	   " OTHERNAME,"+              
	    	   " LOANCARDNO,"+             
	    	   " GUARANTEEFORM,"+          
	    	   " COMMONDATE,"+             
	    	   " VOUCHMETHOD,"+            
	    	   " BAILSUM,"+                
	    	   " CHANNEL "+              
		    " from GUARANTY_CONTRACT where SerialNo = '"+sSerialNo+"')," +
		    " R2 as (SELECT "+
		       " SERIALNO,"+
	    	   " CONTRACTTYPE,"+
	    	   " GUARANTYTYPE,"+
	    	   " CONTRACTSTATUS,"+
	    	   " CONTRACTNO,"+
	    	   " SIGNDATE,"+
	    	   " BEGINDATE,"+
	    	   " ENDDATE,"+
	    	   " CUSTOMERID,"+
	    	   " GUARANTORID,"+            
	    	   " GUARANTORNAME,"+          
	    	   " CREDITORGID,"+            
	    	   " CREDITORGNAME,"+          
	    	   " GUARANTYCURRENCY,"+       
	    	   " GUARANTYVALUE,"+          
	    	   " GUARANTYINFO,"+           
	    	   " OTHERDESCRIBE,"+          
	    	   " CHECKGUARANTY,"+          
	    	   " RECEPTION,"+              
	    	   " RECEPTIONDUTY,"+          
	    	   " GUARANRYOPINION,"+        
	    	   " CHECKGUARANTYMAN1,"+      
	    	   " CHECKGUARANTYMAN2,"+      
	    	   " INPUTORGID,"+             
	    	   " INPUTUSERID,"+            
	    	   " INPUTDATE,"+              
	    	   " UPDATEUSERID,"+           
	    	   " UPDATEDATE,"+             
	    	   " REMARK,"+                 
	    	   " CERTTYPE,"+               
	    	   " CERTID,"+                 
	    	   " OTHERNAME,"+              
	    	   " LOANCARDNO,"+             
	    	   " GUARANTEEFORM,"+          
	    	   " COMMONDATE,"+             
	    	   " VOUCHMETHOD,"+            
	    	   " BAILSUM,"+                
	    	   " CHANNEL "+                
		    " from GUARANTY_CONTRACT_BAK where SerialNo = '"+sSerialNo+"' order by GCBSerialNo desc fetch first 1 rows only) "+
		    " select * from R1 except select * from R2";
			
			rs = Sqlca.getASResultSet(sSql);
			if(rs.getRowCount()==0){
				rs.getStatement().close();
				sIfEquals= "match";
			}else{
				rs.getStatement().close();
				sIfEquals= "changed";
			}
			
			if(sIfEquals.equals("match")) //合同记录未被修改过
			{
				//删除合同备份
				sSql =  " delete from GUARANTY_CONTRACT_BAK BCB " +
						" where  BCB.GCBSerialNo = (select max(GCBSerialNo) " +
						" from GUARANTY_CONTRACT_BAK where SerialNo = '"+sSerialNo+"' )";
				Sqlca.executeSQL(sSql);
			}
		}else if(sObjectType.equals("BusinessPutOut"))
		{
			sSql = " with R1 as (select " +
			   " SERIALNO,"+                  
	 		   " CUSTOMERID,"+                
	 		   " CUSTOMERNAME,"+              
	 		   " BUSINESSTYPE,"+             
	 		   " BUSINESSCURRENCY,"+          
	 		   " BUSINESSSUM,"+               
	 		   " TERMYEAR,"+                
	 		   " TERMMONTH,"+                
	 		   " TERMDAY,"+                 
	 		   " PUTOUTDATE,"+               
	 		   " MATURITY,"+                
	 		   " BUSINESSRATE,"+             
	 		   " ICTYPE,"+                   
	 		   " ICCYC,"+                    
	 		   " PAYCYC,"+                   
	 		   " CORPUSPAYMETHOD,"+           
	 		   " SUBJECTNO,"+                
	 		   " DEALBEGINTIME,"+             
	 		   " DEALENDTIME,"+              
	 		   " DEALFLAG,"+                 
	 		   " OPERATEORGID,"+              
	 		   " OPERATEUSERID,"+              
	 		   " OPERATEDATE,"+               
	 		   " INPUTORGID,"+               
	 		   " INPUTUSERID,"+               
	 		   " INPUTDATE,"+               
	 		   " UPDATEDATE,"+               
	 		   " PIGEONHOLEDATE,"+           
	 		   " REMARK,"+                 
	 		   " OCCURDATE,"+                 
	 		   " BASERATETYPE,"+              
	 		   " BASERATE,"+               
	 		   " RATEFLOATTYPE,"+            
	 		   " RATEFLOAT,"+              
	 		   " CONTRACTSERIALNO,"+          
	 		   " DUEBILLSERIALNO,"+          
	 		   " ARTIFICIALNO,"+            
	 		   " RELATIVEACCOUNTNO,"+         
	 		   " ACCOUNTNO,"+               
	 		   " LOANACCOUNTNO,"+             
	 		   " LOANTYPE,"+             
	 		   " CREDITLINEFLAG,"+           
	 		   " CREDITAGGREEMENT,"+          
	 		   " CONTRACTSUM,"+               
	 		   " PURPOSE,"+              
	 		   " ADJUSTRATETYPE,"+           
	 		   " FIXCYC,"+               
	 		   " BACKRATE,"+                
	 		   " ACCEPTINTTYPE,"+            
	 		   " PREINTTYPE,"+             
	 		   " RESUMEINTTYPE,"+             
	 		   " SECONDPAYACCOUNT,"+          
	 		   " OVERINTTYPE,"+               
	 		   " RATEADJUSTCYC,"+            
	 		   " GUARANTYNO,"+              
	 		   " RISKRATE,"+                
	 		   " CONSIGNACCOUNTNO,"+          
	 		   " MOSTLYDUEBILLNO,"+           
	 		   " NEGOTIATENO,"+              
	 		   " CREDITKIND,"+                
	 		   " PDGSUM,"+                
	 		   " PDGACCOUNTNO,"+             
	 		   " PDGPAYMETHOD,"+             
	 		   " BUSINESSSUBTYPE,"+           
	 		   " BUSINESSSUBTYPE1,"+          
	 		   " EXCHANGETYPE,"+             
	 		   " EXCHANGESTATE,"+            
	 		   " EXCHANGESERIALNO,"+         
	 		   " ADJUSTRATETERM,"+           
	 		   " PROJECTNO,"+               
	 		   " FZACCOUNTNO,"+              
	 		   " FZANBALANCE,"+              
	 		   " CCODE,"+             
	 		   " CDATE,"+             
	 		   " FZGUABALANCE,"+            
	 		   " PZTYPE,"+              
	 		   " BILLNO,"+              
	 		   " GATHERINGNAME,"+             
	 		   " ABOUTBANKNAME,"+             
	 		   " INTERSERIALNO,"+            
	 		   " BILLRESOURCE,"+             
	 		   " BAILACCOUNT,"+              
	 		   " ABOUTBANKID,"+              
	 		   " BILLSUM,"+              
	 		   " RATETYPE,"+             
	 		   " BILLRISK,"+              
	 		   " OPENBANKNAME,"+             
	 		   " OPENBANKADD,"+              
	 		   " OPENBANKZIP,"+              
	 		   " TYPE1,"+                  
	 		   " TYPE2,"+                  
	 		   " TYPE3,"+                   
	 		   " TYPE4,"+                   
	 		   " TYPE5,"+                   
	 		   " TYPE6,"+                   
	 		   " TYPE7,"+                   
	 		   " ABOUTBANKID2,"+              
	 		   " ABOUTBANKNAME2,"+           
	 		   " ABOUTBANKID3,"+              
	 		   " NAME1,"+                  
	 		   " ADDRESS1,"+                  
	 		   " NAME2,"+                  
	 		   " ADDRESS2,"+                 
	 		   " ZIP2,"+                   
	 		   " ADDRESS3,"+                  
	 		   " TERM1,"+                    
	 		   " TERM2,"+                    
	 		   " TERM3,"+                    
	 		   " VOUCHTYPE,"+                
	 		   " BAILCURRENCY,"+              
	 		   " BAILRATIO,"+               
	 		   " MFEEPAYMETHOD,"+           
	 		   " SECURITIESTYPE,"+           
	 		   " TYPE8,"+                  
	 		   " TYPE9,"+                  
	 		   " THIRDPARTYACCOUNTS,"+       
	 		   " THIRDPARTYID1,"+            
	 		   " CCYC,"+                   
	 		   " LOANTERM,"+                
	 		   " RELATIVEPUTOUTNO,"+         
	 		   " PRINTTIMES,"+                
	 		   " TEMPSAVEFLAG,"+             
	 		   " SENDFLAG,"+                 
	 		   " CERTTYPE,"+                
	 		   " CERTID,"+                
	 		   " MATERIALFLAG,"+            
	 		   " APPROVALNO,"+               
	 		   " SPECIALACCOUNT,"+           
	 		   " COUNTERPARTYNAME,"+          
	 		   " COUNTERPARTYBANK,"+         
	 		   " COUNTERPARTYACCOUNT,"+     
	 		   " BAILSUM,"+                 
	 		   " TRADEBACKFLAG,"+           
	 		   " INTERNATIONALAPPROVALFLAG,"+
	 		   " CHECKNOTESFALG,"+           
	 		   " REVIEWFLAG,"+               
	 		   " BAILRATE,"+                 
	 		   " NATIONRISK,"+              
	 		   " ASSUREAGREEMENT,"+        
	 		   " COMMUNITYAGREEMENT,"+      
	 		   " OVERDUERATEFLOAT,"+          
	 		   " OVERDUERATE,"+               
	 		   " TARATEFLOAT,"+              
	 		   " TARATE,"+                
	 		   " PUTOUTORGID,"+             
	 		   " COMMERCIALNO,"+             
	 		   " ACCUMULATIONNO,"+          
	 		   " AFALOANFLAG,"+             
	 		   " SELFPAYMETHOD,"+           
	 		   " BILLAMOUNT,"+               
	 		   //" BAILDATE,"+               
	 		   //" CONSULTNO,"+               
	 		   //" ERATEDATE,"+               
	 		   " CHANGTYPE,"+              
	 		   " CHANGEREASON "+             
	 		   //" CHANGEOBJECT,"+             
	 		   //" CAPITALSOURCE,"+             
	 		   //" CAPITALSOURCENO,"+          
	 		   //" DEDUCTNO,"+                  
	 		   //" LOANORGID"+              
		    " from BUSINESS_PUTOUT where SerialNo = '"+sSerialNo+"')," +
		    " R2 as (SELECT "+
		       " SERIALNO,"+                  
	 		   " CUSTOMERID,"+                
	 		   " CUSTOMERNAME,"+              
	 		   " BUSINESSTYPE,"+             
	 		   " BUSINESSCURRENCY,"+          
	 		   " BUSINESSSUM,"+               
	 		   " TERMYEAR,"+                
	 		   " TERMMONTH,"+                
	 		   " TERMDAY,"+                 
	 		   " PUTOUTDATE,"+               
	 		   " MATURITY,"+                
	 		   " BUSINESSRATE,"+             
	 		   " ICTYPE,"+                   
	 		   " ICCYC,"+                    
	 		   " PAYCYC,"+                   
	 		   " CORPUSPAYMETHOD,"+           
	 		   " SUBJECTNO,"+                
	 		   " DEALBEGINTIME,"+             
	 		   " DEALENDTIME,"+              
	 		   " DEALFLAG,"+                 
	 		   " OPERATEORGID,"+              
	 		   " OPERATEUSERID,"+              
	 		   " OPERATEDATE,"+               
	 		   " INPUTORGID,"+               
	 		   " INPUTUSERID,"+               
	 		   " INPUTDATE,"+               
	 		   " UPDATEDATE,"+               
	 		   " PIGEONHOLEDATE,"+           
	 		   " REMARK,"+                 
	 		   " OCCURDATE,"+                 
	 		   " BASERATETYPE,"+              
	 		   " BASERATE,"+               
	 		   " RATEFLOATTYPE,"+            
	 		   " RATEFLOAT,"+              
	 		   " CONTRACTSERIALNO,"+          
	 		   " DUEBILLSERIALNO,"+          
	 		   " ARTIFICIALNO,"+            
	 		   " RELATIVEACCOUNTNO,"+         
	 		   " ACCOUNTNO,"+               
	 		   " LOANACCOUNTNO,"+             
	 		   " LOANTYPE,"+             
	 		   " CREDITLINEFLAG,"+           
	 		   " CREDITAGGREEMENT,"+          
	 		   " CONTRACTSUM,"+               
	 		   " PURPOSE,"+              
	 		   " ADJUSTRATETYPE,"+           
	 		   " FIXCYC,"+               
	 		   " BACKRATE,"+                
	 		   " ACCEPTINTTYPE,"+            
	 		   " PREINTTYPE,"+             
	 		   " RESUMEINTTYPE,"+             
	 		   " SECONDPAYACCOUNT,"+          
	 		   " OVERINTTYPE,"+               
	 		   " RATEADJUSTCYC,"+            
	 		   " GUARANTYNO,"+              
	 		   " RISKRATE,"+                
	 		   " CONSIGNACCOUNTNO,"+          
	 		   " MOSTLYDUEBILLNO,"+           
	 		   " NEGOTIATENO,"+              
	 		   " CREDITKIND,"+                
	 		   " PDGSUM,"+                
	 		   " PDGACCOUNTNO,"+             
	 		   " PDGPAYMETHOD,"+             
	 		   " BUSINESSSUBTYPE,"+           
	 		   " BUSINESSSUBTYPE1,"+          
	 		   " EXCHANGETYPE,"+             
	 		   " EXCHANGESTATE,"+            
	 		   " EXCHANGESERIALNO,"+         
	 		   " ADJUSTRATETERM,"+           
	 		   " PROJECTNO,"+               
	 		   " FZACCOUNTNO,"+              
	 		   " FZANBALANCE,"+              
	 		   " CCODE,"+             
	 		   " CDATE,"+             
	 		   " FZGUABALANCE,"+            
	 		   " PZTYPE,"+              
	 		   " BILLNO,"+              
	 		   " GATHERINGNAME,"+             
	 		   " ABOUTBANKNAME,"+             
	 		   " INTERSERIALNO,"+            
	 		   " BILLRESOURCE,"+             
	 		   " BAILACCOUNT,"+              
	 		   " ABOUTBANKID,"+              
	 		   " BILLSUM,"+              
	 		   " RATETYPE,"+             
	 		   " BILLRISK,"+              
	 		   " OPENBANKNAME,"+             
	 		   " OPENBANKADD,"+              
	 		   " OPENBANKZIP,"+              
	 		   " TYPE1,"+                  
	 		   " TYPE2,"+                  
	 		   " TYPE3,"+                   
	 		   " TYPE4,"+                   
	 		   " TYPE5,"+                   
	 		   " TYPE6,"+                   
	 		   " TYPE7,"+                   
	 		   " ABOUTBANKID2,"+              
	 		   " ABOUTBANKNAME2,"+           
	 		   " ABOUTBANKID3,"+              
	 		   " NAME1,"+                  
	 		   " ADDRESS1,"+                  
	 		   " NAME2,"+                  
	 		   " ADDRESS2,"+                 
	 		   " ZIP2,"+                   
	 		   " ADDRESS3,"+                  
	 		   " TERM1,"+                    
	 		   " TERM2,"+                    
	 		   " TERM3,"+                    
	 		   " VOUCHTYPE,"+                
	 		   " BAILCURRENCY,"+              
	 		   " BAILRATIO,"+               
	 		   " MFEEPAYMETHOD,"+           
	 		   " SECURITIESTYPE,"+           
	 		   " TYPE8,"+                  
	 		   " TYPE9,"+                  
	 		   " THIRDPARTYACCOUNTS,"+       
	 		   " THIRDPARTYID1,"+            
	 		   " CCYC,"+                   
	 		   " LOANTERM,"+                
	 		   " RELATIVEPUTOUTNO,"+         
	 		   " PRINTTIMES,"+                
	 		   " TEMPSAVEFLAG,"+             
	 		   " SENDFLAG,"+                 
	 		   " CERTTYPE,"+                
	 		   " CERTID,"+                
	 		   " MATERIALFLAG,"+            
	 		   " APPROVALNO,"+               
	 		   " SPECIALACCOUNT,"+           
	 		   " COUNTERPARTYNAME,"+          
	 		   " COUNTERPARTYBANK,"+         
	 		   " COUNTERPARTYACCOUNT,"+     
	 		   " BAILSUM,"+                 
	 		   " TRADEBACKFLAG,"+           
	 		   " INTERNATIONALAPPROVALFLAG,"+
	 		   " CHECKNOTESFALG,"+           
	 		   " REVIEWFLAG,"+               
	 		   " BAILRATE,"+                 
	 		   " NATIONRISK,"+              
	 		   " ASSUREAGREEMENT,"+        
	 		   " COMMUNITYAGREEMENT,"+      
	 		   " OVERDUERATEFLOAT,"+          
	 		   " OVERDUERATE,"+               
	 		   " TARATEFLOAT,"+              
	 		   " TARATE,"+                
	 		   " PUTOUTORGID,"+             
	 		   " COMMERCIALNO,"+             
	 		   " ACCUMULATIONNO,"+          
	 		   " AFALOANFLAG,"+             
	 		   " SELFPAYMETHOD,"+           
	 		   " BILLAMOUNT,"+               
	 		   //" BAILDATE,"+               
	 		   //" CONSULTNO,"+               
	 		   //" ERATEDATE,"+               
	 		   " CHANGTYPE,"+              
	 		   " CHANGEREASON "+             
	 		   //" CHANGEOBJECT,"+             
	 		   //" CAPITALSOURCE,"+             
	 		   //" CAPITALSOURCENO,"+          
	 		   //" DEDUCTNO,"+                  
	 		   //" LOANORGID"+                  
		    " from BUSINESS_PUTOUT_BAK where SerialNo = '"+sSerialNo+"' order by BPBSerialNo desc fetch first 1 rows only) "+
		    " select * from R1 except select * from R2";
			
			rs = Sqlca.getASResultSet(sSql);
			if(rs.getRowCount()==0){
				rs.getStatement().close();
				sIfEquals= "match";
			}else{
				rs.getStatement().close();
				sIfEquals= "changed";
			}
			
			if(sIfEquals.equals("match")) //合同记录未被修改过
			{
				//删除合同备份
				sSql =  " delete from BUSINESS_PUTOUT_BAK BCB " +
						" where  BCB.BPBSerialNo = (select max(BPBSerialNo) " +
						" from BUSINESS_PUTOUT_BAK where SerialNo = '"+sSerialNo+"' )";
				Sqlca.executeSQL(sSql);
			}
		}else if(sObjectType.equals("BusinessContract"))
		{
			sSql = " with R1 as (select " +
			"SerialNo, " +  
			"ArtificialNo, " +  
			"RelativeSerialNo, " + 
			"BusinessSum, " + 
			"InputOrgID, " +
			"InputUserID, " + 
			"InputDate, " + 					
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
			"PutoutDate, " +
			"Maturity, " +
			"Balance, " +
			"NormalBalance, " +
			"OverdueBalance, " +
			"DullBalance, " +
			"BadBalance, " +
			"OverdueDays, " +
			"OverdueRateFloat, " +
			"OverdueRate, " +
			"TARateFloat, " +
			"TARate " +
		    " from BUSINESS_CONTRACT where SerialNo = '"+sSerialNo+"')," +
		    " R2 as (SELECT "+
			"SerialNo, " +  
			"ArtificialNo, " +  
			"RelativeSerialNo, " + 
			"BusinessSum, " + 
			"InputOrgID, " +
			"InputUserID, " + 
			"InputDate, " + 					
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
			"PutoutDate, " +
			"Maturity, " +
			"Balance, " +
			"NormalBalance, " +
			"OverdueBalance, " +
			"DullBalance, " +
			"BadBalance, " +
			"OverdueDays, " +
			"OverdueRateFloat, " +
			"OverdueRate, " +
			"TARateFloat, " +
			"TARate " +
		    " from BUSINESS_CONTRACT_BAK where SerialNo = '"+sSerialNo+"' order by BCSerialNo desc fetch first 1 rows only) "+
		    " select * from R1 except select * from R2";
			
			rs = Sqlca.getASResultSet(sSql);
			if(rs.getRowCount()==0){
				rs.getStatement().close();
				sIfEquals= "match";
			}else{
				rs.getStatement().close();
				sIfEquals= "changed";
			}
			
			if(sIfEquals.equals("match")) //合同记录未被修改过
			{
				//删除合同备份
				sSql =  " delete from BUSINESS_CONTRACT_BAK BCB " +
						" where  BCB.BCSerialNo = (select max(BCSerialNo) " +
						" from BUSINESS_CONTRACT_BAK where SerialNo = '"+sSerialNo+"' )";
				Sqlca.executeSQL(sSql);
			}
		}
		return "SUCCEEDED";
	}
}
