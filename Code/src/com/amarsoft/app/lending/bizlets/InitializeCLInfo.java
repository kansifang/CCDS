/*
		Author: --魏治毅 2005-11-23
		Tester:
		Describe: --新增授信额度申请记录时，需同时在额度信息表CL_INFO中新增一笔记录
		Input Param:
				ObjectNo：申请编号
				BusinessType：业务品种
				CustomerID: 客户代码
				CustomerName: 客户名称				
		Output Param:

		HistoryLog: 增加工程机械按揭额度 added by lpzhang 2009-8-11
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.ASResultSet;
public class InitializeCLInfo extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");	
		//业务品种
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//客户编号
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//客户名称		
		String sCustomerName = (String)this.getAttribute("CustomerName");		
		//登记人
		String sInputUser = (String)this.getAttribute("InputUser");
		//登记机构
		String sInputOrg = (String)this.getAttribute("InputOrg");
		
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sCustomerID == null) sCustomerID = "";
	    if(sCustomerName == null) sCustomerName = "";
	    if(sInputUser == null) sInputUser = "";
	    if(sInputOrg == null) sInputOrg = "";
	    ASResultSet rs = null,rs1 = null;
	    
	    //获得当前时间
	    String sCurDate = StringFunction.getToday();
	    
	    //如果业务品种是额度，则必须在额度信息表CL_INFO中插入一笔信息
	    if(sBusinessType.startsWith("3") && !sBusinessType.equals("3020"))
	    {
	        String sSerialNo = DBFunction.getSerialNo("CL_INFO","LineID",Sqlca);
	        String sClTypeName=Sqlca.getString("select TypeName from Business_Type where typeno='"+sBusinessType+"'");
	        String sSql =  " insert into CL_INFO(LineID,CLTypeID,ClTypeName,ApplySerialNo,BusinessType,CustomerID,CustomerName, "+
	        	  		   " FreezeFlag,InputUser,InputOrg,InputTime,UpdateTime) "+
	                       " values ('"+sSerialNo+"','001','"+sClTypeName+"','"+sObjectNo+"','"+sBusinessType+"', '" + sCustomerID+"', " + 
	         			   " '"+sCustomerName+"','1','"+sInputUser+"','"+sInputOrg+"','"+sCurDate+"','"+sCurDate+"')";
        
	        //执行插入语句
		    Sqlca.executeSQL(sSql);
	    }
	    if(sBusinessType.equals("3020"))//工程机械按揭额度
	    {
	    	String sSerialNo = DBFunction.getSerialNo("ENT_AGREEMENT","SerialNo",Sqlca);
	    	String sSql =  " insert into ENT_AGREEMENT(SerialNo,AgreementType,CustomerID,CustomerName ,InputUserID,InputOrgID,InputDate,UpdateDate)"+
	    	 			   " values ('"+sSerialNo+"','ProjectAgreement','"+sCustomerID+"', " + 
	         			   " '"+sCustomerName+"','"+sInputUser+"','"+sInputOrg+"','"+sCurDate+"','"+sCurDate+"')";
	    	//执行插入语句
		    Sqlca.executeSQL(sSql);
		    
		    String sSql1 =  " insert into Apply_Relative(SerialNo,ObjectType,ObjectNo)"+
			   " values ('"+sObjectNo+"','ProjectAgreement','"+sSerialNo+"')" ;
			   
			 //执行插入语句
			Sqlca.executeSQL(sSql1);
		     
		    Sqlca.executeSQL("update Business_Apply set UseOrgList = '"+sInputOrg+"' where SerialNo = '"+sObjectNo+"'");
		    
	    }
	    /*if(sBusinessType.equals("3060"))//信用共同体授信额度
	    {	
	    	String sAssureGroupID = "",CLSerialNo = "",sLineID = "";
	    	String sCLTypeID = "",sParentLineID = "";
	    	//查询额度基本信息
	    	String sSql = 	" select LineID,CLTypeID "+
			" from CL_INFO where (ParentLineID is null or ParentLineID='') "+
			" and ApplySerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sParentLineID = rs.getString("LineID");
			}
			rs.getStatement().close();
			
	    	//循环查询信用共同体联保小组编号
	    	sSql = " select distinct AssureGroupID from CUSTOMER_RELATIVE  "+ 
	    				" where AssureGroupID is not null and  AssureGroupID<>'' "+
	    				" and CustomerID='"+sCustomerID+"' and RelationShip like '0701%'   ";
	    	rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
			{
				sAssureGroupID = rs.getString("AssureGroupID");
				//查询联保小组额度下额度分配信息
				String Sql1 = " select LineID from CL_INFO  "+ 
				" where ParentLineID is not null and ParentLineID<>'' "+
				" and BCSerialNo in(select SerialNo from BUSINESS_CONTRACT "+
				" where BusinessType ='3050' "+
				" and (DeleteFlag = ''  or  DeleteFlag is null)  "+
				" and InUseFlag='01' and (FinishDate='' or FinishDate is null)"+
				" and CustomerID='"+sAssureGroupID+"' )";
				rs1 = Sqlca.getASResultSet(Sql1);
				while(rs1.next())
				{
					CLSerialNo = DBFunction.getSerialNo("CL_INFO","LineID",Sqlca);
					sLineID = rs1.getString("LineID");
					String sSql2 =  " insert into cl_info(lineid,TermMonth,InputTime,"+
										" ApproveSerialNo,Currency,InputOrg,CLTypeID,"+
										" CustomerName,LineSum2,ParentLineID,"+
										" ApplySerialNo,MemberName,UpdateTime,"+
										" BCSerialNo,CustomerID,LineSum1,"+
										"InputUser,CLTypeName,MemberID,"+
										"Rotative) select '"+CLSerialNo+"',TermMonth,'"+sCurDate+"',"+
										" '','01','"+sInputOrg+"',CLTypeID,"+
										" '"+sCustomerName+"',LineSum2,'"+sParentLineID+"', "+
										" '"+sObjectNo+"',MemberName,'"+sCurDate+"',"+
										" '','"+sCustomerID+"',LineSum1,"+
										" '"+sInputUser+"',CLTypeName,MemberID,Rotative "+
										" from cl_info where LineID='"+sLineID+"'";
					//执行插入语句
					Sqlca.executeSQL(sSql2);
				}
				rs1.getStatement().close();
			}
			rs.getStatement().close();
	   
	    }*/
	    //默认为人民币
		Sqlca.executeSQL("Update Business_Apply  set BusinessCurrency = '01' where  SerialNo = '"+sObjectNo+"'");
	    
	    
		return "1";
	 }
}
