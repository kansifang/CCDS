<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   zywei 2006-1-18
			Tester:
			Content: ��ѯ�б���Ϣ����
			Input Param:
		   ObjectType����������
	               RelationShip��������ϵ
	 		Output param:
			                
			History Log: 
	 		
	           
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "��������Tab��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	
	//���ҳ�����	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sRelationShip =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	if(sObjectType == null) sObjectType = "";
	if(sRelationShip == null) sRelationShip = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
		{"ObjectType","��������"},
		{"RelationShip","������ϵ����"},
		{"SortNo","�����"},
		{"DisplayName","��ʾ��������"},
		{"RelaObjectType","����"},
		{"ShowOnTabExpr","չ��Tab���ʽ"},
		{"RelaExpr","չ��Tab����"},
		{"ViewExpr","չ��TabUrl"},				
		{"IsInUse","�Ƿ���Ч"},
		{"Remark","��ע"},
		{"InputUserName","������"},
		{"InputUser","������"},
		{"InputOrgName","�������"},
		{"InputOrg","�������"},
		{"InputTime","����ʱ��"},
		{"UpdateUserName","������"},
		{"UpdateUser","������"},
		{"UpdateTime","����ʱ��"}
	   };  

	String sSql = 	" Select ObjectType,RelationShip,SortNo,DisplayName,RelaObjectType,ShowOnTabExpr, "+
			" RelaExpr,ViewExpr,Attribute1,Attribute2,Attribute3,IsInUse,Remark, "+
			" getUserName(InputUser) as InputUserName,InputUser,InputOrg, "+
			" getOrgName(InputOrg) as InputOrgName,InputTime,UpdateUser, "+
			" getUserName(UpdateUser) as UpdateUserName,UpdateTime "+
			" From OBJECTTYPE_RELA " +
			" Where ObjectType = '" + sObjectType +"' "+
			" and RelationShip = '" + sRelationShip +"' ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="OBJECTTYPE_RELA";
	doTemp.setKey("ObjectType,RelationShip,",true);
	doTemp.setHeader(sHeaders);
	
	doTemp.setDDDWCode("IsInUse","IsInUse");
	doTemp.setHTMLStyle("ShowOnTabExpr,RelaExpr,ViewExpr"," style={width:400px} ");
	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Remark",120);
	doTemp.setReadOnly("InputUserName,InputOrgName,UpdateUserName,InputTime,UpdateTime",true);
 	doTemp.setRequired("ObjectType,RelationShip,SortNo,DisplayName,RelaObjectType,ShowOnTabExpr,RelaExpr,ViewExpr,IsInUse",true);
	doTemp.setVisible("Attribute1,Attribute2,Attribute3,InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
  			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
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
			{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
			{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
    var sCurClassName=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndReturn()
	{
        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn();");        
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
		OpenPage("/Common/Configurator/ObjectManage/ObjTypeRelaList.jsp","_self","");
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{	       
		OpenPage("/Common/Configurator/ObjectManage/ObjTypeRelaInfo.jsp","_self","");
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	function initRow()
	{
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
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
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