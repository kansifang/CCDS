<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang   2008-10-16
 * Tester:
 *
 * Content: ѡ���ĵ����͡��ĵ����ơ���������·��
 * Input Param:
 *				�������ͣ�ObjectType
 *					��BusinessApply���������
 *          ��Customer���ͻ�����
 *					��Classify���弶���ࣩ
 *				�����ţ�ObjectNo
 *					������/��ͬ��ˮ����/�ͻ����
 * Output param: 			
 *			�������ͣ�ObjectType
 * 			�����ţ�ObjectNo
 *			�ĵ����ͣ�DocumentType
 *			�ĵ����ƣ�DocName
 *			������Ϣ��AttachmentFileName
 * 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,����)�����Զ���Ӧwindow_open
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	sObjectNo= sObjectNo.trim();
	
%>
<html>
<head> 
<title>��ѡ���ĵ���Ϣ</title>
</head>

<script language=javascript>

	function checkItems()
	{
		//������Ϸ���
		var sFileName="";
		
	
		if (document.forms("SelectAttachment").DocName.value=="")
		{
			alert("�����븽�����ƣ�");
			document.forms("SelectAttachment").DocName.focus();
			return false;
		}
		
		sFileName  = document.forms("SelectAttachment").AttachmentFileName.value;				
		if (sFileName=="")			
		{
			alert("��ѡ��һ���ļ�����");
			return false;
		}	
		else
			return true;			
	}	
	
	function UploadInfo()
	{
		if(checkItems()) 
		{
			//document.forms("SelectAttachment").DocumentType.value=document.forms("SelectAttachment").DocumentType.value;
			
			document.forms("SelectAttachment").submit();			
		}
					
	}	
	
</script>

<body class="ShowModalPage" leftmargin="0" topmargin="0"  >
<br>
<form name="SelectAttachment"  method="post" ENCTYPE="multipart/form-data"  action="AttachmentUpload.jsp?CompClientID=<%=CurComp.ClientID%>">
<input type="hidden" name="ObjectType" value="<%=sObjectType%>">
<input type="hidden" name="ObjectNo" value="<%=sObjectNo%>">
<input type="hidden" name="PageClientID" value="<%=CurPage.ClientID%>"> 
<input type="hidden" name="DocumentType" value="">
  <table align="center" width="100%" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
  <%if(!"CS".equals(sObjectType)){%>
    <tr> 
      <td nowrap align="right" class="black9pt">��ѡ���ĵ����ͣ�</td>
      <td nowrap >       
        <select  name="DocumentTypeValue" >
					<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'DocumentType'",1,2,"")%> 
        </select>      
      </td>
    </tr>
    <tr> 
  <%}%>  
      <td nowrap align="right" class="black9pt">�������ĵ����ƣ� </td>
      <td nowrap ><input name="DocName" value="" size=30 style="background-color:#FFFFFF"></td>
    </tr> 

   	<tr>
    	<td nowrap align="right" class="black9pt">�������ݣ�ѡ���ļ��� </td>
    	<td>
      	<input type="file" size=40  name="AttachmentFileName">
    	</td>
    </tr>
    <tr>
     <td nowrap align="right" class="black9pt"><%=HTMLControls.generateButton("ȷ��","","javascript:UploadInfo()",sResourcesPath)%></td>
     <td nowrap align="left" class="black9pt"><%=HTMLControls.generateButton("ȡ��","","javascript:self.returnValue='_none_';self.close()",sResourcesPath)%></td>
    </tr>
  </table>  
</form>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>