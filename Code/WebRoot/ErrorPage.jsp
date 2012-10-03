<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: RCZhu 2003.7.18
 * Tester:
 *
 * Content: 出错页面处理   
 * Input Param:
 * Output param:
 *
 * History Log: 2003.07.18 RCZhu
 *              2003.08.10 XDHou
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.web.config.ASConfigure" isErrorPage="true" session="true"%>
<%
    String sWebRootPath = request.getContextPath();
	String sResourcesPath = sWebRootPath+ASConfigure.getASConfigure().getConfigure("ResourcesPath");
	sResourcesPath = sResourcesPath + "/Public";

	String sMessage=exception.getMessage();
	
	if(sMessage!=null && sMessage.equals("------Timeout------"))
		sMessage="系统已经超时，请重新<a href=\""+sWebRootPath+"/index.html\" target=\"_top\" >登录</a>！";
	
	if(sMessage!=null && sMessage.equals("NoRight"))
		sMessage="<span style={font-size: 9pt;}>对不起，您无权限访问该页面。<br>请与系统管理员联系。</span><a href=\""+sWebRootPath+"/Main.jsp\" target=\"_top\" ><!--返回主页--></a>";
%>
<html>
<head>
<style>
td{font-size:9pt}
</style>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0">
<div style="background-color: #DCDCDC;" align=center style="overflow:auto">
<table WIDTH=100% BORDER="0" CELLSPACING="5" CELLPADDING="5" height="100%">
	<tr>
		<td>
			<table align=center cellpadding="8" cellspacing="0" border="1" bordercolorlight=#999999 bordercolordark=#FFFFFF >
				<tr height=1>
					<td bgcolor="#CCCCCC">				
						提示信息
					</td>
				</tr>
				<tr>
					<td valign=top>

					<p>
						<%=sMessage%>
					</p>
					<p></p>
					</td>
				</tr>
			</table>
		</td>
		<td></td>
	</tr>
</table>
</div>
<div style="display:none">
<%
exception.printStackTrace();
exception.fillInStackTrace();
exception.printStackTrace(new java.io.PrintWriter(out));
%>		                  
</div>
</body>
</html>