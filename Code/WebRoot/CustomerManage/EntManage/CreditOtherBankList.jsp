<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: bliu 2004-12-03
		Tester:
		Describe: �ͻ����������ڻ���ҵ��;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			CustomerID����ǰ�ͻ����
			SerialNo:	��ˮ��
			EditRight:Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
			
		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	���ӹ�����					
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ����������ڻ���ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����
	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	
							{"SerialNo","��ˮ��"},
							{"OccurOrg","������"},
							{"BusinessType","ҵ������"},
							{"VouchTypeName","������ʽ"},
							{"CurrencyName","����"},
							{"BusinessSum","���Ž��"},
							{"Balance","�������"},
							{"ClassifyResult","�弶����"},
							{"BeginDate","��������"},
							{"Maturity","������"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"}
						  };

	String sSql =	" select CustomerID,SerialNo," +
	                " OccurOrg,getItemName('OtherBusinessType',BusinessType) as BusinessType,getItemName('VouchType',VouchType) as VouchTypeName,getItemName('Currency',Currency) as CurrencyName,BusinessSum,Balance," +
					" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,BeginDate,Maturity ,InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName" +
					" from CUSTOMER_OACTIVITY " +
					" where CustomerID='"+sCustomerID+"' ";


	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_OACTIVITY";
	//���ùؼ���
	doTemp.setKey("CustomerID,SerialNo",true);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,SerialNo,InputOrgID,InputUserID",false);
	doTemp.setUpdateable("BusinessType,UserName,OrgName",false);
	//�����ֶ�����
	doTemp.setType("BusinessSum,Balance","Number");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName��BusinessType" ,"style={width:200px} ");	
	doTemp.setAlign("BusinessType,CurrencyName,UserName,OccurOrg","2");
	doTemp.setCheckFormat("Maturity,BeginDate","3");
    doTemp.setHTMLStyle("OrgName��BusinessType","style={width:200px}"); 	
    //���ɹ�����
	doTemp.setColumnAttribute("OccurOrg","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
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
		{"true","","Button","����","�������������ڻ���ҵ�����","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴���������ڻ���ҵ�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ�����������ڻ���ҵ�����","deleteRecord()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/CreditOtherBankInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"InputUserID");//--�û�����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}	
    	}else
        	alert(getHtmlMessage('3'));	
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sUserID=getItemValue(0,getRow(),"InputUserID");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/CustomerManage/EntManage/CreditOtherBankInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
		}
	}
	
 	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
