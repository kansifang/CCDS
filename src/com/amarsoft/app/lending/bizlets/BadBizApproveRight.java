package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong
Tester:
Describe: --判断不良业务审批权限
Input Param:
		ObjectNo：对象编号
		ObjectType:对象类型
Output Param:
		sReturnValue:返回值
HistoryLog:
*/

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class BadBizApproveRight extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		//System.out.println(sObjectNo+"@"+sObjectType);
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		//定义变量：SQL语句、关联流水号1、关联流水号2、字段列值
		String sSql = "";
		//定义变量：查询结果集、查询结果集1
		ASResultSet rs = null;
		//申请类型,返回值
		String sApplyType = "",sReturnValue = "2";
		double dBusinessSum = 0.0,dAuthSum2 = 0.0;
		//取不良贷款基本信息
		sSql =  " select ApplyType,BusinessSum from BadBiz_Apply where SerialNo='"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sApplyType = rs.getString("ApplyType");
			dBusinessSum = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();
		
		if("030".equals(sApplyType))//核销
		{
			//取机构核销权限
			sSql =  "select AuthSum2 from ORG_INFO "+
			" where OrgID in(select OrgID from FLOW_TASK "+
			" where (EndTime is null or EndTime = '') "+
			" and ObjectNO='"+sObjectNo+"' and ObjectType='"+sObjectType+"') ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dAuthSum2 = rs.getDouble("AuthSum2");
			}
			rs.getStatement().close();
			if(dAuthSum2 >= dBusinessSum ) sReturnValue="1";
		}	
		return sReturnValue;
	}		
}
