<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: thong 2005.03.17
 * Tester:
 *
 * Content: ɾ��reg_comment_item & reg_comment_rela
 * Input Param:
 *			
 *			����:	ColumnName
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
<title>������к�</title>

<%	
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow.open����window_open
	//��ȡ�����������͸�ʽ
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
