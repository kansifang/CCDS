package com.amarsoft.app.lending.bizlets;

/**
 * @(#)CreditAuthBusiness.java	2010-2-23
 *
 * Copyright 2006-2009 Amarsoft, Inc. All Rights Reserved.
 * 
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * 
 * Author:lpzhang
 * purpose:��ҵ����Ȩ�ж�
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


public class CreditAuthBusiness extends Bizlet{

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
	private String CurDate = StringFunction.getToday();
	
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
		String AuthPointField="",sMessage ="��Ȩ���ͨ��";
		double dTotalBalance1 = 0.0,dTotalBalance2 = 0.0,dBusinessSum = 0.0;
		double[] dFieldValue =null;
		String[] sFieldKey = null;
		String[] AuthSumArr= null;
		String sRepeatPhaseNo ="";
		String sPhaseNo ="";
		//��ʼ������
		initBusinessMemory(sObjectNo,Sqlca);
		initCustomerMemory(sObjectNo,sUserID,sOrgID,Sqlca);
		//ɾ���ϴ���Ȩ�����־
		Sqlca.executeSQL("delete from  Authorization_Check_Log where  ApplySerialNo = '"+sObjectNo+"'  and TaskNo = '"+sTaskSerialNo+"'");
		
		//----------------------0.����������(��ԭ���������˷����ñ�����������������)------------------------------
		if("090".equals((String) oBusiness.getAttribute("OccurType"))&& "".equals(roles))
		{
			//ԭ������������(�����)�׶κ�
			sRepeatPhaseNo = Sqlca.getString("select PhaseNo from FLOW_TASK where  " +
					"SerialNo=(select RelativeSerialNo from flow_Task " +
					"where  ObjectType='CreditApply' " +
					" and ObjectNo=(select ObjectNo from Apply_RELATIVE where SerialNo='"+sObjectNo+"' " +
					" and ObjectType='BusinessReApply')and PhaseNo='8000') ");
	    	if(sRepeatPhaseNo == null) sRepeatPhaseNo="0";
	    	//��ǰ����׶κ�
	    	sPhaseNo = Sqlca.getString("select PhaseNo from FLOW_TASK where  SerialNo='"+sTaskSerialNo+"'");
	    	if(sPhaseNo == null) sPhaseNo="";
	    	if(Double.parseDouble((String)sPhaseNo)<=Double.parseDouble((String)sRepeatPhaseNo))
	    	{
	    		sMessage = "�����������˴���Ȩ��";
				CheckLog(sMessage,0,0,0,"");
				return "FALSE";
	    	}
		}
		//----------------------0.�������(��ԭ���������˷����ñ�����������������)------------------------------
		if("120".equals((String) oBusiness.getAttribute("OccurType"))&& "".equals(roles))
		{
			//ԭ������������(�����)�׶κ�
			sRepeatPhaseNo = Sqlca.getString("select PhaseNo from FLOW_TASK where  " +
					"SerialNo=(select RelativeSerialNo from flow_Task " +
					"where  ObjectType='CreditApply' " +
					" and ObjectNo=(select BCH.RelativeSerialNo from Apply_RELATIVE AR,BUSINESS_CONTRACT_HISTORY BCH " +
					" where AR.SerialNo='"+sObjectNo+"' " +
					"  and AR.ObjectNo=BCH.Order and AR.ObjectType='ContractChange') and PhaseNo='1000') ");
	    	if(sRepeatPhaseNo == null)
	    	{
	    		//ԭ������������(�����)�׶κ�
				sRepeatPhaseNo = Sqlca.getString("select PhaseNo from FLOW_TASK where  " +
						"SerialNo=(select RelativeSerialNo from flow_Task " +
						"where  ObjectType='CreditApply' " +
						" and ObjectNo=(select ObjectNo from Apply_RELATIVE where SerialNo='"+sObjectNo+"' " +
						" and ObjectType='ApplyChange')and PhaseNo='1000') ");
	    		if(sRepeatPhaseNo == null) sRepeatPhaseNo="0";
	    	}
	    	//��ǰ����׶κ�
	    	sPhaseNo = Sqlca.getString("select PhaseNo from FLOW_TASK where  SerialNo='"+sTaskSerialNo+"'");
	    	if(sPhaseNo == null) sPhaseNo="";
	    	if(Double.parseDouble((String)sPhaseNo)<Double.parseDouble((String)sRepeatPhaseNo))
	    	{
	    		sMessage = "������������˴���Ȩ��";
				CheckLog(sMessage,0,0,0,"");
				return "FALSE";
	    	}
		}
		//----------------------0.��û�д��ݽ�ɫ�������------------------------------
		if("".equals(roles) || roles == null)
		{
			String[] roleTemp = Sqlca.getStringArray("select roleID from User_Role where UserID='"+sUserID+"'");
			for(int i=0;i<roleTemp.length;i++)
			{
				roles += roleTemp[i]+",";
			}
		}
		System.out.println("roles:"+roles);
		
		
		//----------------------1.��˾ҵ����Ȩ��ά�ȣ�������𡢽�ɫ��------------------------------
		if(((String)oBusiness.getAttribute("BusinessType")).startsWith("1010") || ((String)oBusiness.getAttribute("BusinessType")).startsWith("1020") 
			||((String)oBusiness.getAttribute("BusinessType")).startsWith("1030") ||((String)oBusiness.getAttribute("BusinessType")).startsWith("1040") 
			||((String)oBusiness.getAttribute("BusinessType")).startsWith("1050") ||((String)oBusiness.getAttribute("BusinessType")).startsWith("1060") 
			||((String)oBusiness.getAttribute("BusinessType")).startsWith("1080") ||((String)oBusiness.getAttribute("BusinessType")).startsWith("1090") 
			||(((String)oBusiness.getAttribute("BusinessType")).startsWith("2") && !((String)oBusiness.getAttribute("BusinessType")).startsWith("2110"))
			||((String)oBusiness.getAttribute("BusinessType")).startsWith("3010") )
		{
			AuthPointField=getAuthPointField1(sObjectNo,sObjectType,sFlowNo,Sqlca);//��˾ҵ��ȡ����Ҫ��Ȩ�жϵ��ֶ�
			sFieldKey =AuthPointField.trim().split(",");
		    dFieldValue = new double[sFieldKey.length];
		    //�жϻ������
		    String SqlArr="",OrgFlag="";
		    if(roles.indexOf("208")>-1){
		    	OrgFlag = Sqlca.getString("select OrgFlag from Org_Info where  OrgID ='"+sOrgID+"'");
		    	if(OrgFlag == null) OrgFlag="";
		    	if(OrgFlag.equals("040") )//������
		    	{
		    		SqlArr = " and Attribute2 = '010' ";
		    	}else if(OrgFlag.equals("020")){//������
		    		SqlArr = " and Attribute2 = '020' ";
		    	}
		    }
		    
		    sSql = " select "+AuthPointField+" from ORG_AUTH  where locate(RoleID,'"+roles+"')>0  " + SqlArr +
			       "  and  Attribute5='01' order by RoleID desc fetch first 1 rows only";
			AuthSumArr  = Sqlca.getStringArray(sSql);
			if(AuthSumArr.length==0)//δ������Ȩ
			{
				sMessage = "δ���û����ö�Ӧ��Ȩ��";
				icount++;
				CheckLog(sMessage,0,0,0,"NoAllAuth");
			}else
			{
				dBusinessSum = Double.parseDouble((String)oBusiness.getAttribute("BusinessSum"));//�ñ�������
				for(int j=0;j<AuthSumArr.length;j++)
				{
					dFieldValue[j]= Double.parseDouble(AuthSumArr[j]);
					if(sFieldKey[j].equals("AuthSum1"))//΢С��ҵ
					{
						dTotalBalance1 = getSum4();
						if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
							sMessage = "��΢С��ҵ��Ȩ���ÿͻ��ۻ������+���������ɫ��Ȩ��";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
					if(sFieldKey[j].equals("AuthSum2"))//��˾һ��������Ȩ���
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						System.out.println("dTotalBalance1+dBusinessSum:"+dTotalBalance1+dBusinessSum+"&&:dFieldValue[j]:"+dFieldValue[j]);
						if("065".equals(sOccurType)){//��������
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "����˾����(����)��Ȩ���ÿͻ��Ǳ��ʹ���ҵ���ۻ������+���������ɫ��Ȩ��";
								icount++;
							}	
						}else{
							if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
							double dd =dTotalBalance1+dBusinessSum;
							sMessage = "����˾һ��������Ȩ���ÿͻ��ۻ������+���������ɫ��Ȩ��";
							icount++;
							}
						}
						if("065".equals(sOccurType)){
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}else{
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					if(sFieldKey[j].equals("AuthSum3"))//��˾һ�������Ȩ���
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						if("060".equals(sOccurType)){
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "����˾һ�����(���ɽ���)��Ȩ���ÿͻ��Ǳ��ʹ���ҵ���ۻ������+���������ɫ��Ȩ��";
								icount++;
							}	
						}else if("020".equals(sOccurType)){
							if(dTotalBalance1+0>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "����˾һ�����(���»���)��Ȩ���ÿͻ��ۻ������(����������)+���������ͻ�ҵ��������ɫ��Ȩ��";
								icount++;
							}
						}else if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
							sMessage = "����˾һ�����(�ǻ��ɽ��½��»���)��Ȩ���ÿͻ��ۻ������+���������ɫ��Ȩ��";
							icount++;
						}
						if("060".equals(sOccurType)){
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}else if("020".equals(sOccurType)){
							CheckLog(sMessage,dTotalBalance1,0,dFieldValue[j],sFieldKey[j]);
						}else {
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					
					if(sFieldKey[j].equals("AuthSum4"))//��˾�ͷ�����Ȩ���
					{
						dTotalBalance1 = getSum2();
						if(dBusinessSum+dTotalBalance1>dFieldValue[j])
						{
							sMessage = "����˾�ͷ�����Ȩ���ÿͻ�������+�ÿͻ����еͷ���ҵ��������ɫ����Ȩ��";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
					if(sFieldKey[j].equals("AuthSum5"))//��������
					{
						dTotalBalance1 = getSum1();
						if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
							sMessage = "����˾����������Ȩ���ÿͻ��Ǳ��ʹ���ҵ���ۻ������+���������ɫ��Ȩ��";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
				}
			}
			
		}
		//----------------------2.����ҵ����Ȩ��ά�ȣ�ҵ��Ʒ�֡���ɫ������Ʒ��Ȩ------------------------------
		else if((((String)oBusiness.getAttribute("BusinessType")).startsWith("1110") || ((String)oBusiness.getAttribute("BusinessType")).startsWith("1140") || ((String)oBusiness.getAttribute("BusinessType")).equals("3040")
			||(((String)oBusiness.getAttribute("BusinessType")).startsWith("1150") ||((String)oBusiness.getAttribute("BusinessType")).startsWith("2110")))
			&& "1150010,1150050,1150060,1140130,1150020".indexOf(((String)oBusiness.getAttribute("BusinessType")))<0)
		{
		/*˵�������һ�����������Ա����������ɫ��ͬʱ������ɫ����������Ȩ��������RoleID������򣬺�������һ����lpzhang
		 * */
			AuthPointField=getAuthPointField2(sObjectNo,sObjectType,sFlowNo,Sqlca);//����ҵ��ȡ����Ҫ��Ȩ�жϵ��ֶ�
			sFieldKey =AuthPointField.trim().split(",");
		    dFieldValue = new double[sFieldKey.length];
		    String SqlCyc = "" , sCurBusinessType="";
		 
		    if("1140080".indexOf((String)oBusiness.getAttribute("BusinessType")) >-1)//�¸�ʧҵ
		    { 
		    	if(((String)oBusiness.getAttribute("CycleFlag")).equals("1")){
		    		SqlCyc = " and Attribute3 = '1' ";
		    	}else{
		    		SqlCyc = " and (Attribute3 = '2'  or Attribute3 is null or Attribute3 ='' ) ";
		    	}
		    }
		    sCurBusinessType = (String)oBusiness.getAttribute("BusinessType");
		    if(sCurBusinessType.equals("3040"))//ȡ�������ҵ��
		    {
		    	sSql = " select BusinessType from CL_Info where ApplySerialNo ='"+sObjectNo+"'  and (ParentLineID is not null and ParentLineID <> '')  fetch first 1 rows only";
		    	String sCLBusinessType = Sqlca.getString(sSql);
		    	if(sCLBusinessType == null) sCLBusinessType="";
		    	sCurBusinessType = sCLBusinessType;
		    }
		    
			sSql = " select "+AuthPointField+" from ORG_AUTH " +
				   " where locate(RoleID,'"+roles+"')>0" + SqlCyc +
				   " and BusinessType = '"+sCurBusinessType+"' and  Attribute5='02' order by RoleID desc fetch first 1 rows only";
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
					
					if(sFieldKey[j].equals("AuthSum2"))//����һ��������Ȩ���
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						if("065".equals(sOccurType)){//��������
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "��������������)��Ȩ���ÿͻ��Ǳ��ʹ���ҵ���ۻ������+���������ɫ��Ȩ��";
								icount++;
							}	
						}else{
							if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
								sMessage = "������һ��������Ȩ���ÿͻ�����Ʒ�ۻ������+���������ɫ��Ȩ��";
								icount++;
							}
						}
						if("065".equals(sOccurType)){//��������
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}else{
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					if(sFieldKey[j].equals("AuthSum3"))//����һ�������Ȩ���
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						if("060".equals(sOccurType)){
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "������һ�����(���ɽ���)��Ȩ���ÿͻ��Ǳ��ʹ���ҵ���ۻ������+���������ɫ��Ȩ��";
								icount++;
							}	
						}else if("020".equals(sOccurType)){
							if((dTotalBalance1+0>dFieldValue[j]) || dFieldValue[j]<=0){
								sMessage = "������һ�����(���»���)��Ȩ���ÿͻ�����Ʒ�ۻ������(����������)+���������ͻ�ҵ��������ɫ��Ȩ��";
								icount++;
							}
						}else if((dTotalBalance1+dBusinessSum>dFieldValue[j]) || dFieldValue[j]<=0){
							sMessage = "������һ�����(�ǻ��ɽ��½��»���)��Ȩ���ÿͻ�����Ʒ�ۻ������+���������ɫ��Ȩ��";
							icount++;
						}
						if("060".equals(sOccurType)){
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}else if("020".equals(sOccurType)){
							CheckLog(sMessage,dTotalBalance1,0,dFieldValue[j],sFieldKey[j]);
						}else {
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					
					if(sFieldKey[j].equals("AuthSum4"))//���˵ͷ�����Ȩ���
					{
						dTotalBalance1 = getSum2();
						if(dBusinessSum+dTotalBalance1>dFieldValue[j])
						{
							sMessage = "�����˵ͷ�����Ȩ���ÿͻ�������+�ÿͻ����еͷ���ҵ��������ɫ����Ȩ��";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
					if(sFieldKey[j].equals("AuthSum5"))//��������
					{
						dTotalBalance1 = getSum1();
						if((dTotalBalance1+dBusinessSum>dFieldValue[j]) || dFieldValue[j]<=0){
							sMessage = "����������������Ȩ���ÿͻ��Ǳ��ʹ���ҵ���ۻ������+���������ɫ��Ȩ��";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
				}
			}
		}
			
		//----------------------3.���ù�ͬ�弰������Ȩ��ά�ȣ�ҵ��Ʒ�֡���ɫ����������������Ʒ��Ȩ------------------------------
		else if("1150010,1150050,1150060,1140130,1150020,3060".indexOf(((String)oBusiness.getAttribute("BusinessType")))>-1)
		{
			/*˵�������һ�����������Ա����������ɫ��ͬʱ������ɫ����������Ȩ��������RoleID������򣬺�������һ����lpzhang
			 **/ 
			AuthPointField=getAuthPointField2(sObjectNo,sObjectType,sFlowNo,Sqlca);//���ù�ͬ�弰����ȡ����Ҫ��Ȩ�жϵ��ֶ�
			sFieldKey =AuthPointField.trim().split(",");
		    dFieldValue = new double[sFieldKey.length];
		    
		    String SqlStr0="", SqlStr="",sAssessLevel="";
		    int iCount=0;
		    /*ȡ����������*/
		    if("1150050,1150060,1140130".indexOf(((String)oBusiness.getAttribute("BusinessType")))>-1){
		    	 sAssessLevel = Sqlca.getString(" select CGALevel from CUSTOMER_RELATIVE where  RelationShip='0701' and RelativeID='"+(String) oBusiness.getAttribute("CustomerID")+"'");
			     if(sAssessLevel == null) sAssessLevel="";
			     iCount = Sqlca.getDouble("select Count(*) from CUSTOMER_RELATIVE WHERE RelativeID = '"+(String) oBusiness.getAttribute("CustomerID")+"' AND RelationShip LIKE '0501%'").intValue();
			     if(iCount>0)
			     {
			    	 sAssessLevel = sAssessLevel+"001";
			     }
		    }
		    if("1150020,1150010".indexOf(((String)oBusiness.getAttribute("BusinessType")))>-1)
	        {
	    	     sAssessLevel = Sqlca.getString(" select FCreditLevel from IND_INFO where CustomerID='"+(String) oBusiness.getAttribute("CustomerID")+"'");
	    	     if(sAssessLevel == null) sAssessLevel="";
	        }
		    
		    if("1150020".indexOf((String)oBusiness.getAttribute("BusinessType"))>-1)//����
		    {
		    	sAssessLevel = sAssessLevel+"001";
		    }
		    if("3060".indexOf((String)oBusiness.getAttribute("BusinessType")) < 0)//���ù�ͬ����
		    {
		    	SqlStr0 = " and  Attribute1 = '"+sAssessLevel+"'  " ;
		    }
		    /*ȡ�ù�ͬ������*/
		    if("1150050,1150060,1140130".indexOf((String)oBusiness.getAttribute("BusinessType"))>-1)
		    {
		    	String sCommunityType = Sqlca.getString("select SuperCertType from ENT_INFO where CustomerID =(SELECT CustomerID FROM CUSTOMER_RELATIVE  WHERE RelativeID = '"+(String) oBusiness.getAttribute("CustomerID")+"' AND RelationShip LIKE '0701%')");
			    if(sCommunityType == null) sCommunityType="";
			    SqlStr = " and Attribute2 = '"+sCommunityType+"' ";
		    }else if("3060".indexOf((String)oBusiness.getAttribute("BusinessType"))>-1)
		    {
		    	String sCommunityType = Sqlca.getString("select SuperCertType from ENT_INFO where CustomerID = '" +(String) oBusiness.getAttribute("CustomerID")+"' ");
			    if(sCommunityType == null) sCommunityType="";
			    SqlStr = " and Attribute2 = '"+sCommunityType+"' ";
		    }
		    else{
		    	SqlStr = " and (Attribute2 = '' or Attribute2 is null) ";
		    }
		    
			sSql = " select "+AuthPointField+" from ORG_AUTH " +
				   " where 1=1 " + SqlStr0 + SqlStr +
				   "  and locate(RoleID,'"+roles+"')>0 and BusinessType = '"+(String)oBusiness.getAttribute("BusinessType")+"' and  Attribute5='02' order by RoleID desc fetch first 1 rows only";

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
					
					if(sFieldKey[j].equals("AuthSum2"))//����һ��������Ȩ���
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						if("065".equals(sOccurType)){//��������
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "������(��������)��Ȩ���ÿͻ��Ǳ��ʹ���ҵ���ۻ������+���������ɫ��Ȩ��";
								icount++;
							}	
						}else{
							if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
								sMessage = "������һ��������Ȩ���ÿͻ�����Ʒ�ۻ������+���������ɫ��Ȩ��";
								icount++;
							}
						}
						if("065".equals(sOccurType)){
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}else{
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					if(sFieldKey[j].equals("AuthSum3"))//����һ�������Ȩ���
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						if("060".equals(sOccurType)){
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "������һ�����(���ɽ���)��Ȩ���ÿͻ��Ǳ��ʹ���ҵ���ۻ������+���������ɫ��Ȩ��";
								icount++;
							}	
						}else if("020".equals(sOccurType)){
							if((dTotalBalance1+0>dFieldValue[j]) || dFieldValue[j]<=0){
								sMessage = "������һ�����(���»���)��Ȩ���ÿͻ�����Ʒ�ۻ������(����������)+���������ͻ�ҵ��������ɫ��Ȩ��";
								icount++;							}
						}else if((dTotalBalance1+dBusinessSum>dFieldValue[j]) || dFieldValue[j]<=0){
							sMessage = "������һ�����(�ǻ��ɽ��»��ɽ���)��Ȩ���ÿͻ�����Ʒ�ۻ������+���������ɫ��Ȩ��";
							icount++;
						}
						if("060".equals(sOccurType)){
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}else if("020".equals(sOccurType)){
							CheckLog(sMessage,dTotalBalance1,0,dFieldValue[j],sFieldKey[j]);
						}else {
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					
					if(sFieldKey[j].equals("AuthSum4"))//���˵ͷ�����Ȩ���
					{
						dTotalBalance1 = getSum2();
						if(dBusinessSum+dTotalBalance1>dFieldValue[j])
						{
							sMessage = "�����˵ͷ�����Ȩ���ÿͻ������+�ÿͻ����еͷ���ҵ��������ɫ����Ȩ��";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
					if(sFieldKey[j].equals("AuthSum5"))//��������
					{
						dTotalBalance1 = getSum1();
						if((dTotalBalance1+dBusinessSum>dFieldValue[j]) || dFieldValue[j]<=0){
							//sMessage = "����������������Ȩ���ÿͻ��ۻ������(����������)������ɫ��Ȩ��";
							sMessage = "����������������Ȩ���ÿͻ��Ǳ��ʹ���ҵ���ۻ������+���������ɫ��Ȩ��";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
				}
			}
		}
		else
		{
			sMessage = "δ������Ȩ���ã�";
			icount++;
			CheckLog(sMessage,0,0,0,"NoAuth");
		}
		
	
		System.out.println("sMessage:"+sMessage);
		
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
			   " from BUSINESS_APPLY BA where BA.SerialNo = '"+sObjectNo+"' " ;
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			String SerialNo = rs.getString("SerialNo"); if(SerialNo == null) SerialNo="";
			String BusinessType = rs.getString("BusinessType"); if(BusinessType == null) BusinessType="";
			String OccurType = rs.getString("OccurType"); if(OccurType == null) OccurType="";
			String CustomerID = rs.getString("CustomerID"); if(CustomerID == null) CustomerID="";
			String CustomerType = rs.getString("CustomerType"); if(CustomerType == null) CustomerType="";
			String ApplyType = rs.getString("ApplyType"); if(ApplyType == null) ApplyType="";
			String CreditAggreement = rs.getString("CreditAggreement"); if(CreditAggreement == null) CreditAggreement="";
			String BusinessCurrency = rs.getString("BusinessCurrency"); if(BusinessCurrency == null) BusinessCurrency="";
			String LowRisk = rs.getString("LowRisk"); if(LowRisk == null) LowRisk="";
			String NationRisk = rs.getString("NationRisk"); if(NationRisk == null) NationRisk="";
			String CycleFlag = rs.getString("CycleFlag"); if(CycleFlag == null) CycleFlag="";
			String OperateOrgID = rs.getString("OperateOrgID"); if(OperateOrgID == null) OperateOrgID="";
			String OperateOrgName = rs.getString("OperateOrgName"); if(OperateOrgName == null) OperateOrgName="";
			String OperateUserID = rs.getString("OperateUserID"); if(OperateUserID == null) OperateUserID="";
			String OperateUserName = rs.getString("OperateUserName"); if(OperateUserName == null) OperateUserName="";
			String UpdateDate = rs.getString("UpdateDate"); if(UpdateDate == null) UpdateDate="";
			
			oBusiness.setAttribute("SerialNo",SerialNo); //������
			oBusiness.setAttribute("BusinessType",BusinessType); //ҵ��Ʒ��
			oBusiness.setAttribute("OccurType",OccurType); //������ʽ
			oBusiness.setAttribute("CustomerID",CustomerID); //�ͻ����
			oBusiness.setAttribute("CustomerType",CustomerType); //�ͻ�����
			oBusiness.setAttribute("ApplyType",ApplyType); //��������
			oBusiness.setAttribute("CreditAggreement",CreditAggreement); //����Э��� 
			oBusiness.setAttribute("BusinessCurrency",BusinessCurrency); //ҵ�����
			//������ʽΪչ��
			if(OccurType.equals("015"))
			{
				oBusiness.setAttribute("BusinessSum",String.valueOf(0)); //���Ž��
			}else
			{
				oBusiness.setAttribute("BusinessSum",String.valueOf(rs.getDouble("BusinessSum1"))); //���Ž��
			}
			oBusiness.setAttribute("TermMonth",String.valueOf(rs.getDouble("TermMonth"))); //����
			oBusiness.setAttribute("LowRisk",LowRisk); //�Ƿ�ͷ���
			oBusiness.setAttribute("NationRisk",NationRisk); //����ҵ���϶�Ϊ�ͷ���
			oBusiness.setAttribute("CycleFlag",CycleFlag); //�Ƿ�ѭ������
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
	
	//change by zwhu 20100702 ���ͻ��ۼ���Ȩ����ɣ��������+�ۺ����Ŷ�ȣ� ��Ϊ���������+�ۺ����Ŷ������ҵ����
	public void initCustomerMemory(String sObjectNo,String sUserID,String sOrgID,Transaction Sqlca) throws Exception
	{
		sSql = " Select SerialNo,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,BusinessCurrency,BailSum,BailRatio," +
			   " BusinessType,nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate) as Balance,VouchType,CustomerID,Maturity,LowRisk,NationRisk " +
			   " from Business_Contract BC Where ((CustomerID = '"+(String)oBusiness.getAttribute("CustomerID")+"'" +
			   " and ApplyType = 'IndependentApply' and (FinishDate is null or FinishDate ='')) " +
			   " or (CustomerID = '"+(String)oBusiness.getAttribute("CustomerID")+"'" +
			   " and ApplyType = 'DependentApply' and (FinishDate is null or FinishDate =''))) "+
			   " and OccurType<>'015' ";//��Ϊչ��
			   
//			   " or (('"+CurDate+"' < Maturity  or Maturity is null or Maturity ='') and CustomerID = '"+(String)oBusiness.getAttribute("CustomerID")+"'" +
//			   " and (FinishDate is null or FinishDate ='') and ApplyType = 'CreditLineApply') ";
		//���ù�ͬ����
		if("3060".equals((String)oBusiness.getAttribute("BusinessType"))){
			sSql=" Select SerialNo,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,BusinessCurrency,BailSum,BailRatio," +
			   " BusinessType,nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate) as Balance,VouchType,CustomerID,Maturity,LowRisk,NationRisk " +
			   " from Business_Contract BC Where (CustomerID = '"+(String)oBusiness.getAttribute("CustomerID")+"'" +
			   " and BusinessType like '3060%' "+
			   " and (FinishDate is null or FinishDate ='') and ApplyType = 'CreditLineApply') ";
		}
		
		if(((String)oBusiness.getAttribute("OccurType")).equals("100"))
		{
			sSql += " and not exists (select 'X' from APPLY_RELATIVE AR where AR.ObjectType='CLBusinessChange' and AR.ObjectNo = BC.SerialNo and AR.SerialNo='"+sObjectNo+"')";
		}
		if("020".equals((String)oBusiness.getAttribute("OccurType"))){//���»��ɹ���ҵ��
			sSql += " or BC.SerialNo  in (select RelativeSerialNo2 from Business_Duebill where SerialNo in ( "+
			" select ObjectNo from Apply_Relative where ObjectType = 'BusinessDueBill' and SerialNo  = '"+
			(String)oBusiness.getAttribute("SerialNo")+"') and CustomerID!='"+(String)oBusiness.getAttribute("CustomerID")+"')";
		}else if("060".equals((String)oBusiness.getAttribute("OccurType"))){//���ɽ���
			sSql += " and BC.SerialNo not in (select RelativeSerialNo2 from Business_Duebill where SerialNo in ( "+
					" select ObjectNo from Apply_Relative where ObjectType = 'BusinessDueBill' and SerialNo  = '"+
					(String)oBusiness.getAttribute("SerialNo")+"'))";
		}else if("065".equals((String)oBusiness.getAttribute("OccurType"))){//��������
			sSql += " and BC.SerialNo not in (select RelativeSerialNo2 from Business_Duebill where SerialNo in ( "+
			" select ObjectNo from Apply_Relative where ObjectType = 'BusinessDueBill' and SerialNo  = '"+
			(String)oBusiness.getAttribute("SerialNo")+"'))";
		}else if("030".equals((String)oBusiness.getAttribute("OccurType"))){//��������
			sSql += " and BC.SerialNo  not in (select ObjectNo from REFORM_RELATIVE where ObjectType='BusinessContract' "+
			" and SerialNo=(select ObjectNo from APPLY_RELATIVE where ObjectType='CapitalReform' and SerialNo='"+
			(String)oBusiness.getAttribute("SerialNo")+"') and "+
			" exists(select 1 from BUSINESS_CONTRACT where SerialNo=REFORM_RELATIVE.ObjectNo "+
			" and CustomerID='"+(String)oBusiness.getAttribute("CustomerID")+"'))";
		}
	   cd = new CreditData(Sqlca,sSql);
	}
	
	/** �ÿͻ�����һ�����ҵ�����
	 */
	public double getSum1() throws Exception
	{
		return cd.getSum("Balance","LowRisk",Tools.S1,"1");
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
	
	/** �ÿͻ��������
	 */
	public double getSum4() throws Exception
	{
		return cd.getSum("Balance","SerialNo",Tools.ISNOTNULL,"");
	}
	
	/**
	 * ��˾ҵ����ȨȨ���ֶ��ж�
	 * @param sObjectNo
	 * @param sObjectType
	 * @param sFlowNo
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String  getAuthPointField1(String sObjectNo,String sObjectType,String sFlowNo,Transaction Sqlca) throws Exception
	{
		String BusinessType = (String) oBusiness.getAttribute("BusinessType");
		String OccurType = (String) oBusiness.getAttribute("OccurType");
		String CustomerID =  (String) oBusiness.getAttribute("CustomerID");
		String CustomerType =  (String) oBusiness.getAttribute("CustomerType");
		String LowRisk =  (String) oBusiness.getAttribute("LowRisk");
		String NationRisk =  (String) oBusiness.getAttribute("NationRisk");
		String AuthPointField ="" ,sSmallEntFlag="",ReCreditFlag="";
		if(NationRisk.equals("1")){//����ҵ���϶��ͷ�������
			LowRisk="1";
		}
		
		//�ж��Ƿ�Ϊ΢С��ҵSmallEntFlag
		sSql = "select SmallEntFlag,SetupDate from ENT_INFO where  CustomerID ='"+CustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sSmallEntFlag = rs.getString("SmallEntFlag");
			if(sSmallEntFlag == null ) sSmallEntFlag ="";
		}
		rs.getStatement().close();
		//ȡ�����鷽ʽ��ʶ
		if(OccurType.equals("030"))// �ʲ�����
		{
			ReCreditFlag = Sqlca.getString("select ApplyType from APPLY_RELATIVE AR,REFORM_INFO RI where AR.ObjectNo = RI.SerialNo and AR.SerialNo ='"+this.sObjectNo+"'");
			if(ReCreditFlag == null) ReCreditFlag ="";
		}
		//ȡ����Ȩ�ж��ֶ�
		if(ReCreditFlag.equals("02")){//��������
			AuthPointField = "AuthSum5";
		}else if(ReCreditFlag.equals("01")){ //һ������
			AuthPointField = "AuthSum2";
		}else if("1".equals(sSmallEntFlag)){ //΢С��ҵ
			AuthPointField = "AuthSum1";
		}else if("1".equals(LowRisk)){ //�ͷ�����Ȩ
			AuthPointField = "AuthSum4";
		}else if(OccurType.equals("010")||OccurType.equals("065")){ //����ҵ��||��������
			AuthPointField = "AuthSum2";
		}else{    //����ҵ��
			AuthPointField = "AuthSum3";
		}
		
		return AuthPointField;
	}
	/**
	 * ����ҵ����ȨȨ���ֶ��ж�
	 * @param sObjectNo
	 * @param sObjectType
	 * @param sFlowNo
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String  getAuthPointField2(String sObjectNo,String sObjectType,String sFlowNo,Transaction Sqlca) throws Exception
	{
		String BusinessType = (String) oBusiness.getAttribute("BusinessType");
		String OccurType = (String) oBusiness.getAttribute("OccurType");
		String CustomerID =  (String) oBusiness.getAttribute("CustomerID");
		String CustomerType =  (String) oBusiness.getAttribute("CustomerType");
		String LowRisk =  (String) oBusiness.getAttribute("LowRisk");
		String AuthPointField ="" ,sSmallEntFlag="",ReCreditFlag="";
		//���������Ϣ:ԭ������ˮ��,ԭ��������,ԭ�����ʶ,ԭ�ͷ��ձ�ʶ
		String sReObjectNo="",sReOccurType="",sReLowRisk="";
		//ȡ�ø������ԭҵ����Ϣ
		if(OccurType.equals("090"))// ����
		{
			sReObjectNo = Sqlca.getString("select ObjectNo from Apply_RELATIVE where SerialNo='"+sObjectNo+"' " +
			" and ObjectType='BusinessReApply' fetch first 1 Row only");
			if(sReObjectNo == null) sReObjectNo ="";
			sSql=" select LowRisk,OccurType from BUSINESS_CONTRACT where SerialNo ='"+sReObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sReLowRisk = rs.getString("LowRisk");
				if(sReLowRisk == null ) sReLowRisk ="";
				sReOccurType = rs.getString("OccurType");
				if(sReOccurType == null ) sReOccurType ="";
			}
			rs.getStatement().close();
			//ȡ�����鷽ʽ��ʶ
			if(sReOccurType.equals("030"))// �ʲ�����
			{
				ReCreditFlag = Sqlca.getString("select ApplyType from APPLY_RELATIVE AR,REFORM_INFO RI where AR.ObjectNo = RI.SerialNo and AR.SerialNo ='"+sReObjectNo+"'");
				if(ReCreditFlag == null) ReCreditFlag ="";
			}
	
			//ȡ����Ȩ�ж��ֶ�
			if(ReCreditFlag.equals("02")){//��������
				AuthPointField = "AuthSum5";
			}else if("1".equals(sReLowRisk)){ //�ͷ�����Ȩ
				AuthPointField = "AuthSum4";
			}else if(sReOccurType.equals("010")){ //����ҵ��
				AuthPointField = "AuthSum2";
			}else{    //����ҵ��
				AuthPointField = "AuthSum3";
			}
		}else{
			//ȡ�����鷽ʽ��ʶ
			if(OccurType.equals("030"))// �ʲ�����
			{
				ReCreditFlag = Sqlca.getString("select ApplyType from APPLY_RELATIVE AR,REFORM_INFO RI where AR.ObjectNo = RI.SerialNo and AR.SerialNo ='"+this.sObjectNo+"'");
				if(ReCreditFlag == null) ReCreditFlag ="";
			}
	
			//ȡ����Ȩ�ж��ֶ�
			if(ReCreditFlag.equals("02")){//��������
				AuthPointField = "AuthSum5";
			}else if("1".equals(LowRisk)){ //�ͷ�����Ȩ
				AuthPointField = "AuthSum4";
			}else if(OccurType.equals("010")||OccurType.equals("065")){ //����ҵ��
				AuthPointField = "AuthSum2";
			}else{    //����ҵ��
				AuthPointField = "AuthSum3";
			}
		}
		return AuthPointField;
	}
	
	
	//��¼δͨ����Ȩ��ԭ����־
	public void CheckLog(String sReason,double dTotalBalance,double dBusinessSum,double dAuthSum,String sAuthItem) throws Exception{
		
		Sqlca.executeSQL(" insert into Authorization_Check_Log(ApplySerialNo,TaskNo,Reason,UserID,FlowNo,TotalBalance,BusinessSum,AuthSum,AuthItem) " +
						 " values('"+sObjectNo+"','"+sTaskSerialNo+"','"+sReason+"','"+sUserID+"','"+sFlowNo+"',"+dTotalBalance+","+dBusinessSum+","+dAuthSum+",'"+sAuthItem+"')");
		
	}
	
	
}
