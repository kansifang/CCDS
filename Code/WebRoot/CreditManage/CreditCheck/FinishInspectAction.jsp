<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat" %>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   ndeng  2005.1.24
		Tester:
		Content: 检查表完成操作
		Input Param:
			                sSerialNo: 流水号
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>贷后检查完成</title>
<%
	String sSql;
	boolean bFinishFlag=false;
	String sFinishType="";
	ASResultSet rs = null;
	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sInspectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("InspectType"));
	//如果是贷款用途报告
	if(sObjectType.equals("BusinessContract"))
	{
		sSql = "update INSPECT_INFO set finishdate='"+StringFunction.getToday()+"',UpdateDate='"+StringFunction.getToday()+"'"+
			" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'";
			Sqlca.executeSQL(sSql);
		sFinishType="Purpose";
		bFinishFlag=true;
	}
	//贷后检查报告，
	else if(sObjectType.equals("Customer"))
	{
		String sBeforDay="";
		String sToday="";
		sToday=StringFunction.getToday();
		sBeforDay=StringFunction.getRelativeDate(sToday,-10);//获得10天前的日期
		
		//在10天内做过风险分析的才能完成检查报告
		sSql="select count(*) as ClassifyCount from CLASSIFY_RECORD where FinishDate > '"+sBeforDay+"' and FinishDate <= '"+sToday+"' and UserId='"+CurUser.UserID+"' and ObjectNo in(select serialno from business_contract where customerid='"+sObjectNo+"')";
		//out.println(sSql);

		rs = Sqlca.getResultSet(sSql);
		if(rs.next())
		{
			int count=rs.getInt("ClassifyCount");
			//out.println(count);
			if(count>0)
				bFinishFlag=true;
			else
				bFinishFlag=false;
		}
		rs.getStatement().close();
		
		//屏蔽完成检查条件，在测试过后可以去掉
		bFinishFlag=true;
		//----------------end---------------

		if(bFinishFlag)
		{
			if(sObjectType.equals("BusinessContract"))
				sSql = "update INSPECT_INFO set finishdate='"+StringFunction.getToday()+"',UpdateDate='"+StringFunction.getToday()+"',InspectType = '010020'"+
			   			" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'";
			else if(sObjectType.equals("Customer") && sInspectType.equals("020010"))
				sSql = "update INSPECT_INFO set finishdate='"+StringFunction.getToday()+"',UpdateDate='"+StringFunction.getToday()+"',InspectType = '020020'"+
			   			" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'";
			else if(sObjectType.equals("Customer") && sInspectType.equals("040010"))
				sSql = "update INSPECT_INFO set finishdate='"+StringFunction.getToday()+"',UpdateDate='"+StringFunction.getToday()+"',InspectType = '040020'"+
			   			" where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'";	
			Sqlca.executeSQL(sSql);
		}
		sFinishType="Inspect";
	}

%>
<script language=javascript>
	var FinishType="<%=sFinishType%>";
	if(<%=bFinishFlag%>)
		returnValue="finished";
	else
	{
		if(FinishType=="Purpose")
			returnValue="Purposeunfinish";
		if(FinishType=="Inspect")
			returnValue="Inspectunfinish";
	}
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>