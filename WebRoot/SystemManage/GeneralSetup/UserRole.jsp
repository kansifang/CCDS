<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: bliu 2004-12-18
		Tester:
		Describe: �û���ɫ1
		Input Param:
			BelongOrg��������
			UserID:	   �û���
		Output Param:
			
			
		HistoryLog:
		jytian 2005/01/03
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�û���ɫ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������		
	String sSql = "";

	//���ҳ�����
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	if(sUserID == null) sUserID = "";
	//����������
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = 	{
								{"UserID","��Ա���"},
								{"UserName","��Ա����"},
                                {"RoleName","��ɫ����"},
    	                        {"Grantor","�����˱��"},
    	                        {"GrantorName","����������"},
    							{"Status","״̬"},
    	    					{"BeginTime","��ʼ����"}
							};
   
	sSql = 	" select UserID,getUserName(UserID) as UserName,getRoleName(RoleID) as RoleName, "+
			" Grantor,getUserName(Grantor) as GrantorName,getItemName('RoleStatus',Status) as Status, "+
			" BeginTime,RoleID " +
	       	" from USER_ROLE " +
	       	" where UserID ='"+sUserID+"' "+
	       	" order by RoleID ";

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "USER_ROLE";
	
	doTemp.setKey("UserID,RoleID,Grantor,BeginTime",true);	 
	doTemp.setRequired("RoleID,BeginTime",true);
	doTemp.setAlign("BeginTime","2");	
	doTemp.setHTMLStyle("UserID,UserName,Grantor,GrantorName,Status,BeginTime"," style={width:80px} ");
	doTemp.setVisible("RoleID",false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = 	{
				{"true","","Button","����","������ɫ","newRecord()",sResourcesPath},
				{"true","","Button","����","�鿴��ɫ","viewAndEdit()",sResourcesPath},
				{"true","","Button","ɾ��","ɾ���ý�ɫ","deleteRecord()",sResourcesPath},
				{"true","","Button","����","�����û��б�","goBack()",sResourcesPath}
				};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	function newRecord()
	{
		OpenPage("/SystemManage/GeneralSetup/UserRoleInfo.jsp?UserID=<%=sUserID%>","_self","");
    }   
    
    /*~[Describe=�ӵ�ǰ������ɾ������Ա;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
    {   
		sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0)
		{
			alert(getHtmlMessage('1'));
            return;
		}

        if(confirm("ȷ��ɾ���ý�ɫ��")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sUserID = getItemValue(0,getRow(),"UserID");
		sUserName = getItemValue(0,getRow(),"UserName");
		sRoleID = getItemValue(0,getRow(),"RoleID");
		sGrantor= getItemValue(0,getRow(),"Grantor");
		sBeginTime = getItemValue(0,getRow(),"BeginTime");
		
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/SystemManage/GeneralSetup/UserRoleInfo.jsp?UserID="+sUserID+"&RoleID="+sRoleID+"&Grantor="+sGrantor+"&BeginTime="+sBeginTime+"&UserName="+sUserName,"_self","");
		}
	}
	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
