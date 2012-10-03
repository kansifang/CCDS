/*
		Author: jgao1 2008-09-26
		Tester:
		Describe: ��������޶��ܶ��Ƿ���������ܶ��鳨���޶��Ƿ���������޶�
		Input Param:
				LineSum1: �����޶�
				LineSum2: �����޶�
				ParentLineID:�����ܶ�LineID��
		Output Param:
				1."00":��ʾ������
				2."01":��ʾ��ǰ�����޶���������޶
				3."10"����ʾ�����޶�֮�ʹ��������ܶ
				4."11"����ʾ�����޶���������޶�������޶�֮�ʹ��������ܶ�
		HistoryLog:
*/

package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;



public class CheckCreditLine extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
	 	//��������ܶ��LineID
	 	String sParentLineID = (String)this.getAttribute("ParentLineID");
	 	if(sParentLineID == null) sParentLineID = "";
	 	//�������ʱ��LineID�ţ�������LineSum1�޳���
	 	String sSubLineID = (String)this.getAttribute("SubLineID");
		//��õ�Ȼ����������޶�
		String sLineSum1 = (String)this.getAttribute("LineSum1");
		String sCurrency = (String)this.getAttribute("Currency");//��ǰ����
		String sObjectNo = (String)this.getAttribute("ObjectNo");//��ͬ��
		if(sLineSum1==null||sLineSum1.equals("")) sLineSum1 = "0";
		if(sCurrency == null) sCurrency="";
		if(sObjectNo == null) sObjectNo="";
		//���ѵ�Ȼ�����޶��String��ת��Ϊdouble�ͣ���ǰ�����޶����ΪsLineSuminput1
		double sLineSuminput1 = Double.parseDouble(sLineSum1);
		//��õ�Ȼ����ĳ����޶�
		String sLineSum2 = (String)this.getAttribute("LineSum2");
		if(sLineSum2==null||sLineSum2.equals("")) sLineSum2 = "0";
		//���ѵ�Ȼ�����޶��String��ת��Ϊdouble�ͣ���ǰ�����޶����ΪsLineSuminput2
		double sLineSuminput2 = Double.parseDouble(sLineSum2);
		
		int dTermMonth = Integer.parseInt((String)this.getAttribute("TermMonth"));
		
		//�����޶�֮�ͳ��������ܶ�ı�־��1.false��ʾ����;2.true��ʾ����.
		boolean flag1 = false;
		//��ǰ����ĳ����޶���������޶�ı�־��1.false��ʾ������2.true��ʾ����.
		boolean flag2 = false;
		//����ֵ��־��1."00":��ʾ������2."01":��ʾ��ǰ�����޶���������޶3."10"����ʾ�����޶�֮�ʹ��������ܶ3."11"����ʾ�����޶���������޶�������޶�֮�ʹ��������ܶ
		String flag3 = "00";
		
		String sSql = "";
		ASResultSet rs = null;
		int dParentTermMonth=0;
		double dBCBusinessSum=0.0,dBCTermMonth = 0.0;//��ͬ��Ϣ
		//����ͬ��Ϣ
		sSql = "select LineSum1*getERate(Currency,'01',ERateDate) as BusinessSum, TermMonth from CL_INFO where LineID='"+sParentLineID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dBCBusinessSum = rs.getDouble("BusinessSum");
				dBCTermMonth = rs.getDouble("TermMonth");
			}
			rs.getStatement().close();
		
		
		double sLineSum = 0;
		//��CL_INFO����ȡ�������ܶ�
		sSql = "select "+sLineSuminput1+"*getERate('"+sCurrency+"','01','') as LineSum1  from (values 1)  as a ";
	    rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sLineSum = rs.getDouble("LineSum1");//ҳ��¼����
		}
		rs.getStatement().close();
		
		//�����Ѿ��������޶��ܺ�LineSum
		double LineSum = 0;
		sSql = "select sum(nvl(LineSum1,0)*getERate(Currency,'01',ERateDate))  from CL_INFO where ParentLineID='"+sParentLineID+"' and LineID <> '"+sSubLineID+"'";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			LineSum = rs.getDouble(1);
			
		}
		rs.getStatement().close();
		
		//�������Ѿ�����������޶�͵�ǰ����������޶�֮��
		LineSum = LineSum + sLineSum;
		
		//��������������޶���ܺʹ��������ܶ�򳬶�
		if(LineSum > dBCBusinessSum) 
		{
			flag3 = "01";
		}else if(dTermMonth >dBCTermMonth){
			flag3 = "12";
		}
		
		
		return flag3;
	    
	}

}
