<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author: hlzhang 2009-11-27
		Tester:
		Describe: �ύѡ���
		Input Param:
			SerialNo��������ˮ��
		Output Param:
		HistoryLog: 
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>

<%/*~END~*/%>	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=����ҵ���߼�����;]~*/%>
<%	

%>
<%/*~END~*/%>	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=����ѡ���ύ����������;]~*/%>
	<html>
	<head>
		<title>����ҵ����Ϣ</title>
	</head>
	<body class="ShowModalPage" leftmargin="0" topmargin="0" onload="" >
	<form name="Phase" method="post" target="_top">
		 <table width="100%" align="center">
		  	<tr width="100%" >
		  		<td width="100%"  valign="top" >			
					<table align="center">							
						<tr> 
					      <td nowrap align="right" class="black9pt" bgcolor="#D8D8AF" >�������ͬ��ˮ�ţ�</td>
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
			  <input type="button" name="ok" value="ȷ��" onClick="javascript:commitAction()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
			  
			  <input type="button" name="Cancel" value="ȡ��" onClick="javascript:doCancel()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
			</td>
		</tr>
		</table>
	</form>
	</body>
	</html>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>		
				
		//�ύ����
		function commitAction()
		{
			self.returnValue = Phase.BusinessContractNo.value;   				
			self.close();
		}

		//ȡ���ύ
		function doCancel()
		{
			self.returnValue = "_CANCEL_";
			self.close();
		}

</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
