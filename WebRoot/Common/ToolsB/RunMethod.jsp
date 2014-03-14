<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: byhu 2005.08.04
			Tester:
			Describe:
		运行一个classmethod，返回String值。

			Input Param:
		ClassName: 类名称
		MethodName: 方法名称
		Args: 参数串
			Output Param:
		top.returnValue: 返回值

			HistoryLog:
		*/
	%>
<%
	/*~END~*/
%>

<%
	String sClassName = DataConvert.toRealString(iPostChange,CurPage.getParameter("ClassName"));
	String sMethodName = DataConvert.toRealString(iPostChange,CurPage.getParameter("MethodName"));
	String sArgs = DataConvert.toRealString(iPostChange,CurPage.getParameter("Args"));
	
	ASMethod method = new ASMethod(sClassName,sMethodName,Sqlca);
	Any anyValue  = method.execute(sArgs);
	out.println(anyValue.toStringValue());
%>
<script	language=javascript>
	top.returnValue = "<%=anyValue.toStringValue()%>";
	top.close();
</script>

<%@	include file="/IncludeEnd.jsp"%>
