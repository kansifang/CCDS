package com.amarsoft.ReserveManage;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;

public class AccountCancelInfo {
	
	private Transaction Sqlca = null;
	
	public AccountCancelInfo(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
	
	/**
	 * 根据会计月份和贷款帐号获取本期核销金额信息
	 * @param sAccountMonth 会计月份,sLoanAccountNo 贷款帐号
	 * @return double 本期核销金额
	 */
	public double getCancelSum(String sAccountMonth,String sLoanAccountNo) throws Exception
	{
		//定义变量			
		ASResultSet rs = null;
		String sSql = "";
		double dCancelSum = 0.0;
				
		//获取本期的
		sSql = 	" select ALP0OCAM "+
				" from ALPFP0 "+
				" where ALP0DATE like '"+ sAccountMonth.substring(0, 4)+ sAccountMonth.substring(5, 7)+"%' " +
				" and ALP0ACNO = '"+sLoanAccountNo+"' "+
				" and ALP0MDCO in ('LD','LE') ";//LD:呆帐核销,LE:坏帐核销
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dCancelSum = rs.getDouble(1);
		}
		rs.getStatement().close();
		
		return dCancelSum;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			
		}catch(Exception e)
		{
			System.out.println(e.toString());
		}
	}
}
