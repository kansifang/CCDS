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
<%!
	//��û������ڵķ���
	String getBranchOrgID(String sOrgID,Transaction Sqlca) throws Exception {
		String sUpperOrgID = sOrgID;
		int sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		while (sLevel > 3) {
			sUpperOrgID = Sqlca.getString("select RelativeOrgID from Org_Info where OrgID='"+sOrgID+"'");
			if (sUpperOrgID == null) break;
			sOrgID = sUpperOrgID;
			sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		}
		return sOrgID;
	}
	
%>

<% 	
	//��ò���	
	String sDocID = DataConvert.toRealString(iPostChange,(String)request.getParameter("DocID")); 
	String sOrgID = getBranchOrgID(CurOrg.OrgID,Sqlca);
	String sSql = "";
	ASResultSet rs = null;

	String sAttribute = "";
	sSql = "select DefaultValue from FORMATDOC_PARA where docid = '"+sDocID+"' fetch first 1 rows only"; 
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()) sAttribute = rs.getString(1);
	rs.getStatement().close();
%>

<script language="JavaScript">
	self.returnValue = "<%=sAttribute%>";
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>