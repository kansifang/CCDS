package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;

public class getEvaluateItemValue extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		// TODO Auto-generated method stub
		//所取字段
		String sItemName = (String)this.getAttribute("ItemName");
		//对象流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//财务报表月份
		String sAccountMonth = (String)this.getAttribute("AccountMonth");
		//财务报类型
		String sReportScope = (String)this.getAttribute("ReportScope");
		//取值标识别
		String sItemFlag = (String)this.getAttribute("ItemFlag");
		//默认值
		String sDefValue = (String)this.getAttribute("DefValue");
		//将空值转化为空字符串
		if(sItemName == null) sItemName = "0";
		if(sObjectNo == null) sObjectNo = "";
		if(sAccountMonth == null) sAccountMonth = "";
		if(sReportScope == null) sReportScope = "";
		if(sItemFlag == null) sItemFlag = "";
		if(sDefValue == null) sDefValue = "";
		
		//分子值,分母值
		double dNumerator=0.00,dDenominator=0.00,dReturnVlaue = 0.00;
		//Sql语句、返回值
		String sSql = null,sReturnVlaue = "0.00";
		//查询结果集
		ASResultSet rs = null;
		
		//查询分子值
		sSql = 	" SELECT Sum("+sItemName+") FROM REPORT_DATA "+
			 " where ReportNo in "+
			 " (select ReportNo from REPORT_RECORD where "+
			 " ObjectNo ='"+sObjectNo+"' and "+
			 " ReportDate = '"+sAccountMonth+"'"+
			 " and ReportScope = '"+sReportScope+"') ";	
		//根据不同标示区分取值
		if("1".equals(sItemFlag))//债务清偿率
		{
			sSql+=" and RowSubject in('501')";
		}else if("2".equals(sItemFlag))
		{
			sSql+=" and RowSubject in('810')";
		}else
		{
			sSql+="1=2";
		}
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dNumerator = rs.getDouble(1);		
		}
		rs.getStatement().close();
		
		//查询分母值
		sSql = 	" SELECT Sum("+sItemName+") FROM REPORT_DATA "+
			 " where ReportNo in "+
			 " (select ReportNo from REPORT_RECORD where "+
			 " ObjectNo ='"+sObjectNo+"' and "+
			 " ReportDate = '"+sAccountMonth+"'"+
			 " and ReportScope = '"+sReportScope+"') ";	
		//根据不同标示区分取值
		if("1".equals(sItemFlag))//债务清偿率
		{
			sSql += " and RowSubject in('201','211')";
		}else if("2".equals(sItemFlag))
		{
			sSql += " and RowSubject in('517')";
		}else
		{
			sSql += "1=2";
		}
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dDenominator = rs.getDouble(1);		
		}
		rs.getStatement().close();
		//求平均值
		if(dDenominator==0)
		{
			sReturnVlaue = sDefValue;
		}
		else{
			dReturnVlaue = dNumerator/dDenominator;
			sReturnVlaue = String.valueOf(dReturnVlaue);
		}		
		return sReturnVlaue;
	}

}
