package com.amarsoft.app.lending.bizlets;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckLoanCardNoChangeCustomer extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sLoanCardNo = (String)this.getAttribute("LoanCardNo");
		if(sCustomerID == null) sCustomerID = "";
		if(sLoanCardNo == null) sLoanCardNo = "";
		
		//返回标志
		String sFlag = "";
		
		String sSql = " select CustomerID from CUSTOMER_INFO where LoanCardNo = '"+sLoanCardNo+"' ";
		String sExistCustomerID = Sqlca.getString(sSql);
		if(sExistCustomerID == null) sExistCustomerID = "";
		
		if(sExistCustomerID.equals(""))
			sFlag = "Only";
		else
		{
			if(sExistCustomerID.equals(sCustomerID))
				sFlag = "Only";
			else
				sFlag = "Many";
		}
		
		return sFlag;
	}
}
