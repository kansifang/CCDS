<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jacky hao 2005-07-28
		Tester:
		Content: Ԥ�������б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ұ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
		{"trigger_name","���"},
		{"trigger_group","�������"},
		{"description","��������"},
		{"curr_exec_progress","��ǰ����"},
		{"curr_start_time","��ʼ����ʱ��"},
		{"curr_end_time","��������ʱ��"},		
		{"user_id","������"},
		{"create_date","����ʱ��"}
	};
	sSql = "select "+
		   "trigger_name,"+"trigger_group,"+
		   "description,"+"curr_exec_progress,"+
		   "curr_start_time,"+"curr_end_time,"+
		   "user_id,"+"create_date"+
		  " from atask_progress where 1=1 order by create_date desc";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "atask_progress";
	doTemp.setKey("trigger_name",true);
	doTemp.setKey("trigger_group",true);
	doTemp.setHeader(sHeaders);

	//��ѯ
 	doTemp.setColumnAttribute("trigger_group","IsFilter","1");
 	doTemp.setColumnAttribute("description","IsFilter","1");
 	doTemp.setColumnAttribute("curr_exec_progress","Unit","(��λ��%)");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    	dwTemp.setPageSize(20);

	//��������¼�
	//dwTemp.setEvent("BeforeDelete","!Configurator.DelScenarioAll(#ScenarioID)");
	
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
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},		
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		 
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	 
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
            sSerialNo = getItemValue(0,getRow(),"trigger_name");
            if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
                return ;
	    }
	    sReturn=popComp("ScenarioResultInfo","/Common/Configurator/AlarmManage/ScenarioResultInfo.jsp","SerialNo="+sSerialNo,"");
	    reloadSelf();
	}
    
    

   
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		trigger_name = getItemValue(0,getRow(),"trigger_name");
        	if(typeof(trigger_name)=="undefined" || trigger_name.length==0) {
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
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
