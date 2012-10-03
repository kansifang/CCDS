<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-19
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

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window_open
	//查询条件
	String sBusinessFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessFlag"));
	String sEqualRightCondi = "";
	String sEqualRightCondi = "";
	String sRightCondi = "";
	String sSql="",updFieldDate="", updFieldResult = "",sLoanAccount="", sAccountMonth="",updFieldUser="";
	ASResultSet rs1=null;
	if(sRightCondi == null) sRightCondi = "";
	String sEqualCondition = "";
  	String sReturnValue="";
  	String sGrade = "", sNextGrade = "";
  	 
     if(CurUser.hasRole("601")){
       updFieldDate = "FinishDate1";
       updFieldUser = "UserID1";
       updFieldResult = "Result2";
       sEqualRightCondi = "  and (FinishDate2 is null and userid1 is not null)"; 
       sRightCondi =" and (RR.FinishDate2 is null and RR.userid1 is not null)";
     }else if(CurUser.hasRole("602")){
       updFieldDate = "FinishDate2";
       updFieldUser = "UserID2";
       updFieldResult = "Result3";
       sRightCondi = " and (RR.FinishDate3 is null and RR.userid2 is not null)";
	   sEqualRightCondi = " and (FinishDate3 is null and userid2 is not null)";
     }else if(CurUser.hasRole("603")){
       updFieldDate = "FinishDate3";
       updFieldUser = "UserID3";
       updFieldResult = "Result4";
       sRightCondi = " and (RR.FinishDate4 is null and RR.userid3 is not null)";
	   sEqualRightCondi = " and (FinishDate4 is null and userid3 is not null)";
     }else if(CurUser.hasRole("604")){
       updFieldDate = "FinishDate4";
       updFieldUser = "UserID4";
       updFieldResult = "MResult";
       sRightCondi = " and (RR.MResult is not null and RR.MFinishdate is null and RR.UserID4 is not null)";
	   sEqualRightCondi = " and (MResult is not null and MFinishdate is null and UserID4 is not null)";
     }
	boolean bOldCommit = false;
	try{
	    //更新提交标志
	    bOldCommit = Sqlca.conn.getAutoCommit();
	    Sqlca.conn.setAutoCommit(false);
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
	    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	    //删除下一级预测现金流
	    String delSql = " delete from reserve_predictdata " + 
	                    " where Grade = '" + sGrade + "'" ; 
	                    " and exists (select * from Reserve_Record RR where RR.LoanAccount = RP.LoanAccount and RR.BusinessFlag = '" + sBusinessFlag +  "')";	                        
        Sqlca.executeSQL(delSql);
 		System.out.println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        //将标志置为原状态
  		sSql = "update RESERVE_RECORD  set " + updFieldDate + " = null, " + updFieldUser + " = null," +  updFieldResult + " = '' where 1=1 " + sEqualRightCondi;
	    Sqlca.executeSQL(sSql);

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
