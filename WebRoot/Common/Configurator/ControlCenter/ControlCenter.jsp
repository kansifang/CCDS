<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%
 	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
 %>
	<%
		/*
			Author:   
			Tester:
			Content: 主页面
			Input Param:
		          
			Output param:
		      
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>

<html>
<head>
<title></title> 
</head>
<body class="ListPage" leftmargin="0" topmargin="0" >
<div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
<%
	int i=0;
%>
<table align='center' width='98%'  cellspacing="4" cellpadding="0">
  <tr > 
    <td colspan="4"> &nbsp;
    </td> 
  <tr > 
  <tr > 
    <td colspan="4"> 
      <table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" width='100%'>
		<tr>
		<td>
		  <table border=0 cellpadding=0  cellspacing=0 style='CURSOR: hand' width='100%'>
			<tbody> 
			<tr bgcolor='#EEEEEE' id=ConditonMap<%=i%>Tab valign=center height='20'> 
			  <td align=right valign='middle'> <img alt='' border=0 id=ConditonMap<%=i%>Tab3 onClick="showHideContent('ConditonMap<%=i%>','<%=i%>');"  src='<%=sResourcesPath%>/expand.gif' style='CURSOR: hand' width='15' height='15'> 
			  </td>
			  <td align=left width='100%' valign='middle' onClick="javascript:ConditonMap<%=i%>Tab3.click();"> 
				<table>
				  <tr> 
					<td> <font color=#000000 id=ConditonMap<%=i%>Tab2 >系统运行参数</font> 
					</td>
				  </tr>
				</table>
			  </td>
			  <td align=right valign='top'> <img alt='' border=0 id=ConditonMap<%=i%>Tab1 src='<%=sResourcesPath%>/curve1.gif' width='0' height='0'> 
			  </td>
			</tr>
			</tbody> 
		  </table>
		</td>
	  </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="4"> 
      <div id=ConditonMap<%=i%>Content style=' WIDTH: 100%;display:none'> 
	<table class='conditionmap' width='100%' align='left' border='1' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="4">
			  <ul>
			  <tr> 
			    <td width="50%" >
			        <li>PostChange:<strong><%=CurConfig.getConfigure("PostChange")%><strong></li>
			    </td>
			    <td width="50%" >
			        <li>DBChange:<strong><%=CurConfig.getConfigure("DBChange")%><strong></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li>RunMode:<strong><%=CurConfig.getConfigure("RunMode")%></strong></li>
			    </td>
			    <td width="50%" >
			        <li>FileSaveMode:<strong><%=CurConfig.getConfigure("FileSaveMode")%></strong> FileNameType:<strong><%=CurConfig.getConfigure("FileNameType")%></strong></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li>FileSavePath:<strong><%=CurConfig.getConfigure("FileSavePath")%></strong></li>
			    </td>
			    <td width="50%" >
			        <li>WorkDocSavePath:<strong><%=CurConfig.getConfigure("WorkDocSavePath")%></strong></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li>AmarDWChange:<strong><%=CurConfig.getConfigure("AmarDWChange")%><strong></li>
			    </td>
			    <td width="50%" >
			        <li>DebugMode:<strong><%=CurConfig.getConfigure("DebugMode")%><strong></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li>AmarDWMaxRows:<strong><%=CurConfig.getConfigure("AmarDWMaxRows")%><strong></li>
			    </td>
			    <td width="50%" >
			        <li>AmarDWTransMode:<strong><%=CurConfig.getConfigure("AmarDWTransMode")%><strong></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li>TransDebugMode:<strong><%=CurConfig.getConfigure("TransDebugMode")%></strong></li>
			    </td>
			    <td width="50%" >
			        <li>AmarDWTransMode:<strong><%=CurConfig.getConfigure("AmarDWTransMode")%></strong></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li>基础产品版本:<strong><%=CurConfig.getConfigure("ProductName")%> <%=CurConfig.getConfigure("ProductID")%> <%=CurConfig.getConfigure("ProductVersion")%><strong></li>
			    </td>
			    <td width="50%" >&nbsp;
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li>客户增值版本:<strong><%=CurConfig.getConfigure("ImplementationName")%> <%=CurConfig.getConfigure("ImplementationID")%> <%=CurConfig.getConfigure("ImplementationVersion")%><strong></li>
			    </td>
			    <td width="50%" >
			        &nbsp;
			    </td>
			  </tr>
		      </ul>
			</table>

		</td>
	</tr>
	</table>
      </div>
    </td>
  </tr>
<%
	i++;
%>

  <tr > 
    <td colspan="4"> 
      <table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" width='100%'>
		<tr>
		<td>
		  <table border=0 cellpadding=0  cellspacing=0 style='CURSOR: hand' width='100%'>
			<tbody> 
			<tr bgcolor='#EEEEEE' id=ConditonMap<%=i%>Tab valign=center height='20'> 
			  <td align=right valign='middle'> <img alt='' border=0 id=ConditonMap<%=i%>Tab3 onClick="showHideContent('ConditonMap<%=i%>','<%=i%>');"  src='<%=sResourcesPath%>/expand.gif' style='CURSOR: hand' width='15' height='15'> 
			  </td>
			  <td align=left width='100%' valign='middle' onClick="javascript:ConditonMap<%=i%>Tab3.click();"> 
				<table>
				  <tr> 
					<td> <font color=#000000 id=ConditonMap<%=i%>Tab2 >配置信息导入导出</font> 
					</td>
				  </tr>
				</table>
			  </td>
			  <td align=right valign='top'> <img alt='' border=0 id=ConditonMap<%=i%>Tab1 src='<%=sResourcesPath%>/curve1.gif' width='0' height='0'> 
			  </td>
			</tr>
			</tbody> 
		  </table>
		</td>
	  </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="4"> 
      <div id=ConditonMap<%=i%>Content style=' WIDTH: 100%;display:none'> 
	<table class='conditionmap' width='100%' align='left' border='1' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="4">
			  <ul>
			  <tr> 
			    <td width="50%" >
			        <li><a href="javascript:importConfiguration()">导入配置信息</a></li>
			    </td>
			    <td width="50%" >
			        <li><a href="javascript:exportConfiguration()">导出配置信息</a></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li><a href="javascript:objEximPara()">配置信息导入导出参数设置</a></li>
			    </td>
			    <td width="50%" >
			        &nbsp;
			    </td>
			  </tr>
		      </ul>
			</table>

		</td>
	</tr>
	</table>
      </div>
    </td>
  </tr>
<%
	i++;
%>


  <tr > 
    <td colspan="4"> 
      <table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" width='100%'>
		<tr>
		<td>
		  <table border=0 cellpadding=0  cellspacing=0 style='CURSOR: hand' width='100%'>
			<tbody> 
			<tr bgcolor='#EEEEEE' id=ConditonMap<%=i%>Tab valign=center height='20'> 
			  <td align=right valign='middle'> <img alt='' border=0 id=ConditonMap<%=i%>Tab3 onClick="showHideContent('ConditonMap<%=i%>','<%=i%>');"  src='<%=sResourcesPath%>/expand.gif' style='CURSOR: hand' width='15' height='15'> 
			  </td>
			  <td align=left width='100%' valign='middle' onClick="javascript:ConditonMap<%=i%>Tab3.click();"> 
				<table>
				  <tr> 
					<td> <font color=#000000 id=ConditonMap<%=i%>Tab2 >系统监控</font> 
					</td>
				  </tr>
				</table>
			  </td>
			  <td align=right valign='top'> <img alt='' border=0 id=ConditonMap<%=i%>Tab1 src='<%=sResourcesPath%>/curve1.gif' width='0' height='0'> 
			  </td>
			</tr>
			</tbody> 
		  </table>
		</td>
	  </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="4"> 
      <div id=ConditonMap<%=i%>Content style=' WIDTH: 100%;display:none'> 
	<table class='conditionmap' width='100%' align='left' border='1' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="4">
			  <ul>
			  <tr> 
			    <td width="50%" >
			        <li><a href="javascript:viewCompStructure()">查看应用服务器内存组件结构</a></li>
			    </td>
			    <td width="50%" >
			       &nbsp;
			    </td>
			  </tr>
		      </ul>
			</table>

		</td>
	</tr>
	</table>
      </div>
    </td>
  </tr>
  
<%
  	i++;
  %>


  <tr > 
    <td colspan="4"> 
      <table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" width='100%'>
		<tr>
		<td>
		  <table border=0 cellpadding=0  cellspacing=0 style='CURSOR: hand' width='100%'>
			<tbody> 
			<tr bgcolor='#EEEEEE' id=ConditonMap<%=i%>Tab valign=center height='20'> 
			  <td align=right valign='middle'> <img alt='' border=0 id=ConditonMap<%=i%>Tab3 onClick="showHideContent('ConditonMap<%=i%>','<%=i%>');"  src='<%=sResourcesPath%>/expand.gif' style='CURSOR: hand' width='15' height='15'> 
			  </td>
			  <td align=left width='100%' valign='middle' onClick="javascript:ConditonMap<%=i%>Tab3.click();"> 
				<table>
				  <tr> 
					<td> <font color=#000000 id=ConditonMap<%=i%>Tab2 >系统参数缓存</font> 
					</td>
				  </tr>
				</table>
			  </td>
			  <td align=right valign='top'> <img alt='' border=0 id=ConditonMap<%=i%>Tab1 src='<%=sResourcesPath%>/curve1.gif' width='0' height='0'> 
			  </td>
			</tr>
			</tbody> 
		  </table>
		</td>
	  </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="4"> 
      <div id=ConditonMap<%=i%>Content style=' WIDTH: 100%;display:none'> 
	<table class='conditionmap' width='100%' align='left' border='1' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="4">
			  <ul>
			  <tr> 
			    <td width="50%" >
			        <li><a href="javascript:reloadAmarsoftXML()">重新读入amarsoft.xml(需重新登录)</a></li>
			    </td>
			    <td width="50%" >
			        <li><a href="javascript:reloadCache('ASCompSet')">刷新组件定义缓存</a></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li><a href="javascript:reloadCache('ASRoleSet')">刷新角色权限缓存</a></li>
			    </td>
			    <td width="50%" >
			        <li><a href="javascript:reloadCache('ASFuncSet')">刷新功能点定义缓存</a></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li><a href="javascript:reloadCache('ASPrefSet')">刷新用户参数类型定义缓存</a></li>
			    </td>
			    <td width="50%" >
			        <li><a href="javascript:reloadCache('ASCodeSet')">刷新代码定义缓存</a></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li><a href="javascript:reloadCache('SYSCONF_CLTYPE')">刷新授信额度类型定义缓存</a></li>
			    </td>
			    <td width="50%" >
					<li><a href="javascript:reloadCache('SYSCONF_LIMITATIONTYPE')">刷新额度限制类型定义缓存</a></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li><a href="javascript:reloadCache('SYSCONF_CL_ERROR_TYPE')">刷新授信额度异常点类型定义缓存</a></li>
			    </td>
			    <td width="50%" >
			        <li><a href="javascript:reloadCache('SYSCONF_BO_TYPE')">刷新对象类型定义缓存</a></li>
			    </td>
			  </tr>
		      </ul>
			</table>

		</td>
	</tr>
	</table>
      </div>
    </td>
  </tr>

  
</table>


<%
	i++;
%>







</div>

</body>
</html>

<script language="javascript">

	//用以控制几个条件区的显示或隐藏
	function showHideContent(id,iStrip)
	{
		var bMO = false;
		var bOn = false;
		var oTab    = document.all.item(id+"Tab");
		var oTab2   = document.all.item(id+"Tab2");
		var oImage   = document.all.item(id+"Tab3");
		var oContent = document.all.item(id+"Content");
		var oEmptyTag = document.all.item(id+"EmptyTag");

		if (!oTab || !oTab2 || !oImage || !oContent) 
		return;
	
		if (event.srcElement)
		{
			bMO = (event.srcElement.src.toLowerCase().indexOf("_mo.gif") != -1);
			bOn = (oContent.style.display.toLowerCase() == "none");
		}

		if (bOn == false)
		{
			oTab.bgColor = "#EEEEEE";
			oTab2.color  = "#000000";
			oContent.style.display = "none";
			if(oEmptyTag){
				oEmptyTag.style.display = "";
			}
		
			oImage.src = "<%=sResourcesPath%>/expand" + (bMO? ".gif" : ".gif");
		}
		else
		{
			oTab2.color  = "#ffffff";
			oTab.bgColor = "#00659C";
			oContent.style.display = "";
			if(oEmptyTag){
				oEmptyTag.style.display = "none";
			}
			oImage.src = "<%=sResourcesPath%>/collapse" + (bMO? "_mo.gif" : "_mo.gif");
		}
	
	}

	function importConfiguration(){
		popComp("ImportConfig","/Common/Configurator/ObjectExim/ImportFileSelect.jsp","","","");
	}

	function exportConfiguration(){
		popComp("ExportConfig","/Common/Configurator/ObjectExim/ExportObjectSelect.jsp","","","");
	}
	
	function objEximPara(){
		popComp("ObjectResEximConfig","/Common/Configurator/ObjectExim/ObjectResList.jsp","","","");
	}
	function reloadCache(CacheType){
		PopPage("/Common/ToolsB/reloadCacheConfig.jsp?ConfigName="+CacheType,"","");
	}

	function reloadAmarsoftXML(){
		PopPage("/Common/Configurator/ControlCenter/ClearAmarsoftXMLCache.jsp","","");
	}

	function viewCompStructure(){
		OpenComp("CompStructure","/Common/Configurator/ControlCenter/CompStructure.jsp","","W"+randomNumber().toString().substring(2),OpenStyle);
	}


	//showHideContent("ConditonMap0","0");
	ConditonMap0Tab3.click();
	ConditonMap2Tab3.click();
	ConditonMap3Tab3.click();

</script>
<%@ include file="/IncludeEnd.jsp"%>