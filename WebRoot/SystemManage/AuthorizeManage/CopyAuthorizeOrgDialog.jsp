<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>



<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: mshuang	2006-09-19
			Tester:
			Describe: 	���ƻ�����Ȩ
			Input Param:
			Output Param:
			HistoryLog: 
		*/
	%>
<%
	/*~END~*/
%>



<html>
<head> 
<title>������ͻ���Ϣ</title>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/
%>
	<%
		//�������
		
		//����������	

		//���ҳ�����	���ͻ�����
	%>
<%
	/*~END~*/
%>

<script language=javascript>
	function copyRecord()
	{
		//var sAuthorizeOrgLevel = document.all("AuthorizeOrgLevel").value;
		var sOrgID = document.all("OrgID").value;
		var sToOrgID = document.all("ToOrgID").value;
		var sAuthorizeType = document.all("AuthorizeType").value;

		//--by wwhe 2007-09-02	self.returnValue = sAuthorizeType+"@"+sAuthorizeOrgLevel+"@"+sOrgID+"@"+sToOrgID;
		self.returnValue = sAuthorizeType+"@"+sOrgID+"@"+sToOrgID;
		self.close();
	}
</script>

<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<br>
	<table align="center" width="420" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr>
		<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >ѡ����Ȩ������</td>
		<td nowarp bgcolor="#DCDCDC" > 
		<!--select name="AuthorizeNo"-->
		<select name="AuthorizeType">
			<option value = 'all'>ȫ����Ȩ����</option>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeType'  and ItemNo <> '41' and (Isinuse = '1' or Isinuse = '') order by 1",1,2,"")%>
		</select>
		</td>
	</tr>
	
	<!--by wwhe 2007-09-02   
	<tr>
		<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >ѡ����Ȩ����</td>
		<td>
		<select name="AuthorizeOrgLevel">
			<%//--by wwhe 2007-09-02   =HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeOrgLevel' order by 1",1,2,"")%>
		</select>
		</td>
	</tr>
	-->
	<!-- by mshuang 2008-05-19 
	<tr>
		<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >ѡ����Ա��ɫ��</td>
		<td>
		<select name="RoleID">
			<%//--by wwhe 2007-09-02   =HTMLControls.generateDropDownSelect(Sqlca,"select RoleID,RoleName from ROLE_INFO where (RoleName like '%���쵼%' or RoleName like '%��������%' or RoleName like '%����%' or RoleName like '%С��ҵ������Ա%' or  RoleName like '%������פ%') and RoleID not in ('260','282','236','235','035','036','010','027','227') order by 1",1,2,"")%>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeRoleID' and isinuse = '1' order by 1",1,2,"")%>
		</select>
		</td>
	</tr>
	-->
	<tr>
		<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >ѡ���ƻ�����</td>
		<td nowarp bgcolor="#DCDCDC" > 
		<select name="OrgID">
			<%
				//--by wwhe 2007-09-02   =HTMLControls.generateDropDownSelect(Sqlca,"select OrgID,case when orgid in('10000','11000','12000','13000','15000','16000','17000','18000','19000','20000') then orgname || '(ȫ��֧��)' else orgname end from ORG_INFO where (OrgType in ('02','03','07','11','12','13','14','15','16','17','41') or orgid in('10000','11000','12000','13000','15000','16000','17000','18000','19000','20000')) order by SortNo",1,2,"")
			%>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select OrgID,OrgName from org_info where OrgID in(select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') order by sortno",1,2,"")%>
		</select>
		</td>
    </tr>
    <tr>
		<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >ѡ�񱻸��ƻ�����</td>
		<td nowarp bgcolor="#DCDCDC" > 
		<select name="ToOrgID">
			<%
				//--by wwhe 2007-09-02   =HTMLControls.generateDropDownSelect(Sqlca,"select OrgID,case when orgid in('10000','11000','12000','13000','15000','16000','17000','18000','19000','20000') then orgname || '(ȫ��֧��)' else orgname end from ORG_INFO where (OrgType in ('02','03','07','11','12','13','14','15','16','17','41') or orgid in('10000','11000','12000','13000','15000','16000','17000','18000','19000','20000')) order by SortNo",1,2,"")
			%>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select OrgID,OrgName from org_info where OrgID in(select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') order by sortno",1,2,"")%>
		</select>
		</td>
    </tr>
    <tr>
      	<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" height="25" >
      	</td>
      	<td nowarp bgcolor="#DCDCDC" height="25">
        <input type="button" name="next" value="ȷ��" onClick="javascript:copyRecord()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      	</td>
    </tr>
  </table>
</body>
</html>



<%@ include file="/IncludeEnd.jsp"%>