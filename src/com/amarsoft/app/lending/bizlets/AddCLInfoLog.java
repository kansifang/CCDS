package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;

public class AddCLInfoLog extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sAction = (String)this.getAttribute("Action");
		String sUserID = (String)this.getAttribute("UserID");
		String sOrgID = (String)this.getAttribute("OrgID");
		
		//获得当前时间
	    String sNow = StringFunction.getToday()+" "+StringFunction.getNow();
	    
	    String sSql = "",sLogID = "",sFieldValue = "",sLineID = "";
	    int iColumnCount = 0,iFieldType = 0;
	    ASResultSet rs = null;
	    
	    //-----------------------第一步：记录CL_INFO表的操作日志--------------------------
	    //根据对象类型的不同，记录操作日志
	    if(sObjectType.equals("CreditApply"))//查询出申请信息对应的方案明细信息
			sSql =  " select * from CL_INFO where ApplySerialNo = '"+sObjectNo+"' ";

	    if(sObjectType.equals("ApproveApply"))//查询出最终审批意见信息对应的方案明细信息 	
			sSql =  " select * from CL_INFO where ApproveSerialNo = '"+sObjectNo+"' ";

	    if(sObjectType.equals("BusinessContract"))//查询出业务合同信息对应的方案明细信息
			sSql =  " select * from CL_INFO where BCSerialNo = '"+sObjectNo+"' ";

		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		if(rs.next())
		{				
			//获得方案明细信息流水号
			sLogID = DBFunction.getSerialNo("CL_INFO_LOG","LogID",Sqlca);
			//插入方案明细信息
			sSql = " insert into CL_INFO_LOG values('"+sLogID+"'";
			for(int i=1;i<= iColumnCount;i++)
			{					
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}					
			}
			sSql= sSql + ",'"+sUserID+"','"+sOrgID+"','"+sNow+"','"+sAction+"','"+sObjectType+"')";
			Sqlca.executeSQL(sSql);	   
			
			//获得授信额度编号
			sLineID = rs.getString("LineID");
		}  
		rs.getStatement().close();
		
		//-----------------------第二步：记录CL_LIMITATION表的操作日志--------------------------
		sSql = " select * from CL_LIMITATION where LineID = '"+sLineID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		
		while(rs.next())
		{
			//获得方案明限制流水号
			sLogID = DBFunction.getSerialNo("CL_LIMITATION_LOG","LogID",Sqlca);
			//插入方案明细信息
			sSql = " insert into CL_LIMITATION_LOG values('"+sLogID+"'";
			for(int i=1;i<= iColumnCount;i++)
			{					
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}				
			}
			sSql= sSql + ",'"+sUserID+"','"+sOrgID+"','"+sNow+"','"+sAction+"','"+sObjectType+"')";
			
			Sqlca.executeSQL(sSql);	 
		}
		rs.getStatement().close();
		
		//-----------------------第三步：记录CL_LIMITATION_SET表的操作日志--------------------------
		sSql = " select * from CL_LIMITATION_SET where LineID = '"+sLineID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得方案明限制流水号
			sLogID = DBFunction.getSerialNo("CL_LIMITATION_SET_LOG","LogID",Sqlca);
			//插入方案明细信息
			sSql = " insert into CL_LIMITATION_SET_LOG values('"+sLogID+"'";
			for(int i=1;i<= iColumnCount;i++)
			{					
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}					
			}
			sSql= sSql + ",'"+sUserID+"','"+sOrgID+"','"+sNow+"','"+sAction+"','"+sObjectType+"')";
			Sqlca.executeSQL(sSql);	 
		}
		rs.getStatement().close();
	    	
		return "1";
	}
    
	//判断字段类型是否为数字类型,加入integer类型lpzhang
	private static boolean isNumeric(int iType) 
	{
		if (iType==java.sql.Types.BIGINT || iType==java.sql.Types.SMALLINT || iType==java.sql.Types.DECIMAL || iType==java.sql.Types.NUMERIC || iType==java.sql.Types.DOUBLE || iType==java.sql.Types.FLOAT ||iType==java.sql.Types.REAL ||iType==java.sql.Types.INTEGER)
			return true;
		return false;
	}
}
