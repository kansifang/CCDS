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
	String sAlertID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertID",10));
	if(sAlertID==null) sAlertID="";
	//out.println(sUsersSelected);
	
	//���ҳ�����	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ExampleList";
	String sTempletFilter = "1=1";

	//String[][] sHeaders = {
	//	{"CustomerID","�ͻ����"},
	//	{"CustomerName","�ͻ�����"},
	//	{"UserID","��Ա"},
	//	{"UserName","��Ա"},
	//	{"BelongAttribute","��Ч"},
	//	};
	//	
	//sSql = "select GetUserName(CB.UserID) as UserName,CI.CustomerID,CI.CustomerName,CB.UserID,CB.OrgID,CB.BelongAttribute "+
	//	"from CUSTOMER_INFO CI,CUSTOMER_BELONG CB "+
	//	"where CI.CustomerID=CB.CustomerID and '"+sUsersSelected+"' not like '%'||CB.UserID||'%' and CB.UserID not in (select UserID from ALERT_HANDLE where SerialNo='"+sAlertID+"')";
	
	String sHeaders[][] = {	{"UserID","�û���"},
							{"UserName","�û���"},
							{"BelongOrg","����������"},
							{"BelongOrgName","����������"}
						  };

	sSql =	" select UserID,UserName,getOrgName(BelongOrg) as BelongOrgName,BelongOrg " +
					" from USER_INFO " +
					" where 1 = 1 and (BelongOrg != '' or BelongOrg is not null) ";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.multiSelectionEnabled=true;
	doTemp.setHeader(sHeaders);
	//doTemp.setVisible("",false);
	//doTemp.setDDDWCode("BelongAttribute","BelongAttribute");
	//���ɲ�ѯ
	doTemp.setFilter(Sqlca,"1","UserID","");
	doTemp.setFilter(Sqlca,"2","UserName","");
	doTemp.setFilter(Sqlca,"3","BelongOrg","");
	doTemp.setFilter(Sqlca,"4","BelongOrgName","");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
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
		{"true","","Button","�����б�","��ѡ�е���Ա����ַ�Ŀ���û��б�","distribute()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	
	function distribute(){
		var sUsers = getItemValueArray(0,"UserID");
		var sUserString="";
		for(i=0;i<sUsers.length;i++){
			sUserString += "@" + sUsers[i];
		}
		if (typeof(sUserString)=="")
		{
			alert("��˫����ѡ����ѡ��һ�����ϼ�¼��");
			return;
		}

		parent.saveParaToComp("UsersSelected=<%=DataConvert.toString(sUsersSelected)%>"+sUserString,"reloadLeftAndRight()");
	}
    function filterAction(sObjectID,sFilterID,sObjectID2)
	{
		oMyObj = document.all(sObjectID);
		oMyObj2 = document.all(sObjectID2);
		if(sFilterID=="1")
		{
			sReturn = setObjectInfo("User","@UserID@0@UserName@1",0,0);
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_")
			{
				return;
			}else if(sReturn=="_CLEAR_")
			{
				oMyObj.value="";
			}else
			{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				oMyObj2.value=sReturns[1];
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
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
