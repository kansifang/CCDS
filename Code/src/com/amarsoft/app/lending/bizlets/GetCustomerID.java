package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetCustomerID extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		if(sObjectType==null) sObjectType="";
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo==null) sObjectNo="";
		String sCustomerID = "" ;
		
		String sSql = " select ObjectTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
		String sTableName = Sqlca.getString(sSql);
		if(sTableName!=null&&!sObjectNo.equals("")){
			sSql = "select CustomerID from "+sTableName+" where SerialNo='"+sObjectNo+"'";
			sCustomerID = Sqlca.getString(sSql);
		}
		return sCustomerID;
	}

}
