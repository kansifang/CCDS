<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  xhwang1  2007-12-13
 * Tester:
 *
 * Content: �����ѯ����
 * Input Param:
 * Output param:
 *			ReturnValue:���¼�ֵ׼��ʱʹ�õ��ֽ�������  
 * History Log:
 *			
 */			
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>	��ѡ���ֽ�������</title>
</head>
<body bgcolor="#E4E4E4">
<P>&nbsp;</p>
<center>
<form name="Query" method=post action="">
    <table width="100%" align='center' border="1" cellspacing="0" cellpadding="4" bgcolor="#E4E4E4" bordercolor="#999999" bordercolordark="#FFFFFF" >
      <tr>
        <td class=black9pt bgcolor="#F0F1DE" >��ѡ��Ԥ���ֽ�������</td>
        <td colspan=2 bgcolor="#F0F1DE" >
       	<select name="Grade">
       	   <OPTION value="02" >֧���϶����</OPTION>
       	   <OPTION value="03" >�����϶����</OPTION>
       	   <OPTION value="04" selected>�����϶����</OPTION>
       	   <OPTION value="06" >����϶����</OPTION>
		</select>
		  </td>
        <td class=black9pt bgcolor="#F0F1DE" >&nbsp;</td>
    </tr>

      <tr>
     </tr>
   </table>
   <table align="center" width="540" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#D8D8D8'>
	<tr>
     <td nowrap align="right" class="black9pt" bgcolor="#E4E4E4" >
     	<%=HTMLControls.generateButton("ȷ��","ȷ��","javascript:doQuery()",sResourcesPath)%>
      </td>
     <td nowrap align="left" class="black9pt" bgcolor="#E4E4E4" >
      	<%=HTMLControls.generateButton("ȡ��","ȡ��","javascript:doCancel()",sResourcesPath)%>
      </td>
    </tr>
  </table>
</form>
</center>
</body>
</html>


<script language="javascript">

  
	//ȡ��
	function doCancel()
	{
		self.returnValue="";
		window.close();
	}
	
	function doQuery()
	{
		self.returnValue = Query.Grade.value;
		self.close();		
	}


</script>

<%@ include file="/IncludeEnd.jsp"%>