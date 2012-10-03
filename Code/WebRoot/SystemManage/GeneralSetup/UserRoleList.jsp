<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: 用户角色列表
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
	String sSortNo; //排序编号
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
    String sRightStringToUpdate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightStringToUpdate"));
	if (sUserID == null) sUserID = "";
    if (sRightStringToUpdate == null) sRightStringToUpdate = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	StringTokenizer st =null;
	String sSplitStr = "",sSplit1 = "",sSplit2 = "";
	if(!sRightStringToUpdate.equals("")){
		st = new StringTokenizer(sRightStringToUpdate,"@");
		SqlcaRepository.executeSQL(" delete from USER_ROLE where UserID = '"+sUserID+"' ");
	    while (st.hasMoreTokens())
		{
			sSplitStr = st.nextToken(); 
			sSplit1 = StringFunction.getSeparate(sSplitStr,":",1);
			sSplit2 = StringFunction.getSeparate(sSplitStr,":",2);
			if(sSplit2!=null && sSplit2.equals("true")){
	            SqlcaRepository.executeSQL(" insert into USER_ROLE(UserID,RoleId,Grantor,BeginTime,EndTime,InputUser,InputOrg,InputTime,Status) values('"+sUserID+"','"+sSplit1+"' ,'"+CurUser.UserID+"','"+StringFunction.getToday()+"','','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+StringFunction.getToday()+" "+StringFunction.getNow()+"','1')");
	        }
		}
		%>
		<script>alert(getHtmlMessage('4'));//信息保存成功！</script>
		<%
	}
    
    
	/**
	 * @Author:CWZhan 
	 * @Date:  2005-2-1	
	 * @Action:	 取出所有的角色，并判断该用户是否有该角色，并判断该角色是否为叶子结点
	 */	
    String sSql = " select getUserName(UserID),RoleID,getUserName(Grantor), "+
    			  " getItemName('IsInUse',Status),BeginTime,EndTime "+
    			  " from USER_ROLE "+
    			  " where UserID = '"+sUserID+"'";
    ASResultSet rs=Sqlca.getASResultSet(sSql);
    int iRow = rs.getRowCount();
    if (iRow==0) iRow=1;
    String[][] sUserRoleNodes = new String[iRow][6] ;
    iRow=0;
    while (rs.next())
    {
    	if(rs.getString(1) == null)
    		sUserRoleNodes[iRow][0] = "";
    	else
    		sUserRoleNodes[iRow][0] = rs.getString(1);  
    	if(rs.getString(2) == null)
    		sUserRoleNodes[iRow][1] = "";
    	else
    		sUserRoleNodes[iRow][1] = rs.getString(2);  
    	if(rs.getString(3) == null)
    		sUserRoleNodes[iRow][2] = "";
    	else
    		sUserRoleNodes[iRow][2] = rs.getString(3);  
    	if(rs.getString(4) == null)
    		sUserRoleNodes[iRow][3] = "";
    	else
    		sUserRoleNodes[iRow][3] = rs.getString(4);  
    	if(rs.getString(5) == null)
    		sUserRoleNodes[iRow][4] = "";
    	else
    		sUserRoleNodes[iRow][4] = rs.getString(5);  
    	if(rs.getString(6) == null)
    		sUserRoleNodes[iRow][5] = "";
    	else
    		sUserRoleNodes[iRow][5] = rs.getString(6);          	        	  
    	
    	iRow++;
    }
    rs.getStatement().close();
    
    //实例化用户对象
	ASUser o_User = new ASUser(sUserID,Sqlca);		
	//获取机构级别
	String sOrgLevel = Sqlca.getString("select OrgLevel from ORG_INFO where OrgID = '"+o_User.OrgID+"'");
	if(sOrgLevel == null) sOrgLevel = "";
	
    sSql = "select RoleID,RoleName from ROLE_INFO where 1=1 ";
    if(sOrgLevel.equals("0")) //机构级别OrgLevel(0：总行；3：分行；6：支行；9：网点)
    	 sSql += " and (RoleID like '0%' "+	        		
        		 " or RoleID like '8%') "+
        		 " and RoleStatus = '1' ";
    if(sOrgLevel.equals("3")) //机构级别OrgLevel(0：总行；3：分行；6：支行；9：网点)
    	 sSql += " and (RoleID like '2%' "+	        		
        		 " or RoleID like '8%') "+
        		 " and RoleStatus = '1' ";
    if(sOrgLevel.equals("6")) //机构级别OrgLevel(0：总行；3：分行；6：支行；9：网点)
        sSql += " and (RoleID like '4%' "+
        		" or RoleID like '8%') "+
        		" and RoleStatus = '1' ";
     sSql += " order by RoleID ";
    rs=Sqlca.getASResultSet(sSql);
    iRow = rs.getRowCount();
    if (iRow==0) iRow=1;
    String[][] sRoleNodes = new String[iRow][8] ;
    iRow=0;
    while (rs.next())
    {
    	sRoleNodes[iRow][0]=rs.getString(1);
    	sRoleNodes[iRow][1]=rs.getString(2);
    	sRoleNodes[iRow][2]="TRUE";	//isLeaf
    	sRoleNodes[iRow][3]="FALSE";	//hasRole
    	sRoleNodes[iRow][4]=""; //授权人
        sRoleNodes[iRow][5]="";
        sRoleNodes[iRow][6]="";
        sRoleNodes[iRow][7]="";
    	iRow++;
    }
    rs.getStatement().close();
    
    
    for(int i=0;i<sRoleNodes.length;i++)
    {
    	//Is The Node Leaf?
    	for(int j=0;j<sRoleNodes.length;j++)
        {
        	if(i==j) continue;
        	if(sRoleNodes[j][0].startsWith(sRoleNodes[i][0])) sRoleNodes[i][2]="FALSE";
        }
        
        //Has The Node Role?
        for(int j=0;j<sUserRoleNodes.length;j++)
        {
        	if(sRoleNodes[i][0].equals(sUserRoleNodes[j][1])) 
            {
                sRoleNodes[i][3]="TRUE";
                sRoleNodes[i][4]=sUserRoleNodes[j][2]; //授权人
                sRoleNodes[i][5]=sUserRoleNodes[j][3];
                sRoleNodes[i][6]=sUserRoleNodes[j][4];
                sRoleNodes[i][7]=sUserRoleNodes[j][5];
            }
            
        }
        
    }

	
%>

<%/*~END~*/%>

<body leftmargin="0" topmargin="0" onload="" class="ListPage" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
<tr height=1 align=center>
    <td>用户&nbsp;&nbsp;<font color=#6666cc>(<%=sUserID%>)</font>&nbsp;&nbsp;具有的角色
        
    </td>
</tr>
<tr height=1 valign=top >
    <td>
    	<table>
	    	<tr>
	    	 <%
 	         if(!CurUser.hasRole("097"))
 	         {
             %>
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
	    	<%
 	         }
            %>
    		</tr>
    	</table>
    </td>
</tr>
<tr width=100% align="center" width=90%>
    <td valign="top" >
    <div style="positition:absolute;width:100%;height:100%;overflow:auto">
	<table border="0"  cellspacing="1" cellpadding="4" style="{border:  dash 1px;}">
		<tr height=1 valign=top class="RoleTitle">
		    <td width=3% align=center>&nbsp;</td>
		    <td width=10%>角色ID</td>
		    <td width=20%>角色名称</td>
		    <td width=10%>授权人</td>
		    <td width=10%>状态</td>
		    <td width=10%>开始日</td>
		    <td width=10%>到期日</td>
		</tr>
		<form method=post name=RightConfig>
			<INPUT TYPE="hidden" NAME="RightStringToUpdate">
			<INPUT TYPE="hidden" NAME="UserID" value="<%=sUserID%>">
		</form>
		<form name=CheckBoxes>
		<%
        int countLeaf=0;
		for(int i=0;i<sRoleNodes.length;i++)
        {            
            if (sRoleNodes[i][2].equals("TRUE"))  //是否为叶
		    {
                ++countLeaf;
                if(sRoleNodes[i][3].equals("TRUE"))  //是否有角色
                {               
     	%>
			        <tr height=1 valign=top class="RoleLeafCheck">
                        <td align=center>
                            <INPUT ID="checkbox<%=countLeaf%>" TYPE="checkbox" NAME="<%=sRoleNodes[i][0]%>" checked>
                        </td>
                        <td><%=sRoleNodes[i][0]%></td>
                        <td><%=sRoleNodes[i][1]%></td>
                        <td><%=sRoleNodes[i][4]%></td>
                        <td><%=sRoleNodes[i][5]%></td>
                        <td><%=sRoleNodes[i][6]%></td>
                        <td><%=sRoleNodes[i][7]%></td>
                    </tr>
			    <%}else
                {                	
                %>
                    <tr height=1 valign=top class="RoleLeafUncheck">
                        <td align=center>
                            <INPUT ID="checkbox<%=countLeaf%>" TYPE="checkbox" NAME="<%=sRoleNodes[i][0]%>">
                        </td>
                        <td><%=sRoleNodes[i][0]%></td>
                        <td><%=sRoleNodes[i][1]%></td>
                        <td><%=sRoleNodes[i][4]%></td>
                        <td><%=sRoleNodes[i][5]%></td>
                        <td><%=sRoleNodes[i][6]%></td>
                        <td><%=sRoleNodes[i][7]%></td>
                    </tr>
                <%
                }
		    }else 
		    {
		        %>
                <tr height=1 valign=top class="RoleNode">
                    <td>
                        &nbsp;
                    </td>
                    <td><%=sRoleNodes[i][0]%></td>
                    <td><%=sRoleNodes[i][1]%></td>
                    <td><%=sRoleNodes[i][4]%></td>
                    <td><%=sRoleNodes[i][5]%></td>
                    <td><%=sRoleNodes[i][6]%></td>
                    <td><%=sRoleNodes[i][7]%></td>
                </tr>
                <%
		    }
            %>
		    
		<%
		}
		
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
		//alert(sRightStringToUpdate);
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
