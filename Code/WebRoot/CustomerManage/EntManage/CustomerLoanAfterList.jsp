<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: δ��������ҵ���б�;
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
	String PG_TITLE = "δ��������ҵ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	String sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"SerialNo","��ͬ��ˮ��"},
							{"OccurTypeName","��������"},
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"Balance","���"},
							{"ClassifyResultName","���շ���"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"ManageOrgName","�ܻ�����"}, 
							{"OperateOrgName","�������"},
						  };	

	String sSql =   " select SerialNo,"+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,Balance,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" PutOutDate,Maturity,"+
					" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where CustomerID='"+sCustomerID+"' "+					
					" and (FinishDate = '' or FinishDate is null) "+
					" and (BusinessType like '1%' "+
					" or BusinessType like '2%' ) ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("OperateOrgName,BusinessType,OccurType,BusinessCurrency,VouchType,ManageOrgID,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setAlign("OccurTypeName,Currency,VouchTypeName,BusinessTypeName,Maturity,PutOutDate","2");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName,OccurTypeName"," style={width:80px} ");
	doTemp.setHTMLStyle("OperateOrgName,ManageOrgName" ,"style={width:200px} ");	
   //���ɹ�����
	doTemp.setColumnAttribute("SerialNo","IsFilter","1");
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
		{"true","","Button","����","�鿴δ��������ҵ������","viewAndEdit()",sResourcesPath},
		{"true","","Button","��Ϣ����","��Ϣ����","infoGather()",sResourcesPath},
		{"true","","Button","���ʵʱ���","���ʵʱ���","checkBalance()",sResourcesPath},
		{sCustomerType.startsWith("03")?"true":"false","","Button","���״�����ۿ�����","���״�����ۿ�����","deductApply()",sResourcesPath},
		{sCustomerType.startsWith("03")?"true":"false","","Button","���״�����ۿ�ȡ��","���״�����ۿ�ȡ��","deductCancel()",sResourcesPath},
		{sCustomerType.startsWith("03")?"true":"false","","Button","����������ѯ","����������ѯ","assurePay()",sResourcesPath},
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
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType=AfterLoan&ObjectNo="+sSerialNo+"&ViewID=002";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
   
   	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function infoGather()
	{
		popComp("CustomerLoanAfterGather","/CustomerManage/EntManage/CustomerLoanAfterGather.jsp","CustomerID=<%=sCustomerID%>","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=���ʵʱ���;InputParam=��;OutPutParam=��;]~*/
	function checkBalance()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			sBusinessType = getItemValue(0,getRow(),"BusinessType");
			if(sBusinessType=='1110010' || sBusinessType=='1110020' || sBusinessType=='1140060'
			 || sBusinessType=='1140010' || sBusinessType=='1140020' || sBusinessType=='1140110' 
			 || sBusinessType=='2110010'|| sBusinessType=='1140025' || sBusinessType == '1110025')
			{
				//alert("����ϵͳ��δ���ߣ����ܲ�ѯ��");
				sObjectNo=sSerialNo;
				sObjectType="CheckBalance";
				sTradeType = "6002";
				sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
					return;
				}else{
					alert("���͸����ɹ�!"+sReturn[1]);
					reloadSelf();
				}
			}else
			{
				sObjectNo=sSerialNo;
				sObjectType="CheckBalance";
				sTradeType="798004";
				sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
					return;
				}else{
					alert("���ͺ��ĳɹ�!"+sReturn[1]);
					reloadSelf();
				}
			}
		}
	}
	
	/*~[Describe=���״�����ۿ�����;InputParam=��;OutPutParam=��;]~*/
	function deductApply()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		//sSerialNo="9031001000900916";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			///alert("����ϵͳ��δ���ߣ����������״�����ۿ����룡");
			sBusinessType = getItemValue(0,getRow(),"BusinessType");
			if(sBusinessType=='1140110')
			{
				sObjectNo=sSerialNo;
				sObjectType="deductApply";
				sTradeType = "6010";
				sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
					return;
				}else{
					alert("���͸����ɹ�!"+sReturn[1]);
					reloadSelf();
				}
			}
		}
	}
	
	/*~[Describe=���״�����ۿ�ȡ��;InputParam=��;OutPutParam=��;]~*/
	function deductCancel()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		//sSerialNo="9031001000900916";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			//alert("����ϵͳ��δ���ߣ����������״�����ۿ����룡");
			sBusinessType = getItemValue(0,getRow(),"BusinessType");
			if(sBusinessType=='1140110')
			{
				sObjectNo=sSerialNo;
				sObjectType="deductCancel";
				sTradeType = "6011";
				sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
				sReturn=sReturn.split("@");
				if(sReturn[0] != "0000000"){
					alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
					return;
				}else{
					alert("���͸����ɹ�!"+sReturn[1]);
					reloadSelf();
				}
			}
		}
	}
	
	//----------------�����𵣱�����----------------
	function assurePay()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sObjectType = getItemValue(0,getRow(),"BusinessType");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sTradeType = "6024";
		//var sReturn = RunMethod("WorkFlowEngine","GetAfaloanFlag3",sSerialNo);
		if(sBusinessType == '2110020' || sBusinessType == '1110027')
		{
			sReturn = RunMethod("BusinessManage","SendGD",sSerialNo+","+sObjectType+","+sTradeType);
			sReturn=sReturn.split("@");
			if(sReturn[0] != "0000000"){
				alert("������ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
				return;
			}else{
				alert("���͹�����ϵͳ�ɹ���"+sReturn[1]);
			}
		}else
		{
			alert("�ñʴ���ǹ�������");
			return;
		}
		
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
