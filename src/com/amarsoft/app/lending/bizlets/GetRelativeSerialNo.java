/*
		Author: --zywei 2006-1-18
		Tester:
		Describe: --取得业务关联编号
		Input Param:
				ObjectType：对象类型
				RelaObjectType：关联对象类型
				ObjectNo：对象编号
		Output Param:
				SerialNo：业务关联编号
		HistoryLog: lpzhang 2009-9-3 关联复议业务
					xhyong 2009/10/14 修改重组方案标签判断
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetRelativeSerialNo extends Bizlet 
{
	public Object run(Transaction Sqlca) throws Exception
	{
		//获取参数
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sRelaObjectType = (String)this.getAttribute("RelaObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sRelaObjectType == null) sRelaObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//定义变量：SQL语句
		String sSerialNo = "";
		String sRelativeSerialNo = "";
		//查询申请相对应的业务对象流水号（授信额度流水号、资产重组方案）
		if(sObjectType.equals("CreditApply"))
		{	
			//关联对象为授信额度对象
			if(sRelaObjectType.equals("CreditLine"))
			{
				//根据申请流水号获得授信额度流水号
				sSerialNo =  Sqlca.getString("select CreditAggreement from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'"); 
			}

			//关联对象为资产重组方案对象
			if(sRelaObjectType.equals("NPAReformApply"))
			{
				//根据申请流水号获得资产重组方案流水号
				sSerialNo =  Sqlca.getString("select ObjectNo from APPLY_RELATIVE where SerialNo = '"+sObjectNo+"' and ObjectType = 'CapitalReform'"); 
			}
			
			//关联对象为复审
			if(sRelaObjectType.equals("BusinessReApply"))
			{
				//根据申请流水号获得需要复审的申请流水号
				sSerialNo =  Sqlca.getString("select ObjectNo from APPLY_RELATIVE where SerialNo = '"+sObjectNo+"' and ObjectType = 'BusinessReApply'"); 
			}
			
			//关联对象为额度调整
			if(sRelaObjectType.equals("CLBusinessChange"))
			{
				//根据申请流水号获得需要复审的申请流水号
				sSerialNo =  Sqlca.getString("select ObjectNo from APPLY_RELATIVE where SerialNo = '"+sObjectNo+"' and ObjectType = 'CLBusinessChange'"); 
			}
			//关联对象为农户联保小组额度
			if(sRelaObjectType.equals("AssureAgreement"))
			{
				//根据申请流水号获得授信额度流水号
				sSerialNo =  Sqlca.getString("select AssureAgreement from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'");
			}
			//关联对象为农户信用额度共同体
			if(sRelaObjectType.equals("CommunityAgreement"))
			{
				//根据申请流水号获得授信额度流水号
				sSerialNo =  Sqlca.getString("select CommunityAgreement from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'");
			}
		}
		
		//查询最终审批意见相对应的业务对象流水号（授信额度流水号、资产重组方案）
		if(sObjectType.equals("ApproveApply") || sObjectType.equals("ApproveApplyNo"))
		{	
			//关联对象为申请对象
			if(sRelaObjectType.equals("CreditApply"))
			{
				//根据最终审批意见流水号获得申请流水号
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo = '"+sObjectNo+"'"); 
			}
			
			if(sObjectType.equals("ApproveApply"))
			{			
				//关联对象为授信额度对象
				if(sRelaObjectType.equals("CreditLine"))
				{
					//根据最终审批意见流水号获得授信额度流水号
					sSerialNo =  Sqlca.getString("select CreditAggreement from BUSINESS_APPROVE where SerialNo = '"+sObjectNo+"'"); 
				}
	
				//关联对象为资产重组方案对象
				if(sRelaObjectType.equals("NPAReformApply"))
				{
					//根据最终审批意见流水号获得资产重组方案流水号
					sSerialNo =  Sqlca.getString("select ObjectNo from APPROVE_RELATIVE where SerialNo = '"+sObjectNo+"' and ObjectType = 'CapitalReform'"); 
				}
			}			
		}
		
		//查询合同相对应的业务对象流水号（授信额度流水号、最终审批意见流水号、申请流水号、资产重组方案）
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan"))
		{
			
			//关联对象为申请对象
			if(sRelaObjectType.equals("CreditApply"))
			{
				//根据合同流水号获得最终审批意见流水号
				sRelativeSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'"); 
				//根据最终审批意见流水号获得申请流水号
				//sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo = '"+sRelativeSerialNo+"'");
				//修改为去掉最终审批意见 modified by zrli 20090709
				sSerialNo = sRelativeSerialNo;
			}
			
			//关联对象为最终审批意见对象
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//根据合同流水号获得最终审批意见流水号
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'"); 
			}

			//关联对象为授信额度对象
			if(sRelaObjectType.equals("CreditLine"))
			{
				//根据合同流水号获得最终审批意见流水号
				sSerialNo =  Sqlca.getString("select CreditAggreement from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'"); 
			}

			//关联对象为资产重组方案对象
			if(sRelaObjectType.equals("NPAReformApply"))
			{
				//根据合同流水号获得最终审批意见流水号
				sSerialNo =  Sqlca.getString("select ObjectNo from CONTRACT_RELATIVE where SerialNo = '"+sObjectNo+"' and ObjectType = 'CapitalReform'"); 
			}
			
		}
				
		//查询出帐相对应的业务对象流水号（合同、批复、申请）
		if(sObjectType.equals("PutOutApply"))
		{
			//关联对象为申请对象
			if(sRelaObjectType.equals("CreditApply"))
			{
				//根据出帐流水号获得合同流水号
				sRelativeSerialNo =  Sqlca.getString("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'"); 
				//根据合同流水号获得最终审批意见流水号
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sRelativeSerialNo+"'"); 
				
			}
			
			//关联对象为最终审批意见对象
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//根据出帐流水号获得合同流水号
				sRelativeSerialNo =  Sqlca.getString("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'"); 
				//根据合同流水号获得最终审批意见流水号
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sRelativeSerialNo+"'"); 
			}
			
			//关联对象为合同对象
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//根据出帐流水号获得合同流水号
				sSerialNo =  Sqlca.getString("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'"); 
			}		
			//关联对象为额度对象
			if(sRelaObjectType.equals("CreditLine"))
			{
				//根据合同流水号获得最终审批意见流水号
				sSerialNo =  Sqlca.getString("select CreditAggreement from BUSINESS_PUTOUT where SerialNo = '"+sObjectNo+"'"); 
			}
		}
							
		//查询借据相对应的业务对象流水号（合同、出帐）
		if(sObjectType.equals("BusinessDueBill"))
		{
			//关联对象为申请对象
			if(sRelaObjectType.equals("CreditApply"))
			{
				//根据借据流水号获得合同流水号
				sRelativeSerialNo =  Sqlca.getString("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo = '"+sObjectNo+"'"); 
				//根据合同流水号获得最终审批意见流水号
				sRelativeSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sRelativeSerialNo+"'"); 
				//根据最终审批意见流水号获得申请流水号
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo = '"+sRelativeSerialNo+"'"); 
			}
			
			//查询借据相对应的最终审批意见
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//根据借据流水号获得合同流水号
				sRelativeSerialNo =  Sqlca.getString("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo = '"+sObjectNo+"'"); 
				//根据合同流水号获得最终审批意见流水号
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = '"+sRelativeSerialNo+"'"); 
			}
			
			//关联对象为合同对象
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//根据出帐流水号获得合同流水号
				sSerialNo =  Sqlca.getString("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo = '"+sObjectNo+"'"); 
			}
		}
			
		if(sObjectType.equals("ContractModifyApply")){
			if(sRelaObjectType.endsWith("BusinessContract")){
				sSerialNo = Sqlca.getString("select distinct RelativeNo from CONTRACT_MODIFY where SerialNo = '"+sObjectNo+"'");
			}
		}
		
		//add by hlzhang 20120808 增加数据修改获取关联合同号
		if(sObjectType.equals("DataModifyApply")){
			if(sRelaObjectType.endsWith("BusinessContract")){
				sSerialNo = Sqlca.getString("select distinct RelativeNo from DATA_MODIFY where SerialNo = '"+sObjectNo+"'");
			}
		}
		
		return sSerialNo;
	}
}