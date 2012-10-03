package com.amarsoft.app.lending.bizlets;
/*
Author: --xhyong 2011/05/26
Tester:
Describe: --���ҵ����ڵ���鱨��
Input Param:
		sObjectNo��������
Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckExistApproveReport extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//�Զ���ô���Ĳ���ֵ
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		
		//���ر�־,��ѯSQL
		String sFlag = "";
		String sSql = "";
		String sExistCountyApprove="";
		String sExistCityApprove="";
		//�Ƿ��������֧����鱨��
		sSql = " select 'true' from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and ObjectType = 'CountyApprove' ";
		sExistCountyApprove = Sqlca.getString(sSql);
		if(sExistCountyApprove == null) sExistCountyApprove = "";
		//�Ƿ����������鱨��
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
