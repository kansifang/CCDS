<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   fhuang 2007-01-04
		Tester:
		Content:    ��ʽ�����������Ϣ����
		Input Param:
                    DocID�� ��ʽ�����鱨����
                    OrgID�� ʹ�û���  
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
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sDocID == null) sDocID = "";
	if(sOrgID == null) sOrgID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
			{"OrgID","�������"},
			{"DocID","�ĵ����"},
			{"DocName","�ĵ�����"},
			{"DefaultValue","ȱʡ�ڵ����"},			
			{"Attribute1","����һ"},
			{"Attribute2","���Զ�"},
			{"InputUser","�Ǽ���Ա"},
			{"InputUserName","�Ǽ���Ա"},
			{"InputTime","�Ǽ�ʱ��"},
			{"UpdateUser","������Ա"},
			{"UpdateUserName","������Ա"},
			{"UpdateDate","��������"}
		};

	sSql = "Select "+
			"OrgID,"+
			"DocID,"+
			"DocName,"+
			"DefaultValue,"+
			"Attribute1,"+
			"Attribute2,"+
			"InputUser,"+
			"getUserName(InputUser) as InputUserName,"+
			"InputTime,"+
			"UpdateUser,"+
			"getUserName(UpdateUser) as UpdateUserName,"+
			"UpdateDate "+
			"From FormatDoc_Para "+
			"where DocID='"+sDocID+"' "+
			"and OrgID='"+sOrgID+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.UpdateTable="FormatDoc_Para";
	doTemp.setKey("DocID,OrgID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setDDDWSql("OrgID","select OrgID,OrgName from Org_Info ");
	doTemp.setHTMLStyle("DocID"," style={width:60px} ");
	doTemp.setHTMLStyle("DocName"," style={width:250px} ");
	doTemp.setEditStyle("Attribute1,Attribute2,DefaultValue","3");
	doTemp.setRequired("OrgID,DocID,DocName,DefaultValue",true);   //������
	doTemp.setVisible("InputUser,UpdateUser",false);
	doTemp.setUpdateable("InputUserName,UpdateUserName",false);
	doTemp.setReadOnly("DocID,DocName,InputUserName,UpdateUserName,InputTime,UpdateDate",true);
	doTemp.setUnit("DocName"," <input type=button class=inputdate value=.. onclick=parent.getDocName()>");
	//���ù��ø�ʽ

	//filter��������
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDocID+","+sOrgID);
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
        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
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
	/*~[Describe=������ʽ�������ĵ�����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getDocName()
	{		
		sParaString = "";			
		setObjectValue("SelectFormatDoc",sParaString,"@DocID@0@DocName@1",0,0,"");
	}

	function initRow()
	{

		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
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
