<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author: hlzhang 2009-11-27
		Tester:
		Describe: 提交选择框
		Input Param:
			SerialNo：任务流水号
		Output Param:
		HistoryLog: 
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>

<%/*~END~*/%>	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义业务逻辑主体;]~*/%>
<%	

%>
<%/*~END~*/%>	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义选择提交动作界面风格;]~*/%>
	<html>
	<head>
		<title>输入业务信息</title>
	</head>
	<body class="ShowModalPage" leftmargin="0" topmargin="0" onload="" >
	<form name="Phase" method="post" target="_top">
		 <table width="100%" align="center">
		  	<tr width="100%" >
		  		<td width="100%"  valign="top" >			
					<table align="center">							
						<tr> 
					      <td nowrap align="right" class="black9pt" bgcolor="#D8D8AF" >请输入合同流水号：</td>
					      <td nowrap bgcolor="#F0F1DE" > 
					        <input type=text name="BusinessContractNo" width=200">
								
					        </text>
					      </td>
					    </tr>	
					</table>
				</td>
			</tr>
		<tr>
			<td nowarp bgcolor="#F0F1DE" height="30" colspan=5 align=center> 
			  <input type="button" name="ok" value="确认" onClick="javascript:commitAction()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
			  
			  <input type="button" name="Cancel" value="取消" onClick="javascript:doCancel()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
			</td>
		</tr>
		</table>
	</form>
	</body>
	</html>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>		
				
		//提交任务
		function commitAction()
		{
			self.returnValue = Phase.BusinessContractNo.value;   				
			self.close();
		}

		//取消提交
		function doCancel()
		{
			self.returnValue = "_CANCEL_";
			self.close();
		}

</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
