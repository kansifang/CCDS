<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XWu 2004.12.04
 * Tester:
 *
 * Content:      ѡ�����ʲ��������
 * Input Param:
 *			   ShowFlag: ��ʾ����
 						010 �����ʲ��ַ���ʾ
 * Output param:
 *		RecoveryUserID�� ��ȫ��������ԱID
 *		RecoveryUserName����ȫ��������Ա����
 *		RecoveryOrgID����ȫ��������Ա��������ID
 * History Log: 
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������	    

	//����������
	
	//���ҳ�����
	//���ҳ������������š���������	
	String sShowFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ShowFlag"));	
	//����ֵת��Ϊ���ַ���	
	if(sShowFlag == null) sShowFlag = "";			
%>
<%/*~END~*/%>
<html>
<head> 
<title>ѡ�����ʲ�������</title>

<script language=javascript>

	function newTraceUser()
	{		
		sTraceOrgID = document.buff.TraceOrgID.value;
		self.returnValue=sTraceOrgID+"@";//���ز���
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
		<td nowarp bgcolor="#F0F1DE" >��ѡ��������:	
			<input type='text' style='width:250px' name="TraceOrgName" value="" ReadOnly=true>
			<input type=button value="" onclick=parent.selectOrg()>
			<input type=hidden name="TraceOrgID" value="" >
    	</td>
	</tr>	
  </table>
  
  <br>
  <table align="center" width="250" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr >
     <td nowrap align="right" class="black9pt"  ><%=HTMLControls.generateButton("ȷ��","","javascript:newTraceUser()",sResourcesPath)%></td>
     <td nowrap  ><%=HTMLControls.generateButton("ȡ��","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>    
 
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>