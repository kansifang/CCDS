<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%	
	//获得组件参数
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
		if(sBusinessType.startsWith("3")) //如果产品为授信额度时，那么进入授信额度详情界面
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
