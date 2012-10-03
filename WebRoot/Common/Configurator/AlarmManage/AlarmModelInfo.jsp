<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   zxu 2005-06-01
		Tester:
		Content:    Ԥ��ģ������
		Input Param:
                    AlarmModelID��    ��ʾģ�ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ��ģ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sAlarmModelID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AlarmModelID"));
	if(sAlarmModelID==null) sAlarmModelID="";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
		{"AlarmModelNo","Ԥ��ģ�ͱ��"},
		{"AlarmModelType","Ԥ��ģ������"},
		{"AlarmModelName","Ԥ��ģ������"},
		{"AlarmDescribe","Ԥ��ģ������"},
		{"CheckScript","У��ű�"},
		{"Remark","��ע"},
		{"InputUserName","�Ǽ���"},
		{"InputUser","�Ǽ���"},
		{"InputOrgName","�Ǽǻ���"},
		{"InputOrg","�Ǽǻ���"},
		{"InputTime","�Ǽ�ʱ��"},
		{"UpdateUserName","������"},
		{"UpdateUser","������"},
		{"UpdateTime","����ʱ��"}
	};
	
	sSql =  "select "+
			"AlarmModelNo,"+
			"AlarmModelType,"+
			"AlarmModelName,"+
			"AlarmDescribe,"+
			"CheckScript,"+
			"Remark,"+
			"getUserName(InputUser) as InputUserName,"+
			"InputUser,"+
			"getOrgName(InputOrg) as InputOrgName,"+
			"InputOrg,"+
			"InputTime,"+
			"getUserName(UpdateUser) as UpdateUserName,"+
			"UpdateUser,"+
			"UpdateTime "+
		" from Alarm_MODEL where AlarmModelNo = '"+ sAlarmModelID +"' ";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "Alarm_MODEL";
	doTemp.setKey("AlarmModelNo",true);
	doTemp.setHeader(sHeaders);

 	if( sAlarmModelID.length() == 0 )
		doTemp.setReadOnly("InputUser,UpdateUser,InputOrg,InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	else
		doTemp.setReadOnly("AlarmModelNo,InputUser,UpdateUser,InputOrg,InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);

 	doTemp.setRequired("AlarmModelNo,AlarmModelType,AlarmModelName,CheckScript,EffStatus",true);

 	doTemp.setHTMLStyle("AlarmModelName"," style={width:400px} ");
 	doTemp.setHTMLStyle("AlarmDescribe"," style={width:400px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);

	doTemp.setEditStyle("CheckScript,Remark","3");
	doTemp.setHTMLStyle("CheckScript,Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("CheckScript",1600);
 	doTemp.setLimit("Remark",250);

	doTemp.setDDDWCode("AlarmModelType","AlarmModelType");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAlarmModelID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
		// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","���ش����б�","doReturn('N')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurModelID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndReturn()
	{
 		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
        	as_save("myiframe0","doReturn('Y');");
        
	}
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
 		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
	        as_save("myiframe0","newRecord()");
        
	}

    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"AlarmModelNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sCurModelID = getItemValue(0,getRow(),"AlarmModelNo");
        OpenComp("AlarmModelInfo","/Common/Configurator/AlarmManage/AlarmModelInfo.jsp","","_self","");
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
            	if ("<%=sAlarmModelID%>" !="") 
            	{
            	    	setItemValue(0,0,"AlarmModelNo","<%=sAlarmModelID%>");
            	}
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
			bIsInsert = true;
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
