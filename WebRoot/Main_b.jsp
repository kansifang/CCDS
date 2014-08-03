<%@ page contentType="text/html; charset=GBK"%>
<%@include file="/Resources/Include/IncludeHead.jsp"%>
 
<%
 	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
 %>
	<%
		/*
		Author:   
		Tester:
		Content: 主页面
		Input Param:
			          
		Output param:
			      
		History Log: 
			 */
	%>
<%
	/*~END~*/
%>

<%
	//取系统名称
	String sImplementationName = CurConfig.getConfigure("ImplementationName");
	if (sImplementationName == null) sImplementationName = "";
%>
<html>
<head>
<title><%=sImplementationName%></title>
</head>
<script language=javascript>

    function openFile(sBoardNo)
    {
        popComp("BoardView","/SystemManage/SynthesisManage/BoardView.jsp","BoardNo="+sBoardNo,"","");
    }
    function saveFile(sBoardNo)
    {
        window.open("<%=sWebRootPath%>/SystemManage/BoardManage/BoardView2.jsp?BoardNo="+sBoardNo+"&rand="+randomNumber(),"_blank",OpenStyle);
    }
</script>
<body leftmargin="0" topmargin="0" class="windowbackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
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
          <td valign="top"  onMouseOver="showlayer(0,this)">
            <table width="100%" border="0" cellpadding="5" height="100%" cellspacing="0">
              <tr>
               <td width=200 height=205>
	                <table border='1' cellspacing='0' cellpadding='0' width='100%' height="100%">
	                   <tr>
	                      <td align="center" nowrap bgcolor= #dcdcdc bordercolorlight='#99999' bordercolordark='#FFFFFF' height="18"></td>
						</tr>
						<tr>
	                      <td bgcolor= #dcdcdc>
	                      <iframe name="Tree" src="<%=sWebRootPath%>/DeskTop/Components/Marquee.jsp?TextToShow=正在打开页面，请稍候&CompClientID=<%=CurComp.ClientID%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
	                      </td>
						</tr>
		            </table>
                </td>
                <td valign="top" rowspan=2>
                  <div class="groupboxmaxcontent" >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                      <tr>
                        <td height="1">
                          <table cols=2 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td nowrap class="groupboxheader">
                              	<font class="groupbox"> &nbsp;&nbsp;我的工作台&nbsp;&nbsp;</font> </td>
                              <td nowrap class="groupboxcorner"><img class="groupboxcornerimg" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" name="Image1"></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td>
                         <div  valign=middle class="groupboxmaxcontent" style="position:absolute; width: 100%;overflow:auto;visibility: inherit" id="window1">
							<iframe	id="right" name="middleName" src="<%=sWebRootPath%>/DeskTop/Components/WorkDeskTab.jsp?TextToShow=正在打开页面，请稍候&CompClientID=<%=CurComp.ClientID%>" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no></iframe>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </div>
                </td>
                </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
<script language="JavaScript">
	//OpenComp("MyCalendar","/DeskTop/Components/MyCalendar.jsp","","MyCalendar","");
</script>
<%@ include file="/IncludeEnd.jsp"%>