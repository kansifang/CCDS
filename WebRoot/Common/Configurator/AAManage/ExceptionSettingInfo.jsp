
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:zywei 2005/08/30
			Tester:
			Content: ��������������Ϣҳ��
			Input Param:
		ExceptionID�������ID
		AuthID����Ȩ��ID
			Output param:
			History Log: 

		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "����������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	
	//����������

	//���ҳ�����	
	String sExceptionID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExceptionID"));
	String sAuthID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthID"));
	if(sExceptionID == null) sExceptionID = "";
	if(sAuthID == null) sAuthID = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String[][] sHeaders = {
				{"AuthID","��Ȩ��ID"},
				{"TypeID","��������ID"},
				{"TypeName","��������˵��"},
				{"SortNo","�����"},					
				{"VariableA","����A"},					
				{"VariableB","����B"},		
				{"BizBalanceCeiling","�������ʽ�����ޣ�Ԫ��"},
				{"BizExposureCeiling","�������ʳ�����Ȩ���ޣ�Ԫ��"},
				{"CustBalanceCeiling","�������������Ȩ���ޣ�Ԫ��"},
				{"CustExposureCeilin","��������������Ȩ���ޣ�Ԫ��"},
				{"InterestRateFloor","�����������ޣ�%��"},
				{"IsInUse","�Ƿ����"},
				};
		String sSql = 	" select ExceptionID,AuthID,TypeID,'' as TypeName,VariableA,VariableB,SortNo, "+
				" BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling, "+
				" CustExposureCeilin,InterestRateFloor,IsInUse,InputUser, "+
				" InputTime,UpdateUser,UpdateTime "+
				" from AA_EXCEPTION "+
				" where AuthID = '"+sAuthID+"' "+
				" and ExceptionID = '"+sExceptionID+"' ";	
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.UpdateTable = "AA_EXCEPTION";
		doTemp.setKey("ExceptionID",true);	
		doTemp.setHeader(sHeaders);
		//���ò��ɼ�
		doTemp.setVisible("AuthID,ExceptionID,InputUser,InputTime,UpdateUser,UpdateTime",false);
		//����������
		doTemp.setDDDWCode("IsInUse","YesNo");
		//���ñ�����
		doTemp.setRequired("TypeID,SortNo,IsInUse",true);	
		//���ò��ɸ���
		doTemp.setUpdateable("TypeName",false);
		//����ֻ��
		doTemp.setReadOnly("AuthID,TypeID,TypeName",true);
		//���������������ʽ
		doTemp.setAlign("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin,InterestRateFloor","3");
		doTemp.setCheckFormat("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,InterestRateFloor,CustExposureCeilin","2");
		//�����������͵ĵ���ѡ�񴰿�ģʽ
		doTemp.setUnit("TypeID","<input class=inputdate type=button value=\"...\" onClick=parent.getTypeID()>");

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		session.setAttribute(dwTemp.Name,dwTemp);
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}		
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

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0");
		
	}	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/Common/Configurator/AAManage/ExceptionSettingList.jsp?AuthID=<%=sAuthID%>","_self","");
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
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
		setItemValue(0,0,"InputTime",sNow);
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sNow);
	}	

	/*~[Describe=������������ѡ�񴰿�;InputParam=��;OutPutParam=��;]~*/
	function getTypeID(){
		setObjectValue("SelectExceptionType","","@TypeID@0@TypeName@1",0,0,"");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"AuthID","<%=sAuthID%>");
			bIsInsert = true;
		}
		//�����������ID
		sTypeID = getItemValue(0,getRow(),"TypeID");
		if(typeof(sTypeID) != "undefined" && sTypeID != "") 
		{
			sReturn=RunMethod("PublicMethod","GetColValue","TypeName,AA_EXCEPTIONTYPE,String@TypeID@"+sTypeID);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				sExceptionTypeInfo = sReturn.split('@');
				sTypeName = sExceptionTypeInfo[1];				
				setItemValue(0,getRow(),"TypeName",sTypeName);
			}
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "AA_EXCEPTION";//����
		var sColumnName = "ExceptionID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
