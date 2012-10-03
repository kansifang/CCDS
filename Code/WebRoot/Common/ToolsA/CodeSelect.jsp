<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jytian 2004-12-03 
		Tester:
		Describe: 代码选择框
		Input Param:
			CodeNo：代码英文名称+"^"+TreeView标题+"^"+Where条件语句
		Output Param:
			ItemNo：条目编号
			ItemName：条目名称

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
		sTitle = "贷款方式";
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
	sCon=StringFunction.replace(sCon,"*","%"); //修正银票贷款方式的bug
%>

<html>
<head>
<title>请选择代码内容</title>


<script language=javascript>

	//获取用户选择的代码内容
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

	//将查询出的代码内容按TreeView展示
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
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
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
