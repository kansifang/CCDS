<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: thong 2005.03.17
 * Tester:
 *
 * Content: 删除reg_comment_item & reg_comment_rela
 * Input Param:
 *			
 *			列名:	ColumnName
 *			
 * Output param:
 *		  
 *
 * History Log:
 *
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>获得序列号</title>

<%	
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window.open或者window_open
	//获取表名、列名和格式
	boolean isOk = false ;
	ASResultSet rsTemp ;
	String sCommentItemID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CommentItemid"));
	String sSql = "delete from reg_comment_rela where CommentItemID = '"+sCommentItemID+"'" ;
	String sSql2 = "delete from reg_comment_item where CommentItemID = '"+sCommentItemID+"'";

	int i = 0;
	int i1 = 0;
	try{
		i = Sqlca.executeSQL(sSql) ;
		i1 = Sqlca.executeSQL(sSql2) ;
		if(i1 == 1){
			isOk = true ;
		}
	}catch(Exception ex){ex.printStackTrace();}

%>
<script language=javascript>
	self.returnValue = "<%=isOk%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>
