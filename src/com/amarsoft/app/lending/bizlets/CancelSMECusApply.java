package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CancelSMECusApply extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		
		/*
		 * 删除流程相关信息		  
		*/
		Bizlet bzCancelFlow = new CancelFlow();
		bzCancelFlow.setAttribute("ObjectNo",sObjectNo); 
		bzCancelFlow.run(Sqlca);
		
		/*
		 * 删除对应客户信息		  
		*/
		Bizlet bzDeleteCustomer = new DeleteCustomer();
		bzDeleteCustomer.setAttribute("CustomerID",sObjectNo); 
		bzDeleteCustomer.run(Sqlca);			
				
		return "OK";
	}		
}
