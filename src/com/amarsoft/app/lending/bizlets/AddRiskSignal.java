/*
		Author: --xhyong 2011/09/28
		Tester:
		Describe: --新增预警信号
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
		//获得已批准预警信息流水号
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sSignalNo = (String)this.getAttribute("SignalNo");
		String sSignalName = (String)this.getAttribute("SignalName");
		String sInputUserID = (String)this.getAttribute("InputUserID");
		String sInputOrgID = (String)this.getAttribute("InputOrgID");
		String sObjectNo =  (String)this.getAttribute("ObjectNo");
		String sObjectType =  (String)this.getAttribute("ObjectType");
		//将空值转化成空字符串		
		if(sCustomerID == null) sCustomerID = "";		
		if(sSignalNo == null) sSignalNo = "";
		if(sSignalName == null) sSignalName = "";
		if(sInputUserID == null) sInputUserID = "";
		if(sInputOrgID == null) sInputOrgID = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		//获得流水号
		String sSerialNo = DBFunction.getSerialNo("Customer_RiskSignal","SerialNo","",Sqlca);
		//获得当前日期
		String sToday = StringFunction.getToday();
		//定义变量：SQL语句,预警类型
		String sSql = "",sSignalType = "",sExistFlag = "",sSignalStatus = "",sMessage="";
		//定义变量：查询结果集
		ASResultSet rs = null;
		//查询是否存在该预警信号
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
			//将空值转化为空字符串		
			if(sSignalType == null) sSignalType = "";
			if(sSignalStatus == null) sSignalStatus = "";
			if("01".equals(sSignalType))
			{
				sExistFlag="01";//存在发起的预警
			}
			if("02".equals(sSignalType)&&!"01".equals(sExistFlag)&&"30".equals(sSignalStatus))
			{
				sExistFlag="02";//只存在解除并通过的预警
			}
		}
		rs.getStatement().close();
		if("01".equals(sExistFlag))
		{
			sMessage = "该预警信号已存在!";
		}else if("02".equals(sExistFlag))//如果存在解除的自动引入该预警信号
		{
			//查询预警信号流水号
			sSql = "select SerialNo  " +
					" from Customer_RiskSignal  "+
					" where CustomerID = '"+sCustomerID+"'"+
					" and SignalNo = '"+sSignalNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next())
			{
				sSerialNo = rs.getString("SerialNo");
				//将空值转化为空字符串		
				if(sSerialNo == null) sSerialNo = "";
			}
			rs.getStatement().close();
			//初始化预警关联信息
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
			//初始化预警信号基本信息
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
			//初始化预警关联信息
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
