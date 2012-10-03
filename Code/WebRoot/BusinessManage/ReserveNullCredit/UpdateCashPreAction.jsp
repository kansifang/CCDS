<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-15
 * Tester:
 *
 * Content: 更新改笔贷款的减值准备金
 * Input Param:
 *           AccountMonth  : 会计月份
 *           LoanAccount:  贷款编号
 *           Grade:  预测级别  01-信贷员，02－支行，03－分行， 04－总行 ， 05－最终认定员， 06-审计结果
 *           UpdFlag: 更新标志 Clear-将对应的该级别的减值准备设置为null
 * Output param:
 *          00-成功
 *          01-失败
 *          03-缺少附件
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));
	String sUpdFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UpdFlag"));
	
	String sSql="";
	String sReturnValue="";
	if(sLoanAccount==null) sLoanAccount = "";
	if(sUpdFlag==null) sUpdFlag = "";

	try
	{
        sSql =  " select sum(DiscountValue) from reserve_predictdata " + 
               " where LoanAccount = '"+sLoanAccount+"'" + 
     		   " and Grade = '" + sGrade + "'";
   		 ASResultSet rs = Sqlca.getASResultSet(sSql);
   		 if(rs.next()){
   		 
   		     String updField = "";
   		     double dDiscountValue = rs.getDouble(1);
   		     if(sGrade.equals("01")){
   		       updField = "Result1";
   		     }else if(sGrade.equals("02")){
   		       updField = "Result2";
   		     }else if(sGrade.equals("03")){
   		       updField = "Result3";
   		     }else if(sGrade.equals("04")){
   		       updField = "Result4";
   		     }else if(sGrade.equals("05")){
   		       updField = "AResult";
   		     }
   		     System.out.println(sLoanAccount+"--------------------------"+sAccountMonth);
   		     double dRMBBalance = 0.0;
   		     String s1 = "select (nvl(Balance,0))* nvl(ExchangeRate, 1) as RMBBalance from reserve_nocredit where AssetNo = '"+sLoanAccount+"' and AccountMonth = '" + sAccountMonth + "'" ;
   		     ASResultSet r1 = Sqlca.getASResultSet(s1);
   		     if(r1.next()){
   		        dRMBBalance = r1.getDouble("RMBBalance");
   		     }
   		     System.out.println("++++++++++++++++++++++++++++++++++++++");
   		     r1.getStatement().close();
   		     //减值准备公式：损失准备测算结果=（贷款余额＋利息调整）X汇率-现金流折现值
   		     String updSql = "";
   		     if(CurUser.hasRole("604"))
   		     {
   		     	updSql = "update RESERVE_RECORD  set AFinishdate = '" + StringFunction.getToday() + "', " +
	  		           " AUserID='" + CurUser.UserID + "', " +  updField + " = " + (dRMBBalance - dDiscountValue) + " where 1=1 "+
					   " and LoanAccount = '"+sLoanAccount+"' and AccountMonth = '" + sAccountMonth + "'" ;
   		     }else{
   		     	updSql = "Update Reserve_Record set " + updField + " = " +  (dRMBBalance - dDiscountValue) + 
   		          				" where LoanAccount = '"+sLoanAccount+"' and AccountMonth = '" + sAccountMonth + "'" ;
   		     }
   		     
   		     if(sUpdFlag.equals("Clear")){//由于增加或删除预测现金流，改变了”损失准备测算结果“结果，故设置为空，需要重新确认
   		     	updSql = "Update Reserve_Record set " + updField + " = 0 " + 
   		          " where LoanAccount = '"+sLoanAccount+"' and AccountMonth = '" + sAccountMonth + "'" ;
   		     }
   		     
   		     System.out.println(updSql);
   		    
   		     Sqlca.executeSQL(updSql);
   		 }
	     rs.getStatement().close(); 
	     sReturnValue = "00";
    }catch(Exception ex){
	    sReturnValue = "01";
		System.out.println(ex.getMessage());
	}
%>
<script language=javascript>
	alert("<%=sReturnValue%>");
    self.returnValue = "<%=sReturnValue%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>