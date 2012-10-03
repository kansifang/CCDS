/*
Author:   wangdw 2012/07/24
Tester:
Describe: ���µ���Ѻ������������Ϣ
Input Param:
		SerialNo: ������ˮ��
		ObjectNo: ������
		sObjectType:��������
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateGuaranty_Apply extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{	
		String sSerialNo ="";
		String sUserID ="";
		String sOrgID ="";
		String sInputDate ="";
		String sContractNo ="";
		String sOBJECTTYPE = "";
		String sOBJECTNO = "";
		String sGUARANTYTYPE = "";	  //����Ѻ������
		Date   sMaturity = new Date();//������
		Date   sNow = new Date();     //��ǰ����
		double sBalance = 0.0;	      //��ǰ���+ǷϢ
		String sIscloseoff = "1";      //�����־  1������  0��δ����     
		//��ȡ����
		sSerialNo = (String)this.getAttribute("SerialNo");
		sUserID = (String)this.getAttribute("UserID");
		sOrgID = (String)this.getAttribute("OrgID");
		sInputDate = (String)this.getAttribute("InputDate");
		sContractNo = (String)this.getAttribute("ContractNo");
		sGUARANTYTYPE = (String)this.getAttribute("GUARANTYTYPE");
		String sSql = "";
		String sSql1 = "";
		ASResultSet rs=null;
		ASResultSet rs1=null;
		//��ȡ��������
		sSql = "select OBJECTTYPE from Guaranty_Apply where Serialno = '"+sSerialNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sOBJECTTYPE = rs.getString("OBJECTTYPE");
		}
		//�ж��Ƿ��ǳ����������������жϸñʳ����Ӧ�Ĵ����ͬ�Ƿ����
		if(sOBJECTTYPE.equals("GuarantyOutApply"))
		{
			//��ȡ�ñʳ���ĵ���Ѻ��������Ĵ����ͬ���
			sSql = "select GR.OBJECTNO from GUARANTY_RELATIVE GR,Guaranty_Apply GA where GA.Serialno = '"+sSerialNo+"' and GR.OBJECTTYPE='BusinessContract' and GA.OBJECTNO=GR.GUARANTYID ";
			rs = Sqlca.getASResultSet(sSql);
			//�жϹ����Ĵ����ͬ�Ƿ����
			DateFormat df = new SimpleDateFormat("yyyy/mm/dd");
			while(rs.next())
			{
				sOBJECTNO = rs.getString("OBJECTNO");
				sSql1 = "select Maturity,nvl(Balance,0)+nvl(INTERESTBALANCE1,0)+nvl(INTERESTBALANCE2,0) Balance from BUSINESS_CONTRACT where SERIALNO='"+sOBJECTNO+"'";
				rs1 = Sqlca.getASResultSet(sSql1);
				if(rs1.next())
				{
					sMaturity = df.parse(rs1.getString("Maturity"));
					sBalance = rs1.getDouble("Balance");
				}
				//���������>��ǰ���ڻ���������0�������ý����־Ϊδ����
				if(sMaturity.compareTo(sNow)>0||sBalance!=0)
				{
					sIscloseoff = "0";
					break;
				}
			}
			rs1.getStatement().close();
			sSql = "update Guaranty_Apply set INPUTUSERID = '"+sUserID+"',INPUTORGID = '"+sOrgID+"',INPUTDATE " +
			"= '"+sInputDate+"' ,UPDATEDATE = '"+sInputDate+"',ContractNo = '"+sContractNo+"',GUARANTYTYPE = '"+sGUARANTYTYPE+"',Iscloseoff = '"+sIscloseoff+"'  where " +
			"Serialno = '"+sSerialNo+"' ";
		}else{
			sSql = "update Guaranty_Apply set INPUTUSERID = '"+sUserID+"',INPUTORGID = '"+sOrgID+"',INPUTDATE " +
					"= '"+sInputDate+"' ,UPDATEDATE = '"+sInputDate+"',ContractNo = '"+sContractNo+"',GUARANTYTYPE = '"+sGUARANTYTYPE+"' where " +
					"Serialno = '"+sSerialNo+"' ";
			}
		Sqlca.executeSQL(sSql);
		rs.getStatement().close();
		return "123";
	}
}

