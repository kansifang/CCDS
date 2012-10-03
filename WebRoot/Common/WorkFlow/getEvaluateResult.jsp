<%
/* Author: 2010-4-27 lpzhang
 * Tester:
 *

 * History Log:
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<% 
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));//客户编号

	//将空值转化成空字符串
	if(sCustomerID == null) sCustomerID = "";
	String sSql ="";
	ASResultSet rs = null;
	String sEvaluateResult ="",sEvaluateSerialNo="",sCognResult="",Retrun="";
	double dEvaluateScore=0.0,dCognScore=0.0;
	
	sSql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='Customer' "+
    	   " and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth  desc fetch first 1 rows only ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		dEvaluateScore    = rs.getDouble("EvaluateScore");
		sEvaluateResult   = rs.getString("EvaluateResult");
		dCognScore        = rs.getDouble("CognScore");
		sCognResult       = rs.getString("CognResult");
		if(sEvaluateSerialNo == null) sEvaluateSerialNo ="";
		if(sEvaluateResult == null) sEvaluateResult ="";
		if(sCognResult == null) sCognResult ="";
		Retrun = dEvaluateScore+"@"+sEvaluateResult+"@"+dCognScore+"@"+sCognResult;
	}
	rs.getStatement().close();
	
	
	

%>
<script language=javascript>	
	self.returnValue = "<%=Retrun%>";
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>