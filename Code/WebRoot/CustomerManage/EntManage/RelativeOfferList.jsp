<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: �ʽ������Ϊ���пͻ��ṩ��������б�;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			ObjectType: �������͡�
			ObjectNo: �����š�
			BackType: ���ط�ʽ����(Blank)

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ʽ������Ϊ���пͻ��ṩ��������б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"GuarantorName","�ʽ�������ͻ�����"},
							{"CustomerName","������������"},
							{"ContractNo","������ͬ���"},
							{"GuarantyTypeName","��������"},
							{"Currency","����"},
							{"GuarantyValue","�����ܽ��"},
							{"BeginDate","��ʼ����"},
							{"EndDate","��������"},
							{"InputOrgName","�������"},
						  };
	//ȡ���ʽ�������ͻ�����CustomerID�б�
	//select RelativeID from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and (RelationShip like '52%' or RelationShip like '02%')
	//������ͬ״̬�������� ContractStatus = '010' 
	String sSql =   " select SerialNo,"+
					" CustomerID,GuarantorName,getCustomerName(CustomerID) as CustomerName,"+
					" ContractNo,"+
					" GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName,"+
					" GuarantyCurrency,getItemName('Currency',GuarantyCurrency) as Currency,"+
					" GuarantyValue,"+
					" BeginDate,EndDate,"+
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName"+
					" from GUARANTY_CONTRACT"+
					" where GuarantorID in (select RelativeID from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and (RelationShip like '52%' or RelationShip like '02%'))"+
					" and ContractStatus = '020'";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,CustomerID,GuarantyType,GuarantyCurrency,InputOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setAlign("GuarantyTypeName,Currency","2");
	doTemp.setCheckFormat("GuarantyValue","2");
	//����html��ʽ
	doTemp.setHTMLStyle("GuarantyTypeName,Currency,BeginDate,EndDate"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName,GuarantorName"," style={width:180px} ");
	doTemp.setCheckFormat("BeginDate,EndDate","3");
    doTemp.setHTMLStyle("InputOrgName","style={width:200px}"); 
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
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
		{"true","","Button","����","�鿴Ϊ���пͻ��ṩ�����������","viewAndEdit()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			openObject("GuarantyContract",sSerialNo,"002");
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
