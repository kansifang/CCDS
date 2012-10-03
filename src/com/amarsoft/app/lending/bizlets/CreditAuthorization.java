package com.amarsoft.app.lending.bizlets;

/**
 * @(#)CreditAuthorization.java	2009-9-1
 *
 * Copyright 2006-2009 Amarsoft, Inc. All Rights Reserved.
 * 
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * 
 * Author:lpzhang
 * purpose:业务授权判断
 * 
 */

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.impl.tjnh_als.bizlets.CreditData;
import com.amarsoft.impl.tjnh_als.bizlets.Tools;
import com.amarsoft.impl.tjnh_als.bizlets.WhereClause;
import com.amarsoft.script.ScriptObject;


public class CreditAuthorization extends Bizlet{

	private ASResultSet rs = null;
	
	//该笔业务对象
	private ScriptObject oBusiness = new ScriptObject();
	
	private CreditData cd = null;
	//定义Sql
	private String sSql ="";
	//判断结果
	private String sReturn ="";
	//日志信息
	private String sMessage ="";
	
	//日志ID记录数
	private int icount=0;
	
	private String sObjectNo="";
	private String sUserID="";
	private String sTaskSerialNo="";
	private String sFlowNo="";
	private String roles="";
	private Transaction Sqlca = null;
	
