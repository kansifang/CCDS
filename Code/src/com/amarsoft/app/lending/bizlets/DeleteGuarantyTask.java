package com.amarsoft.app.lending.bizlets;
/*
Author: --wangdw 2012/08/07
Tester:
Describe: --删除抵质押物出入库申请信息;
Input Param:
		ObjectType: --对象类型(出入库申请类型)
		ObjectNo:--出入库流水号
		DeleteType：删除类型
Output Param:
		return：返回值（1 --删除成功）

HistoryLog:
*/
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteGuarantyTask extends Bizlet 
{
	private String sObjectTable = "";
	private String sRelativeTable = ""; 
	private String sRelativeNo = ""; 
	public Object  run(Transaction Sqlca) throws Exception
	{		
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
			//删除抵质押品出入库申请信息表  add by wangdw 2012-7-13
			if(sObjectType.equals("GuarantyOutApply")||sObjectType.equals("GuarantyInApply"))
			{
				deleteGuaranty_Apply(sObjectType,sObjectNo,Sqlca);
			}
		} 
		return "1";
	}
	//删除抵质押物出入库申请信息  add by  wangdw 2012-7-13
	private void deleteGuaranty_Apply(String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		sSql = " delete from Guaranty_Apply where ObjectType = '"+sObjectType+"' "+
		" and serialno = '"+sObjectNo+"' ";
		//执行删除语句
		Sqlca.executeSQL(sSql); 
	}
}
