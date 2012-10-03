package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CancelSMECusApply extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		
		/*
		 * ɾ�����������Ϣ		  
		*/
		Bizlet bzCancelFlow = new CancelFlow();
		bzCancelFlow.setAttribute("ObjectNo",sObjectNo); 
		bzCancelFlow.run(Sqlca);
		
		/*
		 * ɾ����Ӧ�ͻ���Ϣ		  
		*/
		Bizlet bzDeleteCustomer = new DeleteCustomer();
		bzDeleteCustomer.setAttribute("CustomerID",sObjectNo); 
		bzDeleteCustomer.run(Sqlca);			
				
		return "OK";
	}		
}
