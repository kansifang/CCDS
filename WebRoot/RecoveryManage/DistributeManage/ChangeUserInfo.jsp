<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2010/05/30
		Tester:
		Content: �����ʲ������˱��
		Input Param:
			sObjectType  :��������
			sObjectNo    :��������
			sSerialNo    :ȡ��ˮ��
		Output param:

		History Log: 

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ������˱��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	boolean IsAddInfoFlag = false;  //�Ƿ�Ϊ�޸Ļ�������ǣ����в�ͬjsp���ñ�jsp��
	//����������	
	
	//���ҳ�����
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); //��������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); //��ͬ���
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); //��ˮ��
	String sOldUserID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldUserID")); //ԭ�������ID
	String sOldUserName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldUserName")); //ԭ�������
	String sFlag = DataConvert.toRealString(iPostChange,CurPage.getParameter("Flag"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sOldUserID == null) sOldUserID = "";
	if(sOldUserName == null) sOldUserName = "";
	if(sFlag == null) sFlag = "";
	if(sSerialNo.equals("")) IsAddInfoFlag = true;     //��ˮ��Ϊ�գ�����
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ManageChangeUserInfo";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����ѡ���п�
	doTemp.setHTMLStyle("OldUserName,NewUserName,ChangeDate,ChangeUserName,ChangeTime"," style={width:80px} ");
	
	
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","����","���������޸�","mySave()",sResourcesPath},
		};
		
	if(IsAddInfoFlag==false)
	{
		sButtons[0][0]="false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	//���ĺ�ͬ��ȫ���ż���Ա
	function my_ChangeUserAction()
	{
		sRecoverUserID = getItemValue(0,getRow(),"NewUserID");
		sRecoverOrgID = getItemValue(0,getRow(),"NewOrgID");
		var sReturn=RunMethod("PublicMethod","UpdateColValue","@String@RecoverUserID@"+sRecoverUserID+"@String@UserChangeFlag@1,BADBIZ_ACCOUNT,String@SerialNo@<%=sObjectNo%>");
	}
	
	/*~[Describe=����¼�����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function mySave()
	{
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		saveRecord(my_ChangeUserAction())
	}
	
  		
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{		
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		sOldUserID = getItemValue(0,getRow(),"OldUserID");//ԭ������Ա			
		sNewUserID = getItemValue(0,getRow(),"NewUserID");//�ֹ�����Ա
		if(typeof(sOldUserID) != "undefined" && sOldUserID != "" && 
		typeof(sNewUserID) != "undefined" && sNewUserID != "")
		{
			if(sOldUserID == sNewUserID)
			{
				alert("�ֹ����˲�����ԭ��������ͬ��");
				return false;
			}
		}
		return true;
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"OldOrgID","<%=sOldUserID%>");
			setItemValue(0,0,"OldOrgName","<%=sOldUserName%>");
			setItemValue(0,0,"OldUserID","<%=sOldUserID%>");
			setItemValue(0,0,"OldUserName","<%=sOldUserName%>");
			setItemValue(0,0,"ChangeUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"ChangeOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"ChangeUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"ChangeOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"ChangeTime","<%=StringFunction.getToday()%>");
		}
   	}
    	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "MANAGE_CHANGE";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/	
	function getNewUserName()
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectBadBizUser",sParaString,"@NewUserID@0@NewUserName@1@NewOrgID@2",0,0,"");
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
