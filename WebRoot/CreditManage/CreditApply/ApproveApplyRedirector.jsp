<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	ASResultSet rs=null;
	String sSql = "";
	String sBusinessType = "";
		
	sSql = " select BusinessType from BUSINESS_APPROVE where SerialNo = '"+sObjectNo+"'";
	sBusinessType = Sqlca.getString(sSql);	
%>


<script language=javascript>
	<%
		if(sBusinessType.startsWith("3")) //�����ƷΪ���Ŷ��ʱ����ô�������Ŷ���������
		{
	%>		
		OpenPage("/CreditManage/CreditLine/CreditLineApproveView.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
	<%
		}else
		{
	%>
		OpenPage("/CreditManage/CreditApply/CreditView.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
	<%
		}
	%>
</script>
<%@ include file="/IncludeEnd.jsp"%>
