/*
		Author: --zywei 2005-12-16
		Tester:
		Describe: --实现表到表的字段复制
		Input Param:
				
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateGuarantyChangeInfo extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值
		String sSerialNo = (String)this.getAttribute("SerialNo");
		if(sSerialNo == null) sSerialNo = "";
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		if(sGuarantyID == null) sGuarantyID = "";
		String sChangeType   = (String)this.getAttribute("ChangeType");
		if(sChangeType == null) sChangeType = "";
				
		String sUpdateSql = "";
		if(sSerialNo.equals(""))
		{
			String sSql = 	" select SerialNo from GUARANTY_CHANGE "+
							" where GuarantyID='"+sGuarantyID+"' "+
							" and ChangeType='"+sChangeType+"' "+
							" order by SerialNo desc ";
			ASResultSet rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				sSerialNo = rs.getString("SerialNo");
			rs.getStatement().close();
		}
			
		String sSql = 	" select NewEvalOrgID,NewEvalOrgName,NewEvalNetValue,NewConfirmValue,NewOwnerID,NewOwnerName"+
						" from GUARANTY_CHANGE "+
						" where SerialNo = '"+sSerialNo+"' ";		
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			if(rs.getString("NewEvalOrgID") != null && !rs.getString("NewEvalOrgID").equals(""))
				sUpdateSql += ",EvalOrgID='" + rs.getString("NewEvalOrgID")+"'";
			if(rs.getString("NewEvalOrgName") != null && !rs.getString("NewEvalOrgName").equals(""))	
				sUpdateSql += ",EvalOrgName='" + rs.getString("NewEvalOrgName")+"'";
			if(rs.getString("NewEvalNetValue") != null && !rs.getString("NewEvalNetValue").equals(""))	
				sUpdateSql += ",EvalNetValue=" + rs.getDouble("NewEvalNetValue")+"";
			if(rs.getString("NewConfirmValue") != null && !rs.getString("NewConfirmValue").equals(""))
				sUpdateSql += ",ConfirmValue=" + rs.getDouble("NewConfirmValue")+"";
			if(rs.getString("NewOwnerID") != null && !rs.getString("NewOwnerID").equals(""))
				sUpdateSql += ",OwnerID='" + rs.getString("NewOwnerID")+"'";
			if(rs.getString("NewOwnerName") != null && !rs.getString("NewOwnerName").equals(""))
				sUpdateSql += ",OwnerName='" + rs.getString("NewOwnerName")+"'";
			
			if(!sUpdateSql.equals("")){
				String sUpdateSql1 = " update GUARANTY_INFO set "+sUpdateSql.substring(1)+" where GuarantyID='"+sGuarantyID+"' ";
				Sqlca.executeSQL(sUpdateSql1);
			}
		}
		rs.getStatement().close();
		return "1";
	 }

}
