/*
Author:   wangdw 2012/07/24
Tester:
Describe: 抵质押物出入库更新最终审批信息
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

public class FinishGuarantyApply extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//获取参数
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sPhaseType = (String)this.getAttribute("PhaseType");
		String sAPPROVEUSERID = "";//最终审批人
		String sAPPROVEORGID = "";//最终审批机构
		String sAPPROVEOPINION = "";//最终审批意见
		String sFinalTime = "";//最终审批时间
		
		//将空值转化成空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sPhaseType == null) sPhaseType = "";
		String sSql = "";
		ASResultSet rs=null;
		sSql = "select userid,orgid,phaseaction,endtime from Flow_Task where objectno = '"+sObjectNo+"' and phaseno = '0040'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sAPPROVEUSERID = rs.getString("userid");
			sAPPROVEORGID = rs.getString("orgid");
			sAPPROVEOPINION = rs.getString("phaseaction");
			sFinalTime = rs.getString("endtime");
		}
		rs.getStatement().close();
		sSql = "update Guaranty_Apply set APPROVEUSERID = '"+sAPPROVEUSERID+"',APPROVEORGID ='"+sAPPROVEORGID+"' ,APPROVEOPINION ='"+sAPPROVEOPINION+"',FinalTime ='"+sFinalTime+"' where SerialNo = '"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
		return "1";

	}

}

