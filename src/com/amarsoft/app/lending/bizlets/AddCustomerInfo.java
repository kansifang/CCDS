package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;

public class AddCustomerInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sCustomerName = (String)this.getAttribute("CustomerName");
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");
		String sLoanCardNo = (String)this.getAttribute("LoanCardNo");
		String sUserID = (String)this.getAttribute("UserID");
		
		//将空值转化为空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		if(sLoanCardNo == null ||"#LoanCardNo".equals(sLoanCardNo) ) sLoanCardNo = "";
		if(sUserID == null) sUserID = "";
		
		//定义变量
		ASResultSet rs = null;
		String sSql = "";
		int iCount = 0;
		
		//实例化用户对象
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		
		//根据客户编号查询系统中是否已建立信贷关系
		sSql = 	" select count(CustomerID) from CUSTOMER_INFO "+
				" where CustomerID = '"+sCustomerID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		if(iCount == 0)
		{			
			if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ent"))//公司客户，如果客户类型小于3个字符，无需比较
			{				
				//在CI表中新建记录	
				//客户编号、客户名称、客户类型、证件类型、证件编号、登记机构、登记人、登记日期	、来源渠道、贷款卡编号	
				sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel,LoanCardNo,CustomerScale) "+
					   " values('"+sCustomerID+"','"+sCustomerName+"','0101','"+sCertType+"','"+sCertID+"','"+CurUser.OrgID+"', "+
					   " '"+CurUser.UserID+"','"+StringFunction.getToday()+"','2','"+sLoanCardNo+"','010')";
				Sqlca.executeSQL(sSql);
				
				//证件类型为组织机构代码
				if(sCertType.equals("Ent01"))
				{
					//客户编号、组织机构代码证编号、客户名称、机构性质、集团客户标志、登记机构、登记人、登记日期、更新机构、更新人、更新日期、贷款卡编号
					sSql = " insert into ENT_INFO(CustomerID,CorpID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
						   " values('"+sCustomerID+"','"+sCertID+"','"+sCustomerName+"','0101','0','"+CurUser.OrgID+"','"+CurUser.UserID+"', "+
						   " '"+StringFunction.getToday()+"','"+CurUser.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+sLoanCardNo+"')";
					Sqlca.executeSQL(sSql);
				//证件类型为营业执照
				}else if(sCertType.equals("Ent02"))
				{
					//客户编号、营业执照号、客户名称、机构性质、集团客户标志、登记机构、登记人、登记日期、更新机构、更新人、更新日期、贷款卡编号
					sSql = " insert into ENT_INFO(CustomerID,LicenseNo,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
						   " values('"+sCustomerID+"','"+sCertID+"','"+sCustomerName+"','0101','0','"+CurUser.OrgID+"','"+CurUser.UserID+"', "+
						   " '"+StringFunction.getToday()+"','"+CurUser.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+sLoanCardNo+"')";
					Sqlca.executeSQL(sSql);
				
				}else
				{
					//客户编号、客户名称、机构性质、集团客户标志、登记机构、登记人、登记日期、更新机构、更新人、更新日期、贷款卡编号
					sSql = " insert into ENT_INFO(CustomerID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
						   " values('"+sCustomerID+"','"+sCustomerName+"','0101','0','"+CurUser.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"', "+
						   " '"+CurUser.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+sLoanCardNo+"')";
					Sqlca.executeSQL(sSql);
				}	
			}else if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ind")) //个人客户，如果客户类型小于3个字符，无需比较
			{
				//在CI表中新建记录	
				//客户编号、客户名称、客户类型、证件类型、证件编号、登记机构、登记人、登记日期	、来源渠道、贷款卡编号	
				sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel,LoanCardNo) "+
					   " values('"+sCustomerID+"','"+sCustomerName+"','03','"+sCertType+"','"+sCertID+"','"+CurUser.OrgID+"', "+
					   " '"+CurUser.UserID+"','"+StringFunction.getToday()+"','2','"+sLoanCardNo+"')";
				Sqlca.executeSQL(sSql);
				
				//客户编号、姓名、证件类型、证件编号、登记机构、登记人、登记日期、更新日期
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
				//更新ENT_INFO和IND_INFO中的贷款卡号，保持一致
				if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ent"))//公司客户，如果客户类型小于3个字符，无需比较
			    {
					sSql =  " update ENT_INFO set LoanCardNo = '"+sLoanCardNo+"' "+
			                " where CustomerID = '"+sCustomerID+"' ";
					Sqlca.executeSQL(sSql);
			    }else if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ind")) //个人客户，如果客户类型小于3个字符，无需比较
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
