<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: xhyong 2009/12/03
 * Tester:
 * Content: �ڵ�ծ�ʲ�̨����������ծ�ʲ���Ϣ
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
	//��ծ������ˮ��
	String 	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	//
	String sSql = " insert into BADBIZ_APPLY (InputDate,ApplyDate,OperateDate,"+
					" ApplyType,InputUserID,SerialNo,OperateUserID,TempSaveFlag,"+
					" OccurDate,InputOrgID,OperateOrgID,UpdateDate,ManageUserID,ManageOrgID,ManageFlag)"+
				" values ('"+StringFunction.getToday()+"','"+StringFunction.getToday()+"',"+
						" '"+StringFunction.getToday()+"','010','"+CurUser.UserID+"','"+sSerialNo+"',"+
						" '"+CurUser.UserID+"','1','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"',"+
						" '"+CurOrg.OrgID+"','"+StringFunction.getToday()+"','"+CurUser.UserID+"',"+
						" '"+CurOrg.OrgID+"','030')";
	Sqlca.executeSQL(sSql);
%>
<script language=javascript>
		self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>