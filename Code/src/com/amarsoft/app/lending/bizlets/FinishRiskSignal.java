/*
Author:   xhyong 2011/03/28
Tester:
Describe: Ԥ���ź��϶��Ժ�������Ϣ���и���
Input Param:
		SerialNo: ������ˮ��
		ObjectNo: ������
		sObjectType:��������
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishRiskSignal extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//��ȡ����
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sPhaseType = (String)this.getAttribute("PhaseType");
		
		//����ֵת���ɿ��ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sPhaseType == null) sPhaseType = "";
		String sSql = "";
		//����Ϊ��׼״̬
		if("1040".equals(sPhaseType))//��׼
		{
			sSql = "update RISK_SIGNAL set SignalStatus = '30' where SerialNo = '"+sObjectNo+"'";
			Sqlca.executeSQL(sSql);
		}
		if("1050".equals(sPhaseType))//���
		{
			sSql = "update RISK_SIGNAL set SignalStatus = '40' where SerialNo = '"+sObjectNo+"'";
			Sqlca.executeSQL(sSql);
		}
		
		return "1";

	}

}

