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
 * purpose:ҵ����Ȩ�ж�
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
	
	//�ñ�ҵ�����
	private ScriptObject oBusiness = new ScriptObject();
	
	private CreditData cd = null;
	//����Sql
	private String sSql ="";
	//�жϽ��
	private String sReturn ="";
	//��־��Ϣ
	private String sMessage ="";
	
	//��־ID��¼��
	private int icount=0;
	
	private String sObjectNo="";
	private String sUserID="";
	private String sTaskSerialNo="";
	private String sFlowNo="";
	private String roles="";
	private Transaction Sqlca = null;
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ȡ�������������ͣ������ź͵�ǰ�û�,��ǰ����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sUserID = (String)this.getAttribute("UserID");
		String sOrgID = (String)this.getAttribute("OrgID");
		String sFlowNo = (String)this.getAttribute("FlowNo");
		String sTaskSerialNo = (String)this.getAttribute("TaskSerialNo");
	    this.roles = (String)this.getAttribute("roles");
		//����ֵת���ɿ��ַ���
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
		//��ʼ������
		initBusinessMemory(sObjectNo,Sqlca);
		initCustomerMemory(sObjectNo,sUserID,sOrgID,Sqlca);
		//ɾ���ϴ���Ȩ�����־
		Sqlca.executeSQL("delete from  Authorization_Check_Log where  ApplySerialNo = '"+sObjectNo+"'  and TaskNo = '"+sTaskSerialNo+"'");
		System.out.println("roles*********************:"+roles);
		if("".equals(roles) || roles == null)//��û�д��ݽ�ɫ�������
		{
			String[] roleTemp = Sqlca.getStringArray("select roleID from User_Role where UserID='"+sUserID+"'");
			for(int i=0;i<roleTemp.length;i++)
			{
				roles += roleTemp[i]+",";
			}
		}
		System.out.println("roles:"+roles);
		AuthPointField=getAuthPointField(sObjectNo,sObjectType,sFlowNo,Sqlca);//ȡ����Ҫ��Ȩ�жϵ��ֶ�
		String[] sFieldKey =AuthPointField.trim().split(",");
		double[] dFieldValue = new double[sFieldKey.length];
		
		String[] AuthSumArr= null;
		//--------ͬҵ�����Ȩ(�������ۼ���Ȩ)-------------
		if(((String)oBusiness.getAttribute("BusinessType")).equals("3015"))
		{
			double dAuthTYED = 0.0;
			sSql = " select AuthSum3 from ORG_INFO where OrgID = '"+sOrgID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				dAuthTYED = rs.getDouble("AuthSum3");
			}else
			{
				sMessage = "��ͬҵ�����Ȩ��δ�Ա��������û���������";
				icount++;
				CheckLog(sMessage,0,0,0,"NoTypeAuth");
			}
			rs.getStatement().close();
			
			if(dAuthTYED == 0.0)
			{
				sMessage = "��ͬҵ�����Ȩ��δ�Ա���������ͬҵ�����Ȩ������";
				icount++;
				CheckLog(sMessage,0,0,0,"NoTongYeAuth");
			}else
			{
				dBusinessSum = Double.parseDouble((String)oBusiness.getAttribute("BusinessSum"));//�ñ�������
				if(dAuthTYED < dBusinessSum)
				{
					sMessage = "��ͬҵ�����Ȩ����ͬҵ�ͻ������ͬҵ��ȳ�������Ӧ��Ȩ��";
					icount++;
					CheckLog(sMessage,dBusinessSum,dBusinessSum,dAuthTYED,"Org_Info.AuthSum3");
				}
			}
			
		}else
		{
			/*˵�������һ�����������Ա����������ɫ��ͬʱ������ɫ����������Ȩ��������RoleID������򣬺�������һ����lpzhang
			 * */
			//--------����Ʒ��Ȩ-----------------
			if(!((String)oBusiness.getAttribute("BusinessType")).equals("3010"))//�ۺ����Ų����е���Ʒ��Ȩ���
			{
				sSql = " select "+AuthPointField+" from ORG_AUTH " +
					   " where OrgID='"+sOrgID+"' and locate(RoleID,'"+roles+"')>0 and  BusinessType = " +
					   " '"+(String)oBusiness.getAttribute("BusinessType")+"' order by RoleID desc fetch first 1 rows only";
				System.out.println("sSql1:"+sSql);
				AuthSumArr  = Sqlca.getStringArray(sSql);
				if(AuthSumArr.length==0)//δ������Ȩ
				{
					sMessage = "δ���û����øò�Ʒ����Ȩ��";
					icount++;
					CheckLog(sMessage,0,0,0,"NoTypeAuth");
				}else
				{
					dBusinessSum = Double.parseDouble((String)oBusiness.getAttribute("BusinessSum"));//�ñ�������
					for(int j=0;j<AuthSumArr.length;j++)
					{
						dFieldValue[j]= Double.parseDouble(AuthSumArr[j]);
						if(sFieldKey[j].equals("AuthSum2") || sFieldKey[j].equals("AuthSum4") || sFieldKey[j].equals("AuthSum6"))//��˾һ�����ҵ����Ȩ��΢С��ҵһ�����ҵ����Ȩ������ҵ��һ�������Ȩ	
						{
							dTotalBalance2 = getSum3();
							if(dTotalBalance2+dBusinessSum>dFieldValue[j])
							{
								sMessage = "��һ�����ҵ�񡿸ÿͻ��ڸò�Ʒ�����+���������Ʒ����Ӧ��Ȩ��";
								icount++;
								CheckLog(sMessage,dTotalBalance2,dBusinessSum,dFieldValue[j],sFieldKey[j]);
							}
						}
						
					}
				}
			}
			//------------�ۻ���Ȩ-----------
			sSql = " select "+AuthPointField+" from ORG_AUTH " +
			   " where OrgID='"+sOrgID+"' and locate(RoleID,'"+roles+"')>0  and  (BusinessType = '' or BusinessType is null) " +
			   "  order by RoleID desc fetch first 1 rows only";
			AuthSumArr  = Sqlca.getStringArray(sSql);
			if(AuthSumArr.length==0)//δ�����ۼ���Ȩ
			{
				sMessage = "δ���û������ۼ���Ȩ��";
				icount++;
				CheckLog(sMessage,0,0,0,"NoAllAuth");
			}else
			{
				dBusinessSum = Double.parseDouble((String)oBusiness.getAttribute("BusinessSum"));//�ñ�������
				for(int j=0;j<AuthSumArr.length;j++)
				{
					dFieldValue[j]= Double.parseDouble(AuthSumArr[j]);
					if(sFieldKey[j].equals("AuthSum1") || sFieldKey[j].equals("AuthSum5"))//��˾ҵ��ͷ�����Ȩ,���˵ͷ���ҵ����Ȩ
					{
						dTotalBalance1 = getSum2();
						if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
							sMessage = "���ͷ�����Ȩ���ÿͻ��ۻ������+��������ͻ����ۼ���Ȩ��";
							icount++;
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					
					if(sFieldKey[j].equals("AuthSum2") || sFieldKey[j].equals("AuthSum4") || sFieldKey[j].equals("AuthSum6") || sFieldKey[j].equals("AuthSum3"))//��˾һ�����ҵ����Ȩ��΢С��ҵһ�����ҵ����Ȩ������ҵ��һ�������Ȩ 
					{
						dTotalBalance1 = getSum1();
						System.out.println("dTotalBalance1::"+dTotalBalance1);
						if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
							sMessage = "��һ�����ҵ����Ȩ���ÿͻ��ۻ������+��������ͻ����ۼ���Ȩ��";
							icount++;
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					if(sFieldKey[j].equals("AuthSum3"))//��������	
					{
						dTotalBalance1 = getSum1();
						if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
							sMessage = "������������Ȩ���ÿͻ��ۻ������+��������ͻ����ۼ���Ȩ��";
							icount++;
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					
					if(sFieldKey[j].equals("AuthSum7"))//΢С�̻���Ȩ���
					{
						dTotalBalance1 = getSum4();
						if(dTotalBalance1+dBusinessSum>dFieldValue[j])
						{
							sMessage = "��΢С�̻���Ȩ���ÿͻ��ۻ������+��������ͻ����ۼ���Ȩ��";
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
			oBusiness.setAttribute("SerialNo",SerialNo); //��ͬ���
			oBusiness.setAttribute("BusinessType",BusinessType); //ҵ��Ʒ��
			oBusiness.setAttribute("CustomerID",CustomerID); //�ͻ����
			oBusiness.setAttribute("CustomerType",CustomerID); //�ͻ�����
			oBusiness.setAttribute("ApplyType",ApplyType); //��������
			oBusiness.setAttribute("CreditAggreement",CreditAggreement); //����Э��� 
			oBusiness.setAttribute("BusinessCurrency",BusinessCurrency); //ҵ�����
			oBusiness.setAttribute("BusinessSum",String.valueOf(rs.getDouble("BusinessSum1"))); //���Ž��
			oBusiness.setAttribute("TermMonth",String.valueOf(rs.getDouble("TermMonth"))); //����
			oBusiness.setAttribute("LowRisk",LowRisk); //�Ƿ�ͷ���
			oBusiness.setAttribute("OperateOrgID",OperateOrgID); //��������
			oBusiness.setAttribute("OperateOrgName",OperateOrgName); //������������
			oBusiness.setAttribute("OperateUserID",OperateUserID); //������
			oBusiness.setAttribute("OperateUserName",OperateUserName); //����������
			oBusiness.setAttribute("UpdateDate",UpdateDate); //��������
 		}else{
 			throw new Exception("��ʼ��ҵ��������û���ҵ�ҵ�����["+sObjectNo+"]");
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
	
	/** �ÿͻ�����һ�����ҵ�����
	 */
	public double getSum1() throws Exception
	{
		return cd.getSum("Balance","LowRisk",Tools.NOTEQUALS,"1");
	}
	
	/** �ÿͻ����еͷ���ҵ�����
	 */
	public double getSum2() throws Exception
	{
		return cd.getSum("Balance","LowRisk",Tools.EQUALS,"1");
	}
	
	/** �Ƹÿͻ���ҵ��Ʒ��ҵ�����,��ͳ�Ƶͷ���
	 */
	public double getSum3() throws Exception
	{
		WhereClause[] wc = new WhereClause[2];
	    wc[0] = new WhereClause("BusinessType",Tools.EQUALS,(String)oBusiness.getAttribute("BusinessType"));
		wc[1] = new WhereClause("LowRisk",Tools.NOTEQUALS,"1");
		
		return cd.getSum("Balance",wc);
	}
	
	/** �ÿͻ�����΢С�̻����
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
		//ȡ����Ȩ�ж��ֶ�
		//΢С�̻�����--����
		if(BusinessType.equals("1140120"))
		{
			AuthPointField = "AuthSum7";
		}else
		{
			/*sSql = " select FC.Aapolicy from Flow_Catalog FC,Flow_Object FO where FC.FlowNo= FO.FlowNo" +
				   " where ObjectNo ='"+sObjectNo+"' and ObjectType ='"+sObjectType+"'";
		    AuthPointField = Sqlca.getString("Aapolicy");
			if(AuthPointField ==null) AuthPointField="";*/
			if(sFlowNo.equals("EntCreditFlowTJ02"))//��˾�ͷ���ҵ����������
			{
				AuthPointField = "AuthSum1";
			}else if(sFlowNo.equals("EntCreditFlowTJ01") )//��˾һ�����ҵ����������
			{
				AuthPointField = "AuthSum2";
			}else if(sFlowNo.equals("CreditFlow02"))//΢С��ҵ
			{
				AuthPointField = "AuthSum4";
			}else if(sFlowNo.equals("IndCreditFlowTJ01"))//����һ�����
			{
				AuthPointField = "AuthSum6";
			}else if(sFlowNo.equals("IndCreditFlowTJ02"))//���˵ͷ���
			{
				AuthPointField = "AuthSum5";
			}
			
		}
		
		sSql = " select count(*) from CUSTOMER_SPECIAL where  SectionType='50' and CustomerID ='"+CustomerID+"'";
		
		int iNum = Sqlca.getDouble(sSql).intValue();
		
		if(!LowRisk.equals("1") && iNum>0)//�ɶ����ǵͷ���
		{
			AuthPointField =AuthPointField+",AuthSum3";
		}
		
		return AuthPointField;
	}
	
	//��¼δͨ����Ȩ��ԭ����־
	public void CheckLog(String sReason,double dTotalBalance,double dBusinessSum,double dAuthSum,String sAuthItem) throws Exception{
		
		Sqlca.executeSQL(" insert into Authorization_Check_Log(ApplySerialNo,TaskNo,Reason,UserID,FlowNo,TotalBalance,BusinessSum,AuthSum,AuthItem) " +
						 " values('"+sObjectNo+"','"+sTaskSerialNo+"','"+sReason+"','"+sUserID+"','"+sFlowNo+"',"+dTotalBalance+","+dBusinessSum+","+dAuthSum+",'"+sAuthItem+"')");
		
	}
	
	
}
