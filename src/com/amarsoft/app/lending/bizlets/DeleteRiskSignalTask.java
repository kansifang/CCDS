package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong 2011/03/17
Tester:
Describe: --ɾ��Ԥ���ź�;
Input Param:
		ObjectType: --��������(��������)
		ObjectNo:--Ԥ����ˮ��
		DeleteType��ɾ������
Output Param:
		return������ֵ��1 --ɾ���ɹ���

HistoryLog:
*/
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteRiskSignalTask extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//�Զ���ô���Ĳ���ֵ		
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sDeleteType = (String)this.getAttribute("DeleteType");
		//����ֵת���ɿ��ַ���		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sDeleteType == null) sDeleteType = "";
		//�������:sql,Ԥ������ 01 ���� 02 ���
		String sSql = "",sSignalType = "";
		ASResultSet rs = null;
		//ɾ������
		if(sDeleteType.equals("DeleteTask"))
		{
			//ɾ��Ԥ���ź�������Ϣ
			if(sObjectType.equals("RiskSignalApply"))
			{
				//��ѯԤ��������Ϣ
				sSql = " select SignalType from RISK_SIGNAL where SerialNo = '"+sObjectNo+"' ";
				rs = Sqlca.getASResultSet(sSql);
				if (rs.next()) { 
					sSignalType=rs.getString("SignalType");
				}
				rs.getStatement().close();
				if("01".equals(sSignalType))
				{
					//ɾ��Ԥ��������Ϣ
					sSql = " delete from Customer_RiskSignal " +
							"where SerialNo in(select ObjectNo from RISKSIGNAL_RELATIVE " +
							"where ObjectType='RiskSignal' and SerialNo='"+sObjectNo+"') ";
					Sqlca.executeSQL(sSql);
				}
				//ɾ��Ԥ��������Ϣ
				sSql = " delete from RISK_SIGNAL where SerialNo = '"+sObjectNo+"' ";
				Sqlca.executeSQL(sSql);
				//ɾ��Ԥ��������Ϣ
				sSql = " delete from RISKSIGNAL_RELATIVE where ObjectType='RiskSignal' and SerialNo = '"+sObjectNo+"' ";
				Sqlca.executeSQL(sSql);
				//ɾ��Ԥ��������Ϣ
				sSql = " delete from RISK_SIGNAL where SerialNo = '"+sObjectNo+"' ";
				Sqlca.executeSQL(sSql);
				//ɾ��Ԥ��������Ϣ
				sSql = " delete from RISK_SIGNAL where SerialNo = '"+sObjectNo+"' ";
				Sqlca.executeSQL(sSql);
				
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
