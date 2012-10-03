/*
		Author: --xhyong 2011/09/28
		Tester:
		Describe: --����Ԥ���ź�
		Input Param:
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.util.StringFunction;


public class AddRiskSignal extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{		
		//�������׼Ԥ����Ϣ��ˮ��
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sSignalNo = (String)this.getAttribute("SignalNo");
		String sSignalName = (String)this.getAttribute("SignalName");
		String sInputUserID = (String)this.getAttribute("InputUserID");
		String sInputOrgID = (String)this.getAttribute("InputOrgID");
		String sObjectNo =  (String)this.getAttribute("ObjectNo");
		String sObjectType =  (String)this.getAttribute("ObjectType");
		//����ֵת���ɿ��ַ���		
		if(sCustomerID == null) sCustomerID = "";		
		if(sSignalNo == null) sSignalNo = "";
		if(sSignalName == null) sSignalName = "";
		if(sInputUserID == null) sInputUserID = "";
		if(sInputOrgID == null) sInputOrgID = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		//�����ˮ��
		String sSerialNo = DBFunction.getSerialNo("Customer_RiskSignal","SerialNo","",Sqlca);
		//��õ�ǰ����
		String sToday = StringFunction.getToday();
		//���������SQL���,Ԥ������
		String sSql = "",sSignalType = "",sExistFlag = "",sSignalStatus = "",sMessage="";
		//�����������ѯ�����
		ASResultSet rs = null;
		//��ѯ�Ƿ���ڸ�Ԥ���ź�
		sSql = "select RS.SignalType,RS.SignalStatus  " +
				" from Customer_RiskSignal CR,Risk_Signal RS,RISKSIGNAL_RELATIVE RR"+
				" where RR.ObjectNo = CR.SerialNo "+
				" and RS.SerialNo=RR.SerialNo and RR.ObjectType='RiskSignal' "+
				" and CR.CustomerID = '"+sCustomerID+"'"+
				" and CR.SignalNo = '"+sSignalNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sSignalType = rs.getString("SignalType");
			sSignalStatus = rs.getString("SignalStatus");
			//����ֵת��Ϊ���ַ���		
			if(sSignalType == null) sSignalType = "";
			if(sSignalStatus == null) sSignalStatus = "";
			if("01".equals(sSignalType))
			{
				sExistFlag="01";//���ڷ����Ԥ��
			}
			if("02".equals(sSignalType)&&!"01".equals(sExistFlag)&&"30".equals(sSignalStatus))
			{
				sExistFlag="02";//ֻ���ڽ����ͨ����Ԥ��
			}
		}
		rs.getStatement().close();
		if("01".equals(sExistFlag))
		{
			sMessage = "��Ԥ���ź��Ѵ���!";
		}else if("02".equals(sExistFlag))//������ڽ�����Զ������Ԥ���ź�
		{
			//��ѯԤ���ź���ˮ��
			sSql = "select SerialNo  " +
					" from Customer_RiskSignal  "+
					" where CustomerID = '"+sCustomerID+"'"+
					" and SignalNo = '"+sSignalNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
			{
				sSerialNo = rs.getString("SerialNo");
				//����ֵת��Ϊ���ַ���		
				if(sSerialNo == null) sSerialNo = "";
			}
			rs.getStatement().close();
			//��ʼ��Ԥ��������Ϣ
			sSql =  "insert into RISKSIGNAL_RELATIVE( " +
									"SerialNo,"+
									"ObjectType,"+
									"ObjectNo "+
									" ) values("+
									"'"+sObjectNo+"',"+
									"'"+sObjectType+"',"+
									"'"+sSerialNo+"' )";
			Sqlca.executeSQL(sSql);
		}else{
			//��ʼ��Ԥ���źŻ�����Ϣ
			sSql =  "insert into Customer_RiskSignal( " +
									"SerialNo,"+
									"CustomerID,"+
									"SignalNo,"+
									"SignalName,"+
									"InputOrgID,"+
									"InputUserID,"+
									"InputDate "+
									" ) values("+
									"'"+sSerialNo+"',"+
									"'"+sCustomerID+"',"+
									"'"+sSignalNo+"', "+
									"'"+sSignalName+"', "+
									"'"+sInputOrgID+"', "+
									"'"+sInputUserID+"', "+
									"'"+sToday+"' )";
			Sqlca.executeSQL(sSql);	
			//��ʼ��Ԥ��������Ϣ
			sSql =  "insert into RISKSIGNAL_RELATIVE( " +
									"SerialNo,"+
									"ObjectType,"+
									"ObjectNo "+
									" ) values("+
									"'"+sObjectNo+"',"+
									"'"+sObjectType+"',"+
									"'"+sSerialNo+"' )";
			Sqlca.executeSQL(sSql);
		}
				
		return sMessage;
	}	
}
