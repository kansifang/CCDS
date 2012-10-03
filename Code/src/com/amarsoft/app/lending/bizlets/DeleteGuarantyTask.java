package com.amarsoft.app.lending.bizlets;
/*
Author: --wangdw 2012/08/07
Tester:
Describe: --ɾ������Ѻ������������Ϣ;
Input Param:
		ObjectType: --��������(�������������)
		ObjectNo:--�������ˮ��
		DeleteType��ɾ������
Output Param:
		return������ֵ��1 --ɾ���ɹ���

HistoryLog:
*/
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteGuarantyTask extends Bizlet 
{
	private String sObjectTable = "";
	private String sRelativeTable = ""; 
	private String sRelativeNo = ""; 
	public Object  run(Transaction Sqlca) throws Exception
	{		
		//�Զ���ô���Ĳ���ֵ		
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sDeleteType = (String)this.getAttribute("DeleteType");
		//����ֵת���ɿ��ַ���		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sDeleteType == null) sDeleteType = "";
		//ɾ������
		if(sDeleteType.equals("DeleteTask"))
		{
			//ɾ������ѺƷ�����������Ϣ��  add by wangdw 2012-7-13
			if(sObjectType.equals("GuarantyOutApply")||sObjectType.equals("GuarantyInApply"))
			{
				deleteGuaranty_Apply(sObjectType,sObjectNo,Sqlca);
			}
		} 
		return "1";
	}
	//ɾ������Ѻ������������Ϣ  add by  wangdw 2012-7-13
	private void deleteGuaranty_Apply(String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		sSql = " delete from Guaranty_Apply where ObjectType = '"+sObjectType+"' "+
		" and serialno = '"+sObjectNo+"' ";
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql); 
	}
}
