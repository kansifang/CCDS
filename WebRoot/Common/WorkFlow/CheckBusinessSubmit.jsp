<%
/* Author: zwhu 20100630
 * Tester:
 *
 * Content: 
 * Input Param:
 
 * Output param:
 *				
 * History Log:
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>

<% 
	String sPhaseAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseAction"));//���ϸ�ҳ��õ�����Ķ�����Ϣ
	String sRoleID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RoleID"));
	//����ֵת���ɿ��ַ���
	if(sRoleID == null) sRoleID = "";
	if(sPhaseAction == null) sPhaseAction = "";
	double dReturn = Sqlca.getDouble("select count(*) from user_role where  locate(userid,'"+sPhaseAction+"') >0 and roleid = '"+sRoleID+"'");
	
	
%>
<script language=javascript>	
	self.returnValue = "<%=dReturn%>";
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>