package com.amarsoft.app.lending.bizlets;
/*
Author: --王业罡 2005-08-03
Tester:
Describe: --删除文档关联信息
Input Param:
		sDocNo：文档编号

Output Param:

HistoryLog:
*/
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class DelDocRelative extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值
		String sDocNo = (String)this.getAttribute("DocNo");//--文档编号
		if(sDocNo == null) sDocNo = "";
		//定义变量
		String sSql = " delete from DOC_RELATIVE where DocNo = '"+sDocNo+"' ";
		Sqlca.executeSQL(sSql);
		sSql = " delete from DOC_ATTACHMENT  where DocNo = '"+sDocNo+"' ";
	    Sqlca.executeSQL(sSql);
	    return null;
	 }
}
