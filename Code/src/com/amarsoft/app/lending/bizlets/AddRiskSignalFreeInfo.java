/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --������׼��Ԥ����Ϣ���Ƶ�Ԥ����Ϣ�����
		Input Param:
				ObjectNo: ��׼��Ԥ����Ϣ���				
		Output Param:
				SerialNo����ˮ��
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.util.StringFunction;


public class AddRiskSignalFreeInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{		
		//�������׼Ԥ����Ϣ��ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//��ȡ��ǰ�û�
		String sUserID = (String)this.getAttribute("UserID");
		
		//����ֵת���ɿ��ַ���		
		if(sObjectNo == null) sObjectNo = "";		
		if(sUserID == null) sUserID = "";
		
		//�����ˮ��
		String sSerialNo = DBFunction.getSerialNo("RISK_SIGNAL","SerialNo","RS",Sqlca);
		//���������SQL���
		String sSql = "";		
						
		//ʵ�����û�����
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		
		//������׼����Ϣ���Ƶ�Ԥ����Ϣ�����
		sSql =  "insert into RISK_SIGNAL ( "+
					"ObjectType, "+          
					"ObjectNo, "+
					"SerialNo, "+
					"RelativeSerialNo, "+ 
					"SignalType, "+
					"SignalStatus, "+
					"InputOrgID, "+
					"InputUserID, "+
					"InputDate, "+
					"UpdateDate, "+
					"Remark, "+
					"SignalNo, "+
					"SignalName, "+
					"MessageOrigin, "+ 
					"MessageContent, "+
					"ActionFlag, "+
					"ActionType, "+											
					"FreeReason, "+
					"SignalChannel,"+
					"SignalLevel,"+
					"CustomerBalance,"+
					"BailSum,"+
					"CustomerOpenBalance,"+
					"ApproveDate,"+
					"CreditLevel,"+
					"AlarmApplyDate)"+
					"select "+ 
					"ObjectType, "+          
					"ObjectNo, "+
					"'"+sSerialNo+"', "+
					"'"+sObjectNo+"', "+ 
					"'02', "+
					"'10', "+
					"'"+CurUser.OrgID+"', " + 
					"'"+CurUser.UserID+"', " +
					"'"+StringFunction.getToday()+"', " + 
					"'"+StringFunction.getToday()+"', " + 
					"'', "+
					"SignalNo, "+
					"SignalName, "+
					"MessageOrigin, "+ 
					"'', "+
					"ActionFlag, "+
					"ActionType, "+		
					"FreeReason, "+
					"SignalChannel, "+
					"SignalLevel,"+
					"CustomerBalance,"+
					"BailSum,"+
					"CustomerOpenBalance,"+
					"ApproveDate,"+
					"CreditLevel,"+
					"AlarmApplyDate "+
					"from RISK_SIGNAL " +
					"where SerialNo='"+sObjectNo+"'";
		System.out.println("------------------------------------"+sSql);
		Sqlca.executeSQL(sSql);	
		//��Ԥ�������е�Ԥ����Ϣ�����������
		//��ʼ��Ԥ��������Ϣ
		sSql =  "insert into RISKSIGNAL_RELATIVE( " +
								"SerialNo,"+
								"ObjectType,"+
								"ObjectNo "+
								" )select " +
								"'"+sSerialNo+"'," +
								" ObjectType," +
								" ObjectNo " +
								" from RISKSIGNAL_RELATIVE " +
								" where SerialNo='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);	
		
		//��ʼ������
		InitializeFlow InitializeFlow_RiskSignalFree = new InitializeFlow();
		InitializeFlow_RiskSignalFree.setAttribute("ObjectType","RiskSignalApply");
		InitializeFlow_RiskSignalFree.setAttribute("ObjectNo",sSerialNo); 
		InitializeFlow_RiskSignalFree.setAttribute("ApplyType","RiskSignalFApply");
		InitializeFlow_RiskSignalFree.setAttribute("FlowNo","RiskSignalFreeFlow");
		InitializeFlow_RiskSignalFree.setAttribute("PhaseNo","0010");
		InitializeFlow_RiskSignalFree.setAttribute("UserID",CurUser.UserID);
		InitializeFlow_RiskSignalFree.setAttribute("OrgID",CurUser.OrgID);
		InitializeFlow_RiskSignalFree.run(Sqlca);

		return sSerialNo;
	}	
}
