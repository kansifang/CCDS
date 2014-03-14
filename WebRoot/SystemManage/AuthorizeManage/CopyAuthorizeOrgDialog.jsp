<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>



<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: mshuang	2006-09-19
			Tester:
			Describe: 	复制机构授权
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
<title>请输入客户信息</title>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/
%>
	<%
		//定义变量
		
		//获得组件参数	

		//获得页面参数	：客户类型
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
		<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >选择授权方案：</td>
		<td nowarp bgcolor="#DCDCDC" > 
		<!--select name="AuthorizeNo"-->
		<select name="AuthorizeType">
			<option value = 'all'>全部授权方案</option>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeType'  and ItemNo <> '41' and (Isinuse = '1' or Isinuse = '') order by 1",1,2,"")%>
		</select>
		</td>
	</tr>
	
	<!--by wwhe 2007-09-02   
	<tr>
		<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >选择授权级别：</td>
		<td>
		<select name="AuthorizeOrgLevel">
			<%//--by wwhe 2007-09-02   =HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeOrgLevel' order by 1",1,2,"")%>
		</select>
		</td>
	</tr>
	-->
	<!-- by mshuang 2008-05-19 
	<tr>
		<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >选择人员角色：</td>
		<td>
		<select name="RoleID">
			<%//--by wwhe 2007-09-02   =HTMLControls.generateDropDownSelect(Sqlca,"select RoleID,RoleName from ROLE_INFO where (RoleName like '%行领导%' or RoleName like '%审批中心%' or RoleName like '%贷审%' or RoleName like '%小企业部审批员%' or  RoleName like '%总行派驻%') and RoleID not in ('260','282','236','235','035','036','010','027','227') order by 1",1,2,"")%>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeRoleID' and isinuse = '1' order by 1",1,2,"")%>
		</select>
		</td>
	</tr>
	-->
	<tr>
		<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >选择复制机构：</td>
		<td nowarp bgcolor="#DCDCDC" > 
		<select name="OrgID">
			<%
				//--by wwhe 2007-09-02   =HTMLControls.generateDropDownSelect(Sqlca,"select OrgID,case when orgid in('10000','11000','12000','13000','15000','16000','17000','18000','19000','20000') then orgname || '(全部支行)' else orgname end from ORG_INFO where (OrgType in ('02','03','07','11','12','13','14','15','16','17','41') or orgid in('10000','11000','12000','13000','15000','16000','17000','18000','19000','20000')) order by SortNo",1,2,"")
			%>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select OrgID,OrgName from org_info where OrgID in(select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') order by sortno",1,2,"")%>
		</select>
		</td>
    </tr>
    <tr>
		<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >选择被复制机构：</td>
		<td nowarp bgcolor="#DCDCDC" > 
		<select name="ToOrgID">
			<%
				//--by wwhe 2007-09-02   =HTMLControls.generateDropDownSelect(Sqlca,"select OrgID,case when orgid in('10000','11000','12000','13000','15000','16000','17000','18000','19000','20000') then orgname || '(全部支行)' else orgname end from ORG_INFO where (OrgType in ('02','03','07','11','12','13','14','15','16','17','41') or orgid in('10000','11000','12000','13000','15000','16000','17000','18000','19000','20000')) order by SortNo",1,2,"")
			%>
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select OrgID,OrgName from org_info where OrgID in(select BelongOrgID from ORG_BELONG where OrgID = '"+CurOrg.OrgID+"') order by sortno",1,2,"")%>
		</select>
		</td>
    </tr>
    <tr>
      	<td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" height="25" >
      	</td>
      	<td nowarp bgcolor="#DCDCDC" height="25">
        <input type="button" name="next" value="确认" onClick="javascript:copyRecord()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      	</td>
    </tr>
  </table>
</body>
</html>



<%@ include file="/IncludeEnd.jsp"%>