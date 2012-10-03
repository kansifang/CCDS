<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lpzhang 2010-5-27 
		Tester:
		Describe: ���շ���״̬����
		Input Param:	
			
		Output Param:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���շ���״̬����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������	
	String sSql="";
	String sWhere = "";	

	//���ҳ�����
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//��ʾ����				
	String[][] sHeaders = {		
							{"SerialNo","��ͬ��ˮ��"},              	
							{"CustomerName","�ͻ�����"},              
							{"BusinessTypeName","ҵ��Ʒ������"},  
							{"LockClassifyResultName","����������"}, 
							{"ClassifyResultName","�ʲ����շ�����"}, 
							{"CurrencyName","����"},                    
							{"BusinessSum","��ͬ���"},           	
							{"Balance","��ͬ���"},  
							{"PutOutDate","��ͬ��ʼ��"}, 
							{"Maturity","��ͬ������"}, 
							{"ManageUserName","���������Ա"},                  
							{"ManageOrgName","����ܻ���"},                
						 };
	

	sSql =  " select SerialNo,CustomerID,getCustomerType(CustomerID) as CustomerType,getCustomerName(CustomerID) as CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
			" BusinessSum,Balance,BusinessCurrency,getItemName('Currency',BusinessCurrency) as CurrencyName, LockClassifyResult,getItemName('ClassifyResult',LockClassifyResult) as LockClassifyResultName, "+
			" ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName, PutOutDate,Maturity, ManageUserID,ManageOrgID, "+
			" getUserName(ManageUserID) as ManageUserName,getOrgName(ManageOrgID) as ManageOrgName "+
			" from Business_Contract where Balance >0 " +
			" and businesstype is not null " +
			" and businesstype <>'' " +
			" and vouchtype is not null " +
			" and vouchtype <>'' " +
			" and (finishdate is null or finishdate = '') " +
			" and left(BusinessType,1) <>'3'"+
			" and PutOutDate is not null and PutOutDate<>'' ";
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//��ӻ�������
	sWhere += OrgCondition.getOrgCondition("ManageOrgID",CurOrg.OrgID,Sqlca); 
	doTemp.WhereClause+=sWhere;
	
	doTemp.UpdateTable="Business_Contract";
	doTemp.setKey("SerialNo",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("CurrencyName","2");
	
	doTemp.setType("BusinessSum,Balance","Number");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("CurrencyName"," style={width:80px} ");
	
	doTemp.setVisible("CustomerID,BusinessCurrency,LockClassifyResult,ManageUserID,ManageOrgID,ClassifyResult,BusinessType,CustomerType",false);
	//����Filter			
	doTemp.setColumnAttribute("SerialNo","IsFilter","1");
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.setColumnAttribute("ManageUserName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	dwTemp.setPageSize(10);
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
			{"true","","Button","�޸�����������","�޸�����������","ModifiedLockResult()",sResourcesPath},
			{"true","","Button","ȡ������","ȡ������","Cancel()",sResourcesPath},
			{"true","","Button","�鿴��ͬ","�鿴��ͬ����","contractInfo()",sResourcesPath},
			
		};		
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=�޸�����������;InputParam=��;OutPutParam=��;]~*/
	function ModifiedLockResult()
	{    		
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sCustomerType = getItemValue(0,getRow(),"CustomerType");
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sReturn = popComp("ModifiedLockResultDialog","/CreditManage/CreditCheck/ModifiedLockResultDialog.jsp","ObjectNo="+sObjectNo+"&CustomerType="+sCustomerType,"dialogWidth=30;dialogHeight=15;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function Cancel()
	{    		
		 sObjectNo = getItemValue(0,getRow(),"SerialNo");
		 if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)	
		 {
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			 return;
		 }
		 alert(sObjectNo);
		 sReturn = RunMethod("�弶����","ȡ�������ʲ����շ���",sObjectNo);
		 if (typeof(sObjectNo) != "undefined" && sObjectNo.length != 0)	
		 {
		 	 alert("�����ɹ���");
			 reloadSelf();
		 }
	    
	}
	
	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function contractInfo()
	{ 
		//��ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
			return;
		}
		
		openObject("AfterLoan",sSerialNo,"002");
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
