<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
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
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "��˾�ͻ����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
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
								{"OrgNatureName","��������"},
								{"Licensedate","Ӫҵִ�յǼ���"},
								{"LicenseMaturity","Ӫҵִ�յ�����"},
								{"OrgType","��ҵ����"},
								{"OrgTypeName","��ҵ����"},
								{"OldIndustryType","�Ϲ�����ҵ����"},
								{"OldIndustryTypeName","�Ϲ�����ҵ����"},
								{"IndustryType","������ҵ����"},
								{"IndustryTypeName","������ҵ����"},
								{"IndustryType2","������ҵ����"},
								{"IndustryType2Name","������ҵ����"},
								{"MostBusiness","��Ӫ��Χ"},
								{"EmployeeNumber","ְ������"},
								{"OldScopeName","��ҵ��ģ(�ϱ�׼)"},
								{"ScopeName","��ҵ��ģ"},
								{"EnterpriseBelongName","��ҵ����"},
								{"ListingCorpOrNotName","�Ƿ����й�˾"},
								{"RegisterCapital","ע���ʱ�"},
								{"RegisterAdd","ע���ַ"},
								{"CountryCodeName","���ڹ���(����)"},
								{"RegionCodeName","ʡ�ݡ�ֱϽ�С�������"},
								{"OfficeAdd","�칫��ַ"},
								{"PCCurrencyName","ʵ���ʱ�����"},
								{"PaiclUpCapital","ʵ���ʱ�"},
								{"CreditLevel","���м������õȼ�"},
								{"InBalance","�������"},
								{"OutBalance","�������"},
								{"OutChangkouBalance","���⳨�����"},
								{"OverdueBalance","�������"},
								{"InterestBalance1","����ǷϢ���"},
								{"InterestBalance2","����ǷϢ���"},
								{"InputUserName","�Ǽ���"},
								{"InputOrgName","�Ǽǻ���"},
								{"UpdateUserName","������Ա"},
								{"UpdateOrgName","���»���"},
								{"PreBalance","2.28�����ܶ�"},
								{"PreCKBalance","2.28�жҳ���"},
								{"Balance1","�����ʽ����"},
								{"Balance2","Ʊ������"},
								{"Balance3","��Ŀ����"},
								{"Balance4","���˰���"},
								{"Balance5","���ز���������"},
								{"Balance6","���Ŵ���"},
								{"Balance7","����ó������(����)"},
								{"Balance8","����ó������"},
								{"Balance9","���гжһ�Ʊ"},
								{"Balance10","��������֤"},
								{"Balance11","����"},
								{"Balance13","����ó������(����)"},
								{"Balance14","ί�д���"},
								{"Balance15","�����ŵ"},
								{"Balance16","���"},
								{"ReportBalance1","�ʲ�"},
								{"ReportBalance2","��ծ"},
								{"ReportBalance3","������Ȩ��"},
								{"Flag3Name","���ڿͻ�����"},
								{"OrgName","ֱ��������"},
								{"RealtyFlag","�ص�ͻ���������"},
								{"IndustryType1","����ͻ�����"},
								{"LastDate","���һ��ҵ��������"},
								{"EconomyTypeName","��Ӫ����"}
				   }; 
	
	if(CurUser.hasRole("098")){
		sSql =	" select getLastDate(EI.CustomerID) as LastDate,"+
		" getItemName('RealtyFlag',RealtyFlag) as RealtyFlag,getItemName('IndustryType1',IndustryType1) as IndustryType1, "+
		" getOrgName(getHeaderOrgID(InputOrgID)) as OrgName, "+
		" EI.CustomerID,EnterpriseName,CorpID,LicenseNo, "+
		" Licensedate,LicenseMaturity, "+
		" OrgType,getItemName('OrgType',OrgType) as OrgTypeName, "+
		" OldIndustryType,getItemName('OldIndustryType',substr(OldIndustryType,1,1))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,3))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,4))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,5)) as OldIndustryTypeName,"+
		" EI.IndustryType,getItemName('IndustryType',substr(EI.IndustryType,1,1))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,3))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,4))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,5)) as IndustryTypeName, "+
		" IndustryType2,getItemName('BankIndustryType',IndustryType2) as IndustryType2Name, "+
		" getItemName('CustomerType2',Flag3) as Flag3Name, "+
		" getItemName('EconomyType',EconomyType) as EconomyTypeName, "+
		" MostBusiness,EmployeeNumber,"+
		" getItemName('Scope',AUS.OldEntScope) as OldScopeName,"+
		" getItemName('Scope',Scope) as ScopeName, "+
		" getItemName('EnterpriseBelong',EnterpriseBelong) as EnterpriseBelongName, "+
		" getItemName('YesNo',ListingCorpOrNot) as ListingCorpOrNotName, "+
		" RegisterCapital, "+
		" RegisterAdd,getItemName('CountryCode',CountryCode) as CountryCodeName, "+
		" getItemName('AreaCode',RegionCode) as RegionCodeName,OfficeAdd, "+
		" getItemName('Currency',PCCurrency) as PCCurrencyName,"+
		" PaiclUpCapital,CreditLevel,"+
		" getCreditBalance(EI.CustomerID,'1') as InBalance, "+
		" getCreditBalance(EI.CustomerID,'2') as OutBalance, "+
		" getOutChangkouBalance(EI.CustomerID) as OutChangkouBalance, "+
		" getSumByType(EI.CustomerID,'10') as OverdueBalance ,"+
		" getSumByType(EI.CustomerID,'20') as InterestBalance1 ,"+
		" getSumByType(EI.CustomerID,'30') as InterestBalance2 ,"+
		" PreBalance,PreCKBalance,"+
		" getCreditBalance(EI.CustomerID,'1010') as Balance1, "+
		" getCreditBalance(EI.CustomerID,'1030') as Balance3, "+
		" getCreditBalance(EI.CustomerID,'1040') as Balance4, "+
		" getCreditBalance(EI.CustomerID,'1050') as Balance5, "+
		" getCreditBalance(EI.CustomerID,'1060') as Balance6, "+
		" getCreditBalance(EI.CustomerID,'1090') as Balance8, "+
		" getCreditBalance(EI.CustomerID,'2010') as Balance9, "+
		" getCreditBalance(EI.CustomerID,'2020') as Balance10, "+
		" (getCreditBalance(EI.CustomerID,'2030')+getCreditBalance(EI.CustomerID,'2040')) as Balance11, "+
		" getCreditBalance(EI.CustomerID,'2070') as Balance14, "+
		" getCreditBalance(EI.CustomerID,'2080') as Balance15, "+
		" getCreditBalance(EI.CustomerID,'1130') as Balance16, "+
		" getUserName(InputUserID) as InputUserName, "+
		" getOrgName(InputOrgID) as InputOrgName,"+
		" getUserName(EI.UpdateUserID) as UpdateUserName,"+
		" getOrgName(EI.UpdateOrgID) as UpdateOrgName "+
		" from ENT_INFO EI left join Als_UpdateEntIndustry AU on EI.CustomerID=AU.CustomerID left join Als_UpdateEntScope AUS on EI.CustomerID=AUS.CustomerID " +
		" where  EI.CustomerID in (select CustomerID from CUSTOMER_BELONG "+
		" where OrgID in (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"')) "+
		" and OrgNature < '0201' ";
	}else{
		sSql =	" select getOrgName(getLastOrgID(EI.CustomerID)) as OrgName, "+
		" EI.CustomerID,EnterpriseName,CorpID,LicenseNo, "+
		" Licensedate,LicenseMaturity, "+
		" OrgType,getItemName('OrgType',OrgType) as OrgTypeName, "+
		" OldIndustryType,getItemName('OldIndustryType',substr(OldIndustryType,1,1))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,3))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,4))||'--'||"+
		" getItemName('OldIndustryType',substr(OldIndustryType,1,5)) as OldIndustryTypeName,"+
		" EI.IndustryType,getItemName('IndustryType',substr(EI.IndustryType,1,1))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,3))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,4))||'--'||"+
		" getItemName('IndustryType',substr(EI.IndustryType,1,5)) as IndustryTypeName, "+
		" IndustryType2,getItemName('BankIndustryType',IndustryType2) as IndustryType2Name, "+
		" getItemName('CustomerType2',Flag3) as Flag3Name, "+
		" MostBusiness,EmployeeNumber,"+
		"getItemName('Scope',AUS.OldEntScope) as OldScopeName,"+
		"getItemName('Scope',Scope) as ScopeName, "+
		" getItemName('EnterpriseBelong',EnterpriseBelong) as EnterpriseBelongName, "+
		" getItemName('YesNo',ListingCorpOrNot) as ListingCorpOrNotName, "+
		" RegisterCapital, "+
		" RegisterAdd,getItemName('CountryCode',CountryCode) as CountryCodeName, "+
		" getItemName('AreaCode',RegionCode) as RegionCodeName,OfficeAdd, "+
		" getItemName('Currency',PCCurrency) as PCCurrencyName,"+
		" PaiclUpCapital,CreditLevel, "+
		" getCreditBalance(EI.CustomerID,'1') as InBalance, "+
		" getCreditBalance(EI.CustomerID,'2') as OutBalance, "+
		" getOutChangkouBalance(EI.CustomerID) as OutChangkouBalance, "+
		" getSumByType(EI.CustomerID,'10') as OverdueBalance ,"+
		" getSumByType(EI.CustomerID,'20') as InterestBalance1 ,"+
		" getSumByType(EI.CustomerID,'30') as InterestBalance2 ,"+
		" PreBalance,PreCKBalance,"+
		" getCreditBalance(EI.CustomerID,'1010') as Balance1, "+
		" getCreditBalance(EI.CustomerID,'1030') as Balance3, "+
		" getCreditBalance(EI.CustomerID,'1040') as Balance4, "+
		" getCreditBalance(EI.CustomerID,'1050') as Balance5, "+
		" getCreditBalance(EI.CustomerID,'1060') as Balance6, "+
		" getCreditBalance(EI.CustomerID,'1090') as Balance8, "+
		" getCreditBalance(EI.CustomerID,'2010') as Balance9, "+
		" getCreditBalance(EI.CustomerID,'2020') as Balance10, "+
		" (getCreditBalance(EI.CustomerID,'2030')+getCreditBalance(EI.CustomerID,'2040')) as Balance11, "+
		" getCreditBalance(EI.CustomerID,'2070') as Balance14, "+
		" getCreditBalance(EI.CustomerID,'2080') as Balance15, "+
		" getCreditBalance(EI.CustomerID,'1130') as Balance16, "+
		" getUserName(InputUserID) as InputUserName, "+
		" getOrgName(InputOrgID) as InputOrgName, "+
		" getUserName(EI.UpdateUserID) as UpdateUserName,"+
		" getOrgName(EI.UpdateOrgID) as UpdateOrgName "+
		" from ENT_INFO EI left join Als_UpdateEntIndustry AU on EI.CustomerID=AU.CustomerID left join Als_UpdateEntScope AUS on EI.CustomerID=AUS.CustomerID" +
		" where EI.CustomerID in (select CustomerID from CUSTOMER_BELONG "+
		" where OrgID in (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"')) "+
		" and OrgNature < '0201' ";
	}
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);   
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	doTemp.setKey("CustomerID",true);	 

	//�����ֶ�����
    doTemp.setType("RegisterCapital,PaiclUpCapital,Balance1,Balance2,Balance3,Balance4,Balance5,Balance6,Balance7,Balance8,"+
    		"Balance9,PreBalance,PreCKBalance,InBalance,OutBalance,OutChangkouBalance,OverdueBalance,InterestBalance1,InterestBalance2,Balance10,"+
    		"Balance11,Balance12,Balance13,Balance14,Balance15,Balance16,ReportBalance1,ReportBalance2,ReportBalance3","Number");
	
    doTemp.setAlign("RegisterCapital,PaiclUpCapital,Balance1,Balance2,Balance3,Balance4,Balance5,Balance6,Balance7,Balance8,"+
    		"Balance9,PreBalance,PreCKBalance,InBalance,OutBalance,OutChangkouBalance,OverdueBalance,InterestBalance1,InterestBalance2,Balance10,"+
    		"Balance11,Balance12,Balance13,Balance14,Balance15,Balance16,ReportBalance1,ReportBalance2,ReportBalance3","3");
	
    doTemp.setCheckFormat("RegisterCapital,PaiclUpCapital,Balance1,Balance2,Balance3,Balance4,Balance5,Balance6,Balance7,Balance8,"+
    		"Balance9,PreBalance,PreCKBalance,InBalance,OutBalance,OutChangkouBalance,OverdueBalance,InterestBalance1,InterestBalance2,Balance10,"+
    		"Balance11,Balance12,Balance13,Balance14,Balance15,Balance16,ReportBalance1,ReportBalance2,ReportBalance3","2");
	
    //������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("EnterpriseName","style={width:250px} ");  
	doTemp.setHTMLStyle("IndustryTypeName","style={width:350px} ");  
    
    doTemp.setVisible("OrgType,IndustryType,OldIndustryType,IndustryType2",false);
    doTemp.setDDDWCode("OrgType","OrgType");
	doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'IndustryType' and length(ItemNo)=1");
    
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerID","");
	doTemp.setFilter(Sqlca,"2","CorpID","");
	doTemp.setFilter(Sqlca,"3","EnterpriseName","");
	doTemp.setFilter(Sqlca,"4","OrgType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","IndustryType","Operators=BeginsWith;");
	doTemp.setFilter(Sqlca,"6","RegisterCapital","");
	doTemp.setFilter(Sqlca,"7","RegisterAdd","");
	doTemp.setFilter(Sqlca,"8","OfficeAdd","");
	doTemp.setFilter(Sqlca,"9","LicenseNo","");
	doTemp.setFilter(Sqlca,"10","MostBusiness","");
	if(CurUser.hasRole("098")){
		doTemp.setFilter(Sqlca,"11","RealtyFlag","");
		doTemp.setFilter(Sqlca,"12","EconomyTypeName","");
	}
	doTemp.setAlign("EmployeeNumber","3");
	
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
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
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
			{CurUser.hasRole("098")?"true":"false","","Button","�ͻ��ص�����","�ͻ��ص�����","addIndustryType1()",sResourcesPath},
			{"true","","Button","�����ص�ͻ�����","�����ص�ͻ�����","addUserDefine()",sResourcesPath}
		};
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
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
    
   	/*~[added by wwhe 2010-05-11 Describe=�ͻ��ص�����;InputParam=��;OutPutParam=SerialNo;]~*/
    function addIndustryType1()
    {
    	//��ÿͻ����
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		PopComp("ChangeCustomer","/InfoManage/QuickSearch/ChangeCustomer.jsp","CustomerID="+sCustomerID,"resizable=yes;dialogWidth=25;dialogHeight=20;center:yes;status:no;statusbar:no");
		reloadSelf();
    }
	/*~[Describe=�����ص���Ϣ����;InputParam=CustomerID,ObjectType=Customer;OutPutParam=��;]~*/
	function addUserDefine()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getBusinessMessage('114'))) //������ͻ���Ϣ�����ص�ͻ���������?
		{
			PopPage("/Common/ToolsB/AddUserDefineAction.jsp?ObjectType=Customer&ObjectNo="+sCustomerID,"","");
		}
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
	
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
