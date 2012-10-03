package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AlertCustomerRelationShip extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		// TODO Auto-generated method stub		
		String sRelationShip = (String)this.getAttribute("RelationShip");
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");
		if(sRelationShip == null) sRelationShip = "";
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		
		//定义变量
		String sSql = "";
		String sRelationName = "";
		
		String sReturnValue = "",CustomerDesc = "";
		ASResultSet rs = null;
				
		//取到反关系代码
		sSql = 	" select ItemName from CODE_LIBRARY "+
				" where CodeNo = 'RelationShip' "+
				" and ItemNo = '"+sRelationShip+"' ";
		sRelationName = Sqlca.getString(sSql);
		if(sRelationName == null) sRelationName = "";
		
		//取到客户自己的客户名称，证件类型，证件号码
		sSql = 	" select getCustomerName(CustomerID) as ReltiveCustomerName,CustomerName "+
				" from CUSTOMER_RELATIVE "+
				" where CertType = '"+sCertType+"' "+
				" and CertID='"+sCertID+"' "+
				" and RelationShip='"+sRelationShip+"'";
		rs = Sqlca.getASResultSet(sSql);	
		while (rs.next()) 
		{	
			CustomerDesc = "该"+sRelationName+"["+rs.getString("CustomerName")+"]与";
			sReturnValue+="["+rs.getString("ReltiveCustomerName")+"]";
		}
		rs.getStatement().close();
		if(!"".equals(sReturnValue))
		sReturnValue=CustomerDesc+sReturnValue+"已经是["+sRelationName+"]关系,请确认后登记!";
				
		return sReturnValue;
	}

}
