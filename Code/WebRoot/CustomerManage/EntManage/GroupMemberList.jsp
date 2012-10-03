<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-12-27
		Tester:
		Describe: �������ų�Ա��Ϣ�б�;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			CustomerID����ǰ�ͻ����
			RelativeID�������ͻ���֯��������
			Relationship��������ϵ
		HistoryLog:
					
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ų�Ա��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����
	//����������
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	String sHeaders[][] = {
							{"CustomerName","���ų�Ա����"},
							{"CertType","֤������"},
							{"CertID","֤������"},
							{"RelationShipName","��Ա����"},
							{"EntKeyMan","����������"},
							{"UnfinishedBusiness","�Ƿ����δ����ҵ�����������"},
							{"ManageOrgName","�ܻ�����"},
							{"ManageUserName","�ܻ��ͻ�����"}
						  };

	String sSql =   " select CustomerID,RelativeID,CustomerName, "+
					" getItemName('CertType',CertType) as CertType, "+
					" CertID,RelationShip,getItemName('RelationShip',RelationShip) as RelationShipName, "+
					" getEntKeyMan(RelativeID,'0100') as EntKeyMan, "+
					" getItemName('HaveNot',getNotEndBusiness(RelativeID)) as UnfinishedBusiness, "+
					" getManageOrgName(RelativeID) as ManageOrgName, "+
					" getManageUserName(RelativeID) as ManageUserName, " +
					" InputOrgID,InputUserID "+
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"' "+
					" and RelationShip like '04%' " ;
				// 	" and length(RelationShip)>2 ";

   	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	//�������������ں����ɾ��
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	//���ò��ɼ���
	doTemp.setVisible("RelationShip,CustomerID,RelativeID,InputOrgID,InputUserID",false);
	//��ʽ����
	doTemp.setHTMLStyle("UnfinishedBusiness"," style={width:150px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setAlign("CertType,UnfinishedBusiness","2");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	//ɾ�����������Ϣ
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.DeleteGroupInfo(#CustomerID,#RelativeID,#InputUserID)");

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

	String sButtons[][] = {		
		{"true","","Button","����","����������ҵ��Ա��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴������ҵ��Ա��Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��������ҵ��Ա��Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","�ͻ�����","�鿴������ҵ��Ա�ͻ���Ϣ����","viewCustomer()",sResourcesPath},
		{"true","","Button","���ſͻ�����","���ſͻ�����","listRelative()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/GroupMemberInfo.jsp?","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sCustomerName   = getItemValue(0,getRow(),"CustomerName");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����			
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		sRelationShip = getItemValue(0,getRow(),"RelationShip");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/GroupMemberInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip, "_self","");
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomer()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			openObject("Customer",sRelativeID,"001");
		}
	}
	
	/*~[Describe=���ſͻ�����;InputParam=��;OutPutParam=��;]~*/
	function listRelative()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
		}else 
		{					
			sSelectRelativeCustomer =PopPage("/CustomerManage/EntManage/SelectRelativeCustomer.jsp?CustomerID="+sRelativeID,"","top=40;dialogWidth=26;dialogHeight=30;resizable=yes;status:no;maximize:yes;help:no;");
			if(typeof(sSelectRelativeCustomer)!="undefined" && sSelectRelativeCustomer.length!=0 && sSelectRelativeCustomer != '_none_')
			{
				sUserID = "<%=CurUser.UserID%>" ;
			    sReturn=RunMethod("CustomerManage","AddListRelative",sSelectRelativeCustomer+","+<%=sCustomerID%>+","+sUserID);	
			    if(sReturn != "")
			    {
			      alert(sReturn);
			      reloadSelf();
			    }			
			}
		}		
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
