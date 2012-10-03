package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.sql.ASResultSet;


public class UpdateBusinessPigeonhole extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//��ò����������Ŀͻ����ơ�֤�����͡�֤����źʹ�����	
	 	String sContractSerialNo  = (String)this.getAttribute("ContractSerialNo");
		//�������
		String sSql = "";
		ASResultSet rs=null;
		double dTotalPutOutBusinessSum=0.00,dContractBusinessSum=0.00;
		String sBusinessType = "";
			   	
		//��ú�ͬ���,ҵ��Ʒ��
		sSql = " select BusinessSum,BusinessType from BUSINESS_CONTRACT where SerialNo = '"+sContractSerialNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dContractBusinessSum = rs.getDouble("BusinessSum");
			sBusinessType = rs.getString("BusinessType");
			//����ֵת��Ϊ���ַ���		
			if(sBusinessType == null) sBusinessType = "";
		}
		rs.getStatement().close();
		
		//����ǽ�������֤ȡʵ�����Ž��
		if("2050030".equals(sBusinessType))
		{
			//��ú�ͬ���
			sSql = " select PracticeSum from BUSINESS_CONTRACT where SerialNo = '"+sContractSerialNo+"' ";
			dContractBusinessSum = Sqlca.getDouble(sSql);
		}
		
		//����ܳ��˽��
		sSql = " select sum(BusinessSum) from BUSINESS_PUTOUT where ContractSerialNo = '"+sContractSerialNo+"' ";
		dTotalPutOutBusinessSum = Sqlca.getDouble(sSql);
		
	    //����ſ����
		if(dContractBusinessSum==dTotalPutOutBusinessSum)
		{
			sSql = "Update BUSINESS_CONTRACT set PigeonholeDate='"+StringFunction.getToday()+"' where SerialNo='"+sContractSerialNo+"' " ;
		}
	    //ִ�и������
	    Sqlca.executeSQL(sSql);
	    
	    return "Success";
	 }

}
