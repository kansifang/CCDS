package com.amarsoft.app.lending.bizlets;
/*
Author: --jbye 2006-11-22
Tester:
Describe: --�����������õȼ��������
Input Param:
		sObjectType����������
		sObjectNo��������
Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateLastEva extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//�Զ���ô���Ĳ���ֵ
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSourceValue = (String)this.getAttribute("SourceValue");
		String sAccountMonth = (String)this.getAttribute("sAccountMonth");
		
		if(sSerialNo == null) sSerialNo = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSourceValue == null) sSourceValue = "";
		if(sAccountMonth == null) sAccountMonth = "";
		//Ĭ��Ϊ֧�����õȼ�
		if(sSourceValue == "" || sSourceValue.equals("")){
			sSourceValue = sSourceValue.replaceAll(sSourceValue,"CognResult4");
		}
		
		//���ر�־
		String sResult = "",sFlag = "";
		//ȡ�ö�Ӧ���
		sResult = Sqlca.getString("select "+sSourceValue+" from EVALUATE_RECORD where SerialNo='"+sSerialNo+"'");
		//�������½��
		Sqlca.executeSQL("Update ENT_INFO set CreditLevel = '"+sResult+"',EvaluateDate = '"+sAccountMonth+"'  where CustomerID = '"+sObjectNo+"'");
		return sFlag;
	}
}
