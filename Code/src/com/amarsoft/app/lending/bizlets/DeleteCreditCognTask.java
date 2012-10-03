package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteCreditCognTask extends Bizlet {

	private String sObjectTable = "";
	private String sRelativeTable = ""; 
	public Object run(Transaction Sqlca) throws Exception {
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
			//ɾ�����õȼ��϶�������Ϣ2009-04-03
			if(sObjectType.equals("Customer"))
			{
				//ɾ�����ն�������ϸ��Ϣ
				deleteCreditCognTableData("Evaluate_Data",sObjectType,sObjectNo,Sqlca);
				//ɾ�����ն�������Ϣ
				deleteCreditCognTableData("Evaluate_Record",sObjectType,sObjectNo,Sqlca);
				//ɾ�����̶�����Ϣ				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//ɾ������������Ϣ
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
			}

		}

		return "1";
	}
	private void deleteCreditCognTableData(String sTableName,String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception
	{
		String sSql = "";
		sSql = " delete from "+sTableName+" where ObjectType = '"+sObjectType+"' "+
		" and serialno = '"+sObjectNo+"' ";
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql); 
	}
	//ɾ����ObjectType,ObjectNo��Ϊ����ı�
	private void deleteTableData(String sTableName,String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		sSql = " delete from "+sTableName+" where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"' ";
		//ִ��ɾ�����
		Sqlca.executeSQL(sSql); 
	}


}
