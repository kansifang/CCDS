/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --将已批准的预警信息复制到预警信息解除中
		Input Param:
				ObjectNo: 批准的预警信息编号				
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


public class AddRiskSignalFreeInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{		
		//获得已批准预警信息流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//获取当前用户
		String sUserID = (String)this.getAttribute("UserID");
		
		//将空值转化成空字符串		
		if(sObjectNo == null) sObjectNo = "";		
		if(sUserID == null) sUserID = "";
		
		//获得流水号
		String sSerialNo = DBFunction.getSerialNo("RISK_SIGNAL","SerialNo","RS",Sqlca);
		//定义变量：SQL语句
		String sSql = "";		
						
		//实例化用户对象
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		
		//将已批准的信息复制到预警信息解除中
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
		//将预警发起中的预警信息关联到解除里
		//初始化预警关联信息
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
		
		//初始化流程
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
