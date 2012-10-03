package com.amarsoft.app.lending.bizlets;
/*
		Author: --xhyong 2011/09/28
		Tester:
		Describe: --ɾ��Ԥ���ź�
		Input Param:
				ObjectType: --��������(ҵ��׶�)��
				ObjectNo: --Ԥ����š�
				SerialNo:--Ԥ����ˮ��
		Output Param:
				return������ֵ��SUCCEEDED --ɾ���ɹ���

		HistoryLog:
 */
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteRiskSignal extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSerialNo = (String)this.getAttribute("SerialNo");

		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
				
		//���ݶ������ͻ�ù�������
		String sSql = " ";
	
			
		//ɾ��������ͬ
		sSql =  " delete from Customer_RiskSignal "+
				" where SerialNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);
		
		//ɾ��������ͬ�����Ѻ��Ĺ�����ϵ
		sSql =  " delete from RISKSIGNAL_RELATIVE "+
				" where ObjectType = '"+sObjectType+"' "+
				" and ObjectNo = '"+sObjectNo+"' "+
				" and SerialNo = '"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
	
		return "SUCCEEDED";
	}
}
