<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: 客户信息检查
		Input Param:
			                
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>预警信号风险提示</title>
<%
	String sActionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ActionType"));
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
	//out.println("sSerialNo:"+sSerialNo);
	if(sActionType.equals("Delete"))
	{		
		Sqlca.executeSQL("delete from RISK_SIGNAL where SerialNo='"+sSerialNo+"'");
	}
	else if(sActionType.equals("Add"))
	{
		String sRemark = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Remark"));
		String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SignalStatus"));

		String Today=StringFunction.getToday();

		String sSql="update RISK_SIGNAL set InputOrgID='"+CurUser.OrgID+"',InputUserID='"+CurUser.UserID+"',InputDate='"+Today+"',UpdateDate='"+Today+"',Remark='"+sRemark+"',SignalStatus='"+sSignalStatus+"'"+
		" where SerialNo='"+sSerialNo+"'";

		Sqlca.executeSQL(sSql);		
	}
%>
<script language=javascript>
	self.returnValue = "ok";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>