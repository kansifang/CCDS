<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: XWu 2004-11-29
*	Tester:
*	Describe: ծȨ�ò���¼����;
*	Input Param:
*		ObjectType:��������															
*		ObjectNo  :��ͬ���
*	Output Param:     
*        	SerialNo  :��ͬ��ˮ��
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ծȨ�ò���¼����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sEditRight;

	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); //��������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));     //��ͬ���
	//���ҳ�����
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	
				{"SerialNo","��ˮ��"},
				{"ApproveNo","ծȨ�ò���׼��"},
				{"ConcedeDate","ծȨ�ò�����"},
				{"ConcedeReason","ծȨ�ò�����"},
				{"ConcedeBasicFile","�ò������ļ�"},
				{"ConcedeCorpusSum","ծȨ�ò�������(Ԫ)"},
				{"ConcedeInterestSum","ծȨ�ò���Ϣ���(Ԫ)"},
				{"ApprovePerson","������"},
				{"OperateUserName","������"},
				};
	
	String sSql = " Select SerialNo, " +
				" ApproveNo, " +	
				" ConcedeDate, " +	
				" getItemName('ConcedeReason',ConcedeReason) as ConcedeReason, " +	
				" getItemName('ConcedeBasicFile',ConcedeBasicFile) as ConcedeBasicFile, " +	
				" ConcedeCorpusSum, " +	
				" ConcedeInterestSum, " +	
				" ApprovePerson, " +	
				" getUserName(OperateUserID) as OperateUserName,InputDate" +	
				" from CONCEDE_INFO " +
				" Where ObjectNo = '"+sObjectNo+"' order by InputDate desc";	  

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,InputDate",false);
	
	doTemp.UpdateTable = "CONCEDE_INFO";

	doTemp.setType("ConcedeCorpusSum,ConcedeInterestSum","Number");
	//����
	doTemp.setAlign("ConcedeCorpusSum,ConcedeInterestSum,ConcedeSumRat","3");
	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("ConcedeCorpusSum,ConcedeInterestSum,ConcedeSumRate","2");
	//����
	doTemp.setAlign("ConcedeDate,UpToDate,InputDate,UpdateDate","2");
	doTemp.setHTMLStyle("ConcedeCorpusSum,ConcedeInterestSum,ConcedeSumRate"," style={width:125px} ");
	doTemp.setHTMLStyle("ConcedeBasicFile"," style={width:160px} ");
	doTemp.setHTMLStyle("ApproveNo,ConcedeReason"," style={width:90px} ");
	doTemp.setHTMLStyle("ConcedeDate"," style={width:80px} ");
	doTemp.setHTMLStyle("ApprovePerson,OperateUserName"," style={width:50px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);  //��������ҳ

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
		{"true","","Button","����","�����ͻ�����ծȯ��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴�ͻ�����ծȯ��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ͻ�����ծȯ��Ϣ","deleteRecord()",sResourcesPath},
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
		sObjectNo = "<%=sObjectNo%>";
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/ConsessionInfo.jsp?ObjectNo="+sObjectNo,"_self","");
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
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/ConsessionInfo.jsp?SerialNo="+sSerialNo,"_self","");
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

<%@include file="/IncludeEnd.jsp"%>
