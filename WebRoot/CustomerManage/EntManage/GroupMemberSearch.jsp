<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.lending.bizlets.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=注释区;]~*/%>
<%
/* 
  author:  zywei 2006/08/09 
  Tester:
  Content:  集团客户搜索
  Input Param:
			CustomerID：客户编号
  Output param:
 
  History Log:     

               
 */
 %>
<%/*~END~*/%>

<%     
	
    //定义变量
    String sReturnValue = "";
    
    //获得组件参数
    
    //获得页面参数：项目编号、对象编号。
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
   	if(sCustomerID == null) sCustomerID = "";
   	
   	try
   	{
   		GroupSearch	groupSearch = new GroupSearch(sCustomerID,Sqlca);
		groupSearch.getSearchResult(Sqlca);
   		sReturnValue = "True";
   	}catch(Exception e)
   	{
   		sReturnValue = "False";
   		System.out.println("---------GroupMemberSearch-----------"+e.toString());
   	}
 %>

<script language=javascript>
	self.returnValue = "<%=sReturnValue%>";	
	self.close();		
</script>


<%@ include file="/IncludeEnd.jsp"%>