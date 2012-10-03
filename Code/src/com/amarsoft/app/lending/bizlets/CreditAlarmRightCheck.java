package com.amarsoft.app.lending.bizlets;
/*
Author: --bqliu 2011-05-27
Tester:
Describe: --����Ԥ��Ȩ���ж�
Input Param:
		SerialNo��������ˮ��
		CustomerID����ǰ��ɫID
Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CreditAlarmRightCheck extends Bizlet{

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sUserID = (String)this.getAttribute("UserID");
		Double dCustomerOpenBalance = null;
		double dBusinessSum = 0;
		Double DAuthSum = null;
		double dAuthSum = -1;//��Ȩ���
		String sAlarmLevel = "01";//Ԥ������ 01��һ��  02���ش�
		int m = 10000;//��Ԫ
		String result = "";

        //��ȡ�ͻ��ĳ��ڽ�Ԥ������
		String sSql = "select CustomerOpenBalance,SignalLevel from RISK_SIGNAL where SerialNo='"+sObjectNo+"'";
		//��ȡԤ�����𡢷�����
		ASResultSet rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{
			dCustomerOpenBalance = rs.getDouble("CustomerOpenBalance");
			sAlarmLevel = rs.getString("SignalLevel");
			
			if(sAlarmLevel == null) sAlarmLevel = "";
			if(dCustomerOpenBalance == null) {dBusinessSum = 999999999;}
			else {dBusinessSum = dCustomerOpenBalance;}
		}
		rs.getStatement().close();
		sSql = "select AuthSum from RiskSingal_Auth where RiskLevel = '"+sAlarmLevel+"'"+
		       " and RoleID in (select RoleID from User_Role where userid = '"+sUserID+"')";
		//��ȡȨ��������Ԥ�����𡢽���ɫ
		rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{
			DAuthSum = rs.getDouble("AuthSum");
			if(DAuthSum == null) {dAuthSum = -1;}
			else {dAuthSum = DAuthSum;}
		}
		rs.getStatement().close();
        if(dAuthSum >= dBusinessSum) result = "TRUE";
        else result = "FALSE";
        System.out.println("------------result:"+result);
        return result;
       
	}
}
