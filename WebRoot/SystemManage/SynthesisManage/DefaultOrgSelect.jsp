<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:LFENG  2004.02.17
 * Tester:
 *
 * History Log: 
 *			HXLI  2004.05.13 代码重检、优化
 */%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	ASResultSet rs  = null; 
    String sOrgID = "123456789";
	String sSql = "";
%>
<script language="JavaScript">

	var availableReportCaptionList = new Array;
	var availableReportNameList = new Array;
	var selectedReportCaptionList = new Array;
	var selectedReportNameList = new Array;
	
	var availableCustomerCaptionList = new Array;
	var availableCustomerNameList = new Array;
	var selectedCustomerCaptionList = new Array;
	var selectedCustomerNameList = new Array;
	
<%int num = 0;
	
	sSql = "select SortNo from ORG_INFO where OrgID = '"+CurOrg.OrgID+"' ";
	String sSortNo = Sqlca.getString(sSql);
	if(sSortNo == null) sSortNo = "";
	
	sSql = "select OrgLevel from ORG_INFO where OrgID = '"+CurOrg.OrgID+"' ";
	String sOrgLevel = Sqlca.getString(sSql);
	if(sOrgLevel == null) sOrgLevel = "";
	
	String OrgCondition = "";
	if (sOrgLevel.equals("6")) //支行
	{		
		OrgCondition=" and SortNo = '"+sSortNo+"' ";
	} 
	if (sOrgLevel.equals("3")) //分行
	{
		sSortNo= sSortNo.substring(0,6);
		OrgCondition=" and SortNo like '"+sSortNo+"%' ";
	}
	if (sOrgLevel.equals("0")) //总行
	{
		sSortNo= sSortNo.substring(0,3);
		OrgCondition=" and SortNo like '"+sSortNo+"%' ";
	}
	
	sSql =  " select OrgName,OrgID from org_info where orgid not in ("+sOrgID+") "+OrgCondition+" order by orgid desc ";
	
	rs = Sqlca.getASResultSet(sSql);
	num = 0;
	while(rs.next())
	{
		out.println("availableReportCaptionList[" + num + "] = '" + rs.getString(1) + "';\r");
		out.println("availableReportNameList[" + num + "] = '" + rs.getString(2) + "';\r");
		num++;
	}
	rs.getStatement().close();
	
	num = 0;
	sSql =  " select OrgName,OrgID from org_info where orgid in ("+sOrgID+") "+OrgCondition+" order by sortno desc ";
	rs = Sqlca.getASResultSet(sSql);
	num = 0;
	while(rs.next())
	{
		out.println("selectedReportCaptionList[" + num + "] = '" + rs.getString(1) + "';\r");
		out.println("selectedReportNameList[" + num + "] = '" + rs.getString(2) + "';\r");
		num++;
	}
	rs.getStatement().close();%>

</script>
<html>
<head>
	<title>选择机构</title>
