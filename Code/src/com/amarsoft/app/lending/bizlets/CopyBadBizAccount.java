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

public class CopyBadBizAccount extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//���������ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");	
		String sDASerilNo = (String)this.getAttribute("DASerilNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectNo == null) sObjectNo = "";		
		if(sDASerilNo == null) sDASerilNo = "";	
		//���պ�ͬ�����ɹ��������º�ͬ����
		String sSerialNo = DBFunction.getSerialNo("BADBIZAPPLY_ACCOUNT","SerialNo",Sqlca);
		
		//------------------------------��һ������������������Ϣ����ͬ��--------------------------------------
		//��������Ϣ���Ƶ���ͬ��Ϣ��
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
