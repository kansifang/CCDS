/*
		Author: --pliu 2011-09-28
		Tester:
		Describe: --探测申请风险
		Input Param:
				ObjectType: 对象类型
				ObjectNo: 对象编号
		Output Param:
				Message：风险提示信息
		HistoryLog: lpzhang 2009-8-24 for TJ 从检代码
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;

import com.amarsoft.biz.bizlet.Bizlet;

public class CheckRiskSignal extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
        
		 
		//定义变量：提示信息、SQL语句、产品类型、客户类型
		String sMessage = "",sSql = "",sSignalLevel = "", sSignalName = "";
		//定义变量：查询结果集
		ASResultSet rs = null;	
		
		
		//获取预警级别
		sSql = " select  SignalLevel from  RISK_SIGNAL where SerialNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) { 
			sSignalLevel = rs.getString("SignalLevel");
			//将空值转化成空字符串
			if (sSignalLevel == null) sSignalLevel = "";
		}
		rs.getStatement().close();
		if(sSignalLevel=="undefined" || sSignalLevel.length()==0) {
			sMessage  += "预警信号申请信息未填写！"+"@";
			return sMessage;
		}
		
		//获取预警信号信息
		sSql =  " select CR.SignalName as SignalName"+
        " from Customer_RiskSignal CR,Risk_Signal RS,RISKSIGNAL_RELATIVE RR"+
        " where RR.ObjectNo = CR.SerialNo "+
        " and RS.SerialNo=RR.SerialNo and RR.ObjectType='RiskSignal' "+
        " and RS.SerialNo = '"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) { 
			sSignalName = rs.getString("SignalName");
			//将空值转化成空字符串
			if (sSignalName == null) sSignalName = "";
		}
		rs.getStatement().close();
		System.out.println(sSignalName);
		if(sSignalName=="undefined" || sSignalName.length()==0) {
			sMessage  += "没有预警信号信息！"+"@";
			return sMessage;
		}
		
		return sMessage;

		

		
	}
	
	
}
