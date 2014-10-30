
<%
	//out.println(HTMLTab.genTabHTML(sTableStyle,sTopRight,sTabID,sIframeName,sDefaultPage,sIframeStyle));
%>
<table <%=sTableStyle%>>
	<tr>
		<td valign='top' class='tabhead' <%=sTabHeadStyle%>><%=sTabHeadText%></td>
	</tr>
	<!--  
	<tr>
		<td valign='top' align='left' id="tabtd" class="tabtd"></td>
		<td valign='top' class="tabbar"><%=sTopRight%></td>
	</tr>
	-->
	<tr>
		<td valign='top' align='left' class="tabtd" >
			<table id="tabtid" width='100%'>
				<tr>
					<td valign='top' id="tabtd" align='left'></td>
				</tr><!-- tab标签上面那一行，下面挂各种tab标签，一组标签就是一个<tr></tr>-->
			</table>
		</td>
	</tr>
	<tr>
		<td valign='top' class="tabbar"><%=sTopRight%></td>
	</tr>
	<tr>
		<td class='tabcontent' align='center' valign='top'>
			<table id="tableIframe" cellspacing=0 cellpadding=4 border=0	width='100%' height='100%'>
				<tr> 
					<td id="TabIframeTD" valign="top">
						<iframe	name="<%=sIframeName%>" src="<%=sDefaultPage%>" <%=sIframeStyle%>></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

