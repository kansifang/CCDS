<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-15
 * Tester:
 *
 * Content: ���¸ıʴ���ļ�ֵ׼����
 * Input Param:
 *           AccountMonth  : ����·�
 *           LoanAccount:  ������
 *           Grade:  Ԥ�⼶��  01-�Ŵ�Ա��02��֧�У�03�����У� 04������ �� 05�������϶�Ա�� 06-��ƽ��
 *           UpdFlag: ���±�־ Clear-����Ӧ�ĸü���ļ�ֵ׼������Ϊnull
 * Output param:
 *          00-�ɹ�
 *          01-ʧ��
 *          03-ȱ�ٸ���
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
   		     //��ֵ׼����ʽ����ʧ׼��������=����������Ϣ������X����-�ֽ�������ֵ
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
   		     
   		     if(sUpdFlag.equals("Clear")){//�������ӻ�ɾ��Ԥ���ֽ������ı��ˡ���ʧ׼���������������������Ϊ�գ���Ҫ����ȷ��
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