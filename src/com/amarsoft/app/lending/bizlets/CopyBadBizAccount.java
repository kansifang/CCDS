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

public class CopyBadBizAccount extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//获得批复流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");	
		String sDASerilNo = (String)this.getAttribute("DASerilNo");
		
		//将空值转化成空字符串
		if(sObjectNo == null) sObjectNo = "";		
		if(sDASerilNo == null) sDASerilNo = "";	
		//按照合同号生成规则区最新合同号码
		String sSerialNo = DBFunction.getSerialNo("BADBIZAPPLY_ACCOUNT","SerialNo",Sqlca);
		
		//------------------------------第一步：拷贝批复基本信息到合同中--------------------------------------
		//将批复信息复制到合同信息中
		String sSql = " Insert into badbizApply_account (" +
					"SERIALNO," +
					"OBJECTNO," +
					"OBJECTTYPE," +
					"RelativeAccountNo,"+
					"RelativeContractNo," +
					"AccountType,BelongOrgID," +
					"FirstPutOutDate," +
					"AssetName," +
					"LastMaturity," +
					"GainDate," +
					"loanAccountNo," +
					"GainType," +
					"CustomerName," +
					"CustomerID," +
					"SitAddress," +
					"CustomerType," +
					"AssetStatus," +
					"CustomerManageStatus," +
					"AssetAna," +
					"CustomerProperty," +
					"CustomerAttitude," +
					"AssetArea," +
					"DebtInstance," +
					"PropertyFlag," +
					"FactVouchDegree," +
					"GroundTransferFlag," +
					"VouchEffectDate," +
					"ConstructionType," +
					"LawEffectDate," +
					"HousePurpose," +
					"TextDocStatus," +
					"ConstructionArea," +
					"FormerManageName," +
					"PropertyFlag1," +
					"InitializeBalance," +
					"HouseTransferFlag," +
					"DisposeTotalSum," +
					"AssetType," +
					"MoneyReturnSum," +
					"EffectsName," +
					"PayDebtSum," +
					"AssetAmount," +
					"OtherReturnSum," +
					"ExistOrNewFLag," +
					"CleanInterest," +
					"FinalBalance," +
					"FinalInterest," +
					"SaleSum," +
					"FactUser," +
					"HireSum," +
					"CertType," +
					"OtherDisposeSum," +
					"CertID," +
					"LostSum," +
					"VouchMaturity," +
					"ReceiveSum," +
					"LastDunDate," +
					"FinalAccountBalance," +
					"AccountManageDate," +
					"FactValue," +
					"BasicManageDate," +
					"RecoverOrgID," +
					"RecoverUserID," +
					"AccountNeedManage," +
					"IsFinish," +
					"BasicNeedManage," +
					"BadBizFinishDate," +
					"NeedDun," +
					"VDMature," +
					"Ldmature," +
					"LoanType," +
					"ClassifyResult," +
					"MetathesisType," +
					"BadLoanType," +
					"CVDate," +
					"CVReason," +
					"CVBadDebtType," +
					"CVSource," +
					"ReformSBSum," +
					"ReformUpSum," +
					"NotReformUpSum," +
					"CVSum," +
					"MetathesisSum," +
					"CleanInterest1," +
					"CleanInterest2," +
					"ISLawFlag," +
					"ReturnLawSum," +
					"StateFlag," +
					"ReturnLawInterest," +
					"OPERATEUSERID," +
					"OPERATEORGID," +
					"INPUTUSERID," +
					"INPUTORGID," +
					"INPUTDATE," +
					"UPDATEDATE," +
					"REMARK," +
					"REFROMBAFLAG " +
					") " +
					" select " +
					"'"+sSerialNo+"'," +
					"'"+sDASerilNo+"'," +
					"OBJECTTYPE," +
					"SerialNo,"+
					"RelativeContractNo," +
					"AccountType," +
					"BelongOrgID," +
					"FirstPutOutDate," +
					"AssetName," +
					"LastMaturity," +
					"GainDate," +
					"loanAccountNo," +
					"GainType," +
					"CustomerName," +
					"CustomerID," +
					"SitAddress," +
					"CustomerType," +
					"AssetStatus," +
					"CustomerManageStatus," +
					"AssetAna," +
					"CustomerProperty," +
					"CustomerAttitude," +
					"AssetArea," +
					"DebtInstance," +
					"PropertyFlag," +
					"FactVouchDegree," +
					"GroundTransferFlag," +
					"VouchEffectDate," +
					"ConstructionType," +
					"LawEffectDate," +
					"HousePurpose," +
					"TextDocStatus," +
					"ConstructionArea," +
					"FormerManageName," +
					"PropertyFlag1," +
					"InitializeBalance," +
					"HouseTransferFlag," +
					"DisposeTotalSum," +
					"AssetType," +
					"MoneyReturnSum," +
					"EffectsName," +
					"PayDebtSum," +
					"AssetAmount," +
					"OtherReturnSum," +
					"ExistOrNewFLag," +
					"CleanInterest," +
					"FinalBalance," +
					"FinalInterest," +
					"SaleSum," +
					"FactUser," +
					"HireSum," +
					"CertType," +
					"OtherDisposeSum," +
					"CertID," +
					"LostSum," +
					"VouchMaturity," +
					"ReceiveSum," +
					"LastDunDate," +
					"FinalAccountBalance," +
					"AccountManageDate," +
					"FactValue," +
					"BasicManageDate," +
					"RecoverOrgID," +
					"RecoverUserID," +
					"AccountNeedManage," +
					"IsFinish," +
					"BasicNeedManage," +
					"BadBizFinishDate," +
					"NeedDun," +
					"VDMature," +
					"Ldmature," +
					"LoanType," +
					"ClassifyResult," +
					"MetathesisType," +
					"BadLoanType," +
					"CVDate," +
					"CVReason," +
					"CVBadDebtType," +
					"CVSource," +
					"ReformSBSum," +
					"ReformUpSum," +
					"NotReformUpSum," +
					"CVSum," +
					"MetathesisSum," +
					"CleanInterest1," +
					"CleanInterest2," +
					"ISLawFlag," +
					"ReturnLawSum," +
					"StateFlag," +
					"ReturnLawInterest," +
					"OPERATEUSERID," +
					"OPERATEORGID," +
					"INPUTUSERID," +
					"INPUTORGID," +
					"INPUTDATE," +
					"UPDATEDATE," +
					"REMARK," +
					"'3'" +
					"from badbiz_account where SerialNo = '"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);		
		return sSerialNo;
	}
}
