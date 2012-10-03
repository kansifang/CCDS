package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class OpenAuthorization extends Bizlet{

	public Object run(Transaction Sqlca) throws Exception {
		//��ȡ�������������ͣ������ź͵�ǰ�û�
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sUserID = (String)this.getAttribute("UserID");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sUserID == null) sUserID = "";
		
		//������������ؽ����SQL��䡢�������Ȩ���ڽ��
		String result="false",sBusinessType = "",sSql = "";
		//������������ʳ�����Ȩ���������������Ȩ���
		String BusinessResult="",UserResult="";
		//����������ͻ����
		String sCustomerID="";
		//������������볨�ڽ����ʳ�����Ȩ���û��������ڽ�����������Ȩ���
		double dBusinessSum1 = 0,dAuBusinessSum1 = 0,dBusinessSum2 = 0,dAuBusinessSum2 = 0;
		//�����������ѯ�����
		ASResultSet rs = null;
		//��ҵ�������sObjectNo����Чֵ
		if(!sObjectType.trim().equals("CreditApply"))	
			return "false";
		if(sObjectNo.trim().equals(""))
			return "false";
			//��ȡ���볨�ڽ��,ҵ��Ʒ��
		sSql = "select CustomerID,(getErate(BusinessCurrency,'01',ERateDate)*(nvl(BusinessSum,0)-nvl(BailSum,0))) as BusinessSum ,BusinessType from BUSINESS_APPLY "+
			   " where SerialNo='"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
		{ 
			dBusinessSum1 = rs.getDouble("BusinessSum");
			sBusinessType = rs.getString("BusinessType");
			sCustomerID=rs.getString("CustomerID");
		}
		else {
			//���ҵ�񲻴���
			rs.getStatement().close();
			return "false";
		}
		rs.getStatement().close();
		
		if(sBusinessType==null)sBusinessType = "";
		if(sCustomerID==null)sCustomerID = "";
		
		//ҵ��Ʒ��Ϊ��Чֵ
		if(sBusinessType.trim().equals(""))
			BusinessResult="NoExit";
			
		if(!sBusinessType.equals("")){
			//��ȡ���ʳ�����Ȩ���
			sSql = "select (getErate(BusinessExposureCurrency,'01','')*nvl(BusinessExposure,0)) as BusinessExposure from USER_AUTHORIZATION "+
				 " where UserID = '"+sUserID+"'  and  BusinessType=  '"+sBusinessType+"' and AUTHORIZATIONType='01'";
			rs = Sqlca.getASResultSet(sSql);
			
			if (rs.next())
				dAuBusinessSum1 = rs.getDouble("BusinessExposure");		
			else 
				BusinessResult="NoExit";
			rs.getStatement().close();
		}
			
		//��ȡ����������Ȩ���
		sSql = "select (getErate(BusinessExposureCurrency,'01','')*nvl(BusinessExposure,0)) as BusinessExposure from USER_AUTHORIZATION "+
			 " where UserID = '"+sUserID+"'  and AUTHORIZATIONType='02'";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
			dAuBusinessSum2 = rs.getDouble("BusinessExposure");		
		else 
			UserResult="NoExit";
		rs.getStatement().close();
		//���������Ȩ�͵�����Ȩ�������ڣ����ء�false��
		if(BusinessResult.equals("NoExit")&&UserResult.equals("NoExit"))
			return "false";
		//�е�����Ȩ���Ƚ����볨�ڽ����ʳ�����Ȩ���
		if (!BusinessResult.equals("NoExit")&&dBusinessSum1>dAuBusinessSum1) 
			return "false";
		else 
			BusinessResult="SUCCESS";
		//��ȡ�û��������ڽ��	
		sSql = "select sum(getErate(BusinessCurrency,'01',ERateDate)*(nvl(Balance,0)-nvl(BailSum,0))) as Balance from BUSINESS_CONTRACT "+
			 " where CustomerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
			dBusinessSum2 = rs.getDouble("Balance");
		//����ҵ������볨�ڽ��		
		dBusinessSum2+=dBusinessSum1;
		//�е�����Ȩ���Ƚ��û��������ڽ��+���볨�ڽ�����������Ȩ���
		if (!UserResult.equals("NoExit")&&dBusinessSum2>dAuBusinessSum2) 
			return "false";
		else 
			UserResult="SUCCESS";
		
		//������Ȩ�͵�����Ȩ��ͨ��
		if(UserResult.equals("SUCCESS")&&BusinessResult.equals("SUCCESS"))
			result="true";
		//ֻ�е�����Ȩ�ҵ�����Ȩͨ��
		if(UserResult.equals("SUCCESS")&&BusinessResult.equals("NoExit"))
			result="true";
		//ֻ�е�����Ȩ�ҵ�����Ȩͨ��
		if(BusinessResult.equals("SUCCESS")&&UserResult.equals("NoExit"))
			result="true";
		return result;
	}

}
