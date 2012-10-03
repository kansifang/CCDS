<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>获得时间</title>

<%
    String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	ASResultSet rs = null;
	String	sReturn	= "";
	String sSql = "select max(accountmonth) as LastAccountMonth from reserve_total where accountmonth<'"+ sAccountMonth +"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sReturn = DataConvert.toString(rs.getString("LastAccountMonth"));
	}
	rs.getStatement().close();
%>

<script language=javascript>
	self.returnValue = "<%=sReturn%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
