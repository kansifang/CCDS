package com.lmt.baseapp.flow;

/***
 * added by bzhang 五级分类认定删除 2009.06.12
 */
import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.sql.Transaction;
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
			//删除五级分类认定申请信息
			if(sObjectType.equals("ClassifyApply"))
			{
				//删除评估模型信息 （晋商没有）
				deleteCreditCognTableData("Classify_Data",sObjectType,sObjectNo,Sqlca);
				//删除五级分类信息信息
				deleteCreditCognTableData("Classify_Record",sObjectType,sObjectNo,Sqlca);
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

