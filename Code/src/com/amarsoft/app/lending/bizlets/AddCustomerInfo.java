package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;

public class AddCustomerInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sCustomerName = (String)this.getAttribute("CustomerName");
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");
		String sLoanCardNo = (String)this.getAttribute("LoanCardNo");
		String sUserID = (String)this.getAttribute("UserID");
		
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		if(sLoanCardNo == null ||"#LoanCardNo".equals(sLoanCardNo) ) sLoanCardNo = "";
		if(sUserID == null) sUserID = "";
		
		//�������
		ASResultSet rs = null;
		String sSql = "";
		int iCount = 0;
		
		//ʵ�����û�����
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		
		//���ݿͻ���Ų�ѯϵͳ���Ƿ��ѽ����Ŵ���ϵ
		sSql = 	" select count(CustomerID) from CUSTOMER_INFO "+
				" where CustomerID = '"+sCustomerID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		if(iCount == 0)
		{			
			if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ent"))//��˾�ͻ�������ͻ�����С��3���ַ�������Ƚ�
			{				
				//��CI�����½���¼	
				//�ͻ���š��ͻ����ơ��ͻ����͡�֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ�����	����Դ������������	
				sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel,LoanCardNo,CustomerScale) "+
					   " values('"+sCustomerID+"','"+sCustomerName+"','0101','"+sCertType+"','"+sCertID+"','"+CurUser.OrgID+"', "+
					   " '"+CurUser.UserID+"','"+StringFunction.getToday()+"','2','"+sLoanCardNo+"','010')";
				Sqlca.executeSQL(sSql);
				
				//֤������Ϊ��֯��������
				if(sCertType.equals("Ent01"))
				{
					//�ͻ���š���֯��������֤��š��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ�������
					sSql = " insert into ENT_INFO(CustomerID,CorpID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
						   " values('"+sCustomerID+"','"+sCertID+"','"+sCustomerName+"','0101','0','"+CurUser.OrgID+"','"+CurUser.UserID+"', "+
						   " '"+StringFunction.getToday()+"','"+CurUser.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+sLoanCardNo+"')";
					Sqlca.executeSQL(sSql);
				//֤������ΪӪҵִ��
				}else if(sCertType.equals("Ent02"))
				{
					//�ͻ���š�Ӫҵִ�պš��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ�������
					sSql = " insert into ENT_INFO(CustomerID,LicenseNo,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
						   " values('"+sCustomerID+"','"+sCertID+"','"+sCustomerName+"','0101','0','"+CurUser.OrgID+"','"+CurUser.UserID+"', "+
						   " '"+StringFunction.getToday()+"','"+CurUser.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+sLoanCardNo+"')";
					Sqlca.executeSQL(sSql);
				
				}else
				{
					//�ͻ���š��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ�������
					sSql = " insert into ENT_INFO(CustomerID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
						   " values('"+sCustomerID+"','"+sCustomerName+"','0101','0','"+CurUser.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"', "+
						   " '"+CurUser.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+sLoanCardNo+"')";
					Sqlca.executeSQL(sSql);
				}	
			}else if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ind")) //���˿ͻ�������ͻ�����С��3���ַ�������Ƚ�
			{
				//��CI�����½���¼	
				//�ͻ���š��ͻ����ơ��ͻ����͡�֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ�����	����Դ������������	
				sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel,LoanCardNo) "+
					   " values('"+sCustomerID+"','"+sCustomerName+"','03','"+sCertType+"','"+sCertID+"','"+CurUser.OrgID+"', "+
					   " '"+CurUser.UserID+"','"+StringFunction.getToday()+"','2','"+sLoanCardNo+"')";
				Sqlca.executeSQL(sSql);
				
				//�ͻ���š�������֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ����ڡ���������
				sSql = " insert into IND_INFO(CustomerID,FullName,CertType,CertID,InputOrgID,InputUserID,InputDate,UpdateDate,CreditBelong) "+
					   " values('"+sCustomerID+"','"+sCustomerName+"','"+sCertType+"','"+sCertID+"','"+CurUser.OrgID+"', "+
					   " '"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"','501')";
				Sqlca.executeSQL(sSql);
			}
		}else
		{
			sSql = " select LoanCardNo from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
			String sExistLoanCardNo = Sqlca.getString(sSql);
			if(sExistLoanCardNo == null) sExistLoanCardNo = "";
			
			if(sExistLoanCardNo.equals("") || !sExistLoanCardNo.equals(sLoanCardNo))
			{
				sSql = 	" update CUSTOMER_INFO set LoanCardNo = '"+sLoanCardNo+"' "+
						" where CustomerID = '"+sCustomerID+"' ";
				Sqlca.executeSQL(sSql);
				//����ENT_INFO��IND_INFO�еĴ���ţ�����һ��
				if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ent"))//��˾�ͻ�������ͻ�����С��3���ַ�������Ƚ�
			    {
					sSql =  " update ENT_INFO set LoanCardNo = '"+sLoanCardNo+"' "+
			                " where CustomerID = '"+sCustomerID+"' ";
					Sqlca.executeSQL(sSql);
			    }else if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ind")) //���˿ͻ�������ͻ�����С��3���ַ�������Ƚ�
			    {
			    	sSql =  " update IND_INFO set LoanCardNo = '"+sLoanCardNo+"' "+
			    			" where CustomerID = '"+sCustomerID+"' ";
			    	Sqlca.executeSQL(sSql);
			    }
			}
		}
		
		return "1";
	}
}
