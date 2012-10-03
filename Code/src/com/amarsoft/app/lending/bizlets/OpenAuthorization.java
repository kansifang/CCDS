package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class OpenAuthorization extends Bizlet{

	public Object run(Transaction Sqlca) throws Exception {
		//获取参数：对象类型，对象编号和当前用户
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sUserID = (String)this.getAttribute("UserID");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sUserID == null) sUserID = "";
		
		//定义变量：返回结果、SQL语句、申请金额、授权敞口金额
		String result="false",sBusinessType = "",sSql = "";
		//定义变量：单笔敞口授权结果，单户敞口授权结果
		String BusinessResult="",UserResult="";
		//定义变量：客户编号
		String sCustomerID="";
		//定义变量：申请敞口金额，单笔敞口授权金额，用户已批敞口金额，单户敞口授权金额
		double dBusinessSum1 = 0,dAuBusinessSum1 = 0,dBusinessSum2 = 0,dAuBusinessSum2 = 0;
		//定义变量：查询结果集
		ASResultSet rs = null;
		//非业务申请或sObjectNo无有效值
		if(!sObjectType.trim().equals("CreditApply"))	
			return "false";
		if(sObjectNo.trim().equals(""))
			return "false";
			//获取申请敞口金额,业务品种
		sSql = "select CustomerID,(getErate(BusinessCurrency,'01',ERateDate)*(nvl(BusinessSum,0)-nvl(BailSum,0))) as BusinessSum ,BusinessType from BUSINESS_APPLY "+
			   " where SerialNo='"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
		{ 
			dBusinessSum1 = rs.getDouble("BusinessSum");
			sBusinessType = rs.getString("BusinessType");
			sCustomerID=rs.getString("CustomerID");
		}
		else {
			//这笔业务不存在
			rs.getStatement().close();
			return "false";
		}
		rs.getStatement().close();
		
		if(sBusinessType==null)sBusinessType = "";
		if(sCustomerID==null)sCustomerID = "";
		
		//业务品种为无效值
		if(sBusinessType.trim().equals(""))
			BusinessResult="NoExit";
			
		if(!sBusinessType.equals("")){
			//获取单笔敞口授权金额
			sSql = "select (getErate(BusinessExposureCurrency,'01','')*nvl(BusinessExposure,0)) as BusinessExposure from USER_AUTHORIZATION "+
				 " where UserID = '"+sUserID+"'  and  BusinessType=  '"+sBusinessType+"' and AUTHORIZATIONType='01'";
			rs = Sqlca.getASResultSet(sSql);
			
			if (rs.next())
				dAuBusinessSum1 = rs.getDouble("BusinessExposure");		
			else 
				BusinessResult="NoExit";
			rs.getStatement().close();
		}
			
		//获取单户敞口授权金额
		sSql = "select (getErate(BusinessExposureCurrency,'01','')*nvl(BusinessExposure,0)) as BusinessExposure from USER_AUTHORIZATION "+
			 " where UserID = '"+sUserID+"'  and AUTHORIZATIONType='02'";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
			dAuBusinessSum2 = rs.getDouble("BusinessExposure");		
		else 
			UserResult="NoExit";
		rs.getStatement().close();
		//如果单笔授权和单户授权都不存在，返回“false”
		if(BusinessResult.equals("NoExit")&&UserResult.equals("NoExit"))
			return "false";
		//有单笔授权，比较申请敞口金额，单笔敞口授权金额
		if (!BusinessResult.equals("NoExit")&&dBusinessSum1>dAuBusinessSum1) 
			return "false";
		else 
			BusinessResult="SUCCESS";
		//获取用户已批敞口金额	
		sSql = "select sum(getErate(BusinessCurrency,'01',ERateDate)*(nvl(Balance,0)-nvl(BailSum,0))) as Balance from BUSINESS_CONTRACT "+
			 " where CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
			dBusinessSum2 = rs.getDouble("Balance");
		//加上业务的申请敞口金额		
		dBusinessSum2+=dBusinessSum1;
		//有单户授权，比较用户已批敞口金额+申请敞口金额，单户敞口授权金额
		if (!UserResult.equals("NoExit")&&dBusinessSum2>dAuBusinessSum2) 
			return "false";
		else 
			UserResult="SUCCESS";
		
		//单笔授权和单户授权都通过
		if(UserResult.equals("SUCCESS")&&BusinessResult.equals("SUCCESS"))
			result="true";
		//只有单户授权且单户授权通过
		if(UserResult.equals("SUCCESS")&&BusinessResult.equals("NoExit"))
			result="true";
		//只有单笔授权且单笔授权通过
		if(BusinessResult.equals("SUCCESS")&&UserResult.equals("NoExit"))
			result="true";
		return result;
	}

}
