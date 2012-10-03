package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateRelation extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值	
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sRelativeID   = (String)this.getAttribute("RelativeID");
		String sRelationShip = (String)this.getAttribute("RelationShip");
		
		if(sCustomerID == null) sCustomerID = "";
		if(sRelativeID == null) sRelativeID = "";
		if(sRelationShip == null) sRelationShip = "";
		
		//定义变量
		ASResultSet rs = null;
		String sItemDescribe = "";
		String sCurrencyType = "",sInvestDate = "";
		double dInvestmentSum = 0.0,dOughtSum = 0.0,dInvestmentProp=0.0;
		String sSql = "";
		//取到反关系代码
		sSql=" select ItemDescribe from CODE_LIBRARY where CODENO = 'RelationShip' and ITEMNO ='"+sRelationShip+"'";
		rs = Sqlca.getResultSet(sSql);
	    if(rs.next())
	    {
	    	sItemDescribe = rs.getString(1);
	    }
	    
	    rs.getStatement().close();
	    //取到投资金额日期相关值
	    sSql=" select CurrencyType,nvl(InvestmentSum,0),nvl(OughtSum,0),nvl(InvestmentProp,0),InvestDate "+
	         " from CUSTOMER_RELATIVE "+
	         " where CustomerID='"+sCustomerID+"' and RelativeID='"+sRelativeID+"' and RelationShip='"+sRelationShip+"' ";
	    System.out.println(sSql);
	    rs = Sqlca.getResultSet(sSql);
	    if(rs.next())
	    {
	    	sCurrencyType = rs.getString(1);
	    	dInvestmentSum = rs.getDouble(2);
	    	dOughtSum = rs.getDouble(3);
	    	dInvestmentProp = rs.getDouble(4);
	    	sInvestDate = rs.getString(5);
	    }
	    if(sInvestDate== null) sInvestDate = "";
	    rs.getStatement().close();
	   
	    //更新反关系投资金额日期相关值
	    sSql= " update CUSTOMER_RELATIVE set CURRENCYTYPE='"+sCurrencyType+"',INVESTMENTSUM="+dInvestmentSum+","+
	          " OUGHTSUM="+dOughtSum+",INVESTMENTPROP="+dInvestmentProp+",INVESTDATE='"+sInvestDate+"' "+
	          " where CUSTOMERID='"+sCustomerID+"' and RELATIVEID='"+sRelativeID+"' and RELATIONSHIP='"+sRelationShip+"'" ;
	    
	    //执行更新语句
	    Sqlca.executeSQL(sSql);
	    //更新反关系投资金额日期相关值
	    sSql= " update CUSTOMER_RELATIVE set CURRENCYTYPE='"+sCurrencyType+"',INVESTMENTSUM="+dInvestmentSum+","+
	          " OUGHTSUM="+dOughtSum+",INVESTMENTPROP="+dInvestmentProp+",INVESTDATE='"+sInvestDate+"' "+
	          " where CUSTOMERID='"+sRelativeID+"' and RELATIVEID='"+sCustomerID+"' and RELATIONSHIP='"+sItemDescribe+"'" ;
	    
	    //执行更新语句
	    Sqlca.executeSQL(sSql);
	    return "1";
	    
	 }

}
