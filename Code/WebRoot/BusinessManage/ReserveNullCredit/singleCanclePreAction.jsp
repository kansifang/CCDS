<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-17
 * Tester:
 *
 * Content: 完成现金流预测撤销
 * Input Param:
 * 		  借据流水号：	SerialNo
 * 		 
 * 		  会计月份：	AccountMonth
 * Output param:
 *        sReturnValue :
 *             00-成功
 *             01-失败
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=gb2312"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window_open
	//查询条件
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sSql="",updFieldDate="", updFieldUserID = "", updFieldResult = "", sLoanAccount="", sAccountMonth="";

  	String sReturnValue="";
  	String sGrade = "", sNextGrade = "";
  	
  	//获取贷款号及会计月份
  	String stemp = "select LoanAccount, AccountMonth from reserve_record where serialno = '" + sSerialNo + "'";
  	ASResultSet rsTemp = Sqlca.getASResultSet(stemp);
    if(rsTemp.next()){
        sLoanAccount = rsTemp.getString("LoanAccount")==null ? "" :rsTemp.getString("LoanAccount");
        sAccountMonth = rsTemp.getString("AccountMonth")==null ? "" :rsTemp.getString("AccountMonth");
    }
    rsTemp.getStatement().close();
  
    if(CurUser.hasRole("601")){
       updFieldDate = "FinishDate1";
       updFieldUserID = "UserID1";
       updFieldResult = "Result2";
     }else if(CurUser.hasRole("602")){
       updFieldDate = "FinishDate2";
       updFieldUserID = "UserID2";
       updFieldResult = "Result3";
     }else if(CurUser.hasRole("603")){
       updFieldDate = "FinishDate3";
       updFieldUserID = "UserID3";
       updFieldResult = "Result4";
     }else if(CurUser.hasRole("604")){
       updFieldDate = "FinishDate4";
       updFieldUserID = "UserID4";
       updFieldResult = "MResult";
     }
	boolean bOldCommit = false;
	try{
	    //更新提交标志
	    bOldCommit = Sqlca.conn.getAutoCommit();
	    Sqlca.conn.setAutoCommit(false);
  		if(CurUser.hasRole("604"))
	    {
	    	sSql = "update RESERVE_RECORD  set " + updFieldDate + " = null, " +updFieldUserID + " = null, "+  updFieldResult + " = '' ,AResult = ''  where 1=1 "+
				   " and SerialNo ='"+sSerialNo+"'";
	    }
	    else
	    {
  			sSql = "update RESERVE_RECORD  set " + updFieldDate + " = null, " +updFieldUserID + " = null, "+  updFieldResult + " = '' where 1=1 "+
				   " and SerialNo ='"+sSerialNo+"'";
		}
	    Sqlca.executeSQL(sSql);
	    if(updFieldDate.equals("FinishDate1")){
	       sGrade ="02";
	    }
	    if(updFieldDate.equals("FinishDate2")){
	       sGrade ="03";
	    }
	    if(updFieldDate.equals("FinishDate3")){
	       sGrade ="04";
	    }
	    if(updFieldDate.equals("FinishDate4")){
	       sGrade ="05";
	    }
	    //删除下一级预测现金流
	    String delSql = "delete from reserve_predictdata where LoanAccount = '" + sLoanAccount + "'" + 
	                       // " and AccountMonth = '" + sAccountMonth + "'" + 
	                        " and Grade = '" + sGrade + "'";
        Sqlca.executeSQL(delSql);

	    Sqlca.conn.commit();
	    Sqlca.conn.setAutoCommit(bOldCommit);
		sReturnValue="00";
	}catch(Exception e){
	    Sqlca.conn.rollback();
	    Sqlca.conn.setAutoCommit(bOldCommit);
		sReturnValue = "01";
		System.out.println(e.toString());
    }
%>
<script language=javascript>
	self.returnValue="<%=sReturnValue%>";
	self.close();   
</script>
<%@ include file="/IncludeEnd.jsp"%>
