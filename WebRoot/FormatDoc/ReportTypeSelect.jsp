<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xdhou  2005.02.17
		Tester:
		Content: ��ȡ���鱨�������
		Input Param:
			ObjectType����������
			ObjectNo��������
		Output param:
			DocID�����鱨������
		History Log: 
	 */
	%>
<%/*~END~*/%>


<% 	
	//���ҳ�����	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 		//ҵ����ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 	//��������
	
	String sSql = " select DocID from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"' ";
	String sDocID = Sqlca.getString(sSql);	
	if(sDocID == null) sDocID = "";		
%>

<script language="JavaScript">
	self.returnValue="<%=sDocID%>";
    self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>