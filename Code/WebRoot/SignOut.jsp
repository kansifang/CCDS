<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sTempNow = StringFunction.getToday()+" "+StringFunction.getNow();
	CurPref.setUserPreference(Sqlca,"LastSignOutTime",sTempNow);
%>
<script language="javascript">
		window.open("<%=sWebRootPath%>/SessionOut.jsp?rand="+randomNumber(),"_self");
</script>
<%@ include file="/IncludeEnd.jsp"%>