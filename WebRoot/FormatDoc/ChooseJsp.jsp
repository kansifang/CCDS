<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.18
		Tester:
		Content: ѡ����Ҫ���õ�JSP
		Input Param:
			SerialNo:	������ˮ��
			ObjectNo��	ҵ����ˮ��
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<% 	
	//��ò���	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
 	//��������
	String sSql = "",sJspName="",sDocID="";
	ASResultSet rsData = null;

	sSql = " select JspFileName,A.DocID " +
			" from FORMATDOC_DATA A,FORMATDOC_DEF B "+
			" where A.SerialNo = '"+sSerialNo+"' "+
			" and A.ObjectNo = '"+sObjectNo+"' "+
			" and A.ObjectType = '"+sObjectType+"'"+
			" and B.DocID = A.DocID "+
			" and B.DirID = A.DirID ";
	rsData = Sqlca.getResultSet(sSql);
	if(rsData.next())
	{
		sJspName = rsData.getString(1);
		sDocID = rsData.getString(2);
	}
	rsData.getStatement().close();
	String sReturn = sJspName+"?DocID="+sDocID+"&";
%>

<script language="JavaScript">
	self.returnValue="<%=sReturn%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>