package com.amarsoft.app.lending.bizlets;
/*
Author: --xyong
Tester:
Describe: --检查调查报告是否生成
Input Param:
		CertID：证件号码
		CertType：证件类型
		LoanCardNo:贷款卡
Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckLoanCardNoByCertID extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");
		String sLoanCardNo = (String)this.getAttribute("LoanCardNo");
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		if(sLoanCardNo == null) sLoanCardNo = "";
		
		//返回标志
		String sFlag = "";
		String sExistCustomerName = "";
		String sExistCertType = "";
		String sExistCertID = "";
		ASResultSet rs = null;
		String sSql = " select CustomerName,CertType,CertID from CUSTOMER_INFO where LoanCardNo = '"+sLoanCardNo+"' ";
		rs = Sqlca.getASResultSet(sSql);				
		if(rs.next())
		{
			sExistCustomerName = rs.getString("CustomerName");
			sExistCertType = rs.getString("CertType");
			sExistCertID = rs.getString("CertID");
			if(sExistCustomerName == null) sExistCustomerName = "";
			if(sExistCertType == null) sExistCertType = "";
			if(sExistCertID == null) sExistCertID = "";
		}
		rs.getStatement().close();
		
		if(sExistCustomerName.equals(""))
			sFlag = "Only";
		else
		{
			if(sExistCertType.equals(sCertType)&&sExistCertID.equals(sCertID))
				sFlag = "Only";
			else
				sFlag = "Many";
		}
		
		return sFlag;
	}
}
