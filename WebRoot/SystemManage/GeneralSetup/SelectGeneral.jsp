<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: zwhu
 * Tester:
 *
 * Content: 更新授权
 * Input Param:
 *			
 *
 * History Log:
 *
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	ASResultSet rs  = null; 
	String sSql = ""; 
%>
<script language="JavaScript">

	var availableOrgCaptionList = new Array;
	var availableOrgNameList = new Array;
	
	var availableBusinessTypeCaptionList = new Array;
	var availableBusinessTypeNameList = new Array;	
	
	var availableRoleCaptionList = new Array;
	var availableRoleNameList = new Array;
	
<%
	int num=0;
	sSql = "select OrgID,OrgName from ORG_INFO where OrgID in (select OrgID from ORG_INFO where SortNo like '100%') and OrgLevel in ('0','3','6') ";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		out.println("availableOrgCaptionList[" + num + "] = '" + rs.getString(2) + "';\r");
		out.println("availableOrgNameList[" + num + "] = '" + rs.getString(1) + "';\r");
		num++;
	}
	rs.getStatement().close();
	sSql = "select TypeNo,TypeName from business_type where (displaytemplet  is not null or displaytemplet <>'' or TypeNo ='3010') and isInUse = '1' order by typeno";
	rs = Sqlca.getASResultSet(sSql);
	num=0;
	while(rs.next()){
		out.println("availableBusinessTypeCaptionList[" + num + "] = '" + rs.getString(2) + "';\r");
		out.println("availableBusinessTypeNameList[" + num + "] = '" + rs.getString(1) + "';\r");
		num++;
	}
	rs.getStatement().close();
	
	sSql = "select roleid,rolename from role_info where roleid in ('410','210','211','226','011','010') order by roleid";
	rs = Sqlca.getASResultSet(sSql);
	num=0;
	while(rs.next()){
		out.println("availableRoleCaptionList[" + num + "] = '" + rs.getString(2) + "';\r");
		out.println("availableRoleNameList[" + num + "] = '" + rs.getString(1) + "';\r");
		num++;
	}
	rs.getStatement().close();
%>

</script>
<html>
<head>
	<title>批量更新授权设置</title>
