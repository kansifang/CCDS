<%@	page contentType="text/html; charset=GBK"%>
<%@	include file="IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: �Ŵ����ݲ����б�;
		Input Param:
					DataInputType��010�貹���Ŵ�ҵ��
									020��������Ŵ�ҵ��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Ŵ����ݲ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";
	
	String sClauseWhere="";
	//���ҳ�����
	
	//����������
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));

	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	if(sFlag==null) sFlag="";
	sReinforceFlag="010";
	
	String sHeaders[][] = {
					{"SerialNo","��ͬ��ˮ��"},
					{"CustomerName","�ͻ�����"},
					{"CustomerTypeName","�ͻ�����"},
					{"CustomerID","�ͻ����"},
					{"BusinessTypeName","ҵ��Ʒ��"},
					{"ArtificialNo","��ͬ���"},
					{"OccurTypeName","��������"},
					{"Currency","����"},
					{"BusinessSum","��ͬ���(Ԫ)"},
					{"Balance","���(Ԫ)"},
					{"VouchTypeName","��Ҫ������ʽ"},
					{"PutOutDate","��ʼ����"},
					{"Maturity","��������"},
					{"OperateOrgName","�������"},
				  };

	if(sReinforceFlag.equals("010"))  //�����ǵ�ҵ��
	{
	
		if(sFlag.equals("Y"))  //�����ʲ�����
		{
			sClauseWhere = " and ManageOrgID ='"+CurOrg.OrgID+"' and (RecoveryOrgID='' or RecoveryOrgID is null)";
		}
		else	//�Ŵ���Ϣ����
		{
			sClauseWhere = " and ManageOrgID ='"+CurOrg.OrgID+"' and (RecoveryOrgID='' or RecoveryOrgID is null)";
		}
	}
	if(sReinforceFlag.equals("020"))  //������ɵ�ҵ��
	{
	
		if(sFlag.equals("Y"))  //�����ʲ�����
		{
			sClauseWhere = " and ManageOrgID ='"+CurOrg.OrgID+"' and (RecoveryOrgID<>'' or RecoveryOrgID is not null)";
		}
		else	//�Ŵ���Ϣ����
		{
			sClauseWhere = " and ManageOrgID ='"+CurOrg.OrgID+"' and (RecoveryOrgID='' or RecoveryOrgID is null)";
		}
	}
	
	 sSql = " select SerialNo,CustomerName,"+
			" CustomerID,getCustomerType(CustomerID) as CustomerType,"+
			" getItemName('CustomerType',getCustomerType(CustomerID)) as CustomerTypeName,"+
			" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
			" ArtificialNo,"+
			" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
			" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
			" BusinessSum,Balance,"+
			" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
			" PutOutDate,Maturity,"+
			" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
			" from BUSINESS_CONTRACT"+
			" where (BusinessType like '[1,2,5]%' or BusinessType is null)"+
			" and ReinforceFlag = '"+sReinforceFlag+"' "
			+sClauseWhere ;
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
		
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setKeyFilter("SerialNo"); //add by hxd in 2005/02/21
	
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,BusinessType,CustomerType,OccurType,BusinessCurrency,VouchType,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:180px} ");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,ArtificialNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function CustomerInfo()
	{
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			var sReturn = PopPage("/InfoManage/DataInput/CustomerQueryAction.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("Ҫ��ѯ�Ŀͻ���Ϣ�����ڣ�");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("Ҫ��ѯ�Ŀͻ�����Ϊ�գ���ѡ��ͻ����ͣ�");
			}
			openObject("Customer",sCustomerID,"001");
		}
	}

	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function BusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			openObject("AfterLoan",sSerialNo,"002");
		}
	}

	/*~[Describe=���ǿͻ���Ϣ;InputParam=��;OutPutParam=��;]~*/
	function InputCustomerInfo()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			var sReturn = PopPage("/InfoManage/DataInput/CustomerQueryAction.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("Ҫ���ǵĿͻ���Ϣ�����ڣ�");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("Ҫ���ǵĿͻ�����Ϊ�գ���ѡ��ͻ����ͣ�");
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
				if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
				sCustomerType = sReturn;
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			}
			openObject("Customer",sCustomerID,"000");
		}
	}

	/*~[Describe=����ҵ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function InputBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				sCustomerType   = getItemValue(0,getRow(),"CustomerType");
				sCustomerType = sCustomerType.substr(0,3);
				sReturn=selectObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=N");
				if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
				sss1 = sReturn.split("@");
				sBusinessType=sss1[0];
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
			}
			openObject("ReinforceContract",sSerialNo,"000");
			reloadSelf();
		}
	}

	/*~[Describe=�ı�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function changeCustomerType()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			sReturn=PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
			if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
			sCustomerType = sReturn;
			sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			reloadSelf();
		}
	}

	/*~[Describe=�ı�ҵ��Ʒ��;InputParam=��;OutPutParam=��;]~*/
	function changeBusinessType()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			sCustomerType   = getItemValue(0,getRow(),"CustomerType");
			sCustomerType = sCustomerType.substr(0,3);
			sReturn=selectObjectInfo("BusinessType","CustomerType="+sCustomerType+"~ReinforceFlag=N");
			if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
			sss1 = sReturn.split("@");
			sBusinessType=sss1[0];
			sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
			reloadSelf();
		}
	}

	/*~[Describe=������ͬ;InputParam=��;OutPutParam=��;]~*/
	function NewContract()
	{
		var sFlag="<%=sFlag%>";
		
		if(sFlag=="Y")
		{
			var sReturn = createObject("NPAReinforceContract","");
		}
		else
		{
			var sReturn = createObject("ReinforceContract","");
		}
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		reloadSelf();
	}

	/*~[Describe=����ɲ��Ǳ�־;InputParam=��;OutPutParam=��;]~*/
	function Finished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm("���Ҫ���������")) 
			{
				var sFlag="<%=sFlag%>";
			
				if(sFlag=="Y")   //�����ʲ��������
				{
					sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag,"","");
				}
				else
				{
					sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo,"","");
				}
				if(sReturn == "succeed")
				{
					alert(getBusinessMessage('186'));
				}
				//reloadSelf();
				OpenComp("DataInputMain","/InfoManage/DataInput/DataInputMain.jsp","ComponentName=��Ϣ����Ǽ�&Component=N&ComponentType=MainWindow","_top","")
			}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=�ٴβ���;InputParam=��;OutPutParam=��;]~*/
	function secondFinished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm("���Ҫ�ٴβ�����")) 
		{
			
			var sFlag="<%=sFlag%>";
			var sFlag1 = "SecondFlag";
			
			if(sFlag=="Y")   //�����ʲ��������
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag="+sFlag+"&Flag1="+sFlag1,"","");
			}
			else
			{
				sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&Flag1=SecondFlag","","");
			}
			
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			
			if(sReturn == "true")
			{
				alert("�ٴβ��ǣ���ѡ���ݽ��ص��貹��ҵ���б�!");
			}
			
			if(sReturn == "false")
			{
				alert("��ѡ�ʲ��Ѿ��ַ�,�����ٴβ���!");
			}
			reloadSelf();
		}
	}


	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="IncludeEnd.jsp"%>
