package com.amarsoft.app.lending.bizlets;
/*
Author: --xlyu 2012-03-21
Tester:
Describe: --风险分类权限判断
Input Param:
		ObjectNo：分类流水号
		RoleID：当前角色ID
Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ClassifyRightCheck extends Bizlet{

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		
		String sObjectNo = (String)this.getAttribute("ObjectNo");//分类流水号
		String sRoleID = (String)this.getAttribute("RoleID");
		String sLowRisk = "";//1低风险，2一般风险
		String sCustomerid = "";//客户编号
		double dSumCreditBalance = 0;//非低风险敞口余额
		double dLowSumCreditBalance = 0;//低风险敞口余额
		double dRiskSum = 0;//一般风险金额
		double dLowRiskSum = 0;//低风险金额
		String sCustomerType = "";//客户类型 01、公司  03、个人
		String sClassifyResult = "";//风险分类结果
		String result = "";
        //获取业务是否是低风险
		String sSql = "select LowRisk, Customerid "+
		              " from Business_Contract where SerialNo=(select ObjectNo from CLASSIFY_RECORD where SerialNo='"+sObjectNo+"')";
		ASResultSet rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{
			sLowRisk = rs.getString("LowRisk");
			sCustomerid= rs.getString("Customerid");
			if(sLowRisk == null) sLowRisk="";
			if(sCustomerid == null) sCustomerid="";
		
		}
		rs.getStatement().close();
		//风险分类结果
		sClassifyResult =Sqlca.getString("select ClassifyLevel from CLASSIFY_RECORD where SerialNo='"+sObjectNo+"' ");
		sClassifyResult=sClassifyResult.substring(0,2);
		//非低风险敞口余额
		dSumCreditBalance=Sqlca.getDouble("select sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)) from Business_Contract where customerid='"+sCustomerid+"' "+"" +
				" and (LOWRISK <> '1' or LOWRISK is null) and (FinishDate = '' or FinishDate is null) ");
		//低风险敞口余额
		dLowSumCreditBalance=Sqlca.getDouble("select sum(nvl(Balance,0)*geterate(Businesscurrency,'01',ERateDate)) from Business_Contract where customerid='"+sCustomerid+"' "+"" +
				" and LOWRISK = '1' and (FinishDate = '' or FinishDate is null) ");
		//客户类型
		sCustomerType=Sqlca.getString("select CustomerType from Customer_Info where customerid='"+sCustomerid+"' ");
		sCustomerType=sCustomerType.substring(0,2);
		//获取权限配置中金额、角色
	   	sSql = "select LowRiskSum,RiskSum from Classify_Auth where ClassifyResult = '"+sClassifyResult+"'"+
	           " and  CustomerType='"+sCustomerType+"'"+
	    	   " and RoleID = '"+sRoleID+"'";
	    
		rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{
			dLowRiskSum = rs.getDouble("LowRiskSum");
			dRiskSum = rs.getDouble("RiskSum");
			
		}
		rs.getStatement().close();
        if(sLowRisk.equals("1"))
        {
        	if( dLowRiskSum >= dLowSumCreditBalance) result = "TRUE";
        }else if(dRiskSum >= dSumCreditBalance) result = "TRUE";
        else result = "FALSE";
        System.out.println("------------result:"+result);
        return result;
       
	}
}
