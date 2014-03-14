package com.lmt.baseapp.flow;
import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.baseapp.util.DBFunction;
import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;


public class InitializeFlow extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//对象类型
		String sObjectType = DataConvert.toString((String)this.getAttribute("ObjectType"));
		//对象编号
		String sObjectNo = DataConvert.toString((String)this.getAttribute("ObjectNo"));
		//申请类型
		String sApplyType = DataConvert.toString((String)this.getAttribute("ApplyType"));
		//流程编号
		String sFlowNo = DataConvert.toString((String)this.getAttribute("FlowNo"));
		//阶段编号
		String sPhaseNo = DataConvert.toString((String)this.getAttribute("PhaseNo"));	
		//用户代码
		String sUserID = DataConvert.toString((String)this.getAttribute("UserID"));
		//机构代码
		String sOrgID = DataConvert.toString((String)this.getAttribute("OrgID"));
        		
		//定义变量:用户名称、机构名称、流程名称、阶段名称、阶段类型、开始时间、任务流水号、SQL
		String sUserName = "";
		String sOrgName = "";
		String sFlowName = "";
		String sPhaseName = "";	
		String sPhaseType = "";
		String sBeginTime = "";
		String sSerialNo = "";
		String sSql = "";
		//定义变量：查询结果集
		ASResultSet rs=null;
				
		//获取的用户名称
		sSql = " select UserName from USER_INFO where UserID = '"+sUserID+"' ";
		sUserName = DataConvert.toString(Sqlca.getString(sSql));
	    //取得机构名称
		sSql = " select OrgName from ORG_INFO where OrgID = '"+sOrgID+"' ";
		sOrgName = DataConvert.toString(Sqlca.getString(sSql));
        //取得流程名称
		sSql = " select FlowName from FLOW_CATALOG where FlowNo = '"+sFlowNo+"' ";
		sFlowName = DataConvert.toString(Sqlca.getString(sSql));
        //取得阶段名称
		sSql = " select PhaseName,PhaseType from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			sPhaseName = DataConvert.toString(rs.getString("PhaseName"));
			sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
		}
		rs.getStatement().close(); 
		//获得开始日期
	    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();	 
	    //在流程对象表FLOW_OBJECT中新增一笔信息
	    String sSql1 =  " Insert into FLOW_OBJECT("+
	    				" ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,"+
	    				" FlowName,PhaseNo,PhaseName,OrgID,OrgName," +
			    	    " UserID,UserName,InputDate) " +
			            " values ("+
			    	    "'"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"',"+
			            "'"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sOrgName+"',"+
			    	    "'"+sUserID+"','"+sUserName+"','"+StringFunction.getToday()+"')";
	    //在流程任务表FLOW_TASK中新增一笔信息
	    sSerialNo = DBFunction.getSerialNo("FLOW_TASK","SerialNo",Sqlca);
        String sSql2 =  " insert into FLOW_TASK("+
        				" SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,"+
        				" FlowNo,FlowName,PhaseNo,PhaseName,OrgID, " +
         				" UserID,UserName,OrgName,BegInTime) "+
         				" values ("+
         				"'"+sSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"'," + 
         				"'"+sFlowNo+"','"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"',"+
         				"'"+sUserID+"','"+sUserName+"','"+sOrgName+"','"+sBeginTime+"')";
	    //执行插入语句
	    Sqlca.executeSQL(sSql1);
	    Sqlca.executeSQL(sSql2);
	    return "1";
	 }
}
