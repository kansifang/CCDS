<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: wwhe	2008-04-19
			Tester:
			Describe: ��Ȩ��������
			Input Param:
					ObjectNo:	��Ȩ�������
					MethodType:	������������
			Output Param:
			HistoryLog: 
				 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "��Ȩ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	ASResultSet rs = null;//--��ѯ�����
	String sSql = "";
	
	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sMethodType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MethodType"));
	String sMethodName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MethodName"));
	
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sMethodType == null) sMethodType = "";
	if(sMethodName == null) sMethodName = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"ObjectNo","��Ȩ�������"},
						{"MethodType","������������"},
						{"MethodDescribe","��������˵��"},
						{"ClassName","�����෽������"},
						{"MethodName","�����෽��������"},
						{"MethodStatus","״̬"},
						{"InputDate","�Ǽ�����"},
						{"Remark","��ע"},
						{"InputOrgName","¼�����"},
						{"InputUserName","¼����Ա"}
		   				};		   		
		
		sSql =  " select SerialNo,ObjectNo,MethodType,MethodDescribe,ClassName,MethodName,MethodStatus, "+
		" InputDate,InputOrgID,InputUserID, "+
		" getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,Remark"+
		" from AUTHORIZE_METHOD "+
		" where ObjectNo = '"+sObjectNo+"' "+
		" and MethodName = '"+sMethodName+"' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		
		doTemp.UpdateTable = "AUTHORIZE_METHOD";
		doTemp.setKey("SerialNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName",false);
		//doTemp.setDDDWCode("MethodType","AuthorizeMethodType");
		doTemp.setDDDWSql("MethodType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AuthorizeMethodType' and ItemNo <> '01'");
		doTemp.setDDDWCode("MethodStatus","IsInUse");
		doTemp.setDDDWSql("MethodName","select MethodName,MethodName from Class_Method where ClassName = '��Ȩ����'");
		doTemp.setReadOnly("SerialNo,ObjectNo,ClassName,InputDate,InputOrgName,InputUserName",true);
		doTemp.setVisible("SerialNo,InputOrgID,InputUserID,MethodType",false);
		doTemp.setRequired("ClassName,MethodName,MethodStatus",true);
		doTemp.setCheckFormat("InputDate","3");
		doTemp.setEditStyle("Remark,MethodDescribe","3");
		doTemp.setHTMLStyle("Remark,MethodDescribe"," style={height:100px;width:400px} ");
		doTemp.setHTMLStyle("ClassName,MethodName","style={width:200px}");
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //����ΪGrid���
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/
%>
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
			{"true","","Button","����","������Ϣ","saveRecord()",sResourcesPath},
			{"true","","Button","����","����","goBack()",sResourcesPath}
			};
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{		
		if(bIsInsert){		
			beforeInsert();
		}

		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/AuthorizeManage/AuthorizeControlList.jsp?SerialNo=<%=sObjectNo%>","_self","");
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "AUTHORIZE_METHOD";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "AM";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{	
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"ClassName","��Ȩ����");

			bIsInsert = true;
		}
    }
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
