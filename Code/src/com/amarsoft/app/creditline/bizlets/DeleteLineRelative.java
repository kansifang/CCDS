package com.amarsoft.app.creditline.bizlets;
/*
Author: --jbye 2005-09-01 9:51
Tester:
Describe: --删除授信相关信息
Input Param:
		sLineID：授信协议编号

Output Param:

HistoryLog:
*/

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.app.lending.bizlets.DeleteBusiness;

public class DeleteLineRelative extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值
		String sLineID   = (String)this.getAttribute("LineID");//--文档编号
		if(sLineID==null) sLineID="";
		//定义变量
		String sSql= "",sBCSerialNo = "";
		
		//获取合同流水号
		sBCSerialNo = Sqlca.getString("select BCSerialNo from CL_INFO where LineID = '"+sLineID+"'");
		if(sBCSerialNo == null) sBCSerialNo = "";
		
		System.out.println("---------sBCSerialNo----------"+sBCSerialNo);
		
		//删除授信额度信息
		sSql = 	" update CL_INFO set BCSerialNo = null "+
				" where LineID = '"+sLineID+"' ";
		Sqlca.executeSQL(sSql);
		
	    //删除授信协议信息
		Bizlet bzDeleteBusiness = new DeleteBusiness();
		bzDeleteBusiness.setAttribute("ObjectType","BusinessContract"); 
		bzDeleteBusiness.setAttribute("ObjectNo",sBCSerialNo);
		bzDeleteBusiness.setAttribute("DeleteType","DeleteBusiness");
		bzDeleteBusiness.run(Sqlca);		
			
		return null;
	 }
}
