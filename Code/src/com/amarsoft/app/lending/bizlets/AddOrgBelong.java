package com.amarsoft.app.lending.bizlets;

/*
Author: --zywei 2006-01-17
Tester:
Describe: --新增机构时，同时在ORG_BELONG新增相应的机构间的层次关系
		  --目前用于页面：OrgInfo
Input Param:
		OrgID: 机构编号
		RelativeOrgID: 上级机构编号
Output Param:

HistoryLog:
*/

import java.util.*;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddOrgBelong extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		//自动获得传入的参数值	  	    
		String sOrgID = (String)this.getAttribute("OrgID");
		String sRelativeOrgID = (String)this.getAttribute("RelativeOrgID");
				
		//将空值转化为空字符串
		if(sOrgID == null) sOrgID = "";
		if(sRelativeOrgID == null) sRelativeOrgID = "";	
				
		//定义变量
		Vector o_OrgInfo = new Vector();
		ASResultSet rs = null;
		String sSql = "";
		String sBelongOrgID = "";
		int iCount = 0;
		
		//判断该机构与上级机构之间的层次关系是否已存在
		sSql = 	" select count(OrgID) from ORG_BELONG "+
				" where OrgID = '"+sOrgID+"' "+
				" and BelongOrgID = '"+sRelativeOrgID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		//该机构与上级机构之间的层次关系不存在
		if(iCount < 1)
		{
			//删除该机构与上级机构之间的层次关系（便于新增）
			Sqlca.executeSQL("delete from ORG_BELONG where BelongOrgID = '"+sOrgID+"'");
			
			//获取该机构的所有上级机构编号
			sSql = 	" select distinct OrgID from ORG_BELONG "+
					" where BelongOrgID = '"+sRelativeOrgID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
				o_OrgInfo.add(rs.getString("OrgID"));
			rs.getStatement().close();
			
			o_OrgInfo.add(sOrgID);
			//新增该机构与上级机构之间的层次关系
			if(o_OrgInfo.size() > 0)
			{
				for(int i=0;i<o_OrgInfo.size();i++)
				{
					sBelongOrgID = (String)o_OrgInfo.get(i);
					sSql = 	" insert into ORG_BELONG(OrgID,BelongOrgID) "+
							" values('"+sBelongOrgID+"','"+sOrgID+"') ";
					Sqlca.executeSQL(sSql);
				}
			}
		}
		
		
		
		return "1";
	}

}
