<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/09/25
		Tester:
		Describe: ��ծ�ʲ��ճ���ع����̵�����б�;
			
		Input Param:
			ObjectNo�����ʵ�ծ���
			DealType:��ͼ�ڵ��
		Output Param:
			SerialNo: ������ˮ�����͡�
			DealType:��ͼ�ڵ��
		HistoryLog:
				
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ��ճ���ع����̵�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
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

	//���ҳ�����:������ˮ��,��ͼ��ʶ,��������

	//����������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	//����ֵת��Ϊ�ַ���
	if(sObjectNo == null) sObjectNo="";
	if(sDealType == null) sDealType="";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	
							{"SerialNo","�̵������"},
							{"ObjectNo","���ʵ�ծ���"},
							{"ReportDate","��������"},
							{"OperateUserName","������"},
							{"OperateOrgName","�������"}
						  };

	String sSql =   " select SerialNo,ObjectNo,ReportDate,"+
					" FinishDate,"+
					" OperateUserID,getUserName(OperateUserID) as OperateUserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName "+
					" from ASSET_REPORT "+
					" where ReportType='020' and ObjectNo='"+sObjectNo+"' ";
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//��������,�ɸ��±�
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "ASSET_REPORT";
	
	//���ò��ɼ���
	doTemp.setVisible("FinishDate,OperateUserID,SerialNo,OperateOrgID",false);
	//����html��ʽ
	//doTemp.setHTMLStyle(""," style={width:150px} ");
	
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
		{"false","","Button","����","����","newRecord()",sResourcesPath},
		{"true","","Button","����","����","viewAndEdit()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		{"true","","Button","����","����","go_Back()",sResourcesPath}
    };
	//���ݲ�ͬ��ͼ��ʾ��ť
	if(sDealType.equals("020020010"))
	
	{
		sButtons[getBtnIdxByName(sButtons,"����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"ɾ��")][0]="true";
	}
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
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/LiquidateReportInfo.jsp?ObjectNo=<%=sObjectNo%>&DealType=<%=sDealType%>","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sFinishDate = getItemValue(0,getRow(),"FinishDate");//���ʱ��(���ڼ�¼�Ƿ���Ч)
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(typeof(sFinishDate)!="undefined" && sFinishDate.length!=0)
		{
			alert("����Ч,����ɾ��!");//��ѡ��һ����Ϣ��
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
		sFinishDate = getItemValue(0,getRow(),"FinishDate");//���ʱ��(���ڼ�¼�Ƿ���Ч)
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/LiquidateReportInfo.jsp?FinishDate="+sFinishDate+"&SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&DealType=<%=sDealType%>","_self","");
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
