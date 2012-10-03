/**
 * Author: --zwhu 2010-03-29
 * Tester:                               
 * Describe: --��ȼ��
 * Input Param:                          
 * 		ObjectNo :������  
 * 		ObjectType����������
 * 		LineID����ȱ��
 *      BusinessType��ҵ��Ʒ��
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
    		sMessage.append("�����볬���ò�Ʒ�������@"); 
    	}
    	if(dTermMonth>dCLTermMonth){
    		sMessage.append("���������޳����ò�Ʒ����������ƣ�@");
    	}
    	if("2010".equals(sBusinessType)){
    		if(dBailRatio!=dCLBailRatio)
    		sMessage.append("�����뱣֤�������ò�Ʒ��ȱ�֤���������!@");
    	}
    	System.out.println(sMessage.toString());
		return sMessage.toString();

	}

}
