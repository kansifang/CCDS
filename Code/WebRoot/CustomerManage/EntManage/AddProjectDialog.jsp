<%/*~BEGIN~���ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=ע����;]~*/%>
<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  cwliu 2004-12-3
 * Tester:
 *
 * Content: ������Ŀ���ͺ���Ŀ����
 * Input Param:

 * Output param:
 *             ReturnValue:sProjectStyle@sProjectName
 *
 *
 * History Log:	
 *
 */
%>
<%/*~END~*/%>	


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql="";
	ASResultSet rs=null;
	
	sSql = "select ItemNo,ItemName from CODE_LIBRARY where CodeNo='ProjectStyle' and IsInUse = '1' order by ItemNo";

	rs = Sqlca.getASResultSet(sSql);
	
%>
<%/*~END~*/%>	

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=����ҳ��;]~*/%>
<html>
<head> 
<title>��������Ŀ���ͺ���Ŀ����</title>
</head>

<body bgcolor="#DEDFCE">
<br>
<form name="buff">
  <table align="center" width="279" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowrap align="right" class="black9pt" bgcolor="#D8D8AF" >��Ŀ���ͣ�</td>
   
      <td nowrap bgcolor="#F0F1DE">         
        <select name="ProjectStyle">
                <%=HTMLControls.generateDropDownSelect(rs,1,2,"")%> 
        <FONT SIZE="" COLOR="FF0000">*</FONT>        
	</select>        
      </td>     
    </tr>
    <tr> 
      <td nowrap align="right" class="black9pt" bgcolor="#D8D8AF" >��Ŀ���ƣ�</td>
      <td nowrap bgcolor="#F0F1DE" >
     	 <input name="ProjectName" value="" style="background-color:#D8D8D8">
		 <FONT SIZE="" COLOR="FF0000">*</FONT>
      </td>
    </tr>    
    <tr>
    </tr>
    <tr>
      <td nowarp bgcolor="#F0F1DE" height="30" colspan=2 align=center> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:newProject()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:goBack()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</form>
</body>
</html>
<%/*~END~*/%>	

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main04;Describe=�Զ��庯��;]~*/%>
<script language=javascript>

	//��ѡ��ķ������͡���������֯������������������Ʒ���;
	function newProject()
	{		
		//��Ŀ����
		var sProjectType  = document.all("ProjectStyle").value;
		//��Ŀ����
		var sProjectName = document.all("ProjectName").value;
		if(sProjectType=="")
		{
			alert("��������Ŀ���ͣ�");
			return;
		}
				
		if(sProjectName=="")
		{
			alert("��������Ŀ���ƣ�");
			return;
		}	
		self.returnValue="&ProjectType="+sProjectType+"&ProjectName="+sProjectName;
		self.close();
		
	}
	function goBack(){
		self.returnValue='';
		self.close();
	}
</script>
<%/*~END~*/%>	
<% rs.getStatement().close();%>

<%@ include file="/IncludeEnd.jsp"%>