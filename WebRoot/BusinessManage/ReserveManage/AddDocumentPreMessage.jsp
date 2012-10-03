<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang   2008-10-16
 * Tester:
 *
 * Content: 选择文档类型、文档名称、附件所在路径
 * Input Param:
 *				对象类型：ObjectType
 *					—BusinessApply（申请对象）
 *          —Customer（客户对象）
 *					—Classify（五级分类）
 *				对象编号：ObjectNo
 *					—申请/合同流水号码/客户编号
 * Output param: 			
 *			对象类型：ObjectType
 * 			对象编号：ObjectNo
 *			文档类型：DocumentType
 *			文档名称：DocName
 *			附件信息：AttachmentFileName
 * 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,参数)它会自动适应window_open
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	sObjectNo= sObjectNo.trim();
	
%>
<html>
<head> 
<title>请选择文档信息</title>
</head>

<script language=javascript>

	function checkItems()
	{
		//检查代码合法性
		var sFileName="";
		
	
		if (document.forms("SelectAttachment").DocName.value=="")
		{
			alert("请输入附件名称！");
			document.forms("SelectAttachment").DocName.focus();
			return false;
		}
		
		sFileName  = document.forms("SelectAttachment").AttachmentFileName.value;				
		if (sFileName=="")			
		{
			alert("请选择一个文件名！");
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
      <td nowrap align="right" class="black9pt">请选择文档类型：</td>
      <td nowrap >       
        <select  name="DocumentTypeValue" >
					<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'DocumentType'",1,2,"")%> 
        </select>      
      </td>
    </tr>
    <tr> 
  <%}%>  
      <td nowrap align="right" class="black9pt">请输入文档名称： </td>
      <td nowrap ><input name="DocName" value="" size=30 style="background-color:#FFFFFF"></td>
    </tr> 

   	<tr>
    	<td nowrap align="right" class="black9pt">附件内容（选择文件） </td>
    	<td>
      	<input type="file" size=40  name="AttachmentFileName">
    	</td>
    </tr>
    <tr>
     <td nowrap align="right" class="black9pt"><%=HTMLControls.generateButton("确认","","javascript:UploadInfo()",sResourcesPath)%></td>
     <td nowrap align="left" class="black9pt"><%=HTMLControls.generateButton("取消","","javascript:self.returnValue='_none_';self.close()",sResourcesPath)%></td>
    </tr>
  </table>  
</form>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>