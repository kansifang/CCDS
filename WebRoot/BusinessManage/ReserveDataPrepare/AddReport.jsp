<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu  2009.11.03
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>请输入相关信息</title>

<script language=javascript>

	function selectAccountMonth()
	{	
		
		var sAccountMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=21;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sAccountMonth)!="undefined" && sAccountMonth!="")
		{	
			document.all("AccountMonth").value=sAccountMonth;
		}
		else
		{
			document.all("AccountMonth").value="";
		}
	}
	
	function newReport()
	{
		var sAccountMonth = document.all("AccountMonth").value;
		var sRptType = document.all("RptType").value;
				
		//检查会计月份是否选择
		if (sAccountMonth == '')
		{
			alert("请选择会计月份");
			document.all("AccountMonth").focus();
			return;
		}
		//检查报表类型
		if(sRptType == '')
		{
			alert("请选择报表类型");
			document.all("RptType").focus();
			return;
		}
		
		
		//返回变量：细化的客户类型、客户名称、客户证件类型、证件号
		self.returnValue=sAccountMonth+"@"+sRptType;
		self.close();
	}

</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
  	<tr>
  		<td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >会计月份&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
  		<td nowarp bgcolor="#F0F1DE">
  			<input type='text' name="AccountMonth" value="" readonly="readonly" onclick="selectAccountMonth()">
  		</td>
  	</tr>
     <%	    
		String sSql="select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'RptType' order by SortNo ";
	 %>
    <tr> 
      
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >报表类型&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <select name="RptType">
        	<%=HTMLControls.generateDropDownSelect(Sqlca,sSql,1,2,"")%> 
        </select>
      </td>
    </tr> 
   <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >所属机构&nbsp;<font color="#ff0000"></font>&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE"> 
        <input type='text' name="OrgName" value="<%=CurOrg.OrgName %>" readonly="readonly">
      </td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:newReport()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>