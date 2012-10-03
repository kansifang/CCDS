package com.amarsoft.app.lending.bizlets;
/*
Author: --jbye 2007-1-14 15:03
Tester:
Describe: --检查客户信息状态
Input Param:
	  CustomerType：客户类型
	  	公司客户：	
			0101：法人企业；
			0102：非法人企业；
			0103：个体工商户（本系统暂不用）；
			0104：事业单位；
			0105：社会团体；
			0106：党政机关；
			0107：金融机构；
			0199：其他；
		关联集团：
			0201：一类集团；
			0202：二类集团（本系统暂不用）；
		个人客户：
			03：个人客户			  			                				
	  CustomerName：客户名称
	  CertType：证件类型
	  CertID：证件号码
	  ReturnStatus：返回状态
	  CustomerID：客户号
Output param:
		History Log: 			
*/
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class AddCustomerAction extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{
	    //获得页面参数：客户类型、客户名称、证件类型、证件编号、返回状态、客户编号
		String sCustomerType = (String)this.getAttribute("CustomerType");
		String sCustomerName = (String)this.getAttribute("CustomerName");	
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");	
		String sReturnStatus = (String)this.getAttribute("ReturnStatus");
		String sCustomerID = (String)this.getAttribute("CustomerID");	
		String sCustomerScale = (String)this.getAttribute("CustomerScale");	
		String sOrgID = (String)this.getAttribute("OrgID");	
		String sUserID = (String)this.getAttribute("UserID");	
		
		//将空值转化为空字符串
	   	if(sCustomerType == null) sCustomerType = "";   
	   	if(sCustomerName == null) sCustomerName = "";
	   	if(sCertType == null) sCertType = "";
	   	if(sReturnStatus == null) sReturnStatus = "";
	   	if(sCustomerID == null) sCustomerID = "";
	   	if(sCustomerScale == null) sCustomerScale = "";
	   	
	   	//定义变量：sql语句
		String sSql = "",sGroupType = "";
		
	   	//根据客户类型设置集团客户类型
	   	if(sCustomerType.equals("0201")) //一类集团客户
			sGroupType = "1";//一类集团
		else if(sCustomerType.equals("0202")) //二类集团客户
			sGroupType = "2";//二类集团
		else
			sGroupType = "0";//单一客户
		//01为无该客户 
		if(sReturnStatus.equals("01"))
		{
		   //开始事务
	 	   boolean bOld = Sqlca.conn.getAutoCommit(); 
		   try 
		   {		
				if(!bOld) Sqlca.conn.commit();
				Sqlca.conn.setAutoCommit(false);
						
				//在CI表中新建记录	
				if(sCustomerType.substring(0,2).equals("02")) //关联集团客户
				{
					//客户编号、客户名称、客户类型、证件类型、证件编号、登记机构、登记人、登记日期、来源渠道
					sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel) "+
						   " values('"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"',null,null,'"+sOrgID+"', "+
						   " '"+sUserID+"','"+StringFunction.getToday()+"','1')";
					Sqlca.executeSQL(sSql);
				}else
				{
					//客户编号、客户名称、客户类型、证件类型、证件编号、登记机构、登记人、登记日期	、来源渠道
					sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel,CustomerScale) "+
						   " values('"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"','"+sCertType+"','"+sCertID+"','"+sOrgID+"', "+
						   " '"+sUserID+"','"+StringFunction.getToday()+"','1','"+sCustomerScale+"')";
					Sqlca.executeSQL(sSql);
				}
					
				//在CB表中新建有效记录
				//客户编号、有权机构、有权人、主办权、信息查看权、信息维护权、业务办理权
				sSql = 	" insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3, "+
						" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
					   	" values('"+sCustomerID+"','"+sOrgID+"','"+sUserID+"','1','1','1','1','1','"+sOrgID+"', "+
					   	" '"+sUserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
				Sqlca.executeSQL(sSql);
					
				if(sCustomerType.substring(0,2).equals("01"))//公司客户
				{
					//证件类型为组织机构代码
					if(sCertType.equals("Ent01"))
					{
						//客户编号、组织机构代码证编号、客户名称、机构性质、集团客户标志、登记机构、登记人、登记日期、更新机构、更新人、更新日期
						sSql = " insert into ENT_INFO(CustomerID,CorpID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate) "+
							   " values('"+sCustomerID+"','"+sCertID+"','"+sCustomerName+"','"+sCustomerType+"','"+sGroupType+"','"+sOrgID+"','"+sUserID+"', "+
							   " '"+StringFunction.getToday()+"','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"')";
						Sqlca.executeSQL(sSql);
					//证件类型为营业执照
					}else if(sCertType.equals("Ent02"))
					{
						//客户编号、营业执照号、客户名称、机构性质、集团客户标志、登记机构、登记人、登记日期、更新机构、更新人、更新日期
						sSql = " insert into ENT_INFO(CustomerID,LicenseNo,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate) "+
							   " values('"+sCustomerID+"','"+sCertID+"','"+sCustomerName+"','"+sCustomerType+"','"+sGroupType+"','"+sOrgID+"','"+sUserID+"', "+
							   " '"+StringFunction.getToday()+"','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"')";
						Sqlca.executeSQL(sSql);
					
					}else
					{
						//客户编号、客户名称、机构性质、集团客户标志、登记机构、登记人、登记日期、更新机构、更新人、更新日期
						sSql = " insert into ENT_INFO(CustomerID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate) "+
							   " values('"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"','"+sGroupType+"','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"', "+
							   " '"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"')";
						Sqlca.executeSQL(sSql);
					}	
				}else if(sCustomerType.substring(0,2).equals("02")) //关联集团客户
				{				
					//客户编号、组织机构代码（系统自动虚拟，同集团客户编号）、客户名称、机构性质、登记机构、登记人、登记日期、更新机构、更新人、更新日期、集团客户分类
					sSql = " insert into ENT_INFO(CustomerID,CorpID,EnterpriseName,OrgNature,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,GroupFlag) "+
						   " values('"+sCustomerID+"','"+sCustomerID+"','"+sCustomerName+"','"+sCustomerType+"','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"', "+
						   " '"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"','"+sGroupType+"')";
					Sqlca.executeSQL(sSql);		
				}else if(sCustomerType.substring(0,2).equals("03"))//个人客户
				{
					//客户编号、姓名、证件类型、证件编号、登记机构、登记人、登记日期、更新日期
					sSql = "insert into IND_INFO(CustomerID,FullName,CertType,CertID,InputOrgID,InputUserID,InputDate,UpdateDate) "+
						   "values('"+sCustomerID+"','"+sCustomerName+"','"+sCertType+"','"+sCertID+"','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
					Sqlca.executeSQL(sSql);
				}
				
				//事物提交成功
				Sqlca.conn.commit();
				Sqlca.conn.setAutoCommit(bOld);
			} catch(Exception e)
			{
				Sqlca.conn.rollback();
				Sqlca.conn.setAutoCommit(bOld);
				throw new Exception("事务处理失败！"+e.getMessage());
			}			
		//该客户没有与任何用户建立有效关联
		}else if(sReturnStatus.equals("04"))
		{
			//将来源渠道由"2"变成"1"
			sSql = 	" update CUSTOMER_INFO set Channel = '1' "+
					" where CustomerID = '"+sCustomerID+"' ";
			Sqlca.executeSQL(sSql);
			//建立有效关联
			//客户编号、有权机构、有权人、主办权、信息查看权、信息维护权、业务办理权、其他权限（预留）、登记机构、登记人、登记日期、更新日期
			sSql = " insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				   " values('"+sCustomerID+"','"+sOrgID+"','"+sUserID+"','1','1','1','1','1','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
		//该客户与其他用户建立有效关联
		}else if(sReturnStatus.equals("05"))
		{
			//建立无效关联
			sSql = " insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				   " values('"+sCustomerID+"','"+sOrgID+"','"+sUserID+"','2','2','2','2','2','"+sOrgID+"','"+sUserID+"','"+StringFunction.getToday()+"','"+StringFunction.getToday()+"')";
			Sqlca.executeSQL(sSql);
		}
		return "succeed";
	}	
		
}
