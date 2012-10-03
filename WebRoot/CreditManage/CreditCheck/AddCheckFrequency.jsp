<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu  2009.11.18
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
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	

	%>
<%/*~END~*/%>
<script language=javascript>
	function newCheckFrequency()
	{
		var sCheckFrequency = document.all("CheckFrequency").value;
				
		//检查会计月份是否选择
		if (sCheckFrequency == '')
		{
			alert("请填写检查频率");
			document.all("sCheckFrequency").focus();
			return;
		}
		//返回变量：细化的客户类型、客户名称、客户证件类型、证件号
		self.returnValue=sCheckFrequency;
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
      
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >检查频率&nbsp;<font color="#ff0000">*</font>&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" > 
  			<select name="CheckFrequency" >
  				<option value="0" >不检查</option>
  				<option value="30">30天</option>
  				<option value="90">90天</option>
  				<option value="180">180天</option>
  			</select>
      </td>
    </tr> 
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:newCheckFrequency()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>