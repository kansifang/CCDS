package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;

public class getEvaluateItemValue extends Bizlet {

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
		//ȡֵ��ʶ��
		String sItemFlag = (String)this.getAttribute("ItemFlag");
		//Ĭ��ֵ
		String sDefValue = (String)this.getAttribute("DefValue");
		//����ֵת��Ϊ���ַ���
		if(sItemName == null) sItemName = "0";
		if(sObjectNo == null) sObjectNo = "";
		if(sAccountMonth == null) sAccountMonth = "";
		if(sReportScope == null) sReportScope = "";
		if(sItemFlag == null) sItemFlag = "";
		if(sDefValue == null) sDefValue = "";
		
		//����ֵ,��ĸֵ
		double dNumerator=0.00,dDenominator=0.00,dReturnVlaue = 0.00;
		//Sql��䡢����ֵ
		String sSql = null,sReturnVlaue = "0.00";
		//��ѯ�����
		ASResultSet rs = null;
		
		//��ѯ����ֵ
		sSql = 	" SELECT Sum("+sItemName+") FROM REPORT_DATA "+
			 " where ReportNo in "+
			 " (select ReportNo from REPORT_RECORD where "+
			 " ObjectNo ='"+sObjectNo+"' and "+
			 " ReportDate = '"+sAccountMonth+"'"+
			 " and ReportScope = '"+sReportScope+"') ";	
		//���ݲ�ͬ��ʾ����ȡֵ
		if("1".equals(sItemFlag))//ծ���峥��
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
		
		//��ѯ��ĸֵ
		sSql = 	" SELECT Sum("+sItemName+") FROM REPORT_DATA "+
			 " where ReportNo in "+
			 " (select ReportNo from REPORT_RECORD where "+
			 " ObjectNo ='"+sObjectNo+"' and "+
			 " ReportDate = '"+sAccountMonth+"'"+
			 " and ReportScope = '"+sReportScope+"') ";	
		//���ݲ�ͬ��ʾ����ȡֵ
		if("1".equals(sItemFlag))//ծ���峥��
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
		//��ƽ��ֵ
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
