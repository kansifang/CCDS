package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class FreezeCreditLine extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值	
		String sLineID   = (String)this.getAttribute("LineID");
		String sBCSerialNo   = (String)this.getAttribute("BCSerialNo");
		String sFreezeFlag = (String)this.getAttribute("FreezeFlag");
		
		if(sLineID == null) sLineID = "";
		if(sBCSerialNo == null) sBCSerialNo = "";
		if(sFreezeFlag == null) sFreezeFlag = "";
			   
	    //更新CL_INFO中相对应的额度信息
	    Sqlca.executeSQL("update CL_INFO set FreezeFlag = '"+sFreezeFlag+"' where LineID = '"+sLineID+"'");
	    //更新BUSINESS_CONTRACT中相对应的额度信息
	    Sqlca.executeSQL("update BUSINESS_CONTRACT set FreezeFlag = '"+sFreezeFlag+"' where SerialNo = '"+sBCSerialNo+"'");
	    //终止该笔授信额度
	   if("4".equals(sFreezeFlag))
	   {
		   //更新BUSINESS_CONTRACT中额度终止
		    Sqlca.executeSQL("update BUSINESS_CONTRACT set FinishDate = '"+StringFunction.getToday()+"' where SerialNo = '"+sBCSerialNo+"'");
	   }
	    return "1";
	    
	 }

}
