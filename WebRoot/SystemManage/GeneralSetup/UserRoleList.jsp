<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: �û���ɫ�б�
		Input Param:
                  
		Output param:
		                
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
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
    String sRightStringToUpdate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightStringToUpdate"));
	if (sUserID == null) sUserID = "";
    if (sRightStringToUpdate == null) sRightStringToUpdate = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
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
		<script>alert(getHtmlMessage('4'));//��Ϣ����ɹ���</script>
		<%
	}
    
    
	/**
	 * @Author:CWZhan 
	 * @Date:  2005-2-1	
	 * @Action:	 ȡ�����еĽ�ɫ�����жϸ��û��Ƿ��иý�ɫ�����жϸý�ɫ�Ƿ�ΪҶ�ӽ��
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
    
    //ʵ�����û�����
	ASUser o_User = new ASUser(sUserID,Sqlca);		
	//��ȡ��������
	String sOrgLevel = Sqlca.getString("select OrgLevel from ORG_INFO where OrgID = '"+o_User.OrgID+"'");
	if(sOrgLevel == null) sOrgLevel = "";
	
    sSql = "select RoleID,RoleName from ROLE_INFO where 1=1 ";
    if(sOrgLevel.equals("0")) //��������OrgLevel(0�����У�3�����У�6��֧�У�9������)
    	 sSql += " and (RoleID like '0%' "+	        		
        		 " or RoleID like '8%') "+
        		 " and RoleStatus = '1' ";
    if(sOrgLevel.equals("3")) //��������OrgLevel(0�����У�3�����У�6��֧�У�9������)
    	 sSql += " and (RoleID like '2%' "+	        		
        		 " or RoleID like '8%') "+
        		 " and RoleStatus = '1' ";
    if(sOrgLevel.equals("6")) //��������OrgLevel(0�����У�3�����У�6��֧�У�9������)
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
    	sRoleNodes[iRow][4]=""; //��Ȩ��
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
                sRoleNodes[i][4]=sUserRoleNodes[j][2]; //��Ȩ��
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
    <td>�û�&nbsp;&nbsp;<font color=#6666cc>(<%=sUserID%>)</font>&nbsp;&nbsp;���еĽ�ɫ
        
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
                        <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","����","����Ȩ�޶�����Ϣ","javascript:saveRightConf()",sResourcesPath)%>
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
		    <td width=10%>��ɫID</td>
		    <td width=20%>��ɫ����</td>
		    <td width=10%>��Ȩ��</td>
		    <td width=10%>״̬</td>
		    <td width=10%>��ʼ��</td>
		    <td width=10%>������</td>
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
            if (sRoleNodes[i][2].equals("TRUE"))  //�Ƿ�ΪҶ
		    {
                ++countLeaf;
                if(sRoleNodes[i][3].equals("TRUE"))  //�Ƿ��н�ɫ
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
		if(!confirm("ȷ��Ҫ����Խ�ɫ���޸���")){
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
