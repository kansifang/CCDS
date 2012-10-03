/*
		Author: --xhyong 2020/03/03
		Tester:
		Describe: --根据联保小组批量增加信用共同体成员
		Input Param:
							
		Output Param:

		HistoryLog: 
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
public class BatchAddCreditGroup extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//联保小组编号
		String sGroupSerialNo = (String)this.getAttribute("GroupSerialNo");	
		//客户编号
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sInputUserID = (String)this.getAttribute("InputUserID");
		String sInputOrgID = (String)this.getAttribute("InputOrgID");
		
		//将空值转化为空字符串
		if(sGroupSerialNo == null) sGroupSerialNo = "";
		if(sCustomerID == null) sCustomerID = "";
		if(sInputUserID == null) sInputUserID = "";
		if(sInputOrgID == null) sInputOrgID = "";

	    //获得当前时间
	    String sCurDate = StringFunction.getToday();
		String sSql =  " insert into CUSTOMER_RELATIVE(CustomerID,RelativeID,"+
						" CustomerName,CertType,CertID,RelationShip,"+
						" AssureGroupID,InputUserID,InputDate,UpdateDate,InputOrgID) "+
						" select '"+sCustomerID+"',RelativeID,"+
						" CustomerName,CertType,CertID,'0701',"+
						" '"+sGroupSerialNo+"','"+sInputUserID+"','"+sCurDate+"','"+sCurDate+"','"+sInputOrgID+"' "+
								" from CUSTOMER_RELATIVE CR "+
								" where CustomerID='"+sGroupSerialNo+"' "+
								" and RelationShip like '0501%' "+
								" and RelativeID not in(select RelativeID from CUSTOMER_RELATIVE "+
								" where RelativeID=CR.RelativeID and RelationShip='0701' )";
					//执行插入语句
		Sqlca.executeSQL(sSql);
		
		return "1";
	 }
}
