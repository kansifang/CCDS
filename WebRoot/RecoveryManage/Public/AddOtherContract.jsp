<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>

<%/*~END~*/%>


<html>
<head> 
<title>������ͻ���Ϣ</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>

<%/*~END~*/%>


<script language=javascript>

	function newDuebill()
	{
		sSerialNo = document.all("SerialNo").value;			
		
		if (sSerialNo == '')
		{
			alert(getBusinessMessage('104'));//�ͻ����Ʋ���Ϊ�գ�
			document.all("SerialNo").focus();
			return;
		}
		
		//���ر�����ϸ���Ŀͻ����͡��ͻ����ơ��ͻ�֤�����͡�֤����
		self.returnValue=sSerialNo
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
      
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >�������ͬ��ˮ��&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="SerialNo" value="">
      </td>
    </tr> 
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:newDuebill()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>