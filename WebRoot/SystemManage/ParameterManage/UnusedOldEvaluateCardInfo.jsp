<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hldu
		Tester:
		Describe: ���������ֿ�ģ�� 
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������ֿ�ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sSql = "";
    String sIsInuse = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = { 
		                     {"CODENO","UnusedOldEvaluateCard"},
                             {"ITEMNO","UnusedOldEvaluateCard"},
	                         {"IsInuse","�Ƿ�ͣ�����õȼ�����(��ģ��)"},
	                         {"inputuser","������"},
	                         {"inputusername","������"},
	                         {"inputorg","���»���"},
	                         {"inputorgname","���»���"},
	                         {"InputTime","�Ǽ�����"},						
	                         {"UpdateTime","����ʱ��"}
			              };

	sSql = " select codeno,itemno,IsInuse,inputuser,getUserName(inputuser) as inputusername,inputorg,getOrgName(inputorg) as inputorgname ,InputTime,UpdateTime from code_library  where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' "	;
	
	//��sSql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ,���±���,��ֵ,������,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.setDefaultValue("CODENO,ITEMNO","UnusedOldEvaluateCard");
	doTemp.UpdateTable = "code_library";
	doTemp.setKey("CODENO,ITEMNO",true);
	doTemp.setVisible("CODENO,ITEMNO,inputuser,inputorg",false);
	doTemp.setUpdateable("inputusername,inputorgname",false);  	
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:80px}");
	doTemp.setReadOnly("inputusername,inputorgname,InputTime,UpdateTime",true);
	doTemp.setRequired("IsInuse",true);
	//����������
	doTemp.setDDDWSql("IsInuse","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'YesNo' ");
    
	//����Ĭ��ֵ
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	sIsInuse = Sqlca.getString(" select IsInuse from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
	if(sIsInuse == null) sIsInuse = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ:
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			//{(sIsInuse.equals("2")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath}
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath}
		};
	if(!sIsInuse.equals("2"))
	{
		sButtons[0][0] = "false";
	}	

	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		beforeUpdate();		
		as_save("myiframe0",sPostEvents);
		reloadSelf();
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
	    sIsInuse = getItemValue(0,getRow(),"IsInuse");// �ŵ�jsp��
	    if(sIsInuse == "1") //ѡ���ǡ� ͣ��ԭ���ֿ�ģ�ͣ����������ֿ�ģ��
	    {
	  		sRetValue = PopPage("/SystemManage/ParameterManage/UnusedOldEvaluateCardAction.jsp?Flag=1","","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(sRetValue=='00'){
				alert("�л��ɹ���");
				reloadSelf();
			}else{
				alert("�л�ʧ�ܣ�");
			}
	    }
	    //����ʱ��
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		//������
		setItemValue(0,0,"inputuser","<%=CurUser.UserID%>");
		setItemValue(0,0,"inputusername","<%=CurUser.UserName%>");	
		//���»���
		setItemValue(0,0,"inputorg","<%=CurOrg.OrgID%>");	
		setItemValue(0,0,"inputorgname","<%=CurOrg.OrgName%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{

         if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"inputuser","<%=CurUser.UserID%>");
			setItemValue(0,0,"inputusername","<%=CurUser.UserName%>");	
			setItemValue(0,0,"inputorg","<%=CurOrg.OrgID%>");	
		    setItemValue(0,0,"inputorgname","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		}
		
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>