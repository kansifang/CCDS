<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: xhyong 2010/02/01
 * Tester:
 *
 * Content:      选择评定表类型
 * Input Param:
 *		
 * Output param:
 *		
 * History Log: 
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量	    

	//获得组件参数
	
	//获得页面参数
	//获得页面参数：
	//将空值转化为空字符串			
%>
<%/*~END~*/%>
<html>
<head> 
<title>请输入评定表名称</title>

<script language=javascript>

	function selectAssessFormType()
	{		
		var sAssessFormType = "";
		sAssessFormType = document.all("AssessFormType").value;
		if(sAssessFormType=="")
		{
			alert("请选择评定表!");
			return;
		}
			
		self.returnValue=sAssessFormType+"@";//返回参数
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
	<td nowarp bgcolor="#F0F1DE" > 评定表:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="AssessFormType" >
			<%=HTMLControls.generateDropDownSelect(Sqlca,"Select ItemNo,ItemName From CODE_LIBRARY Where CodeNo = 'AssessFormType' and isinuse='1' ",1,2,"")%>
		</select>
	</td>
	</tr>
  </table>
  
  <br>
  <table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr >
     <td nowrap align="right" class="black9pt"  ><%=HTMLControls.generateButton("确认","","javascript:selectAssessFormType()",sResourcesPath)%></td>
     <td nowrap  ><%=HTMLControls.generateButton("取消","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>