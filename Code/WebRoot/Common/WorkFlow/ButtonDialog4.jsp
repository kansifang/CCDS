<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: zywei 2006-10-25
 * Tester:
 *
 * Content: 人造dialog
 * Input Param:
 *      	
 * Output param:
 *			
 * History Log:
 *
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>

</head>

<body class="ListPage" leftmargin="0" topmargin="0" onload="" style={overflow:auto; overflow-y : auto;overflow-x : auto; } >
	<table align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
		    <td></td>
		</tr>
		<tr valign=top>
	    	<td>
				<form name="Condition">
					<table align="center">
						<tr align="center" >
							<td align="center" colspan=2>&nbsp</td>
						</tr>
				 		<tr align="center">
							<td align="center" colspan=2><img  width=16 height=16 src="<%=sResourcesPath%>/HtmlEdit/images/ed_charmap.gif"><font >此笔申请超出当前审批权限!</font></td>
						</tr> 			
						<tr align="center">      		
				      		<td align="center" colspan=2> 
				        		<input type="button" name="Confirm" value="关闭提示信息" onClick="javascript:self.returnValue='_CONFIRM_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
				      		</td>
				    	</tr>
					</table>
				</form>
    		</td>
		</tr>		
	</table>
</body>
</html>

<script language=javascript>
		
</script>

<%@ include file="/IncludeEnd.jsp"%>