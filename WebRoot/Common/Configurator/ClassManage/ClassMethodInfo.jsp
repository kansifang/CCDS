<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content:    �༰������¼��Ϣ����
			Input Param:
	                    ClassName��    ������
	                    MethodName��   ��������
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
	String sSql;
	String sSortNo; //������
	String sDiaLogTitle;
	
	//����������	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassName"));
	String sMethodName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("MethodName"));
	String sClassDescribe =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassDescribe"));
	if(sClassName==null) sClassName="";
	if(sClassName==null) sClassName="";
	if(sMethodName==null) sMethodName="";
	if (sClassName.equals(""))
	{
		sDiaLogTitle = "�� �����·����������� ��";	
	}
	else
	{
		if(sMethodName.equals(""))
		{
	sDiaLogTitle = "����"+sClassDescribe+"��["+ sClassName +"]��������������";
		}
		else
		{
	sDiaLogTitle = "����"+sClassDescribe+"��["+ sClassName +"]���ġ� "+sMethodName+" �������鿴�޸�����";
		}
	}
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders={
		{"CLASSNAME","������"},
		{"METHODNAME","��������"},
		{"METHODTYPE","��������"},
		{"METHODDESCRIBE","��������"},
		{"RETURNTYPE","����ֵ����"},
		{"METHODARGS","��������"},
		{"METHODCODE","����ʵ�ִ���"},
		{"REMARK","��ע"},
		{"INPUTUSERNAME","�Ǽ���"},
		{"INPUTUSER","�Ǽ���"},
		{"INPUTORGNAME","�Ǽǻ���"},
		{"INPUTORG","�Ǽǻ���"},
		{"INPUTTIME","�Ǽ�ʱ��"},
		{"UPDATEUSERNAME","������"},
		{"UPDATEUSER","������"},
		{"UPDATETIME","����ʱ��"},
		};

	sSql = "select "+
	"CLASSNAME,"+
	"METHODNAME,"+
	"METHODTYPE,"+
	"METHODDESCRIBE,"+
	"RETURNTYPE,"+
	"METHODARGS,"+
	"METHODCODE,"+
	"REMARK,"+
	"getUserName(INPUTUSER) as INPUTUSERNAME,"+
	"INPUTUSER,"+
	"getOrgName(INPUTORG) as INPUTORGNAME,"+
	"INPUTORG,"+
	"INPUTTIME,"+
	"getUserName(UPDATEUSER) as UPDATEUSERNAME,"+
	"UPDATEUSER,"+
	"UPDATETIME "+
	"from CLASS_METHOD where ClassName='"+sClassName+"' and MethodName='"+sMethodName+"'";

	ASDataObject doTemp = new ASDataObject(sSql);

	doTemp.UpdateTable="CLASS_METHOD";
	doTemp.setKey("CLASSNAME,METHODNAME",true);
	doTemp.setHeader(sHeaders);

 	doTemp.setHTMLStyle("METHODDESCRIBE,METHODARGS"," style={width:300px} ");
 	doTemp.setEditStyle("METHODCODE","3");
 	doTemp.setHTMLStyle("METHODCODE"," style={height:300px;width:400px;} ");

 	doTemp.setHTMLStyle("INPUTORG"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTTIME,UPDATETIME"," style={width:130px} ");
	doTemp.setEditStyle("REMARK","3");
	doTemp.setHTMLStyle("REMARK"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("REMARK",120);
	doTemp.setReadOnly("INPUTUSER,UPDATEUSER,INPUTORG,INPUTUSERNAME,UPDATEUSERNAME,INPUTORGNAME,INPUTTIME,UPDATETIME",true);

	doTemp.setDDDWCodeTable("RETURNTYPE","Number,Number,String,String,Number[],Number[],String[],String[]");
	doTemp.setDDDWCode("METHODTYPE","MethodType");
	doTemp.setRequired("CLASSNAME",true);

	if (!sClassName.equals("")) 
	{
		doTemp.setVisible("CLASSNAME",false);    	
	   	doTemp.setRequired("CLASSNAME",false);
	}
	doTemp.setVisible("INPUTUSER,INPUTORG,UPDATEUSER",false);    	
	doTemp.setUpdateable("INPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);
	//������
   	doTemp.setRequired("METHODNAME",true);
   	doTemp.setRequired("METHODDESCRIBE",true);

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
			{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
			{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
			// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","���ش����б�","doReturn('N')",sResourcesPath}
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
	        setItemValue(0,0,"UPDATEUSER","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","doReturn('Y');");
        
	}
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
	        setItemValue(0,0,"UPDATEUSER","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","newRecord()");
	}

    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CLASSNAME");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
	        sClassName = getItemValue(0,getRow(),"CLASSNAME");
	        OpenComp("ClassMethodInfo","/Common/Configurator/ClassManage/ClassMethodInfo.jsp","ClassName="+sClassName,"_self","");
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
			if ("<%=sClassName%>" !="") 
			{
				setItemValue(0,0,"CLASSNAME","<%=sClassName%>");
			}
			setItemValue(0,0,"INPUTUSER","<%=CurUser.UserID%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.UserName%>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"INPUTTIME","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.UserID%>");
			setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.UserName%>");
			setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
			
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
