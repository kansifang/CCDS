<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui  2003.8.18
		Tester:
		Content: ��ҵծȯ������Ϣ_List
		Input Param:
			                CustomerID���ͻ����
			                CustomerRight:Ȩ�޴���----01�鿴Ȩ��02ά��Ȩ��03����ά��Ȩ
		Output param:
		                CustomerID����ǰ�ͻ�����Ŀͻ���
		              	Issuedate:��������
		              	BondType:ծȯ����
		                CustomerRight:Ȩ�޴���
		                EditRight:�༭Ȩ�޴���----01�鿴Ȩ��02�༭Ȩ
		History Log: 
		                 2003.08.20 CYHui
		                 2003.08.28 CYHui
		                 2003.09.08 CYHui 
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
	String sSql;

	//����������	
	String sUsersSelected =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UsersSelected",1));
	if(sUsersSelected==null) sUsersSelected="";
	//out.println(sUsersSelected);
	
	//���ҳ�����	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ExampleList";
	String sTempletFilter = "1=1";

	String[][] sHeaders = {
		{"CustomerID","�ͻ����"},
		{"CustomerName","�ͻ�����"},
		{"UserName","��Ա"},
		{"BelongAttribute","��Ч"},
		};
		
	sSql = "select UserID,UserName "+
		"from USER_INFO "+
		"where  '"+sUsersSelected+"@' like '%@'||UserID||'@%'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.multiSelectionEnabled=true;
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("UserID,OrgID,BelongAttribute",false);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
	//out.println(doTemp.SourceSql);
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
		{"true","","Button","ȷ�Ϸַ�","���þ�ʾ��Ϣ�ַ���ѡ�е���Ա","confirmDistribution()",sResourcesPath},
		{"true","","Button","���б���ȥ��","����ѡ���û��б���ȥ��","removeUsers()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------

	function removeUsers(){
		var sUsers = getUnselectedItemValueArray(0,"UserID");
		var sUserString="";
		for(i=0;i<sUsers.length;i++){
			//alert(sUsers[i]);
			sUserString += "@" + sUsers[i];
		}
		parent.saveParaToComp("UsersSelected="+sUserString,"reloadLeftAndRight()");
	}
	function confirmDistribution(){
		sRequirement = PopPage("/CreditManage/CreditAlarm/GetRequirementDialog.jsp","","dialogWidth:400px;dialogHeight:300px");
		if(typeof(sRequirement)=="undefined" || sRequirement=="" || sRequirement=="_CANCEL_") return;
		sReturn = PopPage("/CreditManage/CreditAlarm/ConfirmAlertDistributeAction.jsp?UserSelected=<%=sUsersSelected%>&Requirement="+sRequirement,"","dialogWidth:400px;dialogHeight:300px");
		if(typeof(sReturn)=="undefined"||sReturn=="failed") return;
		if(sReturn=="succeeded") self.close();
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	function getUnselectedItemValueArray(iDW,sColumnID){
		var b = getRowCount(iDW);
		var countSelected = 0;
		var sMemberIDTemp = "";
		var sSelected = new Array(1000);
		for(var iMSR = 0 ; iMSR < b ; iMSR++)
		{
			var a = getItemValue(iDW,iMSR,"MultiSelectionFlag");
			if(a != "��"){
				sSelected[countSelected] = getItemValue(iDW,iMSR,sColumnID);
				countSelected++;
			}
		}
		var sReturn = new Array(countSelected);
		for(var iReturnMSR = 0;iReturnMSR < countSelected; iReturnMSR++){
			sReturn[iReturnMSR] = sSelected[iReturnMSR];
		}
		return sReturn;
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
