/*
Author:   wangdw 2012/07/24
Tester:
Describe: 更新抵质押物出入库申请信息
Input Param:
		SerialNo: 流程流水号
		ObjectNo: 对象编号
		sObjectType:对象类型
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
		String sGUARANTYTYPE = "";	  //抵质押物类型
		Date   sMaturity = new Date();//到期日
		Date   sNow = new Date();     //当前日期
		double sBalance = 0.0;	      //当前余额+欠息
		String sIscloseoff = "1";      //结清标志  1：结清  0：未结清     
		//获取参数
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
		//获取操作类型
		sSql = "select OBJECTTYPE from Guaranty_Apply where Serialno = '"+sSerialNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sOBJECTTYPE = rs.getString("OBJECTTYPE");
		}
		//判断是否是出库操作，如果是则判断该笔出库对应的贷款合同是否结清
		if(sOBJECTTYPE.equals("GuarantyOutApply"))
		{
			//获取该笔出库的抵质押物相关连的贷款合同编号
			sSql = "select GR.OBJECTNO from GUARANTY_RELATIVE GR,Guaranty_Apply GA where GA.Serialno = '"+sSerialNo+"' and GR.OBJECTTYPE='BusinessContract' and GA.OBJECTNO=GR.GUARANTYID ";
			rs = Sqlca.getASResultSet(sSql);
			//判断关联的贷款合同是否结清
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
				//如果到期日>当前日期或者余额不等于0，则设置结清标志为未结清
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

