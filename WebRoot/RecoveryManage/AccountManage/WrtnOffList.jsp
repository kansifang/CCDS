<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/10/09
		Tester:
		Describe: ̨��ά��������Ϣ�Ǽ��б�;
			
		Input Param:
			ObjectNo����ͬ��ˮ��
			DealType:��ͼ�ڵ��
			RetractType:��������
		Output Param:
			SerialNo: ������ˮ�����͡�
			DealType:��ͼ�ڵ��
		HistoryLog:
				
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "̨��ά��������Ϣ�Ǽ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%

	//������� 

	//���ҳ�����:

	//����������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	String sRetractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RetractType"));
	//����ֵת��Ϊ�ַ���
	if(sObjectNo == null) sObjectNo="";
	if(sDealType == null) sDealType="";
	if(sRetractType == null) sRetractType="";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"RetractDate","��������"},
							{"RetractSum","�����ʽ��ջ�"},
							{"OtherRetractSum","�����ջ�"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputDate","�Ǽǻ���"}
						  };

	String sSql =   " select SerialNo,RelativeContractNo,RetractDate,"+
					" RetractSum,OtherRetractSum,"+
					" InputUserID,getUserName(InputUserID) as InputUserName,"+
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName "+
					" from WRTNOFF_INFO "+
					" where RelativeContractNo='"+sObjectNo+"' and RetractType='"+sRetractType+"' ";
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//��������,�ɸ��±�
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "WRTNOFF_INFO";
	
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,RelativeContractNo,InputUserID,InputOrgID",false);
	//���ý��Ϊ��λһ������
	doTemp.setType("RetractSum,OtherRetractSum","Number");
	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("RetractSum,OtherRetractSum","2");
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("RetractSum,OtherRetractSum","3");
   //���ɹ�����
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
		{"true","","Button","����","����","newRecord()",sResourcesPath},
		{"true","","Button","����","����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
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
		OpenPage("/RecoveryManage/AccountManage/WrtnOffInfo.jsp","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
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
			OpenPage("/RecoveryManage/AccountManage/WrtnOffInfo.jsp?SerialNo="+sSerialNo,"_self","");
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
