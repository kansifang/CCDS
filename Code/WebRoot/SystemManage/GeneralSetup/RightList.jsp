<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: 权限列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>  
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSqldel = "";
	String sPara = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Para"));
    String sRightStringToUpdate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightStringToUpdate"));
    String sDeleteString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DeleteString"));

    if (sPara == null) sPara = "@@";
    String sParas[] = sPara.split("@");//组件号＋类型（用户、角色）＋类型对应编号（用户号、角色号）
    String sRelativeTable="";   //权限关联表
    String sKey=""; //对应关联表的主键
    String sInsertSql="";  //Insert语句
    String sSelectSql="";

    if (sParas[1].equals("USER")) //用户具有的权限
    {
        sRelativeTable="USER_RIGHT";
        sKey="UserID";
        sSelectSql="select RightID from USER_RIGHT where UserID='"+sParas[2]+"'";
    }else if (sParas[1].equals("ROLE")) //角色具有的权限
    {
        sRelativeTable="ROLE_RIGHT";
        sKey="RoleID";
        sSelectSql="select RightID from ROLE_RIGHT where RoleID='"+sParas[2]+"'";
    }
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
    StringTokenizer st =null;
    ASResultSet rs1 = null;
	String sParastr = "",sSplit1="",sSplit2 = "",sSqlStr = "";
	int iCount = 0;
	if(sRightStringToUpdate!=null && !sRightStringToUpdate.equals("")){
		st = new StringTokenizer(sRightStringToUpdate,"@");		
		SqlcaRepository.executeSQL(" delete from "+sRelativeTable+" where "+sKey+"='"+sParas[2]+"' "+sDeleteString+" ");
        while (st.hasMoreTokens())
		{
			sParastr = st.nextToken(); 
			sSplit1 = StringFunction.getSeparate(sParastr,":",1);
			sSplit2 = StringFunction.getSeparate(sParastr,":",2);

            if(sSplit2!=null && sSplit2.equals("true")){
                if (sParas[1].equals("USER")) //用户具有的权限
                {
                    sSqlStr = 	"select count(UserID) from USER_RIGHT "+
	                    		"where UserID = '"+sParas[2]+"' "+
	                    		"and RightId = '"+sSplit1+"' "+
	                    		"and Grantor = '"+CurUser.UserID+"' "+
	                    		"and BeginTime = '"+StringFunction.getToday()+"' ";
                    rs1 = Sqlca.getASResultSet(sSqlStr);
                    if(rs1.next())
                    	iCount = rs1.getInt(1);
                    if(iCount == 0)
                    {
                    	sInsertSql=" insert into USER_RIGHT(UserID,RightId,Grantor,BeginTime,EndTime,InputUser,InputOrg,InputTime,Status) values('"+sParas[2]+"','"+sSplit1+"' ,'"+CurUser.UserID+"','"+StringFunction.getToday()+"','','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+StringFunction.getToday()+" "+StringFunction.getNow()+"','1')";
                		SqlcaRepository.executeSQL(sInsertSql);
                	}
                }else if (sParas[1].equals("ROLE")) //角色具有的权限
                {
                	sSqlStr = 	"select count(RightId) from ROLE_RIGHT "+
	                    		"where RightId = '"+sSplit1+"' "+
	                    		"and RoleId = '"+sParas[2]+"' ";
                    rs1 = Sqlca.getASResultSet(sSqlStr);
                    if(rs1.next())
                    	iCount = rs1.getInt(1);
                    if(iCount == 0)
                    {
	                    sInsertSql=" insert into ROLE_RIGHT(RoleID,RightId,InputUser,InputOrg,InputTime) values('"+sParas[2]+"','"+sSplit1+"' ,'"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+StringFunction.getToday()+" "+StringFunction.getNow()+"')";
	                	SqlcaRepository.executeSQL(sInsertSql);
	                }
                }
                
            }
		}
		%>
		<script>alert("保存成功");</script>
		<%
	}
    
    String sSql = "";
    ASResultSet rs=null;
    String sCompOrderNo = "";//组件排序号
    String sRightIDString="";

    //取组件排序号
	sSql = "select OrderNo from REG_COMP_DEF where CompID='"+sParas[0]+"'";
	rs = SqlcaRepository.getASResultSet(sSql);
	if(rs.next()) sCompOrderNo = rs.getString("OrderNo");
	rs.getStatement().close();
    
    //取出当前用户所具有的权限
	rs = SqlcaRepository.getASResultSet(sSelectSql);
	while(rs.next()){
		sRightIDString = sRightIDString + rs.getString(1)+"@";
	}
	rs.getStatement().close();
	//out.println(sRightIDString);
        
    sSql = "select RightID,RightName,getItemName('IsInUse',RightStatus) as RightStatus from RIGHT_INFO WHERE RightID in (select RightID from REG_COMP_DEF where OrderNo like'"+sCompOrderNo+"%') or RightID in (select RightID from REG_FUNCTION_DEF where CompID in ((select CompID from REG_COMP_DEF where OrderNo like'"+sCompOrderNo+"%')))  ORDER BY RightID ";
    sSqldel = " and RightID in (select RightID from REG_COMP_DEF where OrderNo like'"+sCompOrderNo+"%') or RightID in (select RightID from REG_FUNCTION_DEF where CompID in ((select CompID from REG_COMP_DEF where OrderNo like'"+sCompOrderNo+"%')))" ;
