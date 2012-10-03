package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;

public class getFinanceAverage extends Bizlet {

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
		//财务报告科目号
		String sRowSubject = (String)this.getAttribute("RowSubject");
		//将空值转化为空字符串
		if(sItemName == null) sItemName = "0";
		if(sObjectNo == null) sObjectNo = "";
		if(sAccountMonth == null) sAccountMonth = "";
		if(sReportScope == null) sReportScope = "";
		if(sRowSubject == null) sRowSubject = "";
		
		//今年值,去年值,前年值
		double dThisYearValue = 0.0,dLastYearValue = 0.00,dFormerYearValue = 0.00,dReturnVlaue = 0.00;
		//Sql语句、返回值
		String sSql = null,sReturnVlaue = "0.00";
		//计数标识
		int iFlag = 1,iFSCount=4;
		//查询结果集
		ASResultSet rs = null;
		
		//查询今年财务报表相关值
		sSql = 	" SELECT "+sItemName+" FROM REPORT_DATA "+
			 " where ReportNo in "+
			 " (select ReportNo from REPORT_RECORD where "+
			 " ObjectNo ='"+sObjectNo+"' and "+
			 " ReportDate = '"+sAccountMonth+"'"+
			 " and ReportScope = '"+sReportScope+"') "+
			 " and RowSubject='"+sRowSubject+"'";	
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dThisYearValue = rs.getDouble(1);
		}
		rs.getStatement().close();
		
		//查询去年财务报表相关值
		sSql = 	" SELECT "+sItemName+" FROM REPORT_DATA "+
			 " where ReportNo in "+
			 " (select ReportNo from REPORT_RECORD where "+
			 " ObjectNo ='"+sObjectNo+"' and "+
			 " ReportDate = varchar(left(char((int(left('"+sAccountMonth+"',4))-1)),4)||'/12') "+
			 " and ReportScope = '"+sReportScope+"') "+
			 " and RowSubject='"+sRowSubject+"'";	
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dLastYearValue = rs.getDouble(1);
			iFlag = iFlag+1;
		}
		rs.getStatement().close();
		
		//查询前年财务报表相关值
		sSql = 	" SELECT "+sItemName+" FROM REPORT_DATA "+
			 " where ReportNo in "+
			 " (select ReportNo from REPORT_RECORD where "+
			 " ObjectNo ='"+sObjectNo+"' and "+
			 " ReportDate = varchar(left(char((int(left('"+sAccountMonth+"',4))-2)),4)||'/12') "+
			 " and ReportScope = '"+sReportScope+"') "+
			 " and RowSubject='"+sRowSubject+"'";	
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dFormerYearValue = rs.getDouble(1);	
			iFlag = iFlag+1;
		}
		rs.getStatement().close();
		//查询年报数量
		sSql = 	" select count(RecordNo) from  CUSTOMER_FSRECORD "+
				" where CustomerID='"+sObjectNo+"' and ReportPeriod='04'";	
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			iFSCount = rs.getInt(1);
		}
		rs.getStatement().close();
		//求平均值
		if(iFSCount<4)
		{
			//如果只有小于4期，自动减一计算，因为第一年没有数据
			if(iFSCount==1)
			{
				dReturnVlaue = 0;
			}else
			{
				dReturnVlaue = (dThisYearValue+dLastYearValue+dFormerYearValue)/(iFSCount-1);
			}
		}else{
			dReturnVlaue = (dThisYearValue+dLastYearValue+dFormerYearValue)/iFlag;
		}
		sReturnVlaue = String.valueOf(dReturnVlaue);
		if(sReturnVlaue==null) sReturnVlaue="0";
		return sReturnVlaue;
	}

}
