<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   zxu 2005-06-07
			Tester:
			Content: Ԥ�������б�
			Input Param:
	                  ScenarioID��	����ID
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
		{"AlarmArgID","�������"},
		{"SortNo","�����"},
		{"ArgsString","������"},
		{"ConstructSql","�����������"},
		{"EffStatus","��Ч��־"}
	};
	
	sSql =  "select "+
	"ScenarioID,"+
	"AlarmArgID,"+
	"SortNo,"+
	"ArgsString,"+
	"ConstructSql,"+
	"getItemName('TrueFalse',EffStatus) as EffStatus"+
		" from ALARM_ARGS where 1=1 order by ScenarioID,AlarmArgID";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "ALARM_ARGS";
	doTemp.setKey("ScenarioID,AlarmArgID",true);
	doTemp.setHeader(sHeaders);
	
	//��ѯ
 	doTemp.setColumnAttribute("AlarmArgID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(sScenarioID !=null && !sScenarioID.equals(""))
	{
		doTemp.WhereClause+=" And ScenarioID='"+sScenarioID+"'";
	}
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";

	doTemp.setHTMLStyle("ArgsString"," style={width:300px} ");
	doTemp.setHTMLStyle("ConstructSql"," style={width:350px} ");
	doTemp.setHTMLStyle("ScenarioID,AlarmArgID,SortNo,EffStatus"," style={width:50px} ");

	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(30);
    
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
		sReturn=popComp("AlarmArgsInfo","/Common/Configurator/AlarmManage/AlarmArgsInfo.jsp","ScenarioID=<%=sScenarioID%>","");
		//�޸����ݺ�ˢ���б�
		reloadSelf();
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        sAlarmArgID = getItemValue(0,getRow(),"AlarmArgID");
        if(typeof(sAlarmArgID)=="undefined" || sAlarmArgID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        sReturn=popComp("AlarmArgsInfo","/Common/Configurator/AlarmManage/AlarmArgsInfo.jsp","ScenarioID="+sScenarioID+"&AlarmArgID="+sAlarmArgID,"");
        //�޸����ݺ�ˢ���б�
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
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
