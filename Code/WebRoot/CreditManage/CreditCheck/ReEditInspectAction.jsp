<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   ndeng  2005.1.24
		Tester:
		Content: 撤回完成的检查报告操作
		Input Param:
			 SerialNo: 流水号
			 ObjectType：对象类型
			 ObjectNo：对象编号
		Output param:
		
		History Log: zywei 2006/09/11 重检代码
			
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>贷后检查完成</title>
<%
	//定义变量
	String sSql = "";
	
	//获取页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sInspectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("InspectType"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	//如果是贷款用途报告
	if(sObjectType.equals("BusinessContract"))
	{
		sSql = 	" update INSPECT_INFO set FinishDate = null,InspectType = '010010'"+
				" where SerialNo = '"+sSerialNo+"' "+
				" and ObjectNo = '"+sObjectNo+"' "+
				" and ObjectType = '"+sObjectType+"'";
		Sqlca.executeSQL(sSql);
	}
	//客户检查报告，
	else if(sObjectType.equals("Customer") && sInspectType.equals("020020"))
	{		
		sSql = 	" update INSPECT_INFO set FinishDate = null,InspectType = '020010'"+
	   			" where SerialNo = '"+sSerialNo+"' "+
	   			" and ObjectNo = '"+sObjectNo+"' "+
	   			" and ObjectType = '"+sObjectType+"' ";
		Sqlca.executeSQL(sSql);
		sSql = " update CHECK_Frequency set NextCheckTime='' where CustomerID ='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
	}
	else if(sObjectType.equals("Customer") && sInspectType.equals("040020"))
	{		
		sSql = 	" update INSPECT_INFO set FinishDate = null,InspectType = '040010'"+
	   			" where SerialNo = '"+sSerialNo+"' "+
	   			" and ObjectNo = '"+sObjectNo+"' "+
	   			" and ObjectType = '"+sObjectType+"' ";
		Sqlca.executeSQL(sSql);
		sSql = " update CHECK_Frequency set NextCheckTime='' where CustomerID ='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
	}
%>
<script language=javascript>
	alert(getBusinessMessage('655'));//报告撤回完成！
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>