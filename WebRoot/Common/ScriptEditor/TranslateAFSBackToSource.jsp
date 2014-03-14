<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.finance.*" %>
<%
	String sScriptText = CurPage.getParameter("AFScriptSourceAfterEdit");
if (sScriptText==null) sScriptText="";
sScriptText = StringFunction.replace(sScriptText,"$[wave]","~");
sScriptText = Report.transExpression(1,sScriptText.trim(),Sqlca);
sScriptText = SpecialTools.real2Amarsoft(sScriptText);
%>


<script language="javascript">
self.returnValue=real2Amarsoft('<%=sScriptText%>');
self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>