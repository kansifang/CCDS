package com.amarsoft.app.lending.bizlets;
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

		HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReinforceCLInfo extends Bizlet 
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
		//申请金额
		double dBusinessSum =0;
		
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sCustomerID == null) sCustomerID = "";
	    if(sCustomerName == null) sCustomerName = "";
	    if(sInputUser == null) sInputUser = "";
	    if(sInputOrg == null) sInputOrg = "";
	   	
	    //获得当前时间
	    String sCurDate = StringFunction.getToday();
	    
	    //获得申请金额
	    String sSql1 = " select BusinessSum from BUSINESS_CONTRACT Where SerialNo= '"+sObjectNo+"'";
	    ASResultSet rs = Sqlca.getASResultSet(sSql1);
	    if(rs.next()){
	    	dBusinessSum = rs.getDouble("BusinessSum");
	    }
	    rs.getStatement().close();
	    
	    //如果业务品种是综合授信额度，则必须在额度信息表CL_INFO中插入一笔信息
	    //modify by hlzhang 2008-08-07 增加三种综合授信额度，并在额度信息表CL_INFO中插入相应信息
	       if(sBusinessType.startsWith("3") && !sBusinessType.equals("3020"))
	    {
	        String sSerialNo = DBFunction.getSerialNo("CL_INFO","LineID",Sqlca);
	        String sClTypeName=Sqlca.getString("select TypeName from Business_Type where typeno='"+sBusinessType+"'");
	        String sSql =  " insert into CL_INFO(LineID,CLTypeID,ClTypeName,BCSerialNo,BusinessType,CustomerID,CustomerName, "+
	        	  		   " FreezeFlag,InputUser,InputOrg,InputTime,UpdateTime) "+
	                       " values ('"+sSerialNo+"','001','"+sClTypeName+"','"+sObjectNo+"','"+sBusinessType+"', '" + sCustomerID+"', " + 
	         			   " '"+sCustomerName+"','1','"+sInputUser+"','"+sInputOrg+"','"+sCurDate+"','"+sCurDate+"')";
        
	        //执行插入语句
		    Sqlca.executeSQL(sSql);
	    }
	   
	    
		return "1";
	 }
}
