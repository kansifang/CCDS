package com.amarsoft.app.lending.bizlets;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishInspectAction extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sCustomerID = (String)this.getAttribute("CustomerID");
		
		if(sCustomerID == null) sCustomerID = "";
		
		//定义变量
		String sSql = "";
		int iCheckFrequency = 0;
		String sCheckFrequency = "";
		ASResultSet rs = null;
		String sToDay = StringFunction.getToday();
		String sNextChectTime = ""; 
		sSql = "select CheckFrequency from CHECK_Frequency where customerID = '"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sCheckFrequency = rs.getString(1);
		}
		rs.getStatement().close();
		if(sCheckFrequency == null ) sCheckFrequency="0";
		iCheckFrequency = Integer.parseInt(sCheckFrequency);		
		if(iCheckFrequency != 0){
			sNextChectTime = StringFunction.getRelativeDate(sToDay,iCheckFrequency);	
			sSql =  " update CHECK_Frequency set NextCheckTime='"+sNextChectTime+"' where CustomerID ='"+sCustomerID+"'" ;
			Sqlca.executeSQL(sSql);
		}					
		return "1";
	}

}
