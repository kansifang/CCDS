<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content:    ���񱨱�Ŀ¼��Ϣ����
			Input Param:
	                    ModelNo��    �����¼���
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
		String PG_TITLE = "���񱨱�Ŀ¼��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
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
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if(sModelNo==null) sModelNo="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders={
	{"MODELNO","ģ�ͱ��"},
	{"MODELNAME","ģ������"},
	{"MODELTYPE","ģ������"},
	{"MODELDESCRIBE","ģ������"},
	{"MODELABBR","ģ����д"},
	{"MODELCLASS","ģ�ͷ���"},
	{"ATTRIBUTE1","ģ������1"},
	{"ATTRIBUTE2","ģ������2"},
	{"DISPLAYMETHOD","��ʾ����"},
	{"HEADERMETHOD","��ͷ����"},
	{"DELETEFLAG","ɾ����־"},
	{"REMARK","��ע"},	
		};

	sSql = "Select "+
	"MODELNO,"+
	"MODELNAME,"+
	"MODELTYPE,"+
	"MODELDESCRIBE,"+
	"MODELABBR,"+
	"MODELCLASS,"+
	"ATTRIBUTE1,"+
	"ATTRIBUTE2,"+
	"DISPLAYMETHOD,"+
	"HEADERMETHOD,"+
	"DELETEFLAG,"+
	"REMARK "+
	" From REPORT_CATALOG Where MODELNO = '"+sModelNo+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REPORT_CATALOG";
	doTemp.setKey("MODELNO",true);
	doTemp.setHeader(sHeaders);

	doTemp.setRequired("MODELNO",true);   //������
	doTemp.setVisible("DELETEFLAG",false);
	doTemp.setHTMLStyle("MODELNO,MODELTYPE,DELETEFLAG"," style={width:60px} ");
	doTemp.setHTMLStyle("MODELDESCRIBE"," style={width:400px} ");
	doTemp.setHTMLStyle("MODELCLASS"," style={width:120px} ");
	doTemp.setHTMLStyle("DISPLAYMETHOD"," style={width:80px} ");
	doTemp.setEditStyle("HEADERMETHOD,REMARK","3");
	doTemp.setHTMLStyle("HEADERMETHOD,REMARK","style={width=400px;height=100px;overflow=scroll}");

	doTemp.setDDDWSql("MODELTYPE","select ItemName,ItemName from CODE_LIBRARY where CodeNo = 'ReportPeriod' order by SortNo");
	doTemp.setDDDWSql("DISPLAYMETHOD","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'DisplayMethod' order by SortNo ");
	doTemp.setDDDWCode("MODELCLASS","FinanceBelong");
	doTemp.setDDDWCodeTable("DELETEFLAG","Y,��,N,��");

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

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
			{"false","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
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
	var sCurModelNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
	        as_save("myiframe0","");       
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
	        as_save("myiframe0","doReturn('N');");        
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
	        as_save("myiframe0","newRecord()");     
	}
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"MODELNO");
	        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
 	       OpenComp("ReportCatalogInfo","/Common/Configurator/ReportManage/ReportCatalogInfo.jsp","","_self","");
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
