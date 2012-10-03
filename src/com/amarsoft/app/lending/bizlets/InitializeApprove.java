/*
		Author: --zywei 2005-08-09
		Tester:
		Describe: --初始化最终审批意见和流程
		Input Param:
				ObjectType: 对象类型
				ObjectNo: 对象编号
				ApplyType：申请类型
				FlowNo：流程编号
				PhaseNo：阶段编号
				UserID：用户代码
				OrgID：用户机构
				ApproveType：批复类型
				DisagreeOpinion：否决意见
		Output Param:
				SerialNo：批复流水号
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitializeApprove extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//申请类型
		String sApplyType = (String)this.getAttribute("ApplyType");
		//流程编号
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//阶段编号
		String sPhaseNo = (String)this.getAttribute("PhaseNo");	
		//用户代码
		String sUserID = (String)this.getAttribute("UserID");
		//机构代码
		String sOrgID = (String)this.getAttribute("OrgID");
		//获取批复类型
		String sApproveType = (String)this.getAttribute("ApproveType");
		//获取否决意见
		String sDisagreeOpinion = (String)this.getAttribute("DisagreeOpinion");
				
		String sSerialNo = "";
		
		//将空值转化为空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sApplyType == null) sApplyType = "";
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		if(sApproveType == null) sApproveType = "";
		if(sDisagreeOpinion == null) sDisagreeOpinion = "";
		
		/*
		 * 1、对授信方案明细进行备份，调用 AddCLInfoLog.java		  
		*/
		
		Bizlet bzAddCLInfoLog = new AddCLInfoLog();
		bzAddCLInfoLog.setAttribute("ObjectType","CreditApply"); 
		bzAddCLInfoLog.setAttribute("ObjectNo",sObjectNo);
		bzAddCLInfoLog.setAttribute("Action","AddApprove");
		bzAddCLInfoLog.setAttribute("UserID",sUserID);
		bzAddCLInfoLog.setAttribute("OrgID",sOrgID);
		bzAddCLInfoLog.run(Sqlca);
		
		/*
		 * 2、对最终审批意见进初始化，调用 InitializeFlow.java		  
		*/
		Bizlet bzAddApprove = new AddApproveInfo();
		bzAddApprove.setAttribute("ObjectType",sObjectType); 
		bzAddApprove.setAttribute("ObjectNo",sObjectNo);
		bzAddApprove.setAttribute("ApproveType",sApproveType);
		bzAddApprove.setAttribute("DisagreeOpinion",sDisagreeOpinion);
		bzAddApprove.setAttribute("UserID",sUserID);
		sSerialNo = (String)bzAddApprove.run(Sqlca);
		
		/*
		 * 3、调用 InitializeFlow.java对最终审批意见进行流程初始化		  
		*/
		Bizlet bzInitFlow = new InitializeFlow();
		bzInitFlow.setAttribute("ObjectType",sObjectType); 
		bzInitFlow.setAttribute("ObjectNo",sSerialNo); 
		bzInitFlow.setAttribute("ApplyType",sApplyType);
		bzInitFlow.setAttribute("FlowNo",sFlowNo);
		bzInitFlow.setAttribute("PhaseNo",sPhaseNo);
		bzInitFlow.setAttribute("UserID",sUserID);
		bzInitFlow.setAttribute("OrgID",sOrgID);
		bzInitFlow.run(Sqlca);
		  
	    return sSerialNo;
	    
	 }

}
