/*
		Author: --xhyong 2011/03/31
		Tester:
		Describe: --����Ԥ���źŷ���
		Input Param:		
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


public class AddRiskSignalInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{		
		//�������׼Ԥ����Ϣ��ˮ��
		String sUserID = (String)this.getAttribute("UserID");
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//����ֵת���ɿ��ַ���		
		if(sUserID == null) sUserID = "";		
		if(sCustomerID == null) sCustomerID = "";	
		//�����ˮ��
		String sSerialNo = DBFunction.getSerialNo("RISK_SIGNAL","SerialNo","RS",Sqlca);
		//���������SQL���
		String sSql = "";		
						
		//ʵ�����û�����
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		
		//��ʼ��Ԥ���źŻ�����Ϣ
		sSql =  "insert into RISK_SIGNAL ( "+
					"ObjectType,"+
					"ObjectNo,"+
					"SerialNo, "+
					"SignalType, "+
					"SignalStatus, "+
					"InputOrgID, "+
					"InputUserID, "+
					"InputDate ) values("+
					"'Customer',"+
					"'"+sCustomerID+"', "+
					"'"+sSerialNo+"', "+
					"'01', "+
					"'10', "+
					"'"+CurUser.OrgID+"', " + 
					"'"+CurUser.UserID+"', " +
					"'"+StringFunction.getToday()+"' )";
		Sqlca.executeSQL(sSql);	
		//��ʼ������
		InitializeFlow InitializeFlow_RiskSignalFree = new InitializeFlow();
		InitializeFlow_RiskSignalFree.setAttribute("ObjectType","RiskSignalApply");
		InitializeFlow_RiskSignalFree.setAttribute("ObjectNo",sSerialNo); 
		InitializeFlow_RiskSignalFree.setAttribute("ApplyType","RiskSignalApply");
		InitializeFlow_RiskSignalFree.setAttribute("FlowNo","RiskSignalFlow");
		InitializeFlow_RiskSignalFree.setAttribute("PhaseNo","0010");
		InitializeFlow_RiskSignalFree.setAttribute("UserID",CurUser.UserID);
		InitializeFlow_RiskSignalFree.setAttribute("OrgID",CurUser.OrgID);
		InitializeFlow_RiskSignalFree.run(Sqlca);
				
		return sSerialNo;
	}	
}
