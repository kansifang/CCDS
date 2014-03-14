<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: jytian 2004-12-06 
			Tester:
			Describe: 添加重点信息链接中
			Input Param:
		ObjectType：信息类型
		ObjectNo：信息代码
			Output Param:
			HistoryLog:   zywei 2005/09/10 重检代码
		
		 */
	%>
<%
	/*~END~*/
%> 
<html>
<head>
<title>添加重点信息链接中</title>

<%
	//获取页面参数：信息类型和信息代码
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
   	String sSql = " select ObjectType,UserID,ObjectNo "+
		          " from User_DefineInfo "+
		          " where UserID ='"+CurUser.UserID+"' "+
		          " and ObjectType='"+sObjectType+"' "+
		          " and ObjectNo='"+sObjectNo+"'";
   ASResultSet rs = Sqlca.getResultSet(sSql);
   if(rs.next()){
%>
<script language=javascript>
	 alert(getBusinessMessage('242'));	
	 self.close();
</script>
<%
	}
   else
   {
	    Sqlca.executeSQL(" insert into User_DefineInfo(UserID,ObjectType,ObjectNo) values('"+CurUser.UserID+"','"+sObjectType+"','"+sObjectNo+"') ");
%>
<script language=javascript>
	alert(getBusinessMessage('243'));	
	self.close();
</script>
<%
	}
    rs.getStatement().close();
%>
<%@ include file="/IncludeEnd.jsp"%>