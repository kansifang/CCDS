package com.amarsoft.app.lending.bizlets;
/*
	Author: --hlzhang 2011/10/28
	Tester:
	Describe: --将合同插入到备份合同表中;
	Input Param:
	Output Param:
			return：返回值（1 --插入数据成功）
	
	HistoryLog:
*/

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddBusinessContractBak extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		//合同备份表流水号
		String sBCBSerialNo = (String)this.getAttribute("BCBSerialNo");	
		//合同流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//当前机构
		String sOrgID = (String)this.getAttribute("OrgID");
		//当前操作员
		String sUserID = (String)this.getAttribute("UserID");
		//对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");

		//将空值转化为空字符串
		if(sBCBSerialNo == null) sBCBSerialNo = "";		
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";		
		if(sOrgID == null) sOrgID = "";
		if(sUserID == null) sUserID = "";
		
		//获得当前时间
	    //String sCurDate = StringFunction.getToday();
	    String sSql = "";
	    if(sObjectType.equals("GuarantyContract"))
	    {
	    	sSql = " insert into GUARANTY_CONTRACT_BAK( "+
	    		   " GCBSERIALNO,"+
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
		    	   " CHANNEL,"+                
		    	   " ModifyOrgID, " +
				   " ModifyUserID " +
		    	   " ) " +
		    	   " select " +
		    	   " '" +sBCBSerialNo+ "'," +  
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
		    	   " CHANNEL,"+                
		    	   " '"+ sOrgID+ "' , " +
				   " '"+ sUserID+ "'  " +
		    	   " from GUARANTY_CONTRACT " +
		    	   " where serialno = '"+sObjectNo+"' ";
	    	Sqlca.executeSQL(sSql);
	    }else if(sObjectType.equals("BusinessPutOut"))
	    {
	    	sSql = " insert into BUSINESS_PUTOUT_BAK( "+
	    		   " BPBSERIALNO,"+
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
	    		   " CHANGEREASON,"+             
	    		   //" CHANGEOBJECT,"+             
	    		   //" CAPITALSOURCE,"+             
	    		   //" CAPITALSOURCENO,"+          
	    		   //" DEDUCTNO,"+                  
	    		   //" LOANORGID,"+                 
	    		   " ModifyORGID,"+               
	    		   " ModifyUSERID "+              
		    	   " ) " +
		    	   " select " +
		    	   " '" +sBCBSerialNo+ "'," +  
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
	    		   " CHANGEREASON,"+             
	    		   //" CHANGEOBJECT,"+             
	    		   //" CAPITALSOURCE,"+             
	    		   //" CAPITALSOURCENO,"+          
	    		   //" DEDUCTNO,"+                  
	    		   //" LOANORGID,"+               
		    	   " '"+ sOrgID+ "' , " +
				   " '"+ sUserID+ "'  " +
		    	   " from BUSINESS_PUTOUT " +
		    	   " where serialno = '"+sObjectNo+"' ";
	    	Sqlca.executeSQL(sSql);
	    }else if(sObjectType.equals("BusinessContract"))
	    {
		    sSql =	" insert into BUSINESS_CONTRACT_BAK( "+
		    		" BCSerialNo, " +  
				    " SerialNo, " +  
					" ArtificialNo, " +  
					" RelativeSerialNo, " + 
					" BusinessSum, " + 
					" InputOrgID, " +
					" InputUserID, " + 
					" InputDate, " + 					
					" PutOutOrgID, " + 
					" ManageOrgID, " + 
					" ManageUserID, " + 
					" TempSaveFlag, " +
					" OccurDate, " +
					" CustomerID, " +
					" CustomerName, " +
					" BusinessType, " +
					" BusinessSubType, " +
					" OccurType, " +
					" FundSource, " +
					" OperateType, " +
					" CurrenyList, " +
					" CurrencyMode, " +
					" BusinessTypeList, " +
					" CalculateMode, " +
					" UseOrgList, " +					
					" FlowReduceFlag, " +
					" ContractFlag, " +
					" SubContractFlag, " +
					" SelfUseFlag, " +
					" CreditAggreement, " +
					" RelativeAgreement, " +
					" LoanFlag, " +
					" TotalSum, " +
					" OurRole, " +
					" Reversibility, " +
					" BillNum, " +
					" HouseType, " +
					" LCTermType, " +
					" RiskAttribute, " +
					" SureType, " +
					" SafeGuardType, " +
					" BusinessCurrency, " +
					" BusinessProp, " +
					" TermYear, " +
					" TermMonth, " +
					" TermDay, " +
					" LGTerm, " +
					" BaseRateType, " +
					" BaseRate, " +
					" RateFloatType, " +
					" RateFloat, " +
					" BusinessRate, " +
					" ICType, " +
					" ICCyc, " +
					" PDGRatio, " +
					" PDGSum, " +
					" PDGPayMethod, " +
					" PDGPayPeriod, " +
					" PromisesFeeRatio, " +
					" PromisesFeeSum, " +
					" PromisesFeePeriod, " +
					" PromisesFeeBegin, " +
					" MFeeRatio, " +
					" MFeeSum, " +
					" MFeePayMethod, " +
					" AgentFee, " +
					" DealFee, " +
					" TotalCast, " +
					" DiscountInterest, " +
					" PurchaserInterest, " +
					" BargainorInterest, " +
					" DiscountSum, " +
					" BailRatio, " +
					" BailCurrency, " +
					" BailSum, " +
					" BailAccount, " +
					" FineRateType, " +
					" FineRate, " +
					" DrawingType, " +
					" FirstDrawingDate, " +
					" DrawingPeriod, " +
					" PayTimes, " +
					" PayCyc, " +
					" GracePeriod, " +
					" OverDraftPeriod, " +
					" OldLCNo, " +
					" OldLCTermType, " +
					" OldLCCurrency, " +
					" OldLCSum, " +
					" OldLCLoadingDate, " +
					" OldLCValidDate, " +
					" Direction, " +
					" Purpose, " +
					" PlanalLocation, " +
					" ImmediacyPaySource, " +
					" PaySource, " +
					" CorpusPayMethod, " +
					" InterestPayMethod, " +
					" ThirdParty1, " +
					" ThirdPartyID1, " +
					" ThirdParty2, " +
					" ThirdPartyID2, " +
					" ThirdParty3, " +
					" ThirdPartyID3, " +
					" ThirdPartyRegion, " +
					" ThirdPartyAccounts, " +
					" CargoInfo, " +
					" ProjectName, " +
					" OperationInfo, " +
					" ContextInfo, " +
					" SecuritiesType, " +
					" SecuritiesRegion, " +
					" ConstructionArea, " +
					" UseArea, " +
					" Flag1, " +
					" Flag2, " +
					" Flag3, " +
					" TradeContractNo, " +
					" InvoiceNo, " +
					" TradeCurrency, " +
					" TradeSum, " +
					" PaymentDate, " +
					" OperationMode, " +
					" VouchClass, " +
					" VouchType, " +
					" VouchType1, " +
					" VouchType2, " +
					" VouchFlag, " +
					" Warrantor, " +
					" WarrantorID, " +
					" OtherCondition, " +
					" GuarantyValue, " +
					" GuarantyRate, " +
					" BaseEvaluateResult, " +
					" RiskRate, " +
					" LowRisk, " +
					" NationRisk, " +
					" OtherAreaLoan, " +
					" LowRiskBailSum, " +
					" OriginalPutOutDate, " +
					" ExtendTimes, " +
					" LNGOTimes, " +
					" GOLNTimes, " +
					" DRTimes, " +
					" BaseClassifyResult, " +
					" ApplyType, " +
					" BailRate, " +
					" FinishOrg, " +
					" OperateOrgID, " +
					" OperateUserID, " +
					" OperateDate, " +
					" Remark, " +
					" Flag4, " +
					" PayCurrency, " +
					" PayDate, "+
					" ClassifyResult, "+
					" ClassifyDate, "+
					" ClassifyFrequency, "+
					" AdjustRateType, "+ 
					" AdjustRateTerm, "+ 
					" FixCyc, "+ 
					" RateAdjustCyc, "+ 
					" FZANBalance, "+ 
					" ThirdPartyAdd2, "+ 
					" ThirdPartyZIP2, "+ 
					" ThirdPartyAdd1, "+ 
					" ThirdPartyZIP1, "+ 
					" TermDate1, "+ 
					" TermDate2, "+ 
					" TermDate3, "+
					" AcceptIntType, "+ 
					" Ratio, "+ 
					" Describe2, "+
					" Describe1, "+
					" ApproveDate, " +
					" FreezeFlag, " +					
					" CycleFlag ," +	
					" AssureAgreement, " +					
					" CommunityAgreement ," +	
					" AGRILOANCLASSIFY,"+
					" COMMUNITYTYPE,"+
					" THIRDPARTY4,"+
					" INVOICESUM,"+
					" INVOICECURRENCY,"+
					" FEECURRENCY,"+
					" EXPOSURESUM ,"+
					" CREDITMANAGEMODE,"+
					" PROJECTFLAG,"+
					" AUCTIONFLAG,"+
					" DEALERCOOPFLAG,"+
					" CONSTRUCTCONTRACTNO,"+
					" TRADENAME,"+
					" COMPPROVIDENTFLAG,"+
					" VOUCHCORPFLAG,"+
					" VOUCHAGGREEMENT,"+
					" VOUCHCORPNAME,"+
					" EquipmentSum,"+
					" CropName,"+
					" BuildAgreement,"+
					" ThirdPartyAdd3, "+
					" ThirdPartyZIP3,"+
					" EstateUseYears, "+
					" OperateYears, "+
					" RentRatio, "+
					" LoanType, "+
					" OldBusinessRate, "+
					" BAAgreement, "+
					" BankGroupFlag, "+
					" AgriLoanFlag, "+
					" AFALoanFlag, "+
					" ApprovalNo, "+
					" CreditUseInfo, " +
					" OverdueTerms, " +
					" UnusualRecord, " +
					" OverdueTermsSum, " +
					" UnusualDeal, " +
					" ReCreditUseInfo, " +
					" ReOverdueTerms, " +
					" ReUnusualRecord, " +
					" ReOverdueTermsSum, " +
					" ReUnusualDeal, " +
					" CommercialNo, "+
					" GDSerialNo, " +
					" RetireLoanType, " +
					" IsUseConsortPact, " +
					" TermUseType, " +
					" MostTermMonth, " +
					" MostLoanValue, " +
					" AccumulationNo, "+
					" TotalBusinessSum, " +
					" RiseFallRate, " +
					" MonthReturnSum, " +
					" PutoutDate, " +
					" Maturity, " +
					" Balance, " +
					" NormalBalance, " +
					" OverdueBalance, " +
					" DullBalance, " +
					" BadBalance, " +
					" OverdueDays, " +
					" OverdueRateFloat, " +
					" OverdueRate, " +
					" TARateFloat, " +
					" TARate, " +
					" UpdateDate," +
					" PigeonholeDate, " +
					" UpdateOrgID, " +
					" UpdateUserID " +
		    		" ) " +
		    		" select " +
		    		" '" +sBCBSerialNo+ "'," +  
		    		" SerialNo, " +  
					" ArtificialNo, " +  
					" RelativeSerialNo, " + 
					" BusinessSum, " + 
					" InputOrgID, " +
					" InputUserID, " + 
					" InputDate, " + 					
					" PutOutOrgID, " + 
					" ManageOrgID, " + 
					" ManageUserID, " + 
					" TempSaveFlag, " +
					" OccurDate, " +
					" CustomerID, " +
					" CustomerName, " +
					" BusinessType, " +
					" BusinessSubType, " +
					" OccurType, " +
					" FundSource, " +
					" OperateType, " +
					" CurrenyList, " +
					" CurrencyMode, " +
					" BusinessTypeList, " +
					" CalculateMode, " +
					" UseOrgList, " +					
					" FlowReduceFlag, " +
					" ContractFlag, " +
					" SubContractFlag, " +
					" SelfUseFlag, " +
					" CreditAggreement, " +
					" RelativeAgreement, " +
					" LoanFlag, " +
					" TotalSum, " +
					" OurRole, " +
					" Reversibility, " +
					" BillNum, " +
					" HouseType, " +
					" LCTermType, " +
					" RiskAttribute, " +
					" SureType, " +
					" SafeGuardType, " +
					" BusinessCurrency, " +
					" BusinessProp, " +
					" TermYear, " +
					" TermMonth, " +
					" TermDay, " +
					" LGTerm, " +
					" BaseRateType, " +
					" BaseRate, " +
					" RateFloatType, " +
					" RateFloat, " +
					" BusinessRate, " +
					" ICType, " +
					" ICCyc, " +
					" PDGRatio, " +
					" PDGSum, " +
					" PDGPayMethod, " +
					" PDGPayPeriod, " +
					" PromisesFeeRatio, " +
					" PromisesFeeSum, " +
					" PromisesFeePeriod, " +
					" PromisesFeeBegin, " +
					" MFeeRatio, " +
					" MFeeSum, " +
					" MFeePayMethod, " +
					" AgentFee, " +
					" DealFee, " +
					" TotalCast, " +
					" DiscountInterest, " +
					" PurchaserInterest, " +
					" BargainorInterest, " +
					" DiscountSum, " +
					" BailRatio, " +
					" BailCurrency, " +
					" BailSum, " +
					" BailAccount, " +
					" FineRateType, " +
					" FineRate, " +
					" DrawingType, " +
					" FirstDrawingDate, " +
					" DrawingPeriod, " +
					" PayTimes, " +
					" PayCyc, " +
					" GracePeriod, " +
					" OverDraftPeriod, " +
					" OldLCNo, " +
					" OldLCTermType, " +
					" OldLCCurrency, " +
					" OldLCSum, " +
					" OldLCLoadingDate, " +
					" OldLCValidDate, " +
					" Direction, " +
					" Purpose, " +
					" PlanalLocation, " +
					" ImmediacyPaySource, " +
					" PaySource, " +
					" CorpusPayMethod, " +
					" InterestPayMethod, " +
					" ThirdParty1, " +
					" ThirdPartyID1, " +
					" ThirdParty2, " +
					" ThirdPartyID2, " +
					" ThirdParty3, " +
					" ThirdPartyID3, " +
					" ThirdPartyRegion, " +
					" ThirdPartyAccounts, " +
					" CargoInfo, " +
					" ProjectName, " +
					" OperationInfo, " +
					" ContextInfo, " +
					" SecuritiesType, " +
					" SecuritiesRegion, " +
					" ConstructionArea, " +
					" UseArea, " +
					" Flag1, " +
					" Flag2, " +
					" Flag3, " +
					" TradeContractNo, " +
					" InvoiceNo, " +
					" TradeCurrency, " +
					" TradeSum, " +
					" PaymentDate, " +
					" OperationMode, " +
					" VouchClass, " +
					" VouchType, " +
					" VouchType1, " +
					" VouchType2, " +
					" VouchFlag, " +
					" Warrantor, " +
					" WarrantorID, " +
					" OtherCondition, " +
					" GuarantyValue, " +
					" GuarantyRate, " +
					" BaseEvaluateResult, " +
					" RiskRate, " +
					" LowRisk, " +
					" NationRisk, " +
					" OtherAreaLoan, " +
					" LowRiskBailSum, " +
					" OriginalPutOutDate, " +
					" ExtendTimes, " +
					" LNGOTimes, " +
					" GOLNTimes, " +
					" DRTimes, " +
					" BaseClassifyResult, " +
					" ApplyType, " +
					" BailRate, " +
					" FinishOrg, " +
					" OperateOrgID, " +
					" OperateUserID, " +
					" OperateDate, " +
					" Remark, " +
					" Flag4, " +
					" PayCurrency, " +
					" PayDate, "+
					" ClassifyResult, "+
					" ClassifyDate, "+
					" ClassifyFrequency, "+
					" AdjustRateType, "+ 
					" AdjustRateTerm, "+ 
					" FixCyc, "+ 
					" RateAdjustCyc, "+ 
					" FZANBalance, "+ 
					" ThirdPartyAdd2, "+ 
					" ThirdPartyZIP2, "+ 
					" ThirdPartyAdd1, "+ 
					" ThirdPartyZIP1, "+ 
					" TermDate1, "+ 
					" TermDate2, "+ 
					" TermDate3, "+
					" AcceptIntType, "+ 
					" Ratio, "+ 
					" Describe2, "+
					" Describe1, "+
					" ApproveDate, " +
					" FreezeFlag, " +					
					" CycleFlag ," +	
					" AssureAgreement, " +					
					" CommunityAgreement ," +	
					" AGRILOANCLASSIFY,"+
					" COMMUNITYTYPE,"+
					" THIRDPARTY4,"+
					" INVOICESUM,"+
					" INVOICECURRENCY,"+
					" FEECURRENCY,"+
					" EXPOSURESUM ,"+
					" CREDITMANAGEMODE,"+
					" PROJECTFLAG,"+
					" AUCTIONFLAG,"+
					" DEALERCOOPFLAG,"+
					" CONSTRUCTCONTRACTNO,"+
					" TRADENAME,"+
					" COMPPROVIDENTFLAG,"+
					" VOUCHCORPFLAG,"+
					" VOUCHAGGREEMENT,"+
					" VOUCHCORPNAME,"+
					" EquipmentSum,"+
					" CropName,"+
					" BuildAgreement,"+
					" ThirdPartyAdd3, "+
					" ThirdPartyZIP3,"+
					" EstateUseYears, "+
					" OperateYears, "+
					" RentRatio, "+
					" LoanType, "+
					" OldBusinessRate, "+
					" BAAgreement, "+
					" BankGroupFlag, "+
					" AgriLoanFlag, "+
					" AFALoanFlag, "+
					" ApprovalNo, "+
					" CreditUseInfo, " +
					" OverdueTerms, " +
					" UnusualRecord, " +
					" OverdueTermsSum, " +
					" UnusualDeal, " +
					" ReCreditUseInfo, " +
					" ReOverdueTerms, " +
					" ReUnusualRecord, " +
					" ReOverdueTermsSum, " +
					" ReUnusualDeal, " +
					" CommercialNo, "+
					" GDSerialNo, " +
					" RetireLoanType, " +
					" IsUseConsortPact, " +
					" TermUseType, " +
					" MostTermMonth, " +
					" MostLoanValue, " +
					" AccumulationNo, "+
					" TotalBusinessSum, " +
					" RiseFallRate, " +
					" MonthReturnSum, " +
					" PutoutDate, " +
					" Maturity, " +
					" Balance, " +
					" NormalBalance, " +
					" OverdueBalance, " +
					" DullBalance, " +
					" BadBalance, " +
					" OverdueDays, " +
					" OverdueRateFloat, " +
					" OverdueRate, " +
					" TARateFloat, " +
					" TARate, " +
					" UpdateDate," +
					" PigeonholeDate, " +
					" '"+ sOrgID+ "' , " +
					" '"+ sUserID+ "'  " +
		    		" from BUSINESS_CONTRACT " +
		    		" where serialno = '"+sObjectNo+"' ";
		    Sqlca.executeSQL(sSql);
	    }
		return "1";			
	}	
}
