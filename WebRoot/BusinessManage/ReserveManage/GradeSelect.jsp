<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  xhwang1  2007-12-13
 * Tester:
 *
 * Content: 输入查询内容
 * Input Param:
 * Output param:
 *			ReturnValue:更新减值准备时使用的现金流级别  
 * History Log:
 *			
 */			
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>	请选择现金流级别</title>
</head>
<body bgcolor="#E4E4E4">
<P>&nbsp;</p>
<center>
<form name="Query" method=post action="">
    <table width="100%" align='center' border="1" cellspacing="0" cellpadding="4" bgcolor="#E4E4E4" bordercolor="#999999" bordercolordark="#FFFFFF" >
      <tr>
        <td class=black9pt bgcolor="#F0F1DE" >请选择预测现金流级别</td>
        <td colspan=2 bgcolor="#F0F1DE" >
       	<select name="Grade">
       	   <OPTION value="02" >支行认定结果</OPTION>
       	   <OPTION value="03" >分行认定结果</OPTION>
       	   <OPTION value="04" selected>总行认定结果</OPTION>
       	   <OPTION value="06" >审计认定结果</OPTION>
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
     	<%=HTMLControls.generateButton("确定","确定","javascript:doQuery()",sResourcesPath)%>
      </td>
     <td nowrap align="left" class="black9pt" bgcolor="#E4E4E4" >
      	<%=HTMLControls.generateButton("取消","取消","javascript:doCancel()",sResourcesPath)%>
      </td>
    </tr>
  </table>
</form>
</center>
</body>
</html>


<script language="javascript">

  
	//取消
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