<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=注释区;]~*/
%>
<%
	/* 
  author:  --fbkang 2005-7-25 
  Tester:
  Content:  校验是否可以删除此项目
  Input Param:
	--ObjectType  ：对象类型
	--ObjectNo    : 对象编号
            --ProjectNo   ：项目编号
  Output param:
 
  History Log:     

               
 */
%>
<%
	/*~END~*/
%>

<%
	//定义变量
    String sRight = "";
	/*获取当前用户的权限
	    影像权限分为用户级和角色级，用户级优先级较高，当该用户在用户级中存在影像权限时不考虑角色级的权限
	*/
	String sSql2 = "Select ImageRight from User_Info where UserID = '"+CurUser.UserID+"' ";
	String sUserRight = Sqlca.getString(sSql2);
	sRight  = sUserRight;
	if(sUserRight == null || sUserRight.length()==0){
	String sSql3 = "Select ri.ImageRight from Role_Info ri,User_Role ur,User_Info ui where ri.RoleID like 'I%' and ur.UserID = ui.UserID and ri.RoleID = ur.RoleID and ui.UserID = '"+CurUser.UserID+"' ";
	String sRoleRight = Sqlca.getString(sSql3);
	sRight = sRoleRight;
	}
%>

<script language=javascript>
	self.returnValue="<%=sRight%>";
	self.close();
		
</script>


<%@ include file="/IncludeEnd.jsp"%>