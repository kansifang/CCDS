<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: CChang 2003.8.28
 * Tester:
 *
 * Content: ��ʾ��һ�׶���Ϣ 
 * Input Param:
 * 				SerialNo��	��ǰ�������ˮ��
 * Output param:
 *				sReturnValue:	����ֵCommit��ʾ��ɲ���
 * History Log:
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>
<% 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));//���ϸ�ҳ��õ������������ˮ��
	String sReturnMessage = "";//ִ�к󷵻ص���Ϣ
	
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);//��ʼ���������
	//ftBusiness.cancel(CurUser);//ִ���˻ز���
	sReturnMessage = ftBusiness.cancel(CurUser).ReturnMessage;	
%>
<script language=javascript>	
	if("<%=sReturnMessage%>" == "�˻����")
		self.returnValue = "Commit";
	else
		self.returnValue = '<%=sReturnMessage%>';
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>