package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class DeleteUser extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ		
		String sUserID   = (String)this.getAttribute("UserID");
				
		//�������		
		String sSql = null;
		//�߼�ɾ���û��������û�״̬��Ϊͣ��
		sSql="update USER_INFO set Status = '2' where UserID = '"+sUserID+"'";
		Sqlca.executeSQL(sSql);
	    
		//ɾ���û��Ľ�ɫ
	    sSql = 	" delete from USER_ROLE where UserID = '"+sUserID+"' ";
	    //ִ��ɾ�����
	    Sqlca.executeSQL(sSql);
	    
	    //ɾ���û���Ȩ��
	    sSql = 	" delete from USER_RIGHT where UserID = '"+sUserID+"' ";
	    //ִ��ɾ�����
	    Sqlca.executeSQL(sSql);
	    
	    return "1";
	 }

}
