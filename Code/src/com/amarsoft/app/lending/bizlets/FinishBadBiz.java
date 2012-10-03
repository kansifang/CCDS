/*
Author:   xhyong 2009/09/14
Tester:
Describe: ����ҵ���϶��Ժ�������Ϣ���и���
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

public class FinishBadBiz extends Bizlet {

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
		
		if(sPhaseType.equals("1040"))//��׼
		{
			sSql = "update BADBIZ_APPLY set PassDate = '"+StringFunction.getToday()+"' where SerialNo = '"+sObjectNo+"'";
		}
		else if(sPhaseType.equals("1030"))//�˻ز�������
		{
			sSql = "update BADBIZ_APPLY set ReturnDate = '"+StringFunction.getToday()+"' where SerialNo = '"+sObjectNo+"'";
		}
		else if(sPhaseType.equals("1050"))//���
		{
			sSql = "update BADBIZ_APPLY set VetoDate = '"+StringFunction.getToday()+"' where SerialNo = '"+sObjectNo+"'";
		}
		Sqlca.executeSQL(sSql);
		
		return "1";

	}

}

