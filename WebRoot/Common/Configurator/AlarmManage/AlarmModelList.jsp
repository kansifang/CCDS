<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zxu 2005-06-01
		Tester:
		Content: Ԥ��ģ���б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ��ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	
    //���ҳ�����	
	String sAlarmModelID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlarmModelID"));
    if (sAlarmModelID == null) 
        sAlarmModelID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
		{"AlarmModelNo","Ԥ��ģ�ͱ��"},
		{"AlarmModelType","Ԥ��ģ������"},
		{"AlarmModelName","Ԥ��ģ������"},
		{"AlarmDescribe","Ԥ��ģ������"},
		{"CheckScript","У��ű�"}
	};
	
	sSql =  "select "+
			"AlarmModelNo,"+
			"getItemName('AlarmModelType',AlarmModelType) as AlarmModelType,"+
			"AlarmModelName,"+
			"AlarmDescribe,"+
			"CheckScript"+
		" from Alarm_MODEL where 1=1 order by AlarmModelNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "Alarm_MODEL";
	doTemp.setKey("AlarmModelNo",true);
	doTemp.setHeader(sHeaders);
	
	doTemp.setHTMLStyle("AlarmModelNo"," style={width:60px} ");
	doTemp.setHTMLStyle("AlarmModelName,AlarmDescribe"," style={width:180px} ");
	doTemp.setHTMLStyle("CheckScript"," style={width:300px} ");
	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	//��ѯ
 	doTemp.setColumnAttribute("AlarmModelNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(sAlarmModelID !=null && !sAlarmModelID.equals(""))
	{
		doTemp.WhereClause+=" And AlarmModelNo='"+sAlarmModelID+"'";
	}
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);
    
	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelAlarmModel(#AlarmModelNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","����","doReturn('N')",sResourcesPath}
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sReturn=popComp("AlarmModelInfo","/Common/Configurator/AlarmManage/AlarmModelInfo.jsp","AlarmModelID=<%=sAlarmModelID%>","");
		//�޸����ݺ�ˢ���б�
		reloadSelf();
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sAlarmModelID = getItemValue(0,getRow(),"AlarmModelNo");
        if(typeof(sAlarmModelID)=="undefined" || sAlarmModelID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
	    }
        sReturn=popComp("AlarmModelInfo","/Common/Configurator/AlarmManage/AlarmModelInfo.jsp","AlarmModelID="+sAlarmModelID,"");
        //�޸����ݺ�ˢ���б�
	    reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sAlarmModelID = getItemValue(0,getRow(),"AlarmModelNo");
        if(typeof(sAlarmModelID)=="undefined" || sAlarmModelID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        	return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"AlarmModelNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	hideFilterArea();
    
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
