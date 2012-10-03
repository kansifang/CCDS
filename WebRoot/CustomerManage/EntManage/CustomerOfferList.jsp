<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: Ϊ���пͻ��ṩ��������б�;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			ObjectType: �������͡�
			ObjectNo: �����š�
			BackType: ���ط�ʽ����(Blank)

		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	���ӹ�����			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ϊ���пͻ��ṩ��������б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"GuarantorName","������������"},
							{"CustomerName","������������"},
							{"SerialNo","������ͬ��ˮ��"},
							{"GuarantyTypeName","��������"},
							{"Currency","����"},
							{"GuarantyValue","������ͬ���"},
							{"Balance","������ͬ���"},
							{"BeginDate","��ʼ����"},
							{"EndDate","��������"},
							{"InputOrgName","�������"},	
						  };
	//������ͬ״̬�������� ContractStatus = '010' 
	String sSql =   " select GC.SerialNo,"+
					" getCustomerName(GC.CustomerID) as CustomerName,"+
					" GC.GuarantyType,getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName,"+
					" GC.GuarantyCurrency,getItemName('Currency',GC.GuarantyCurrency) as Currency,"+
					" GC.GuarantyValue,"+
					" BC.Balance,"+
					" GC.BeginDate,GC.EndDate,"+
					" GC.InputOrgID,getOrgName(GC.InputOrgID) as InputOrgName"+
					" from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR"+
					" where CR.ObjectNo = GC.serialNo"+
					" and CR.ObjectType = 'GuarantyContract'"+
					" and BC.SerialNo=CR.SerialNo"+
					" and GC.GuarantorID = '"+sCustomerID+"'"+
					" and ContractStatus = '020'";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("GuarantyType,GuarantyCurrency,InputOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setAlign("GuarantyTypeName,Currency,EndDate,BeginDate,CustomerName","2");
	doTemp.setCheckFormat("GuarantyValue","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,BeginDate,EndDate"," style={width:80px} ");
  	doTemp.setHTMLStyle("InputOrgName" ,"style={width:200px} ");
  	//���ɹ�����
	doTemp.setColumnAttribute("CustomerName,SerialNo","IsFilter","1");
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
		{"true","","Button","����","�鿴Ϊ���пͻ��ṩ�����������","viewAndEdit()",sResourcesPath},
		{"true","","Button","��Ϣ����","��Ϣ����","infoGather()",sResourcesPath}
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
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function infoGather()
	{
		popComp("CustomerOfferGather","/CustomerManage/EntManage/CustomerOfferGather.jsp","CustomerID=<%=sCustomerID%>","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
