<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-6
		Tester:
		Describe: 担保类型选择框;
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	//根据sObjectType的不同，得到不同的关联表名
	String sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";
	String sObjectTable = Sqlca.getString(sSql);
	sSql="select BusinessType,VouchType from "+sObjectTable+" where SerialNo='"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	String sBusinessType = "",sVouchType = "",sGuarantyType="";
	if(rs.next()){
		sBusinessType = rs.getString("BusinessType");
		if(sBusinessType == null) sBusinessType = "";
		sVouchType = rs.getString("VouchType");
		if(sVouchType == null) sVouchType = "";
	}
	rs.getStatement().close();
	//表外表内标志
	String sBusinessAttr = sBusinessType.substring(0,1);
	if(sVouchType.startsWith("010")){
		sGuarantyType = "010010";
	}else if(sVouchType.startsWith("020")){
		sGuarantyType = "050";
	}else if(sVouchType.startsWith("040")){
		sGuarantyType = "060";
	}
%>
<script language=javascript>
    if(<%=sVouchType%> == "0105080")
    {
        alert("100%保证金业务不需录入担保信息！");
    }
</script>
<html>
<head> 
<title>选择担保类型</title>
<script language=javascript>
function newGuarantyInfo()
{
		self.returnValue=document.all("NewGuarantyType").value;
		self.close();
}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DEDFCE">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" >选择担保类型：</td>
      <td nowarp bgcolor="#F0F1DE" > 
        <select name="NewGuarantyType">
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'GuarantyType' and IsInUse = '1' and ItemAttribute like '%"+sBusinessAttr+"%' order by SortNo ",1,2,sGuarantyType)%> 
        </select>
      </td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#D8D8AF" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#F0F1DE" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:newGuarantyInfo()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>