<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=ע����;]~*/
%>
<%
	/* 
  author:  --fbkang 2005-7-25 
  Tester:
  Content:  У���Ƿ����ɾ������Ŀ
  Input Param:
	--ObjectType  ����������
	--ObjectNo    : ������
            --ProjectNo   ����Ŀ���
  Output param:
 
  History Log:     

               
 */
%>
<%
	/*~END~*/
%>

<%
	//�������
    String sRight = "";
	/*��ȡ��ǰ�û���Ȩ��
	    Ӱ��Ȩ�޷�Ϊ�û����ͽ�ɫ�����û������ȼ��ϸߣ������û����û����д���Ӱ��Ȩ��ʱ�����ǽ�ɫ����Ȩ��
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