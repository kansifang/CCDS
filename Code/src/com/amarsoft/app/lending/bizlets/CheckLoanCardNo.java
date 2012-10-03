package com.amarsoft.app.lending.bizlets;
/*
Author: --��ҵ� 2005-08-03
Tester:
Describe: --�����鱨���Ƿ�����
Input Param:
		sObjectType����������
		sObjectNo��������
Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckLoanCardNo extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//�Զ���ô���Ĳ���ֵ
		String sCustomerName = (String)this.getAttribute("CustomerName");
		String sLoanCardNo = (String)this.getAttribute("LoanCardNo");
		if(sCustomerName == null) sCustomerName = "";
		if(sLoanCardNo == null) sLoanCardNo = "";
		
		//���ر�־
		String sFlag = "";
		
		String sSql = " select CustomerName from CUSTOMER_INFO where LoanCardNo = '"+sLoanCardNo+"' ";
		String sExistCustomerName = Sqlca.getString(sSql);
		if(sExistCustomerName == null) sExistCustomerName = "";
		
		if(sExistCustomerName.equals(""))
			sFlag = "Only";
		else
		{
			if(sExistCustomerName.equals(sCustomerName))
				sFlag = "Only";
			else
				sFlag = "Many";
		}
		
		return sFlag;
	}
}
