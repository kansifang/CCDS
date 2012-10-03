package com.amarsoft.app.lending.bizlets;
/*
Author: --jbye 2006-11-22
Tester:
Describe: --更新最新信用等级评估结果
Input Param:
		sObjectType：对象类型
		sObjectNo：对象编号
Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateLastEva extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSourceValue = (String)this.getAttribute("SourceValue");
		String sAccountMonth = (String)this.getAttribute("sAccountMonth");
		
		if(sSerialNo == null) sSerialNo = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSourceValue == null) sSourceValue = "";
		if(sAccountMonth == null) sAccountMonth = "";
		//默认为支行信用等级
		if(sSourceValue == "" || sSourceValue.equals("")){
			sSourceValue = sSourceValue.replaceAll(sSourceValue,"CognResult4");
		}
		
		//返回标志
		String sResult = "",sFlag = "";
		//取得对应结果
		sResult = Sqlca.getString("select "+sSourceValue+" from EVALUATE_RECORD where SerialNo='"+sSerialNo+"'");
		//更新最新结果
		Sqlca.executeSQL("Update ENT_INFO set CreditLevel = '"+sResult+"',EvaluateDate = '"+sAccountMonth+"'  where CustomerID = '"+sObjectNo+"'");
		return sFlag;
	}
}
