<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: �������Ϣ����
			Input Param:
	                    CodeNo��    �������
	                    ItemNo��    ��Ŀ��ţ������ǲ����룩
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
	String sSql = "";
	String sDiaLogTitle = "";
	String sSortNo = ""; //������
	
	//����������	
	String sCodeNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo"));
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
	String sCodeName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeName"));
	//����ֵת��Ϊ���ַ���
	if(sCodeNo == null) sCodeNo = "";
	if(sItemNo == null) sItemNo = "";
	if(sCodeName == null) sCodeName = "";
	
	if(sCodeNo.equals("")) 
	{
		sDiaLogTitle = "�� ������������� ��";
	}else
	{
		if(sItemNo==null || sItemNo.equals("")) 
		{
	sItemNo="";
	sDiaLogTitle = "��"+sCodeName+"�����룺��"+sCodeNo+"����������";
		}else
		{
	sDiaLogTitle = "��"+sCodeName+"�����룺��"+sCodeNo+"���鿴�޸�����";
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
		{"CodeNo","�����"},
		{"ItemNo","��Ŀ��"},
		{"ItemName","��Ŀ����"},
		{"SortNo","�����"},
		{"IsInUse","��Ч״̬"},
		{"ItemDescribe","��Ŀ����"},
		{"ItemAttribute","��Ŀ����"},
		{"RelativeCode","��������"},
		{"Attribute1","����1"},
		{"Attribute2","����2"},
		{"Attribute3","����3"},
		{"Attribute4","����4"},
		{"Attribute5","����5"},
		{"Attribute6","����6"},
		{"Attribute7","����7"},
		{"Attribute8","����8"},
		{"Remark","��ע"},
		{"HelpText","����"},
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
	"CodeNo,"+
	"ItemNo,"+
	"ItemName,"+
	"SortNo,"+
	"IsInUse,"+
	"ItemDescribe,"+
	"ItemAttribute,"+
	"RelativeCode,"+
	"Attribute1,"+
	"Attribute2,"+
	"Attribute3,"+
	"Attribute4,"+
	"Attribute5,"+
	"Attribute6,"+
	"Attribute7,"+
	"Attribute8,"+
	"Remark,"+
	"HelpText,"+
	"getUserName(InputUser) as InputUserName,"+
	"InputUser,"+
	"getOrgName(InputOrg) as InputOrgName,"+
	"InputOrg,"+
	"InputTime,"+
	"getUserName(UpdateUser) as UpdateUserName,"+
	"UpdateUser,"+
	"UpdateTime "+
	"from CODE_LIBRARY "+
	"Where CodeNo = '" +sCodeNo+"' "+
	"And ItemNo = '"+sItemNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);

	doTemp.UpdateTable="CODE_LIBRARY";
	doTemp.setKey("CodeNo,ItemNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("InputUserName,UpdateUserName,InputOrgName"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:90px} ");
	doTemp.setVisible("InputUser,InputOrg,UpdateUser",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
	//ֻ����
	doTemp.setReadOnly("InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);

	doTemp.setDDDWCode("IsInUse","IsInUse");
 
	doTemp.setHTMLStyle("CodeNo"," style={width:200px} ");
	doTemp.setHTMLStyle("ItemName"," style={width:200px} ");
	doTemp.setHTMLStyle("SortNo,ItemNo"," style={width:200px} ");
	//������
   	doTemp.setRequired("ItemNo,ItemName",true);
	doTemp.setEditStyle("Remark,HelpText,ItemDescribe,ItemAttribute,RelativeCode,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8","3");
	doTemp.setHTMLStyle("Remark,HelpText,ItemDescribe,ItemAttribute,RelativeCode,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8"," style={width:600px;height:100px;overflow:auto} onDBLClick=\"parent.editObjectValueWithScriptEditorForASScript(this)\"");
	if(!sCodeNo.equals("")) 
	{
		doTemp.setVisible("CodeNo",false); 
	}
	else
	{
		doTemp.setRequired("CodeNo",true);
	} 
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateCodeCatalogUpdateTime("+StringFunction.getTodayNow()+","+CurUser.UserID+","+sCodeNo+")");
	
	
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
			{"true","","Button","���沢����","���������","saveAndNew()",sResourcesPath}			
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
	var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=���沢����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function saveAndNew()
	{
		saveRecord("newRecord()");
	}
   
	function newRecord()
	{
        	OpenComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeNo=<%=sCodeNo%>&CodeName=<%=sCodeName%>","_self");
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
			setItemValue(0,0,"CodeNo","<%=sCodeNo%>");
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
