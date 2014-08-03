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
   <!-- 单独一行用于公司通知公告等 -->
                <tr >
                <td width=200 >
                  <table border='1' cellspacing='0' cellpadding='0' width='100%' height="100%">
                    <tr>
                      <td align="center" nowrap bgcolor= #dcdcdc bordercolorlight='#99999' bordercolordark='#FFFFFF' height="18">通知</td>
					</tr>
		            <tr>
		              <td nowrap bgcolor= #dcdcdc bordercolorlight='#dcdcdc' bordercolordark='#dcdcdc' class="pt9song">
				            <table width=97% border=0 align="right" cellpadding=5 height=100%>
				              <tr>
				                    <td class="pt9song">
				                    <font color="#FFFFFF">
				                    <marquee behavior="scroll" DIRECTION="up" width=100% height=100%  scrollamount=2 scrolldelay=80 onMouseOver="this.stop();" onMouseOut="this.start();" bgcolor="#6382BC" style="padding-left:5">
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><zhp>&nbsp</p><p>&nbsp</p><p>&nbsp</p><!--加空行解决滚动区域的问题-->
				                 <%
				                 	  String sIsNew = "",sIsEject = "";
	           		                  ASResultSet rs = null;
	           		                  rs = Sqlca.getASResultSet("select BoardNo,BoardTitle,IsNew,IsEject from BOARD_LIST where IsPublish = '1' and (ShowToRoles is null or ShowToRoles in (select RoleID from USER_ROLE where UserID='"+CurUser.UserID+"')) order by BoardNo desc");
	           		                  while(rs.next())
	           		                  {
	           		                    sIsNew = DataConvert.toString(rs.getString("IsNew"));
	           		                    sIsEject = DataConvert.toString(rs.getString("IsEject"));
	           		                    out.print("<li style='cursor:hand' >");
	           		                    if(sIsEject.equals("1"))
	           		                    {
	           		                        out.print("<span onclick='javascript:openFile(\""+rs.getString(1)+"\")'>"+rs.getString(2)+"</span>");
	           		                    }
	           		                    else
	           		                    {
	           		                        out.print("<span>"+rs.getString(2)+"</span>");
	           		                    }
	           		                    if(sIsNew.equals("1")) out.print("<img src='"+sResourcesPath+"/new.gif' border=0>");
	           		                    
	           		                    out.print("<br><br>");
	           		                  }
	           		                  rs.getStatement().close();
				                 %>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                </marquee>
				                    </font>
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
	//OpenComp("MyCalendar","/DeskTop/Components/MyCalendar.jsp","","MyCalendar","")
</script>
<%@ include file="/IncludeEnd.jsp"%>