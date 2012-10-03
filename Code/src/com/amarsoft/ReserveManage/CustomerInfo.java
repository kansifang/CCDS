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
	 * ���ݴ����ʺŻ�ȡ�ͻ�����֯��������
	 * @param sLoanAccountNo �����ʺ�
	 * @return String ��֯��������
	 */
	public String getCertID(String sLoanAccountNo) throws Exception
	{
		//�������			
		ASResultSet rs = null;
		String sSql = "";
		String sCertID = "";
		
		//���ݴ����ʺŻ�ȡ�ͻ���֯��������
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
