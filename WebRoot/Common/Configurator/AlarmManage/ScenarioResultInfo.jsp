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
	//����������	
	String SerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(SerialNo==null) SerialNo="";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
		{"recordno","��¼���"},
		{"alarmmodelno","ģ�ͱ��"},
		{"alarmlogid","��־���"},
		{"alarmtip","TIP"},
		{"dealmethod","�����ʩ"},
		{"dealdate","����ʱ��"}
	};
	sSql = "select "+
		   "alarmlogid,"+
		   "alarmmodelno,"+
		   "recordno,"+
		   "alarmtip,"+
		   "dealmethod,"+
		   "dealdate "+		   
		  "from alarm_log where recordno = '"+SerialNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "alarm_log";
	doTemp.setKey("alarmlogid",true);
	doTemp.setKey("alarmmodelno",true);
	doTemp.setKey("recordno",true);
	doTemp.setHeader(sHeaders);

	//��ѯ
 	doTemp.setColumnAttribute("alarmlogid","IsFilter","1");
 	doTemp.setColumnAttribute("alarmmodelno","IsFilter","1");
 	 
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
		//{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},		
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
		alarmlogid = getItemValue(0,getRow(),"alarmlogid");
        	if(typeof(alarmlogid)=="undefined" || alarmlogid.length==0) {
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
