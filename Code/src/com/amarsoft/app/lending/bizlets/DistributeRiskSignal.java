/*
		Author: --zywei 2006-08-18
		Tester:
		Describe: ���µ���Ѻ��״̬�����������/����ۼ�
		Input Param:
			GuarantyID������Ѻ����
			GuarantyStatus������Ѻ��״̬
			UserID���Ǽ��˱��	
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.biz.bizlet.Bizlet;


public class DistributeRiskSignal extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";			
		String sCheckUser   = (String)this.getAttribute("CheckUser");
		if(sCheckUser == null) sCheckUser = "";		
				
		//�������
		String sCheckOrg = "",sCheckDate = "",sUpdateSql = "",sInsertSql = "";
				
		//��ȡϵͳ����
		sCheckDate = StringFunction.getToday();
		//��ȡ�û����ڻ���
		ASUser CurUser = new ASUser(sCheckUser,Sqlca);
		sCheckOrg = CurUser.OrgID;
		//���Ԥ����Ϣ�ַ���ˮ��
		String sROSerialNo = DBFunction.getSerialNo("RISKSIGNAL_OPINION","SerialNo","",Sqlca);
		
		//����Ԥ���źŵ�Ԥ��״̬
		sUpdateSql = " update RISK_SIGNAL set SignalStatus = '20' "+
					 " where SerialNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sUpdateSql);
		
		sInsertSql = " insert into RISKSIGNAL_OPINION(ObjectNo,SerialNo,CheckUser,CheckOrg,CheckDate) "+
					 " values ('"+sObjectNo+"','"+sROSerialNo+"','"+sCheckUser+"','"+sCheckOrg+"', "+
					 " '"+sCheckDate+"') ";		
		Sqlca.executeSQL(sInsertSql);
		return "1";
	 }
}
