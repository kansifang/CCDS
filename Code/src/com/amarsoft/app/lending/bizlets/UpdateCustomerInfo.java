package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateCustomerInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//��ò����������Ŀͻ����ơ�֤�����͡�֤����źʹ�����	
	 	String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sNewCustomerName   = (String)this.getAttribute("NewCustomerName");
		String sNewCertType   = (String)this.getAttribute("NewCertType");
		String sNewCertID = (String)this.getAttribute("NewCertID");
		String sNewLoanCardNo = (String)this.getAttribute("NewLoanCardNo");
		//�������
		String sSql = "",sCustomerType = "";
			   	
		//���ݿͻ���Ż�ÿͻ�����
		sSql = " select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
		sCustomerType = Sqlca.getString(sSql);
		if (sCustomerType == null) sCustomerType = "";
		
	    //���¿ͻ�������Ϣ��
	    sSql = " update CUSTOMER_INFO set "+
	    	   " CustomerName = '"+sNewCustomerName+"', "+
	    	   " CertType='"+sNewCertType+"', "+
	           " CertID = '"+sNewCertID+"', "+
	           " LoanCardNo = '"+sNewLoanCardNo+"' "+
	           " where CUSTOMERID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);
	    
	    if (!sCustomerType.equals("03")) //�Ǹ��˿ͻ�
	    {
	    	
			if(sNewCertType.equals("Ent01"))//֤������Ϊ��֯��������
			{
				//������ҵ������Ϣ��
			    sSql = " update ENT_INFO set "+
			    	   " EnterpriseName = '"+sNewCustomerName+"', "+
			    	   " CorpID = '"+sNewCertID+"', "+
			    	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
		        	   " where CustomerID = '"+sCustomerID+"' " ;
			}else if(sNewCertType.equals("Ent02"))//֤������ΪӪҵִ��
			{
				//������ҵ������Ϣ��
			    sSql = " update ENT_INFO set "+
			    	   " EnterpriseName = '"+sNewCustomerName+"', "+
			    	   " LicenseNo = '"+sNewCertID+"', "+
			    	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
		        	   " where CustomerID = '"+sCustomerID+"' " ;				
			}else
			{
		    	//������ҵ������Ϣ��
			    sSql = " update ENT_INFO set "+
			    	   " EnterpriseName = '"+sNewCustomerName+"', "+
			    	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
		        	   " where CustomerID = '"+sCustomerID+"' " ;
			}
	    }else
	    {
		    //���¸��˻�����Ϣ��
		    sSql = " update IND_INFO set "+
		    	   " FullName = '"+sNewCustomerName+"', "+
		    	   " CertType='"+sNewCertType+"', "+
	        	   " CertID = '"+sNewCertID+"' "+
	        	   " where CustomerID = '"+sCustomerID+"' " ;	    
	    }
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	
	    
	    //���°���̨����Ϣ��
	    sSql = " update LAWCASE_BOOK set "+
	    	   " BankruptcyOrgName = '"+sNewCustomerName+"' "+
        	   " where BankruptcyOrgID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);
	    
	    //���µ�����ͬ��Ϣ��
	    sSql = " update GUARANTY_CONTRACT set "+
	    	   " GuarantorName = '"+sNewCustomerName+"', "+
	    	   " CertType='"+sNewCertType+"', "+	    	   
        	   " CertID = '"+sNewCertID+"', "+
        	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
        	   " where GuarantorID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);
	 
	    //���µ�������ʲ���������¼��
	    sSql = " update GUARANTY_CHANGE set "+
	    	   " OldOwnerName = '"+sNewCustomerName+"', "+
	    	   " OldCertType='"+sNewCertType+"', "+	    	   
        	   " OldCertID = '"+sNewCertID+"', "+
        	   " OldLoanCardNo = '"+sNewLoanCardNo+"' "+
        	   " where OldOwnerID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	
	    
	    sSql = " update GUARANTY_CHANGE set "+
	    	   " NewOwnerName = '"+sNewCustomerName+"', "+
	    	   " NewCertType='"+sNewCertType+"', "+	    	   
        	   " NewCertID = '"+sNewCertID+"', "+
        	   " NewLoanCardNo = '"+sNewLoanCardNo+"' "+
 	   		   " where NewOwnerID = '"+sCustomerID+"' " ;
		//ִ�и������
		Sqlca.executeSQL(sSql);	   
	    
	    //���µ�������Ϣ��
	    sSql = " update GUARANTY_INFO set "+
	    	   " OwnerName = '"+sNewCustomerName+"', "+
	    	   " CertType='"+sNewCertType+"', "+	    	   
        	   " CertID = '"+sNewCertID+"', "+
        	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
        	   " where OwnerID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	    
	    
	    //���·�������װ����Ϣ��
	    sSql = " update BUILDING_DEAL set "+
	    	   " ObligeeName = '"+sNewCustomerName+"' "+
        	   " where ObligeeID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	
	    
	    sSql = " update BUILDING_DEAL set "+
	    	   " AgencyName = '"+sNewCustomerName+"' "+
		 	   " where AgencyID = '"+sCustomerID+"' " ;
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	
		 
	     sSql = " update BUILDING_DEAL set "+
	     	    " FitOrgName = '"+sNewCustomerName+"' "+
	 	        " where FitOrgID = '"+sCustomerID+"' " ;
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	
	    
	    //���¸��˹���������
	    sSql = " update IND_RESUME set "+
	    	   " Employment = '"+sNewCustomerName+"' "+
        	   " where CompanyCode = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);
	    
	    //���¿�����¥����Ϣ��
	    sSql = " update BUILDING_INFO set "+
	    	   " DeveloperName = '"+sNewCustomerName+"' "+
        	   " where DeveloperID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	    
	    
	    sSql = " update BUILDING_INFO set "+
	    	   " BuilderName = '"+sNewCustomerName+"' "+
	     	   " where BuilderID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	    
		 
	    //���¿ͻ�������Ϣ��
	    sSql = " update CUSTOMER_RELATIVE set "+
	    	   " CustomerName = '"+sNewCustomerName+"', "+
	    	   " CertType='"+sNewCertType+"', "+
        	   " CertID = '"+sNewCertID+"', "+
        	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
        	   " where RelativeID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	    
	    
	    //����ó�׺�ͬ��Ϣ��
	    sSql = " update CONTRACT_INFO set "+
	    	   " PurchaserName = '"+sNewCustomerName+"' "+
        	   " where PurchaserID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	
	    	    
	    sSql = " update CONTRACT_INFO set "+
	    	   " BargainorName = '"+sNewCustomerName+"' "+
        	   " where BargainorID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    //����Ʊ����Ϣ��
	    sSql = " update BILL_INFO set "+
	    	   " Writer = '"+sNewCustomerName+"' "+
        	   " where WriterID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    	    
	    sSql = " update BILL_INFO "+
	    	   " set Holder = '"+sNewCustomerName+"' "+
        	   " where HolderID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    sSql = " update BILL_INFO set "+
	    	   " Beneficiary = '"+sNewCustomerName+"' "+
        	   " where BeneficiaryID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    	    
	    sSql = " update BILL_INFO set "+
	    	   " Acceptor = '"+sNewCustomerName+"' "+
        	   " where AcceptorID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    //���������ṩ�����˱�
	    sSql = " update BUSINESS_PROVIDER set "+
	    	   " ProviderName = '"+sNewCustomerName+"' "+
        	   " where ProviderNo = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    //������Ŀ������Ϣ��
	    sSql = " update PROJECT_INFO set "+
	    	   " DevelopmentName = '"+sNewCustomerName+"' "+
        	   " where DevelopmentID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    sSql = " update PROJECT_INFO set "+
	    	   " CopartnerName = '"+sNewCustomerName+"' "+
        	   " where CopartnerID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    //������Ŀ�ʽ���Դ��Ϣ��
	    sSql = " update PROJECT_FUNDS set "+
	    	   " InvestorName = '"+sNewCustomerName+"' "+
        	   " where InvestorCode = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    //����������Ϣ��
	    sSql = " update CONSUME_INFO set "+
	    	   " DealerName = '"+sNewCustomerName+"' "+
        	   " where DealerID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    //����ҵ�����֪ͨ����
	    sSql = " update BUSINESS_PUTOUT set "+
			   " CertType='"+sNewCertType+"', "+
		 	   " CertID = '"+sNewCertID+"', "+
	    	   " CustomerName = '"+sNewCustomerName+"' "+
        	   " where CustomerID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    //����ҵ���ͬ��Ϣ��
	    sSql = " update BUSINESS_CONTRACT set "+
	    	   " CustomerName = '"+sNewCustomerName+"' "+
        	   " where CustomerID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	

	    //����ҵ����(�˻�)��Ϣ��
	    sSql = " update BUSINESS_DUEBILL set "+
	    	   " CustomerName = '"+sNewCustomerName+"' "+
        	   " where CustomerID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    //����ҵ����׼��Ϣ��
	    sSql = " update BUSINESS_APPROVE set "+
	    	   " CustomerName = '"+sNewCustomerName+"' "+
        	   " where CustomerID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    //����ҵ�����������˱�
	    sSql = " update BUSINESS_APPLICANT set "+
	    	   " ApplicantName = '"+sNewCustomerName+"' "+
        	   " where ApplicantID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    
	    
	    //����ҵ��������Ϣ��
	    sSql = " update BUSINESS_APPLY set "+
	    	   " CustomerName = '"+sNewCustomerName+"' "+
        	   " where CustomerID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);		    

	    //������ֵ˰��Ʊ��Ϣ��
	    sSql = " update INVOICE_INFO set "+
	    	   " PurchaserName = '"+sNewCustomerName+"' "+
        	   " where PurchaserID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	
	    	    
	    sSql = " update INVOICE_INFO set "+
	    	   " BargainorName = '"+sNewCustomerName+"' "+
        	   " where BargainorID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	
	    
	    //���¶�ȷ�����Ϣ��
	    sSql = " update CL_INFO set "+
 	   			" CustomerName = '"+sNewCustomerName+"' "+
 	   			" where CustomerID = '"+sCustomerID+"' " ;
	    //ִ�и������
	    Sqlca.executeSQL(sSql);	
	    return "Success";
	    
	 }

}
