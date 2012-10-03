package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.sql.ASResultSet;


public class UpdateBusinessPigeonhole extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//获得参数：变更后的客户名称、证件类型、证件编号和贷款卡编号	
	 	String sContractSerialNo  = (String)this.getAttribute("ContractSerialNo");
		//定义变量
		String sSql = "";
		ASResultSet rs=null;
		double dTotalPutOutBusinessSum=0.00,dContractBusinessSum=0.00;
		String sBusinessType = "";
			   	
		//获得合同金额,业务品种
		sSql = " select BusinessSum,BusinessType from BUSINESS_CONTRACT where SerialNo = '"+sContractSerialNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dContractBusinessSum = rs.getDouble("BusinessSum");
			sBusinessType = rs.getString("BusinessType");
			//将空值转化为空字符串		
			if(sBusinessType == null) sBusinessType = "";
		}
		rs.getStatement().close();
		
		//如果是进口信用证取实际用信金额
		if("2050030".equals(sBusinessType))
		{
			//获得合同金额
			sSql = " select PracticeSum from BUSINESS_CONTRACT where SerialNo = '"+sContractSerialNo+"' ";
			dContractBusinessSum = Sqlca.getDouble(sSql);
		}
		
		//获得总出账金额
		sSql = " select sum(BusinessSum) from BUSINESS_PUTOUT where ContractSerialNo = '"+sContractSerialNo+"' ";
		dTotalPutOutBusinessSum = Sqlca.getDouble(sSql);
		
	    //如果放款结束
		if(dContractBusinessSum==dTotalPutOutBusinessSum)
		{
			sSql = "Update BUSINESS_CONTRACT set PigeonholeDate='"+StringFunction.getToday()+"' where SerialNo='"+sContractSerialNo+"' " ;
		}
	    //执行更新语句
	    Sqlca.executeSQL(sSql);
	    
	    return "Success";
	 }

}
