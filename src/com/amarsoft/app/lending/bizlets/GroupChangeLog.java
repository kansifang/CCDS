package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
//import com.amarsoft.are.sql.Transaction;
/**
 * @author mfhu 
 *
 */
public class GroupChangeLog {
	/**
	 * @param sGroupNo,sCustomerID,sOperateFlag,sUserID,sOrgID,sInputDate
	 * @param 集团代码，客户代码，变动类型，原客户名称，变动日期，操作机构，操作人员，事务
	 *
	 */
	public void AddChangeLog(String sGroupNo,String sCustomerID,String sOperateFlag,String sOldName,String sInputDate,String sOrgID,String sUserID,String sCustomerName,String sCorp,Transaction Sqlca) throws Exception
	{
		//生成流水号
		try{

			String sSerialNo = DBFunction.getSerialNo("GROUP_CHANGE","SerialNo","",Sqlca);
			
			String sSql="";
			
			sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
				   " values('"+sSerialNo+"','"+sGroupNo+"','"+sCustomerID+"','"+sOperateFlag+"','"+sOldName+"','"+sInputDate+"','"+sOrgID+"','"+sUserID+"','"+sCustomerName+"','"+sCorp+"')";
			Sqlca.executeSQL(sSql);
		}catch (Exception e)
		{			
			throw new Exception("AddChangeLog"+e.toString());			
		}
	
	}
	/**
	 *@param sGroupNo,sCustomerID,sOperateFlag 
	 * 删除集团下某个成员某种操作标志的变动记录
	 *
	 */
	public void DelChangeLog(String sGroupNo,String sCustomerID,String sOperateFlag,Transaction Sqlca)throws Exception
	{
		try{
			Sqlca.executeSQL("delete from GROUP_CHANGE where GroupNo='"+sGroupNo+"' and CustomerID='"+sCustomerID+"' and ChangeType='"+sOperateFlag+"'");
		}catch (Exception e)
		{
			throw new Exception("DelChangeLog"+e.toString());			
		}
	}
	
	/**
	 * @param sGroupNo,sCustomerID
	 * 删除集团下某个成员的变动记录
	 */
	
	public void DelChangeLog(String sGroupNo,String sCustomerID,Transaction Sqlca)throws Exception
	{
		try{
			Sqlca.executeSQL("delete from GROUP_CHANGE where GroupNo='"+sGroupNo+"' and CustomerID='"+sCustomerID+"' ");
		}catch (Exception e)
		{
			throw new Exception("DelChangeLog"+e.toString());
		}
	}
	/**
	 *@param  sAggregateNo
	 * 删除集团的所有更改记录
	 * 
	 * 
	 */	  
	public void DelChangeLog(String sGroupNo,Transaction Sqlca){

		 try{
		
			Sqlca.executeSQL("delete from GROUP_CHANGE where GroupNo='"+sGroupNo+"'");
		 }catch (Exception e)
		 {
			System.out.println("DelChangeLog"+e.toString());
		 }
	
	}
	
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
