package com.amarsoft.app.lending.bizlets;
/*
Author: --��ҵ� 2005-08-03
Tester:
Describe: --ɾ���ĵ�������Ϣ
Input Param:
		sDocNo���ĵ����

Output Param:

HistoryLog:
*/
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class DelDocRelative extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ
		String sDocNo = (String)this.getAttribute("DocNo");//--�ĵ����
		if(sDocNo == null) sDocNo = "";
		//�������
		String sSql = " delete from DOC_RELATIVE where DocNo = '"+sDocNo+"' ";
		Sqlca.executeSQL(sSql);
		sSql = " delete from DOC_ATTACHMENT  where DocNo = '"+sDocNo+"' ";
	    Sqlca.executeSQL(sSql);
	    return null;
	 }
}
