<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/12/08
		Tester:
		Describe: ��������ر����б�;
			
		Input Param:
			ObjectNo����ͬ��ˮ��
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
	String PG_TITLE = "��������ر����б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DealType"));
	//����ֵת��Ϊ�ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sDealType == null) sDealType = "";
	//����������
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"CustomerName","�ͻ�����"},
							{"ObjectNo","��ͬ��ˮ��"},
							{"ReportDate","��������"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"}
						  };

	String sSql =   " select SerialNo,ObjectNo,ReportDate,"+
					" CustomerID,CustomerName,FinishDate,"+
					" InputUserID,getUserName(InputUserID) as InputUserName,"+
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName "+
					" from MONITOR_REPORT "+
					" where ObjectNo='"+sObjectNo+"' and ReportType='030' ";
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//��������,�ɸ��±�
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "MONITOR_REPORT";
	
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,FinishDate,InputUserID,SerialNo,InputOrgID",false);
	//����html��ʽ
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	
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
	if(sDealType.equals("020030050010"))
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
			//����������͡�������ˮ��
		sObjectType = "ReformContract";
		sObjectNo = "<%=sObjectNo%>";
		sCompID = "ReformReportCreationInfo";
		sCompURL = "/RecoveryManage/NPAManage/NPADailyManage/ReformReportCreationInfo.jsp";			
		sReturn = popComp(sCompID,sCompURL,"ObjectNo="+sObjectNo+"&DealType=<%=sDealType%>","dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sSerialNo=sReturn[0];
		var sDocID = "13";		
		sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sSerialNo+"&ObjectType="+sObjectType,"","");
		
		if(typeof(sReturn)!='undefined' && sReturn!="")
		{
			sReturnSplit = sReturn.split("?");
			var sFormName=randomNumber().toString();
			sFormName = "AA"+sFormName.substring(2);
			OpenComp("ReformFormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
		}
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sFinishDate = getItemValue(0,getRow(),"FinishDate");//���ʱ��(���ڼ�¼�Ƿ���Ч)
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
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sObjectType = "ReformContract";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			var sDocID = "13";		
			sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");	
			if(typeof(sReturn)!='undefined' && sReturn!="")
			{
				sReturnSplit = sReturn.split("?");
				var sFormName=randomNumber().toString();
				sFormName = "AA"+sFormName.substring(2);
				OpenComp("ReformFormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
			}
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
