<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2011/05/26
		Tester:
		Describe: ��鱨������ѡ���
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>



<html>
<head> 
<title>�����</title>
<script language=javascript>
	function doAction()
	{
		//�̴������
		sCommercialNo = document.all("CommercialNo").value;
		sAccumulationNo = document.all("AccumulationNo").value;	
		//����̴�������Ƿ�����
		if (sCommercialNo == '')
		{
			alert("�������̴������!");
			document.all("CommercialNo").focus();
			return;
		}
		//���ί��������Ƿ�����
		if (sAccumulationNo == '')
		{
			alert("������ί�������!");
			document.all("AccumulationNo").focus();
			return;
		}
		self.returnValue=sCommercialNo+"@"+sAccumulationNo;
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
      <td nowarp class=black9pt bgcolor="#D8D8AF" >�̴������&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
        <td nowarp class=black9pt colspan=2  bgcolor="#F0F1DE">        
           <input type="text" name="CommercialNo" value="" class="put">        
        </td>
       <td nowarp class=black9pt bgcolor="#F0F1DE">&nbsp;</td>
    </tr>
     <tr> 
      <td nowarp class=black9pt bgcolor="#D8D8AF" >ί�������&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
        <td nowarp class=black9pt colspan=2  bgcolor="#F0F1DE">        
           <input type="text" name="AccumulationNo" value="" class="put">        
        </td>
       <td nowarp class=black9pt bgcolor="#F0F1DE">&nbsp;</td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:doAction()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>