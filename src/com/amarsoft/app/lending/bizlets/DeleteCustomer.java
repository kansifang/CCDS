package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteCustomer extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		
		String sSql = "",sCustomerType = "";//Sql���		
		
		sSql = "select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'";
		sCustomerType = Sqlca.getString(sSql);
		
		if(sCustomerType!=null)
		{
			//ɾ���ͻ�������Ϣ			
			sSql = 	" delete from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
			Sqlca.executeSQL(sSql);
			
			if(sCustomerType.startsWith("01"))
			{	
				//ɾ����˾�ͻ���Ϣ
				sSql = 	" delete from ENT_INFO where CustomerID = '"+sCustomerID+"' ";
				Sqlca.executeSQL(sSql);
			}else if(sCustomerType.startsWith("03"))
			{
				//ɾ�����˿ͻ���Ϣ
				sSql = 	" delete from IND_INFO where CustomerID = '"+sCustomerID+"' ";
				Sqlca.executeSQL(sSql);
			}
		}
		
		return "1";
	}		
}
