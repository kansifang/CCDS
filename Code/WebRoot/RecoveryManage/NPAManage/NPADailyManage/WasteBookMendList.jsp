<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/09/17
		Tester:
		Describe: ���ʽ�����б�;
			һ�ʻ�����ˮ��Ӧ��ʲ�����Ϣ
		Input Param:
			ObjectNo��������ˮ��
		Output Param:
			SerialNo: ������ˮ�����͡�

		HistoryLog:
				
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ʽ�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����:������ˮ��,��ͼ��ʶ

	//����������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sObjectNo == null) sObjectNo = "";
	if(sDealType == null) sDealType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"RelativeWasteBookNo","������ˮ��"},
							{"RelativeContractNo","��ͬ��ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"ReturnTypeName","���շ�ʽ"},
							{"ReturnSum","���ս��"},
							{"ReturnDate","��������"},
							{"InputDate","�Ǽ�����"},
						  };

	String sSql =   " select SerialNo,"+
					" RelativeWasteBookNo,RelativeContractNo,"+
					" CustomerID,CustomerName,getItemName('ReturnType',ReturnType) as ReturnTypeName,"+
					" ReturnSum,InputDate "+
					" from BUSINESS_WASTEBOOK_MEND"+
					" where RelativeWasteBookNo='"+sObjectNo+"' ";
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//��������,�ɸ��±�
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "BUSINESS_WASTEBOOK_MEND";
	
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,SerialNo,InputDate",false);
	doTemp.setAlign("ReturnSum","3");
	doTemp.setCheckFormat("ReturnSum","2");
	//����html��ʽ
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	
   //���ɹ�����
	doTemp.setColumnAttribute("RelativeContractNo,CustomerName","IsFilter","1");
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
		{sDealType.equals("020020010")?"true":"false","","Button","�Ǽǻ��ʽ","�Ǽǻ��ʽ","newRecord()",sResourcesPath},
		{"true","","Button","���ʽ����","���ʽ����","viewAndEdit()",sResourcesPath},
		{sDealType.equals("020020010")?"true":"false","","Button","ȡ���Ǽ�","ȡ���Ǽ�","deleteRecord()",sResourcesPath},
		{"true","","Button","����","����","go_Back()",sResourcesPath}
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
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/WasteBookMendInfo.jsp?ObjectNo=<%=sObjectNo%>&DealType=<%=sDealType%>","_self","");
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

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/WasteBookMendInfo.jsp?SerialNo="+sSerialNo+"&DealType=<%=sDealType%>&ObjectNo=<%=sObjectNo%>","_self","");
		}
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function go_Back()
	{
		self.close();
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
