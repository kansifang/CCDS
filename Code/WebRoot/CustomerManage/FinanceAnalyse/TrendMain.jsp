<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  
		Tester:	
		Content: 客户财务报表分析
		Input Param:
	                 CustomerID：客户号
	                 Term 参数包括以下参数内容：
	                      ReportCount ：报表期数
	                      AccountMonth1：报表的年月
	                      Scope：报表范围
		Output param:
	                 CustomerID：客户号
	                 ReportNo:报表号
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005-7-21 fbkang	页面调整
			
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "趋势分析"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
    
    //获得页面参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sTerm = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Term"));
	sTerm = sTerm.replace('@','&');
	//获得组件参数
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=主页面的编写;]~*/%>

<html>
<head>
	<title>趋势分析</title>
</head>
<body class="ListPage" leftmargin="0" topmargin="0" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}" onload="resizeTo(screen.width,screen.height,moveTo(0,0));" oncontextmenu="return false">
<table align='center' cellspacing=0 cellpadding=0 border=0 width=100% height="100%">
  <tr>
       <td valign='top' colspan=2 class='tabhead'>
       	<table>
       		<tr>
       			<td>&nbsp;</td>
       			<td>
       				<%=HTMLControls.generateButton("退&nbsp;出","关闭窗口","javascript:confirm('关闭当前窗口？')?self.close():''",sResourcesPath)%>
       			</td>
       		</tr>
       	</table>
       </td>
  </tr>                         
   <tr>  
       <td valign='top' align='left' id="tabtd" class="tabtd" height=20 align='left' width=100%> 
  				<iframe class="tabpage" name="DeskTopTab" src="" width=100% height=20 frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"></iframe>
      </td>
  </tr>
  
  <tr> 
       <td class='tabcontent' align='center' valign='top'>  
				<table cellspacing=0 cellpadding=4 border=0 width='100%' height='100%'>
				<tr> 
				<td valign="top" id="TabBodyTable" class="TabBodyTable">
						<iframe name="DeskTopInfo" src="" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 ></iframe>
				</td>
				</tr>
				</table> 
      </td>
  </tr>
</table>
</body>
</html>

<script language="JavaScript">
   /*~[Describe=用tab格式来画页面;InputParam=无;OutPutParam=无;]~*/
   
	var tabstrip = new Array();
	<%
		String sFinanceBelong = "";
		ASResultSet rs = Sqlca.getASResultSet("select FinanceBelong from ENT_INFO where CustomerID= '" + sCustomerID + "'");
		if(rs.next()) sFinanceBelong = rs.getString(1);		
		rs.getStatement().close();
		
		String sReportNo = "", sReportName = "";
		int iCount = 0;
		String sSql = "select ReportNo,ReportName from FINANCE_CATALOG where FINANCE_CATALOG.BelongIndustry ='" + sFinanceBelong + "'"+" order by ReportNo";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sReportNo = rs.getString(1);
			sReportName = rs.getString(2);
			if(sReportNo.substring(3,4).equals("8"))
				continue;
	%>
			tabstrip[<%=iCount%>] = new Array("block<%=iCount%>","<%=sReportName%>","javascript:parent.drawTab(<%=iCount+1%>,'<%=sReportNo%>');");
	<%	
			iCount++;
		}
		rs.beforeFirst();
		if(rs.next())
			sReportNo = rs.getString(1);
		rs.getStatement().close();
	%>
	
	hc_drawTabToIframe("tab_DeskTopInfo",tabstrip,1,DeskTopTab);
	//self.open("TrendDetail.jsp?CustomerID=<%=sCustomerID%>&ReportNo=<%=sReportNo%><%=sTerm%>&rand="+randomNumber(),"DeskTopInfo");
    OpenPage("/CustomerManage/FinanceAnalyse/TrendDetail.jsp?CustomerID=<%=sCustomerID%>&ReportNo=<%=sReportNo%><%=sTerm%>","DeskTopInfo");
	
	function drawTab(selectedStrip,reportNo)
	{ 	
		hc_drawTabToIframe("tab_DeskTopInfo",tabstrip,selectedStrip,DeskTopTab);
		//self.open("TrendDetail.jsp?CustomerID=<%=sCustomerID%>&ReportNo="+reportNo+"<%=sTerm%>&rand="+randomNumber(),"DeskTopInfo");
	    OpenPage("/CustomerManage/FinanceAnalyse/TrendDetail.jsp?CustomerID=<%=sCustomerID%>&ReportNo="+reportNo+"<%=sTerm%>","DeskTopInfo");
	
	}
	
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
