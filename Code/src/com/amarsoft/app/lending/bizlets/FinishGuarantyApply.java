/*
Author:   wangdw 2012/07/24
Tester:
Describe: ����Ѻ�������������������Ϣ
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

public class FinishGuarantyApply extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//��ȡ����
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sPhaseType = (String)this.getAttribute("PhaseType");
		String sAPPROVEUSERID = "";//����������
		String sAPPROVEORGID = "";//������������
		String sAPPROVEOPINION = "";//�����������
		String sFinalTime = "";//��������ʱ��
		
		//����ֵת���ɿ��ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sPhaseType == null) sPhaseType = "";
		String sSql = "";
		ASResultSet rs=null;
		sSql = "select userid,orgid,phaseaction,endtime from Flow_Task where objectno = '"+sObjectNo+"' and phaseno = '0040'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sAPPROVEUSERID = rs.getString("userid");
			sAPPROVEORGID = rs.getString("orgid");
			sAPPROVEOPINION = rs.getString("phaseaction");
			sFinalTime = rs.getString("endtime");
		}
		rs.getStatement().close();
		sSql = "update Guaranty_Apply set APPROVEUSERID = '"+sAPPROVEUSERID+"',APPROVEORGID ='"+sAPPROVEORGID+"' ,APPROVEOPINION ='"+sAPPROVEOPINION+"',FinalTime ='"+sFinalTime+"' where SerialNo = '"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
		return "1";

	}

}

