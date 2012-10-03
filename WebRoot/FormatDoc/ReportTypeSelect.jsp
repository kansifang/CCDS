<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.17
		Tester:
		Content: 获取调查报告的种类
		Input Param:
			ObjectType：对象类型
			ObjectNo：对象编号
		Output param:
			DocID：调查报告种类
		History Log: 
	 */
	%>
<%/*~END~*/%>


<% 	
	//获得页面参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 		//业务流水号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 	//对象类型
	
	String sSql = " select DocID from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"' ";
	String sDocID = Sqlca.getString(sSql);	
	if(sDocID == null) sDocID = "";		
%>

<script language="JavaScript">
	self.returnValue="<%=sDocID%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>