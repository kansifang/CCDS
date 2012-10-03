package com.amarsoft.app.lending.bizlets;
/*
Author: --lpzhang
Tester:
Describe: --测算客户本笔风险总量
Input Param:
		sCustomerID：客户编号
Output Param:
		EvaluateScore:本笔风险总量
HistoryLog:
*/

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.workflow.FlowPhase;
import com.amarsoft.biz.workflow.FlowTask;


public class ClassifyBatchSubmit extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值
		String sPhaseOpinion1 = (String)this.getAttribute("PhaseOpinion1");
		String sPhaseAction = (String)this.getAttribute("PhaseAction");
		String sBatchObjectNo = (String)this.getAttribute("Index");
		String sFlowNo = (String)this.getAttribute("FlowNo");
		String sPhaseNo = (String)this.getAttribute("PhaseNo");
		String sUserID = (String)this.getAttribute("UserID");
		if(sPhaseOpinion1 == null) sPhaseOpinion1 = "";
		if(sPhaseAction == null) sPhaseAction = "";
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";
		if(sUserID == null) sUserID = "";
		if(sBatchObjectNo == null) sBatchObjectNo = "";
		String[] sBatchObjectNos = sBatchObjectNo.split("@");
		FlowPhase fpFlow = null;
		FlowTask ftBusiness = null;
		for(int i =0;i<sBatchObjectNos.length;i++){
			boolean bOld = Sqlca.conn.getAutoCommit(); 
			Sqlca.conn.setAutoCommit(false);
			try{
				String sSerialNo = Sqlca.getString(" select SerialNo from Flow_Task where ObjectType = 'ClassifyApply' "+
					" and ObjectNo ='"+sBatchObjectNos[i]+"' and FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'" +
					" and (PhaseAction is null or PhaseAction='') and UserID = '"+sUserID+"' and (EndTime is null or EndTime ='')");
				ftBusiness = new FlowTask(sSerialNo,Sqlca);
				fpFlow = ftBusiness.commitAction(sPhaseAction,sPhaseOpinion1);
				Sqlca.conn.commit();
				Sqlca.conn.setAutoCommit(bOld);
			}catch(Exception e)
			{
				//事物失败，数据回滚
				Sqlca.conn.rollback();
				Sqlca.conn.setAutoCommit(bOld);
				throw new Exception("事务处理失败！"+e.getMessage());
			}  
		}	
		return "下一阶段:"+" " + fpFlow.PhaseName;
	}
}
