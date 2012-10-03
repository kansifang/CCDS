package com.amarsoft.app.lending.bizlets;
/*
		Author: --xhyong 2011/09/28
		Tester:
		Describe: --删除预警信号
		Input Param:
				ObjectType: --对象类型(业务阶段)。
				ObjectNo: --预警编号。
				SerialNo:--预警流水号
		Output Param:
				return：返回值（SUCCEEDED --删除成功）

		HistoryLog:
 */
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteRiskSignal extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSerialNo = (String)this.getAttribute("SerialNo");

		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
				
		//根据对象类型获得关联表名
		String sSql = " ";
	
			
		//删除担保合同
		sSql =  " delete from Customer_RiskSignal "+
				" where SerialNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);
		
		//删除担保合同与抵质押物的关联关系
		sSql =  " delete from RISKSIGNAL_RELATIVE "+
				" where ObjectType = '"+sObjectType+"' "+
				" and ObjectNo = '"+sObjectNo+"' "+
				" and SerialNo = '"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
	
		return "SUCCEEDED";
	}
}
