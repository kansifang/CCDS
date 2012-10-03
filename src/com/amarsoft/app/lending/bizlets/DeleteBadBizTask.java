package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong 2009/09/07
Tester:
Describe: --ɾ������ҵ������;
Input Param:
		ObjectType: --��������(��������)
		ObjectNo:--������ˮ��
		DeleteType��ɾ������
Output Param:
		return������ֵ��1 --ɾ���ɹ���

HistoryLog:
*/
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteBadBizTask extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//�Զ���ô���Ĳ���ֵ		
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sDeleteType = (String)this.getAttribute("DeleteType");
		//����ֵת���ɿ��ַ���		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sDeleteType == null) sDeleteType = "";
		//�������:
		String sSql = "";
		//ɾ������
		if(sDeleteType.equals("DeleteTask"))
		{
			//ɾ�����շ����϶�������Ϣ2009-04-03
			if(sObjectType.equals("BadBizApply"))
			{
				//ɾ������ҵ��������Ϣ
				sSql = " delete from BADBIZ_APPLY where SerialNo = '"+sObjectNo+"' ";
				Sqlca.executeSQL(sSql);
				//ɾ������ҵ�������Ϣ
				sSql = " delete from BADBIZ_RELATIVE where SerialNo = '"+sObjectNo+"' ";
				Sqlca.executeSQL(sSql);
				//ɾ�����ϰ�����Ϣ
				deleteTableData("LAWCASE_INFO",sObjectType,sObjectNo,Sqlca);
				//ɾ����ծ�ʲ���Ϣ��
				deleteTableData("ASSET_INFO",sObjectType,sObjectNo,Sqlca);
				//ɾ����������������Ϣ��
				deleteTableData("ASSET_BIZ",sObjectType,sObjectNo,Sqlca);
				//ɾ�������Ϣ��		
				deleteTableData("Flow_OPINION",sObjectType,sObjectNo,Sqlca);
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
