package com.amarsoft.ReserveManage;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;


public class CustomerInfo {
	
	private Transaction Sqlca = null;
	
	public CustomerInfo(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
	
	/**
	 * 根据贷款帐号获取客户的组织机构代码
	 * @param sLoanAccountNo 贷款帐号
	 * @return String 组织机构代码
	 */
	public String getCertID(String sLoanAccountNo) throws Exception
	{
		//定义变量			
		ASResultSet rs = null;
		String sSql = "";
		String sCertID = "";
		
		//根据贷款帐号获取客户组织机构代码
		sSql = 	" select CIF30ZZDM "+
				" from CIF30PF  "+
				" where CIF30ACNO = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sCertID = rs.getString("CIF30ZZDM");			
		}
		rs.getStatement().close();
		
		return sCertID;
	}
}
