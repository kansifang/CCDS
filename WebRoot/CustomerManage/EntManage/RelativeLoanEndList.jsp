<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: �ʽ�������ѽ�������ҵ���б�;
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
	String PG_TITLE = "�ʽ�������ѽ�������ҵ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"SerialNo","��ͬ��ˮ��"},
							{"CustomerName","�ʽ�������ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"ArtificialNo","�ı���ͬ���"},
							{"OccurTypeName","��������"},
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"FinishDate","��������"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"OperateOrgName","�������"},
						  };

	//ȡ���ʽ�������ͻ�����CustomerID�б�
	//select RelativeID from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and (RelationShip like '52%' or RelationShip like '02%')
	String sSql =   " select SerialNo,"+
					" CustomerID,getCustomerName(CustomerID) as CustomerName,"+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
					" ArtificialNo,"+
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,"+
					" FinishDate,PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where CustomerID in (select RelativeID from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and (RelationShip like '52%' or RelationShip like '02%'))"+
					" and FinishDate is not null "+
					" and (BusinessType like '1%' or BusinessType like '2%' or BusinessType like '3%' or BusinessType is null) ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,BusinessType,OccurType,BusinessCurrency,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency","2");
	doTemp.setCheckFormat("BusinessSum","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,FinishDate,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:180px} ");
	doTemp.setHTMLStyle("CustomerName","style={width:180px}");
	doTemp.setCheckFormat("Maturity,PutOutDate,FinishDate","3");
    doTemp.setHTMLStyle("OperateOrgName","style={width:200px}"); 
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
		{"true","","Button","����","�鿴�ѽ�������ҵ������","viewAndEdit()",sResourcesPath},
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
			sObjectType = "AfterLoan";
			OpenComp("CreditTab","/CreditManage/CreditApply/ObjectTab.jsp","ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"_blank","OpenStyle");
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