<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.8
		Tester:
		Content: 合同补登数据处理
		Input Param:
			                BusinessType:业务品种
			                SerialNo:合同流水号
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>合同补登数据处理</title>
<%
	String sSql;
	String sSerialNo="",sBusinessType="";	
	ASResultSet rs = null;
	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));	
	sBusinessType = DataConvert.toRealString(iPostChange,(String)request.getParameter("BusinessType"));	
	String sToday = StringFunction.getToday();
	
	sSql = 	" Update BUSINESS_CONTRACT set BusinessType = '"+sBusinessType+"',"+
			" InputDate ='"+StringFunction.getToday()+"', "+		
			" InputOrgID ='"+CurOrg.OrgID+"', "+
			" InputUserID ='"+CurUser.UserID+"', "+
			" UpdateDate ='"+sToday+"', "+
			" PigeonholeDate ='"+sToday+"' "+
			" where SerialNo = '"+sSerialNo+"'";
	Sqlca.executeSQL(sSql);
%>
<script language=javascript>
	self.returnValue = "succeed";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>