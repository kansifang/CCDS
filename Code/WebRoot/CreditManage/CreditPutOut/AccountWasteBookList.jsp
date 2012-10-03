<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: ��ˮ̨���б�;
		Input Param:
			SerialNo	��ͬ��ˮ��
			ObjectType��010������ˮ
				    	020������ˮ
				    	����ALL ȫ��
		Output Param:
			
		HistoryLog:
		����ObjectType��ALL 2004/12/21  tjy
		slliua:���ݴ�������Ŵ��ࡢ���Ŵ��������ʾ��ť
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ˮ̨���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";

	//���ҳ�����
	
	//����������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//AccountType 01 ���� 02 ����
	String sAccountType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AccountType"));
	if(sObjectNo == null) sObjectNo = "";
	if(sAccountType == null) sAccountType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�б��ͷ
	String sHeaders[][] = { {"SerialNo","������ˮ��"},
							{"OccurDirectionName","̨������"},
							{"RelativeContractNo","��ͬ��ˮ��"},
							{"RelativeSerialNo","�����ˮ��"},							
							{"OccurDate","��������"},
							{"BusinessCCYName","����"},
							{"BackType","���շ�ʽ"},
							{"ActualDebitSum","���Ž��(Ԫ)"},
							{"ActualCreditSum","���ս��(Ԫ)"}
					  };


	if(sAccountType.equals("ALL"))
	{
		sSql =	" select SerialNo,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,"+
				" RelativeContractNo,OccurDate,ActualDebitSum,ActualCreditSum "+
				" from BUSINESS_WASTEBOOK  "+
				" where RelativeContractNo='"+sObjectNo+"' "+
				" order by OccurDate ";
	}else if(sAccountType.equals("01"))
	{
		sSql =	" select SerialNo,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,"+
				" RelativeContractNo,OccurDate,ActualDebitSum "+
				" from BUSINESS_WASTEBOOK  "+
				" where RelativeContractNo='"+sObjectNo+"' "+
				" and OccurDirection='0'  "+
				" order by OccurDate ";
	}else if(sAccountType.equals("02"))
	{
	    String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
		if(sDBName.startsWith("INFORMIX"))
		{
			sSql =	" select SerialNo,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,"+
					" RelativeContractNo,OccurDate,getItemName('ReclaimType',BackType) as BackType,ActualCreditSum "+
					" from BUSINESS_WASTEBOOK  "+
					" where RelativeContractNo='"+sObjectNo+"' "+
					" and OccurDirection='1' "+
					" and (BackType <> '' and BackType is not null) "+
					" order by  OccurDate ";
		}else if(sDBName.startsWith("ORACLE"))
		{
			sSql =	" select SerialNo,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,"+
					" RelativeContractNo,OccurDate,getItemName('ReclaimType',BackType) as BackType,ActualCreditSum "+
					" from BUSINESS_WASTEBOOK  "+
					" where RelativeContractNo='"+sObjectNo+"' "+
					" and OccurDirection='1' "+
					" and (BackType <> ' ' and BackType is not null) "+
					" order by  OccurDate ";
		}else if(sDBName.startsWith("DB2"))
		{
			sSql =	" select SerialNo,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,"+
					" RelativeContractNo,OccurDate,getItemName('ReclaimType',BackType) as BackType,ActualCreditSum "+
					" from BUSINESS_WASTEBOOK  "+
					" where RelativeContractNo='"+sObjectNo+"' "+
					" and OccurDirection='1' "+
					" and (BackType <> '' and BackType is not null) "+
					" order by  OccurDate ";
		}
	}
	//out.println(sSql);

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.UpdateTable = "BUSINESS_WASTEBOOK";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("OccurDirection,BusinessCurrency,OccurType",false);

    //���ý��Ϊ������ʽ
    doTemp.setType("ActualCreditSum,ActualDebitSum","Number");
    doTemp.setCheckFormat("ActualCreditSum,ActualDebitSum","2");
	doTemp.setAlign("ActualCreditSum,ActualDebitSum","3");


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

	String sButtons[][] = {
		{"false","","Button","������ˮ","������ˮ","newRecord()",sResourcesPath},
		{"true","","Button","�鿴����","�鿴����","viewAndEdit()",sResourcesPath},
		{"false","","Button","ɾ����ˮ","ɾ����ˮ","deleteRecord()",sResourcesPath}
		};

	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������ˮ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditPutOut/AccountWasteBookInfo.jsp", "_self","");
	}
	
	/*~[Describe=ɾ����ˮ��Ϣ;InputParam=��;OutPutParam=��;]~*/
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

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sOccurDirection = getItemValue(0,getRow(),"OccurDirection")
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/CreditManage/CreditPutOut/AccountWasteBookInfo.jsp?SerialNo="+sSerialNo, "_self","");
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
