package com.amarsoft.app.lending.bizlets;
/*
Author: --jbye 2007-1-14 15:03
Tester:
Describe: --���ͻ���Ϣ״̬
Input Param:
	CustomerType���ͻ�����
		01����˾�ͻ���
		0201��һ�༯�ſͻ���
		0202�����༯�ſͻ���ϵͳ��ʱ���ã���
		03�����˿ͻ���
	CustomerName:�ͻ�����
	CertType:�ͻ�֤������
	CertID:�ͻ�֤������
Output param:
		ReturnStatus:����״̬
				01Ϊ�޸ÿͻ�
				02Ϊ��ǰ�û�����ÿͻ���������
				04Ϊ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ.
				05Ϊ��ǰ�û�û����ÿͻ���������,���к������ͻ���������Ȩ.
		History Log: 			
*/
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckCustomerAction extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{
		//��ȡҳ��������ͻ����͡��ͻ����ơ�֤�����͡�֤�����
		String sCustomerType = (String)this.getAttribute("CustomerType");
		String sCustomerName = (String)this.getAttribute("CustomerName");	
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");	
		String sUserID = (String)this.getAttribute("UserID");	
		
		//���������Sql��䡢������Ϣ���ͻ����롢����Ȩ
		String sSql = "",sReturnStatus = "",sCustomerID = "";	
		//���������������
		int iCount = 0;
		//�����������ѯ�����
		ASResultSet rs = null;
		
		//����ֵת��Ϊ���ַ���
		if(sCustomerType == null) sCustomerType = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		
		//�ǹ������ſͻ���ͨ��֤�����͡�֤���������Ƿ���CI���д�����Ϣ	
		if(!sCustomerType.substring(0,2).equals("02"))		
			sSql = 	" select CustomerID "+
					" from CUSTOMER_INFO "+
					" where CertType = '"+sCertType+"' "+
					" and CertID = '"+sCertID+"' ";
		else //�������ſͻ�ͨ���ͻ����Ƽ���Ƿ���CI���д�����Ϣ
			sSql = 	" select CustomerID "+
					" from CUSTOMER_INFO "+
					" where CustomerName = '"+sCustomerName+"' "+
					" and CustomerType = '"+sCustomerType+"' ";
		sCustomerID = Sqlca.getString(sSql);
		if(sCustomerID == null) sCustomerID = "";
		
		if(sCustomerID.equals(""))
		{
			//�޸ÿͻ�
			sReturnStatus = "01";
		}else
		{
			//�õ���ǰ�û���ÿͻ�֮��ܻ���ϵ
			sSql = 	" select count(CustomerID) "+
					" from CUSTOMER_BELONG "+
					" where CustomerID = '"+sCustomerID+"' "+
					" and UserID = '"+sUserID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			   	iCount = rs.getInt(1);
			rs.getStatement().close(); 
			
			if(iCount > 0)
			{
	  			//02Ϊ��ǰ�û�����ÿͻ�������Ч����
	 			sReturnStatus = "02";
			}else
			{
				//���ÿͻ��Ƿ��йܻ���
				sSql = 	" select count(CustomerID) "+
						" from CUSTOMER_BELONG "+
						" where CustomerID = '"+sCustomerID+"' "+
						" and BelongAttribute = '1'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				   	iCount = rs.getInt(1);
		
				rs.getStatement().close(); 
				
				if(iCount > 0)
				{
	  				//05Ϊ��ǰ�û�û����ÿͻ���������,���кͿͻ���������Ȩ.
					sReturnStatus = "05";
				}else
				{
	  				//04Ϊ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ.
					sReturnStatus = "04";
				}
			}
		}
		return sReturnStatus+"@"+sCustomerID;
	}	
		
}
