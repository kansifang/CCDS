<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2006-03-18
		Tester:
		Describe: Ԥ���ź�״̬ѡ���;
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>ѡ��Ԥ���ź�״̬</title>
<script language=javascript>
function newSignalStatus()
{
		self.returnValue=document.all("NewSignalStatus").value;
		self.close();
}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
  <table align="center" width="250" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >ѡ��Ԥ���ź�״̬��</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <select name="NewSignalStatus">
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'SignalStatus' and (ItemNo = '30' or ItemNo = '40') ",1,2,"")%> 
        </select>
      </td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:newSignalStatus()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>