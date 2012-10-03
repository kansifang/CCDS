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
 * purpose:新业务授权判断
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
	private String CurDate = StringFunction.getToday();
	
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
		String AuthPointField="",sMessage ="授权检查通过";
		double dTotalBalance1 = 0.0,dTotalBalance2 = 0.0,dBusinessSum = 0.0;
		double[] dFieldValue =null;
		String[] sFieldKey = null;
		String[] AuthSumArr= null;
		String sRepeatPhaseNo ="";
		String sPhaseNo ="";
		//初始化对象
		initBusinessMemory(sObjectNo,Sqlca);
		initCustomerMemory(sObjectNo,sUserID,sOrgID,Sqlca);
		//删除上次授权检测日志
		Sqlca.executeSQL("delete from  Authorization_Check_Log where  ApplySerialNo = '"+sObjectNo+"'  and TaskNo = '"+sTaskSerialNo+"'");
		
		//----------------------0.复审否决申请(若原申请终审人否决则该笔申请跳过该终审人)------------------------------
		if("090".equals((String) oBusiness.getAttribute("OccurType"))&& "".equals(roles))
		{
			//原申请终审批人(否决人)阶段号
			sRepeatPhaseNo = Sqlca.getString("select PhaseNo from FLOW_TASK where  " +
					"SerialNo=(select RelativeSerialNo from flow_Task " +
					"where  ObjectType='CreditApply' " +
					" and ObjectNo=(select ObjectNo from Apply_RELATIVE where SerialNo='"+sObjectNo+"' " +
					" and ObjectType='BusinessReApply')and PhaseNo='8000') ");
	    	if(sRepeatPhaseNo == null) sRepeatPhaseNo="0";
	    	//当前申请阶段号
	    	sPhaseNo = Sqlca.getString("select PhaseNo from FLOW_TASK where  SerialNo='"+sTaskSerialNo+"'");
	    	if(sPhaseNo == null) sPhaseNo="";
	    	if(Double.parseDouble((String)sPhaseNo)<=Double.parseDouble((String)sRepeatPhaseNo))
	    	{
	    		sMessage = "【复审】跳过此次授权！";
				CheckLog(sMessage,0,0,0,"");
				return "FALSE";
	    	}
		}
		//----------------------0.变更申请(若原申请终审人否决则该笔申请跳过该终审人)------------------------------
		if("120".equals((String) oBusiness.getAttribute("OccurType"))&& "".equals(roles))
		{
			//原申请终审批人(否决人)阶段号
			sRepeatPhaseNo = Sqlca.getString("select PhaseNo from FLOW_TASK where  " +
					"SerialNo=(select RelativeSerialNo from flow_Task " +
					"where  ObjectType='CreditApply' " +
					" and ObjectNo=(select BCH.RelativeSerialNo from Apply_RELATIVE AR,BUSINESS_CONTRACT_HISTORY BCH " +
					" where AR.SerialNo='"+sObjectNo+"' " +
					"  and AR.ObjectNo=BCH.Order and AR.ObjectType='ContractChange') and PhaseNo='1000') ");
	    	if(sRepeatPhaseNo == null)
	    	{
	    		//原申请终审批人(否决人)阶段号
				sRepeatPhaseNo = Sqlca.getString("select PhaseNo from FLOW_TASK where  " +
						"SerialNo=(select RelativeSerialNo from flow_Task " +
						"where  ObjectType='CreditApply' " +
						" and ObjectNo=(select ObjectNo from Apply_RELATIVE where SerialNo='"+sObjectNo+"' " +
						" and ObjectType='ApplyChange')and PhaseNo='1000') ");
	    		if(sRepeatPhaseNo == null) sRepeatPhaseNo="0";
	    	}
	    	//当前申请阶段号
	    	sPhaseNo = Sqlca.getString("select PhaseNo from FLOW_TASK where  SerialNo='"+sTaskSerialNo+"'");
	    	if(sPhaseNo == null) sPhaseNo="";
	    	if(Double.parseDouble((String)sPhaseNo)<Double.parseDouble((String)sRepeatPhaseNo))
	    	{
	    		sMessage = "【变更】跳过此次授权！";
				CheckLog(sMessage,0,0,0,"");
				return "FALSE";
	    	}
		}
		//----------------------0.在没有传递角色的情况下------------------------------
		if("".equals(roles) || roles == null)
		{
			String[] roleTemp = Sqlca.getStringArray("select roleID from User_Role where UserID='"+sUserID+"'");
			for(int i=0;i<roleTemp.length;i++)
			{
				roles += roleTemp[i]+",";
			}
		}
		System.out.println("roles:"+roles);
		
		
		//----------------------1.公司业务授权（维度：贷款类别、角色）------------------------------
		if(((String)oBusiness.getAttribute("BusinessType")).startsWith("1010") || ((String)oBusiness.getAttribute("BusinessType")).startsWith("1020") 
			||((String)oBusiness.getAttribute("BusinessType")).startsWith("1030") ||((String)oBusiness.getAttribute("BusinessType")).startsWith("1040") 
			||((String)oBusiness.getAttribute("BusinessType")).startsWith("1050") ||((String)oBusiness.getAttribute("BusinessType")).startsWith("1060") 
			||((String)oBusiness.getAttribute("BusinessType")).startsWith("1080") ||((String)oBusiness.getAttribute("BusinessType")).startsWith("1090") 
			||(((String)oBusiness.getAttribute("BusinessType")).startsWith("2") && !((String)oBusiness.getAttribute("BusinessType")).startsWith("2110"))
			||((String)oBusiness.getAttribute("BusinessType")).startsWith("3010") )
		{
			AuthPointField=getAuthPointField1(sObjectNo,sObjectType,sFlowNo,Sqlca);//公司业务取得需要授权判断的字段
			sFieldKey =AuthPointField.trim().split(",");
		    dFieldValue = new double[sFieldKey.length];
		    //判断机构组别
		    String SqlArr="",OrgFlag="";
		    if(roles.indexOf("208")>-1){
		    	OrgFlag = Sqlca.getString("select OrgFlag from Org_Info where  OrgID ='"+sOrgID+"'");
		    	if(OrgFlag == null) OrgFlag="";
		    	if(OrgFlag.equals("040") )//合行组
		    	{
		    		SqlArr = " and Attribute2 = '010' ";
		    	}else if(OrgFlag.equals("020")){//联社组
		    		SqlArr = " and Attribute2 = '020' ";
		    	}
		    }
		    
		    sSql = " select "+AuthPointField+" from ORG_AUTH  where locate(RoleID,'"+roles+"')>0  " + SqlArr +
			       "  and  Attribute5='01' order by RoleID desc fetch first 1 rows only";
			AuthSumArr  = Sqlca.getStringArray(sSql);
			if(AuthSumArr.length==0)//未设置授权
			{
				sMessage = "未对用户设置对应授权！";
				icount++;
				CheckLog(sMessage,0,0,0,"NoAllAuth");
			}else
			{
				dBusinessSum = Double.parseDouble((String)oBusiness.getAttribute("BusinessSum"));//该笔申请金额
				for(int j=0;j<AuthSumArr.length;j++)
				{
					dFieldValue[j]= Double.parseDouble(AuthSumArr[j]);
					if(sFieldKey[j].equals("AuthSum1"))//微小企业
					{
						dTotalBalance1 = getSum4();
						if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
							sMessage = "【微小企业授权】该客户累积的余额+申请金额超过角色授权！";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
					if(sFieldKey[j].equals("AuthSum2"))//公司一般新增授权金额
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						System.out.println("dTotalBalance1+dBusinessSum:"+dTotalBalance1+dBusinessSum+"&&:dFieldValue[j]:"+dFieldValue[j]);
						if("065".equals(sOccurType)){//新增续作
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "【公司新增(续作)授权】该客户非本笔关联业务累积的余额+申请金额超过角色授权！";
								icount++;
							}	
						}else{
							if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
							double dd =dTotalBalance1+dBusinessSum;
							sMessage = "【公司一般新增授权】该客户累积的余额+申请金额超过角色授权！";
							icount++;
							}
						}
						if("065".equals(sOccurType)){
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}else{
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					if(sFieldKey[j].equals("AuthSum3"))//公司一般存量授权金额
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						if("060".equals(sOccurType)){
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "【公司一般存量(还旧借新)授权】该客户非本笔关联业务累积的余额+申请金额超过角色授权！";
								icount++;
							}	
						}else if("020".equals(sOccurType)){
							if(dTotalBalance1+0>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "【公司一般存量(借新还旧)授权】该客户累积的余额(不含申请金额)+关联其他客户业务余额超过角色授权！";
								icount++;
							}
						}else if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
							sMessage = "【公司一般存量(非还旧借新借新还旧)授权】该客户累积的余额+申请金额超过角色授权！";
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
					
					if(sFieldKey[j].equals("AuthSum4"))//公司低风险授权金额
					{
						dTotalBalance1 = getSum2();
						if(dBusinessSum+dTotalBalance1>dFieldValue[j])
						{
							sMessage = "【公司低风险授权】该客户申请金额+该客户所有低风险业务余额超过角色的授权！";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
					if(sFieldKey[j].equals("AuthSum5"))//扩盘重组
					{
						dTotalBalance1 = getSum1();
						if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
							sMessage = "【公司扩盘重组授权】该客户非本笔关联业务累积的余额+申请金额超过角色授权！";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
				}
			}
			
		}
		//----------------------2.个人业务授权（维度：业务品种、角色）单产品授权------------------------------
		else if((((String)oBusiness.getAttribute("BusinessType")).startsWith("1110") || ((String)oBusiness.getAttribute("BusinessType")).startsWith("1140") || ((String)oBusiness.getAttribute("BusinessType")).equals("3040")
			||(((String)oBusiness.getAttribute("BusinessType")).startsWith("1150") ||((String)oBusiness.getAttribute("BusinessType")).startsWith("2110")))
			&& "1150010,1150050,1150060,1140130,1150020".indexOf(((String)oBusiness.getAttribute("BusinessType")))<0)
		{
		/*说明：如果一个审查审批人员具有两个角色，同时两个角色都具有审批权。则会根据RoleID排序规则，忽略其中一个。lpzhang
		 * */
			AuthPointField=getAuthPointField2(sObjectNo,sObjectType,sFlowNo,Sqlca);//个人业务取得需要授权判断的字段
			sFieldKey =AuthPointField.trim().split(",");
		    dFieldValue = new double[sFieldKey.length];
		    String SqlCyc = "" , sCurBusinessType="";
		 
		    if("1140080".indexOf((String)oBusiness.getAttribute("BusinessType")) >-1)//下岗失业
		    { 
		    	if(((String)oBusiness.getAttribute("CycleFlag")).equals("1")){
		    		SqlCyc = " and Attribute3 = '1' ";
		    	}else{
		    		SqlCyc = " and (Attribute3 = '2'  or Attribute3 is null or Attribute3 ='' ) ";
		    	}
		    }
		    sCurBusinessType = (String)oBusiness.getAttribute("BusinessType");
		    if(sCurBusinessType.equals("3040"))//取额度项下业务
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
					
					if(sFieldKey[j].equals("AuthSum2"))//个人一般新增授权金额
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						if("065".equals(sOccurType)){//新增续作
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "【个人新增续作)授权】该客户非本笔关联业务累积的余额+申请金额超过角色授权！";
								icount++;
							}	
						}else{
							if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
								sMessage = "【个人一般新增授权】该客户单产品累积的余额+申请金额超过角色授权！";
								icount++;
							}
						}
						if("065".equals(sOccurType)){//新增续作
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}else{
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					if(sFieldKey[j].equals("AuthSum3"))//个人一般存量授权金额
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						if("060".equals(sOccurType)){
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "【个人一般存量(还旧借新)授权】该客户非本笔关联业务累积的余额+申请金额超过角色授权！";
								icount++;
							}	
						}else if("020".equals(sOccurType)){
							if((dTotalBalance1+0>dFieldValue[j]) || dFieldValue[j]<=0){
								sMessage = "【个人一般存量(借新还旧)授权】该客户单产品累积的余额(不含申请金额)+关联其他客户业务余额超过角色授权！";
								icount++;
							}
						}else if((dTotalBalance1+dBusinessSum>dFieldValue[j]) || dFieldValue[j]<=0){
							sMessage = "【个人一般存量(非还旧借新借新还旧)授权】该客户单产品累积的余额+申请金额超过角色授权！";
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
					
					if(sFieldKey[j].equals("AuthSum4"))//个人低风险授权金额
					{
						dTotalBalance1 = getSum2();
						if(dBusinessSum+dTotalBalance1>dFieldValue[j])
						{
							sMessage = "【个人低风险授权】该客户申请金额+该客户所有低风险业务余额超过角色的授权！";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
					if(sFieldKey[j].equals("AuthSum5"))//扩盘重组
					{
						dTotalBalance1 = getSum1();
						if((dTotalBalance1+dBusinessSum>dFieldValue[j]) || dFieldValue[j]<=0){
							sMessage = "【个人扩盘重组授权】该客户非本笔关联业务累积的余额+申请金额超过角色授权！";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
				}
			}
		}
			
		//----------------------3.信用共同体及联保授权（维度：业务品种、角色、信用评级）单产品授权------------------------------
		else if("1150010,1150050,1150060,1140130,1150020,3060".indexOf(((String)oBusiness.getAttribute("BusinessType")))>-1)
		{
			/*说明：如果一个审查审批人员具有两个角色，同时两个角色都具有审批权。则会根据RoleID排序规则，忽略其中一个。lpzhang
			 **/ 
			AuthPointField=getAuthPointField2(sObjectNo,sObjectType,sFlowNo,Sqlca);//信用共同体及联保取得需要授权判断的字段
			sFieldKey =AuthPointField.trim().split(",");
		    dFieldValue = new double[sFieldKey.length];
		    
		    String SqlStr0="", SqlStr="",sAssessLevel="";
		    int iCount=0;
		    /*取得信用评级*/
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
		    
		    if("1150020".indexOf((String)oBusiness.getAttribute("BusinessType"))>-1)//联保
		    {
		    	sAssessLevel = sAssessLevel+"001";
		    }
		    if("3060".indexOf((String)oBusiness.getAttribute("BusinessType")) < 0)//信用共同体额度
		    {
		    	SqlStr0 = " and  Attribute1 = '"+sAssessLevel+"'  " ;
		    }
		    /*取得共同体类型*/
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
					
					if(sFieldKey[j].equals("AuthSum2"))//个人一般新增授权金额
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						if("065".equals(sOccurType)){//新增续作
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "【个人(新增续作)授权】该客户非本笔关联业务累积的余额+申请金额超过角色授权！";
								icount++;
							}	
						}else{
							if(dTotalBalance1+dBusinessSum>dFieldValue[j]){
								sMessage = "【个人一般新增授权】该客户单产品累积的余额+申请金额超过角色授权！";
								icount++;
							}
						}
						if("065".equals(sOccurType)){
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}else{
							CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
						}
					}
					if(sFieldKey[j].equals("AuthSum3"))//个人一般存量授权金额
					{
						dTotalBalance1 = getSum1();
						String sOccurType = (String) oBusiness.getAttribute("OccurType");
						if("060".equals(sOccurType)){
							if(dTotalBalance1+dBusinessSum>dFieldValue[j] || dFieldValue[j]<=0){
								sMessage = "【个人一般存量(还旧借新)授权】该客户非本笔关联业务累积的余额+申请金额超过角色授权！";
								icount++;
							}	
						}else if("020".equals(sOccurType)){
							if((dTotalBalance1+0>dFieldValue[j]) || dFieldValue[j]<=0){
								sMessage = "【个人一般存量(借新还旧)授权】该客户单产品累积的余额(不含申请金额)+关联其他客户业务余额超过角色授权！";
								icount++;							}
						}else if((dTotalBalance1+dBusinessSum>dFieldValue[j]) || dFieldValue[j]<=0){
							sMessage = "【个人一般存量(非还旧借新还旧借新)授权】该客户单产品累积的余额+申请金额超过角色授权！";
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
					
					if(sFieldKey[j].equals("AuthSum4"))//个人低风险授权金额
					{
						dTotalBalance1 = getSum2();
						if(dBusinessSum+dTotalBalance1>dFieldValue[j])
						{
							sMessage = "【个人低风险授权】该客户申请金额超+该客户所有低风险业务余额过角色的授权！";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
					if(sFieldKey[j].equals("AuthSum5"))//扩盘重组
					{
						dTotalBalance1 = getSum1();
						if((dTotalBalance1+dBusinessSum>dFieldValue[j]) || dFieldValue[j]<=0){
							//sMessage = "【个人扩盘重组授权】该客户累积的余额(不含申请金额)超过角色授权！";
							sMessage = "【个人扩盘重组授权】该客户非本笔关联业务累积的余额+申请金额超过角色授权！";
							icount++;
						}
						CheckLog(sMessage,dTotalBalance1,dBusinessSum,dFieldValue[j],sFieldKey[j]);
					}
					
				}
			}
		}
		else
		{
			sMessage = "未进行授权配置！";
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
			
			oBusiness.setAttribute("SerialNo",SerialNo); //申请编号
			oBusiness.setAttribute("BusinessType",BusinessType); //业务品种
			oBusiness.setAttribute("OccurType",OccurType); //发生方式
			oBusiness.setAttribute("CustomerID",CustomerID); //客户编号
			oBusiness.setAttribute("CustomerType",CustomerType); //客户类型
			oBusiness.setAttribute("ApplyType",ApplyType); //申请类型
			oBusiness.setAttribute("CreditAggreement",CreditAggreement); //申请协议号 
			oBusiness.setAttribute("BusinessCurrency",BusinessCurrency); //业务币种
			//发生方式为展期
			if(OccurType.equals("015"))
			{
				oBusiness.setAttribute("BusinessSum",String.valueOf(0)); //授信金额
			}else
			{
				oBusiness.setAttribute("BusinessSum",String.valueOf(rs.getDouble("BusinessSum1"))); //授信金额
			}
			oBusiness.setAttribute("TermMonth",String.valueOf(rs.getDouble("TermMonth"))); //期限
			oBusiness.setAttribute("LowRisk",LowRisk); //是否低风险
			oBusiness.setAttribute("NationRisk",NationRisk); //国际业务部认定为低风险
			oBusiness.setAttribute("CycleFlag",CycleFlag); //是否循环贷款
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
	
	//change by zwhu 20100702 将客户累计授权金额由（单笔余额+综合授信额度） 改为（单笔余额+综合授信额度项下业务余额）
	public void initCustomerMemory(String sObjectNo,String sUserID,String sOrgID,Transaction Sqlca) throws Exception
	{
		sSql = " Select SerialNo,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,BusinessCurrency,BailSum,BailRatio," +
			   " BusinessType,nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate) as Balance,VouchType,CustomerID,Maturity,LowRisk,NationRisk " +
			   " from Business_Contract BC Where ((CustomerID = '"+(String)oBusiness.getAttribute("CustomerID")+"'" +
			   " and ApplyType = 'IndependentApply' and (FinishDate is null or FinishDate ='')) " +
			   " or (CustomerID = '"+(String)oBusiness.getAttribute("CustomerID")+"'" +
			   " and ApplyType = 'DependentApply' and (FinishDate is null or FinishDate =''))) "+
			   " and OccurType<>'015' ";//不为展期
			   
//			   " or (('"+CurDate+"' < Maturity  or Maturity is null or Maturity ='') and CustomerID = '"+(String)oBusiness.getAttribute("CustomerID")+"'" +
//			   " and (FinishDate is null or FinishDate ='') and ApplyType = 'CreditLineApply') ";
		//信用共同体额度
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
		if("020".equals((String)oBusiness.getAttribute("OccurType"))){//借新还旧关联业务
			sSql += " or BC.SerialNo  in (select RelativeSerialNo2 from Business_Duebill where SerialNo in ( "+
			" select ObjectNo from Apply_Relative where ObjectType = 'BusinessDueBill' and SerialNo  = '"+
			(String)oBusiness.getAttribute("SerialNo")+"') and CustomerID!='"+(String)oBusiness.getAttribute("CustomerID")+"')";
		}else if("060".equals((String)oBusiness.getAttribute("OccurType"))){//还旧借新
			sSql += " and BC.SerialNo not in (select RelativeSerialNo2 from Business_Duebill where SerialNo in ( "+
					" select ObjectNo from Apply_Relative where ObjectType = 'BusinessDueBill' and SerialNo  = '"+
					(String)oBusiness.getAttribute("SerialNo")+"'))";
		}else if("065".equals((String)oBusiness.getAttribute("OccurType"))){//新增续作
			sSql += " and BC.SerialNo not in (select RelativeSerialNo2 from Business_Duebill where SerialNo in ( "+
			" select ObjectNo from Apply_Relative where ObjectType = 'BusinessDueBill' and SerialNo  = '"+
			(String)oBusiness.getAttribute("SerialNo")+"'))";
		}else if("030".equals((String)oBusiness.getAttribute("OccurType"))){//扩盘重组
			sSql += " and BC.SerialNo  not in (select ObjectNo from REFORM_RELATIVE where ObjectType='BusinessContract' "+
			" and SerialNo=(select ObjectNo from APPLY_RELATIVE where ObjectType='CapitalReform' and SerialNo='"+
			(String)oBusiness.getAttribute("SerialNo")+"') and "+
			" exists(select 1 from BUSINESS_CONTRACT where SerialNo=REFORM_RELATIVE.ObjectNo "+
			" and CustomerID='"+(String)oBusiness.getAttribute("CustomerID")+"'))";
		}
	   cd = new CreditData(Sqlca,sSql);
	}
	
	/** 该客户所有一般风险业务余额
	 */
	public double getSum1() throws Exception
	{
		return cd.getSum("Balance","LowRisk",Tools.S1,"1");
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
	
	/** 该客户所有余额
	 */
	public double getSum4() throws Exception
	{
		return cd.getSum("Balance","SerialNo",Tools.ISNOTNULL,"");
	}
	
	/**
	 * 公司业务授权权限字段判定
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
		if(NationRisk.equals("1")){//国际业务部认定低风险优先
			LowRisk="1";
		}
		
		//判断是否为微小企业SmallEntFlag
		sSql = "select SmallEntFlag,SetupDate from ENT_INFO where  CustomerID ='"+CustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sSmallEntFlag = rs.getString("SmallEntFlag");
			if(sSmallEntFlag == null ) sSmallEntFlag ="";
		}
		rs.getStatement().close();
		//取得重组方式标识
		if(OccurType.equals("030"))// 资产重组
		{
			ReCreditFlag = Sqlca.getString("select ApplyType from APPLY_RELATIVE AR,REFORM_INFO RI where AR.ObjectNo = RI.SerialNo and AR.SerialNo ='"+this.sObjectNo+"'");
			if(ReCreditFlag == null) ReCreditFlag ="";
		}
		//取出授权判断字段
		if(ReCreditFlag.equals("02")){//扩盘重组
			AuthPointField = "AuthSum5";
		}else if(ReCreditFlag.equals("01")){ //一般重组
			AuthPointField = "AuthSum2";
		}else if("1".equals(sSmallEntFlag)){ //微小企业
			AuthPointField = "AuthSum1";
		}else if("1".equals(LowRisk)){ //低风险授权
			AuthPointField = "AuthSum4";
		}else if(OccurType.equals("010")||OccurType.equals("065")){ //新增业务||新增续作
			AuthPointField = "AuthSum2";
		}else{    //存量业务
			AuthPointField = "AuthSum3";
		}
		
		return AuthPointField;
	}
	/**
	 * 个人业务授权权限字段判定
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
		//复审相关信息:原申请流水号,原发生类型,原重组标识,原低风险标识
		String sReObjectNo="",sReOccurType="",sReLowRisk="";
		//取得复审关联原业务信息
		if(OccurType.equals("090"))// 复审
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
			//取得重组方式标识
			if(sReOccurType.equals("030"))// 资产重组
			{
				ReCreditFlag = Sqlca.getString("select ApplyType from APPLY_RELATIVE AR,REFORM_INFO RI where AR.ObjectNo = RI.SerialNo and AR.SerialNo ='"+sReObjectNo+"'");
				if(ReCreditFlag == null) ReCreditFlag ="";
			}
	
			//取出授权判断字段
			if(ReCreditFlag.equals("02")){//扩盘重组
				AuthPointField = "AuthSum5";
			}else if("1".equals(sReLowRisk)){ //低风险授权
				AuthPointField = "AuthSum4";
			}else if(sReOccurType.equals("010")){ //新增业务
				AuthPointField = "AuthSum2";
			}else{    //存量业务
				AuthPointField = "AuthSum3";
			}
		}else{
			//取得重组方式标识
			if(OccurType.equals("030"))// 资产重组
			{
				ReCreditFlag = Sqlca.getString("select ApplyType from APPLY_RELATIVE AR,REFORM_INFO RI where AR.ObjectNo = RI.SerialNo and AR.SerialNo ='"+this.sObjectNo+"'");
				if(ReCreditFlag == null) ReCreditFlag ="";
			}
	
			//取出授权判断字段
			if(ReCreditFlag.equals("02")){//扩盘重组
				AuthPointField = "AuthSum5";
			}else if("1".equals(LowRisk)){ //低风险授权
				AuthPointField = "AuthSum4";
			}else if(OccurType.equals("010")||OccurType.equals("065")){ //新增业务
				AuthPointField = "AuthSum2";
			}else{    //存量业务
				AuthPointField = "AuthSum3";
			}
		}
		return AuthPointField;
	}
	
	
	//记录未通过授权的原因日志
	public void CheckLog(String sReason,double dTotalBalance,double dBusinessSum,double dAuthSum,String sAuthItem) throws Exception{
		
		Sqlca.executeSQL(" insert into Authorization_Check_Log(ApplySerialNo,TaskNo,Reason,UserID,FlowNo,TotalBalance,BusinessSum,AuthSum,AuthItem) " +
						 " values('"+sObjectNo+"','"+sTaskSerialNo+"','"+sReason+"','"+sUserID+"','"+sFlowNo+"',"+dTotalBalance+","+dBusinessSum+","+dAuthSum+",'"+sAuthItem+"')");
		
	}
	
	
}
