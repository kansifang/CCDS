package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteCustomer extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//将空值转化为空字符串
		if(sCustomerID == null) sCustomerID = "";
		
		String sSql = "",sCustomerType = "";//Sql语句		
		
		sSql = "select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'";
		sCustomerType = Sqlca.getString(sSql);
		
		if(sCustomerType!=null)
		{
			//删除客户公用信息			
			sSql = 	" delete from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
			Sqlca.executeSQL(sSql);
			
			if(sCustomerType.startsWith("01"))
			{	
				//删除公司客户信息
				sSql = 	" delete from ENT_INFO where CustomerID = '"+sCustomerID+"' ";
				Sqlca.executeSQL(sSql);
			}else if(sCustomerType.startsWith("03"))
			{
				//删除个人客户信息
				sSql = 	" delete from IND_INFO where CustomerID = '"+sCustomerID+"' ";
				Sqlca.executeSQL(sSql);
			}
		}
		
		return "1";
	}		
}
