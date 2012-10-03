<%/*~BEGIN~不可编辑区~[Editable=true;CodeAreaID=Main01;Describe=注释区;]~*/%>
<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  cwliu 2004-12-3
 * Tester:
 *
 * Content: 输入项目类型和项目名称
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

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql="";
	ASResultSet rs=null;
	
	sSql = "select ItemNo,ItemName from CODE_LIBRARY where CodeNo='ProjectStyle' and IsInUse = '1' order by ItemNo";

	rs = Sqlca.getASResultSet(sSql);
	
%>
<%/*~END~*/%>	

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=主体页面;]~*/%>
<html>
<head> 
<title>请输入项目类型和项目名称</title>
</head>

<body bgcolor="#DEDFCE">
<br>
<form name="buff">
  <table align="center" width="279" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowrap align="right" class="black9pt" bgcolor="#D8D8AF" >项目类型：</td>
   
      <td nowrap bgcolor="#F0F1DE">         
        <select name="ProjectStyle">
                <%=HTMLControls.generateDropDownSelect(rs,1,2,"")%> 
        <FONT SIZE="" COLOR="FF0000">*</FONT>        
	</select>        
      </td>     
    </tr>
    <tr> 
      <td nowrap align="right" class="black9pt" bgcolor="#D8D8AF" >项目名称：</td>
      <td nowrap bgcolor="#F0F1DE" >
     	 <input name="ProjectName" value="" style="background-color:#D8D8D8">
		 <FONT SIZE="" COLOR="FF0000">*</FONT>
      </td>
    </tr>    
    <tr>
    </tr>
    <tr>
      <td nowarp bgcolor="#F0F1DE" height="30" colspan=2 align=center> 
        <input type="button" name="next" value="确定" onClick="javascript:newProject()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="取消" onClick="javascript:goBack()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</form>
</body>
</html>
<%/*~END~*/%>	

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main04;Describe=自定义函数;]~*/%>
<script language=javascript>

	//将选择的发生类型、申请人组织机构代码和申请人名称返回;
	function newProject()
	{		
		//项目类型
		var sProjectType  = document.all("ProjectStyle").value;
		//项目名称
		var sProjectName = document.all("ProjectName").value;
		if(sProjectType=="")
		{
			alert("请输入项目类型！");
			return;
		}
				
		if(sProjectName=="")
		{
			alert("请输入项目名称！");
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