<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.8
		Tester:
		Content: ��ͬ�������ݴ���
		Input Param:
			                BusinessType:ҵ��Ʒ��
			                SerialNo:��ͬ��ˮ��
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>��ͬ�������ݴ���</title>
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