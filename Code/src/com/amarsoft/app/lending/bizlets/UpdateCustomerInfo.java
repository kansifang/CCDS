package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateCustomerInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//获得参数：变更后的客户名称、证件类型、证件编号和贷款卡编号	
	 	String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sNewCustomerName   = (String)this.getAttribute("NewCustomerName");
		String sNewCertType   = (String)this.getAttribute("NewCertType");
		String sNewCertID = (String)this.getAttribute("NewCertID");
		String sNewLoanCardNo = (String)this.getAttribute("NewLoanCardNo");
		//定义变量
		String sSql = "",sCustomerType = "";
			   	
		//根据客户编号获得客户类型
		sSql = " select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
		sCustomerType = Sqlca.getString(sSql);
		if (sCustomerType == null) sCustomerType = "";
		
	    //更新客户基本信息表
	    sSql = " update CUSTOMER_INFO set "+
	    	   " CustomerName = '"+sNewCustomerName+"', "+
	    	   " CertType='"+sNewCertType+"', "+
	           " CertID = '"+sNewCertID+"', "+
	           " LoanCardNo = '"+sNewLoanCardNo+"' "+
	           " where CUSTOMERID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);
	    
	    if (!sCustomerType.equals("03")) //非个人客户
	    {
	    	
			if(sNewCertType.equals("Ent01"))//证件类型为组织机构代码
			{
				//更新企业基本信息表
			    sSql = " update ENT_INFO set "+
			    	   " EnterpriseName = '"+sNewCustomerName+"', "+
			    	   " CorpID = '"+sNewCertID+"', "+
			    	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
		        	   " where CustomerID = '"+sCustomerID+"' " ;
			}else if(sNewCertType.equals("Ent02"))//证件类型为营业执照
			{
				//更新企业基本信息表
			    sSql = " update ENT_INFO set "+
			    	   " EnterpriseName = '"+sNewCustomerName+"', "+
			    	   " LicenseNo = '"+sNewCertID+"', "+
			    	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
		        	   " where CustomerID = '"+sCustomerID+"' " ;				
			}else
			{
		    	//更新企业基本信息表
			    sSql = " update ENT_INFO set "+
			    	   " EnterpriseName = '"+sNewCustomerName+"', "+
			    	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
		        	   " where CustomerID = '"+sCustomerID+"' " ;
			}
	    }else
	    {
		    //更新个人基本信息表
		    sSql = " update IND_INFO set "+
		    	   " FullName = '"+sNewCustomerName+"', "+
		    	   " CertType='"+sNewCertType+"', "+
	        	   " CertID = '"+sNewCertID+"' "+
	        	   " where CustomerID = '"+sCustomerID+"' " ;	    
	    }
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	
	    
	    //更新案件台帐信息表
	    sSql = " update LAWCASE_BOOK set "+
	    	   " BankruptcyOrgName = '"+sNewCustomerName+"' "+
        	   " where BankruptcyOrgID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);
	    
	    //更新担保合同信息表
	    sSql = " update GUARANTY_CONTRACT set "+
	    	   " GuarantorName = '"+sNewCustomerName+"', "+
	    	   " CertType='"+sNewCertType+"', "+	    	   
        	   " CertID = '"+sNewCertID+"', "+
        	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
        	   " where GuarantorID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);
	 
	    //更新担保物和资产情况变更记录表
	    sSql = " update GUARANTY_CHANGE set "+
	    	   " OldOwnerName = '"+sNewCustomerName+"', "+
	    	   " OldCertType='"+sNewCertType+"', "+	    	   
        	   " OldCertID = '"+sNewCertID+"', "+
        	   " OldLoanCardNo = '"+sNewLoanCardNo+"' "+
        	   " where OldOwnerID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	
	    
	    sSql = " update GUARANTY_CHANGE set "+
	    	   " NewOwnerName = '"+sNewCustomerName+"', "+
	    	   " NewCertType='"+sNewCertType+"', "+	    	   
        	   " NewCertID = '"+sNewCertID+"', "+
        	   " NewLoanCardNo = '"+sNewLoanCardNo+"' "+
 	   		   " where NewOwnerID = '"+sCustomerID+"' " ;
		//执行更新语句
		Sqlca.executeSQL(sSql);	   
	    
	    //更新担保物信息表
	    sSql = " update GUARANTY_INFO set "+
	    	   " OwnerName = '"+sNewCustomerName+"', "+
	    	   " CertType='"+sNewCertType+"', "+	    	   
        	   " CertID = '"+sNewCertID+"', "+
        	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
        	   " where OwnerID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	    
	    
	    //更新房屋买卖装修信息表
	    sSql = " update BUILDING_DEAL set "+
	    	   " ObligeeName = '"+sNewCustomerName+"' "+
        	   " where ObligeeID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	
	    
	    sSql = " update BUILDING_DEAL set "+
	    	   " AgencyName = '"+sNewCustomerName+"' "+
		 	   " where AgencyID = '"+sCustomerID+"' " ;
		 //执行更新语句
		 Sqlca.executeSQL(sSql);	
		 
	     sSql = " update BUILDING_DEAL set "+
	     	    " FitOrgName = '"+sNewCustomerName+"' "+
	 	        " where FitOrgID = '"+sCustomerID+"' " ;
		 //执行更新语句
		 Sqlca.executeSQL(sSql);	
	    
	    //更新个人工作履历表
	    sSql = " update IND_RESUME set "+
	    	   " Employment = '"+sNewCustomerName+"' "+
        	   " where CompanyCode = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);
	    
	    //更新开发商楼盘信息表
	    sSql = " update BUILDING_INFO set "+
	    	   " DeveloperName = '"+sNewCustomerName+"' "+
        	   " where DeveloperID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	    
	    
	    sSql = " update BUILDING_INFO set "+
	    	   " BuilderName = '"+sNewCustomerName+"' "+
	     	   " where BuilderID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	    
		 
	    //更新客户关联信息表
	    sSql = " update CUSTOMER_RELATIVE set "+
	    	   " CustomerName = '"+sNewCustomerName+"', "+
	    	   " CertType='"+sNewCertType+"', "+
        	   " CertID = '"+sNewCertID+"', "+
        	   " LoanCardNo = '"+sNewLoanCardNo+"' "+
        	   " where RelativeID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	    
	    
	    //更新贸易合同信息表
	    sSql = " update CONTRACT_INFO set "+
	    	   " PurchaserName = '"+sNewCustomerName+"' "+
        	   " where PurchaserID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	
	    	    
	    sSql = " update CONTRACT_INFO set "+
	    	   " BargainorName = '"+sNewCustomerName+"' "+
        	   " where BargainorID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    //更新票据信息表
	    sSql = " update BILL_INFO set "+
	    	   " Writer = '"+sNewCustomerName+"' "+
        	   " where WriterID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    	    
	    sSql = " update BILL_INFO "+
	    	   " set Holder = '"+sNewCustomerName+"' "+
        	   " where HolderID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    sSql = " update BILL_INFO set "+
	    	   " Beneficiary = '"+sNewCustomerName+"' "+
        	   " where BeneficiaryID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    	    
	    sSql = " update BILL_INFO set "+
	    	   " Acceptor = '"+sNewCustomerName+"' "+
        	   " where AcceptorID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    //更新其它提供贷款人表
	    sSql = " update BUSINESS_PROVIDER set "+
	    	   " ProviderName = '"+sNewCustomerName+"' "+
        	   " where ProviderNo = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    //更新项目基本信息表
	    sSql = " update PROJECT_INFO set "+
	    	   " DevelopmentName = '"+sNewCustomerName+"' "+
        	   " where DevelopmentID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    sSql = " update PROJECT_INFO set "+
	    	   " CopartnerName = '"+sNewCustomerName+"' "+
        	   " where CopartnerID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    //更新项目资金来源信息表
	    sSql = " update PROJECT_FUNDS set "+
	    	   " InvestorName = '"+sNewCustomerName+"' "+
        	   " where InvestorCode = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    //更新消费信息表
	    sSql = " update CONSUME_INFO set "+
	    	   " DealerName = '"+sNewCustomerName+"' "+
        	   " where DealerID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    //更新业务出帐通知单表
	    sSql = " update BUSINESS_PUTOUT set "+
			   " CertType='"+sNewCertType+"', "+
		 	   " CertID = '"+sNewCertID+"', "+
	    	   " CustomerName = '"+sNewCustomerName+"' "+
        	   " where CustomerID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    //更新业务合同信息表
	    sSql = " update BUSINESS_CONTRACT set "+
	    	   " CustomerName = '"+sNewCustomerName+"' "+
        	   " where CustomerID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	

	    //更新业务借据(账户)信息表
	    sSql = " update BUSINESS_DUEBILL set "+
	    	   " CustomerName = '"+sNewCustomerName+"' "+
        	   " where CustomerID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    //更新业务批准信息表
	    sSql = " update BUSINESS_APPROVE set "+
	    	   " CustomerName = '"+sNewCustomerName+"' "+
        	   " where CustomerID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    //更新业务其他申请人表
	    sSql = " update BUSINESS_APPLICANT set "+
	    	   " ApplicantName = '"+sNewCustomerName+"' "+
        	   " where ApplicantID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    
	    
	    //更新业务申请信息表
	    sSql = " update BUSINESS_APPLY set "+
	    	   " CustomerName = '"+sNewCustomerName+"' "+
        	   " where CustomerID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);		    

	    //更新增值税发票信息表
	    sSql = " update INVOICE_INFO set "+
	    	   " PurchaserName = '"+sNewCustomerName+"' "+
        	   " where PurchaserID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	
	    	    
	    sSql = " update INVOICE_INFO set "+
	    	   " BargainorName = '"+sNewCustomerName+"' "+
        	   " where BargainorID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	
	    
	    //更新额度分配信息表
	    sSql = " update CL_INFO set "+
 	   			" CustomerName = '"+sNewCustomerName+"' "+
 	   			" where CustomerID = '"+sCustomerID+"' " ;
	    //执行更新语句
	    Sqlca.executeSQL(sSql);	
	    return "Success";
	    
	 }

}
