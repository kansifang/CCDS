package com.amarsoft.app.lending.bizlets;
/**
 * History Log modified by fhuang 2007.01.08 增加中小企业流程选择
 * 
 * */
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.ASResultSet;


public class InitializeFlow extends Bizlet 
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
		
		if(sObjectType == null) sObjectType = "";
		
		System.out.println("sObjectType:"+sObjectType+"#sObjectNO:"+sObjectNo);
		if(sObjectType.equals("PutOutApply"))
		{
			String sCustomerType="",sBusinessType="",sNationRisk="";
			sSql = "select getCustomerType(CustomerID) as CustomerType,BusinessType,NationRisk from Business_PutOut where SerialNo='"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{ 
				sCustomerType = rs.getString("CustomerType");
				sBusinessType = rs.getString("BusinessType");
				sNationRisk = rs.getString("NationRisk");
				
				//将空值转化成空字符串
				if(sCustomerType == null) sCustomerType = "";
				if(sBusinessType == null) sBusinessType = "";
				if(sNationRisk == null) sNationRisk = "";
			}
			rs.getStatement().close(); 
			
			if (sCustomerType == null||sCustomerType.equals("")) 
				throw new Exception("获取客户类型错误，请联系系统管理员！");
			if("918010100".equals(sOrgID)){
				sFlowNo = "CompanyPutOutFlow";
			}
			else if(sCustomerType.startsWith("03"))//个人
				sFlowNo="IndPutOutFlow";
			else{
				//查询该业务申请发起流程
				String sContractNo = Sqlca.getString("select ContractSerialNo from Business_PutOut where SerialNo ='"+sObjectNo+"'");
				if(sContractNo == null) sContractNo="";

				String sSmallEntFlag = Sqlca.getString("select SmallEntFlag from ENT_INFO where CustomerID = (select CustomerID from Business_Contract where SerialNo = '"+sContractNo+"')");
				if(sSmallEntFlag == null) sSmallEntFlag = "";
				if("1".equals(sSmallEntFlag))
				{
					sFlowNo="SmallPutOutFlow";//微小企业放款流程
				}else{
					sFlowNo="EntPutOutFlow";
				}
			}
		}
		
		//获取的用户名称
		sSql = " select UserName from USER_INFO where UserID = '"+sUserID+"' ";
		sUserName = Sqlca.getString(sSql);
	   	    
	    //取得机构名称
		sSql = " select OrgName from ORG_INFO where OrgID = '"+sOrgID+"' ";
		sOrgName = Sqlca.getString(sSql);
	    	    
        //取得流程名称
		sSql = " select FlowName from FLOW_CATALOG where FlowNo = '"+sFlowNo+"' ";
		sFlowName = Sqlca.getString(sSql);
			    
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
			            " values ('"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"','"+sFlowNo+"', " +
			            " '"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sOrgName+"','"+sUserID+"', "+
			            " '"+sUserName+"','"+StringFunction.getToday()+"') ";
	    //在流程任务表FLOW_TASK中新增一笔信息
	    sSerialNo = DBFunction.getSerialNo("FLOW_TASK","SerialNo",Sqlca);
        String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
         				" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime) "+
         				" values ('"+sSerialNo+"','"+sObjectType+"','"+sObjectNo+"','"+sPhaseType+"','"+sApplyType+"', " + 
         				" '"+sFlowNo+"','"+sFlowName+"','"+sPhaseNo+"','"+sPhaseName+"','"+sOrgID+"','"+sUserID+"', " +
         				" '"+sUserName+"','"+sOrgName+"','"+sBeginTime+"' )";

	   
	    //执行插入语句
	    Sqlca.executeSQL(sSql1);
	    Sqlca.executeSQL(sSql2);
	    	    
	    return "1";
	    
	 }

}
