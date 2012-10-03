/*
		Author: --xhyong
		Tester:
		Describe: --新增抵债资产处置时,在抵债资产中增加一条处置记录
		Input Param:
				ObjectNo：申请编号
				BusinessType：业务品种
				CustomerID: 客户代码
				CustomerName: 客户名称				
		Output Param:

		HistoryLog: 增加工程机械按揭额度 added by lpzhang 2009-8-11
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;

public class InitializeBadBiz extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");	
		//对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//对象类型
		String sUserID = (String)this.getAttribute("UserID");
		//对象类型
		String sOrgID = (String)this.getAttribute("OrgID");
		ASResultSet rs = null;
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		String sApplyType = "";
	    //获得当前时
		String sCurDate = StringFunction.getToday();
		//查询申请类型
    	String sSql1 = 	" select ApplyType from BADBIZ_APPLY where SerialNo= '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql1);
		if(rs.next())
		{
			sApplyType = rs.getString("ApplyType");
		}
		rs.getStatement().close();
		
		if("020".equals(sApplyType))//抵债资产处置
		{
	    //如果业务品种是额度，则必须在额度信息表Asset_Info中插入一笔信息
	     String sSerialNo = DBFunction.getSerialNo("Asset_Info","SerialNo",Sqlca);
	     String sSql =  " insert into Asset_Info(SerialNo,ObjectNo,ObjectType,AssetFlag,OperateUserID,OperateOrgID,InputUserID,InputOrgID,InputDate) "+
	                       " values ('"+sSerialNo+"','"+sObjectNo+"','"+sObjectType+"','030','"+sUserID+"','"+sOrgID+"','"+sUserID+"','"+sOrgID+"','"+sCurDate+"')";
	     //执行插入语句
		 Sqlca.executeSQL(sSql);
		}
	    
		if("025".equals(sApplyType))//抵债资产处置核销
		{
	     //执行插入语句
		 Sqlca.executeSQL("Update BADBIZ_APPLY set OperateType='160' where SerialNo= '"+sObjectNo+"'");
		}
		
		return "1";
	 }
}
