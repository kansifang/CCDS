<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Resources/Include/IncludeHead.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: ��ҳ��
		Input Param:
			          
		Output param:
			      
		History Log: syang 2009/09/27 ����̨������Ų���ճ�������ʾ�ϡ�
		History Log: syang 2009/12/09 ��дҳ��TAB���ɷ�ʽ��
		History Log: syang 2009/12/16 TAB֧���Զ��幦��
	 */
	%>
<%/*~END~*/%>
<%
		String PG_TITLE = "ģ������"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;��������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
		String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
		String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>

<%
	//ȡϵͳ����
	PG_TITLE = CurConfig.getConfigure("ImplementationName");
	if (PG_TITLE == null) PG_TITLE = "";
%> 


<html>
<head>
<title><%=PG_TITLE%></title>
</head>
<body leftmargin="0" topmargin="0" class="windowbackground" style="{overflow:auto;overflow-x:scroll;overflow-y:visible}">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
<!-- add by byhu: ����ˢ�±�ҳ�� -->
<form name="DOFilter" method=post onSubmit="if(!checkDOFilterForm(this)) return false;">
		<input type=hidden name=CompClientID value="<%=CurComp.ClientID%>">
		<input type=hidden name=PageClientID value="<%=CurPage.ClientID%>">
</form>

	<tr>
		<td id=mytop class="mytop">
			<%@include file="/MainTop.jsp"%>
		</td>
	</tr>
	<tr>
		<td valign="top" id="mymiddle" class="mymiddle"></td>
	</tr>
	<tr>
		<td valign="top" id="mymiddleShadow" class="mymiddleShadow"></td>
	</tr>
	<tr>
		<td id="myall" valign="top" onMouseOver="showlayer(0,mymiddle)">
			<!-- �������� -->
			<%@include file="/DeskTop/Components/MainContent.jsp"%>
			<!-- �������� -->
		</td>
	</tr>
<!-----------------------------���Թ�����----------------------------->
<%@ include file="/Resources/CodeParts/SourceDisplayTR.jsp"%>
<!-------------------------------->
</table>
</body>
</html>
<script language="JavaScript">
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	myleft.width=<%=PG_LEFT_WIDTH%>; 
	<%
	String sDefaultCompID = CurPage.getParameter("DefaultCompID");
	String sDefaultCompParas = CurPage.getParameter("DefaultCompParas");
	if(sDefaultCompParas!=null) sDefaultCompParas = StringFunction.replace(sDefaultCompParas,"~","&");
	else sDefaultCompParas="";
	if(sDefaultCompID!=null && !sDefaultCompID.equals("")){
	%>
	OpenComp("<%=sDefaultCompID%>","","<%=sDefaultCompParas%>","right","");
	<%}%>
</script>
<%@ include file="/IncludeEnd.jsp"%>