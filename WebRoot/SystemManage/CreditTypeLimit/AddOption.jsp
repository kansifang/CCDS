<%/* 
 * Author:ljma 2011.02.24
 * Tester:选择标识
 *
 * History Log: 
 *			
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//定义变量
		//获得页面参数	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	//定义变量
    String sSql = "";
%>
<script language="JavaScript">

	var availableReportCaptionList = new Array;
	var availableReportNameList = new Array;

<%int num = 0;
	sSql =  " select ItemNo || ' ' || ItemName,ItemNo||'@'||ItemName" +
			" from CODE_LIBRARY "+
			" where CodeNo = 'BankYesNo' "+
			" and IsInUse='1' ";
	    
    sSql += " order by ItemNo ";
    ASResultSet rs = Sqlca.getASResultSet(sSql);
	num = 0;
	while(rs.next())
	{
		out.println("availableReportCaptionList[" + num + "] = '" + rs.getString(1) + "';\r");
		out.println("availableReportNameList[" + num + "] = '" + rs.getString(2) + "';\r");
		num++;
	}
	rs.getStatement().close();%>

</script>
<html>
<head>
	<title>选取信息</title>
</head>
<body bgcolor="#E4E4E4">
<form name="analyseterm">
<table align="center" width="100%">
	<tr>
		<td>
			<table width='100%' border='1' cellpadding='0' cellspacing='5' bgcolor='#DDDDDD'>
				<tr>
					<td>
						<span>选取需输入的信息</span>
					</td>
				</tr>
				<tr>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>可选择的内容</span>
					</td>
				</tr>
				<tr>
					<td align='center'>
						<select name='report_available'  size='12' style='width:100%;' multiple='true'> 
						</select>
					</td>
				</tr>
				
			</table>
		</td>
	</tr>
	<tr height=1>
		<td>&nbsp;</td>
	</tr>

	
	<tr>
		<td >
			<table width="100%">
				<tr>
					<td width="40%" align="center">
						<%=HTMLControls.generateButton("&nbsp;确&nbsp;定&nbsp;","确定","javascript:doQuery();",sResourcesPath)%>
					</td>
					<td width="30%" align="left">
						<%=HTMLControls.generateButton("&nbsp;取&nbsp;消&nbsp;","取消","javascript:self.returnValue='_none_';self.close();",sResourcesPath)%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
<script language="JavaScript">

	function doQuery()
	{
		if(analyseterm.report_available.length == 0)
		{
			alert("请选择需要的内容！");
			return;
		}
		
		var vReturn = "";
		var vReportCount = analyseterm.report_available.length;
		
		for(var i=0; i<vReportCount;i++ )
		{
			if(analyseterm.report_available.options[i].selected == true ){
				var vTemp = analyseterm.report_available.options[i].value;
            	vReturn = vReturn+vTemp+"@";
			}
		}
		self.returnValue = vReturn;
		self.close();
	}
	
	function doDefault()
	{
		analyseterm.report_available.options.length = 0;
		var j = 0;
		for(var i = 0; i < availableReportNameList.length; i++)
		{
			eval("analyseterm.report_available.options[" + j + "] = new Option(availableReportCaptionList[" + i + "], availableReportNameList[" + i + "])");
			j++;
		}
	}
	
	doDefault();
	
</script>

<%@ include file="/IncludeEnd.jsp"%>
