<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	ASResultSet rsRole = SqlcaRepository.getASResultSet("select SortNo,count(*) from REG_COMMENT_ITEM where SortNo not like '99%' group by SortNo having count(*)>1");
while(rsRole.next()){
	throw new Exception("ע����������ظ���"+rsRole.getString("SortNo"));
}
rsRole.getStatement().close();
rsRole = SqlcaRepository.getASResultSet("select SortNo from REG_COMMENT_ITEM where DoGenHelp='true' and length(SortNo) not in (select codelength from object_level where objecttype='Comment' )");
while(rsRole.next()){
	throw new Exception("ע���������λ��������μ�����Comment���Ķ���㼶���塣���������ţ�"+rsRole.getString("SortNo"));
}
rsRole.getStatement().close();

String sCommentItemID = DataConvert.toRealString(iPostChange,CurPage.getParameter("CommentItemID"));
if(sCommentItemID!=null && !sCommentItemID.equals("")){
%>
<script language="javascript">
	OpenComp("HelpContent","/Common/help/HelpContent.jsp","CommentItemID=<%=sCommentItemID%>","mainFrame","");
</script>
<%
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>�ޱ����ĵ�</title>
<script language="JavaScript">
	function TreeViewOnClick()
	{
	 var sCommentItemID=getCurTVItem().value;
	 //window.open("HelpContent.jsp?CommentItemID="+sCommentItemID+"&rand="+randomNumber(),"mainFrame");
	 OpenComp('HelpContent','/Common/help/HelpContent.jsp','CommentItemID='+sCommentItemID,'mainFrame','');
	}
	
	function startMenu() 
	{
	<%HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"���������б�","right");
		tviTemp.TriggerClickEvent=true;
		String sSqlTreeView = " from REG_COMMENT_ITEM where DoGenHelp='true' ";
		out.println("<!--sSqlTreeView: "+sSqlTreeView+"-->");
		tviTemp.initWithSql("SortNo","CommentItemName","CommentItemID","","",sSqlTreeView,"Order By SortNo",Sqlca);  //ȡ��Ϣ�б������ʾ
		
		tviTemp.toRegister = false;
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		out.println(tviTemp.generateHTMLTreeView());%>
		expandNode('root');
		//expandNode(1);
		
	}
</script>
</head>

<body leftmargin="5" topmargin="5" class="pagebackground">
<iframe name="left" src="" width="100%"  height="100%" frameborder=0 scrolling=no ></iframe>
</body>
</html>
<script language="JavaScript">
	startMenu();
</script>

<%@ include file="/IncludeEnd.jsp"%>