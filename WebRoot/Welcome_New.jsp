<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:    lpzhang 2009-8-5 
		Tester:
		Content: ��ӭҳ��
		Input Param:
			          
		Output param:
			      
		History Log: 
	 */
	%>
<%/*~END~*/%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>Welcome ��ӭ����</title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.OrangeFont {
	color: #FC5C04;
	font-size: 12px;
	font-family:tahoma,����;
}
.bg_map_background {
	background-image: url(Resources/Public/welcome_map.jpg);
	background-position: right top;
	background-repeat: no-repeat;
}
.OrangeBox {
	border: 1px solid #FC5C04;
}
.px12 {
	font-size: 12px;
	line-height: 20px;
	font-family:tahoma,����;
}
.STYLE1 {color: #FC5C04; font-size: 12px; font-weight: bold;margin-top: 0px; }
-->
</style>
</head>

<body style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
  <tr>
    <td valign="top" background="Resources/Public/welcome_bg.jpg">
    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
      <tr> 
		<td valign="top">
		 	<iframe name=myrefresh0 frameborder=0 width=1 height=1 src="<%=sWebRootPath%>/SessionClose.jsp" style="display:none"> </iframe>
		</td>
	  </tr>
      <tr  height="1">
        <td valign="top"><img src="Resources/1/1x1.gif" alt="welcome header" width="451" height="100" /></td>
      </tr>
      <tr>
        <td class="bg_map_background" valign="top" >
        <table width="100%" border="0" cellspacing="0" cellpadding="3">
		<tr>
			<td width="160" valign="top" >&nbsp;</td>
			<td><img src="Resources/1/1x1.gif" alt="welcome" width="304" height="88" /></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="160" valign="top" >&nbsp;</td>
			<td valign="bottom"class="STYLE1">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="160" align="right" valign="top"><img src="Resources/Public/welcome_sound.jpg" alt="sound" width="26" height="36" /></td>
			<td class="px12"><table width="100%" border="0" cellpadding="5" cellspacing="0">        
			<td height="35" valign="bottom" class="STYLE1"><p><%=CurUser.UserName%></font></strong>�����ã� </p></td>
        </tr>
        <tr>
        	<%
		  	//ȡ��Ʒ���ơ��汾��
			String sProductName = CurConfig.getConfigure("ProductName");
			String sProductVersion = CurConfig.getConfigure("ProductVersion");
		  	%>
          	<td>��������<%=iVisitTimes%>�ε�¼ &lt;<%=sProductName%> ver <%=sProductVersion%>&gt;<br><br>
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
			<%}%>
			
			<%
			if (!sPasswordState.equals("0")) {
			%>
				<strong><font size="+1" face="����,Arial, Helvetica, sans-serif"><%=sPasswordMessage %></font></strong>
			<%
			}
			%>
		  </td>
        </tr>
        <tr> 
          <td><img src="Resources/Public/welcome_available_action.jpg" alt="available action" width="304" height="47" /></td> <!--����ǰ���Խ��еĲ���-->
        </tr>
        <tr> 
          <td class="STYLE1">
			<table>
			<tr>
				<%
				if(sPasswordState.equals("0")){
				%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","������ҳ��","������ҳ��","javascript:goToMain()",sResourcesPath)%>
				</td>
				<%}%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�޸�����","�޸�����","javascript:ModifyPassword()",sResourcesPath)%>
				</td>
				<%
				if(!sLastComp.equals("")){
				%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","������һ�������ʵ�ģ��","������һ�������ʵ�ģ��","javascript:goToLastVisit()",sResourcesPath)%>
				</td>
				<%
				}
				if(sPasswordState.equals("0")){
				%>
				<!-- <tr> 
				  <td> <li><a href="javascript:ShowLastRetrievedCompHelp()">�鿴ϵͳ���߰���</a></li></td>
				</tr> -->
				<!--td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","���߰���","�鿴ϵͳ���߰���","javascript:ShowLastRetrievedCompHelp()",sResourcesPath)%>
				</td-->
				<%}%>
				<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�˳�ϵͳ","�˳�ϵͳ","javascript:sessionOut()",sResourcesPath)%>
				</td>
			</tr>
            </table>
           </td>
        </tr>
      </table></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td width="160">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td width="160">&nbsp;</td>
            <td class="STYLE1">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td width="160">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
        <p>&nbsp;</p>
          <p>&nbsp;</p></td>
      </tr>
    </table></td>
  	</tr>
	<tr>
    	<td height="20" bgcolor="#000080" style="font-size: 12px;color:white;font-family:tahoma,����;" align="center">Powered by <b>Amarsoft</b> | AmarBank Lending Suite</td>
  	</tr>
</table>
</body>
</html>
<script type="text/javascript">
function goToMain(){
	OpenComp("Main","/Main.jsp","","_self","");
}
function ModifyPassword(){
	var sReturn=PopPage("/DeskTop/ModifyPassword.jsp","","dialogWidth=24;dialogHeight=17;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	if (typeof(sReturn)=="undefined" || sReturn.length==0)
		return;
	if (sReturn=="SUCCESS")
		self.open("<%=sWebRootPath%>/SessionOut.jsp?rand="+randomNumber(),"_top","");
}
function goToLastVisit(){
	OpenComp("<%=sLastComp%>","<%=sLastCompURL%>","<%=sLastCompPara%>","_self","");
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
/*
var sTestChinese = PopPage("/Frame/Test/TestChinese.jsp?TestChinese=���������ַ���&rand="+randomNumber(),"_blank","");
if(sTestChinese=="success"){
}else{
	alert("��һ̨�ͻ����޷���ȷ���������ַ�,��ᵼ��ϵͳ��������ϵͳ����Ա��ϵ��");
	window.open("index.html","_top");
}
*/
//�����ڼ��Զ�����
goToMain();
</script>
<%@ include file="/IncludeEnd.jsp"%>