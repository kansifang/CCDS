<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    ���񱨱��¼��Ϣ����
		Input Param:
                    TypeNo��    �����¼���
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
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	if(sTypeNo==null) sTypeNo="";

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders = {
			{"TypeNo","���ͱ�ţ����ã�"},
			{"SortNo","������"},
			{"TypeName","��������"},
			{"IsInUse","�Ƿ���Ч"},
			{"TypesortNo","�������"},
			{"SubtypeCode","������"},
			{"InfoSet","��Ϣ����"},
			{"DisplayTemplet","��Ӧ����ʾģ��"},
			{"Attribute1","����1"},
			{"Attribute2","����2"},
			{"Attribute3","����3"},
			{"Attribute4","����4"},
			{"Attribute5","����5"},
			{"Attribute6","����6"},
			{"Attribute7","����7"},
			{"Attribute8","����8"},
			{"Attribute9","����9"},
			{"Attribute10","����10"},
			{"Remark","��ע"},
			{"ApplyDetailNo","Ӧ�����Ժ�"},
			{"ApproveDetailNo","�������Ժ�"},
			{"ContractDetailNo","��ͬ���Ժ�"},
			{"InputUserName","�Ǽ���"},
			{"InputUser","�Ǽ���"},
			{"InputOrgName","�Ǽǻ���"},
			{"InputOrg","�Ǽǻ���"},
			{"InputTime","�Ǽ�ʱ��"},
			{"UpdateUserName","������"},
			{"UpdateUser","������"},
			{"UpdateTime","����ʱ��"},
			{"Attribute11","����11"},
			{"Attribute12","����12"},
			{"Attribute13","����13"},
			{"Attribute14","����14"},
			{"Attribute15","����15"},
			{"Attribute16","����16"},
			{"Attribute17","����17"},
			{"Attribute18","����18"},
			{"Attribute19","����19"},
			{"Attribute20","����20"},
			{"Attribute21","����21"},
			{"Attribute22","����22"},
			{"Attribute23","����23"},
			{"Attribute24","����24"},
			{"Attribute25","����25"},
		};
	sSql = "select "+
			"TypeNo,"+
			"SortNo,"+
			"TypeName,"+
			"IsInUse,"+
			"TypesortNo,"+
			"SubtypeCode,"+
			"InfoSet,"+
			"DisplayTemplet,"+
			"Attribute1,"+
			"Attribute2,"+
			"Attribute3,"+
			"Attribute4,"+
			"Attribute5,"+
			"Attribute6,"+
			"Attribute7,"+
			"Attribute8,"+
			"Attribute9,"+
			"Attribute10,"+
			"Remark,"+
			"ApplyDetailNo,"+
			"ApproveDetailNo,"+
			"ContractDetailNo,"+
			"getUserName(InputUser) as InputUserName,"+
			"InputUser,"+
			"getOrgName(InputOrg) as InputOrgName,"+
			"InputOrg,"+
			"InputTime,"+
			"getUserName(UpdateUser) as UpdateUserName,"+
			"UpdateUser,"+
			"UpdateTime,"+
			"Attribute11,"+
			"Attribute12,"+
			"Attribute13,"+
			"Attribute14,"+
			"Attribute15,"+
			"Attribute16,"+
			"Attribute17,"+
			"Attribute18,"+
			"Attribute19,"+
			"Attribute20,"+
			"Attribute21,"+
			"Attribute22,"+
			"Attribute23,"+
			"Attribute24,"+
			"Attribute25 "+
		"from BUSINESS_TYPE Where TypeNo = '"+sTypeNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_TYPE";
	doTemp.setKey("TypeNo",true);
	doTemp.setHeader(sHeaders);

 	doTemp.setRequired("TypeNo,SortNo,TypeName",true);

	doTemp.setDDDWCode("IsInUse","IsInUse");

	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Remark",120);
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");
 	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setReadOnly("InputUser,UpdateUser,InputOrg,InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTypeNo);
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
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndBack()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
		// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д���{"true","","Button","����","���ش����б�","doReturn('N')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
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
		sObjectNo = getItemValue(0,getRow(),"TypeNo");
	        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
	        OpenComp("BizTypeInfo","/Common/Configurator/BizTypeManage/BizTypeInfo.jsp","","_self","");
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
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
