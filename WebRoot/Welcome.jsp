<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%
 	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
 %>
	<%
		/*
			Author:   
			Tester:
			Content: ��ҳ��
			Input Param:
		          
			Output param:
		      
			History Log: 2005/10/15 zywei �����û����밲ȫ��ƹ���
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
<title>Welcome ��ӭ</title>
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
          <td> <strong><font size="+1" face="����,Arial, Helvetica, sans-serif"><%=CurUser.UserName%></font></strong>�� 
            ���ã� </td>
        </tr>
        <tr> 
          <td>��������<%=iVisitTimes%>�ε�¼ &lt;�Ŵ�����ϵͳ ver 6.3&gt;<br><br>
			<%
				if(iVisitTimes<=1)
				{
				}else if(sLastSignOutTime.compareTo(sLastVisitTime)>0 && !sLastSignOutTime.equals(""))
				{
			%>
				����һ�ε�¼��ϵͳ���� <%=CurPref.getUserPreference(Sqlca,"LastSignInTime")%> ������  <%=sLastSignOutTime%>  �˳���<br><br>
			<%
				}else
				{
			%>
				����һ�ε�¼��ϵͳ���� <%=CurPref.getUserPreference(Sqlca,"LastSignInTime")%> ��û�������˳���  <br><br>Ϊ�˱�֤�������ݰ�ȫ��ϵͳ�������ܣ�ǿ�ҽ�������������˳�ϵͳ��<br><br>
			<%
				}
			%>
			
			<%
							if (!sPasswordState.equals("0")) {
						%>
				<strong><font size="+1" face="����,Arial, Helvetica, sans-serif"><%=sPasswordMessage%></font></strong>
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
				<td height="23" background="Resources/1/workTipLine.gif"><strong>����ǰ���Խ��еĲ���</strong></td>
			</tr>
				<%
					if(sPasswordState.equals("0")){
				%>
				<tr> 
				  <td> <li><a href="javascript:goToMain()">������ҳ��</a> </li></td>
				</tr>
				<%
					}
				%>
				<tr> 
				  <td> <li><a href="javascript:ModifyPassword()">�޸�����</a> </li></td>
				</tr>
				<%
					if(!sLastComp.equals("")){
				%>
				<tr> 
				  <td> <li><a href="javascript:goToLastVisit()">������һ�������ʵ�ģ�� <%
 	/* add by zxu 20050328 for Name not Module Title
 %> ���� <%=sLastCompName%> <%
 	*/
 %></a> </li></td>
				</tr>
				<%
					}
						if(sPasswordState.equals("0")){
				%>
				<tr> 
				  <td> <li><a href="javascript:ShowLastRetrievedCompHelp()">�鿴ϵͳ���߰���</a></li></td>
				</tr>
				<%
					}
				%>
				<tr> 
				  <td> <li><a href="javascript:sessionOut()">�˳�ϵͳ</a></li></td>
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
	if(confirm("ȷ���˳���ϵͳ��"))
		OpenComp("SignOut","/SignOut.jsp","","_top","");
}
<%//����״̬��Ĭ��ֱ�ӽ��뵽��ҳ��
if(sPasswordState.equals("0")){
	out.println("goToMain();");
}else if(sPasswordState.equals("2") || sPasswordState.equals("1")){		//�������or��ʼ����
	out.println("ModifyPassword();");
}%>
</script>
<%@ include file="/IncludeEnd.jsp"%>