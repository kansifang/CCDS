<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --xhyong 2009/08/13
		Tester:
		Describe: --��Ҫ������ҵ�б�;
		Input Param:
			CustomerID��--��ǰ�ͻ����
		Output Param:
			CustomerID��--��ǰ�ͻ����
			RelativeID��--�����ͻ���֯��������
			Relationship��--������ϵ      
			EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��      
		HistoryLog:
					
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ҫ������ҵ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
     String sSql = "";//--���sql���
	//���ҳ�����

	//�������������ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = { 
							{"CustomerName","��ҵ����"},
							{"InvestmentProp","�عɱ���(%)"},
							{"InvestmentSum","ע���ʱ�"},
							{"InvestDate","Ͷ��ʱ��"},
							{"OrgName","�������"},						
							{"UserName","������"}
						  };

	      sSql =	" select CustomerID,RelativeID,CustomerName,InvestmentProp,RelationShip, " +
					" InvestmentSum,InputOrgId, "+
					" getOrgName(InputOrgId) as OrgName,InputUserId,getUserName(InputUserId) as UserName " +
					" from CUSTOMER_RELATIVE " +
					" where CustomerID = '"+sCustomerID+"' "+
					" and RelationShip like '56%' "+
					" and length(RelationShip)>2 ";


	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//�����޸ĵı�
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
    //��������ֵ
	doTemp.setKey("CustomerID,RelativeID,CustomerName,RelationShip",true);
	//���ò��ɼ�
	doTemp.setVisible("CustomerID,RelativeID,RelationShip,InputUserId,InputOrgId",false);
	//���ò����޸���
	doTemp.setUpdateable("UserName,OrgName",false);
    //����������
	doTemp.setType("InvestmentProp,InvestmentSum","Number");
	//�����еĿ��
	doTemp.setHTMLStyle("CurrencyTypeName,InvestmentProp"," style={width:80px} ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	//����setEvent
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

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
			{"true","","Button","����","����������ҵ","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴������ҵ","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��������ҵ","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntUnderlingInfo.jsp?EditRight=02","_self","");
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
		}else if(sUserID == '<%=CurUser.UserID%>')
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
		sRelationShip = getItemValue(0,getRow(),"RelationShip");//--�ͻ�����
		sRelativeID   = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/EntUnderlingInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight="+sEditRight, "_self","");
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
