<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: ��ʾģ��Ŀ¼�б�
		Input Param:
                  
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
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
	String sDoName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoName"));
	String sDoNo2 =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo2"));

	if(sDoNo==null) sDoNo="";
	if(sDoName==null) sDoName="";
    if (sDoNo2==null) sDoNo2=""; 
    
	//���ҳ�����	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
			{"DoNo","DO���"},
			{"DoName","DO����"},
			{"DoDescribe","DO����"},
			{"DoType","DO���"},
			{"DoArguments","DO����"},
			{"DoAttribute","DO����"},
			{"DoUpdateTable","����Ŀ���"},
			{"DoUpdateWhere","���·�ʽ"},
			{"DoFromClause","DOFrom�Ӿ�"},
			{"DoWhereClause","DOWhere�Ӿ�"},
			{"DoGroupClause","DOGroup�Ӿ�"},
			{"DoOrderClause","DOOrder�Ӿ�"},
			{"Remark","��ע"},
			{"DoClass","����"},
			{"ModifyAuditTable","�޸���Ʊ�"},
			{"ModifyModeCriteria","�޸��������"},
			{"DeleteAuditTable","ɾ����Ʊ�"},
			{"DeleteModeCriteria","ɾ���������"},
			{"IsInUse","��Ч"},
		};

	sSql = "Select "+
			"DoNo,"+
			"DoName,"+
			"DoDescribe,"+
			"getItemName('DOType',DoType) as DoType,"+
			"DoArguments,"+
			"DoAttribute,"+
			"DoUpdateTable,"+
			"getItemName('DoUpdateWhere',DoUpdateWhere) as DoUpdateWhere,"+
			"DoFromClause,"+
			"DoWhereClause,"+
			"DoGroupClause,"+
			"DoOrderClause,"+
			"Remark,"+
			"getItemName('DOClass',DoClass) as DoClass,"+
			"ModifyAuditTable,"+
			"ModifyModeCriteria,"+
			"DeleteAuditTable,"+
			"DeleteModeCriteria,"+
			"getItemName('IsInUse',IsInUse) as IsInUse "+
			"From DATAOBJECT_CATALOG where 1=1";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="DATAOBJECT_CATALOG";
	doTemp.setKey("DoNo",true);
	doTemp.setHeader(sHeaders);

	//����
	doTemp.setVisible("Remark,ModifyAuditTable,ModifyModeCriteria,DeleteAuditTable,DeleteModeCriteria",false);    	

	doTemp.setHTMLStyle("DoName"," style={width:150px} ");
	doTemp.setHTMLStyle("DoNo"," style={width:120px} ");
	doTemp.setHTMLStyle("DoType,DoUpdateWhere,DoClass,IsInUse"," style={width:60px} ");
	doTemp.setHTMLStyle("DoWhereClause"," style={width:260px} ");


	//��ѯ
 	doTemp.setColumnAttribute("DoNo,DoName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelDOLibrary(#DoNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","��Ԫ��������","��Ԫ��������","generateFromMetaData()",sResourcesPath}
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        OpenComp("DataObjectView","/Common/Configurator/DataObject/DataObjectView.jsp","","");
		reloadSelf();
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sDoNo = getItemValue(0,getRow(),"DoNo");
        if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        openObject("DataObject",sDoNo,"001");
	}
    

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sDoNo = getItemValue(0,getRow(),"DoNo");
        if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
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

	function generateFromMetaData()
	{
		sDoNo = getItemValue(0,getRow(),"DoNo");
        	if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            		return ;
		}
		sMetaData = popComp("MetaTableSelect","/Common/Configurator/MetaDataManage/MetaTableSelectionList.jsp","","");
		if(typeof(sMetaData)=="undefined" || sMetaData=="_CANCEL_") return;
		alert(sMetaData);
		sMetaDatas = sMetaData.split("@");
		sMetaDatabase = sMetaDatas[0];
		sMetaTable = sMetaDatas[1];
		sReturn = PopPage("/Common/Configurator/DataObject/GenerateFromMetaData.jsp?DatabaseID="+sMetaDatabase+"&TableID="+sMetaTable+"&DoNo="+sDoNo,"","");
		if(sReturn=="succeeded"){
			if(confirm("�ɹ��������ݶ���\n\n�򿪱༭��")) viewAndEdit();
		}
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
<%
    if(!doTemp.haveReceivedFilterCriteria()) {
%>
	showFilterArea();
<%
	}	
%>
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
