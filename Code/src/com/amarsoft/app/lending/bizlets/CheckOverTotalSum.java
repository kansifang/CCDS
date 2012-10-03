package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckOverTotalSum extends Bizlet{

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String dRepaySum = (String)this.getAttribute("RepaySum");
		
		//将空值转化成空字符串
		if(sSerialNo == null) sSerialNo = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		String sReturn = "";
		Double dOtherRepaySum = 0.0,dBusinessSum = 0.0;
		dBusinessSum= Sqlca.getDouble("SELECT Nvl(BusinessSum,0) FROM Business_Contract WHERE SerialNo = '"+sObjectNo+"'");
		if("".equals(sSerialNo)){
			dOtherRepaySum = Sqlca.getDouble(" SELECT nvl(Sum(nvl(RepaySum,0)),0) FROM Repay_Plan WHERE ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"'");
		}
		else{
			dOtherRepaySum =Sqlca.getDouble(" SELECT nvl(Sum(nvl(RepaySum,0)),0) FROM Repay_Plan WHERE ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"'"+
			" and SerialNo <> '"+sSerialNo+"'");
		}
		if((dOtherRepaySum+Double.valueOf(dRepaySum))>dBusinessSum){
			sReturn = "nopass";
		}
		else{
			sReturn = "pass";
		}
		return sReturn;
	}

}
