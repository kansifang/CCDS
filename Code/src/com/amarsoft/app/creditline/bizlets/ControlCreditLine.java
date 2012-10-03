/**
 * Author: --zwhu 2010-03-29
 * Tester:                               
 * Describe: --额度检查
 * Input Param:                          
 * 		ObjectNo :对象编号  
 * 		ObjectType：对象类型
 * 		LineID：额度编号
 *      BusinessType：业务品种
 * Output Param:   
 * 		sMessage             
 * HistoryLog:                           
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ControlCreditLine extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String sBAAgreement = (String)this.getAttribute("BAAgreement");   
		String sBusinessType = (String)this.getAttribute("BusinessType"); 
        double dTermMonth = Double.valueOf((String)this.getAttribute("TermMonth"));
        double dBailRatio = Double.valueOf((String)this.getAttribute("BailRatio"));
        double dBusinessSum = Double.valueOf((String)this.getAttribute("BusinessSum"));
        String sObjectNo = (String)this.getAttribute("ObjectNo");       
        if(sObjectNo == null) sObjectNo = "";
        if(sBAAgreement == null) sBAAgreement = "";
        if(sBusinessType == null) sBusinessType = "";
    	StringBuffer sMessage = new StringBuffer("");
    	double dCLBusinessSum = 0,dCLTermMonth=0 ,dCLBailRatio = 0;
    	double dTotalBusinessSum = Sqlca.getDouble(" select sum(nvl(BusinessSum,0)*getErate(BusinessCurrency,'01',ERateDate)) as TotalBusinessSum "+
    				  " from business_apply  where BAAgreement ='"+sBAAgreement+"' and BusinessType = '"+sBusinessType+"'"+
    				  " and SerialNo <> '"+sObjectNo+"'");
    	String sSql = " select nvl(LineSum1,0)*getErate(Currency,'01',ERateDate) as LineSum,TermMonth,BailRatio "+
    				  " from CL_INFO where ApplySerialNo ='"+sBAAgreement+"' and BusinessType ='"+sBusinessType+"'" ;
    	ASResultSet rs = Sqlca.getASResultSet(sSql);
    	if(rs.next()){
    		dCLBusinessSum = rs.getDouble("LineSum");
    		dCLTermMonth = rs.getDouble("TermMonth");
    		dCLBailRatio = rs.getDouble("BailRatio");
    	}
    	rs.close();
    	System.out.println(dTotalBusinessSum+dBusinessSum+":"+dCLBusinessSum+":"+dTermMonth+":"+dCLTermMonth);
    	if(dTotalBusinessSum+dBusinessSum>dCLBusinessSum){
    		sMessage.append("该申请超过该产品额度限制@"); 
    	}
    	if(dTermMonth>dCLTermMonth){
    		sMessage.append("该申请期限超过该产品额度期限限制！@");
    	}
    	if("2010".equals(sBusinessType)){
    		if(dBailRatio!=dCLBailRatio)
    		sMessage.append("该申请保证金比例与该产品额度保证金比例不等!@");
    	}
    	System.out.println(sMessage.toString());
		return sMessage.toString();

	}

}
