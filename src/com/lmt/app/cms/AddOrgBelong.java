package com.lmt.app.cms;

/*
Author: --zywei 2006-01-17
Tester:
Describe: --新增机构时，同时在ORG_BELONG新增相应的机构间的层次关系
		  --目前用于页面：OrgInfo
Input Param:
		OrgID: 机构编号
		RelativeOrgID: 上级机构编号
Output Param:

HistoryLog: ---modified by wwhe 20090909
					废除根据上级机构来新增org_belong
					总行的任一管理机构都由权限查看分行以及支行机构
					分行任一机构都由权限查看支行
					
					9999 暂设为晋商银行总行机构号
					
				
					
*/

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.sql.Transaction;

public class AddOrgBelong extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		//自动获得传入的参数值	  	    
		String sOrgID 		= (String)this.getAttribute("OrgID");
		String sOrgLevel	= (String)this.getAttribute("OrgLevel");
		String sSortNo 		= (String)this.getAttribute("SortNo");
		String sRelativeOrgID 	= (String)this.getAttribute("RelativeOrgID");
				
		//将空值转化为空字符串
		if(sOrgID == null) sOrgID = "";
		if(sOrgLevel == null) sOrgLevel = "";	
		if(sSortNo == null) sSortNo = "";	
		if(sRelativeOrgID == null) sRelativeOrgID = "";	
		
		//保存前删除与该机构的有关记录，防止主键重复
		Sqlca.executeSQL("delete from ORG_BELONG where BelongOrgID = '"+sOrgID+"'");
		Sqlca.executeSQL("delete from ORG_BELONG where OrgID = '"+sOrgID+"'");
		
		//1:总行
		if(sOrgLevel.equals("0"))
		{
			//对下级机构的查看权限:总行部门应该可以查看其它部门（包括其它总行部门）
			Sqlca.executeSQL("insert into ORG_BELONG select '"+sOrgID+"',OrgID from org_info where OrgID<>'"+sOrgID+"'");
			//对上级机构的所属权限：总行部门，应该被其他总行部门和自身查看到
			Sqlca.executeSQL("insert into ORG_BELONG select OrgID,'"+sOrgID+"' from org_info where Orglevel='0'");
		}	
		
		//2:分行
		if(sOrgLevel.equals("3"))
		{
			//对下级机构的查看权限:分行部门应该可以查看本分行下属部门和自身
			Sqlca.executeSQL("insert into ORG_BELONG select '"+sOrgID+"',OrgID from org_info where RelativeOrgID = '"+sOrgID+"' or OrgID='"+sOrgID+"'");
			//对上级机构的所属权限：分行部门，应该被所有的总行部门查看到
			Sqlca.executeSQL("insert into ORG_BELONG select OrgID,'"+sOrgID+"' from org_info where Orglevel='0'");
		}	
		
		//3：支行
		if(sOrgLevel.equals("6"))
		{
			//对下级机构的查看权限:支行部门应该可以查看本支行下属部门和自身
			Sqlca.executeSQL("insert into ORG_BELONG select '"+sOrgID+"',OrgID from org_info where RelativeOrgID = '"+sOrgID+"' or OrgID='"+sOrgID+"'");
			//对上级机构的所属权限：支行部门，应该被所有总行部门，和所属分行查看到
			Sqlca.executeSQL("insert into ORG_BELONG select OrgID,'"+sOrgID+"' from org_info where Orglevel='0' or OrgID = '"+sRelativeOrgID+"'");
		}	
		
		//更新排序号，如果本机构的排序号没有以所属行的排序号开头，则更新本机构的排序号。
		String sHeaderSortNo = Sqlca.getString("select SortNo from org_info where OrgID='"+sRelativeOrgID+"'");

		if(!sSortNo.startsWith(sHeaderSortNo))
		{   
			String sMaxSortNo = Sqlca.getString("select max(SortNo) from org_info where SortNo like '"+sHeaderSortNo+"%'");
			String sNewSortNo = "";
			if(sHeaderSortNo.equals(sMaxSortNo)){
				sNewSortNo = "0"+(Integer.parseInt(sMaxSortNo)+"00"+1);
			}else{
			    sNewSortNo = "0"+(Integer.parseInt(sMaxSortNo)+1);
			}
			
			Sqlca.executeSQL("update Org_Info set SortNo='"+sNewSortNo+"' where OrgID='"+sOrgID+"'");
		}
		return "1";
	}

}
