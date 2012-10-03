/*
		Author: --CYHui 2005-12-13
		Tester:
		Describe: --ȡ�õ�ǰ�ͻ�����ܻ���δ���嵥��׻�����Ч���������Ŀͻ�����
		Input Param:
				UserID���û�����
		Output Param:
				iCustomerAmount������
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetCustomerAmount extends Bizlet 
{
	public Object run(Transaction Sqlca) throws Exception
	{
		//��ȡ��ǰ�û�
		String sUserID = (String)this.getAttribute("UserID");
		
		//����ֵת���ɿ��ַ���
		if(sUserID == null) sUserID = "";
		
		//���������SQL���
		String sSql = "";
		int iCustomerAmount = 0;
				
		sSql =  "select nvl(count(distinct CustomerID),0) from BUSINESS_CONTRACT where OperateUserID ='"+sUserID+"' ";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCustomerAmount = rs.getInt(1);
		rs.getStatement().close();
		
		sSql = "select nvl(count(distinct CustomerID),0) from BUSINESS_APPROVE where OperateUserID ='"+sUserID+"' and CustomerID not in(select CustomerID from BUSINESS_CONTRACT where OperateUserID ='"+sUserID+"')";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCustomerAmount = iCustomerAmount + rs.getInt(1);
		rs.getStatement().close();
				
		return String.valueOf(iCustomerAmount);
	}
}