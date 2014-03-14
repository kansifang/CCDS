package com.lmt.baseapp.flow;

import java.sql.SQLException;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

/**
 * @authow ymwu 20131011
 * @describe  退回"上一阶段"而不是"上一步" 如 ：
 * 			     由支行客户经理经过支行行长提交到总行的业务，当退回补充资料时直接退到支行客户经理，
 * 			     支行 客户经理资料补充完成后可以直接提交到退回人， 而这过程中如果总行退回业务时，需要退回到支行行长
 * 			     即业务退回时，是退到上一阶段而不是上一步
 * 
 * */
public class FlowGoBack {
	
	private String sObjectNo="",sSerialNo="",sPhaseNo="",sPhaseName="",sObjectType="",
		   sPhaseType="",sFirstSerialNo="";
	ASResultSet rs =null;
	Transaction Sqlca;
	
	public FlowGoBack(String SerialNo,String ObjectNo,String ObjectType,Transaction transaction) throws Exception{
		sFirstSerialNo =SerialNo;
		Sqlca = transaction;
		sObjectNo = ObjectNo;
		sObjectType = ObjectType;
	
		/**
		 * 在Flow_Task 表中获取上一阶段的信息
		 * **/
		rs = Sqlca.getASResultSet(" Select SerialNo,PhaseNo,PhaseName,PhaseType From Flow_Task ft1 " +
								  " Where  objectno='"+sObjectNo+"' and objecttype='"+sObjectType+"' and phaseno<>'3000' and phaseno<> (  " +
								  " SELECT phaseno FROM flow_task ft2 where objectno='"+sObjectNo+"' and objecttype='"+sObjectType+"' and serialno='"+sFirstSerialNo+"') " +
								  " and serialno<'"+sFirstSerialNo+"' order by serialno desc  fetch first 1 rows only ") ;
		if(rs.next()){
			sSerialNo = rs.getString("SerialNo");
            sPhaseNo = rs.getString("PhaseNo");
            sPhaseName = rs.getString("PhaseName");
            sPhaseType = rs.getString("PhaseType");
		}
		rs.getStatement().close();
	}
	
	/**
	 * @throws SQLException 
	 * @describe 退回上一阶段,删除当前Flow_Task、Flow_Opinion，更新上一阶段的信息，更新Flow_Object
	 * **/
	public String cancel() throws SQLException{
		

		String sDeleteFlowTask = " Delete From Flow_Task where SerialNo = '"+sFirstSerialNo+"' ";
		String sUpdateFlowTask = " Update Flow_Task set EndTime='',PhaseAction='',PhaseOpinion=''  Where " +
								 " SerialNo = '"+sSerialNo+"' ";
		String sUpdateFlowObject = " Update Flow_Object set PhaseType='"+sPhaseType+"',PhaseNo='"+sPhaseNo+"'," +
								   " PhaseName='"+sPhaseName+"' where ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' ";
		String sUpdateFlowOpinion = " Update Flow_Opinion set PhaseOpinion='' where SerialNo='"+sSerialNo+"' ";
		
		Boolean bool = Sqlca.conn.getAutoCommit();
		try {
			
			Sqlca.conn.setAutoCommit(false);
			Sqlca.executeSQL(sDeleteFlowTask);
			Sqlca.executeSQL(sUpdateFlowTask);
			Sqlca.executeSQL(sUpdateFlowObject);
			Sqlca.executeSQL(sUpdateFlowOpinion);
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(bool);
			return "退回完成";
		} catch (Exception e) {
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bool);
			e.printStackTrace();
			return "false$退回上一阶段失败！";
		}
	}
	
}