</head>
<body bgcolor="#E4E4E4">
<form name="analyseterm">
<table align="center" width="100%">
	<tr>
		<td>
			<table width='100%' border='1' cellpadding='0' cellspacing='5' bgcolor='#DDDDDD'>
				<tr>
					<td colspan="8">
						<span>选取需更新授权的节点</span>
					</td>
				</tr>
				<tr>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>可选取的机构节点列表</span>
					</td>
					<td bordercolor='#DDDDDD'></td>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>已选取的机构节点列表</span>
					</td>
					<td></td>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>可选取的业务品种节点列表</span>
					</td>
					<td bordercolor='#DDDDDD'></td>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>已选取的业务品种节点列表</span>
					</td>
					<td></td>					
				</tr>
				<tr>
					<td align='center'>
						<select name='org_available' onchange='selectionChanged(document.forms["analyseterm"].elements["org_available"],document.forms["analyseterm"].elements["org_chosen"]);' size='12' style='width:100%;' multiple='true'> 
						</select>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='movefrom_org_available' onmousedown='pushButton("movefrom_org_available",true);' onmouseup='pushButton("movefrom_org_available",false);' onmouseout='pushButton("movefrom_org_available",false);' onclick='moveSelected(document.forms["analyseterm"].elements["org_available"],document.forms["analyseterm"].elements["org_chosen"]);updateHiddenChooserField(document.forms["analyseterm"].elements["org_chosen"],document.forms["analyseterm"].elements["org"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif' alt='Add selected items' />
						<br><br>
						<img name='movefrom_org_chosen' onmousedown='pushButton("movefrom_org_chosen",true);' onmouseup='pushButton("movefrom_org_chosen",false);' onmouseout='pushButton("movefrom_org_chosen",false);' onclick='moveSelected(document.forms["analyseterm"].elements["org_chosen"],document.forms["analyseterm"].elements["org_available"]);updateHiddenChooserField(document.forms["analyseterm"].elements["org_chosen"],document.forms["analyseterm"].elements["org"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif' alt='Remove selected items' />
					</td>
					<td align='center'>
						<select name='org_chosen' onchange='selectionChanged(document.forms["analyseterm"].elements["org_chosen"],document.forms["analyseterm"].elements["org_available"]);' size='12' style='width:100%;' multiple='true'>
						</select>
						<input type='hidden' name='org' value=''>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='shiftup_org_chosen' onmousedown='pushButton("shiftup_org_chosen",true);' onmouseup='pushButton("shiftup_org_chosen",false);' onmouseout='pushButton("shiftup_org_chosen",false);' onclick='shiftSelected(document.forms["analyseterm"].elements["org_chosen"],-1);updateHiddenChooserField(document.forms["analyseterm"].elements["org_chosen"],document.forms["analyseterm"].elements["org"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowUp_disabled.gif' alt='Shift selected items down' />
						<br><br>
						<img name='shiftdown_org_chosen' onmousedown='pushButton("shiftdown_org_chosen",true);' onmouseup='pushButton("shiftdown_org_chosen",false);' onmouseout='pushButton("shiftdown_org_chosen",false);' onclick='shiftSelected(document.forms["analyseterm"].elements["org_chosen"],1);updateHiddenChooserField(document.forms["analyseterm"].elements["org_chosen"],document.forms["analyseterm"].elements["org"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowDown_disabled.gif' alt='Shift selected items up' />
					</td>
					
					
					<td align='center'>
						<select name='businessType_available' onchange='selectionChanged(document.forms["analyseterm"].elements["businessType_available"],document.forms["analyseterm"].elements["businessType_chosen"]);' size='12' style='width:100%;' multiple='true'> 
						</select>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='movefrom_businessType_available' onmousedown='pushButton("movefrom_businessType_available",true);' onmouseup='pushButton("movefrom_businessType_available",false);' onmouseout='pushButton("movefrom_businessType_available",false);' onclick='moveSelected(document.forms["analyseterm"].elements["businessType_available"],document.forms["analyseterm"].elements["businessType_chosen"]);updateHiddenChooserField(document.forms["analyseterm"].elements["businessType_chosen"],document.forms["analyseterm"].elements["businessType"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif' alt='Add selected items' />
						<br><br>
						<img name='movefrom_businessType_chosen' onmousedown='pushButton("movefrom_businessType_chosen",true);' onmouseup='pushButton("movefrom_businessType_chosen",false);' onmouseout='pushButton("movefrom_businessType_chosen",false);' onclick='moveSelected(document.forms["analyseterm"].elements["businessType_chosen"],document.forms["analyseterm"].elements["businessType_available"]);updateHiddenChooserField(document.forms["analyseterm"].elements["businessType_chosen"],document.forms["analyseterm"].elements["businessType"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif' alt='Remove selected items' />
					</td>
					<td align='center'>
						<select name='businessType_chosen' onchange='selectionChanged(document.forms["analyseterm"].elements["businessType_chosen"],document.forms["analyseterm"].elements["businessType_available"]);' size='12' style='width:100%;' multiple='true'>
						</select>
						<input type='hidden' name='businessType' value=''>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='shiftup_businessType_chosen' onmousedown='pushButton("shiftup_businessType_chosen",true);' onmouseup='pushButton("shiftup_businessType_chosen",false);' onmouseout='pushButton("shiftup_businessType_chosen",false);' onclick='shiftSelected(document.forms["analyseterm"].elements["businessType_chosen"],-1);updateHiddenChooserField(document.forms["analyseterm"].elements["businessType_chosen"],document.forms["analyseterm"].elements["businessType"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowUp_disabled.gif' alt='Shift selected items down' />
						<br><br>
						<img name='shiftdown_businessType_chosen' onmousedown='pushButton("shiftdown_businessType_chosen",true);' onmouseup='pushButton("shiftdown_businessType_chosen",false);' onmouseout='pushButton("shiftdown_businessType_chosen",false);' onclick='shiftSelected(document.forms["analyseterm"].elements["businessType_chosen"],1);updateHiddenChooserField(document.forms["analyseterm"].elements["businessType_chosen"],document.forms["analyseterm"].elements["businessType"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowDown_disabled.gif' alt='Shift selected items up' />
					</td>					
				</tr>
			</table>	
			<table width='100%' border='1' cellpadding='0' cellspacing='5' bgcolor='#DDDDDD'>				

				<tr style='display:none' height=1 >
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr style='' >
					<td colspan="4">
						<span>选取要更新授权的角色</span>
					</td>
				</tr>
				<tr style='' >
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>可选取的角色列表</span>
					</td>
					<td bordercolor='#DDDDDD'></td>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>已选取的角色列表</span>
					</td>
					<td></td>
				</tr>
				<tr style='' >
					<td align='center'>
						<select name='role_available' onchange='selectionChanged(document.forms["analyseterm"].elements["role_available"],document.forms["analyseterm"].elements["role_chosen"]);' size='12' style='width:100%;' multiple='true'> 
						</select>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='movefrom_role_available' onmousedown='pushButton("movefrom_role_available",true);' onmouseup='pushButton("movefrom_role_available",false);' onmouseout='pushButton("movefrom_role_available",false);' onclick='moveSelected(document.forms["analyseterm"].elements["role_available"],document.forms["analyseterm"].elements["role_chosen"]);updateHiddenChooserField(document.forms["analyseterm"].elements["role_chosen"],document.forms["analyseterm"].elements["role"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif' alt='Add selected items' />
						<br><br>
						<img name='movefrom_role_chosen' onmousedown='pushButton("movefrom_role_chosen",true);' onmouseup='pushButton("movefrom_role_chosen",false);' onmouseout='pushButton("movefrom_role_chosen",false);' onclick='moveSelected(document.forms["analyseterm"].elements["role_chosen"],document.forms["analyseterm"].elements["role_available"]);updateHiddenChooserField(document.forms["analyseterm"].elements["role_chosen"],document.forms["analyseterm"].elements["role"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif' alt='Remove selected items' />
					</td>
					<td align='center'>
						<select name='role_chosen' onchange='selectionChanged(document.forms["analyseterm"].elements["role_chosen"],document.forms["analyseterm"].elements["role_available"]);' size='12' style='width:100%;' multiple='true'>
						</select>
						<input type='hidden' name='role' value=''>
					</td>
					<td width='1' align='center' valign='middle' bordercolor='#DDDDDD'>
						<img name='shiftup_role_chosen' onmousedown='pushButton("shiftup_role_chosen",true);' onmouseup='pushButton("shiftup_role_chosen",false);' onmouseout='pushButton("shiftup_role_chosen",false);' onclick='shiftSelected(document.forms["analyseterm"].elements["role_chosen"],-1);updateHiddenChooserField(document.forms["analyseterm"].elements["role_chosen"],document.forms["analyseterm"].elements["role"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowUp_disabled.gif' alt='Shift selected items down' />
						<br><br>
						<img name='shiftdown_role_chosen' onmousedown='pushButton("shiftdown_role_chosen",true);' onmouseup='pushButton("shiftdown_role_chosen",false);' onmouseout='pushButton("shiftdown_role_chosen",false);' onclick='shiftSelected(document.forms["analyseterm"].elements["role_chosen"],1);updateHiddenChooserField(document.forms["analyseterm"].elements["role_chosen"],document.forms["analyseterm"].elements["role"]);' border='0' src='<%=sResourcesPath%>/chooser_orange/arrowDown_disabled.gif' alt='Shift selected items up' />
					</td>
					<td style='width:55%;'>
					<table>
					<tr><td>关联交易授权金额(元)</td><td><input type="text" id="AuthSum3" onkeyup="isDigit('AuthSum3')" onblur="convertAuthSum('AuthSum3')" onfocus="convertAuthSumToDouble('AuthSum3')"/></td></tr>
					<tr><td>公司业务低风险授权金额(元) </td><td><input type="text" id="AuthSum1" onkeyup="isDigit('AuthSum1')" onblur="convertAuthSum('AuthSum1')" onfocus="convertAuthSumToDouble('AuthSum1')"/></td></tr>
					<tr><td>公司业务一般风险授权金额(元) </td><td><input type="text" id="AuthSum2" onkeyup="isDigit('AuthSum2')" onblur="convertAuthSum('AuthSum2')" onfocus="convertAuthSumToDouble('AuthSum2')"/></td></tr>
					<tr><td>个人业务低风险授权金额(元) </td><td><input type="text" id="AuthSum5" onkeyup="isDigit('AuthSum5')" onblur="convertAuthSum('AuthSum5')" onfocus="convertAuthSumToDouble('AuthSum5')"/></td></tr>
					<tr><td>个人业务一般风险授权金额(元) </td><td><input type="text" id="AuthSum6" onkeyup="isDigit('AuthSum6')" onblur="convertAuthSum('AuthSum6')" onfocus="convertAuthSumToDouble('AuthSum6')"/></td></tr>
					<tr><td>微小企业一般风险授权金额(元) </td><td><input type="text" id="AuthSum4" onkeyup="isDigit('AuthSum4')" onblur="convertAuthSum('AuthSum4')" onfocus="convertAuthSumToDouble('AuthSum4')"/></td></tr>
					<tr><td>微小商户授权金额(元) </td><td><input type="text" id="AuthSum7" onkeyup="isDigit('AuthSum7')" onblur="convertAuthSum('AuthSum7')" onfocus="convertAuthSumToDouble('AuthSum7')"/></td></tr>					 		 
					</table>
					</td>
				</tr>										
			</table>
		</td>
	</tr>
	<tr height=1>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
		<td colspan=4>
			<table width="100%">
				<tr>
					<td width="25%" align="right">
						<%=HTMLControls.generateButton("&nbsp;恢&nbsp;复&nbsp;","恢复","javascript:doDefault();",sResourcesPath)%>
					</td>
					<td width="25%" align="center">
						<%=HTMLControls.generateButton("批量更新","批量更新授权","javascript:batchUpdate();",sResourcesPath)%>
					</td>
					<td width="25%" align="center">
						<%=HTMLControls.generateButton("批量设置","批量配置授权","javascript:batchInsert();",sResourcesPath)%>
					</td>					
					<td width="25%" align="left">
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
	function isDigit(s) 
	{ 	
		var sAuthSum = document.getElementById(s).value;
		if (sAuthSum.search("^-?\\d+(\\.\\d+)?$")!=0 && !(typeof(sAuthSum)=="undefined" || sAuthSum.length==0)){
			document.getElementById(s).value=sAuthSum.replace(/[a-zA-Z]/,"");
			
			return false;
		}
		return true; 
	} 
	function convertAuthSum(s)
	{	
		var sAuthSum = document.getElementById(s).value;
		var sResult = PopPage("/SystemManage/GeneralSetup/ConvertAuthSum.jsp?AuthSum="+sAuthSum,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		document.getElementById(s).value=sResult;
	}
	function convertAuthSumToDouble(s){
		var sAuthSum = document.getElementById(s).value.replace(/,/g,"");
		document.getElementById(s).value=sAuthSum;
	}
	function batchInsert(){
		if(doQuery()==false){
			return;
		}
		var vReturn1 = "",vReturn2 = "",vReturn3 = "",vReturn4 = "";
		for(var i=1;i<8;i++){
			var sAuthSum = "AuthSum"+i 
			var sAuthSumValue = document.getElementById(sAuthSum).value.replace(/,/g,"");
			if(typeof(sAuthSumValue)=="undefined" || sAuthSumValue.length==0){
				alert("金额不能为空");
				return;
			}else{
				vReturn4 += sAuthSumValue+","; 
			}
		}
		vReturn4 = vReturn4.substring(0,vReturn4.length-1);
		if(!confirm("您确定要更新以上授权金额吗？"))
		{
			return;
		}

		var vOrgCount = analyseterm.org_chosen.length;		
		for(var i=0; i<vOrgCount;i++ )
		{
			var vTemp = analyseterm.org_chosen.options[i].value;
			vReturn1 += "'"+vTemp+"',";
		}
		vReturn1 = vReturn1.substring(0,vReturn1.length-1);
		
		var vbusinessTypeCount = analyseterm.businessType_chosen.length;				
		for(var i=0; i<vbusinessTypeCount;i++ )
		{
			var vTemp = analyseterm.businessType_chosen.options[i].value;
			vReturn2 += "'"+vTemp+"',";
		}
		vReturn2 = vReturn2.substring(0,vReturn2.length-1);
		
		var vroleCount = analyseterm.role_chosen.length;	
		for(var i=0; i<vroleCount;i++ )
		{
			var vTemp = analyseterm.role_chosen.options[i].value;
			vReturn3 += "'"+vTemp+"',";
		}				
		vReturn3 = vReturn3.substring(0,vReturn3.length-1);
		
		//参数依次为：机构、业务品种、角色、授权金额
		var sResult = PopPage("/SystemManage/GeneralSetup/InsertBatchAuthSum.jsp?OrgIDArr="+vReturn1+"&BusinessTypeArr="+vReturn2+"&RoleIDArr="+vReturn3+"&SetUnit="+vReturn4,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		if(typeof(sResult)!="undefined" && sResult.length!=0)
		{
			alert("批量设置成功,共设置了"+sResult+"条记录");
			return;
		}else
		{
			alert("批量设置出现错误！");
			return;
		}
	}	

	function batchUpdate(){
		if(doQuery()==false){
			return;
		}
		if(!confirm("您确定要更新以上授权金额吗？"))
		{
			return;
		}
		var vReturn1 = "",vReturn2 = "",vReturn3 = "",vReturn4 = "";
		var vOrgCount = analyseterm.org_chosen.length;		
		for(var i=0; i<vOrgCount;i++ )
		{
			var vTemp = analyseterm.org_chosen.options[i].value;
			vReturn1 += "'"+vTemp+"',";
		}
		vReturn1 = vReturn1.substring(0,vReturn1.length-1);
		
		var vbusinessTypeCount = analyseterm.businessType_chosen.length;				
		for(var i=0; i<vbusinessTypeCount;i++ )
		{
			var vTemp = analyseterm.businessType_chosen.options[i].value;
			vReturn2 += "'"+vTemp+"',";
		}
		vReturn2 = vReturn2.substring(0,vReturn2.length-1);
		
		var vroleCount = analyseterm.role_chosen.length;	
		for(var i=0; i<vroleCount;i++ )
		{
			var vTemp = analyseterm.role_chosen.options[i].value;
			vReturn3 += "'"+vTemp+"',";
		}				
		vReturn3 = vReturn3.substring(0,vReturn3.length-1);

		for(var i=1;i<8;i++){
			var sAuthSum = "AuthSum"+i 
			var sAuthSumValue = document.getElementById(sAuthSum).value.replace(/,/g,"");
			if(!(typeof(sAuthSumValue)=="undefined" || sAuthSumValue.length==0)){
				vReturn4 += sAuthSum +"="+sAuthSumValue+","; 
			}	
		}
		vReturn4 = vReturn4.substring(0,vReturn4.length-1);
		//参数依次为：机构、业务品种、角色、授权金额
		var sResult = PopPage("/SystemManage/GeneralSetup/UpdateBatchAuthSum.jsp?OrgIDArr="+vReturn1+"&BusinessTypeArr="+vReturn2+"&RoleIDArr="+vReturn3+"&SetUnit="+vReturn4,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		if(typeof(sResult)!="undefined" && sResult.length!=0)
		{
			alert("批量更新成功,共更新了"+sResult+"条记录");
			return;
		}else
		{
			alert("批量更新出现错误！");
			return;
		}
	}	
	
	function doQuery()
	{
		if(analyseterm.org_chosen.length == 0)
		{
			alert("请选择机构！");
			return false;
		}
		if(analyseterm.businessType_chosen.length == 0)
		{
			alert("请选择业务品种！");
			return false ;
		}
		if(analyseterm.role_chosen.length == 0)
		{
			alert("请选择角色！");
			return false;
		}	
		if(analyseterm.role_chosen.length>1){
			alert("只能选择一个角色进行更新");
			return false;
		}	
		return true;
	}
	
	function doDefault()
	{
		analyseterm.org_available.options.length = 0;
		analyseterm.org_chosen.length = 0;
		
		var j = 0;
		for(var i = 0; i < availableOrgNameList.length; i++)
		{
			eval("analyseterm.org_available.options[" + j + "] = new Option(availableOrgCaptionList[" + i + "], availableOrgNameList[" + i + "])");
			j++;
		}
		
		
		analyseterm.businessType_available.options.length = 0;
		analyseterm.businessType_chosen.length = 0;
		j = 0;
		for(var i = 0; i < availableBusinessTypeNameList.length; i++)
		{
			eval("analyseterm.businessType_available.options[" + j + "] = new Option(availableBusinessTypeCaptionList[" + i + "], availableBusinessTypeNameList[" + i + "])");
			j++;
		}
		
		
		analyseterm.role_available.options.length = 0;
		analyseterm.role_chosen.length = 0;
		j = 0;
		for(var i = 0; i < availableRoleNameList.length; i++)
		{
			eval("analyseterm.role_available.options[" + j + "] = new Option(availableRoleCaptionList[" + i + "], availableRoleNameList[" + i + "])");
			j++;
		}
		
	}
	
	doDefault();
	
</script>

<%@ include file="/IncludeEnd.jsp"%>
