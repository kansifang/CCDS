<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XWu 2004.12.04
 * Tester:
 *
 * Content:      选择不良资产管理机构
 * Input Param:
 *			   ShowFlag: 显示控制
 						010 不良资产分发显示
 * Output param:
 *		RecoveryUserID： 保全部管理人员ID
 *		RecoveryUserName：保全部管理人员名称
 *		RecoveryOrgID：保全部管理人员所属机构ID
 * History Log: 
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量	    

	//获得组件参数
	
	//获得页面参数
	//获得页面参数：质物编号、质物类型	
	String sShowFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ShowFlag"));	
	//将空值转化为空字符串	
	if(sShowFlag == null) sShowFlag = "";			
%>
<%/*~END~*/%>
<html>
<head> 
<title>选择不良资产管理人</title>

<script language=javascript>

	function newTraceUser()
	{		
		sTraceOrgID = document.buff.TraceOrgID.value;
		self.returnValue=sTraceOrgID+"@";//返回参数
		self.close();
	}
	
	function selectOrg()
	{
		var sParaString = "SortNo,"+"<%=CurOrg.SortNo%>";
		var sReturn= selectObjectValue("SelectBadBizOrg",sParaString,"");
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'))
		{
			sReturn=sReturn.split("@");
			document.all("TraceOrgID").value=sReturn[0];
			document.all("TraceOrgName").value=sReturn[1];
			
		}
		else if (sReturn=='_CLEAR_')
		{
			document.all("TraceOrgID").value="";
			document.all("TraceOrgName").value="";
		}
		else 
		{
			return;
		}
	}	   
	
	
</script>

<style TYPE="text/css">
.changeColor{ background-color: #F0F1DE  }
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
<form name="buff">
  <table align="center" width="280" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr>
		<td nowarp align="left" class="black9pt" bgcolor="#F0F1DE" ></td> 
		<td nowarp bgcolor="#F0F1DE" >请选择管理机构:	
			<input type='text' style='width:250px' name="TraceOrgName" value="" ReadOnly=true>
			<input type=button value="" onclick=parent.selectOrg()>
			<input type=hidden name="TraceOrgID" value="" >
    	</td>
	</tr>	
  </table>
  
  <br>
  <table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr >
     <td nowrap align="right" class="black9pt"  ><%=HTMLControls.generateButton("确认","","javascript:newTraceUser()",sResourcesPath)%></td>
     <td nowrap  ><%=HTMLControls.generateButton("取消","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>