<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: FSGong 2004.12.08
 * Tester:
 *
 * Content:      ѡ���ծ�ʲ�����
 * Input Param:
 *			    
 * Output param:
 *	AssetType����ծ�ʲ�����	
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head> 
<title>ѡ���ծ�ʲ�����</title>
<%
	//��ծ�ʲ�����
	String sAssetType="";
%>
<script language=javascript>

	function Get_AssetType()
	{
		var sAssetType ;
		
		//��ծ�ʲ�����
		sAssetType = document.all("AssetType").value;
		
		if(sAssetType == "")
		{
			alert(getBusinessMessage("783"));//��ѡ���ծ�ʲ����ͣ�
			return;
		}
		  		
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = initSerialNo();
		//����ող��������кż�¼������ȱʡֵ��
		PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDAInsertAction.jsp?SerialNo="+sSerialNo+"&AssetType="+sAssetType,"","");

		//�����ʲ����ͺ����к�
		self.returnValue=sAssetType+"@"+sSerialNo;
		self.close();
	}
	
	function initSerialNo()
	{
		 //����һ���µļ�¼����Asset_Info�����кš�
		var sTableName = "ASSET_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		var  sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		return sSerialNo;
	}
	
</script>

<style TYPE="text/css">
.changeColor{ background-color: #F0F1DE  }
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
<form name="buff">
  <table align="center" width="240" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr id="ListTitle" class="ListTitle">
	    <td>
	    </td>
    </tr>
	<tr> 
	<td nowarp align="center" class="black9pt" bgcolor="#F0F1DE" >ѡ���ծ�ʲ����ࣺ</td>
	<td nowarp bgcolor="#F0F1DE" > 
		<select name="AssetType" >
			<%=HTMLControls.generateDropDownSelect(Sqlca,"PDAType",sAssetType)%> 
		</select>
	</td>
	</tr>
    </table>
  <table align="center" width="240" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr>
	<td> </td>
	</tr>
    <tr>
     <td nowrap align="right" class="black9pt" bgcolor="#F0F1DE" ><%=HTMLControls.generateButton("ȷ��","","javascript:Get_AssetType()",sResourcesPath)%></td>
     <td nowrap bgcolor="#F0F1DE" ><%=HTMLControls.generateButton("ȡ��","","javascript:self.returnValue='';self.close()",sResourcesPath)%></td>
    </tr>
  </table>     
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>