<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: ��˾�ͻ����ٲ�ѯ
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ���˾�ͻ����ٲ�ѯ
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��˾�ͻ����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql;//--���sql���
	String sComponentName;//--�������
	String PG_CONTENT_TITLE;
	//����������	
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
										{"CustomerID","�ͻ����"},
										{"EnterpriseName","�ͻ�����"},
										{"EnglishName","�ͻ�Ӣ����"},
										{"CorpID","֤������"},
										{"LicenseNo","����Ӫҵִ�պ���"},
										{"FinanceType","��������"},
										{"Licensedate","Ӫҵִ�յǼ���"},
										{"LicenseMaturity","Ӫҵִ�յ�����"},
										{"OrgType","��ҵ����"},
										{"OrgTypeName","��ҵ����"},
										{"IndustryType","������ҵ����"},
										{"IndustryTypeName","������ҵ����"},
										{"IndustryName","��ҵ��ģ������ҵ����"},     //new
										{"IndustryDetailName","��ҵ��ģ������ҵ����"}, //new
										{"MostBusiness","��Ӫ��Χ"},
										{"EmployeeNumber","ְ������"},
										{"TotalAssets","�ʲ��ܶ�"},                //new
										{"SellSum","���۶�"},                                   //new
										{"ScopeName","��ҵ��ģ"},
										{"EnterpriseBelongName","��ҵ����"},
										{"ListingCorpOrNotName","�Ƿ����й�˾"},
										{"SetupDate","��ҵ��������"},
										{"RCCurrencyName","ע���ʱ�����"},
										{"RegisterCapital","ע���ʱ�"},
										{"RegisterAdd","ע���ַ"},
//										{"CountryCodeName","���ڹ���(����)"},
//										{"RegionCodeName","ʡ�ݡ�ֱϽ�С�������"},
										{"OfficeAdd","�칫��ַ"},
										{"OfficeZIP","��������"},
										{"OfficeTel","��ϵ�绰"},
										{"LoanCardNo","�����"},
										{"PCCurrencyName","ʵ���ʱ�����"},
										{"PaiclUpCapital","ʵ���ʱ�"},
										{"HasIERightName","���޽����ھ�ӪȨ"},
										{"CreditLevel","���м������õȼ�"},
										{"InputUserName","�Ǽ���"},
										{"InputOrgName","�Ǽǻ���"},
										{"InputDate","�Ǽ�����"},
										{"UpdateUserName","������Ա"},
										{"UpdateOrgName","���»���"},
										{"UpdateDate","��������"},
										{"OtherCreditLevel","���������������õȼ�"}
						   }; 
	
	sSql =	" select CustomerID,EnterpriseName,EnglishName,CorpID,LicenseNo,FinanceType, "+
			" Licensedate,LicenseMaturity, "+
			" OrgType,getItemName('OrgType',OrgType) as OrgTypeName,IndustryType, "+
			" getItemName('IndustryType',IndustryType) as IndustryTypeName, IndustryName,"+
			"getItemName('IndustryName',IndustryName) as IndustryDetailName,"+
			" MostBusiness,EmployeeNumber,TotalAssets,SellSum,getItemName('Scope',Scope) as ScopeName, "+
			" getItemName('EnterpriseBelong',EnterpriseBelong) as EnterpriseBelongName, "+
			" getItemName('ListingCorpCondition',ListingCorpOrNot) as ListingCorpOrNotName,SetupDate, "+
			" getItemName('Currency',RCCurrency) as RCCurrencyName,RegisterCapital, "+
			" RegisterAdd,"+
			" OfficeAdd,OfficeZIP, "+
			" OfficeTel,LoanCardNo,getItemName('Currency',PCCurrency) as PCCurrencyName,"+
			" PaiclUpCapital,getItemName('HaveNot',HasIERight) as HasIERightName,CreditLevel, "+
			" getUserName(InputUserID) as InputUserName, "+
			" getOrgName(InputOrgID) as InputOrgName,InputDate, "+
			" getUserName(UpdateUserID) as UpdateUserName,"+
			" getOrgName(UpdateOrgID) as UpdateOrgName,UpdateDate ,OtherCreditLevel"+
			" from ENT_INFO" +
			" where CustomerID in (select CustomerID from CUSTOMER_BELONG "+
			" where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')) "+
			" and OrgNature = '0107'";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);   
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	doTemp.setKey("CustomerID",true);	 

	//�����ֶ�����
    doTemp.setType("RegisterCapital,PaiclUpCapital,TotalAssets,SellSum","Number");
    
    doTemp.setVisible("OrgType,IndustryType,OtherCreditLevel,IndustryName,FinanceType",false);
    doTemp.setDDDWCode("OrgType","OrgType");
    doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
    doTemp.setDDDWSql("IndustryName","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryName'");
    doTemp.setDDDWSql("FinanceType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'FinanceType'");
     doTemp.setHTMLStyle("EnterpriseName,RegisterAdd,OfficeAdd","style={width:200px}");
    doTemp.setHTMLStyle("EmployeeNumber","style={width:30px}");    
    doTemp.setHTMLStyle("MostBusiness","style={width:250px}");   
    doTemp.setHTMLStyle("InputOrgName,UpdateOrgName,IndustryTypeName,IndustryDetailName","style={width:200px}"); 
       
    doTemp.setCheckFormat("Licensedate,LicenseMaturity,UpdateDate,InputDate","3");   
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerID","");
	doTemp.setFilter(Sqlca,"2","CorpID","");
	doTemp.setFilter(Sqlca,"3","EnterpriseName","");
	doTemp.setFilter(Sqlca,"4","FinanceType","Operators=BeginsWith;");
	doTemp.setFilter(Sqlca,"4","OrgType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","IndustryType","Operators=BeginsWith;");
	doTemp.setFilter(Sqlca,"6","IndustryName","Operators=BeginsWith;");
	doTemp.setFilter(Sqlca,"7","RegisterCapital","");
	doTemp.setFilter(Sqlca,"8","RegisterAdd","");
	doTemp.setFilter(Sqlca,"","OfficeAdd","");
	doTemp.setFilter(Sqlca,"10","LicenseNo","");
	doTemp.setFilter(Sqlca,"11","MostBusiness","");
	doTemp.setFilter(Sqlca,"12","OtherCreditLevel","");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(21);  //��������ҳ

	//����HTMLDataWindow
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
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
	};
	if(CurUser.hasRole("095")||CurUser.hasRole("0A2")||CurUser.hasRole("0B5")||CurUser.hasRole("0C2")||
	 CurUser.hasRole("0D2")||CurUser.hasRole("0E9")||CurUser.hasRole("0F4")||CurUser.hasRole("0H5")||
	 CurUser.hasRole("0I4")||CurUser.hasRole("0J1")||CurUser.hasRole("282")||CurUser.hasRole("295")||
	 CurUser.hasRole("2A4")||CurUser.hasRole("2B9")||CurUser.hasRole("2C2")||CurUser.hasRole("2D4")||
	 CurUser.hasRole("2E4")||CurUser.hasRole("2G5")||CurUser.hasRole("2H5")||CurUser.hasRole("2I2")||
	 CurUser.hasRole("421")||CurUser.hasRole("495"))
	{
		sButtons[1][0] = "false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ÿͻ����
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");
		}

	}	
    	
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
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
