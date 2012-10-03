package com.amarsoft.app.lending.bizlets;
/*
 * Author:lpzhang  2009-9-11 
 * purpose:更新工程机械按揭协议
 * log:  申请阶段也更新该协议 lpzhang 2009-11-4
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateEntAgreementInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//对象编号
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	String sObjectType = (String)this.getAttribute("ObjectType");
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		String sSql ="",sEntAgreementNo = "";
		String sOperateType="",sBusinessCurrency="",sBailAccount="",sUseOrgList="",sThirdPartyAccounts="",sRemark="",sUpdateDate="",sPutOutDate="",sMaturity="";
		double dBailRatio=0.0,dMfeeRatio=0.0,dFineRate=0.0,dBusinessSum=0.0,dTermMonth=0.0,dPromisesfeeSum=0.0,dDealfee=0.0,dPromisesfeeRatio=0.0;
		ASResultSet rs =null;
		
		if(sObjectType.equals("BusinessContract"))
		{
			sEntAgreementNo = Sqlca.getString("select ObjectNo from Contract_Relative where SerialNo ='"+sObjectNo+"' and ObjectType ='ProjectAgreement' ");
			if(sEntAgreementNo == null) sEntAgreementNo="";
			//取得业务信息
			sSql = " select OperateType,BusinessCurrency,BailRatio,MfeeRatio,FineRate,BailAccount,UseOrgList," +
				   " BusinessSum,TermMonth,PromisesfeeSum,Dealfee,PromisesfeeRatio,ThirdPartyAccounts,Remark,PutOutDate,Maturity,UpdateDate" +
				   " from Business_Contract  where SerialNo ='"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sOperateType = rs.getString("OperateType");
				sBusinessCurrency = rs.getString("BusinessCurrency");
				dBailRatio = rs.getDouble("BailRatio");
				dMfeeRatio = rs.getDouble("MfeeRatio");
				dFineRate = rs.getDouble("FineRate");
				sBailAccount = rs.getString("BailAccount");
				dBusinessSum = rs.getDouble("BusinessSum");
				sUseOrgList = rs.getString("UseOrgList");
				dTermMonth = rs.getDouble("TermMonth");
				dPromisesfeeSum = rs.getDouble("PromisesfeeSum");
				dDealfee = rs.getDouble("Dealfee");
				dPromisesfeeRatio = rs.getDouble("PromisesfeeRatio");
				sThirdPartyAccounts = rs.getString("ThirdPartyAccounts");
				sRemark = rs.getString("Remark");
				sPutOutDate = rs.getString("PutOutDate");
				sMaturity = rs.getString("Maturity");
				sUpdateDate = rs.getString("UpdateDate");
				
				if(sOperateType == null) sOperateType ="";
				if(sBusinessCurrency == null) sBusinessCurrency ="";
				if(sBailAccount == null) sBailAccount =""; 
				if(sUseOrgList == null) sUseOrgList ="";
				if(sThirdPartyAccounts == null) sThirdPartyAccounts ="";
				if(sRemark == null) sRemark ="";
				if(sPutOutDate == null) sPutOutDate="";
				if(sMaturity == null) sMaturity="";
				if(sUpdateDate == null) sUpdateDate ="";
			}
			rs.getStatement().close();
			
			sSql = " update Ent_Agreement set LoanType ='"+sOperateType+"', Currency ='"+sBusinessCurrency+"'," +
				   " BailRatio ="+dBailRatio+",CompanyBailRatio ="+dMfeeRatio+",DealerBailRatio ="+dFineRate+"," +
				   " BailAccount ='"+sBailAccount+"',OperateOrgID ='"+sUseOrgList+"',AgreementScale ="+dBusinessSum+"," +
				   " TermMonth ="+dTermMonth+",LoanSum ="+dPromisesfeeSum+",LoanTerm ="+dDealfee+"," +
				   " LoanRatio ="+dPromisesfeeRatio+",Remark ='"+sRemark+"',UpdateDate ='"+sUpdateDate+"'," +
				   " Maturity ='"+sMaturity+"',PutOutDate ='"+sPutOutDate+"'" +
				   " where SerialNo = '"+sEntAgreementNo+"'";
		}else
		{
			
			sEntAgreementNo = Sqlca.getString("select ObjectNo from Apply_Relative where SerialNo ='"+sObjectNo+"' and ObjectType ='ProjectAgreement' ");
			if(sEntAgreementNo == null) sEntAgreementNo="";
			//取得业务信息
			sSql = " select OperateType,BusinessCurrency,BailRatio,MfeeRatio,FineRate,BailAccount,UseOrgList," +
				   " BusinessSum,TermMonth,PromisesfeeSum,Dealfee,PromisesfeeRatio,ThirdPartyAccounts,Remark,UpdateDate" +
				   " from Business_Apply  where SerialNo ='"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sOperateType = rs.getString("OperateType");
				sBusinessCurrency = rs.getString("BusinessCurrency");
				dBailRatio = rs.getDouble("BailRatio");
				dMfeeRatio = rs.getDouble("MfeeRatio");
				dFineRate = rs.getDouble("FineRate");
				sBailAccount = rs.getString("BailAccount");
				dBusinessSum = rs.getDouble("BusinessSum");
				sUseOrgList = rs.getString("UseOrgList");
				dTermMonth = rs.getDouble("TermMonth");
				dPromisesfeeSum = rs.getDouble("PromisesfeeSum");
				dDealfee = rs.getDouble("Dealfee");
				dPromisesfeeRatio = rs.getDouble("PromisesfeeRatio");
				sThirdPartyAccounts = rs.getString("ThirdPartyAccounts");
				sRemark = rs.getString("Remark");
				sUpdateDate = rs.getString("UpdateDate");
				
				if(sOperateType == null) sOperateType ="";
				if(sBusinessCurrency == null) sBusinessCurrency ="";
				if(sBailAccount == null) sBailAccount ="";
				if(sUseOrgList == null) sUseOrgList ="";
				if(sThirdPartyAccounts == null) sThirdPartyAccounts ="";
				if(sRemark == null) sRemark ="";
				if(sUpdateDate == null) sUpdateDate ="";
			}
			rs.getStatement().close();
			
			sSql = " update Ent_Agreement set LoanType ='"+sOperateType+"', Currency ='"+sBusinessCurrency+"'," +
				   " BailRatio ="+dBailRatio+",CompanyBailRatio ="+dMfeeRatio+",DealerBailRatio ="+dFineRate+"," +
				   " BailAccount ='"+sBailAccount+"',OperateOrgID ='"+sUseOrgList+"',AgreementScale ="+dBusinessSum+"," +
				   " TermMonth ="+dTermMonth+",LoanSum ="+dPromisesfeeSum+",LoanTerm ="+dDealfee+"," +
				   " LoanRatio ="+dPromisesfeeRatio+",Remark ='"+sRemark+"',UpdateDate ='"+sUpdateDate+"' " +
				   " where SerialNo = '"+sEntAgreementNo+"'";
		}

		
	    //执行更新语句
	    Sqlca.executeSQL(sSql);
	
	    return "1";
	    
	 }

}