<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: �ʽ������δ��������ҵ���б�;
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
	String PG_TITLE = "�ʽ������δ��������ҵ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomeID"));

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","��ͬ��ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"ArtificialNo","�ı���ͬ���"},
							{"CreditAggreement","���Э����ˮ��"},
							{"OccurTypeName","��������"},
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"Balance","���"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"OperateOrgName","�������"},
						  };

	//ȡ���ʽ�������ͻ�����CustomerID�б�
	//select RelativeID from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and (RelationShip like '52%' or RelationShip like '02%')
	String sSql =  " select SerialNo,"+
					" CustomerID,getCustomerName(CustomerID) as CustomerName,"+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
					" ArtificialNo,CreditAggreement,"+
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,Balance,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where CustomerID ='"+sCustomerID+"'"+
					" and (FinishDate='' or FinishDate is null) "+
					" and (BusinessType like '1%' or BusinessType like '2%' ) ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency,VouchTypeName","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:180px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10);
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String[][] sListSumHeaders = {	{"BusinessCurrency","����"},
									{"BusinessSum","��ͬ���"},
									{"Balance","���"},
								 };
	String sListSumSql = "Select BusinessCurrency,Sum(BusinessSum) as BusinessSum,Sum(Balance) as Balance"
						+ " From BUSINESS_CONTRACT "
						+ doTemp.WhereClause
						+ " Group By BusinessCurrency";
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);
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
		{"true","","Button","����","�鿴δ��������ҵ������","viewAndEdit()",sResourcesPath},
		{"true","","Button","����","����","listSum()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
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
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			openObject("AfterLoan",sSerialNo,"001");
		}
	}
	
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	/*~[Describe=������;InputParam=��;OutPutParam=��;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
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
