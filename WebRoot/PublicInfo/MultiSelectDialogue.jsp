<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:LFENG  2004.02.17
 * Tester:
 *
 * History Log: 
 *			HXLI  2004.05.13 �����ؼ졢�Ż�
 */%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%!//��û������ڵķ���
	//��ʽΪ columnName,columnNo@tableName@whereclause(--���ͣ���ѡ��)~delimiter--���ͣ���������֮��ķָ���~columnName,columnNo@tableName@whereclause--���ͣ���ѡ���еı�ѡ��
	String[] getSql(String sSelects,Transaction Sqlca) throws Exception {
		String[] aSelects = sSelects.split("~");
		String[] aTemp= new String[aSelects.length];
	    for (int i=0; i<aSelects.length; i++){
	    	String[]aSelect=aSelects[i].split("@");
	    	if(aSelect.length==3){
	    		aTemp[i] = " select " + aSelect[0]+ " from " + aSelect[1] + " where " + aSelect[2];
	    	}else{
	    		aTemp[i]=aSelect[0];
	    	}
	    }
		return aTemp;
	}%>

<%
	String sSelects = DataConvert.toRealString(iPostChange,(String)request.getParameter("Selects"));	
	ASResultSet rs  = null; 
	String sDelimiter="@";//Ĭ��ͬ�����ݵ�Ĭ�Ϸָ���
%>
<script language="JavaScript">
	//���п���ѡ������
	var availableReportCaptionList = new Array;
	var availableReportNameList = new Array;
	//ѡ��ѡ������
	var selectedReportCaptionList = new Array;
	var selectedReportNameList = new Array;
<%String[] aSelect=getSql(sSelects,Sqlca);
	if(aSelect.length>0){
		//��ѡ��
		rs = Sqlca.getASResultSet(aSelect[0]);
		for(int i=0;rs.next();i++)
		{
			out.println("availableReportCaptionList[" + i + "] = '" + rs.getString(1) + "';\r");//��ʾ��
			out.println("availableReportNameList[" + i + "] = '" + rs.getString(2) + "';\r");//ID
		}
		rs.getStatement().close();
		if(aSelect.length>1){
			//���ݷָ���
			if(aSelect[1]!=null&&aSelect[1].length()!=0){
				sDelimiter=aSelect[1];
			}
		}
		if(aSelect.length>2){
			//Ĭ��ѡ�е�ѡ��--��ѡ��
			rs = Sqlca.getASResultSet(aSelect[2]);
			for(int i=0;rs.next();i++)
			{
				out.println("selectedReportCaptionList[" + i + "] = '" + rs.getString(1) + "';\r");
				out.println("selectedReportNameList[" + i + "] = '" + rs.getString(2) + "';\r");
			}
			rs.getStatement().close();
		}
	}%>

</script>
<html>
<head>
	<title>���鱨�涨�ƴ�ӡ����</title>
</head>
<body bgcolor="#E4E4E4">
<form name="analyseterm">
<table align="center" width="100%">
	<tr>
		<td>
			<table width='100%' border='1' cellpadding='0' cellspacing='5' bgcolor='#DDDDDD'>
				<tr>
					<td colspan="4">
						<span>����ѡ��</span>
					</td>
				</tr>
				<tr>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>��ѡȡ��ѡ���б�</span>
					</td>
					<td bordercolor='#DDDDDD'></td>
					<td bgcolor='#DDDDDD'>
						<span class='dialog-label'>��ѡȡ��ѡ���б�</span>
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
					<td width="30%" align="right">
						<%=HTMLControls.generateButton("&nbsp;��&nbsp;��&nbsp;","�ָ�","javascript:doDefault();",sResourcesPath)%>
					</td>
					<td width="40%" align="center">
						<%=HTMLControls.generateButton("&nbsp;ȷ&nbsp;��&nbsp;","ȷ��","javascript:doQuery();",sResourcesPath)%>
					</td>
					<td width="30%" align="left">
						<%=HTMLControls.generateButton("&nbsp;ȡ&nbsp;��&nbsp;","ȡ��","javascript:self.returnValue='_none_';self.close();",sResourcesPath)%>
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
	   
	function updateHiddenChooserField(chosen,hidden) 
	{
		hidden.value='';
		var opts = chosen.options;
		for(var i=0; i<opts.length; i++) 
		{
			hidden.value = hidden.value + opts[i].value+'\n';
		}
	}
   
	//���ò�˵�������д�ú����
	function moveSelected(from,to) 
	{
		newTo = new Array();
		//1������ѡ�еĸ��Ƶ�newTo
		for(i=0; i<to.options.length; i++) 
		{
			//���ѭ��ʹ�ú�������ø�new�����鳤��Ϊ0�Ļ��ƣ�����ѭ���������
			newTo[newTo.length] = cloneOption(to.options[i]);//newTo.length=0,����ֵ�ͱ�Ϊ1�ˣ�js��������Զ�����
			newTo[newTo.length-1].selected = false;//newTo.length=1
		}
		//2���Ѹո�ѡ�еĸ��Ƶ�newTo,ͬʱ�����ӿ�ѡ������ȥ��
		for(i=0; i<from.options.length; i++) 
		{
			if (from.options[i].selected) 
			{
				newTo[newTo.length] = cloneOption(from.options[i]);
				from.options[i] = null;//�������ȥ��
				i--;
			}
		}
		to.options.length = 0;
		//3�����µ�newTo�����option���Ƹ�ѡ��������
		for(i=0; i<newTo.length; i++) 
		{
			to.options[to.options.length] = newTo[i];
		}
		selectionChanged(to,from);
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
		//buttonName�������״̬�ͱ�ɲ����ã������þͱ�ɿ��ã���˶���
		var und = src.lastIndexOf("_disabled.gif");//�Ѿ����û��ǲ����� 
		if (und != -1) //1���Ѿ������ò��ҵ�ѡ�������˾͸Ͻ���ɿ���
		{ 
			if(enable) img.src = src.substring(0,und)+".gif"; 
		}
		else//2���Ѿ����õ�û��ѡ�����ݸϽ���ɲ�����
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
	//ȷ��
	function doQuery()
	{
		if(analyseterm.report_chosen.length == 0)
		{
			alert("��ѡ��Ҫ����ѡ��Ľڵ㣡");
			return;
		}
		var vReportCount = analyseterm.report_chosen.length;		//ѡ�и���
		var sDelimiter="<%=sDelimiter%>";
		var vDefaultCount = selectedReportNameList.length;//Ĭ��ֵ����
		//1�����Ĭ������û�б�ȥ��
		for(var i=0; i<vDefaultCount;i++ )
		{
			var vDefault = selectedReportNameList[i];
			//����Ĭ��ֵ��ѡ��ֵ����û�У��о�������������һ��Ĭ��ֵ
			for(var j=0; j<vReportCount;j++)
			{
				var vTemp = analyseterm.report_chosen.options[j].value;
				if(vDefault == vTemp) break;
			}
			//��������ѭ����ʼ��û��ѡ��ֵ���ҵ�Ĭ��ֵ����������������
			if(j == vReportCount)
			{
				alert("Ĭ�Ͻڵ㲻��ɾ��");
				return;
			}
		}
		var vTemp1="",vTemp2="";
		//2����ѡ�е�ֵ���Զ����������ȥ��
		for(var i=0; i<vReportCount;i++)
		{
			vTemp1 += analyseterm.report_chosen.options[i].value+sDelimiter;//����Ԫ��֮���á������ָ�
			vTemp2 += analyseterm.report_chosen.options[i].text+sDelimiter;
		}
		self.returnValue = vTemp1+"~"+vTemp2;
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
