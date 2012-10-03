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
	 * @param ���Ŵ��룬�ͻ����룬�䶯���ͣ�ԭ�ͻ����ƣ��䶯���ڣ�����������������Ա������
	 *
	 */
	public void AddChangeLog(String sGroupNo,String sCustomerID,String sOperateFlag,String sOldName,String sInputDate,String sOrgID,String sUserID,String sCustomerName,String sCorp,Transaction Sqlca) throws Exception
	{
		//������ˮ��
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
	 * ɾ��������ĳ����Աĳ�ֲ�����־�ı䶯��¼
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
	 * ɾ��������ĳ����Ա�ı䶯��¼
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
	 * ɾ�����ŵ����и��ļ�¼
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
