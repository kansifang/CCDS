/*
Author:   xhyong 2009/09/14
Tester:
Describe: 不良业务认定以后对相关信息进行更新
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

public class FinishBadBiz extends Bizlet {

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
		
		if(sPhaseType.equals("1040"))//批准
		{
			sSql = "update BADBIZ_APPLY set PassDate = '"+StringFunction.getToday()+"' where SerialNo = '"+sObjectNo+"'";
		}
		else if(sPhaseType.equals("1030"))//退回补充资料
		{
			sSql = "update BADBIZ_APPLY set ReturnDate = '"+StringFunction.getToday()+"' where SerialNo = '"+sObjectNo+"'";
		}
		else if(sPhaseType.equals("1050"))//否决
		{
			sSql = "update BADBIZ_APPLY set VetoDate = '"+StringFunction.getToday()+"' where SerialNo = '"+sObjectNo+"'";
		}
		Sqlca.executeSQL(sSql);
		
		return "1";

	}

}

