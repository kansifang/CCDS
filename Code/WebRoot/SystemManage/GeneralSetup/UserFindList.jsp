<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2005-03-07
		Tester:
		Describe: ��ѯ��Ա���
		Input Param:
			
		Output Param:
			
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ա���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����
	
	//����������


%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = 	{
								{"UserID","��Ա���"},
								{"UserName","��Ա����"},
								{"LoginID","��¼��"},
								{"BelongOrgName","��������"},
                                {"Status","��ǰ״̬"}
							};

	String sSql =  "select UserID,UserName,LoginID,BelongOrg,getOrgName(BelongOrg) as BelongOrgName,Status" +
				   " from USER_INFO" +
				   " where (BelongOrg in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') or BelongOrg is null or BelongOrg='')";

	//out.println(sSql);
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
    doTemp.setVisible("BelongOrg,LoginID",false);
    doTemp.setHTMLStyle("UserID"," style={width:100px} ");
	doTemp.setHTMLStyle("UserName"," style={width:150px} ");
	doTemp.setHTMLStyle("LoginID"," style={width:100px} ");
	doTemp.setHTMLStyle("BelongOrgName"," style={width:200px} ");
	doTemp.setHTMLStyle("Status"," style={width:60px} ");
	//��ѯ
	doTemp.setColumnAttribute("UserID,UserName,BelongOrgName,Status","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
    if(!doTemp.haveReceivedFilterCriteria())
	{
	 doTemp.WhereClause+=" and 1=2 ";
	}
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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

	String sButtons[][] = {
							{"true","","Button","����","�鿴��Ա���","viewAndEdit()",sResourcesPath},
							{"true","","Button","��ɫ","�鿴�����޸���Ա��ɫ","my_role()",sResourcesPath},
							{"true","","Button","�������½�ɫ","�������½�ɫ","my_Addrole()",sResourcesPath},
							{"true","","Button","��ʼ����","��ʼ�����û�����","ClearPassword()",sResourcesPath},
							{"true","","Button","����","����","back()",sResourcesPath}
						};

	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{

		sUserID   = getItemValue(0,getRow(),"UserID");
		
		if (typeof(sUserID)=="undefined" || sUserID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/SystemManage/GeneralSetup/UserInfo.jsp?Back=find&UserID="+sUserID,"_self","");
		}
	}
    /*~[Describe=�鿴�����޸���Ա��ɫ;InputParam=��;OutPutParam=��;]~*/
	function my_role()
	{
    	sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0)
    	{ 
		    alert("��ѡ��һ����¼��");
    	}
    	else
    	{
        	popComp("UserRole","/SystemManage/GeneralSetup/UserRole.jsp","UserID="+sUserID,"","");      	
    	}    
	}
	function my_Addrole()
	{
	    sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0)
    	{ 
		    alert("��ѡ��һ����¼��");
    	}
    	else
    	{
        	PopPage("/SystemManage/GeneralSetup/AddUserRole.jsp?UserID="+sUserID,"","dialogWidth=36;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
    	}
	}
	//��ʼ���û�����Ϊ1
	function ClearPassword()
	{
        sUserID = getItemValue(0,getRow(),"UserID");
        if (typeof(sUserID)=="undefined" || sUserID.length==0)
		{
		    alert("��ѡ��һ���û���");
		}else if(confirm("���û����뽫����ʼ����ȷ����")) 
		{
		    PopPage("/SystemManage/GeneralSetup/ClearPasswordAction.jsp?UserID="+sUserID,"","dialogWidth:320px;dialogHeight:270px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
		    alert("��ʼ���û�����ɹ���");
		    reloadSelf();
		}
	}
    function back()
    {
        OpenPage("/SystemManage/GeneralSetup/UserList.jsp","_self","");
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
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
