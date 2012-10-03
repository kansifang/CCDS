<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: fxie 2005-2-18 
		Tester:
		Describe: �û���ɫ��Ϣ
		Input Param:
			BelongOrg��������
			UserID:	   �û���
		Output Param:
			CustomerID����ǰ�ͻ����

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�û����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����	
	String sUserID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sRoleID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RoleID"));
	String sGrantor   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grantor"));
	String sBeginTime = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BeginTime"));

	if(sRoleID == null ) sRoleID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%       
    String sTempletNo = "UserRoleInfo";
	String sTempletFilter = "1=1";
	String sWhere = "";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable="USER_ROLE";
	//���ùؼ���
	doTemp.setKey("UserID,RoleID",true);
	//ȡ����Ա���ڻ����ļ���
	String sOrgLevel = Sqlca.getString("select OrgLevel from ORG_INFO where OrgID ='"+CurOrg.OrgID+"' ");
	if(sOrgLevel.equals("0")) //������Ա���ý�ɫ
	   sWhere = " where length(roleid)>1 ";	
	else if(sOrgLevel.equals("3")) //������Ա���ý�ɫ
	   sWhere = " where roleid not like '0%' and length(roleid)>1  ";	
	else if(sOrgLevel.equals("6")) //֧����Ա���ý�ɫ
	    sWhere = " where (roleid like '4%' or roleid like '8%')  and length(roleid)>1 ";
    
    //����ʱ���ų��û��Ѵ��ڵĽ�ɫ
    if(sRoleID.equals(""))
		sWhere += " and roleid not in (select roleid from user_role where userid='"+sUserID+"')";

	//������������Դ
	doTemp.setDDDWSql("RoleID","select RoleID,RoleID||' '||RoleName from Role_Info "+sWhere);	
   
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly="0";
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID+","+sRoleID+","+sGrantor+","+sBeginTime);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = 
		{
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/GeneralSetup/UserRole.jsp?UserID=<%=sUserID%>","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%> <%=StringFunction.getNow()%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0"); //������¼
			setItemValue(0,0,"UserID","<%=sUserID%>");
			setItemValue(0,0,"BeginTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Status","1");		
			setItemValue(0,0,"Grantor","<%=CurUser.UserID%>");
			setItemValue(0,0,"GrantorName","<%=CurUser.UserName%>");	
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%> <%=StringFunction.getNow()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%> <%=StringFunction.getNow()%>");
			
			bIsInsert = true;
		}		
    }
    
    /*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser()
	{			
		setObjectValue("SelectAllUser","","@Grantor@0@GrantorName@1",0,0,"");
	}
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
