package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong 2009/08/19
Tester:
Describe: --删除风险分类认定申请;
Input Param:
		ObjectType: --对象类型(申请类型)
		ObjectNo:--分类流水号
		DeleteType：删除类型
Output Param:
		return：返回值（1 --删除成功）

HistoryLog:
*/
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteClassifyTask extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//自动获得传入的参数值		
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sDeleteType = (String)this.getAttribute("DeleteType");
		
		//将空值转化成空字符串		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sDeleteType == null) sDeleteType = "";
		//删除任务
		if(sDeleteType.equals("DeleteTask"))
		{
			//删除风险分类认定申请信息2009-04-03
			if(sObjectType.equals("ClassifyApply"))
			{
				//删除风险分类明细信息
				deleteCreditCognTableData("Classify_Data","BusinessContract",sObjectNo,Sqlca);
				//删除风险分类信息
				deleteCreditCognTableData("Classify_Record","BusinessContract",sObjectNo,Sqlca);
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
