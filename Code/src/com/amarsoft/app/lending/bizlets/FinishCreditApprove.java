/*
Author:   xhyong 2011/05/12
Tester:
Describe: ����ҵ�����������Ϣ���и���
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

public class FinishCreditApprove extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//��ȡ����
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sOrgID = (String)this.getAttribute("ObjectType");
		//����ֵת���ɿ��ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		//�Զ������:sql
		String sSql = "";
		sSql = "update BUSINESS_APPLY set FinishApproveUserID = '"+sOrgID+"' where SerialNo = '"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
		
		return "1";

	}

}

