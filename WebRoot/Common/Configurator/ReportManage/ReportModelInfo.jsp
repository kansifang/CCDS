<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    ���񱨱�ģ������
		Input Param:
                    ModelNo��    �����¼���
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���񱨱�ģ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
	//����������	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	String sRowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RowNo"));
	if(sModelNo==null) sModelNo="";
	if(sRowNo==null) sRowNo="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders={
			{"ModelNo","ģ�ͱ��"},
			{"RowNo","�б��"},
			{"RowName","������"},
			{"RowSubject","��Ӧ��Ŀ"},
			{"RowSubjectName","��Ӧ��Ŀ"},
			{"DisplayOrder","��ʾ����"},
			{"RowAttribute","������"},
			{"Col1Def","��1����"},
			{"Col2Def","��2����"},
			{"Col3Def","��3����"},
			{"Col4Def","��4����"},
			{"StandardValue","��׼ֵ"},
			{"DeleteFlag","ɾ����־"},
		};

	sSql = "Select "+
			"RM.ModelNo,"+
			"RM.RowNo,"+
			"RM.RowName,"+
			"RM.RowSubject,"+
			"FI.ItemName as RowSubjectName,"+
			"RM.DisplayOrder,"+
			"RM.RowAttribute,"+
			"RM.Col1Def,"+
			"RM.Col2Def,"+
			"RM.Col3Def,"+
			"RM.Col4Def,"+
			"RM.StandardValue,"+
			"RM.DeleteFlag "+
			" From REPORT_MODEL RM,FINANCE_ITEM FI "+
			" Where RM.RowSubject = FI.ItemNo and RM.ModelNo = '"+sModelNo+"' And RM.RowNo = '"+sRowNo+"' Order by 2";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REPORT_MODEL";
	doTemp.setKey("ModelNo,RowNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setReadOnly("ModelNo",true);

	doTemp.setRequired("RowNo,RowName",true);   //������
	doTemp.setVisible("ModelNo,RowSubject,Col3Def,Col4Def,DeleteFlag",false);
	doTemp.setEditStyle("Col1Def,Col2Def,Col3Def,Col4Def","3");
	doTemp.setHTMLStyle("ModelNo,RowNo,RowSubject,DisplayOrder,StandardValue,DeleteFlag"," style={width:60px} ");
	doTemp.setHTMLStyle("RowName"," style={width:200px} ");
	doTemp.setHTMLStyle("RowAttribute"," style={width:300px} ");
	doTemp.appendHTMLStyle("Col1Def,Col2Def,Col3Def,Col4Def","style={cursor:hand;width=600px;height=100px;overflow:scroll} onDBLClick=\"parent.myDBLClick(this)\"");
	
	doTemp.setUnit("RowSubjectName"," <input type=button class=inputdate value=... onclick=parent.SelectSubject()>");
	doTemp.setReadOnly("RowSubjectName",true);
	doTemp.setUpdateable("RowSubjectName",false);
	
	doTemp.setDDDWCodeTable("DeleteFlag","Y,Y,N,N");
	
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
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
		// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","���ش����б�","doReturn('N')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurModelNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndReturn()
	{
        as_save("myiframe0","doReturn('Y');");
        
	}
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
		as_save("myiframe0","newRecord()");
	}

    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sModelNo = getItemValue(0,getRow(),"ModelNo");
		OpenComp("ReportModelInfo","/Common/Configurator/ReportManage/ReportModelInfo.jsp","ModelNo="+sModelNo,"_self","");
	}

	function myDBLClick(myobj)
	{
		editObjectValueWithScriptEditorForAFS(myobj,'<%=sModelNo%>');
	}

	function openScriptEditorForAFSAndSetText()
	{
		var oMyobj = oTempObj;
		sOutPut = OpenComp("ScriptEditorForAFS","/Common/ScriptEditor/ScriptEditorForAFS.jsp","","");
		if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_")
		{
			oMyobj.value = amarsoft2Real(sOutPut);
		}
	}

	function SelectSubject()
	{		
		setObjectValue("SelectAllSubject","","@RowSubject@0@RowSubjectName@1",0,0,"");			
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
		if ("<%=sModelNo%>" !="") 
		{
			setItemValue(0,0,"ModelNo","<%=sModelNo%>");
		}
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
