<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: xhyong 2010/02/01
 * Tester:
 *
 * Content:      ѡ������������
 * Input Param:
 *		
 * Output param:
 *		
 * History Log: 
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������	    

	//����������
	
	//���ҳ�����
	//���ҳ�������
	//����ֵת��Ϊ���ַ���			
%>
<%/*~END~*/%>
<html>
<head> 
<title>����������������</title>

<script language=javascript>

	function selectAssessFormType()
	{		
		var sAssessFormType = "";
		sAssessFormType = document.all("AssessFormType").value;
		if(sAssessFormType=="")
		{
			alert("��ѡ��������!");
			return;
		}
			
		self.returnValue=sAssessFormType+"@";//���ز���
		self.close();
	}

	
</script>

<style TYPE="text/css">
.changeColor{ background-color: #F0F1DE  }
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
<form name="buff">
  <table align="center" width="280" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
  	<tr> 
	<td nowarp align="left" class="black9pt" bgcolor="#F0F1DE" ></td>
	<td nowarp bgcolor="#F0F1DE" > ������:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="AssessFormType" >
			<%=HTMLControls.generateDropDownSelect(Sqlca,"Select ItemNo,ItemName From CODE_LIBRARY Where CodeNo = 'AssessFormType' and isinuse='1' ",1,2,"")%>
		</select>
	</td>
	</tr>
  </table>
  
  <br>
  <table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr >
     <td nowrap align="right" class="black9pt"  ><%=HTMLControls.generateButton("ȷ��","","javascript:selectAssessFormType()",sResourcesPath)%></td>
     <td nowrap  ><%=HTMLControls.generateButton("ȡ��","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>