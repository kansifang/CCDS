<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: ��ͬ���½��
		Input Param:
			ObjectType: �׶α��
			ObjectNo��ҵ����ˮ��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ���½��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//���ҳ�����

	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	String sHeaders[][] = 	{
								{"CustomerName","�ͻ�����"},
								{"SerialNo","�����ˮ��"},
								{"RelativeSerialNo1","��س�����ˮ��"},
								{"Currency","����"},
								{"BusinessSum","���"},
								{"OccurDate","��������"},
								{"OperateOrgName","�������"},
			      			};


	String sSql =   " select"+
					" CustomerID,CustomerName,"+
					" SerialNo,"+
					" RelativeSerialNo1,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,OccurDate,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from  BUSINESS_DUEBILL "+
					" where RelativeSerialNo2='"+sObjectNo+"'  ";
					

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,BusinessCurrency,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum","3");
	doTemp.setCheckFormat("BusinessSum","2");
	
	//����html��ʽ
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency,OccurDate"," style={width:80px} ");

	//����datawindow
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
	String sButtons[][] = {
			{"true","","Button","����","�鿴ҵ������","viewAndEdit()",sResourcesPath},
			{(CurUser.hasRole("0ZZ")?"true":"false"),"","Button","���������ͬ","�����ݵĹ�����ͬ","ChangeContract()",sResourcesPath}
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
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else 
		{
			openObject("BusinessDueBill",sSerialNo,"002");
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=�����ݵĹ�����ͬ;InputParam=��;OutPutParam=��;]~*/
	function ChangeContract()
	{
		//�����ˮ�š�ԭ��ͬ��š��ͻ����
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sOldContractNo   = "<%=sObjectNo%>";
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else 
		{
			sParaString = "SerialNo"+","+sOldContractNo+",CustomerID"+","+sCustomerID;	
			sContractNo = setObjectValue("SelectChangeContract",sParaString,"",0,0,"");
			if (!(sContractNo=='_CANCEL_' || typeof(sContractNo)=="undefined" || sContractNo.length==0 || sContractNo=='_CLEAR_' || sContractNo=='_NONE_'))
			{
				if(confirm(getBusinessMessage('487'))) //ȷʵҪ�����ݵĹ�����ͬ��
				{
					sContractNo = sContractNo.split('@');
					sContractSerialNo = sContractNo[0];					
					var sReturn = PopPage("/InfoManage/DataInput/ChangeContractAction.jsp?ContractNo="+sContractSerialNo+"&DueBillNo="+sSerialNo+"&OldContractNo="+sOldContractNo,"","");
					if(sReturn == "true")
					{
						alert("��ͬ��"+sOldContractNo+"���µĽ�ݡ�"+sSerialNo+"���Ѿ��ɹ��������ͬ��"+sContractNo+"����!");
						reloadSelf();
					}
				}					
			}			 	
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

<%@	include file="/IncludeEnd.jsp"%>
