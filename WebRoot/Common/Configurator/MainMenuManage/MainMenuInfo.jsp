<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cyyu 2009-03-23
			Tester:
			Content:  ���˵���Ŀ��Ϣ����
			Input Param:
	                    ItemNo��    �������
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
		String PG_TITLE = "Ӧ��"; // ��������ڱ��� <title> PG_TITLE </title>
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
	
	//����������	
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));
	if(sItemNo==null) sItemNo="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
	{"CodeNo","������"},
	{"ItemNo","��Ŀ���"},
	{"ItemName","��Ŀ����"},
	{"SortNo","�����"},
	{"IsInUse","�Ƿ����"},
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
	{"HelpText","����"},
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
	
	sSql = 	" select CodeNo,ItemNo,ItemName,SortNo,IsInUse," +
	" ItemDescribe,ItemAttribute,RelativeCode," +
	" Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8," +
	" HelpText,Remark," + 
	" getUserName(InputUser) as InputUserName,InputUser," + 
	" getOrgName(InputOrg) as InputOrgName,InputOrg," +
	" getUserName(UpdateUser) as UpdateUserName,UpdateUser," +
	" InputTime,UpdateTime " +
	" from CODE_LIBRARY " +
	" where CodeNo='MainMenu' " + 
	" and ItemNo='" + sItemNo + "'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CODE_LIBRARY";
	doTemp.setKey("CodeNo,ItemNo",true);
	doTemp.setHeader(sHeaders);
	
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setUnit("RelativeCode"," <input class=\"inputdate\" type=button value=\"...\" onClick=parent.selectRight()> ");
	doTemp.setReadOnly("RelativeCode,InputUserName,InputOrgName,UpdateUserName,InputTime,UpdateTime",true);
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
	
  	doTemp.setVisible("CodeNo,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8,InputUser,UpdateUser,InputOrg",false);    	
	doTemp.setDDDWCode("IsInUse","IsInUse");
 	doTemp.setEditStyle("ItemDescribe,HelpText,Remark","3");
 	doTemp.setDefaultValue("IsInUse","1");
 	doTemp.setRequired("ItemNo,SortNo,IsInUse,RelativeCode",true);

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
			{"true","","Button","����","���ش����б�","doReturn()",sResourcesPath}
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
    var sCurItemID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		setItemValue(0,0,"CodeNo","MainMenu");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","doReturn();");
	}
    
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function doReturn(){
		OpenPage("/Common/Configurator/MainMenuManage/MainMenuList.jsp","_self","");
	}
    
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	
	function selectRight()
	{
		sItemNo = getItemValue(0,getRow(),"ItemNo");
		sItemName = getItemValue(0,getRow(),"ItemName");
		sRelativeCode = getItemValue(0,getRow(),"RelativeCode");
		sReturn = PopComp("SelectRoleRight","/Common/Configurator/MainMenuManage/UserRoleList.jsp","ItemNo="+sItemNo+"&ItemName="+sItemName+"&RelativeCode="+sRelativeCode,"");
		if(typeof(sReturn) != "undefind" && sReturn.length != 0)
		{
			setItemValue(0,getRow(),"RelativeCode",sReturn);
		}
	}
	
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
