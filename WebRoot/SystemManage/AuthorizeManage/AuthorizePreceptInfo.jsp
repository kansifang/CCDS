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
					SerialNo:	��ˮ��
					Type:		Precept(��Ȩ��������)
								Condition(��Ȩ��������)
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
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sType == null) sType = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"SerialNo","��Ȩ�������"},
						{"AuthorizeClass","��Ȩ�������ȼ�"},
						{"AuthorizeName","��Ȩ��������"},
						{"AuthorizeDescribe","��Ȩ��������"},
						{"BeginDate","��������"},
						{"EndDate","�ս�����"},
						{"Remark","��ע"},
						{"InputOrgName","¼�����"},
						{"InputUserName","¼����Ա"},
						{"AuthorizeStatus","��Ȩ״̬"},
						{"InputDate","�Ǽ�����"},
						{"AuthorizeType","��Ȩ����"}
		   				};		   		
		
		sSql =  " select SerialNo,AuthorizeClass,AuthorizeName,AuthorizeDescribe,AuthorizeType,BeginDate,EndDate,AuthorizeStatus,InputOrgID,InputUserID, "+
		" Remark,InputDate,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName "+
		" from AUTHORIZE_ROLE "+
		" where SerialNo = '"+sSerialNo+"' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		
		doTemp.UpdateTable = "AUTHORIZE_ROLE";
		doTemp.setKey("SerialNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName",false);
		doTemp.setReadOnly("SerialNo,InputOrgName,InputUserName,InputDate",true);
		doTemp.setRequired("AuthorizeClass,AuthorizeName,AuthorizeDescribe,BeginDate,EndDate,AuthorizeStatus",true);
		doTemp.setVisible("InputOrgID,InputUserID,AuthorizeType",false);
		doTemp.setCheckFormat("BeginDate,EndDate,InputDate","3");
		doTemp.setEditStyle("Remark,AuthorizeDescribe","3");
		doTemp.setDDDWCode("AuthorizeStatus","IsInUse");
		doTemp.setDDDWCode("AuthorizeType","AuthorizeType");
		doTemp.setHTMLStyle("Remark,AuthorizeDescribe"," style={height:100px;width:400px} ");
		doTemp.setHTMLStyle("AuthorizeName"," style={width:250px} ");
		doTemp.setCheckFormat("AuthorizeClass","5");
		doTemp.setHTMLStyle("AuthorizeClass"," style={width:30px} ");
		
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
			{(sType.equals("Precept")?"true":"false"),"","Button","����","������Ϣ","saveRecord()",sResourcesPath},
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

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/AuthorizeManage/AuthorizePreceptList.jsp","_self","");
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
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "AUTHORIZE_ROLE";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "AR";//ǰ׺

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
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");

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
