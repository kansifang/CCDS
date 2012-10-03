package com.amarsoft.app.util;

import com.amarsoft.are.sql.Transaction;



/**
 * @author lpzhang 2009-8-20 
 * 机构项下权限控制
 *
 */
public class OrgCondition {
		
	public OrgCondition()
	{
		
	}
	public static String getOrgCondition(String sFieldName,String sOrgID,Transaction Sqlca) throws Exception{
		String sOrgLevel = "";
		String sCondition = "";
		
		sOrgLevel = Sqlca.getString("select OrgLevel from ORG_INFO where OrgID = '"+sOrgID+"'");
		if(sOrgLevel == null) sOrgLevel = "";
		if(sOrgLevel.equals(""))
			sCondition = " and 1=2 ";
		else if(sOrgLevel.equals("0"))
			sCondition = " and 1=1 ";
		else 
			sCondition = " and "+sFieldName+" in (select BelongOrgID from ORG_BELONG where OrgID = '"+sOrgID+"') ";
		return sCondition;
	}
	
	public static void main(String[] args) {
		
	}
	
}
