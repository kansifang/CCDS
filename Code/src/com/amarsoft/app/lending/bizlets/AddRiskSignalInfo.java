/*
		Author: --xhyong 2011/03/31
		Tester:
		Describe: --新增预警信号发起
		Input Param:		
		Output Param:
				SerialNo：流水号
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
		//获得已批准预警信息流水号
		String sUserID = (String)this.getAttribute("UserID");
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//将空值转化成空字符串		
		if(sUserID == null) sUserID = "";		
		if(sCustomerID == null) sCustomerID = "";	
		//获得流水号
		String sSerialNo = DBFunction.getSerialNo("RISK_SIGNAL","SerialNo","RS",Sqlca);
		//定义变量：SQL语句
		String sSql = "";		
						
		//实例化用户对象
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		
		//初始化预警信号基本信息
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
		//初始化流程
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
