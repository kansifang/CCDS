package com.amarsoft.app.lending.bizlets;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;

public class CheckSaveFlag extends Bizlet
{
	public Object  run(Transaction Sqlca) throws Exception
	{		 
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//获得当前日期
		String sToday = StringFunction.getToday();
		//获得去年同期
		
		//定义变量：提示信息、SQL语句、产品类型、客户类型
		String sMessage = "",sSql = "";
		//定义变量：主要担保方式、客户代码、主体表名、关联表名
		String sMainTable = "",sRelativeTable = "",sContractSerialNo="",sBCPutOutDate ="",sCycleFlag="";
		double dBusinessSum =0.0,dBPBusinessSum=0.0,dBalance=0.0,dTotalPBSum=0.0;
		//定义变量：暂存标志,是否低风险
		String sTempSaveFlag = "";
		//定义变量：发生类型、申请类型、担保人代码
		//定义变量：查询结果集
		ASResultSet rs = null;			
		
		//根据对象类型获取主体表名
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) { 
			sMainTable = rs.getString("ObjectTable");
			sRelativeTable = rs.getString("RelativeTable");
			//将空值转化成空字符串
			if (sMainTable == null) sMainTable = "";
			if (sRelativeTable == null) sRelativeTable = "";
		}
		rs.getStatement().close();
		
		if (!sMainTable.equals("")) {
			//--------------检查最终审批意见详情是否全部输入---------------
			//从相应的对象主体表中获取金额、产品类型、票据张数、担保类型
			sSql = 	" select ContractSerialNo,TempSaveFlag,BusinessSum from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	
				sContractSerialNo = rs.getString("ContractSerialNo");
				dBPBusinessSum = rs.getDouble("BusinessSum");
				
				//将空值转化成空字符串
				if (sTempSaveFlag == null) sTempSaveFlag = "";	
				if (sContractSerialNo == null) sContractSerialNo = "";	
				if (sTempSaveFlag.equals("1")) {			
					sMessage = "信息详情为暂存状态，请先填写完信息详情并点击保存按钮！";
												
				}			
			}
			rs.getStatement().close();
		} 
		
		 //--------------第二步：检查该放款起贷日是否在审批通过90天内---------------	
		sSql = 	" select BusinessSum,Balance,PutOutDate,CycleFlag "+
				" from Business_Contract where SerialNo = '"+sContractSerialNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		while (rs.next()) { 
			dBusinessSum = rs.getDouble("BusinessSum");	
			dBalance = rs.getDouble("Balance");	
			sBCPutOutDate = rs.getString("PutOutDate");
			sCycleFlag = rs.getString("CycleFlag");
			if(sBCPutOutDate == null) sBCPutOutDate = "";
			if(sCycleFlag == null) sCycleFlag = "";
		}
		rs.getStatement().close();
		
		String FirstPutOutDate = Sqlca.getString(" select PutOutDate from Business_PutOut where ContractSerialNo = '"+sContractSerialNo+"'" +
												 " order by PutOutDate desc fetch first 1 rows only");
		
		Calendar cd = new GregorianCalendar(Integer.parseInt(FirstPutOutDate.substring(0,4)),Integer.parseInt(FirstPutOutDate.substring(5,7)),Integer.parseInt(FirstPutOutDate.substring(8, 10)));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		cd.add(Calendar.DATE,-91); //回退90天
		String Temp = sdf.format(cd.getTime());
		
		if(Temp.compareTo(FirstPutOutDate)>0)
		{
			sMessage = "90日内未对授信业务提起放贷，该笔申请作废，不能进行放贷申请！"+"@";
		}
		
		return sMessage;
	}
		

}
