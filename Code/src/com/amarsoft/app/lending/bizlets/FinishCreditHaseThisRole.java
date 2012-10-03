/*
		Author: --xhyong 2011/07/14
		Tester:
		Describe: --判断最终审批人是否具有某一角色
		Input Param:
				ObjectType：对象类型
				ObjectNo：对象编号
				RoleID:角色ID
		Output Param:
				ReturnValue：1 是,2 否
		HistoryLog: 
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishCreditHaseThisRole extends Bizlet 
{
	public Object run(Transaction Sqlca) throws Exception
	{
		//获取参数
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sRoleID = (String)this.getAttribute("RoleID");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sRoleID == null) sRoleID = "";
		
		//定义变量：SQL语句
		String sApplySerialNo = "";
		String sContractSerialNo = "";
		String sReturnValue="2";
		String sCreditAggreement = "";
		//查询出帐相对应的业务对象流水号（合同、批复、申请）
		if("PutOutApply".equals(sObjectType))
		{
			//根据出帐流水号获得额度合同流水号
			sCreditAggreement =  Sqlca.getString("select distinct CreditAggreement from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'");
			if(sCreditAggreement == null) sCreditAggreement = "";
			if(!"".equals(sCreditAggreement))
			{
				//合同流水号为额度合同流水号
				sContractSerialNo =  sCreditAggreement;
			}else
			{
				//根据出帐流水号获得合同流水号
				sContractSerialNo =  Sqlca.getString("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'");
			}
			//根据合同流水号获得申请流水号
			sApplySerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sContractSerialNo+"'");
			//根据申请流水号判断该申请最终审批人是否具有某一角色
			sReturnValue = Sqlca.getString("select distinct 1 from USER_ROLE where UserID in (select ApproveUserID from BUSINESS_APPLY where Serialno = '"+sApplySerialNo+"') and RoleID like '%"+sRoleID+"'");
		}else if("CreditApproveApply".equals(sObjectType))
		{
			//根据申请流水号判断该申请最终审批人是否具有某一角色
			sReturnValue = Sqlca.getString("select distinct 1 from USER_ROLE where UserID in (select ApproveUserID from BUSINESS_APPLY where Serialno = '"+sObjectNo+"') and RoleID like '%"+sRoleID+"'");
		}
		return sReturnValue;
	}
}