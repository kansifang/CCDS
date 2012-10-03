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
	 * ���ݻ���·ݺʹ����ʺŻ�ȡ���ں��������Ϣ
	 * @param sAccountMonth ����·�,sLoanAccountNo �����ʺ�
	 * @return double ���ں������
	 */
	public double getCancelSum(String sAccountMonth,String sLoanAccountNo) throws Exception
	{
		//�������			
		ASResultSet rs = null;
		String sSql = "";
		double dCancelSum = 0.0;
				
		//��ȡ���ڵ�
		sSql = 	" select ALP0OCAM "+
				" from ALPFP0 "+
				" where ALP0DATE like '"+ sAccountMonth.substring(0, 4)+ sAccountMonth.substring(5, 7)+"%' " +
				" and ALP0ACNO = '"+sLoanAccountNo+"' "+
				" and ALP0MDCO in ('LD','LE') ";//LD:���ʺ���,LE:���ʺ���
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
