<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: �ʽ������ҵ����������б�;
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
	String PG_TITLE = "�ʽ������ҵ����������б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"CustomerName","�ʽ�������ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurTypeName","��������"},
				            {"SerialNo","������"},
				            {"PhaseName","��ǰ�����׶�"},
							{"Currency","����"},
				            {"BusinessSum","���"},
				            {"OccurDate","��������"},
							{"VouchTypeName","������ʽ"},
							{"OperateOrgName","�������"},
						  };

	//ȡ���ʽ�������ͻ�����CustomerID�б�
	//select RelativeID from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and (RelationShip like '52%' or RelationShip like '02%')
	String sSql =   " select"+
					" CustomerID,getCustomerName(CustomerID) as CustomerName,"+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" SerialNo,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,OccurDate,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_APPLY"+
					" where CustomerID in (select RelativeID from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and (RelationShip like '52%' or RelationShip like '02%'))";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency,VouchTypeName","2");
	doTemp.setCheckFormat("BusinessSum","2");
	
	//����html��ʽ
	doTemp.setHTMLStyle("OccurTypeName,Currency,OccurDate"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:180px} ");
	doTemp.setCheckFormat("OccurDate","3");
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
		{"true","","Button","����","�鿴ҵ�������������","viewAndEdit()",sResourcesPath},
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
			sSerialNo   = getItemValue(0,getRow(),"SerialNo");
			
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			{
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			}else
			{
				openObject("CreditApply",sSerialNo,"001");
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
