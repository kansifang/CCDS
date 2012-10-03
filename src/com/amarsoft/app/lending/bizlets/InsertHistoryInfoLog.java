package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


public class InsertHistoryInfoLog extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//获得参数：变更页面参数	

	 	String sInstertType = (String)this.getAttribute("InstertType");
	 	String sUpdateUser = (String)this.getAttribute("UpdateUser");
	 	String sUpdateDate = StringFunction.getToday();
	 	//获取用户所在机构及系统时间
		ASUser CurUser = new ASUser(sUpdateUser,Sqlca);
		String sUpdateOrg = CurUser.OrgID ;
		
	 	//变更客户
		if(sInstertType.equals("ChangeCustomer"))
		{	
			//获得参数：变更前客户代号，变更信息用户代号
		 	String sCustomerID   = (String)this.getAttribute("ObjectNo");
			//定义变量
			String sSql = "",sCustomerType = "", sCustomerName = "",sCertType = "",sCertID = "",sLoanCardNo = "";
			
			//定义变量：查询结果集
			ASResultSet rs = null;
			//根据客户编号获得客户信息
			sSql = " select CustomerName,CustomerType,CertType,CertID,LoanCardNo from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sCustomerName = rs.getString("CustomerName");
				sCustomerType = rs.getString("CustomerType");
				sCertType = rs.getString("CertType");
				sCertID = rs.getString("CertID");
				sLoanCardNo = rs.getString("LoanCardNo");
			}
			rs.getStatement().close();
			
			if (sCustomerType == null) sCustomerType = "";
			

		    sSql = " insert into CUSTOMER_CHANGELOG(CustomerID,CustomerName,CustomerType,CertType,CertID,LoanCardNo,UpdateUser,UpdateOrg,UpdateDate) "+
		    		" values('" +sCustomerID+"','" +sCustomerName+"','" +sCustomerType+"','" +sCertType+"','" +sCertID+"','" +sLoanCardNo+"'," +
		    		" '"+sUpdateUser+"','" +sUpdateOrg+"','" +sUpdateDate+"') ";
		    //执行插入语句
		    Sqlca.executeSQL(sSql);
		}
		//变更公积金
		if(sInstertType.equals("ChangeAccumulationFundRate"))
		{
			//获取参数:变更前的公积金利率代号
			String sRateID = (String)this.getAttribute("ObjectNo");
			//定义变量
			String sSql = "",sAreaNO="",sCurrency = "",sRateName = "";
			Double dRate = 0.0;//定义变量：查询结果集
			ASResultSet rs = null;
			//根据客公积金利率代号获得公积金利率信息
			sSql = " select AreaNO,Currency,RateName,Rate from AFRATE_INFO where RateID = '"+sRateID+"' ";
			
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sAreaNO = rs.getString("AreaNO");
				sCurrency = rs.getString("Currency");
				sRateName = rs.getString("RateName");
				dRate = rs.getDouble("Rate");
			}
			rs.getStatement().close();
			
			sSql = " insert into ACCUMULATIONFUNDRATE_CHANGELOG(AreaNO,Currency,UpdateDate,RateID,RateName,Rate) "+
					" values('"+sAreaNO+"','"+sCurrency+"','"+sUpdateDate+"','"+sRateID+"','"+sRateName+"',"+dRate+") ";
			
			Sqlca.executeSQL(sSql);
		}
		//变更黑名单
		if(sInstertType.equals("ChangeBlackList"))
		{
			// 获得页面参数
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//定义变量
			String sSql = "",sSectionType = "",sCertID = "",sCertType = "",sCustomerID = "",sCustomerName = "";
			String sAttribute1 = "", sBeginDate = "",sEndDate = "" ;

			//定义变量：查询结果集
			ASResultSet rs = null;
			//根据流水号查黑名单客户信息
			sSql = " select SerialNo,SectionType,CertID,CertType,CustomerID,CustomerName,Attribute1,BeginDate,EndDate from CUSTOMER_SPECIAL where SerialNo = '"+sSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sSectionType = rs.getString("SectionType");
				sCertID = rs.getString("CertID");
				sCertType = rs.getString("CertType");
				sCustomerID = rs.getString("CustomerID");
				sCustomerName = rs.getString("CustomerName");
				sAttribute1 = rs.getString("Attribute1");
				sBeginDate = rs.getString("BeginDate");
				sEndDate = rs.getString("EndDate");				
			}
			rs.getStatement().close();
			
			
			sSql = " insert into CUSTOMER_SPECIALLOG(SerialNo,SectionType,CertID,CertType,CustomerID,CustomerName,Attribute1,BeginDate,EndDate,UpdateUser,UpdateOrg,UpdateDate,InstertType) "+
					" values('"+sSerialNo+"','"+sSectionType+"','"+sCertID+"','"+sCertType+"','"+sCustomerID+"','"+sCustomerName+"','"+sAttribute1+"','"+sBeginDate+"',"+
					" '"+sEndDate+"','"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"','ChangeBlackList') ";
							
			//执行插入语句
		    Sqlca.executeSQL(sSql);
		}
		//变更关联方管理
		if(sInstertType.equals("ChangeRelativeList"))
		{
			// 获得页面参数
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//定义变量
			String sSql = "",sRelativeName = "";
			 Double dAttribute3=0.0,dSum1=0.0,dSum2=0.0;

			//定义变量：查询结果集
			ASResultSet rs = null;
			//根据流水号查黑名单客户信息
			sSql = " select SerialNo,RelativeName,Attribute3,Sum1,Sum2 from RELATIVE_SPECIAL where SerialNo = '"+sSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sRelativeName = rs.getString("RelativeName");
				dAttribute3 = rs.getDouble("Attribute3");
				dSum1 = rs.getDouble("Sum1");
				dSum2 = rs.getDouble("Sum2");				
			}
			rs.getStatement().close();
			
			sSql = " insert into RELATIVE_SPECIALLOG(SerialNo,RelativeName,Attribute3,Sum2,Sum1,UpdateUser,UpdateOrg,UpdateDate) "+
					" values('"+sSerialNo+"','"+sRelativeName+"',"+dAttribute3+","+dSum1+","+dSum2+",'"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"') ";
							
			//执行插入语句
		    Sqlca.executeSQL(sSql);
		}
		//变更股东管理
		if(sInstertType.equals("ChangeStockholderList"))
		{
			// 获得页面参数
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//定义变量
			String sSql = "",sCustomerName = "";
			 Double dAttribute3=0.0,dSum1=0.0,dSum2=0.0;
			//定义变量：查询结果集
			ASResultSet rs = null;
			//根据流水号查黑名单客户信息
			sSql = " select SerialNo,CustomerName,Attribute3,Sum1,Sum2 from CUSTOMER_SPECIAL where SerialNo = '"+sSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sCustomerName = rs.getString("CustomerName");
				dAttribute3 = rs.getDouble("Attribute3");
				dSum1 = rs.getDouble("Sum1");
				dSum2 = rs.getDouble("Sum2");
				
			}
			rs.getStatement().close();
			
			sSql = " insert into CUSTOMER_SPECIALLOG(SerialNo,CustomerName,Attribute3,Sum2,Sum1,UpdateUser,UpdateOrg,UpdateDate,InstertType) "+
			" values('"+sSerialNo+"','"+sCustomerName+"',"+dAttribute3+","+dSum1+","+dSum2+",'"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"','ChangeStockholderList') ";
							
			//执行插入语句
		    Sqlca.executeSQL(sSql);
		}
		//本行认可中介机构管理
		if(sInstertType.equals("ChangeAuditList"))
		{
			// 获得页面参数
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//定义变量
			String sSql = "",sAttribute1 = "",sCustomerName = "",sAuditOrgType = "",sEffectStartDate = "",sEffectFinishDate = "";

			//定义变量：查询结果集
			ASResultSet rs = null;
			//根据流水号查黑名单客户信息
			sSql = " select SerialNo,Attribute1,CustomerName,AuditOrgType,EffectStartDate,EffectFinishDate from CUSTOMER_SPECIAL where SerialNo = '"+sSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sAttribute1 = rs.getString("Attribute1");
				sCustomerName = rs.getString("CustomerName");
				sAuditOrgType = rs.getString("AuditOrgType");
				sEffectStartDate = rs.getString("EffectStartDate");
				sEffectFinishDate = rs.getString("EffectFinishDate");				
			}
			rs.getStatement().close();
			
			
			sSql = " insert into CUSTOMER_SPECIALLOG(SerialNo,Attribute1,CustomerName,AuditOrgType,EffectStartDate,EffectFinishDate,UpdateUser,UpdateOrg,UpdateDate,InstertType) "+
			" values('"+sSerialNo+"','"+sAttribute1+"','"+sCustomerName+"','"+sAuditOrgType+"','"+sEffectStartDate+"','"+sEffectFinishDate+"','"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"','ChangeAuditList') ";
							
			//执行插入语句
		    Sqlca.executeSQL(sSql);
		}
		//特殊客户维护
		if(sInstertType.equals("ChangeSpecialCustList"))
		{
			// 获得页面参数
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//定义变量
			String sSql = "",sCustomerName = "",sBeginDate = "",sEndDate = "";

			//定义变量：查询结果集
			ASResultSet rs = null;
			//根据流水号查黑名单客户信息
			sSql = " select SerialNo,CustomerName,BeginDate,EndDate from CUSTOMER_SPECIAL where SerialNo = '"+sSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sCustomerName = rs.getString("CustomerName");
				sBeginDate = rs.getString("BeginDate");
				sEndDate = rs.getString("EndDate");			
			}
			rs.getStatement().close();
			
			sSql = " insert into CUSTOMER_SPECIALLOG(SerialNo,CustomerName,BeginDate,EndDate,UpdateUser,UpdateOrg,UpdateDate,InstertType) "+
			" values('"+sSerialNo+"','"+sCustomerName+"','"+sBeginDate+"','"+sEndDate+"','"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"','ChangeSpecialCustList') ";
							
			//执行插入语句
		    Sqlca.executeSQL(sSql);
		}
		//融资平台管理
		if(sInstertType.equals("ChangeFinancePlatFormList"))
		{
			// 获得页面参数
			String sSerialNo = (String)this.getAttribute("ObjectNo");
			//定义变量
			String sSql = "";
			
			sSql = " insert into CUSTOMER_FINANCEPLATFORMlog(SERIALNO,CUSTOMERNAME,INPUTORGID,INPUTUSERID," +
						"INPUTDATE,REMARK,CERTTYPE,CERTID,CUSTOMERID," +
						"PLATFORMLEVEL,DEALCLASSIFY,LEGALPERSONNATURE,PLATFORMTYPE," +
						"CASHCOVERDEGREE,FINANCECREDITTYPE,LOANCARDNO,FINANCEPLATFORMFLAG,UPDATEUSER,UPDATEORG,UPDATEDATE) " +
						" select SERIALNO,CUSTOMERNAME,INPUTORGID,INPUTUSERID," +
						"INPUTDATE,REMARK,CERTTYPE,CERTID,CUSTOMERID," +
						"PLATFORMLEVEL,DEALCLASSIFY,LEGALPERSONNATURE,PLATFORMTYPE," +
						"CASHCOVERDEGREE,FINANCECREDITTYPE,LOANCARDNO,FINANCEPLATFORMFLAG," +
						"'"+sUpdateUser+"','"+sUpdateOrg+"','"+sUpdateDate+"' " +
					" from CUSTOMER_FINANCEPLATFORM " +
					" where serialno='"+sSerialNo+"' ";
							
			//执行插入语句
		    Sqlca.executeSQL(sSql);
		}
	    return "Success";
	 }

}
