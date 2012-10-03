package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetLowRiskFlag extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		// TODO Auto-generated method stub
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		
		if(sObjectNo==null)sObjectNo="";
		if(sObjectType==null)sObjectType="";
		
		String sSql = "";
		String sLowRiskFlag = "2";
		//如果为申请信息
		if("Apply".equals(sObjectType)) {
			sSql = "select LowRisk from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'";
			sLowRiskFlag = Sqlca.getString(sSql);
			if(sLowRiskFlag==null)sLowRiskFlag="2";
		}else if("Contract".equals(sObjectType))
		{
			sSql = "select LowRisk from BUSINESS_CONTRACT where SerialNo='"+sObjectNo+"'";
			sLowRiskFlag = Sqlca.getString(sSql);
			if(sLowRiskFlag==null)sLowRiskFlag="2";
		}else if("PutOut".equals(sObjectType))
		{
			sSql = "select LowRisk from BUSINESS_CONTRACT where SerialNo=" +
				"(select ContractSerialNo from BUSINESS_PUTOUT where SerialNo='"+sObjectNo+"')";
			sLowRiskFlag = Sqlca.getString(sSql);
			if(sLowRiskFlag==null)sLowRiskFlag="2";
		}
		return sLowRiskFlag;
	}

}
