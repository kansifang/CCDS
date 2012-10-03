<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author: wangdw 2012/05/23
		Tester:
		Describe: 当是非公积金变更业务时进入此页面
				  变更对象、变更类型选择框
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>



<html>
<head> 
<title>输入框</title>
<script language=javascript>
	function doAction()
	{
		//变更类型
		sChangeObject = document.all("ChangeObject").value;
		sChangType = document.all("ChangType").value;
		if (sChangType == '')
		{
			alert("变更类型!");
			document.all("ChangType").focus();
			return;
		}
		if (sChangeObject == '')
		{
			alert("变更对象!");
			document.all("ChangeObject").focus();
			return;
		}
		
		self.returnValue=sChangeObject+"@"+sChangType;
		self.close();
	}
	function ChangeObject_change(sChangeObject)
	{
		//如果变更对象是申请信息则允许变更"担保信息、用途"
		if(sChangeObject=='01')
		{
			document.all("ChangType").disabled=false;
		}
		//如果变更对象是合同信息则允许变更"用途"
		else if (sChangeObject=='02')
		{
			document.all.ChangType.value="05";
			document.all("ChangType").disabled=true;
		}
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE"  onload="ChangeObject_change(ChangeObject.value)">
<br>
  <table align="center" width="250" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
     <tr> 
      <td nowarp class=black9pt bgcolor="#D8D8AF" >变更对象&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
        <td nowarp class=black9pt colspan=2  bgcolor="#F0F1DE">   
                    <select name="ChangeObject" text="">
                    <%
                    String sSql="";
                    sSql="select ItemNo,ItemName  from code_library where codeno='ChangeObject' order by SortNo";
                    ASResultSet rs=Sqlca.getASResultSet(sSql);
                    while (rs.next()) 
                    {
                        out.println("<option value='"+rs.getString(1)+"' id='ID"+rs.getString(1)+"' text='"+rs.getString(2)+"'>"+rs.getString(2)+"</option>");  
                    }
                    rs.getStatement().close();
                    %>
                    </select">
        </td>
       <td nowarp class=black9pt bgcolor="#F0F1DE">&nbsp;</td>
    </tr>
     <tr> 
      <td nowarp class=black9pt bgcolor="#D8D8AF" >变更类型&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
        <td nowarp class=black9pt colspan=2  bgcolor="#F0F1DE">        
                    <select name="ChangType" text="">
                    <%
                    String sSql1="";
                    sSql1="select ItemNo,ItemName  from code_library where codeno='ChangType'  and itemno in ('04','05') order by SortNo";
                    ASResultSet rs1=Sqlca.getASResultSet(sSql1);
                    while (rs1.next()) 
                    {
                        out.println("<option value='"+rs1.getString(1)+"' id='ID"+rs1.getString(1)+"' text='"+rs1.getString(2)+"'>"+rs1.getString(2)+"</option>");  
                    }
                    rs1.getStatement().close();
                    %>
                    </select>
        </td>
       <td nowarp class=black9pt bgcolor="#F0F1DE">&nbsp;</td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:doAction()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>