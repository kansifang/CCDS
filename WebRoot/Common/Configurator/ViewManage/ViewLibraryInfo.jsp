<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    ���񱨱��¼��Ϣ����
		Input Param:
                    ViewType��    �����¼���
                    ItemNo��   �׶α��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sViewType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewType"));
	String sViewCode =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewCode"));
	if(sViewType==null) sViewType="";
	if(sViewCode==null) sViewCode="";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
		{"ViewType","��ͼ��"},
		{"ViewCode","��ͼ���"},
		{"ViewName","��ͼ����"},
		{"RoleToSee","�ɲ鿴��ɫ"},
		{"OrgToSee","�����ɲ鿴����"},
		{"Attribute1","����һ"},
		{"Attribute2","���Զ�"},
		{"Attribute3","������"},
		{"AllowedShareType","�����΢��Ȩ������"},
		{"RoleToModify","���޸Ľ�ɫ"},
		{"Remark","��ע"},
		{"InputUserName","�Ǽ���"},
		{"InputUser","�Ǽ���"},
		{"InputOrgName","�Ǽǻ���"},
		{"InputOrg","�Ǽǻ���"},
		{"InputTime","�Ǽ�ʱ��"},
		{"UpdateUserName","������"},
		{"UpdateUser","������"},
		{"UpdateTime","����ʱ��"},
	};
	
	sSql =  "select "+
			"ViewType,"+
			"ViewCode,"+
			"ViewName,"+
			"RoleToSee,"+
			"OrgToSee,"+
			"Attribute1,"+
			"Attribute2,"+
			"Attribute3,"+
			"AllowedShareType,"+
			"RoleToModify,"+
			"Remark,"+
			"getUserName(InputUser) as InputUserName,"+
			"InputUser,"+
			"getOrgName(InputOrg) as InputOrgName,"+
			"InputOrg,"+
			"InputTime,"+
			"getUserName(UpdateUser) as UpdateUserName,"+
			"UpdateUser,"+
			"UpdateTime "+
		"from VIEW_LIBRARY Where ViewType = '"+sViewType+"' and ViewCode='"+sViewCode+"' ";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "VIEW_LIBRARY";
	doTemp.setKey("ViewType,ViewCode",true);
	doTemp.setHeader(sHeaders);

	doTemp.setDDDWCode("IsInUse","IsInUse");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
 	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setReadOnly("InputUser,UpdateUser,InputOrg,InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
 	doTemp.setRequired("ViewType,ViewCode",true);

	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Remark",200);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sViewType+","+sViewCode);
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
    var sCurViewType=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndReturn()
	{
 		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn('Y');");
        
	}
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
 		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","newRecord()");
        
	}

    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ViewType");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sViewType = getItemValue(0,getRow(),"ViewType");
        OpenComp("ViewLibraryInfo","/Common/Configurator/ViewManage/ViewLibraryInfo.jsp","ViewType="+sViewType,"_self","");
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
            	if ("<%=sViewType%>" !="") 
            	{
            	    	setItemValue(0,0,"ViewType","<%=sViewType%>");
            	}
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
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
