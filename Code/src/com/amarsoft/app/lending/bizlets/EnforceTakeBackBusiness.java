/*
		Author: --zwhu 20100611
		Tester:
		Describe: --强制收回流程业务
		Input Param:
				ObjectType: 对象类型
				ObjectNo: 对象编号
				PhaseNo：流程阶段
				sRelativeOrgID:当前机构上级机构
		Output Param:
				sReturn：返回提示
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class EnforceTakeBackBusiness extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//获得对象类型
		String sObjectType = (String)this.getAttribute("ObjectType"); 
		//获得对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//获得流程阶段
		String sPhaseNo = (String)this.getAttribute("PhaseNo");
		//获得当前机构
		String sOrgID = (String)this.getAttribute("OrgID");
		//获取当前任务流水号
		String sSerialNo = (String)this.getAttribute("SerialNo");
		
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sPhaseNo == null) sPhaseNo = "";
		if(sSerialNo == null) sSerialNo = "";
		if(sOrgID == null) sOrgID = "";
		String sReturn = "";
		String sSql = "";
		ASResultSet rs = null;
		String sPhaseType= "",sPhaseName = "" ;
		double iCount = 0;
	
		iCount = Sqlca.getDouble("Select count(*) from FLOW_TASK Where ObjectType =  '"+sObjectType+"'"+
						" and ObjectNo = '"+sObjectNo+"' and PhaseNo = '1000'" );
		if(!"9900".equals(sOrgID) && iCount<1){
			String sRelativeOrgID = Sqlca.getString("Select RelativeOrgID from Org_Info where OrgID = '"+sOrgID+"'");
			iCount = Sqlca.getDouble("Select count(*) from FLOW_TASK Where ObjectType = '"+sObjectType+"'"+
							" and ObjectNo = '"+sObjectNo+"' and OrgID = '"+sRelativeOrgID+"'");
		}
		
		if(iCount>0&&!"ClassifyApply".equals(sObjectType)){
			sReturn = "业务已提交至上一机构或已批准，不能强制收回！";
		}
		else{
			sSql = "Select PhaseType,PhaseName from FLOW_TASK Where ObjectType = '"+sObjectType+"' " +
					" and PhaseNo = '"+sPhaseNo+"' and ObjectNo = '"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				sPhaseType = rs.getString("PhaseType");
				sPhaseName = rs.getString("PhaseName");
				if(sPhaseType == null) sPhaseType = "";
				if(sPhaseName == null) sPhaseName = "";
			}
			rs.getStatement().close();
			iCount = Sqlca.getDouble("select count(*) from FLOW_Opinion where SerialNo in " +
					" (select Serialno from FLOW_TASK Where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' " +
					" and PhaseNo > '"+sPhaseNo+"' and SerialNo > '"+sSerialNo+"')");
			if(iCount>0)
			{	
				sSql = "delete from FLOW_Opinion where SerialNo in " +
						" (select Serialno from FLOW_TASK Where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' " +
						" and PhaseNo > '"+sPhaseNo+"' and SerialNo > '"+sSerialNo+"')";
				Sqlca.executeSQL(sSql); 
			}
			sSql = "delete from FLOW_TASK where SerialNo in " +
					" (select serialno from FLOW_TASK Where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' " +
					" and PhaseNo > '"+sPhaseNo+"' and SerialNo > '"+sSerialNo+"' )";
			Sqlca.executeSQL(sSql);
			
			sSql = "update FLOW_TASK set EndTime = null ,Phaseaction = null ,PhaseOpinion1 = null,PhaseChoice = null,"+
					" PhaseOpinion2 = null ,PhaseOpinion3 = null where serialno = '"+sSerialNo+"'";
			Sqlca.executeSQL(sSql);
			
			sSql = "update FLOW_OBJECT SET PhaseType = '"+sPhaseType+"',PhaseName = '"+sPhaseName+"',PhaseNo = '" +sPhaseNo+"'" +
					" where  ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"'";
			Sqlca.executeSQL(sSql); 
			
			sReturn = "业务强制收回成功！";
			//风险分类更新操作
			if("ClassifyApply".equals(sObjectType))
			{
				sSql = "update CLASSIFY_RECORD SET finishdate = null "+
				" where  SerialNo = '"+sObjectNo+"'";
				Sqlca.executeSQL(sSql); 
			}
		}
		return sReturn;
	}

}
