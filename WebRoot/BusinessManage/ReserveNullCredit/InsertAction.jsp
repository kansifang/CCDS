<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-15
 * Tester:
 *
 * Content: ��δ����Ԥ�������ݲ���Ԥ���
 * Input Param:
 * 		  �����ˮ�ţ�	SerialNo
 * 		  �����˺ţ�LoanAccount
 * 		  ����·ݣ�	AccountMonth
 * Output param:
 *        sReturnValue :
 *             sSerialNo-�ü�¼�����
 *             01-ʧ��
 *             02-����
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=gb2312"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow_open
	//��ѯ����
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
    String sReturnValue = "02";
	try{
	   //�жϸñʴ����Ƿ������Ԥ���ֽ�����
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
	       
	       //�жϸñʴ����Ƿ�����ʧ����,���������ʧ������Ԥ���ֽ���
	       /*
	       selSql = "select MClassifyResult,AClassifyResult, (nvl(ExchangeRate, 1) * (nvl(Balance, 0) + nvl(Interest,0))) as RMBBalance  from reserve_record where serialno = '" + sSerialNo + "'";
	       rsSel = Sqlca.getASResultSet(selSql);
	       if(rsSel.next()){
	          String sMClassifyResult = rsSel.getString("MClassifyResult") == null ? "" : rsSel.getString("MClassifyResult");
	          String sAClassifyResult = rsSel.getString("AClassifyResult") == null ? "" : rsSel.getString("AClassifyResult");
	          double dRMBBalance = rsSel.getDouble("RMBBalance");
	          if(sMClassifyResult.equals("05")&& sAClassifyResult.equals("05")){//������������ʧ��05������Ԥ���ֽ���
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
