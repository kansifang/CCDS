<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lpzhang 2010-6-23
		Tester:
		Content: Э������ҵ���б�
		Input Param:
		Output param:
		History Log:   

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ҵ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("SerialNo"));
	String sAgreementType = DataConvert.toRealString(iPostChange,CurComp.getParameter("AgreementType"));
	if(sSerialNo == null) sSerialNo= "";
	if(sAgreementType == null) sAgreementType= "";
	
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
			{"BusinessTypeName","ҵ��Ʒ��"},
			{"CustomerName","�ͻ�����"},
			{"ArtificialNo","��ͬ���"},
			{"OccurTypeName","��������"},
			{"Currency","����"},
			{"BusinessSum","��ͬ���"},
			{"RelativeSum","�ѳ��˽��"},
			{"Balance","���"},
			{"VouchTypeName","��Ҫ������ʽ"},
			{"PutOutDate","��ʼ����"},
			{"Maturity","��������"},
			{"ManageOrgName","�������"},
	};
	sSql = "select SerialNo,CustomerID,CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
		 " ArtificialNo,BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
		 " BusinessSum,Balance,OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
		 " VouchType,getItemName('VouchType',VouchType) as VouchTypeName,PutOutDate,Maturity,"+
		 " ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName "+
		 " from BUSINESS_CONTRACT "+
		 " Where 1=1 ";	
	
	if(sAgreementType.equals("BuildAgreement")){
		sSql += " and BuildAgreement ='"+sSerialNo+"'";
	}else if(sAgreementType.equals("ConstructContractNo")){
		sSql += " and ConstructContractNo ='"+sSerialNo+"'";
	}else if(sAgreementType.equals("VouchAggreement")){
		sSql += " and VouchAggreement ='"+sSerialNo+"'";
	}
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("SerialNo,CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,ManageOrgID",false);
	
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1=1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д


	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//out.println(doTemp.SourceSql); //������仰����datawindow
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
					{"true","","Button","��ͬ����","�������ҵ������","viewTab()",sResourcesPath}		
					};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	setDialogTitle("���Ŷ������ҵ���б�");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
