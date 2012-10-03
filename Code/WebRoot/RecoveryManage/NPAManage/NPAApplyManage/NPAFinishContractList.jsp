<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/09/10
		Tester:
		Describe: �����ս�����ͬ
		Input Param:
			ObjectType: ��������
			ObjectNo��������
		Output Param:
			SerialNo��ҵ����ˮ��
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ս�����ͬ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String 	sSql = "";
	//���ҳ�����
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";

%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

	String sHeaders[][] = {
			{"BusinessTypeName","ҵ��Ʒ��"},
			{"CustomerID","�ͻ����"},
			{"CustomerName","�ͻ�����"},
			{"ObjectNo","��ͬ��ˮ��"},
			{"OccurTypeName","��������"},
			{"BusinessCurrency","����"},
			{"VouchType","������ʽ"},	
			{"Currency","����"},
			{"BusinessSum","��ͬ���"},
			{"Balance","��ǰ���"},
			{"VouchTypeName","��Ҫ������ʽ"},
			{"ClassifyResult","���շ���"},
			{"InterestBalance1","����Ƿ��"},
			{"InterestBalance2","����ǷϢ"},			
			{"OriginalPutOutDate","�״η�����"},
			{"Maturity","��������"},	
		  };
		  
	sSql =   " select BR.SerialNo as SerialNo,BR.ObjectType as ObjectType,BR.ObjectNo as ObjectNo,BC.CustomerID,BC.CustomerName as CustomerName,"+
		" getBusinessName(BC.BusinessType) as BusinessTypeName,"+
		" getItemName('Currency',BC.BusinessCurrency) as Currency,"+
		" BC.BusinessSum as BusinessSum,"+
		" BC.Balance as Balance,"+
		" getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
		" getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
		" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,InterestBalance1,InterestBalance2,"+
		" BC.OriginalPutOutDate as OriginalPutOutDate,BC.Maturity as Maturity"+
		" from BUSINESS_CONTRACT BC,BADBIZ_RELATIVE BR "+
		" where BR.ObjectNo=BC.SerialNo and BR.ObjectType='FinishContract' "+
		" and BR.SerialNo='"+sObjectNo+"'";

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BADBIZ_RELATIVE";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	
	//����С����ʾ״̬,
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setType("BusinessSum,Balance","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType,CustomerID",false);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

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

	String sButtons[][] = 
		{
			{"true","","Button","���������ͬ","��������ս��ͬ��Ϣ","importRecord()",sResourcesPath},
			{"true","","Button","��ͬ����","��ͬ����","viewTab()",sResourcesPath},
			{"true","","Button","ɾ��������ͬ","ɾ��������ͬ��Ϣ","deleteRecord()",sResourcesPath},
			{"true","","Button","�ͻ�����","�ͻ�����","viewCustomer()",sResourcesPath}
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
	function importRecord()
	{
		sParaString = "RecoveryOrgID,"+"<%=CurOrg.OrgID%>"+",RecoveryUserID,"+"<%=CurUser.UserID%>";
		//���¹�����ͬ
		sReturnValue=setObjectValue("SelectFinishContract",sParaString,"",0,0,"");
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_NONE_" && sReturnValue != "_CLEAR_" && sReturnValue != "_CANCEL_") 
		{
			sReturnValue = sReturnValue.split("@");
			sContractSerialNO=sReturnValue[0];
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sObjectNo%>"+",FinishContract,"+sContractSerialNO+",BADBIZ_RELATIVE");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				alert(getBusinessMessage("754"));//���������ͬ�ɹ���
			}else
			{
				alert(getBusinessMessage("755"));//���������ͬʧ�ܣ������²�����
				return;
			}
		}
		reloadSelf();	
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
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
	/*~[Describe=ʹ��OpenComp�򿪿ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomer()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
    	openObject("Customer",sCustomerID,"001");
    	reloadSelf();
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

<%@include file="/IncludeEnd.jsp"%>
