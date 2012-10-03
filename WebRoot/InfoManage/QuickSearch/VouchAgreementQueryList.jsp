<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:xhyong 2012-08-01
		Tester:
		Content:  ������������Э���ѯ
		Input Param:
			
		Output param:
		History Log: 
			 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������������Э���ѯ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	String sWhere = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//��ʾ����				
	String[][] sHeaders = {		
							{"SerialNo","����Э����ˮ��"},              	
							{"CustomerName","������������"},             
							{"VouchTotalSum","�����ܶ��"},           	
							{"VouchAgreementNo","����Э���"}, 
							{"PutOutDate","������ʼ��"},            	
							{"Maturity","����������"},
							{"VouchOrgType","������������"},
							{"VouchOrgTypeName","������������"},
							{"ManageCustomerOrgName","�ܻ�����"},
							{"TermMonth","�������ޣ��£�"},
							{"FreezeFlag","���״̬"},  
						 };
	

	sSql =  " select SerialNo,CustomerName,VouchTotalSum,VouchAgreementNo,"+
			" PutOutDate,Maturity,VouchOrgType,"+
			" getItemName('VouchOrgType',VouchOrgType) as VouchOrgTypeName ,"+
			" (select getOrgName(OrgID) as ManageCustomerOrgName"+
			" from CUSTOMER_BELONG   "+
			" where CustomerID=EA.CustomerID "+
			" and  BelongAttribute1='1' fetch first 1 rows only),"+
			"TermMonth,getItemName('FreezeFlag',FreezeFlag) as FreezeFlag "+
			" from Ent_Agreement EA "+
			" where AgreementType = 'VouchAgreement' "+
			" and FreezeFlag <> '' and FreezeFlag is not null  ";
			
	ASDataObject doTemp = new ASDataObject(sSql);
	//��ӻ�������
	sWhere += OrgCondition.getOrgCondition("InputOrgID",CurOrg.OrgID,Sqlca); 
	doTemp.WhereClause+=sWhere;
	
	doTemp.UpdateTable="Ent_Agreement";
	doTemp.setKey("SerialNo",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("Currency","2");
	   
	doTemp.setType("VouchTotalSum","Number");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency"," style={width:80px} ");
	doTemp.setVisible("VouchOrgType",false);
	doTemp.setDDDWCode("VouchOrgType","VouchOrgType");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	//����Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.setColumnAttribute("VouchTotalSum","IsFilter","1");
	doTemp.setColumnAttribute("PutOutDate","IsFilter","1");
	doTemp.setColumnAttribute("Maturity","IsFilter","1");
	doTemp.setColumnAttribute("VouchOrgType","IsFilter","1");
	doTemp.setColumnAttribute("ManageCustomerOrgName","IsFilter","1");	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","Э������ҵ��","Э������ҵ��","AgreementBusiness()",sResourcesPath},
		};
		
	%> 
	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=Э������ҵ��;InputParam=��;OutPutParam=��;]~*/
	function AgreementBusiness()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sAgreementType   = "VouchAggreement";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("AgreementBusiness","/CreditManage/CreditLine/AgreementBusiness.jsp","SerialNo="+sSerialNo+"&AgreementType="+sAgreementType,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("VouchAgreementInfo","/CreditManage/CreditLine/VouchAgreementInfo.jsp","SerialNo="+sSerialNo+"&ReadOnly=true","_blank",OpenStyle);
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>