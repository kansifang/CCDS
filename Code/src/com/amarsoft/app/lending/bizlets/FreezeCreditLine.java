package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class FreezeCreditLine extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ	
		String sLineID   = (String)this.getAttribute("LineID");
		String sBCSerialNo   = (String)this.getAttribute("BCSerialNo");
		String sFreezeFlag = (String)this.getAttribute("FreezeFlag");
		
		if(sLineID == null) sLineID = "";
		if(sBCSerialNo == null) sBCSerialNo = "";
		if(sFreezeFlag == null) sFreezeFlag = "";
			   
	    //����CL_INFO�����Ӧ�Ķ����Ϣ
	    Sqlca.executeSQL("update CL_INFO set FreezeFlag = '"+sFreezeFlag+"' where LineID = '"+sLineID+"'");
	    //����BUSINESS_CONTRACT�����Ӧ�Ķ����Ϣ
	    Sqlca.executeSQL("update BUSINESS_CONTRACT set FreezeFlag = '"+sFreezeFlag+"' where SerialNo = '"+sBCSerialNo+"'");
	    //��ֹ�ñ����Ŷ��
	   if("4".equals(sFreezeFlag))
	   {
		   //����BUSINESS_CONTRACT�ж����ֹ
		    Sqlca.executeSQL("update BUSINESS_CONTRACT set FinishDate = '"+StringFunction.getToday()+"' where SerialNo = '"+sBCSerialNo+"'");
	   }
	    return "1";
	    
	 }

}
