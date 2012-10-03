package com.amarsoft.app.lending.bizlets;
/**
 * xhyong 20110510 初始化批复申请
 * 
 * */
import java.sql.Date;
import java.text.SimpleDateFormat;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.ASResultSet;



public class InitializeCreditApproveFlow extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		if(sObjectType == null) sObjectType = "";
		//对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		//机构编号
		String sOrgID = (String)this.getAttribute("OrgID");
		if(sObjectNo == null) sObjectNo = "";
		//当前流程号
		String sTempFlowNo = (String)this.getAttribute("FlowNo");
		if(sTempFlowNo == null) sTempFlowNo = "";

		//String sTempOrgID = "";//最终审批机构
		String sOrgName = "";//批复机构名称
		String sUserName = "";//批复经办人
		String sUserID = "";//批复经办人
		String sFlowName = "";//流程名称
		String sPhaseName = "";//阶段名称
		String sPhaseType = "";//所属审批阶段
		String sBeginTime = "";//开始时间
		String sSerialNo = "";//审批流水号
		String sSql = "";//SQL
		String sFlowNo = "CreditApproveFlow01";//流程编号
		String sPhaseNo = "";//阶段编号
		String sApplyType = "";//申请类型
		String sApprovalNo = "";//批复号
		String sMainOrgIDStr = "";//机构前三位
		String sIsApproveFLag = "";//是否走批复
		String sCommunityagreement = "";//关联共同体额度号
		//定义变量：查询结果集
		ASResultSet rs=null;
		
		//个人公司一般风险走批复流程
		if("EntCreditFlowTJ01".equals(sTempFlowNo) || "IndCreditFlowTJ01".equals(sTempFlowNo))
		{
			//非信用共同体贷款做批复
			sSql = " select Communityagreement from business_apply where  communityagreement is not null and communityagreement<>'' and Serialno='"+sObjectNo+"' ";
			sCommunityagreement = Sqlca.getString(sSql);
			if(sCommunityagreement == null) sCommunityagreement = "";
			if("".equals(sCommunityagreement))
			{
				sIsApproveFLag="1";
			}
		}
		//取得机构名称
		sSql = " select OrgName from ORG_INFO where OrgID = '"+sOrgID+"' ";
		sOrgName = Sqlca.getString(sSql);
		
		//获得初始化阶段人和机构
		if("EntCreditFlowTJ01".equals(sTempFlowNo))//公司一般风险流程
		{
			//总行
			if("9900".equals(sOrgID))
			{
				//获取的用户名称:对应系统阶段:中小企业审批分部审查员,总行公司授信审批部审批员
				sSql = " select UserID,UserName from FLOW_TASK where ObjectType='CreditApply' " +
						" and  PhaseNo in('0220','0260') and  FlowNo='"+sTempFlowNo+"' and OrgID = '"+sOrgID+"' "+
						" and ObjectNO='"+sObjectNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{ 
					sUserID = rs.getString("UserID");
					sUserName = rs.getString("UserName");
					//将空值转化成空字符串
					if(sUserID == null) sUserID = "";
					if(sUserName == null) sUserName = "";
				}
				rs.getStatement().close(); 
			}else{//中心支行
				//获取的用户名称
				sSql = " select UserID,UserName from FLOW_TASK where ObjectType='CreditApply' " +
						" and  PhaseNo='0130' and  FlowNo='"+sTempFlowNo+"' and OrgID = '"+sOrgID+"' "+
						" and ObjectNO='"+sObjectNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{ 
					sUserID = rs.getString("UserID");
					sUserName = rs.getString("UserName");
					//将空值转化成空字符串
					if(sUserID == null) sUserID = "";
					if(sUserName == null) sUserName = "";
				}
				rs.getStatement().close();
			}
			
		}else{//个人一般风险流程
			//总行
			if("9900".equals(sOrgID))
			{
				//获取的用户名称
				sSql = " select UserID,UserName from FLOW_TASK where ObjectType='CreditApply' " +
						" and  PhaseNo='0200' and  FlowNo='"+sTempFlowNo+"' and OrgID = '"+sOrgID+"' "+
						" and ObjectNO='"+sObjectNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{ 
					sUserID = rs.getString("UserID");
					sUserName = rs.getString("UserName");
					//将空值转化成空字符串
					if(sUserID == null) sUserID = "";
					if(sUserName == null) sUserName = "";
				}
				rs.getStatement().close(); 
			}else{//中心支行
				//获取的用户名称
				sSql = " select UserID,UserName from FLOW_TASK where ObjectType='CreditApply' " +
						" and  PhaseNo='0130' and  FlowNo='"+sTempFlowNo+"' and OrgID = '"+sOrgID+"' "+
						" and ObjectNO='"+sObjectNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{ 
					sUserID = rs.getString("UserID");
					sUserName = rs.getString("UserName");
					//将空值转化成空字符串
					if(sUserID == null) sUserID = "";
					if(sUserName == null) sUserName = "";
				}
				rs.getStatement().close();
			}
		}
        //取得流程名称
		sSql = " select FlowName,InitPhase from FLOW_CATALOG where FlowNo = '"+sFlowNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			sFlowName = rs.getString("FlowName");
			sPhaseNo = rs.getString("InitPhase");
			//将空值转化成空字符串
			if(sFlowName == null) sFlowName = "";
			if(sPhaseNo == null) sPhaseNo = "";
		}
		rs.getStatement().close(); 	    
        //取得阶段名称
		sSql = " select PhaseName,PhaseType from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{ 
			sPhaseName = rs.getString("PhaseName");
			sPhaseType = rs.getString("PhaseType");
			
			//将空值转化成空字符串
			if(sPhaseName == null) sPhaseName = "";
			if(sPhaseType == null) sPhaseType = "";
		}
		rs.getStatement().close(); 
		//获得开始日期
	    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();	 
	    //申请类型默认为:sObjectType"CreditApproveApply"
	    sApplyType = "CreditApproveApply";
	    //将空值转化成空字符串
	    if(sObjectType == null) sObjectType = "";
	    if(sObjectNo == null) sObjectNo = "";
	    if(sPhaseType == null) sPhaseType = "";
	    if(sApplyType == null) sApplyType = "";
	    if(sFlowNo == null) sFlowNo = "";
	    if(sFlowName == null) sFlowName = "";
	    if(sPhaseNo == null) sPhaseNo = "";
	    if(sPhaseName == null) sFlowName = "";
	    if(sUserID == null) sUserID = "";
	    if(sUserName == null) sUserName = "";
	    if(sOrgID == null) sOrgID = "";
	    if(sOrgName == null) sOrgName = "";

	    //在流程对象表FLOW_OBJECT中新增一笔信息
	    String sSql1 =  " Insert into FLOW_OBJECT(ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName,PhaseNo, " +
			    	    " PhaseName,OrgID,OrgName,UserID,UserName,InputDate) " +
			            " values ('CreditApproveApply','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"', " +
			            " '"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sOrgName+"','"+sUserID+"', "+
			            " '"+sUserName+"','"+StringFunction.getToday()+"') ";
	    //在流程任务表FLOW_TASK中新增一笔信息
	    sSerialNo = DBFunction.getSerialNo("FLOW_TASK","SerialNo",Sqlca);
        String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
         				" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime) "+
         				" values ('"+sSerialNo+"','CreditApproveApply','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"', " + 
         				" '"+sFlowNo+"','"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sUserID+"', " +
         				" '"+sUserName+"','"+sOrgName+"','"+sBeginTime+"' )";
		if(sOrgID.length()>=4){
			sMainOrgIDStr = sOrgID.substring(0,4);
		}else{
			sMainOrgIDStr = sOrgID;
			for(int i=sOrgID.length();i<4;i++){
				sMainOrgIDStr = "0"+ sMainOrgIDStr;
			}
		}
        sApprovalNo=sMainOrgIDStr+ DBFunction.getSerialNo("BUSINESS_APPLY","ApprovalNo","","yyyyMMdd","0000",new java.util.Date(),Sqlca).substring(2,12);
        String sSql3 =  " Update BUSINESS_APPLY set ApprovalNo='"+sApprovalNo+"',IsApproveFLag='"+sIsApproveFLag+"' where SerialNo='"+sObjectNo+"'";
	    //执行插入语句
	    Sqlca.executeSQL(sSql1);
	    Sqlca.executeSQL(sSql2);
	    Sqlca.executeSQL(sSql3);
	    
	    return "1";
	    
	 }

}
