<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009-08-01
		Tester:
		Describe: δ��������ҵ������б�;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			

		HistoryLog:
			DATE	CHANGER		CONTENT	
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ��������ҵ������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"Currency","����"},
							{"BusinessSumSum","���"},
							{"BalanceSum","���"},
							{"iCount","����"}
						  };

	String sSql =   " select BusinessType,BusinessCurrency,"+
					" getBusinessName(BusinessType) as BusinessTypeName,"+
					" getItemName('Currency',BusinessCurrency) as Currency,"+
					" SUM(BusinessSum) as BusinessSumSum,SUM(Balance) as BalanceSum, "+
					" count(SerialNo) as iCount "+
					" from BUSINESS_CONTRACT"+
					" where CustomerID='"+sCustomerID+"' "+					
					" and (FinishDate = '' or FinishDate is null) "+
					" and (BusinessType like '1%' "+
					" or BusinessType like '2%' ) "+
					" group by BusinessType,BusinessCurrency ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("BusinessType,BusinessCurrency",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSumSum,iCount,BalanceSum","3");
	doTemp.setAlign("Currency,BusinessTypeName","2");
	doTemp.setCheckFormat("BusinessSumSum,BalanceSum","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,iCount"," style={width:80px} ");
	
   //���ɹ�����
	doTemp.setColumnAttribute("BusinessTypeName,Currency","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
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
    };
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

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
	hideFilterArea();//Ĭ�Ϲرղ�ѯ���� add by zrli
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
