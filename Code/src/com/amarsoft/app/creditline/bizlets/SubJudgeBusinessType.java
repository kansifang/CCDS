/**
 * Author: --jbye 2005-08-31 17:57            
 * Tester:                               
 * Describe: --判断产品是否符合限制条件  
 * Input Param:                          
 * 		ObjectType: 对象类型          
 * 		ObjectNo: 对象编号 
 * 		LimitationSetID : 授信限制组ID
 *      LineID : 授信ID
 * Output Param:                         
 * 		sErrorLog：返回错误信息          
 * HistoryLog:                           
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.DataConvert;

public class SubJudgeBusinessType extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sObjectNo = (String)this.getAttribute("ObjectNo");
        String sObjectType = (String)this.getAttribute("ObjectType");
        String sLimitationSetID = (String)this.getAttribute("LimitationSetID");
        String sLineID = (String)this.getAttribute("LineID");
		
        if(sObjectNo==null) sObjectNo = "";
        if(sObjectType==null) sObjectType = "";
        if(sLimitationSetID==null) sLimitationSetID = "";
        if(sLineID==null) sLineID = "";
        
        String sRelativeTable = "",sBusinessType = "",sLimitationID = "",sSubBalance = "";
		String sSql = "";
        String sErrorLog = "";//返回日志
        double dSubBusinessSum = 0.0,dSubBalance = 0.0;
        ASResultSet rs=null;
        
        //根据对象类型确定对应的业务判断主体
        if(sObjectType.equals("CreditApply"))	sRelativeTable = "BUSINESS_APPLY";
        else if(sObjectType.equals("AgreeApproveApply"))	sRelativeTable = "BUSINESS_APPROVE";
        else if(sObjectType.equals("BusinessContract"))	sRelativeTable = "BUSINESS_CONTRACT";
        
        //判断一：取得当前业务品种、申请敞口金额信息，如果没有表示 该业务品种不属于对应授信范围
        sSql = "select BusinessType,((case when BusinessSum is null then 0 else BusinessSum end)-(case when BailSum is null then 0 else BailSum end))*getERate(BusinessCurrency,'01',ERateDate) "+
        	 " from "+sRelativeTable+" where  SerialNo='"+sObjectNo+"'";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
		{ 
        	sBusinessType = rs.getString("BusinessType");
        	dSubBusinessSum = rs.getDouble(2);
		}else	sErrorLog = "ErrorType=NOFOUND_BUSINESSAPPLY";
        rs.getStatement().close();
        //判断一结束
        
        //判断二开始：取得对应限制条件的条件ID，判断是否满足余额限制
        sSql = "select LimitationID from CL_LIMITATION where  LimitationSetID='"+sLimitationSetID+"' " +
        		" and LimObjectNo='"+sBusinessType+"'";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
        { 
        	sLimitationID = rs.getString("LimitationID");//授信敞口金额
        	//取得对应限制条件的可用余额
            Bizlet SubLineBalance2 = new GetCreditLine2Balance_Sub();
            SubLineBalance2.setAttribute("LimitationID",sLimitationID); 
            SubLineBalance2.setAttribute("LineID",sLineID); 
            SubLineBalance2.setAttribute("WhereClause"," and BusinessType = '"+sBusinessType+"'"); 
            sSubBalance = (String)SubLineBalance2.run(Sqlca);
            dSubBalance = DataConvert.toDouble(sSubBalance);
            
            //如果对象授信金额超过对应限制条件的可用余额则返回 不通过 标志为 ： EX_SUB_CURRENCY
            if(dSubBusinessSum>dSubBalance) sErrorLog = "ErrorType=EX_SUB_BUSINESSTYPE";
       	}else sErrorLog = "ErrorType=EX_SUB_BUSINESSTYPE_NF";
        rs.getStatement().close();
        //判断二结束
        return sErrorLog;

	}

}
