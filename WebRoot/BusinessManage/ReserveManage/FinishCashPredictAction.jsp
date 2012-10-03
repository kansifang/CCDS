<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-17
 * Tester:
 *
 * Content: 完成现金流预测提交
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
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sType == null) sType = "";
	String sSql="",updFieldDate="", updFieldUser = "", sLoanAccount="";
	String sFromResultField = "", sToResultField = "",sRightCondi="";
    String sEqualCondition = "";
  	String sReturnValue="";
  	String sGrade = "", sNextGrade = "";

    if(CurUser.hasRole("480")){
       updFieldDate = "FinishDate1";
       updFieldUser = "UserID1";
       sFromResultField = "Result1";
       sToResultField = "Result2";
     }
     //由于录入人员有可能是支行或分行的认定人员，那么他们直接更新本级别的finishdate及userid、result,不需要一级一级走上来
     if(sType.equals("Confirm")){
	     if(CurUser.hasRole("601")){
	       updFieldDate = "FinishDate2";
	       updFieldUser = "UserID2";
	       sFromResultField = "Result2";
	       sToResultField = "Result3";
	       sRightCondi = " and (FinishDate2 is null and userid1 is not null and Result2 <> '')";
	     }else if(CurUser.hasRole("602")){
	       updFieldDate = "FinishDate3";
	       updFieldUser = "UserID3";
	       sFromResultField = "Result3";
	       sToResultField = "Result4";
	       sRightCondi = " and (FinishDate3 is null and userid2 is not null and Result3 <> '')";
	     }else if(CurUser.hasRole("603")){
	       updFieldDate = "FinishDate4";
	       updFieldUser = "UserID4";
	       sFromResultField = "Result4";
	       sToResultField = "MResult";
	       sRightCondi = " and (FinishDate4 is null and userid3 is not null and Result4 <> '')"; 
	     }
     }
	boolean bOldCommit = false;
	try{
	    //更新提交标志
	    bOldCommit = Sqlca.conn.getAutoCommit();
	    Sqlca.conn.setAutoCommit(false);
	    if(sType.equals("Input")){
	    	sSql = "update RESERVE_RECORD  set " + updFieldDate + " = '" + StringFunction.getToday() + "', " +
	  		        updFieldUser + " ='" + CurUser.UserID + "', " +  sToResultField + " = " + sFromResultField +  		
	  		        " where FinishDate1 is null and UserID1 is null and Result1 is not null ";
	  	}else if(sType.equals("Confirm"))
	  	{
	   		sSql = "update RESERVE_RECORD  set " + updFieldDate + " = '" + StringFunction.getToday() + "', " +
	  		        updFieldUser + " ='" + CurUser.UserID + "', " +  sToResultField + " = " + sFromResultField +  		
	  		        " where 1=1 " + sRightCondi;
	    }   	    
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
