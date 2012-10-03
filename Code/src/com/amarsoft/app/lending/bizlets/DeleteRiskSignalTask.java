package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong 2011/03/17
Tester:
Describe: --删除预警信号;
Input Param:
		ObjectType: --对象类型(申请类型)
		ObjectNo:--预警流水号
		DeleteType：删除类型
Output Param:
		return：返回值（1 --删除成功）

HistoryLog:
*/
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteRiskSignalTask extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//自动获得传入的参数值		
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sDeleteType = (String)this.getAttribute("DeleteType");
		//将空值转化成空字符串		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sDeleteType == null) sDeleteType = "";
		//定义变量:sql,预警类型 01 发起 02 解除
		String sSql = "",sSignalType = "";
		ASResultSet rs = null;
		//删除任务
		if(sDeleteType.equals("DeleteTask"))
		{
			//删除预警信号申请信息
			if(sObjectType.equals("RiskSignalApply"))
			{
				//查询预警基本信息
				sSql = " select SignalType from RISK_SIGNAL where SerialNo = '"+sObjectNo+"' ";
				rs = Sqlca.getASResultSet(sSql);
				if (rs.next()) { 
					sSignalType=rs.getString("SignalType");
				}
				rs.getStatement().close();
				if("01".equals(sSignalType))
				{
					//删除预警申请信息
					sSql = " delete from Customer_RiskSignal " +
							"where SerialNo in(select ObjectNo from RISKSIGNAL_RELATIVE " +
							"where ObjectType='RiskSignal' and SerialNo='"+sObjectNo+"') ";
					Sqlca.executeSQL(sSql);
				}
				//删除预警申请信息
				sSql = " delete from RISK_SIGNAL where SerialNo = '"+sObjectNo+"' ";
				Sqlca.executeSQL(sSql);
				//删除预警关联信息
				sSql = " delete from RISKSIGNAL_RELATIVE where ObjectType='RiskSignal' and SerialNo = '"+sObjectNo+"' ";
				Sqlca.executeSQL(sSql);
				//删除预警申请信息
				sSql = " delete from RISK_SIGNAL where SerialNo = '"+sObjectNo+"' ";
				Sqlca.executeSQL(sSql);
				//删除预警申请信息
				sSql = " delete from RISK_SIGNAL where SerialNo = '"+sObjectNo+"' ";
				Sqlca.executeSQL(sSql);
				
				//删除意见信息表		
				deleteTableData("Flow_OPINION",sObjectType,sObjectNo,Sqlca);
				//删除流程对象信息				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//删除流程任务信息
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
 
			}

		}

		return "1";
	}
	private void deleteCreditCognTableData(String sTableName,String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception
	{
		String sSql = "";
		sSql = " delete from "+sTableName+" where ObjectType = '"+sObjectType+"' "+
		" and serialno = '"+sObjectNo+"' ";
		//执行删除语句
		Sqlca.executeSQL(sSql); 
	}
	//删除有ObjectType,ObjectNo作为外键的表
	private void deleteTableData(String sTableName,String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		sSql = " delete from "+sTableName+" where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"' ";
		//执行删除语句
		Sqlca.executeSQL(sSql); 
	}


}
