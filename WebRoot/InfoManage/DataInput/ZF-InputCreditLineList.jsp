<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: ��Ȳ����б�;
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
	String PG_TITLE = "��Ȳ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql1="";

	//���ҳ�����
	
	//����������
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","���Э���"},
							{"CustomerName","�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},							
							{"OccurTypeName","��������"},
							{"Currency","����"},
							{"BusinessSum","���Э����(Ԫ)"},
							{"Balance","��ȿ��ý��(Ԫ)"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"OperateOrgName","�������"},
						  };

	String sSql =   " select SerialNo,CustomerName,"+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,Balance,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where ManageOrgID ='"+CurOrg.OrgID+"' and ReinforceFlag = '"+sReinforceFlag+"' "+
					" and BusinessType like '5%'";


	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("BusinessType,OccurType,BusinessCurrency,VouchType,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��


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

	String sBtns = "";
	if(sReinforceFlag.equals("010"))
	{
		sBtns = "�������Э��,�������";
	}else if(sReinforceFlag.equals("020"))
	{
		sBtns = "�ͻ�����,ҵ������";
	}

	String sButtons[][] = {
		{(sBtns.indexOf("�������Э��")>=0?"true":"false"),"","Button","�������Э��","�������Э��","NewCreditLine()",sResourcesPath},
		{(sBtns.indexOf("�������")>=0?"true":"false"),"","Button","�������","�������","Finished()",sResourcesPath},
		{(sBtns.indexOf("�ͻ�����")>=0?"true":"false"),"","Button","�ͻ�����","�ͻ�����","CustomerInfo()",sResourcesPath},
		{(sBtns.indexOf("ҵ������")>=0?"true":"false"),"","Button","ҵ������","ҵ������","BusinessInfo()",sResourcesPath},
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
	function NewCreditLine()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			popComp("Customer","/CustomerManage/CustomerView.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.UserID%>&OrgID=<%=CurOrg.OrgID%>","");
		
			//openObject("Customer",sCustomerID,"000");
		}
	}

	/*~[Describe=����ɲ��Ǳ�־;InputParam=��;OutPutParam=��;]~*/
	function Finished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo,"","");
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			self.location.reload();
		}
	}

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
			
			openObject("ReinforceCustomer",sCustomerID,"002");
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
			if(sReinforceFlag=="110") 
			{
				openObject("AfterLoan",sSerialNo,"000");
			}
			else
			{
				openObject("AfterLoan",sSerialNo,"002");
			}
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
