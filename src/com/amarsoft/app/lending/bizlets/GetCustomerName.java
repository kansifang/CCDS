package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetCustomerName extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		// TODO Auto-generated method stub
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sCustomerName = null;
		String sSql = null;
		
		if(sCustomerID!=null) {
			sSql = "select CustomerID from CUSTOMER_BELONG where CustomerID='"+sCustomerID+"'";
			sCustomerName = Sqlca.getString(sSql);
			 
		}
		return sCustomerName;
	}

}
