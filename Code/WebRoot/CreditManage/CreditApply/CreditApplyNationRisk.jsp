<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  lpzhang 2010-1-19 
		
	 */
	%>
<%/*~END~*/%>
<script language=javascript>

	function getNationRisk()
	{
		var sNationRisk = document.all("NationRisk").value;
		self.returnValue=sNationRisk;
		self.close();
	}
</script>
<html>
<head> 
<title>��ѡ���Ƿ������ҵ���϶�Ϊ�ͷ���</title>


<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
<table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
     <tr> 
      <td nowarp align="left" class="black9pt" bgcolor="#D8D8AF" >�Ƿ������ҵ���϶�Ϊ�ͷ���&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <select name="NationRisk"">
	    //�Ƿ�ͷ�����֤
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'YesNo'  and isinuse='1' order by SortNo ",1,2,"")%> 
        </select>
        
      </td>
    </tr>
  </table>
  <br>
  <br>
   <br>
   <br>
   <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" name="next" value="ȷ��" onClick="javascript:getNationRisk()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
    </tr>
    </table>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>