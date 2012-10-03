<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:  ndeng 2005.03.15
 * Tester:
 *
 * Content: 效验输入的用户编号是否重复
 * Input Param: 
 * 			 UserID：      －所选用户代码。
 * Output param:
 *
 *
 * History Log:  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%  
    String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
    
    
    //判断user_info中是否以后当前的用户编号
    String sSql = "Update FLOW_TASK set EndTime='"+StringFunction.getToday()+"' where SerialNo='"+sSerialNo+"'";
	Sqlca.executeSQL(sSql);	

%>
<script language=javascript>
	
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>


