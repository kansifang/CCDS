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
		String PG_TITLE = "Ԥ�������б�"; // ��������ڱ��� <title> PG_TITLE </title>
		CurPage.setAttribute("ShowDetailArea","true");
		CurPage.setAttribute("DetailAreaHeight","180");
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
		{"ScenarioName","��������"},
		{"ObjectType","Ԥ����������"},
		{"ScenarioDescribe","����˵��"}
	};
	sSql = "select "+
		   "ScenarioID,"+
		   "ScenarioName,"+
		   "ObjectType,"+
		   "ScenarioDescribe "+
		  " from ALARM_SCENARIO where 1=1 order by ScenarioID";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "ALARM_SCENARIO";
	doTemp.setKey("ScenarioID",true);
	doTemp.setHeader(sHeaders);

	//��ѯ
 	doTemp.setColumnAttribute("ScenarioID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(30);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelScenarioAll(#ScenarioID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
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
			{"true","","Button","Ԥ�������б�","�鿴/�޸�Ԥ�������б�","viewAndEditLib()",sResourcesPath},
			{"true","","Button","Ԥ����������","�鿴/�޸�Ԥ��Ԥ�������","viewAndEditArg()",sResourcesPath},
			{"false","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
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
    var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        //sReturn=popComp("ScenarioInfo","/Common/Configurator/AlarmManage/ScenarioInfo.jsp","","");
        OpenComp("ScenarioInfo","/Common/Configurator/AlarmManage/ScenarioInfo.jsp","","DetailFrame",OpenStyle);
	    reloadSelf();
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
	    }
	    //sReturn=popComp("ScenarioInfo","/Common/Configurator/AlarmManage/ScenarioInfo.jsp","ScenarioID="+sScenarioID,"");
	    //reloadSelf();
        OpenComp("ScenarioInfo","/Common/Configurator/AlarmManage/ScenarioInfo.jsp","ScenarioID="+sScenarioID,"DetailFrame",OpenStyle);
	}
    
    /*~[Describe=�鿴���޸�Ԥ�������б�;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditLib()
	{
       	sScenarioID = getItemValue(0,getRow(),"ScenarioID");
       	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		//popComp("AlarmLibList","/Common/Configurator/AlarmManage/AlarmLibList.jsp","ScenarioID="+sScenarioID,"");
		OpenComp("AlarmLibList","/Common/Configurator/AlarmManage/AlarmLibList.jsp","ScenarioID="+sScenarioID,"DetailFrame",OpenStyle);
	}

    /*~[Describe=�鿴���޸�Ԥ������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditArg()
	{
       	sScenarioID = getItemValue(0,getRow(),"ScenarioID");
       	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
           	return ;
		}
        //popComp("AlarmArgsList","/Common/Configurator/AlarmManage/AlarmArgsList.jsp","ScenarioID="+sScenarioID,"");
        OpenComp("AlarmArgsList","/Common/Configurator/AlarmManage/AlarmArgsList.jsp","ScenarioID="+sScenarioID,"DetailFrame",OpenStyle);
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sScenarioID = getItemValue(0,getRow(),"ScenarioID");
       	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
           	return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
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
		sScenarioID = getItemValue(0,getRow(),"ScenarioID");
       	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			OpenPage("/Blank.jsp?TextToShow=��ѡ��һ����¼","DetailFrame","");
			return;
		}
       	OpenComp("ScenarioInfo","/Common/Configurator/AlarmManage/ScenarioInfo.jsp","ScenarioID="+sScenarioID,"DetailFrame",OpenStyle);
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
	mySelectRow();
    hideFilterArea();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
