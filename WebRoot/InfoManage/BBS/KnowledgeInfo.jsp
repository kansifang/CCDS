<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/* 
		Author:   cwliu  2004/12/09
		Tester:
		Content: Ӫ����Ϣ����
		Input Param:
			                ID:��Ϣ���
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ӫ����Ϣ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";
	//����������
	String sCatalogID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sCatalogID == null) sCatalogID = "";
	//���ҳ�����	
	String sID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("ID"));
	if(sID == null) sID = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	String sHeaders[][] = {     
								{"ID","��Ϣ���"},
	                            {"Title","����"},
	                            {"Demo","����"},
				                {"Source","��Դ"},
								{"CatalogName","����"},
				                {"Author","������"},
				                {"CreateDate","��������"},
				                {"ModifiedDate","�޸�����"},
				                {"Hits","�������"},
				                {"Replies","�ظ�����"},
				                {"Body","����"},
				                {"Attribute1","����"},
				                {"Attribute2","������Χ"}
	                       }; 
	sSql = " select ID,CatalogID,getItemName('CatalogID',CatalogID) as CatalogName,"+
		   " ParentID,RootID,Title,Attribute1,Source,Author,Demo," +
	       " Body,CreateDate,ModifiedDate,Hits,Replies  " +
	       " from KNOWLEDGE_CATALOG " +
	       " where ID='"+sID+"'";
	//ͨ����ʾģ�����ASDataObject����doTemp
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "KNOWLEDGE_CATALOG";
	
    doTemp.setKey("ID",true);       
	doTemp.setRequired("Title,Body",true);

	doTemp.setType("Hits,Replies","Number");
	doTemp.setVisible("CatalogID,CatalogName,ID,ParentID,RootID,Hits,Replies,Author",false);
    doTemp.setReadOnly("CatalogName,CreateDate,ModifiedDate",true);
    doTemp.setUpdateable("CatalogName",false);                             
	//��������	                    
	doTemp.setDDDWCode("Attribute1","KnowledgeType");
	doTemp.setHTMLStyle("Title"," style={width:300px}");
	doTemp.setHTMLStyle("CreateDate,ModifiedDate"," style={color:#848284;width:80px} ");
	doTemp.setLimit("Body",800);
	doTemp.setEditStyle("Body","3");
	doTemp.setHTMLStyle("Body"," style={height:150px;width:400px};overflow:scroll} ");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setEvent("AfterInsert","!InfoManage.InsertKnowledgeObjectInfo(#ID,'"+sCatalogID+"')+!InfoManage.InsertBoard(#ID)");
	dwTemp.setEvent("AfterDelete","!InfoManage.DeleteKnowledgeObjectInfo(#ID,'"+sCatalogID+"')+!InfoManage.DeleteBoard(#ID)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","�ϴ��ļ�","�ϴ��ļ�","fileadd()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
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
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	function fileadd()
	{
		sID = getItemValue(0,getRow(),"ID");
	    if(typeof(sID)=="undefined" || sID.length==0) {
			alert("�ȱ�����Ϣ���ϴ��ļ�!");
	        return ;
		}
		popComp("FileAdd","/SystemManage/SynthesisManage/FileAdd.jsp","BoardNo="+sID,"dialogWidth=550px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/InfoManage/BBS/KnowledgeList.jsp","_self","");
	}	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,getRow(),"ModifiedDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CatalogID","<%=sCatalogID%>");
			setItemValue(0,getRow(),"CreateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"ModifiedDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"Hits","0");
			setItemValue(0,getRow(),"Replies","0");
			setItemValue(0,0,"Author","<%=CurUser.UserID%>");
			bIsInsert = true;
		}
		
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "KNOWLEDGE_CATALOG";//����
		var sColumnName = "ID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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
