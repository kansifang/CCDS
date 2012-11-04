/*
Author:   bwang
Tester:
Describe: 信用等级认定后需要对信用等级记录进行更新
Input Param:
		ObjectNo: 对象编号
		sObjectType:对象类型
Output Param:
HistoryLog: lpzhang 2009-8-27 公司信用等级放在业务申请一起审批
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishEvaluate extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//对象编号
		String sObjectNo = (String)this.getAttribute("sObjectNo");
		String sObjectType = (String)this.getAttribute("sObjectType");
		String sBASerialNo = (String)this.getAttribute("BASerialNo");//与业务一起审批的信用等级
		//add by hldu 2012/10/16
		String[] EvaluateSerialNos = sObjectNo.split("@");	
		sObjectNo = EvaluateSerialNos[0];
		String sNewObjectNo = EvaluateSerialNos[1];
		//add end
		
		//将空值转换为字符串
		if(sBASerialNo==null) sBASerialNo="";
		String sFOSerialNo ="";//最后的意见流水编号
		double dUserScore=0;//人工认定分数
		String sUserResult="";//人工认定结果
		String sCognReason="";//人工认定理由
		String sInputTime="";//人工认定日期
		String sInputUser="";//人工认定人
		String sInputOrg="";//人工认定机构
		String sCustomerID="";//客户ID
		String sCustomerType="";//客户类型
		double dNewUserScore=0;//并行人工认定分数
		String sNewUserResult="";//并行人工认定结果
		String sIsInuse = ""; //是否停用并行客户信用等级评估		

		String sSql = "";
		ASResultSet rs=null;
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sNewObjectNo == null || sNewObjectNo.equals("null")) sNewObjectNo = "";
		//取是否停用并行信用等级评估 add by hldu
		sIsInuse = Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
		if (sIsInuse== null) sIsInuse="" ;
		//add end
		//查询认定完成后，最终认定人的审批流程任务编号
		if("".equals(sBASerialNo))
		{
			sSql = 	" select MAX(OpinionNo) as OpinionNo from Flow_Opinion"+
					" where ObjectType='"+sObjectType+"'"+
					" and ObjectNo='"+sObjectNo+"'";
		}else
		{
			sSql = 	" select MAX(OpinionNo) as OpinionNo from Flow_Opinion"+
					" where ObjectType='"+sObjectType+"'"+
					" and ObjectNo='"+sBASerialNo+"'";
		}
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			sFOSerialNo=rs.getString("OpinionNo");
		}
		if(sFOSerialNo==null)sFOSerialNo="";
		rs.getStatement().close();

		//取最终认定人意见
		sSql = 	" select CognScore as CognScore,CognResult as CognResult,"+//人工分数，结果
		" NewCognScore,NewCognResult,"+//并行客户信用等级评估分数，结果  add by hldu
		" InputTime,InputUser,InputOrg,"+//人工认定日期,认定人 ，认定机构
		" PhaseOpinion as CognReason"+
		" from Flow_Opinion"+
		" where OpinionNo='"+sFOSerialNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			dUserScore =rs.getDouble("CognScore");//人工认定分数
			sUserResult=rs.getString("CognResult");//人工认定结果
			sCognReason=rs.getString("CognReason");//人工认定理由
			sInputTime =rs.getString("InputTime");//人工认定日期
			sInputUser =rs.getString("InputUser");//人工认定人
			sInputOrg  =rs.getString("InputOrg");//人工认定机构
			dNewUserScore =rs.getDouble("NewCognScore");//人工认定分数(新模型) add by hldu
			sNewUserResult=rs.getString("NewCognResult");//人工认定结果(新模型)add by hldu
		}
		if(sNewUserResult==null)sNewUserResult=""; // add by hldu
		if(sUserResult==null)sUserResult="";
		if(sCognReason==null)sCognReason="";
		if(sInputTime==null)sInputTime="";
		if(sInputUser==null)sInputUser="";
		if(sInputOrg==null)sInputOrg="";
		rs.getStatement().close();
		
		//add by xhyong 2009/08/25 将信用等级评估结果更新到客户信息里
		//取得客户相关信息
		sSql = 	" select CI.CustomerID as CustomerID,CI.CustomerType as CustomerType " +
				"from EVALUATE_RECORD ER,CUSTOMER_INFO CI "+
				" where ER.ObjectNO=CI.CustomerID " +
				" and ObjectType='Customer'"+
				" and ER.SerialNo='"+sObjectNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			sCustomerID=rs.getString("CustomerID");
			sCustomerType=rs.getString("CustomerType");
		}
		rs.getStatement().close();
		
		//根据客户类型选择更新客户即期信用等级评估结果
		if(sCustomerType.substring(0,2).equals("01"))//公司客户
		{
			Sqlca.executeSQL("UPDATE ENT_INFO SET CreditLevel='"+sUserResult+"',NewCreditLevel='"+sNewUserResult+"',EvaluateDate='"+StringFunction.getToday()+"' where CustomerID= '"+sCustomerID+"'");// change by hldu
		}
		else if(sCustomerType.substring(0,2).equals("03"))//个人客户
		{
			Sqlca.executeSQL("UPDATE IND_INFO SET CreditLevel='"+sUserResult+"',NewCreditLevel='"+sNewUserResult+"',EvaluateDate='"+StringFunction.getToday()+"' where CustomerID= '"+sCustomerID+"'");// change by hldu
		}
		//add end
		//add by hldu
		//更新最终审批人工认定结果更新BA.BASEEVALUATERESULT下,<统计查询使用>
		sSql = " update Business_apply set BASEEVALUATERESULT = '"+sUserResult+"' where serialno = '"+sBASerialNo+"' ";
		Sqlca.executeSQL(sSql);
		//add end
		
		//更新信用等级记录表
		sSql=" UPDATE EVALUATE_RECORD SET CognDate='"+sInputTime+"',"+
		" CognScore="+dUserScore+",CognResult='"+sUserResult+"',"+
		" CognReason='"+sCognReason+"',"+
		" FinishDate='"+sInputTime+"',"+
		" CognOrgID='"+sInputOrg+"',CognUserID='"+sInputUser+"'"+
		" WHERE SerialNo='"+sObjectNo+"' AND ObjectType='Customer'";// change by hldu 修改ObjectType='"+sObjectType+"'
		Sqlca.executeSQL(sSql);
		//更新信用等级记录标中“评估状态”,当前用于业务审批的信用评级记录状态更新为‘1’-有效，该客户其他
		sSql=" UPDATE EVALUATE_RECORD SET EvaluateYesNo = case "+
			 " when SerialNo = '"+sObjectNo+"' then '1' "+
			 " when SerialNo <> '"+sObjectNo+"' AND  EvaluateYesNo = '1' then '2'"+
			 " else EvaluateYesNo end where ObjectNo = '"+sCustomerID+"' AND ObjectType='Customer' ";
		Sqlca.executeSQL(sSql);
		//add by hldu 2012/10/16
		if(sIsInuse.equals("2"))
		{
			sSql=" UPDATE EVALUATE_RECORD SET CognDate='"+sInputTime+"',"+
			" CognScore="+dNewUserScore+",CognResult='"+sNewUserResult+"',"+
			" CognReason='"+sCognReason+"',"+
			" FinishDate='"+sInputTime+"',"+
			" CognOrgID='"+sInputOrg+"',CognUserID='"+sInputUser+"'"+
			" WHERE SerialNo='"+sNewObjectNo+"' AND ObjectType='NewEvaluate'";
			Sqlca.executeSQL(sSql);
			//更新信用等级记录标中“评估状态”,当前用于业务审批的信用评级记录状态更新为‘1’-有效，该客户其他
			sSql=" UPDATE EVALUATE_RECORD SET EvaluateYesNo = case "+
				 " when SerialNo = '"+sNewObjectNo+"' then '1' "+
				 " when SerialNo <> '"+sNewObjectNo+"' AND EvaluateYesNo = '1' then '2'"+
				 " else EvaluateYesNo end where ObjectNo = '"+sCustomerID+"' AND ObjectType='NewEvaluate' ";
			Sqlca.executeSQL(sSql);
		}
		//add end

		return "1";

	}

}

