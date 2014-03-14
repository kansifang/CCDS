<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	String sUserID=DataConvert.toString(request.getParameter("UserID"));
	String sOrgID=DataConvert.toString(request.getParameter("OrgID"));
	String sObjectType  = DataConvert.toString(request.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toString(request.getParameter("ObjectNo"));
	String sSql="select count(*) from Object_User where ObjectType='"+sObjectType+"' and ObjectNo='"+sObjectNo+"' and UserID='"+sUserID+"' and OrgID='"+sOrgID+"' ";
	ASResultSet rs=null;
	//out.println(sSql);
	rs =Sqlca.getASResultSet(sSql);	
	while(rs.next())
	{
	if(rs.getInt(1)>0)
	 {
%>
	        <script	language=javascript>
	              alert( "已经赋予了该用户权限！");
			self.returnValue = "failed";
			self.close();
		</script>
	<%
		}
		else
		 {
	%>
		<script language=javascript>
			self.returnValue = "succeeded";
			self.close();
		</script>

<%
	}
      }
		rs.getStatement().close();
%>
<%@ include file="/IncludeEnd.jsp"%>