<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: jytian 2004-12-06 
			Tester:
			Describe: ����ص���Ϣ������
			Input Param:
		ObjectType����Ϣ����
		ObjectNo����Ϣ����
			Output Param:
			HistoryLog:   zywei 2005/09/10 �ؼ����
		
		 */
	%>
<%
	/*~END~*/
%> 
<html>
<head>
<title>����ص���Ϣ������</title>

<%
	//��ȡҳ���������Ϣ���ͺ���Ϣ����
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
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