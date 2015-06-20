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

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.util.*;
import com.amarsoft.context.*;

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
		String sSerialNo = DBFunction.getSerialNo("BUSINESS_CONTRACT","SerialNo","",Sqlca);
		//定义变量：SQL语句、关联流水号1、关联流水号2、字段列值
		String sSql = "",sRelativeSerialNo1 = "",sFieldValue = "",sContractObjectType = "";
		//定义变量:总列数、总列数1、字段列类型
		int iColumnCount = 0,iFieldType = 0;
		//定义变量：查询结果集、查询结果集1
		ASResultSet rs = null,rs1 = null;
		//实例化用户对象
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		
		//设置合同对象
		sContractObjectType = "BusinessContract";
		//将空值转化成空字符串
		if(sContractObjectType == null) sContractObjectType = "";
		
		//------------------------------第一步：拷贝批复基本信息到合同中--------------------------------------
		//将批复信息复制到合同信息中
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
					"RateType," +//--added by wwhe 2009-09-02 for:利率类型
					"UnitPrice," +//--added by wwhe 2009-09-02 for:单价
					"HouseTotalPrices," +//--added by wwhe 2009-09-02 for:房屋总价
					"FirstSum," +//--added by wwhe 2009-09-02 for:首付金额
					"FirstProportion, "+//--added by wwhe 2009-09-02 for:首付比例
					"CoreSystemBusinessType "+//--added by wwhe 2009-10-22 for：核心贷款子类型
					",ThirdPartyAdd3, "+ //add by hywu 20110225  国际结算
					"isFirstBatch,"+//--added by ymwu 2012-02-27 for：是否首批
					"TasksFirstBatch,"+//--addedby ymwu 2012-02-27 for：首批笔数
					"TotalSumFirstBatch, "+//--added by ymwu 2012-02-27 for：首批最大金额
					//"Describe3, "+//--added by ymwu 2012-04-01
					"Flag9,"+//added by ymwu 20130120 是否软抵押
					"AllyType, "+//added by ymwu 20130120 联保方式
					"ManageDepartFlag "+//add by ymwu 20130528 业务条线
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
					"RateType," +//--added by wwhe 2009-09-02 for:利率类型
					"UnitPrice," +//--added by wwhe 2009-09-02 for:单价
					"HouseTotalPrices," +//--added by wwhe 2009-09-02 for:房屋总价
					"FirstSum," +//--added by wwhe 2009-09-02 for:首付金额
					"FirstProportion, "+//--added by wwhe 2009-09-02 for:首付比例
					"CoreSystemBusinessType "+//--added by wwhe 2009-10-22 for：核心贷款子类型
					",ThirdPartyAdd3, "+ //add by hywu 20110225  国际结算
					"isFirstBatch,"+//--added by ymwu 2012-02-27 for：是否首批
					"TasksFirstBatch,"+//--added by ymwu 2012-02-27 for：首批笔数
					"TotalSumFirstBatch, "+//--added by ymwu 2012-02-27 for：首批最大金额
					//"Describe3, "+//--added by ymwu 2012-04-01
					"Flag9,"+//added by ymwu 20130120 是否软抵押
					"AllyType, "+//added by ymwu 20130120 联保方式
					"ManageDepartFlag "+//add by ymwu 20130528 业务条线
					"from BUSINESS_APPROVE " +
					"where SerialNo='"+sObjectNo+"'";
		
		Sqlca.executeSQL(sSql);		
		
		//------------------------------第二步：拷贝批复信息所对应的担保信息到合同中--------------------------------------
		/*请注意：在批复的担保信息中存在新增的担保信息和引入最高额的担保信息，因此在进行担保信息拷贝时，
		         将担保信息全拷贝*/
		//查找出批复中引入的最高额担保合同信息，并与批复建立关联
		//(合同状态：ContractStatus－010：未签合同；020－已签合同；030－已失效)	
		sSql =  " select GC.SerialNo,AR.IsImport from GUARANTY_CONTRACT GC ,APPROVE_RELATIVE AR "+
				" where ContractStatus = '020' and AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo ,IsImport) "+
					" values('"+sSerialNo+"','GuarantyContract','"+rs.getString("SerialNo")+"','"+DataConvert.toString(rs.getString("IsImport"))+"') ";
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
		sSql =  " select GC.* from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPROVE_RELATIVE AR "+
				" where AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and GC.ContractStatus = '010' ";
		rs = Sqlca.getASResultSet(sSql);
		//获得担保信息总列数
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得担保信息编号
			sRelativeSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo",Sqlca);
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
		sSql =  " select * from AGENCY_INFO where SerialNo in (select ObjectNo from APPROVE_RELATIVE "+
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
				" select '"+sSerialNo+"',ObjectType,ObjectNo from APPROVE_RELATIVE "+
				" where SerialNo = '"+sObjectNo+"' and ObjectType <> 'GuarantyContract' ";
		Sqlca.executeSQL(sSql);
		
		//------------------------------第二十一步：拷贝综合授信批复所对应的方案明细信息到合同中--------------------------------------					
		sSql =  " update CL_INFO set BCSerialNo = '"+sSerialNo+"' where ApproveSerialNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);	
		
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
