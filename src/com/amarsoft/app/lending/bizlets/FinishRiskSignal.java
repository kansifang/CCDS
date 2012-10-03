/*
Author:   xhyong 2011/03/28
Tester:
Describe: 预警信号认定以后对相关信息进行更新
Input Param:
		SerialNo: 流程流水号
		ObjectNo: 对象编号
		sObjectType:对象类型
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishRiskSignal extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//获取参数
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sPhaseType = (String)this.getAttribute("PhaseType");
		
		//将空值转化成空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sPhaseType == null) sPhaseType = "";
		String sSql = "";
		//设置为批准状态
		if("1040".equals(sPhaseType))//批准
		{
			sSql = "update RISK_SIGNAL set SignalStatus = '30' where SerialNo = '"+sObjectNo+"'";
			Sqlca.executeSQL(sSql);
		}
		if("1050".equals(sPhaseType))//否决
		{
			sSql = "update RISK_SIGNAL set SignalStatus = '40' where SerialNo = '"+sObjectNo+"'";
			Sqlca.executeSQL(sSql);
		}
		
		return "1";

	}

}

