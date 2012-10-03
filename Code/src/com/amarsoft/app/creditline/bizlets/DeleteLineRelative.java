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
import com.amarsoft.app.lending.bizlets.DeleteBusiness;

public class DeleteLineRelative extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ
		String sLineID   = (String)this.getAttribute("LineID");//--�ĵ����
		if(sLineID==null) sLineID="";
		//�������
		String sSql= "",sBCSerialNo = "";
		
		//��ȡ��ͬ��ˮ��
		sBCSerialNo = Sqlca.getString("select BCSerialNo from CL_INFO where LineID = '"+sLineID+"'");
		if(sBCSerialNo == null) sBCSerialNo = "";
		
		System.out.println("---------sBCSerialNo----------"+sBCSerialNo);
		
		//ɾ�����Ŷ����Ϣ
		sSql = 	" update CL_INFO set BCSerialNo = null "+
				" where LineID = '"+sLineID+"' ";
		Sqlca.executeSQL(sSql);
		
	    //ɾ������Э����Ϣ
		Bizlet bzDeleteBusiness = new DeleteBusiness();
		bzDeleteBusiness.setAttribute("ObjectType","BusinessContract"); 
		bzDeleteBusiness.setAttribute("ObjectNo",sBCSerialNo);
		bzDeleteBusiness.setAttribute("DeleteType","DeleteBusiness");
		bzDeleteBusiness.run(Sqlca);		
			
		return null;
	 }
}
