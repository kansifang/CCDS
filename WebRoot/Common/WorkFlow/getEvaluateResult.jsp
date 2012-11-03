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
	
	String sNewEvaluateResult ="",sNewCognResult="";
	String sIsInuse="";
	String sNewEvaluateSerialNo="";
	double dNewEvaluateScore=0.0,dNewCognScore=0.0;
	sIsInuse = Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
	if (sIsInuse== null) sIsInuse="" ;
	sSql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='Customer' "+
    	   " and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth desc,SerialNo desc fetch first 1 rows only ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sEvaluateSerialNo = rs.getString("SerialNo");
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
	if(sIsInuse.equals("2"))
	{
		sSql = " select SerialNo,EvaluateScore,EvaluateResult,CognScore,CognResult from Evaluate_Record where ObjectType ='NewEvaluate' "+
		   " and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth  desc,SerialNo desc fetch first 1 rows only ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sNewEvaluateSerialNo = rs.getString("SerialNo");
			dNewEvaluateScore    = rs.getDouble("EvaluateScore");
			sNewEvaluateResult   = rs.getString("EvaluateResult");
			dNewCognScore        = rs.getDouble("CognScore");
			sNewCognResult       = rs.getString("CognResult");
			if(sNewEvaluateSerialNo == null) sNewEvaluateSerialNo ="";
			if(sNewEvaluateResult == null) sNewEvaluateResult ="";
			if(sNewCognResult == null) sNewCognResult ="";
			if(sEvaluateSerialNo.equals("") || sNewEvaluateSerialNo.equals(""))
			{
				Retrun = "";
			}else
			{
				Retrun = dNewEvaluateScore+"@"+sNewEvaluateResult+"@"+dNewCognScore+"@"+sNewCognResult;
			}
		}
		rs.getStatement().close();
	}
	
	
	

%>
<script language=javascript>	
	self.returnValue = "<%=Retrun%>";
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>