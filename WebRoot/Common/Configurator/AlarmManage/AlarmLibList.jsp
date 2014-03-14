<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   zxu 2005-06-06
			Tester:
			Content: Ԥ�������б�
			Input Param:
	                  ScenarioID	Ԥ���������
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
		String PG_TITLE = "Ԥ�������б�@PageTitle"; // ��������ڱ��� <title> PG_TITLE </title>
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
	
    //���ҳ�����	
	String sScenarioID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ScenarioID"));
    if (sScenarioID == null) 
        sScenarioID = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders = {
		{"ScenarioID","�������"},			
		{"AlarmModelName","ģ�ͱ��"},		
		{"SortNo","�����"},
		{"DealMethodName","�����ʩ"},
		{"RunCondition","��������"},
		{"ShowScript","��ʾScript"},
		{"EffStatus","��Ч��־"}
	};
	
	sSql =  "select "+
	"ScenarioID,"+
	"AlarmModelNo,"+
	"getAlarmModelName(AlarmModelNo) as AlarmModelName,"+
	"SortNo,"+
	"DealMethod,"+
	"getItemName('LoanMethod',DealMethod) as DealMethodName,"+
	"RunCondition,"+
	"ShowScript,"+
	"getItemName('TrueFalse',EffStatus) as EffStatus"+
		" from ALARM_LIBRARY where 1=1 order by ScenarioID,AlarmModelNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "ALARM_LIBRARY";
	doTemp.setKey("ScenarioID,AlarmModelNo",true);
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("DealMethodName","2");
 	//���Ƿ�ɼ�
	doTemp.setVisible("AlarmModelNo,DealMethod",false);

	//��ѯ
 	doTemp.setFilter(Sqlca,"1","AlarmModelName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(sScenarioID !=null && !sScenarioID.equals(""))
	{
		doTemp.WhereClause+=" And ScenarioID='"+sScenarioID+"'";
	}
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";

	doTemp.setHTMLStyle("ScenarioID,SortNo,EffStatus"," style={width:50px} ");
	doTemp.setHTMLStyle("AlarmModelName"," style={width:250px} ");
	doTemp.setHTMLStyle("DealMethodName"," style={width:100px} ");
	doTemp.setHTMLStyle("RunCondition"," style={width:120px} ");
	doTemp.setHTMLStyle("ShowScript"," style={width:150px} ");

	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);
    
	//��������¼�
	//dwTemp.setEvent("BeforeDelete","!Configurator.DelSightRight(#RightID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
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
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","����","doReturn('N')",sResourcesPath}
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

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sReturn=popComp("AlarmLibInfo","/Common/Configurator/AlarmManage/AlarmLibInfo.jsp","ScenarioID=<%=sScenarioID%>","");
		//�޸����ݺ�ˢ���б�
		reloadSelf();
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        sAlarmModelNo = getItemValue(0,getRow(),"AlarmModelNo");
        if(typeof(sAlarmModelNo)=="undefined" || sAlarmModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        sReturn=popComp("AlarmLibInfo","/Common/Configurator/AlarmManage/AlarmLibInfo.jsp","ScenarioID="+sScenarioID+"&AlarmModelNo="+sAlarmModelNo,"");
        //�޸����ݺ�ˢ���б�
	reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sAlarmModelNo = getItemValue(0,getRow(),"AlarmModelNo");
        	if(typeof(sAlarmModelNo)=="undefined" || sAlarmModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            		return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ScenarioID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	hideFilterArea();
    
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
