<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XXGe 2004-11-22
 * Tester:
 * Content: �����ϰ������в����ʼ��Ϣ
 * Input Param:
 *		   
 *  
 * Output param:
 *		��	
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//������š��������͡����е����ϵ�λ
	String 	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String  sLawCaseType= DataConvert.toRealString(iPostChange,(String)request.getParameter("LawCaseType"));
	
	//CaseStatus=001��ʾ�������κ����Ͻ��̡�CasePhase=010��ʾ��ǰ
	String sSql = " insert into LAWCASE_INFO(SerialNo,LawCaseType,CasePhase,CaseStatus,ManageUserID,ManageOrgID,OperateUserID,OperateOrgID,InputUserID,InputOrgID,UpdateDate,InputDate) "+
		          " values('"+sSerialNo+"','"+sLawCaseType+"','010','','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"',"+
		          " '"+ StringFunction.getToday() + "','"+ StringFunction.getToday() + "')";
	Sqlca.executeSQL(sSql);
%>
<script language=javascript>
		self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>