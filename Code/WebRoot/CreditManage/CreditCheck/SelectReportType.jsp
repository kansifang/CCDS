<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu  2009.11.03
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>�����������Ϣ</title>

<script language=javascript>
	
	function newReport()
	{
		var sRptType = document.all("RptType").value;
				
		//��鱨������
		if(sRptType == '')
		{
			alert("��ѡ�񱨱�����");
			document.all("RptType").focus();
			return;
		}
		
		//���ر�����ϸ���Ŀͻ����͡��ͻ����ơ��ͻ�֤�����͡�֤����
		self.returnValue=sRptType;
		self.close();
	}

</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >��������&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <select name="RptType">
       		<option value=""></option>
        	<option value="01">��˾��һ����ճ����鱨��</option>
        	<option value="02">��˾��ͷ��ճ����鱨��</option>
        	<option value="03">���˿ͻ������鱨��</option>
        </select>
      </td>
    </tr> 
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:newReport()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>