<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zrli 20100118
		Tester:
		Describe: ����ҵ�����
		Input Param:
		Output Param:
			

		HistoryLog:
			DATE	CHANGER		CONTENT	
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Column1"));
	String[][] sListSumHeaders = (String [][])CurComp.compParentComponent.getAttribute("ListSumHeaders");
	String sListSumSql = CurComp.compParentComponent.getParameter("ListSumSql");
	//out.println("sListSumHeaders="+sListSumHeaders);
	//out.println("sListSumSql="+sListSumSql);
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = sListSumHeaders;

	String sSql =   sListSumSql;

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("0",false);
	//doTemp.setUpdateable("",false);
	doTemp.setAlign("Sum16,Sum15,Sum14,Sum13,Sum12,Sum11,Sum10,Sum9,Sum8,Sum7,Sum6,Sum5,Sum4,Sum3,Sum2,Sum1,BusinessSum,BalanceSum,InterestBalance1,InterestBalance2,Balance,BailSum,InvestSum,InvestRatio","3");
	doTemp.setAlign("BusinessCurrency","2");
	doTemp.setCheckFormat("Sum16,Sum15,Sum14,Sum13,Sum12,Sum11,Sum10,Sum9,Sum8,Sum7,Sum6,Sum5,Sum4,Sum3,Sum2,Sum1,GuarantyValue,BusinessSum,BalanceSum,InterestBalance1,InterestBalance2,Balance,BailSum,InvestSum,InvestRatio","2");
	doTemp.setDDDWCode("BusinessCurrency","Currency");
	doTemp.setDDDWCode("Currency","Currency");	
	doTemp.setVisible("FundSource,Currency",false);
	//����html��ʽ
	//doTemp.setHTMLStyle("Currency"," style={width:80px} ");
	
   //���ɹ�����
	doTemp.setColumnAttribute("BusinessTypeName,Currency","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10);
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
