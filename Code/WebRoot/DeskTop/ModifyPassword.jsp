
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jytian  2005.01.09
		Tester:
		Content: �޸�����
		Input Param:
			      
		Output param:
			              
		History Log: 
		
	 */
	%>
<%/*~END~*/%>

<html> 
<head>
<title>�޸�����--��ǰ�û�:<%=CurUser.UserName%></title> 
<%!
    boolean PasswordCheckRule(Transaction Sqlca,String sPwd) throws Exception
    {
        boolean b1;
        boolean b2;
        //String pn1="^(?=.*\\d).{8,}$"; //���ȴ���8�ұ����������
        //String pn2="^\\d*$"; //����ȫ������
		String sPn1 = Sqlca.getString("select ItemAttribute from CODE_LIBRARY where CodeNo='SecurityAuditOption' and ItemName='PWDCheckRule'");
		String sPn2 = Sqlca.getString("select Attribute1 from CODE_LIBRARY where CodeNo='SecurityAuditOption' and ItemName='PWDCheckRule'");
		System.out.print("sPasswordChek1:["+sPn1+"]");
		System.out.print("sPasswordChek2:["+sPn2+"]");
		if (sPn1==null&&sPn1.equals(""))
			b1 = true;
		else
		    b1 = java.util.regex.Pattern.matches(sPn1, sPwd);
		if (sPn2==null&&sPn2.equals(""))
			b2 = true;
		else
            b2 = !java.util.regex.Pattern.matches(sPn2, sPwd);
        return b1&b2;
    }
%>
<%
	String IsChecked = request.getParameter("hasChecked");
	String oldPassword = request.getParameter("oldPassword");
	String newPassword = request.getParameter("newPassword1");
	if((IsChecked!=null) && IsChecked.equals("1"))
	{
			MD5 md5 = new MD5();
			String sEncOldPassword = md5.getMD5ofStr(oldPassword);
			String sEncNewPassword = md5.getMD5ofStr(newPassword);
			String sSql = "select UserID from USER_INFO where UserID = '"+CurUser.UserID+"' and Password = '"+sEncOldPassword+"' ";
			ASResultSet rs= Sqlca.getResultSet(sSql);			
			if(rs.next())
			{
				if (PasswordCheckRule(Sqlca,newPassword)) {
					Sqlca.executeSQL("Update USER_INFO set Password = '"+sEncNewPassword+"',UpdateDate='"+StringFunction.getToday()+"' where UserID = '"+CurUser.UserID+"' ");
					Sqlca.executeSQL("Update USER_PREF set PreferenceValue='0' where UserID = '"+CurUser.UserID+"' and PreferenceID='PasswordState'");
					%>
					<script language = javascript>
						alert("�����޸ĳɹ�!�����µ�¼ϵͳ!");	//ygwang modify
						self.returnValue="SUCCESS";
						self.close();
					</script>
					<%
					rs.getStatement().close();
				} else {
					%>
					<script language = javascript>
						alert("�����벻����Ҫ������������!\n<%=Sqlca.getString("select ItemDescribe from CODE_LIBRARY where CodeNo='SecurityAuditOption' and ItemName='PWDCheckRule'")%>��");
						self.close();
					</script>
					<%
				}
			} else{
			%>
			<script language = javascript>
				alert("ԭ�����������������!");
				self.close();
			</script>
			<%
			}
	}

%>


