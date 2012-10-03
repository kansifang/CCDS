package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong 2009-08-18
Tester:
Describe: --测算授信总量
Input Param:
		sCustomerID：客户编号
Output Param:
		EvaluateScore:授信风险总量
HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class ComputeCreditGross extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值
		String sCustomerID = (String)this.getAttribute("CustomerID");
		if(sCustomerID == null) sCustomerID = "";
		
		//返回标志
		String sReturnValue="";
		//定义变量：SQL语句、成员授信总量、集团成员总量
		String sSql = "",sEvaluateScore = "0.00",sCognScore = "0.00";
		//定义变量：查询结果集、查询结果集1
		ASResultSet rs = null;
		
	//1.集团成员授信总量
		sSql = " select  "+
			" SUM((case when BC.BusinessSum is null then 0 else BC.BusinessSum end) "+
			" *geterate(BC.Businesscurrency,'01',ERateDate)) as EvaluateScore "+
			" from BUSINESS_CONTRACT BC"+
			" where  BC.SerialNo in("+
			" select BCSerialNo  from CL_INFO"+  
			" Where LineEffDate <= '"+StringFunction.getToday()+"'"+  
			" and BeginDate <= '"+StringFunction.getToday()+"'  "+
			" and EndDate >= '"+StringFunction.getToday()+"'  "+
			" and BCSerialNo is not null "+
			" and BCSerialNo <> ''  "+
			" and (ParentLineID is null  or ParentLineID = '')"+  
			" and (FreezeFlag = '1'  or FreezeFlag = '3')) "+
			" and exists(select 1 from CUSTOMER_RELATIVE where  RelativeID=BC.CustomerID and RelationShip like '04%' " +
			" and length(RelationShip)>2 and CustomerID='"+sCustomerID+"') ";
		
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{	
			sEvaluateScore = rs.getString("EvaluateScore");
		}
		rs.getStatement().close();
		
	//2.集团成员总量
		sSql = " select Sum((case when Balance is null then BusinessSum else Balance end) " +
			" *geterate(Businesscurrency,'01',ERateDate)) as CognScore "+
			" from BUSINESS_CONTRACT BC "+
			" where (BC.FinishDate = '' or BC.FinishDate is null)  "+
			" and (BC.RecoveryOrgID = '' or BC.RecoveryOrgID is null)  "+
			" and  BC.Balance >= 0   "+
			" and BC.ApplyType in('IndependentApply','DependentApply') "+
			" and exists(select 1 from CUSTOMER_RELATIVE where  RelativeID=BC.CustomerID and RelationShip like '04%' " +
			" and length(RelationShip)>2 and CustomerID='"+sCustomerID+"') ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sCognScore = rs.getString("CognScore");
		}
		rs.getStatement().close();
		sReturnValue=sEvaluateScore+"@"+sCognScore;
		return sReturnValue;
	}
	
}
