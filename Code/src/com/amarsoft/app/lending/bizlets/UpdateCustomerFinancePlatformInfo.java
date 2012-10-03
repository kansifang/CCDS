package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateCustomerFinancePlatformInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值	
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sFinancePlatformFlag   = (String)this.getAttribute("FinancePlatformFlag");//是否融资平台
		String sFinancePlatformType = (String)this.getAttribute("PlatformType");		 // 融资平台类型
		String sDealClassify = (String)this.getAttribute("DealClassify"); 				 // 处置分类
		
		if(sCustomerID == null) sCustomerID = "";
		if(sFinancePlatformFlag == null) sFinancePlatformFlag = "";
		if(sFinancePlatformType == null) sFinancePlatformType = "";
		if(sDealClassify == null) sDealClassify = "";
		
		//定义变量
		ASResultSet rs = null;
		String sSql = "";
	   
	    //更新融资平台相关值
	    sSql= " update ENT_INFO set FinancePlatformFlag='"+sFinancePlatformFlag+"',FinancePlatformType='"+sFinancePlatformType+"',"+
	          " DealClassify='"+sDealClassify+"'"+
	          " where CUSTOMERID='"+sCustomerID+"'" ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);
	    return "1";
	    
	 }

}
