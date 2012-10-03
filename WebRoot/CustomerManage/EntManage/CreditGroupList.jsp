<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/10
		Tester:
		Describe: ���ù�ͬ���Ա��Ϣ�б�;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			CustomerID����ǰ�ͻ����
			RelativeID�������ͻ����
			Relationship��������ϵ

		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ù�ͬ���Ա��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"RelativeID","���ù�ͬ���Ա���"},
							{"CustomerName","��Ա����"},
							{"CertID","֤������"},
							{"CGALevelName","���ù�ͬ������������"},
							{"AssureGroupName","�ó�Ա��������С��"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"},	
							{"InputDate","�Ǽ�����"}
						  };

	String sSql =   " select CustomerID,RelativeID,CustomerName,CertID,"+
					" RelationShip,getItemName('AssessLevel',CGALevel) as CGALevelName,"+
					" getCustomerName(AssureGroupID) as AssureGroupName,"+
					" InputOrgId,getOrgName(InputOrgId) as OrgName,"+
					" InputUserId,getUserName(InputUserId) as UserName," +
					" InputDate" +
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"'"+
					" and RelationShip like '0701%'";

   //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	//�������������ں����ɾ��
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,RelationShip,InputUserId,InputOrgId",false);
	//��ʽ����
	doTemp.setCheckFormat("InputDate","3");
	doTemp.appendHTMLStyle("UserName,CGALevelName","style={width:80px}");		
	doTemp.appendHTMLStyle("OrgName"," style={width:200px} ");	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

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
		{"true","","Button","����","�������ù�ͬ���Ա��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����(������С��)","������С���������ù�ͬ���Ա��Ϣ","newGroupRecord()",sResourcesPath},
		{"true","","Button","����","�鿴����С���Ա��Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ������С���Ա��Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","�ͻ�����","�鿴����С���Ա�ͻ���Ϣ����","viewCustomer()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/CreditGroupInfo.jsp","_self","");
	}
	
	/*~[Describe=������¼(������С��);InputParam=��;OutPutParam=��;]~*/
	function newGroupRecord()
	{
		sParaString = "BelongOrg,<%=CurOrg.OrgID%>";
		sCustomerID = "<%=sCustomerID%>";
		sReturnValue=setObjectValue("SelectAssureGroup1",sParaString,"",0,0,"");
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
		{
				sReturnValue = sReturnValue.split("@");
				sGroupSerialNo=sReturnValue[0];
				sReturnValue = RunMethod("CustomerManage","BatchAddCreditGroup",sGroupSerialNo+","+sCustomerID+",<%=CurUser.UserID%>,<%=CurOrg.OrgID%>");
		}
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
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
		}else
		{
			OpenPage("/CustomerManage/EntManage/CreditGroupInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip, "_self","");
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomer()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			openObject("Customer",sRelativeID,"001");
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
