package com.lmt.baseapp.flow;

/***
 * added by bzhang �弶�����϶�ɾ�� 2009.06.12
 */
import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.sql.Transaction;
public class DeleteClassifyTask extends Bizlet {

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
			//ɾ���弶�����϶�������Ϣ
			if(sObjectType.equals("ClassifyApply"))
			{
				//ɾ������ģ����Ϣ ������û�У�
				deleteCreditCognTableData("Classify_Data",sObjectType,sObjectNo,Sqlca);
				//ɾ���弶������Ϣ��Ϣ
				deleteCreditCognTableData("Classify_Record",sObjectType,sObjectNo,Sqlca);
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

