<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.17
		Tester:
		Content: �������ݵ�FORMATDOC_DATA
		Input Param:
			DocID:    formatdoc_catalog�е��ĵ���𣨵��鱨�棬�����鱨�棬...)
			ObjectNo��ҵ����ˮ��
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<% 	
		
	//����������	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 		//ҵ����ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType")); 		//��������
	String sSql = "delete from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and ObjectType='"+sObjectType+"'";
	Sqlca.executeSQL(sSql);
%>

<script language="JavaScript">
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>