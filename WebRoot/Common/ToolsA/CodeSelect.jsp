<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-03 
		Tester:
		Describe: ����ѡ���
		Input Param:
			CodeNo������Ӣ������+"^"+TreeView����+"^"+Where�������
		Output Param:
			ItemNo����Ŀ���
			ItemName����Ŀ����

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>

<%
	String sCodeNo1  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));
	String sCodeNo=StringFunction.getSeparate(sCodeNo1," ",1);
	String sTitle=StringFunction.getSeparate(sCodeNo1," ",2);
	String sFlag = sTitle;
	if (sTitle == null ) sTitle = "";
	if (sTitle.equals("FlowRight"))
	{
		sTitle = "���ʽ";
	}
	String sCon=StringFunction.getSeparate(sCodeNo1,"^",3);	
	if ((sCon==null) || sCon.equals(""))
	{
		sCon=" from Code_Library where CodeNO='"+sCodeNo+"' ";
	}
	else
	{
		sCon=" from Code_Library where CodeNO='"+sCodeNo+"' and "+sCon;		
	}
	sCon=StringFunction.replace(sCon,"$"," ");
	sCon=StringFunction.replace(sCon,"*","%"); //������Ʊ���ʽ��bug
%>

<html>
<head>
<title>��ѡ���������</title>


<script language=javascript>

	//��ȡ�û�ѡ��Ĵ�������
	function TreeViewOnClick()
	{

		var sItemNo=getCurTVItem().id;
		//alert(sItemNo);
		var sFlag = "<%=sFlag%>";
		var sItemName=getCurTVItem().name;
		var sType = getCurTVItem().type;
		if(sType == "page" ||sFlag == "FlowRight" )
		{
			parent.sObjectInfo = sItemNo+"@"+sItemName; 
		}else{
			parent.sObjectInfo = ""; 
		}
		
	}

	//����ѯ���Ĵ������ݰ�TreeViewչʾ
	function startMenu()
	{
	<%
		HTMLTreeView tviTemp = new HTMLTreeView(sTitle,"right");
		tviTemp.TriggerClickEvent=true;
		if("OrgInfo".equals(sCodeNo))
		{
			tviTemp.initWithSql("OrgID","OrgName","OrgID","","from Org_Info",Sqlca);
		}
		else
		{
  			tviTemp.initWithSql("ItemNo","ItemName","ItemNo","",sCon,Sqlca);
  		}
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		out.println(tviTemp.generateHTMLTreeView());
		//System.out.println(tviTemp.generateHTMLTreeView());
	%>

	}
	

</script>
<style>

.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}

</style>
</head>
<body class="pagebackground">
<center>
	<form  name="buff">
		<input type="hidden" name="CountryType" value="">
		<table width="100%" border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
   	 		<tr> 
        			<td id="myleft"  align=center width=50%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
   			</tr>
		</table>
	</form>
</center>
</body>

<script language="JavaScript">
	startMenu();
	expandNode('root');
</script>
</html>
<%@ include file="/IncludeEnd.jsp"%>
