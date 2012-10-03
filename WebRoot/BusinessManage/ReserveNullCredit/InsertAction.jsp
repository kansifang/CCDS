<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-15
 * Tester:
 *
 * Content: 将未插入预测表的数据插入预测表
 * Input Param:
 * 		  借据流水号：	SerialNo
 * 		  贷款账号：LoanAccount
 * 		  会计月份：	AccountMonth
 * Output param:
 *        sReturnValue :
 *             sSerialNo-该记录的序号
 *             01-失败
 *             02-存在
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=gb2312"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window_open
	//查询条件
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
    String sReturnValue = "02";
	try{
	   //判断该笔贷款是否插入了预测现金流表
	   boolean bExist = false;
	   String sSerialNo = "";
	   String selSql = "select SerialNo from reserve_record where LoanAccount = '" + sLoanAccount + "'" + 
	                    " and AccountMonth = '" + sAccountMonth + "'";
	   ASResultSet rsSel = Sqlca.getASResultSet(selSql);
	    if(rsSel.next()){
	       sSerialNo = rsSel.getString("SerialNo") == null ? "" : rsSel.getString("SerialNo");
	       if(!sSerialNo.equals("")) {
	          bExist = true;
	          sReturnValue=sSerialNo;
	       }
	    }
	    rsSel.getStatement().close();
        if(!bExist){ 	
	        sSerialNo = DBFunction.getSerialNo("reserve_record", "SerialNo", "", "yyyyMMdd", "000000",new java.util.Date(), Sqlca);
	    	System.out.println("-------------------------------------------"+sSerialNo);
	        String insSql = " insert into reserve_record (SerialNo, LoanAccount, AccountMonth, CustomerName," + 
	                    " ExchangeRate, Currency, BusinessSum, Manageuserid, " +
	                    " Balance,BusinessFlag ) " + 
	                    " select '" + sSerialNo + "', AssetNo, AccountMonth, DebtorName," +
	                    " ExchangeRate, AccountCurrency, AccountSum, Manageuserid, " +
	                    " Balance,'3' from Reserve_Nocredit where AssetNo = '" + sLoanAccount + "'" + 
	                    " and AccountMonth = '" + sAccountMonth + "'";
	       Sqlca.executeSQL(insSql);
	       
	       //判断该笔贷款是否是损失贷款,，如果是损失类贷款，不预测现金流
	       /*
	       selSql = "select MClassifyResult,AClassifyResult, (nvl(ExchangeRate, 1) * (nvl(Balance, 0) + nvl(Interest,0))) as RMBBalance  from reserve_record where serialno = '" + sSerialNo + "'";
	       rsSel = Sqlca.getASResultSet(selSql);
	       if(rsSel.next()){
	          String sMClassifyResult = rsSel.getString("MClassifyResult") == null ? "" : rsSel.getString("MClassifyResult");
	          String sAClassifyResult = rsSel.getString("AClassifyResult") == null ? "" : rsSel.getString("AClassifyResult");
	          double dRMBBalance = rsSel.getDouble("RMBBalance");
	          if(sMClassifyResult.equals("05")&& sAClassifyResult.equals("05")){//审计与管理都是损失（05），不预测现金流
	             String updSql = "update reserve_record set result1 = " + dRMBBalance + " , result2= " + dRMBBalance +
	              ", result3= " + dRMBBalance + ", result4 = " + dRMBBalance + ", mresult= " + dRMBBalance  + ", Aresult = " + dRMBBalance + 
	             " where serialno = '" + sSerialNo + "'";
	             Sqlca.executeSQL(updSql);
	          }
	       }
	       rsSel.getStatement().close();
	       */
		   sReturnValue=sSerialNo;
		}
	}catch(Exception e){
		sReturnValue = "01";
		System.out.println(e.toString());
    }
%>
<script language=javascript>
	self.returnValue="<%=sReturnValue%>";
	self.close();   
</script>
<%@ include file="/IncludeEnd.jsp"%>
