package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CancelFlow extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		
		String sSql = "";
		//ɾ�����̶�����Ϣ
		sSql =  " delete from FLOW_OBJECT where ObjectNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);
			
		//ɾ�����̹�����Ϣ			
		sSql =  " delete from FLOW_TASK where ObjectNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);
				
		return "1";
	}		
}
