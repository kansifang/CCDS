package com.amarsoft.app.creditline.bizlets;
/*
Author: --jbye 2005-09-01 9:51
Tester:
Describe: --ɾ�����������Ϣ
Input Param:
		sLineID������Э����

Output Param:

HistoryLog:
*/
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteCLLimitationRelative extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ
		String sLineID   = (String)this.getAttribute("LineID");//--�ĵ����
		if(sLineID==null) sLineID="";
		//�������
		String sSql= "";
		//ɾ������������������Ϣ
		sSql = "delete from CL_LIMITATION_SET where LineID = '"+sLineID+"'"; 
		Sqlca.executeSQL(sSql);
		//ɾ����������������Ϣ
	    sSql = "delete from CL_LIMITATION where LineID = '"+sLineID+"'"; 
		Sqlca.executeSQL(sSql);
		return null;
	 }
}
