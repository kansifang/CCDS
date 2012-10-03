package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;

public class getFinanceAverage extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		// TODO Auto-generated method stub
		//��ȡ�ֶ�
		String sItemName = (String)this.getAttribute("ItemName");
		//������ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//���񱨱��·�
		String sAccountMonth = (String)this.getAttribute("AccountMonth");
		//��������
		String sReportScope = (String)this.getAttribute("ReportScope");
		//���񱨸��Ŀ��
		String sRowSubject = (String)this.getAttribute("RowSubject");
		//����ֵת��Ϊ���ַ���
		if(sItemName == null) sItemName = "0";
		if(sObjectNo == null) sObjectNo = "";
		if(sAccountMonth == null) sAccountMonth = "";
		if(sReportScope == null) sReportScope = "";
		if(sRowSubject == null) sRowSubject = "";
		
		//����ֵ,ȥ��ֵ,ǰ��ֵ
		double dThisYearValue = 0.0,dLastYearValue = 0.00,dFormerYearValue = 0.00,dReturnVlaue = 0.00;
		//Sql��䡢����ֵ
		String sSql = null,sReturnVlaue = "0.00";
		//������ʶ
		int iFlag = 1,iFSCount=4;
		//��ѯ�����
		ASResultSet rs = null;
		
		//��ѯ������񱨱����ֵ
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
		
		//��ѯȥ����񱨱����ֵ
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
		
		//��ѯǰ����񱨱����ֵ
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
		//��ѯ�걨����
		sSql = 	" select count(RecordNo) from  CUSTOMER_FSRECORD "+
				" where CustomerID='"+sObjectNo+"' and ReportPeriod='04'";	
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			iFSCount = rs.getInt(1);
		}
		rs.getStatement().close();
		//��ƽ��ֵ
		if(iFSCount<4)
		{
			//���ֻ��С��4�ڣ��Զ���һ���㣬��Ϊ��һ��û������
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