</head>
<body bgcolor="#E4E4E4">
<form name="analyseterm">
<table align="center" width="100%">
	<tr>
		<td>
			<table width='100%' border='1' cellpadding='0' cellspacing='5' bgcolor='#DDDDDD'>
				<tr>
					<td colspan="4">
						<span>选择机构</span>
					</td>
				</tr>
				<tr>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>可选取的机构列表</span>
					</td>
					<td bordercolor='#DDDDDD'></td>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>已选取的机构列表</span>
					</td>
					<td></td>
				</tr>
				<tr>
					<td align='center'>
						<select name='report_available' onchange='selectionChanged(document.forms["analyseterm"].elements["report_available"],document.forms["analyseterm"].elements["report_chosen"]);' size='12' style='width:100%;' multiple='true'> 
						</select>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='movefrom_report_available' onmousedown='pushButton("movefrom_report_available",true);' onmouseup='pushButton("movefrom_report_available",false);' onmouseout='pushButton("movefrom_report_available",false);' onclick='moveSelected(document.forms["analyseterm"].elements["report_available"],document.forms["analyseterm"].elements["report_chosen"]);updateHiddenChooserField(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif' alt='Add selected items' />
						<br><br>
						<img name='movefrom_report_chosen' onmousedown='pushButton("movefrom_report_chosen",true);' onmouseup='pushButton("movefrom_report_chosen",false);' onmouseout='pushButton("movefrom_report_chosen",false);' onclick='moveSelected(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report_available"]);updateHiddenChooserField(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif' alt='Remove selected items' />
					</td>
					<td align='center'>
						<select name='report_chosen' onchange='selectionChanged(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report_available"]);' size='12' style='width:100%;' multiple='true'>
						</select>
						<input type='hidden' name='report' value=''>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='shiftup_report_chosen' onmousedown='pushButton("shiftup_report_chosen",true);' onmouseup='pushButton("shiftup_report_chosen",false);' onmouseout='pushButton("shiftup_report_chosen",false);' onclick='shiftSelected(document.forms["analyseterm"].elements["report_chosen"],-1);updateHiddenChooserField(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowUp_disabled.gif' alt='Shift selected items down' />
						<br><br>
						<img name='shiftdown_report_chosen' onmousedown='pushButton("shiftdown_report_chosen",true);' onmouseup='pushButton("shiftdown_report_chosen",false);' onmouseout='pushButton("shiftdown_report_chosen",false);' onclick='shiftSelected(document.forms["analyseterm"].elements["report_chosen"],1);updateHiddenChooserField(document.forms["analyseterm"].elements["report_chosen"],document.forms["analyseterm"].elements["report"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowDown_disabled.gif' alt='Shift selected items up' />
					</td>
				</tr>
				
	<tr>
		<td colspan=4>
			<table width="100%">
				<tr>
					<td width="30%" align="right">
						<%=HTMLControls.generateButton("&nbsp;恢&nbsp;复&nbsp;","恢复","javascript:doDefault();",sResourcesPath)%>
					</td>
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

	function cloneOption(option)
	{
		var out = new Option(option.text,option.value);
		out.selected = option.selected;
		out.defaultSelected = option.defaultSelected;
		return out;
	}
	
	function shiftSelected(chosen,howFar)
	{
		var opts = chosen.options;
		var newopts = new Array(opts.length);
		var start, end, incr;
		if(howFar > 0)
		{
			start = 0;
			end = newopts.length;
			incr = 1; 
		}
		else 
		{
			start = newopts.length - 1;
			end = -1;
			incr = -1; 
		}
		for(var sel = start; sel != end; sel += incr) 
		{
			if (opts[sel].selected) 
			{
				setAtFirstAvailable(newopts, cloneOption(opts[sel]), sel + howFar, -incr);
			}
		}
		for(var uns = start; uns != end; uns += incr) 
		{
			if (!opts[uns].selected) 
			{
				setAtFirstAvailable(newopts, cloneOption(opts[uns]), start, incr);
			}
		}
		opts.length = 0;
		for(i=0; i<newopts.length; i++) 
		{
			opts[opts.length] = newopts[i]; 
		}
	}
	
	function setAtFirstAvailable(array,obj,startIndex,incr) 
	{
		if (startIndex < 0) startIndex = 0;
		if (startIndex >= array.length) startIndex = array.length -1;
		for(var xxx=startIndex; xxx>= 0 && xxx<array.length; xxx += incr)
		{
			if (array[xxx] == null) 
			{
				array[xxx] = obj; 
				return; 
			}
		}
	}
	
	function moveSelected(from,to) 
	{
		newTo = new Array();
		for(i=0; i<to.options.length; i++) 
		{
			newTo[newTo.length] = cloneOption(to.options[i]);
			newTo[newTo.length-1].selected = false;
		}
		
		for(i=0; i<from.options.length; i++) 
		{
			if (from.options[i].selected) 
			{
				newTo[newTo.length] = cloneOption(from.options[i]);
				from.options[i] = null;
				i--;
			}
		}
		to.options.length = 0;
		for(i=0; i<newTo.length; i++) 
		{
			to.options[to.options.length] = newTo[i];
		}
		selectionChanged(to,from);
	}
   
	function updateHiddenChooserField(chosen,hidden) 
	{
		hidden.value='';
		var opts = chosen.options;
		for(var i=0; i<opts.length; i++) 
		{
			hidden.value = hidden.value + opts[i].value+'\n';
		}
	}
   
	function selectionChanged(selectedElement,unselectedElement) 
	{
		for(i=0; i<unselectedElement.options.length; i++) 
		{
			unselectedElement.options[i].selected=false;
		}
		form = selectedElement.form; 
		enableButton("movefrom_"+selectedElement.name,(selectedElement.selectedIndex != -1));
		enableButton("movefrom_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
		enableButton("shiftdown_"+selectedElement.name,(selectedElement.selectedIndex != -1));
		enableButton("shiftup_"+selectedElement.name,(selectedElement.selectedIndex != -1));
		enableButton("shiftdown_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
		enableButton("shiftup_"+unselectedElement.name,(unselectedElement.selectedIndex != -1));
	}
   
   function enableButton(buttonName,enable) 
	{
		var img = document.images[buttonName]; 
		if (img == null) return; 
		var src = img.src; 
		var und = src.lastIndexOf("_disabled.gif"); 
		if (und != -1) 
		{ 
			if(enable) img.src = src.substring(0,und)+".gif"; 
		}
		else
		{ 
			if(!enable) 
			{
				var gif = src.lastIndexOf("_clicked.gif"); 
				if (gif == -1) gif = src.lastIndexOf(".gif"); 
				img.src = src.substring(0,gif)+"_disabled.gif";
			}
		}
	}
   
   function pushButton(buttonName,push) 
	{
		var img = document.images[buttonName]; 
		if (img == null) return; 
		var src = img.src; 
		var und = src.lastIndexOf("_disabled.gif"); 
		if (und != -1) return false; 
		und = src.lastIndexOf("_clicked.gif"); 
		if (und == -1) 
		{ 
			var gif = src.lastIndexOf(".gif");
			if (push) img.src = src.substring(0,gif)+"_clicked.gif"; 
		}
		else 
		{ 
			if (!push) img.src = src.substring(0,und)+".gif"; 
		}
	}
	
	function doQuery()
	{
		if(analyseterm.report_chosen.length == 0)
		{
			alert("请选择机构！");
			return;
		}
		
		var vReturn = "";
		var vReportCount = analyseterm.report_chosen.length;		
		var vDefaultCount = selectedReportNameList.length;
		
		for(var i=0; i<vDefaultCount;i++ )
		{
			var vDefault = selectedReportNameList[i];
			for(var j=0; j<vReportCount;j++)
			{
				var vTemp = analyseterm.report_chosen.options[j].value;
				if(vDefault == vTemp) break;
			}
			if(j == vReportCount)
			{
				alert("默认节点不能删除");
				return;
			}
		}
		
		for(var i=0; i<vReportCount;i++ )
		{
			var vTemp = analyseterm.report_chosen.options[i].value;
			vReturn += vTemp+",";
		}
		vReturn = vReturn.substring(0,vReturn.length-1)
		self.returnValue = vReturn;
		self.close();
	}
	
	function doDefault()
	{
		analyseterm.report_available.options.length = 0;
		analyseterm.report_chosen.length = 0;
		
		var j = 0;
		for(var i = 0; i < availableReportNameList.length; i++)
		{
			eval("analyseterm.report_available.options[" + j + "] = new Option(availableReportCaptionList[" + i + "], availableReportNameList[" + i + "])");
			j++;
		}
		
		j = 0;
		for(var i = 0; i < selectedReportNameList.length; i++)
		{
			eval("analyseterm.report_chosen.options[" + j + "] = new Option(selectedReportCaptionList[" + i + "], selectedReportNameList[" + i + "])");
			j++;
		}
	}
	
	doDefault();
	
</script>

<%@ include file="/IncludeEnd.jsp"%>
