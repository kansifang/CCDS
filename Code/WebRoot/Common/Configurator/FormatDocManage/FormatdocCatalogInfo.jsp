<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   fhuang 2007-01-04
		Tester:
		Content:    ��ʽ������ģ����Ϣ����
		Input Param:
                    DocID��    ��ʽ�����鱨����
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
	String sSql = "";
	
	//����������	
	String sDocID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocID"));
	if(sDocID == null) sDocID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
			{"DocID","�ĵ����"},
			{"DocName","�ĵ�����"},
			{"Attribute1","����һ"},
			{"Attribute2","���Զ�"},
			{"Attribute3","������"},
			{"Attribute4","������"},
			{"OrgID","�������"},
			{"OrgName","��������"},
			{"UserID","��Ա���"},
			{"UserName","��Ա����"},
			{"InputDate","��������"},
			{"UpdateDate","��������"}
		};

	sSql = "Select "+
			"DocID,"+
			"DocName,"+
			"Attribute1,"+
			"Attribute2,"+
			"Attribute3,"+
			"Attribute4,"+
			"OrgID,"+
			"getOrgName(OrgID) as OrgName,"+
			"UserID,"+
			"getUserName(UserID) as UserName,"+
			"InputDate,"+
			"UpdateDate "+
			"From FormatDoc_Catalog "+
			"where DocID='"+sDocID+"' ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Catalog";
	doTemp.setKey("DocID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DocID"," style={width:60px} ");
	doTemp.setHTMLStyle("DocName"," style={width:180px} ");
	doTemp.setHTMLStyle("OrgName","style={width:250px}");		
	doTemp.setEditStyle("Attribute1,Attribute2,Attribute3,Attribute4","3");
	doTemp.setRequired("DocID,DocName",true);   //������
	doTemp.setVisible("OrgID,UserID",false);
	doTemp.setUpdateable("OrgName,UserName",false);
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);
	//���ù��ø�ʽ

	//filter��������
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDocID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
		{"true","","Button","����","����","saveRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn('Y');");        
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sDocID = getItemValue(0,getRow(),"DocID");
        parent.sObjectInfo = sDocID+"@"+sIsRefresh;
		parent.closeAndReturn();
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
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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