	public Object run(Transaction Sqlca) throws Exception {
		//获取参数：对象类型，对象编号和当前用户,当前机构
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sUserID = (String)this.getAttribute("UserID");
		String sOrgID = (String)this.getAttribute("OrgID");
		String sFlowNo = (String)this.getAttribute("FlowNo");
		String sTaskSerialNo = (String)this.getAttribute("TaskSerialNo");
	    this.roles = (String)this.getAttribute("roles");
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		if(sFlowNo == null) sFlowNo = "";
		if(sTaskSerialNo == null) sTaskSerialNo = "";
		if(roles == null) roles = "";
		
		this.sObjectNo = sObjectNo;
		this.sUserID = sUserID;
		this.sTaskSerialNo = sTaskSerialNo;
		this.sFlowNo = sFlowNo;
		this.Sqlca = Sqlca;
		String AuthPointField="",sMessage ="";
		double dTotalBalance1 = 0.0,dTotalBalance2 = 0.0,dBusinessSum = 0.0;
		//初始化对象
		initBusinessMemory(sObjectNo,Sqlca);
		initCustomerMemory(sObjectNo,sUserID,sOrgID,Sqlca);
		//删除上次授权检测日志
		Sqlca.executeSQL("delete from  Authorization_Check_Log where  ApplySerialNo = '"+sObjectNo+"'  and TaskNo = '"+sTaskSerialNo+"'");
		System.out.println("roles*********************:"+roles);
		if("".equals(roles) || roles == null)//在没有传递角色的情况下
		{
			String[] roleTemp = Sqlca.getStringArray("select roleID from User_Role where UserID='"+sUserID+"'");
			for(int i=0;i<roleTemp.length;i++)
			{
				roles += roleTemp[i]+",";
			}
		}
		System.out.println("roles:"+roles);
		AuthPointField=getAuthPointField(sObjectNo,sObjectType,sFlowNo,Sqlca);//取得需要授权判断的字段
		String[] sFieldKey =AuthPointField.trim().split(",");
		double[] dFieldValue = new double[sFieldKey.length];
		
		String[] AuthSumArr= null;
		//--------同业额度授权(独立于累计授权)-------------
		if(((String)oBusiness.getAttribute("BusinessType")).equals("3015"))
		{
			double dAuthTYED = 0.0;
			sSql = " select AuthSum3 from ORG_INFO where OrgID = '"+sOrgID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				dAuthTYED = rs.getDouble("AuthSum3");
			}else
			{
				sMessage = "【同业额度授权】未对本机构设置机构参数！";
				icount++;
				CheckLog(sMessage,0,0,0,"NoTypeAuth");
			}
			rs.getStatement().close();
			
			if(dAuthTYED == 0.0)
			{
				sMessage = "【同业额度授权】未对本机构设置同业额度授权参数！";
				icount++;
				CheckLog(sMessage,0,0,0,"NoTongYeAuth");
			}else
			{
				dBusinessSum = Double.parseDouble((String)oBusiness.getAttribute("BusinessSum"));//该笔申请金额
				if(dAuthTYED < dBusinessSum)
				{
					sMessage = "【同业额度授权】该同业客户申请的同业额度超过了相应授权！";
					icount++;
					CheckLog(sMessage,dBusinessSum,dBusinessSum,dAuthTYED,"Org_Info.AuthSum3");
				}
			}
			
		}else
		{
			/*说明：如果一个审查审批人员具有两个角色，同时两个角色都具有审批权。则会根据RoleID排序规则，忽略其中一个。lpzhang
			 * */
			//--------单产品授权-----------------
			if(!((String)oBusiness.getAttribute("BusinessType")).equals("3010"))//综合授信不进行单产品授权检测
			{
				sSql = " select "+AuthPointField+" from ORG_AUTH " +
					   " where OrgID='"+sOrgID+"' and locate(RoleID,'"+roles+"')>0 and  BusinessType = " +
					   " '"+(String)oBusiness.getAttribute("BusinessType")+"' order by RoleID desc fetch first 1 rows only";
				System.out.println("sSql1:"+sSql);
				AuthSumArr  = Sqlca.getStringArray(sSql);
				if(AuthSumArr.length==0)//未设置授权
				{
					sMessage = "未对用户设置该产品的授权！";
					icount++;
					CheckLog(sMessage,0,0,0,"NoTypeAuth");
				}else
				{
					dBusinessSum = Double.parseDouble((String)oBusiness.getAttribute("BusinessSum"));//该笔申请金额
					for(int j=0;j<AuthSumArr.length;j++)
					{
						dFieldValue[j]= Double.parseDouble(AuthSumArr[j]);
						if(sFieldKey[j].equals("AuthSum2") || sFieldKey[j].equals("AuthSum4") || sFieldKey[j].equals("AuthSum6"))//公司一般风险业务授权，微小企业一般风险业务授权，个人业务一般风险授权	
						{
							dTotalBalance2 = getSum3();
							if(dTotalBalance2+dBusinessSum>dFieldValue[j])
							{
								sMessage = "【一般风险业务】该客户在该产品的余额+申请金额超过产品的相应授权！";
								icount++;
								CheckLog(sMessage,dTotalBalance2,dBusinessSum,dFieldValue[j],sFieldKey[j]);
							}
						}
						
					}
				}
			}
			//------------累积授权-----------
			sSql = " select "+AuthPointField+" from ORG_AUTH " +
			   " where OrgID='"+sOrgID+"' and locate(RoleID,'"+roles+"')>0  and  (BusinessType = '' or BusinessType is null) " +
			   "  order by RoleID desc fetch first 1 rows only";
			AuthSumArr  = Sqlca.getStringArray(sSql);
			if(AuthSumArr.length==0)//未设置累计授权
			{
				sMessage = "未对用户设置累计授权！";
				icount++;
				CheckLog(sMessage,0,0,0,"NoAllAuth");
			}else
			{
				dBusinessSum = Double.parseDouble((String)oBusiness.getAttribute("BusinessSum"));//该笔申请金额
				for(int j=0;j<AuthSumArr.length;j++)
				{
					dFieldValue[j]= Double.parseDouble(AuthSumArr[j]);
					if(sFieldKey[j].equals("AuthSum1") || sFieldKey[j].equals("AuthSum5"))//公司业务低风险授权,个人低风险业务授权
					{
						dTotalBalance1 = getSum2();
						if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
							sMessage = "【低风险授权】该客户累积的余额+申请金额超过客户的累计授权！";
							icount++;
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					
					if(sFieldKey[j].equals("AuthSum2") || sFieldKey[j].equals("AuthSum4") || sFieldKey[j].equals("AuthSum6") || sFieldKey[j].equals("AuthSum3"))//公司一般风险业务授权，微小企业一般风险业务授权，个人业务一般风险授权 
					{
						dTotalBalance1 = getSum1();
						System.out.println("dTotalBalance1::"+dTotalBalance1);
						if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
							sMessage = "【一般风险业务授权】该客户累积的余额+申请金额超过客户的累计授权！";
							icount++;
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					if(sFieldKey[j].equals("AuthSum3"))//关联交易	
					{
						dTotalBalance1 = getSum1();
						if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
							sMessage = "【关联交易授权】该客户累积的余额+申请金额超过客户的累计授权！";
							icount++;
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					
					if(sFieldKey[j].equals("AuthSum7"))//微小商户授权金额
					{
						dTotalBalance1 = getSum4();
						if(dTotalBalance1+dBusinessSum>dFieldValue[j])
						{
							sMessage = "【微小商户授权】该客户累积的余额+申请金额超过客户的累计授权！";
							icount++;
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					
				}
			}
		}
		System.out.println("sReturn:"+sReturn);
		
		cd.closeCreditData();
		
		if(icount > 0)
			return "FALSE";
		else
			return "TRUE";
	
	}
	
	public void initBusinessMemory(String sObjectNo,Transaction Sqlca) throws Exception
	{
		sSql = " select BA.*,getCustomerType(CustomerID) as CustomerType,getUserName(OperateUserID) as OperateUserName," +
			   " getOrgName(OperateUserID) as OperateOrgName,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum1" +
			   " from BUSINESS_APPLY BA where BA.SerialNo = '"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			String SerialNo = rs.getString("SerialNo"); if(SerialNo == null) SerialNo="";
			String BusinessType = rs.getString("BusinessType"); if(BusinessType == null) BusinessType="";
			String CustomerID = rs.getString("CustomerID"); if(CustomerID == null) CustomerID="";
			String CustomerType = rs.getString("CustomerType"); if(CustomerType == null) CustomerType="";
			String ApplyType = rs.getString("ApplyType"); if(ApplyType == null) ApplyType="";
			String CreditAggreement = rs.getString("CreditAggreement"); if(CreditAggreement == null) CreditAggreement="";
			String BusinessCurrency = rs.getString("BusinessCurrency"); if(BusinessCurrency == null) BusinessCurrency="";
			String LowRisk = rs.getString("LowRisk"); if(LowRisk == null) LowRisk="";
			String OperateOrgID = rs.getString("OperateOrgID"); if(OperateOrgID == null) OperateOrgID="";
			String OperateOrgName = rs.getString("OperateOrgName"); if(OperateOrgName == null) OperateOrgName="";
			String OperateUserID = rs.getString("OperateUserID"); if(OperateUserID == null) OperateUserID="";
			String OperateUserName = rs.getString("OperateUserName"); if(OperateUserName == null) OperateUserName="";
			String UpdateDate = rs.getString("UpdateDate"); if(UpdateDate == null) UpdateDate="";
			oBusiness.setAttribute("SerialNo",SerialNo); //合同编号
			oBusiness.setAttribute("BusinessType",BusinessType); //业务品种
			oBusiness.setAttribute("CustomerID",CustomerID); //客户编号
			oBusiness.setAttribute("CustomerType",CustomerID); //客户类型
			oBusiness.setAttribute("ApplyType",ApplyType); //申请类型
			oBusiness.setAttribute("CreditAggreement",CreditAggreement); //申请协议号 
			oBusiness.setAttribute("BusinessCurrency",BusinessCurrency); //业务币种
			oBusiness.setAttribute("BusinessSum",String.valueOf(rs.getDouble("BusinessSum1"))); //授信金额
			oBusiness.setAttribute("TermMonth",String.valueOf(rs.getDouble("TermMonth"))); //期限
			oBusiness.setAttribute("LowRisk",LowRisk); //是否低风险
			oBusiness.setAttribute("OperateOrgID",OperateOrgID); //创建机构
			oBusiness.setAttribute("OperateOrgName",OperateOrgName); //创建机构名称
			oBusiness.setAttribute("OperateUserID",OperateUserID); //创建人
			oBusiness.setAttribute("OperateUserName",OperateUserName); //创建人姓名
			oBusiness.setAttribute("UpdateDate",UpdateDate); //更新日期
 		}else{
 			throw new Exception("初始化业务对象出错：没有找到业务对象["+sObjectNo+"]");
 		}
		rs.getStatement().close();
		//initMemory.setAttribute("Business",oBusiness);
		//return oBusiness;
	}
	
	public void initCustomerMemory(String sObjectNo,String sUserID,String sOrgID,Transaction Sqlca) throws Exception
	{
		sSql = " Select SerialNo,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,BusinessCurrency,BailSum,BailRatio," +
			   " BusinessType,nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate) as Balance,VouchType,CustomerID,Maturity " +
			   " from Business_Contract Where CustomerID = '"+(String)oBusiness.getAttribute("CustomerID")+"' and BusinessType not like '30%' ";
	   cd = new CreditData(Sqlca,sSql);
	}
	
	/** 该客户所有一般风险业务余额
	 */
	public double getSum1() throws Exception
	{
		return cd.getSum("Balance","LowRisk",Tools.NOTEQUALS,"1");
	}
	
	/** 该客户所有低风险业务余额
	 */
	public double getSum2() throws Exception
	{
		return cd.getSum("Balance","LowRisk",Tools.EQUALS,"1");
	}
	
	/** ∑该客户该业务品种业务余额,不统计低风险
	 */
	public double getSum3() throws Exception
	{
		WhereClause[] wc = new WhereClause[2];
	    wc[0] = new WhereClause("BusinessType",Tools.EQUALS,(String)oBusiness.getAttribute("BusinessType"));
		wc[1] = new WhereClause("LowRisk",Tools.NOTEQUALS,"1");
		
		return cd.getSum("Balance",wc);
	}
	
	/** 该客户所有微小商户余额
	 */
	public double getSum4() throws Exception
	{
		return cd.getSum("Balance","BusinessType",Tools.EQUALS,"1140120");
	}
	
	
	public String  getAuthPointField(String sObjectNo,String sObjectType,String sFlowNo,Transaction Sqlca) throws Exception
	{
		String BusinessType = (String) oBusiness.getAttribute("BusinessType");
		String CustomerID =  (String) oBusiness.getAttribute("CustomerID");
		String CustomerType =  (String) oBusiness.getAttribute("CustomerType");
		String LowRisk =  (String) oBusiness.getAttribute("LowRisk");
		String AuthPointField ="";
		//取出授权判断字段
		//微小商户贷款--特例
		if(BusinessType.equals("1140120"))
		{
			AuthPointField = "AuthSum7";
		}else
		{
			/*sSql = " select FC.Aapolicy from Flow_Catalog FC,Flow_Object FO where FC.FlowNo= FO.FlowNo" +
				   " where ObjectNo ='"+sObjectNo+"' and ObjectType ='"+sObjectType+"'";
		    AuthPointField = Sqlca.getString("Aapolicy");
			if(AuthPointField ==null) AuthPointField="";*/
			if(sFlowNo.equals("EntCreditFlowTJ02"))//公司低风险业务审批流程
			{
				AuthPointField = "AuthSum1";
			}else if(sFlowNo.equals("EntCreditFlowTJ01") )//公司一般风险业务审批流程
			{
				AuthPointField = "AuthSum2";
			}else if(sFlowNo.equals("CreditFlow02"))//微小企业
			{
				AuthPointField = "AuthSum4";
			}else if(sFlowNo.equals("IndCreditFlowTJ01"))//个人一般风险
			{
				AuthPointField = "AuthSum6";
			}else if(sFlowNo.equals("IndCreditFlowTJ02"))//个人低风险
			{
				AuthPointField = "AuthSum5";
			}
			
		}
		
		sSql = " select count(*) from CUSTOMER_SPECIAL where  SectionType='50' and CustomerID ='"+CustomerID+"'";
		
		int iNum = Sqlca.getDouble(sSql).intValue();
		
		if(!LowRisk.equals("1") && iNum>0)//股东，非低风险
		{
			AuthPointField =AuthPointField+",AuthSum3";
		}
		
		return AuthPointField;
	}
	
	//记录未通过授权的原因日志
	public void CheckLog(String sReason,double dTotalBalance,double dBusinessSum,double dAuthSum,String sAuthItem) throws Exception{
		
		Sqlca.executeSQL(" insert into Authorization_Check_Log(ApplySerialNo,TaskNo,Reason,UserID,FlowNo,TotalBalance,BusinessSum,AuthSum,AuthItem) " +
						 " values('"+sObjectNo+"','"+sTaskSerialNo+"','"+sReason+"','"+sUserID+"','"+sFlowNo+"',"+dTotalBalance+","+dBusinessSum+","+dAuthSum+",'"+sAuthItem+"')");
		
	}
	
	
}
