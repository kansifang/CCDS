<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
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
		      
			History Log: 2005/10/15 zywei 增加用户密码安全审计功能
		 */
	%>
<%
	/*~END~*/
%>
<%
	int iVisitTimes = Integer.parseInt(CurPref.getUserPreference(Sqlca,"VisitTimes"));
String sLastVisitTime = CurPref.getUserPreference(Sqlca,"LastSignInTime");
String sLastSignOutTime = CurPref.getUserPreference(Sqlca,"LastSignOutTime");
String sLastApp = CurPref.getUserPreference(Sqlca,"LastVisitApp");
String sLastComp = CurPref.getUserPreference(Sqlca,"LastVisitComp");
String sLastCompName = CurPref.getUserPreference(Sqlca,"LastVisitCompName");
String sLastCompPara = CurPref.getUserPreference(Sqlca,"LastVisitCompPara");
String sLastCompURL = CurPref.getUserPreference(Sqlca,"LastVisitCompURL");
String sPasswordState = CurPref.getUserPreference(Sqlca,"PasswordState");
String sPasswordMessage = CurPref.getUserPreference(Sqlca,"PasswordMessage");
%>
<html>
<head>
<title>Welcome 欢迎</title>
</head>

<body leftmargin="0" topmargin="0" class="windowbackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
<table width="80%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#666666" bgcolor="#FFFFFF">
  <tr> 
    <td valign="top">
<table width="90%" align=center border="0" cellspacing="0" cellpadding="4">
        <tr> 
    <td valign="top">
    	<iframe name=myrefresh0 frameborder=0 width=1 height=1 src="<%=sWebRootPath%>/SessionClose.jsp" style="display:none"> </iframe>
    </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr>
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> <strong><font size="+1" face="宋体,Arial, Helvetica, sans-serif"><%=CurUser.UserName%></font></strong>， 
            您好！ </td>
        </tr>
        <tr> 
          <td>这是您第<%=iVisitTimes%>次登录 &lt;信贷管理系统 ver 6.3&gt;<br><br>
			<%
				if(iVisitTimes<=1)
				{
				}else if(sLastSignOutTime.compareTo(sLastVisitTime)>0 && !sLastSignOutTime.equals(""))
				{
			%>
				您上一次登录本系统是在 <%=CurPref.getUserPreference(Sqlca,"LastSignInTime")%> ，并在  <%=sLastSignOutTime%>  退出。<br><br>
			<%
				}else
				{
			%>
				您上一次登录本系统是在 <%=CurPref.getUserPreference(Sqlca,"LastSignInTime")%> ，没有正常退出。  <br><br>为了保证您的数据安全和系统运行性能，强烈建议您今后正常退出系统。<br><br>
			<%
				}
			%>
			
			<%
							if (!sPasswordState.equals("0")) {
						%>
				<strong><font size="+1" face="宋体,Arial, Helvetica, sans-serif"><%=sPasswordMessage%></font></strong>
			<%
				}
			%>
		  </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td><table width="100%" border="0" cellpadding="4" cellspacing="0">
			<tr> 
				<td height="23" background="Resources/1/workTipLine.gif"><strong>您当前可以进行的操作</strong></td>
			</tr>
				<%
					if(sPasswordState.equals("0")){
				%>
				<tr> 
				  <td> <li><a href="javascript:goToMain()">进入主页面</a> </li></td>
				</tr>
				<%
					}
				%>
				<tr> 
				  <td> <li><a href="javascript:ModifyPassword()">修改密码</a> </li></td>
				</tr>
				<%
					if(!sLastComp.equals("")){
				%>
				<tr> 
				  <td> <li><a href="javascript:goToLastVisit()">进入上一次最后访问的模块 <%
 	/* add by zxu 20050328 for Name not Module Title
 %> —— <%=sLastCompName%> <%
 	*/
 %></a> </li></td>
				</tr>
				<%
					}
						if(sPasswordState.equals("0")){
				%>
				<tr> 
				  <td> <li><a href="javascript:ShowLastRetrievedCompHelp()">查看系统在线帮助</a></li></td>
				</tr>
				<%
					}
				%>
				<tr> 
				  <td> <li><a href="javascript:sessionOut()">退出系统</a></li></td>
				</tr>
            </table></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
<script language="javascript">
function goToMain(){
	OpenComp("Main","/Main.jsp","","_self","");
}
function ModifyPassword(){
	sReturn=PopPage("/DeskTop/ModifyPassword.jsp","","dialogWidth=24;dialogHeight=17;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	if (typeof(sReturn)=="undefined" || sReturn.length==0)
		return;
	if (sReturn=="SUCCESS")
		self.open("<%=sWebRootPath%>/SessionOut.jsp?rand="+randomNumber(),"_top","");
}
function goToLastVisit(){
	OpenComp("<%=sLastComp%>","<%=sLastCompURL%>","<%=sLastCompPara%>","_self","")
}

var LastRetrievedCompID = "<%=CurComp.ID%>";
function ShowLastRetrievedCompHelp()
{ 					
		ShowCompHelp(LastRetrievedCompID);
}
function sessionOut()
{
	if(confirm("确认退出本系统吗？"))
		OpenComp("SignOut","/SignOut.jsp","","_top","");
}
<%//正常状态下默认直接进入到主页面
if(sPasswordState.equals("0")){
	out.println("goToMain();");
}else if(sPasswordState.equals("2") || sPasswordState.equals("1")){		//密码过期or初始密码
	out.println("ModifyPassword();");
}%>
</script>
<%@ include file="/IncludeEnd.jsp"%>