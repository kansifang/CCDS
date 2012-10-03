package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong 2009-09-03
Tester:
Describe: --不良资产责任认定更新状态信息及相关历史信息保存
Input Param:
		ObjectNo: 合同编号
		BadAssetLCFlag: 状态标识 010 认定完成 020 审批完成
		UserID:当前用户
		OrgID:当前机构
Output Param:
		ReturnValue :返回标识
HistoryLog:
*/
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateBadAssetCogniz extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值 合同编号,更新标识,当前用户ID,当前机构ID	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sBadAssetLCFlag = (String)this.getAttribute("BadAssetLCFlag");
		String sUserID = (String)this.getAttribute("UserID");
		String sOrgID = (String)this.getAttribute("OrgID");
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sBadAssetLCFlag == null) sBadAssetLCFlag = "" ;
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "" ;
		
		String sSql = "";
		String sRoleId= "",sUserName="";
		ASResultSet rs = null;
		//更新合同状态
		sSql="update BUSINESS_CONTRACT set BadAssetLcFlag  = '"+sBadAssetLCFlag+"' where SerialNo = '"+sObjectNo+"'";		
		Sqlca.executeSQL(sSql);
		if(sBadAssetLCFlag.equals("010"))//认定完成
		{
			//更新认定时间
			sSql="update DUTY_INFO set CognizeDate  = '"+StringFunction.getToday()+"' where ObjectType='BusinessContract' and ObjectNo = '"+sObjectNo+"'";		
			Sqlca.executeSQL(sSql);
		}else if(sBadAssetLCFlag.equals("020"))//审批完成
		{
			//更新认定时间,审批人,审批机构,审批时间
			sSql="update DUTY_INFO set CognizeExamID = '"+sUserID+"',CognizeExamOrgID = '"+sOrgID+"',CognizeExamDate  = '"+StringFunction.getToday()+"' where ObjectType='BusinessContract' and ObjectNo = '"+sObjectNo+"'";		
			Sqlca.executeSQL(sSql);
		}
		
		return "Success";
	}	

}
