<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-11-29
		Tester:
		Describe: --�����ȨͶ����Ϣ�б�;
		Input Param:
			CustomerID��--��ǰ�ͻ����
		Output Param:
			CustomerID��--��ǰ�ͻ����
			RelativeID��--�����ͻ���֯��������
			Relationship��--������ϵ         
			EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��   
		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	��������ʽ		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ȨͶ����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
     String sSql="";//--���sql���
	//���ҳ�����

	//����������
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	{"Customername","Ͷ�ʿͻ�����"},
							{"RelationShipName","���ʷ�ʽ"},
							{"InvestmentProp","��Ȩ����(%)"},
							{"CurrencyType","���ʱ���"},
							{"InvestmentSum","ʵ�ʳ��ʽ��"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"}
						  };

	       sSql = " select CustomerID,RelativeID,CustomerName,RelationShip,getItemName('RelationShip',RelationShip) as RelationShipName,"+
				  " InvestmentProp,getItemName('Currency',CurrencyType) as CurrencyType,InvestmentSum,InputOrgId, " +
				  " getOrgName(InputOrgId) as OrgName,InputUserId,getUserName(InputUserId) as UserName " +
				  " from CUSTOMER_RELATIVE " +
				  " where CustomerID='"+sCustomerID+"'"+
				  " and RelationShip like '02%' "+
				  " and length(RelationShip)>2 ";

   //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//�����޸ĵı�
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	//�������������ں����ɾ��
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,RelativeID,InputUserId,RelationShip,InputDate,UpdataDate,InputOrgId,InvestmentProp,InvestmentSum",false);
	//�������з�ʽ
	doTemp.setAlign("InvestmentSum,InvestmentProp","3");
	//��ʽ����
	doTemp.setCheckFormat("InvestmentSum,","2");
	doTemp.setType("InvestmentSum,InvestmentProp","number");
	//����html��ʽ
	doTemp.setHTMLStyle("OrgName" ,"style={width:200px} ");	
	doTemp.setHTMLStyle("Customername"," style={width:200px} ");
	doTemp.setAlign("Customername,RelationShipName,UserName","2");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//�����¼��������¼��Ĵ������ں�̨�����д���
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
		{"true","","Button","����","������ȨͶ����Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴��ȨͶ����Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ȨͶ����Ϣ","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/IndManage/IndInvestInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"InputUserId");//--�û�����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--�ͻ�����
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
			if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
			{
				as_del('myiframe0');
				as_save('myiframe0');  //�������ɾ������Ҫ���ô����
			}
		}else alert(getHtmlMessage('3'));
	}


	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{		
		sUserID=getItemValue(0,getRow(),"InputUserId");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01'; 
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");//--�ͻ�����
		sRelationShip = getItemValue(0,getRow(),"RelationShip");//--������ϵ
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/CustomerManage/IndManage/IndInvestInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight="+sEditRight, "_self","");
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
