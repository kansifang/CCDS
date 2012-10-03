<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 2009.11.19
		Tester:
		Content: 插入检查表
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>贷款用途检查客户信息</title>
<%
	String sSql;
	String sSerialNo="";	
	ASResultSet rs = null;
	String sObjectNo=DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sCheckFrequency=DataConvert.toRealString(iPostChange,(String)request.getParameter("CheckFrequency"));	
	if(sObjectNo==null) sObjectNo="";
	if(sCheckFrequency == null) sCheckFrequency = "";
	int iCount =0;
	sSerialNo = DBFunction.getSerialNo("CHECK_FREQUENCY","SerialNo",Sqlca);
	sSql = " select count(customerID) from CHECK_FREQUENCY where customerID = '"+sObjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		iCount = rs.getInt(1);
	}
	rs.getStatement().close();
	if(iCount == 0){
		sSql = "insert into CHECK_FREQUENCY(CustomerID,InputUserID,SerialNo,CheckFrequency) "+
				"values('"+sObjectNo+"','"+CurUser.UserID+"','"+sSerialNo+"','"+sCheckFrequency+"')";
	}
	else{
		sSql = "update CHECK_FREQUENCY set CheckFrequency = '"+sCheckFrequency+"',FinishFrequencyDate='' where CustomerID='"+sObjectNo+"'";
	}
	
	Sqlca.executeSQL(sSql);

	sSql = " update CHECK_Frequency  set  FinishFrequencyDate='"+StringFunction.getToday()+"' where CustomerID='"+sObjectNo+"'";
	Sqlca.executeSQL(sSql);
%>
<script language=javascript>
	self.returnValue = "<%=sSerialNo%>";
	//alert(<%=sSerialNo%>);
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>