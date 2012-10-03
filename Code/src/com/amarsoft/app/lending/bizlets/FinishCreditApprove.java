/*
Author:   xhyong 2011/05/12
Tester:
Describe: 授信业务批复相关信息进行更新
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

public class FinishCreditApprove extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//获取参数
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sOrgID = (String)this.getAttribute("ObjectType");
		//将空值转化成空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		//自定义变量:sql
		String sSql = "";
		sSql = "update BUSINESS_APPLY set FinishApproveUserID = '"+sOrgID+"' where SerialNo = '"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
		
		return "1";

	}

}

