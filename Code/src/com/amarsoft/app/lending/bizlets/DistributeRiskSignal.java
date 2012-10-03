/*
		Author: --zywei 2006-08-18
		Tester:
		Describe: 更新抵质押物状态，并保存入库/出库痕迹
		Input Param:
			GuarantyID：抵质押物编号
			GuarantyStatus：抵质押物状态
			UserID：登记人编号	
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.biz.bizlet.Bizlet;


public class DistributeRiskSignal extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";			
		String sCheckUser   = (String)this.getAttribute("CheckUser");
		if(sCheckUser == null) sCheckUser = "";		
				
		//定义变量
		String sCheckOrg = "",sCheckDate = "",sUpdateSql = "",sInsertSql = "";
				
		//获取系统日期
		sCheckDate = StringFunction.getToday();
		//获取用户所在机构
		ASUser CurUser = new ASUser(sCheckUser,Sqlca);
		sCheckOrg = CurUser.OrgID;
		//获得预警信息分发流水号
		String sROSerialNo = DBFunction.getSerialNo("RISKSIGNAL_OPINION","SerialNo","",Sqlca);
		
		//更新预警信号的预警状态
		sUpdateSql = " update RISK_SIGNAL set SignalStatus = '20' "+
					 " where SerialNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sUpdateSql);
		
		sInsertSql = " insert into RISKSIGNAL_OPINION(ObjectNo,SerialNo,CheckUser,CheckOrg,CheckDate) "+
					 " values ('"+sObjectNo+"','"+sROSerialNo+"','"+sCheckUser+"','"+sCheckOrg+"', "+
					 " '"+sCheckDate+"') ";		
		Sqlca.executeSQL(sInsertSql);
		return "1";
	 }
}