<script language = javascript>
	function encryptPassword1(mypassword)
	{
		var myResult='';
 		for(var i=0;i<mypassword.length;i++)
 		{
 			s=mypassword.charCodeAt(i);
 			s = s ^ 1;
 			myResult =myResult+String.fromCharCode(s)	
 		}
 		return myResult;
	}
	function encryptPassword(mypassword)
	{
		var myResult=''
		for(var i=mypassword.length-1;i>=0;i--)
		{
			s=mypassword.substr(i,1);
			myResult=myResult+s;            //����
		}
		return myResult;	
	}
	
	function test()
	{
		smyOldPassword  = document.forms("ModifyPassword").oldPassword.value;
		alert(smyOldPassword);
		var getmypass = encryptPassword(smyOldPassword);
		alert("changedPass"+getmypass);
		var oldpass = encryptPassword(getmypass);
		alert(oldpass);
	}

	function canclePassword()
	{
		if ("<%=CurUser.Password%>" == "C4CA4238A0B923820DCC509A6F75849B") {
			alert("��ĵ�ǰ����Ϊϵͳ��ʼ�����룬���ȱ�����룡");
			return false;
		}
		self.close();
	}

	function checkpassword()
	{
		sOldPassword  = document.forms("ModifyPassword").oldPassword.value;	
		sPassword1  = document.forms("ModifyPassword").newPassword1.value;
		sPassword2  = document.forms("ModifyPassword").newPassword2.value;
		
		if(sOldPassword=="")
		{
			alert("������ԭ��������!");
			return false;
		}			
		if(sPassword1=="" && sPassword2=="")
		{
			alert("�����벻��Ϊ��");
			return false;
		}
		if(sPassword1!=sPassword2)
		{
			alert("������������벻һ��!");
			return false;
		}
        sReturn=PopPage("/DeskTop/ModifyPassword.jsp?oldPassword="+sOldPassword+"&newPassword1="+sPassword1+"&hasChecked=1","_self","dialogWidth=24;dialogHeight=18;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sReturn)=="undefined" || sReturn.length==0)
			return false;
		if (sReturn=="SUCCESS") {
			self.returnValue="SUCCESS";
			self.close();
		}
		return true;
	}
</script>

<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head> 

<body bgcolor="#DEDFCE">
<P></P>
<form name = ModifyPassword action = ModifyPassword.jsp method = post>
			
<table align="center" width="279" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr>	
    		<td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25">
      			�û����:&nbsp;
    		</td>
     		<td nowarp bgcolor="#F0F1DE"> <%=CurUser.UserID%></td>
  	</tr>
    	<tr> 
    		<td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25">
      			�û�����:&nbsp;
    		</td>
    		<td nowarp bgcolor="#F0F1DE"><%=CurUser.UserName%></td>
  	</tr>
  	<tr> 
    		<td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25">
      			�û�����:&nbsp;
    		</td>
    		<td nowarp bgcolor="#F0F1DE"><%=CurOrg.OrgName%></td>
  	</tr>
  	<tr> 
    		<td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >
      			��ʼ����:&nbsp;
    		</td>
    		<td nowarp bgcolor="#F0F1DE"><input type = password name = oldPassword ></td>
  	</tr>
  	<tr> 
    		<td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >
      			��������:&nbsp;
    		</td>
    		<td nowarp bgcolor="#F0F1DE"><input type = password name = newPassword1></td>
  	</tr>
  	<tr> 
    		<td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >
      			ȷ������:&nbsp;
    		</td>
    		<td nowarp bgcolor="#F0F1DE"><input type = password name = newPassword2></td>
  	</tr> 
  	<tr> 
    		<td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
    		<td nowarp bgcolor="#F0F1DE" height="25">  
      			<input type=button name="Submit" value= 'ȷ��'  onclick= " javascript:checkpassword();" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(<%=sWebRootPath%>/Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>&nbsp;&nbsp;&nbsp;


     			<input type=reset name="Cancel" value= 'ȡ��' onclick= " javascript:canclePassword()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(<%=sWebRootPath%>/Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'> 
   		</td>
  	</tr>
 
 </table>
	<input type = hidden name = "hasChecked" value = "1">

</form>

</body>
</html>
<script language="javascript" for="document" event="onkeydown">

if(event.keyCode==13 && event.srcElement.type!='button' && event.srcElement.type!='submit' && event.srcElement.type!='reset' && event.srcElement.type!='textarea' && event.srcElement.type!='')
event.keyCode=9;

</script>


<%@ include file="/IncludeEnd.jsp"%>

