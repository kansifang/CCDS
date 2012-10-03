package com.amarsoft.app.lending.bizlets;
/**
 *未提交审批意见的小组成员名单
 *lpzhang 2009-12-25 
 */

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetNoTaskSubmit extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		// TODO Auto-generated method stub		
		String sTaskNo = (String)this.getAttribute("TaskNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		if(sTaskNo == null) sTaskNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//定义变量
		String sSql = "";
		String sBeforePhaseNo = "",sAllUser="",sUserName="";
		
		ASResultSet rs = null;
		
		sBeforePhaseNo = Sqlca.getString("select PhaseNo from Flow_Task where SerialNo =(select RelativeSerialNo from Flow_Task  where SerialNo = '"+sTaskNo+"')");
		if(sBeforePhaseNo==null) sBeforePhaseNo="";
		sSql = "SELECT UserName FROM FLOW_TASK WHERE PHASENO='"+sBeforePhaseNo+"' AND (EndTime='' or EndTime is null) AND OBJECTNO ='"+sObjectNo+"' AND OBJECTTYPE = '"+sObjectType+"'";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sUserName = rs.getString("UserName");
			if(sUserName==null) sUserName="";
			
			sAllUser = sAllUser+","+sUserName;
		}
		rs.getStatement().close();
		
		return sAllUser;
	}

}
