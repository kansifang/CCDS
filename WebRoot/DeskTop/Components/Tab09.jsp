<%@ page contentType="text/html; charset=GBK"%>
<%
	//out.println(HTMLTab.genTabHTML(sTableStyle,sTopRight,sTabID,sIframeName,sDefaultPage,sIframeStyle));
%>
<body class=pagebackground leftmargin="0" topmargin="0" >	
<table align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98% >
<!-----------------------------数据Tab区----------------------------->
	<tr height=1 id="ButtonTR">
		<td id="ListButtonArea" class="ListButtonArea" valign=top colspan=2>
			<%
			CurPage.setAttribute("Buttons1",sButtons);
			%>
			<%@ include file="/Resources/CodeParts/ButtonSet.jsp"%>
	    </td>
	</tr>
	<tr>
		<td valign='top' colspan=2 class='tabhead' > <!--这是TabHead--><br> </td>
	</tr>
	<tr>
		<td valign='top' align='left' id="tabtd" class="tabtd">
		</td>
		<td valign='top' class="tabtoolbar" width=1>
		<!--这是TabBar-->
		</td>
	</tr>
	<tr>
		<td class='tabcontent' align='center' valign='top' colspan=2>
			<table cellspacing=0 cellpadding=0 border=0	width='100%' height='100%'>
				<tr> 
					<td valign="top" id="TabIframeTD">
					</td>
				</tr>
			</table>
		</td>
	</tr>
<!-------------------------------->
</table>

</body>

