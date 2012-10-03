package com.amarsoft.app.lending.bizlets;
/*
Author: --bqliu 2011-05-27
Tester:
Describe: --风险预警权限判断
Input Param:
		SerialNo：申请流水号
		CustomerID：当前角色ID
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
		double dAuthSum = -1;//授权金额
		String sAlarmLevel = "01";//预警级别 01、一般  02、重大
		int m = 10000;//万元
		String result = "";

        //获取客户的敞口金额、预警级别
		String sSql = "select CustomerOpenBalance,SignalLevel from RISK_SIGNAL where SerialNo='"+sObjectNo+"'";
		//获取预警级别、发起人
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
		//获取权限配置中预警级别、金额、角色
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
