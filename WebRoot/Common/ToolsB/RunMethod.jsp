<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: byhu 2005.08.04
			Tester:
			Describe:
		����һ��classmethod������Stringֵ��

			Input Param:
		ClassName: ������
		MethodName: ��������
		Args: ������
			Output Param:
		top.returnValue: ����ֵ

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
