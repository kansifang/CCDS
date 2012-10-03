<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: ����̨����Ϣ�б�
		Input Param:
				SerialNo��������ˮ��
				BookType��̨������ 
				LawCaseType����������
		Output param:
				ObjectNo:������ˮ��
				ObjectType:��������LAWCASE_INFO
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����̨����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
		
	//������������������ˮ�š�̨�����͡��������ͣ�		
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sBookType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BookType"));
	String sLawCaseType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("LawCaseType"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sBookType == null) sBookType = "";
	if(sLawCaseType == null) sLawCaseType = "";
	
	String sObjectType = "LawcaseInfo";
		
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	
	//���ݲ�ͬ��booktype��̨�����ͣ���ʾ��ͬ��ģ��	
 	if (sBookType.equals("010"))	//֧����̨��
		sTempletNo="PaymentList";
	if (sBookType.equals("020"))	//��ǰ��ǫ̈̄��
		sTempletNo="DamageList";
	if (sBookType.equals("026"))	//���ϱ�ǫ̈̄��
		sTempletNo="DamageList";
	if (sBookType.equals("030"))	//����̨��
		sTempletNo="BeforeLawsuitList";
	if (sBookType.equals("040"))	//һ��̨��
		sTempletNo="FirstLawsuitList";
	if (sBookType.equals("050"))	//����̨��
		sTempletNo="SecondLawsuitList";
	if (sBookType.equals("060"))	//����̨��
		sTempletNo="LastLawsuitList";
	if (sBookType.equals("070"))	//ִ��̨��
		sTempletNo="EnforceLawsuitList";
	if (sBookType.equals("080"))	//�Ʋ�̨��
		sTempletNo="BankruptcyList";
	if (sBookType.equals("065"))	//��̨֤��
		sTempletNo="ArbitrateList";
	if (sBookType.equals("068"))	//�ٲ�̨��
		sTempletNo="NotarizationList";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);	 //���ùؼ���
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ
	
	//��������¼���Ҫ����ı�
	String sTableName = "LAWCASE_INFO";
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sSerialNo+","+sBookType);

	//Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
	//out.println("----"+doTemp.SourceSql);
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
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"false","","Button","���Ʋ�����","���Ʋ�����һ����¼","copyThis()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}		
		};
	if(sLawCaseType.equals("01"))
	{
		sButtons[2][0] = "true";
	}	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseBookInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sSerialNo%>&LawCaseType=<%=sLawCaseType%>&BookType=<%=sBookType%>&SerialNo=","right","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���̨�ʱ�š������Ż򰸼���š��������͡�̨������
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		var sBookType=getItemValue(0,getRow(),"BookType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseBookInfo.jsp?SerialNo="+sSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&LawCaseType=<%=sLawCaseType%>&BookType="+sBookType+"","right","");
	}
	
	function copyThis()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));
			return;
		}
		sReturn = RunMethod("BadBizManage","CopyCaseBook",sSerialNo);
		if(typeof(sReturn)!="undefined" && sReturn.length!=0)
		{
			alert("���Ƴɹ�");
			reloadSelf();
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
