package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class PutOutAuthBusiness extends Bizlet{

	public Object run(Transaction Sqlca) throws Exception {
		//获取参数：对象类型，对象编号和当前用户
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sRoleID = (String)this.getAttribute("RoleID");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sRoleID == null) sRoleID = "";
		
		//定义变量：返回结果、SQL语句
		String result="FALSE",sSql = "";
		//定义变量：申请金额，授权金额
		double dBusinessSum1 = 0,dAuBusinessSum1 = 0;
		//定义变量：查询结果集
		ASResultSet rs = null;
		//获取申请金额,业务品种
		sSql = "select BusinessSum from BUSINESS_PUTOUT "+
			   " where SerialNo='"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
		{ 
			dBusinessSum1 = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();
		
		if(!sRoleID.equals("")){
			//获取单笔授权金额
			sSql = "select AuthSum from PutOut_Auth "+
				 " where RoleID = '"+sRoleID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			
			if (rs.next())
				dAuBusinessSum1 = rs.getDouble("AuthSum");		
			rs.getStatement().close();
		}
		//System.out.println(dBusinessSum1+"@"+dAuBusinessSum1);
		//单笔授权和单户授权都通过
		if(dBusinessSum1 <= dAuBusinessSum1)
			result="TRUE";
		return result;
	}

}
