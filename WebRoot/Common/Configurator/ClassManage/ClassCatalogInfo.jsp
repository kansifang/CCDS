<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content:    ���񱨱��¼��Ϣ����
			Input Param:
	                    ClassName��    �����¼���
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
		String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSortNo; //������
	String sDiaLogTitle;
	
	//����������	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassName"));
	String sClassDescribe =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassDescribe"));
	if(sClassName==null)
	{
		sClassName="";
		sDiaLogTitle = "�� ������ ��";
	}
	else
	{
		sDiaLogTitle = "��"+sClassDescribe+"����������"+sClassName+"���鿴�޸�����";	
	}
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
		{"ClassName","������"},
		{"ClassType","�����"},
		{"ClassDescribe","������"},
		{"ParentClass","��������"},
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

	String sSql = " Select  ClassName,"+
		"ClassType,"+
		"ClassDescribe,"+
		"ParentClass,"+
		"Remark,"+
		"getUserName(InputUser) as InputUserName,"+
		"InputUser,"+
		"getOrgName(InputOrg) as InputOrgName,"+
		"InputOrg,"+
		"InputTime,"+
		"getUserName(UpdateUser) as UpdateUserName,"+
		"UpdateUser,"+
		"UpdateTime "+
		"From CLASS_CATALOG " +
		"Where ClassName= '" + sClassName +"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CLASS_CATALOG";
	doTemp.setKey("ClassName",true);
	doTemp.setHeader(sHeaders);
	//������
   	doTemp.setRequired("ClassName,ClassDescribe",true);

	doTemp.setHTMLStyle("ClassName"," style={width:160px} ");
	doTemp.setHTMLStyle("ClassType"," style={width:100px} ");
	doTemp.setHTMLStyle("ClassDescribe"," style={width:300px} ");
	doTemp.setHTMLStyle("ParentClass"," style={width:160px} ");
	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");

	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Remark",120);
 	doTemp.setLimit("ClassType",16);
 	doTemp.setLimit("ParentClass",60);
	doTemp.setReadOnly("InputUser,UpdateUser,InputOrg,InputTime,UpdateTime",true);
 
 	if (sClassName != "")	doTemp.setReadOnly("ClassName",true);
 
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	String sCriteriaAreaHTML = "";
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
			{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
			{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
		        // Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","���ش����б�","doReturn('Y')",sResourcesPath}
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
	function saveRecord()
	{
			if(!checkName())
			{
				alert("������������ѱ�ʹ�ã�");
				return;
			}
	        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","");
	}
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
			if(!checkName())
			{
				alert("������������ѱ�ʹ�ã�");
				return;
			}
	        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","doReturn('Y');");
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
			if(!checkName())
			{
				alert("������������ѱ�ʹ�ã�");
				return;
			}
	        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","newRecord()");
	}

     /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ClassName");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
	
	function checkName(){
		sClassName = getItemValue(0,getRow(),"ClassName");
		sReturn=RunMethod("PublicMethod","GetColValue","ClassName,CLASS_CATALOG,String@ClassName@"+sClassName);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				return false;
			}
			 return true;
	}
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
	        OpenComp("ClassCatalogInfo","/Common/Configurator/ClassManage/ClassCatalogInfo.jsp","","_self","");
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
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
 	setDialogTitle("<%=sDiaLogTitle%>");   
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
