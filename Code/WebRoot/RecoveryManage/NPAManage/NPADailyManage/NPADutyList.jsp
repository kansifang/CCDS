<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: XWu 2004-12-09
*	Tester:
*	Describe: �����϶���¼��Ϣ�б�;
*	Input Param:
*		ObjectType:��������															
*		ObjectNo  :��ͬ���
*	Output Param:     
*		ObjectType:��������															
*		ObjectNo  :��ͬ���
*        	SerialNo  :������ˮ��
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����϶���¼��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); //��������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));     //��ͬ���
	//���ҳ�����
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
   	String sHeaders[][] = {
				{"SerialNo","��¼��"},       
				{"DutyType","�������"},          
				{"DutyAttribute","��������"},     
				{"UndertakerName","����������"},  
				{"BelongOrgName","���������ڻ���"},
				
				{"CognizeOrgName","�����϶�����"},
				{"InputUserName","�Ǽ���"},
				{"InputOrgName","�Ǽǻ���"},
				{"InputDate","�Ǽ�����"}
			       };  

	String sSql = " select  SerialNo,"+
				" getItemName('DutyType',DutyType) as DutyType," +
				" getItemName('DutyAttribute',DutyAttribute) as DutyAttribute," +
				" UndertakerName," +
				" BelongOrgName," +
				" CognizeOrgName," +
				" getUserName(InputUserID) as InputUserName," +	
				" getOrgName(InputOrgID) as InputOrgName," +																																																							
				" InputDate " +																																																								
	       			" from DUTY_INFO " +
	       			" where OBJECTTYPE='"+sObjectType+"' AND objectno='"+sObjectNo+"' order by InputDate desc";
                
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "DUTY_INFO";

	doTemp.setType("ReturnSum","Number");
	
	//����
	doTemp.setAlign("ReturnSum","3");
	
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo",false);
    
	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("ReturnSum","2");
	doTemp.setHTMLStyle("DutyType"," style={width:100px} ");
	doTemp.setHTMLStyle("UndertakerName"," style={width:70px} ");
	doTemp.setHTMLStyle("SerialNo,DutyAttribute,InputUserName,InputDate"," style={width:80px} ");

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
		{"true","","Button","����","���������϶���Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴�����϶���Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ�������϶���Ϣ","deleteRecord()",sResourcesPath},
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
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPADutyInfo.jsp","_self","");
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
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPADutyInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo,"_self","");
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
