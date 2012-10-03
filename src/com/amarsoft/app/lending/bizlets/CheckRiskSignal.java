/*
		Author: --pliu 2011-09-28
		Tester:
		Describe: --̽���������
		Input Param:
				ObjectType: ��������
				ObjectNo: ������
		Output Param:
				Message��������ʾ��Ϣ
		HistoryLog: lpzhang 2009-8-24 for TJ �Ӽ����
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;

import com.amarsoft.biz.bizlet.Bizlet;

public class CheckRiskSignal extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
        
		 
		//�����������ʾ��Ϣ��SQL��䡢��Ʒ���͡��ͻ�����
		String sMessage = "",sSql = "",sSignalLevel = "", sSignalName = "";
		//�����������ѯ�����
		ASResultSet rs = null;	
		
		
		//��ȡԤ������
		sSql = " select  SignalLevel from  RISK_SIGNAL where SerialNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) { 
			sSignalLevel = rs.getString("SignalLevel");
			//����ֵת���ɿ��ַ���
			if (sSignalLevel == null) sSignalLevel = "";
		}
		rs.getStatement().close();
		if(sSignalLevel=="undefined" || sSignalLevel.length()==0) {
			sMessage  += "Ԥ���ź�������Ϣδ��д��"+"@";
			return sMessage;
		}
		
		//��ȡԤ���ź���Ϣ
		sSql =  " select CR.SignalName as SignalName"+
        " from Customer_RiskSignal CR,Risk_Signal RS,RISKSIGNAL_RELATIVE RR"+
        " where RR.ObjectNo = CR.SerialNo "+
        " and RS.SerialNo=RR.SerialNo and RR.ObjectType='RiskSignal' "+
        " and RS.SerialNo = '"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) { 
			sSignalName = rs.getString("SignalName");
			//����ֵת���ɿ��ַ���
			if (sSignalName == null) sSignalName = "";
		}
		rs.getStatement().close();
		System.out.println(sSignalName);
		if(sSignalName=="undefined" || sSignalName.length()==0) {
			sMessage  += "û��Ԥ���ź���Ϣ��"+"@";
			return sMessage;
		}
		
		return sMessage;

		

		
	}
	
	
}
