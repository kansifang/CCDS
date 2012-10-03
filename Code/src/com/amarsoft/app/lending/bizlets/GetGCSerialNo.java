/*
		Author: --cyyu 2009-03-26
		Tester:
		Describe: --���û�ͣ�����˵���Ŀ
		Input Param:
				ItemNo: ��Ŀ���
				IsInUse: ʹ��״̬
				Flag����־
		Output Param:
				sReturn��������ʾ
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import java.text.DecimalFormat;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetGCSerialNo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//��ͬ��ˮ��
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyType = (String)this.getAttribute("GuarantyType");
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyType == null) sGuarantyType = "";
		String sGCType = "";
		String sGCSerialNo = "";
		double index = 0;//������ 
		
		if(sGuarantyType.equals("050"))//��Ѻ
			sGCType ="2";
		else if(sGuarantyType.equals("060"))//��Ѻ
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
