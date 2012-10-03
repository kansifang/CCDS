package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong 2011/05/26
Tester:
Describe: --检查业务存在的审查报告
Input Param:
		sObjectNo：对象编号
Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckExistApproveReport extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		
		//返回标志,查询SQL
		String sFlag = "";
		String sSql = "";
		String sExistCountyApprove="";
		String sExistCityApprove="";
		//是否存在中心支行审查报告
		sSql = " select 'true' from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and ObjectType = 'CountyApprove' ";
		sExistCountyApprove = Sqlca.getString(sSql);
		if(sExistCountyApprove == null) sExistCountyApprove = "";
		//是否存在总行审查报告
		sSql = " select 'true' from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and ObjectType = 'CityApprove' ";
		sExistCityApprove = Sqlca.getString(sSql);
		if(sExistCityApprove == null) sExistCityApprove = "";
		
		if("true".equals(sExistCountyApprove)&&"true".equals(sExistCityApprove))
		{
			sFlag="1";
		}
		
		return sFlag;
	}
}
