<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 主页面
		Input Param:
			          
		Output param:
			      
		History Log: syang 2009/09/27 工作台及日历挪到日常工作提示上。
		History Log: syang 2009/12/09 改写页面TAB生成方式。
		History Log: syang 2009/12/16 TAB支持自定义功能
	 */
	%>
<%/*~END~*/%>
<%
%>

<%
	//取系统名称
	//PG_TITLE = CurConfig.getConfigure("ImplementationName");
	//if (PG_TITLE == null) PG_TITLE = "";
%> 


<html>
<head>
<title></title>
</head>
<body leftmargin="0" topmargin="0" class="windowbackground" style="{overflow:auto;overflow-x:scroll;overflow-y:visible}">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr>
		<td id="myall" valign="top" onMouseOver="showlayer(0,mymiddle)">
			<table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="content_table"  id="content_table">
				<tr> 
					<td id="myleft_left_top_corner" class="myleft_left_top_corner"></td>
					<td id="myleft_top" class="myleft_top"></td>
					<td id="myleft_right_top_corner" class="myleft_right_top_corner"></td>
					<td id="mycenter_top" class="mycenter_top"></td>
					<td id="myright_left_top_corner" class="myright_left_top_corner"></td>
					<td id="myright_top" class="myright_top"></td>
					<td id="myright_right_top_corner" class="myright_right_top_corner"></td>
				</tr>
				<tr> 
					<td id="myleft_leftMargin" class="myleft_leftMargin"></td>
					<td id="myleft" > 
						<iframe id="left_id" name="left" src="<%=sWebRootPath%>/DeskTop/Components/Marquee.jsp?TextToShow=正在打开页面，请稍候&CompClientID=<%=CurComp.ClientID%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
						<!--<iframe name="left" src="--sWebRootPath%>/Blank.jsp"  width=100% height=100% frameborder=0 scrolling=no ></iframe>
						-->
					</td>
					<td id="myleft_rightMargin" class="myleft_rightMargin"> </td>
					<td id="mycenter" class="mycenter">
						<div id=divDrag title='可拖拽改变窗口大小 Drag to resize' style="z-index:0; CURSOR: url('<%=sResourcesPath%>/ve_split.cur')"	 
							ondrag="if(event.x>16 && event.x<400) {myleft_top.style.display='block';myleft.style.display='block';myleft_bottom.style.display='block';myleft.width=event.x-6;}if(event.x<=16 && event.y>=4) {myleft_top.style.display='none';myleft.style.display='none';myleft_bottom.style.display='none';}if(event.x<4) window.event.returnValue = false;">
							<!--img name=imgDrag title='可拖拉' height=100% width=3 src="<%=sResourcesPath%>/line.gif"-->
							<img class=imgDrag src=<%=sResourcesPath%>/1x1.gif width="1" height="1">
						</div>
					</td>
					<td id="myright_leftMargin" class="myright_leftMargin"></td>
					<td id="myright" class="myright">
						<div  class="RightContentDiv" id="RightContentDiv"> 
							<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
								<tr> 
									<td height="1"> 
										<table id=table0 cols=3 border=0 cellpadding=0 cellspacing=0>
											<tr> 
												<td nowrap class="groupboxheader"><%=PG_CONTENT_TITLE%></td>
												<td nowrap><img class=groupboxcornerimg src=<%=sResourcesPath%>/1x1.gif width="1" height="1" name="Image1"></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr> 
									<td colspan=2> 
										<%@include file="/DeskTop/Components/GeneralTab.jsp"%>
										<!--
										<div id="TabIframeTD" class="groupboxmaxcontent" style="position:absolute; width: 100%;overflow:hidden;"> 
										<iframe	id="right" name="right" scrolling="auto" src="<%=sWebRootPath%>/DeskTop/Components/WorkDeskTab1.jsp?TextToShow=正在打开页面，请稍候&CompClientID=<%=CurComp.ClientID%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>
										<iframe name="right" scrolling="auto" src="<=sWebRootPath%>/Blank.jsp?TextToShow=<PG_CONTNET_TEXT%>" width=100% height=100% frameborder=0></iframe>
										</div>
										-->
									</td>
								</tr>
							</table>
						</div>
					</td>
					<td id="myright_rightMargin" class="myright_rightMargin"></td>
				</tr>
				<tr>
					<td id="myleft_left_bottom_corner" class="myleft_left_bottom_corner"></td>
					<td id="myleft_bottom" class="myleft_bottom"></td>
					<td id="myleft_right_bottom_corner" class="myleft_right_bottom_corner"></td>
					<td id="mycenter_bottom" class="mycenter_bottom"></td>
					<td id="myright_left_bottom_corner" class="myright_left_bottom_corner"></td>
					<td id="myright_bottom" class="myright_bottom"></td>
					<td id="myright_right_bottom_corner" class="myright_right_bottom_corner"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
<script language="JavaScript">
</script>