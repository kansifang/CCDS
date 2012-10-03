/*
		Author: --xhyong 2012/03/28
		Tester:
		Describe: --风险分类流程初始化
		Input Param:
				ObjectType: 对象类型
				ObjectNo: 对象编号
				TaskNo: 流程编号
		Output Param:
				Message：提示信息
		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import java.util.Hashtable;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;


public class ReinitClassifyFlow extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sTaskNo = (String)this.getAttribute("TaskNo");
		
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sTaskNo == null) sTaskNo = "";
				
		
		//定义变量：提示信息、SQL语句,客户名称
		String sMessage = "",sSql = "";
		//定义变量：查询结果集
		ASResultSet rs = null;
		//定义变量:流程编号
		String FlowNo="";
		
		//判断风险分类是否已调整
		sSql = 	"select count(*) from BUSINESS_CONTRACT BC,Classify_Record CR2 where BC.SerialNo = CR2.ObjectNO and BC.ClassifyResult = CR2.ClassifyLevel and CR2.SerialNo = '"+sObjectNo+"' ";
		double iCount = Sqlca.getDouble(sSql);	
		if(iCount>0)
		{
			FlowNo="ClassifyFlow01";//未调整
		}else{
			FlowNo="ClassifyFlow";//已调整
		}
		String sFlowName = "";
		String sInitPhase="";
		String sPhaseType = "";
		String sPhaseName = "";
		//初始化CATALOG
		sSql = "select InitPhase,FlowName from FLOW_CATALOG where FlowNo = '"+FlowNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sFlowName = rs.getString("FlowName"); //流程名称
			sInitPhase = rs.getString("InitPhase"); //初始化阶段
			if(sFlowName == null) sFlowName ="";
			if(sInitPhase == null) sInitPhase ="";
		}
		rs.getStatement().close();
		
		
		if( sInitPhase.trim().equals(""))
			throw new Exception("审批流程"+FlowNo+"没有初始化阶段编号！");
		//初始化CATALOG
		sSql = "select PhaseType,PhaseName from FLOW_MODEL where FlowNo = '"+FlowNo+"' and PhaseNo='"+sInitPhase+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sPhaseType = rs.getString("PhaseType"); //流程名称
			sPhaseName = rs.getString("PhaseName"); //初始化阶段
			if(sPhaseType == null) sPhaseType ="";
			if(sPhaseName == null) sPhaseName ="";
		}
		rs.getStatement().close();
		
		
		String sSql1 = " Update FLOW_OBJECT set PhaseType  ='"+sPhaseType+"',FlowNo ='"+FlowNo+"'," +
				       " FlowName ='"+sFlowName+"',PhaseNo='"+sInitPhase+"',PhaseName='"+sPhaseName+"'" +
				       " where ObjectNo = '"+sObjectNo+"' and ObjectType ='"+sObjectType+"'";
		
		String sSql2 = " Update FLOW_TASK set PhaseType  ='"+sPhaseType+"',FlowNo ='"+FlowNo+"'," +
				       " FlowName ='"+sFlowName+"',PhaseNo='"+sInitPhase+"',PhaseName='"+sPhaseName+"'" +
				       " where ObjectNo = '"+sObjectNo+"' and ObjectType ='"+sObjectType+"' and SerialNo ='"+sTaskNo+"'";

		
		
	   
	    //执行插入语句
	    Sqlca.executeSQL(sSql1);
	    Sqlca.executeSQL(sSql2);
		
		return sMessage;
	 }
	 

}