%>

<%/*~END~*/%>

<body leftmargin="0" topmargin="0" onload="" class="ListPage">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
<tr height=1>
    <%
        if (sParas[1].equals("USER")) //用户具有的权限
        {
           rs=Sqlca.getASResultSet("select UserName from USER_INFO where UserID='"+sParas[2]+"'");
           if (rs.next())
           {
                out.println("<td>用户&nbsp;&nbsp;<font color=#6666cc>"+rs.getString(1)+"("+sParas[2]+")</font>&nbsp;&nbsp;具有的权限</td>");
           }
           rs.getStatement().close();
        }else if (sParas[1].equals("ROLE")) //角色具有的权限
        {
            rs=Sqlca.getASResultSet("select RoleName from ROLE_INFO where RoleID='"+sParas[2]+"'");
           if (rs.next())
           {
                out.println("<td>角色&nbsp;&nbsp;<font color=#6666cc>"+rs.getString(1)+"("+sParas[2]+")</font>&nbsp;&nbsp;具有的权限</td>");
           }
           rs.getStatement().close();
        }
    %>
</tr>
<tr height=1 valign=top >
    <td>
    	<table>
	    	<tr>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","保存","保存权限定义信息","javascript:saveRightConf()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","全选","全选","javascript:selectAll()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","全不选","全不选","javascript:selectNone()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","反选","反选","javascript:selectInverse()",sResourcesPath)%>
	    		</td>
	    		<td>
	                	<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","恢复","恢复","javascript:restore()",sResourcesPath)%>
	    		</td>
    		</tr>
    	</table>
    </td>
</tr>
<tr>
    <td valign="top" >
	<div style="position:absolute;width:100%;height:100%;overflow:auto">
	<table border="0"  cellspacing="1" cellpadding="4" style="{border:  dash 1px;overflow:scroll;}" >
		<tr height=1 valign=top class="RoleTitle">
		    <td width=3% align=center>&nbsp;</td>
		    <td width=10%>权限ID</td>
		    <td width=20%>权限名称</td>
		    <td width=10%>状态</td>
		</tr>
		<form method=post name=RightConfig>
			<INPUT TYPE="hidden" NAME="RightStringToUpdate">
			<INPUT TYPE="hidden" NAME="Para" value="<%=sPara%>">
			<INPUT TYPE="hidden" NAME="DeleteString" value="<%=sSqldel%>">
		</form>
		<form name=CheckBoxes>
        <%
        int countLeaf=0;
		rs=Sqlca.getASResultSet(sSql);		
        while (rs.next()) 
        {
            ++countLeaf;            
            if(sRightIDString.indexOf(rs.getString("RightID"))>=0)  //是否有权限
            {%>
                <tr height=1 valign=top class="RoleLeafCheck">
                    <td align=center>
                        <INPUT ID="checkbox<%=countLeaf%>" TYPE="checkbox" NAME="<%=rs.getString("RightID")%>" checked>
                    </td>
                    <td><%=rs.getString(1)%></td>
                    <td><%=rs.getString(2)%></td>
                    <td><%=rs.getString(3)%></td>
                </tr>
            <%}else
            {
            %>
                <tr height=1 valign=top class="RoleLeafUncheck">
                    <td align=center>
                        <INPUT ID="checkbox<%=countLeaf%>" TYPE="checkbox" NAME="<%=rs.getString("RightID")%>">
                    </td>
                    <td><%=rs.getString(1)%></td>
                    <td><%=rs.getString(2)%></td>
                    <td><%=rs.getString(3)%></td>
                </tr>
            <%
            }
            %>
		    
		<%
		}
		rs.getStatement().close();
		%>
		</form>
	</table>
	</div>
    </td>
</tr>
</table>
</body>
</html>
<script>
	function saveRightConf(){
		var iControls = <%=countLeaf%>;
		if(!confirm("确认要保存对角色的修改吗？")){
			return;
		}
		var sRightStringToUpdate = "";
		var iTmp = 1;
		for(iTmp=1;iTmp<=iControls;iTmp++){
			sRightStringToUpdate = sRightStringToUpdate + document.all("checkbox"+iTmp).name + ":" + document.all("checkbox"+iTmp).checked+"@";
		}
		document.all("RightStringToUpdate").value=sRightStringToUpdate;
		document.forms("RightConfig").submit();
	}

	function selectAll(){
		var iControls = <%=countLeaf%>;
		var iTmp = 1;
		for(iTmp=1;iTmp<=iControls;iTmp++){
			document.all("checkbox"+iTmp).checked=true;
		}

	}
	function selectNone(){
		var iControls = <%=countLeaf%>;
		var iTmp = 1;
		for(iTmp=1;iTmp<=iControls;iTmp++){
			document.all("checkbox"+iTmp).checked=false;
		}

	}
	function selectInverse(){
		var iControls = <%=countLeaf%>;
		var iTmp = 1;
		for(iTmp=1;iTmp<=iControls;iTmp++){
			document.all("checkbox"+iTmp).checked=!document.all("checkbox"+iTmp).checked;
		}

	}
	function restore(){
		document.forms("CheckBoxes").reset();

	}
	
</script>


<%@ include file="/IncludeEnd.jsp"%>
