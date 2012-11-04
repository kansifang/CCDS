/*
Author:   xhyong 2009/08/24
Tester:
Describe: 风险分类认定以后对相关信息进行更新
Input Param:
		SerialNo: 流程流水号
		ObjectNo: 对象编号
		sObjectType:对象类型
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishClassify extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//获取参数
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		
		//将空值转化成空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		//定义变量
		String sFOSerialNo = "";//最终认定人的审批流程任务编号
		String sFinallyResult = "";//人工认定结果
		String sBaseClassifyResult = "";//人工认定结果(实际)
		String sClassifyUserID = "";//人工认定人
		String sClassifyOrgID = "";//人工认定机构
		String sContractNo = "";//合同流水号
		String sBCClassifyResult = "";//合同分类结果
		String sCustomerID = "";//客户编号
		String sCustomerType = "";//客户类型
		int iCount = 0;//复合条件的记录条数
		double dBusinessBalance = 0.00;//合同余额
		double dSUM1=0.00,dSUM2=0.00,dSUM3=0.00,dSUM4=0.00,dSUM5=0.00;
		//定义数据集
		String sSql = "";
		ASResultSet rs=null;
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		//查询认定完成后，最终认定人的审批流程任务编号
		sSql = 	" select MAX(OpinionNo) as OpinionNo from Flow_Opinion"+
		" where ObjectType='"+sObjectType+"'"+
		" and ObjectNo='"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			sFOSerialNo=rs.getString("OpinionNo");
		}
		if(sFOSerialNo==null)sFOSerialNo="";
		rs.getStatement().close();

		//取最终认定人意见
		sSql = 	" select PhaseOpinion1 as FinallyResult,"+//人工分数，结果
		" PhaseOpinion5 as BaseClassifyResult,"+//人工认定结果(实际)
		" InputUser,InputOrg,"+//认定人 ，认定机构
		" PhaseOpinion as CognReason"+
		" from Flow_Opinion"+
		" where OpinionNo='"+sFOSerialNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			sFinallyResult =rs.getString("FinallyResult");//人工认定结果
			sBaseClassifyResult =rs.getString("BaseClassifyResult");//人工认定结果(实际)
			sClassifyUserID =rs.getString("InputUser");//人工认定人
			sClassifyOrgID  =rs.getString("InputOrg");//人工认定机构
		}
		if(sFinallyResult==null)sFinallyResult="";
		if(sClassifyUserID==null)sClassifyUserID="";
		if(sClassifyOrgID==null)sClassifyOrgID="";
		rs.getStatement().close();
		
		//查询合同余额
		sSql = 	" select BC.SerialNo as ContractNo,nvl(BC.Balance,0) as Balance,BC.ClassifyResult "+
		"from Classify_Record CR,Business_Contract BC "+
		" where BC.SerialNo=CR.ObjectNo and " +
		" CR.ObjectType='BusinessContract' "+
		" and CR.SerialNo='"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			sContractNo=rs.getString("ContractNo");//合同流水号
			dBusinessBalance=rs.getDouble("Balance");//合同余额
			sBCClassifyResult=rs.getString("ClassifyResult");//合同分类结果
		}
		rs.getStatement().close();
		//针对分类结果为空的
		if("".equals(sFinallyResult))
		{
			sFinallyResult=sBCClassifyResult;
		}
		//更新合同中的风险分类结果
		sSql=" UPDATE BUSINESS_CONTRACT SET ClassifyResult='"+sFinallyResult+"', "+
			" BaseClassifyResult='"+sBaseClassifyResult+"' "+
			" WHERE SerialNo='"+sContractNo+"'";
		Sqlca.executeSQL(sSql);
			
		//更新借据中的风险分类结果
		sSql=" UPDATE BUSINESS_DUEBILL SET ClassifyResult='"+sFinallyResult+"' "+
			" WHERE RelativeSerialNo2='"+sContractNo+"'";
		Sqlca.executeSQL(sSql);
			
		//更新风险分类记录相关信息
		if(sFinallyResult.substring(0,2).equals("01"))
			dSUM1=dBusinessBalance;
		if(sFinallyResult.substring(0,2).equals("02"))
			dSUM2=dBusinessBalance;
		if(sFinallyResult.substring(0,2).equals("03"))
			dSUM3=dBusinessBalance;
		if(sFinallyResult.substring(0,2).equals("04"))
			dSUM4=dBusinessBalance;
		if(sFinallyResult.substring(0,2).equals("05"))
			dSUM5=dBusinessBalance;
	
		sSql=" UPDATE CLASSIFY_RECORD SET FinallyResult='"+sFinallyResult+"', " +
			" FinallyBaseResult='"+sBaseClassifyResult+"',"+
			" SUM1="+dSUM1+",SUM2="+dSUM2+",SUM3="+dSUM3+",SUM4="+dSUM4+",SUM5="+dSUM5+", "+
			" BusinessBalance="+dBusinessBalance+",FinishDate='"+StringFunction.getToday()+"', "+
			" ClassifyUserID='"+sClassifyUserID+"',ClassifyOrgID='"+sClassifyOrgID+"' "+
			" WHERE SerialNo='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
		//add by hldu 2012/10/16
		//取该客户编号
		sSql = " select CustomerID ,getCustomerType(CustomerID) as CustomerType from Business_Contract where serialno = '"+sContractNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sCustomerID = rs.getString("CustomerID");
			if(sCustomerID == null) sCustomerID = "";
			sCustomerType = rs.getString("CustomerType");
			if(sCustomerType == null) sCustomerType = "";
		}
		rs.getStatement().close();
		//如果该客户有风险分类为次级、可疑、损失、次级1、次级2的记录时，更新客户信息中 本行即期信用等级为D
		iCount = DataConvert.toInt(Sqlca.getString(" select count(*) from CLASSIFY_RECORD where ObjectNo in "+
				                                   "(select serialno from Business_Contract where CustomerID = '"+sCustomerID+"' ) and (finallyresult like '03%' or   finallyresult like '04%'  or  finallyresult like '05%') "));
		if(iCount > 0)
		{
			if(sCustomerType.substring(0, 2).equals("01"))
			{
				Sqlca.executeSQL(" update Ent_Info set CreditLevel = 'D' where CustomerID = '"+sCustomerID+"' ");
			}else
			{
				Sqlca.executeSQL(" update Ind_Info set CreditLevel = 'D' where CustomerID = '"+sCustomerID+"' ");
			}
		}
		//add end 
		return "1";

	}

}

