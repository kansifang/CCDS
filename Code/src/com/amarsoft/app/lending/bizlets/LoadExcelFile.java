package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class LoadExcelFile extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		// TODO Auto-generated method stub		
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sRelativeID = (String)this.getAttribute("RelativeID");
		String sRelationShip = (String)this.getAttribute("RelationShip");
		
		if(sCustomerID == null) sCustomerID = "";
		if(sRelativeID == null) sRelativeID = "";
		if(sRelationShip == null) sRelationShip = "";
		
		//定义变量
		String sSql = "";
		String sNewRelation = "";
		
		String sCustomerName = "";
		String sCertType = "";
		String sCertID = "";
		ASResultSet rs = null;
				
		//取到反关系代码
		sSql = 	" select ItemDescribe from CODE_LIBRARY "+
				" where CodeNo = 'RelationShip' "+
				" and ItemNo = '"+sRelationShip+"' ";
		sNewRelation = Sqlca.getString(sSql);
		if(sNewRelation == null) sNewRelation = "";
		
		//取到客户自己的客户名称，证件类型，证件号码
		sSql = 	" select CustomerName,CertType,CertID "+
				" from CUSTOMER_INFO "+
				" where CustomerID = '"+sCustomerID+"' ";
		rs = Sqlca.getASResultSet(sSql);	
		if (rs.next()) 
		{					
			sCustomerName = rs.getString("CustomerName");	
			sCertType = rs.getString("CertType");
			sCertID = rs.getString("CertID");
			if(sCustomerName == null) sCustomerName = "";
			if(sCertType == null) sCertType = "";
			if(sCertID == null) sCertID = "";
		}
		rs.getStatement().close();
		
		//先删除反关系，防止插入失败
		sSql =  " delete from CUSTOMER_RELATIVE where CustomerID= '"+sRelativeID+"' and "+
				" RelativeID= '"+sCustomerID+"' and RelationShip= '"+sNewRelation+"'";
		Sqlca.executeSQL(sSql);
		//插入反关系记录，其余字段相同，关系代码，客户名字，证件类型，证件号码用取到的值代替
		sSql =  " insert into CUSTOMER_RELATIVE(CustomerID,RelativeID,RelationShip,CustomerName,"+
				" CertType,CertID,FictitiousPerson,CurrencyType,InvestmentSum,OughtSum,InvestmentProp,"+
				" InvestDate,StockcertNo,Duty,Telephone,Effect,Whethen1,Whethen2,Whethen3,Whethen4,"+
				" Whethen5,Describe,InputOrgID,InputUserID,InputDate,UpdateDate,Remark) "+
				" select RelativeID,CustomerID,'"+sNewRelation+"','"+sCustomerName+"','"+sCertType+"','"+sCertID+"',"+
				" FictitiousPerson,CurrencyType,InvestmentSum,OughtSum,InvestmentProp,"+
				" InvestDate,StockcertNo,Duty,Telephone,Effect,Whethen1,Whethen2,"+
				" Whethen3,Whethen4,Whethen5,Describe,InputOrgID,InputUserID,"+
				" InputDate,UpdateDate,Remark FROM CUSTOMER_RELATIVE "+
				" where CustomerID='"+sCustomerID+"' and RelativeID='"+sRelativeID+"' "+
				" and RelationShip='"+sRelationShip+"'";
		Sqlca.executeSQL(sSql);
				
		return "1";
	}

}
