<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cyyu 2009-03-23
		Tester:
		Content: �û���ɫ�б�
		Input Param:
			ItemNo,ItemName,RelativeCode
		Output param:
		    returnValue            
		History Log: 
            
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>  
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSortNo; //������
	String sItemNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
	String sItemName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemName"));
	String sRelativeCode = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RelativeCode"));
	if (sItemNo == null) sItemNo = "";
	if (sItemName == null) sItemName = "";
	if (sRelativeCode == null) sRelativeCode = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
    String sSql = " select RoleID,RoleName,RoleAttribute,RoleDescribe "+
    			  " from ROLE_INFO "+
    			  " where RoleStatus='1'";
    ASResultSet rs = Sqlca.getASResultSet(sSql);
    int iRow = rs.getRowCount();
    if (iRow==0) iRow=1;
    String[][] sRoleIDNodes = new String[iRow][4] ;
    iRow=0;
	while (rs.next()) {
 		sRoleIDNodes[iRow][0] = rs.getString("RoleID");		
 		sRoleIDNodes[iRow][1] = rs.getString("RoleName");		
 		sRoleIDNodes[iRow][2] = rs.getString("RoleAttribute");		
 		sRoleIDNodes[iRow][3] = rs.getString("RoleDescribe");
 		if (sRoleIDNodes[iRow][0] == null) sRoleIDNodes[iRow][0] = "";
 		if (sRoleIDNodes[iRow][1] == null) sRoleIDNodes[iRow][1] = "";
 		if (sRoleIDNodes[iRow][2] == null) sRoleIDNodes[iRow][2] = "";
 		if (sRoleIDNodes[iRow][3] == null) sRoleIDNodes[iRow][3] = "";
 		iRow++;
 	}
	rs.getStatement().close();
%>

<%/*~END~*/%>

<body leftmargin="0" topmargin="0" onload="" class="ListPage" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
<tr height=1 align=center>
    <td>���÷���&nbsp;&nbsp;<font color=#6666cc>(<%=sItemName%>)</font>&nbsp;&nbsp;��Ҫ�Ľ�ɫ
        
    </td>
</tr>
<tr height=1 valign=top >
    <td>
    	<table align=center>
	    	<tr>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȷ��","����Ȩ�޶�����Ϣ","javascript:saveRightConf()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȫѡ","ȫѡ","javascript:selectAll()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȫ��ѡ","ȫ��ѡ","javascript:selectNone()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ѡ","��ѡ","javascript:selectInverse()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�ָ�","�ָ�","javascript:restore()",sResourcesPath)%>
	    		</td>
    		</tr>
    	</table>
    </td>
</tr>
<tr width=100% align="center" width=90%>
    <td valign="top" >
    <div style="positition:absolute;width:100%;height:100%;overflow:auto">
	<table border="0"  cellspacing="1" cellpadding="4" style="{border:  dash 1px;}">
		<tr height=1 valign=top class="RoleTitle">
		    <td width=5% align=center>&nbsp;</td>
		    <td width=15%>��ɫID</td>
		    <td width=20%>��ɫ����</td>
		    <td width=30%>��ɫ����</td>
		    <td width=30%>��ɫ����</td>
		</tr>
		<form method=post name="CheckBoxes">
			<INPUT type="hidden" name="ItemNo" value="<%=sItemNo%>">
		
		<%
        int countLeaf=1;
		for(int i=0;i<sRoleIDNodes.length;i++)
        {            
     	%>
	        <tr height=1 valign=top class="RoleLeafCheck">
		        <td align=center>
		            <INPUT ID="checkbox<%=countLeaf%>" type="checkbox" name="<%=sRoleIDNodes[i][0]%>" >
		        </td>
		        <td><%=sRoleIDNodes[i][0]%></td>
		        <td><%=sRoleIDNodes[i][1]%></td>
		        <td><%=sRoleIDNodes[i][2]%></td>
		        <td><%=sRoleIDNodes[i][3]%></td>
            </tr>
		<%
		countLeaf++;
        }
		%>
		</form>
	</table>
	</div>
    </td>
</tr>
</table>
</body>
<script>
	function saveRightConf(){
		var iControls = <%=countLeaf%>;
		var sRightString = "";
		for(iTmp=1;iTmp<iControls;iTmp++){
			if(document.all("checkbox"+iTmp).checked)
			{
				sRightString = sRightString + "," + document.all("checkbox"+iTmp).name;
			}
		}
		top.returnValue = sRightString.substring(1);
		top.close();
	}

	function selectAll(){
		var iControls = <%=countLeaf%>;
		var iTmp = 1;
		for(iTmp=1;iTmp<iControls;iTmp++){
			document.all("checkbox"+iTmp).checked=true;
		}

	}
	function selectNone(){
		var iControls = <%=countLeaf%>;
		var iTmp = 1;
		for(iTmp=1;iTmp<iControls;iTmp++){
			document.all("checkbox"+iTmp).checked=false;
		}

	}
	function selectInverse(){
		var iControls = <%=countLeaf%>;
		var iTmp = 1;
		for(iTmp=1;iTmp<iControls;iTmp++){
			document.all("checkbox"+iTmp).checked=!document.all("checkbox"+iTmp).checked;
		}

	}
	function restore(){
		document.forms("CheckBoxes").reset();
	}
	function initRow()
	{
		sRelativeCode = "<%=sRelativeCode%>";
		sRoleIDs = sRelativeCode.split(",");
		var iControls = <%=countLeaf%>;
		var iTmp = 1;
		for(iTmp=1;iTmp<iControls;iTmp++)
		{
			for(i=0;i<sRoleIDs.length;i++)
			{
				if(document.all("checkbox"+iTmp).name == sRoleIDs[i])
					document.all("checkbox"+iTmp).checked = true;
			}
		}
	}
	
	
</script>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language="JavaScript">
	initRow();
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
