<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	ASResultSet rsRole = SqlcaRepository.getASResultSet("select SortNo,count(*) from REG_COMMENT_ITEM where SortNo not like '99%' group by SortNo having count(*)>1");
while(rsRole.next()){
	throw new Exception("注释项排序号重复："+rsRole.getString("SortNo"));
}
rsRole.getStatement().close();
rsRole = SqlcaRepository.getASResultSet("select SortNo from REG_COMMENT_ITEM where DoGenHelp='true' and length(SortNo) not in (select codelength from object_level where objecttype='Comment' )");
while(rsRole.next()){
	throw new Exception("注释项排序号位数错误！请参见对象“Comment”的对象层级定义。错误的排序号："+rsRole.getString("SortNo"));
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
<title>无标题文档</title>
<script language="JavaScript">
	function TreeViewOnClick()
	{
	 var sCommentItemID=getCurTVItem().value;
	 //window.open("HelpContent.jsp?CommentItemID="+sCommentItemID+"&rand="+randomNumber(),"mainFrame");
	 OpenComp('HelpContent','/Common/help/HelpContent.jsp','CommentItemID='+sCommentItemID,'mainFrame','');
	}
	
	function startMenu() 
	{
	<%HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"帮助主题列表","right");
		tviTemp.TriggerClickEvent=true;
		String sSqlTreeView = " from REG_COMMENT_ITEM where DoGenHelp='true' ";
		out.println("<!--sSqlTreeView: "+sSqlTreeView+"-->");
		tviTemp.initWithSql("SortNo","CommentItemName","CommentItemID","","",sSqlTreeView,"Order By SortNo",Sqlca);  //取信息列表进行显示
		
		tviTemp.toRegister = false;
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
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