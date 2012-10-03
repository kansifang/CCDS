/*
		Author: --xhyong 2012/08/23
		Tester:
		Describe: --探测申请风险
		Input Param:
				ObjectType: 对象类型
				ObjectNo: 对象编号
		Output Param:
				Message：风险提示信息
		HistoryLog: 
*/

package com.amarsoft.app.lending.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;



public class CheckBusinessRisk extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//System.out.println("sMiddleYear:"+sMiddleYear); 
		 
		//定义变量：提示信息、SQL语句、产品类型、客户类型
		String sMessage = "",sSql = "",sBusinessType = "";
		//定义变量：主要担保方式、客户代码、主体表名、关联表名
		String sCustomerID = "",sMainTable = "",sRelativeTable = "";
		
		//定义变量：发生类型、申请类型、担保人代码、变更类型
		String sOccurType = "";
		//定义变量：查询结果集
		ASResultSet rs = null;	
		
		if("CreditApply".equals(sObjectType))
		{
			//从相应的对象主体表中获取金额、产品类型、票据张数、担保类型
			sSql = 	" select CustomerID,BusinessType,OccurType from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) {
				sBusinessType = rs.getString("BusinessType");
				sCustomerID = rs.getString("CustomerID");
				sOccurType = rs.getString("OccurType");
				//将空值转化成空字符串
				if (sBusinessType == null) sBusinessType = "";
				if (sCustomerID == null) sCustomerID = "";	
				if (sOccurType == null) sOccurType = "";
			}
			rs.getStatement().close();
			//------------单一客户的新增贷款不能高于资本金的10％--------------
			if(sBusinessType.startsWith("1"))
			{
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =  interpreter.explain(Sqlca,"!审批流程.是否超资本金("+sObjectNo+","+sObjectType+",2)");
				String sReturn = aReturn.stringValue();
				if(sReturn.equals("TRUE"))
				{
					sMessage  += "该客户新增贷款+贷款余额超本行资本金10％！"+"@";
				}
		        
			}
		
			//--------------集团成员办理业务，集团授信总量+本次申请金额不能大于资本金15％---------------
			String JTCustomerID ="";
			sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
				   " and RelationShip like '04%' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				JTCustomerID = rs.getString("CustomerID");
				if(JTCustomerID == null) JTCustomerID ="";
			}
			rs.getStatement().close();
			if(!JTCustomerID.equals(""))
			{
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =  interpreter.explain(Sqlca,"!审批流程.是否超资本金("+sObjectNo+","+sObjectType+",4)");
				String sReturn = aReturn.stringValue();
				if(sReturn.equals("TRUE"))
				{
					sMessage  += "该笔贷款申请金额+集团授信总量不能大于本行资本金额15％！"+"@";
				}
			}
		}
		
		if("PutOutApply".equals(sObjectType))
		{
			//从相应的对象主体表中获取金额、产品类型、票据张数、担保类型
			sSql = 	" select BP.CustomerID,BP.BusinessType,BC.OccurType "+
			" from BUSINESS_CONTRACT BC,BUSINESS_PUTOUT BP "+
			" where BP.ContractSerialNo=BC.SerialNo "+
			" and BP.SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) {
				sBusinessType = rs.getString("BusinessType");
				sCustomerID = rs.getString("CustomerID");
				sOccurType = rs.getString("OccurType");
				//将空值转化成空字符串
				if (sBusinessType == null) sBusinessType = "";
				if (sCustomerID == null) sCustomerID = "";	
				if (sOccurType == null) sOccurType = "";
			}
			rs.getStatement().close();
			
			//------------单一客户的新增贷款不能高于资本金的10％--------------
			if(sBusinessType.startsWith("1"))
			{
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =  interpreter.explain(Sqlca,"!审批流程.是否超资本金("+sObjectNo+","+sObjectType+",2)");
				String sReturn = aReturn.stringValue();
				if(sReturn.equals("TRUE"))
				{
					sMessage  += "该客户新增贷款+贷款余额超本行资本金10％！"+"@";
				}
		        
			}
		
			//--------------集团成员办理业务，集团授信总量+本次申请金额不能大于资本金15％---------------
			String JTCustomerID ="";
			sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
				   " and RelationShip like '04%' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				JTCustomerID = rs.getString("CustomerID");
				if(JTCustomerID == null) JTCustomerID ="";
			}
			rs.getStatement().close();
			if(!JTCustomerID.equals(""))
			{
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =  interpreter.explain(Sqlca,"!审批流程.是否超资本金("+sObjectNo+","+sObjectType+",4)");
				String sReturn = aReturn.stringValue();
				if(sReturn.equals("TRUE"))
				{
					sMessage  += "该笔贷款申请金额+集团授信总量不能大于本行资本金额15％！"+"@";
				}
			}
		}
		
		return sMessage;
	 }
	

}
