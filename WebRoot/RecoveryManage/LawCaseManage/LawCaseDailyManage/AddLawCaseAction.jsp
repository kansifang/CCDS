<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XXGe 2004-11-22
 * Tester:
 * Content: 在诉讼案件表中插入初始信息
 * Input Param:
 *		   
 *  
 * Output param:
 *		无	
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//案件编号、案件类型、我行的诉讼地位
	String 	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String  sLawCaseType= DataConvert.toRealString(iPostChange,(String)request.getParameter("LawCaseType"));
	
	//CaseStatus=001表示不属于任何诉讼进程、CasePhase=010表示诉前
	String sSql = " insert into LAWCASE_INFO(SerialNo,LawCaseType,CasePhase,CaseStatus,ManageUserID,ManageOrgID,OperateUserID,OperateOrgID,InputUserID,InputOrgID,UpdateDate,InputDate) "+
		          " values('"+sSerialNo+"','"+sLawCaseType+"','010','','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"',"+
		          " '"+ StringFunction.getToday() + "','"+ StringFunction.getToday() + "')";
	Sqlca.executeSQL(sSql);
%>
<script language=javascript>
		self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>