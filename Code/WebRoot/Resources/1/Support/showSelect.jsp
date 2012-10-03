<%@page contentType="text/html; charset=GBK"%>
<%@page buffer="64kb" errorPage="/ErrorPage.jsp"%>
<%@page import="com.amarsoft.are.util.*"%> 
<%@page import="com.amarsoft.web.config.ASConfigure"%>
<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:RCZhu 2003.7.18
 * Tester:
 *
 * Content: 请选择...
 * Input Param:
 * Output param:
 *
 * History Log: 2003.07.18 RCZhu
 *              2003.08.10 XDHou
 */
%>
<%
	if(session == null || session.isNew()) throw new Exception("------Timeout------"); 

	String sPostChange = ASConfigure.getASConfigure().getConfigure("PostChange");
	int iPostChange = Integer.valueOf(sPostChange).intValue();

	//传过来的参数:fieldname,defaultvalue,codelist	
	String sDefault = DataConvert.toRealString(iPostChange,(String)request.getParameter("defaultvalue"));
	String sSelect = DataConvert.toRealString(iPostChange,(String)request.getParameter("codelist"));
	
	sSelect = StringFunction.replace(sSelect,"ssppaaccee"," ");
	String[] sss=StringFunction.toStringArray(sSelect,"@");

%>

<head>
	<title>请选择...</title>
	<META http-equiv=Content-Type content="text/html; charset=GBK">
</head>
<body onunload="doUnload()" >
<div align=center>
<br>请选择：<br><br>
<select id=curselect size='10'  style='width:100%;' width='100%' >
<%
	int iLen=sss.length,k;
	String sSelected="";
	for(k=0;k<iLen;k+=2)
	{
		if(sss[k].equals(sDefault)) sSelected="selected";
		else                        sSelected=""; 

%>
		<option value='<%=sss[k]%>' <%=sSelected%> ><%=sss[k+1]%></option>
<%		
	}
	
%>
</select>
<br><br>
<input type=button name=btnOk value="选定"     onclick="javascipt:doOk();" >
<input type=button name=btnCancel value="取消" onclick="javascipt:doCancel();" >
</div>
</body>

<script language=javascript>
bNormal=false;
function doOk()
{
	self.returnValue=curselect.value;
	bNormal=true;
	window.close();
}
function doCancel()
{
	self.returnValue="_none_";
	bNormal=true;
	window.close();
}
function doUnload()
{
	if(!bNormal)
	{
		self.returnValue="_none_";		
	}
}
</script>
