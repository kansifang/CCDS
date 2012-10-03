/*
		Author: --cyyu 2009-03-26
		Tester:
		Describe: --启用或停用主菜单项目
		Input Param:
				ItemNo: 项目编号
				IsInUse: 使用状态
				Flag：标志
		Output Param:
				sReturn：返回提示
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import java.text.DecimalFormat;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetGCSerialNo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//合同流水号
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyType = (String)this.getAttribute("GuarantyType");
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyType == null) sGuarantyType = "";
		String sGCType = "";
		String sGCSerialNo = "";
		double index = 0;//计数器 
		
		if(sGuarantyType.equals("050"))//抵押
			sGCType ="2";
		else if(sGuarantyType.equals("060"))//质押
			sGCType ="3";
		else
			sGCType ="1";
		index = Sqlca.getDouble("select count(*) from Contract_Relative where ObjectType = 'GuarantyContract' and SerialNo = '"+sContractNo+"'");
		index++;
		DecimalFormat decimalformat = new DecimalFormat("00");
		while(true){
			sGCSerialNo = sContractNo+sGCType+decimalformat.format(index);
			double dCount = Sqlca.getDouble("select count(*) from Guaranty_Contract where SerialNo = '"+sGCSerialNo+"'");
			if(dCount >0) index++;
			else break;
		}	
		return sGCSerialNo;
	}

}
