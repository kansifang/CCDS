<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: ����ģ��Ŀ¼�б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ģ��Ŀ¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	//����������

	//���ҳ�����	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
			{"MODELNO","������"},
			{"MODELNAME","��������"},
			{"MODELTYPE","��������"},
			{"MODELDESCRIBE","��������"},
			{"MODELABBR","������д"},
			{"MODELCLASS","�������"},
			{"ATTRIBUTE1","��������1"},
			{"ATTRIBUTE2","��������2"},
			{"DISPLAYMETHOD","��ʾ����"},
			{"HEADERMETHOD","��ͷ����"},
			{"DELETEFLAG","ɾ����־"},
			{"REMARK","��ע"},	
		};

	sSql = "Select "+
			"MODELNO,"+
			"MODELNAME,"+
			"getItemName('ReportPeriod',MODELTYPE) as MODELTYPE,"+
			"MODELDESCRIBE,"+
			"MODELABBR,"+
			"getItemName('FinanceBelong',MODELCLASS) as MODELCLASS,"+
			"ATTRIBUTE1,"+
			"ATTRIBUTE2,"+
			"getItemName('DisplayMethod',DISPLAYMETHOD) as DISPLAYMETHOD,"+
			"HEADERMETHOD,"+
			"DELETEFLAG,"+
			"REMARK "+
			" From REPORT_CATALOG where 1=1";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REPORT_CATALOG";
	doTemp.setKey("MODELNO",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("MODELNO,MODELTYPE,DELETEFLAG"," style={width:60px} ");
	doTemp.setHTMLStyle("MODELDESCRIBE,REMARK"," style={width:300px} ");
	doTemp.setHTMLStyle("HEADERMETHOD"," style={width:400px} ");
	doTemp.setHTMLStyle("MODELCLASS"," style={width:120px} ");
	doTemp.setHTMLStyle("DISPLAYMETHOD"," style={width:80px} ");
	doTemp.setVisible("MODELDESCRIBE,ATTRIBUTE1,ATTRIBUTE2,DELETEFLAG,REMARK",false);

	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	//��ѯ
 	doTemp.setColumnAttribute("MODELNO","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelReportModel(#MODELNO)");
	
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
		{"true","","Button","ģ���б�","�鿴/�޸�ģ���б�","viewAndEdit2()",sResourcesPath},
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sReturn=popComp("ReportCatalogInfo","/Common/Configurator/ReportManage/ReportCatalogInfo.jsp","","");
		reloadSelf(); 
		//�������ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
		{
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
			{
				OpenPage("/Common/Configurator/ReportManage/ReportCatalogList.jsp","_self",""); 
			}
		}     
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sModelNo = getItemValue(0,getRow(),"MODELNO");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		//openObject("ReportCatalogView",sModelNo,"001");
		popComp("ReportCatalogView","/Common/Configurator/ReportManage/ReportCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0010","");
	}
    
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2()
	{
		sModelNo = getItemValue(0,getRow(),"MODELNO");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		//popComp("ReportModelList","/Common/Configurator/ReportManage/ReportModelList.jsp","ModelNo="+sModelNo,"");
		popComp("ReportCatalogView","/Common/Configurator/ReportManage/ReportCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0020","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sModelNo = getItemValue(0,getRow(),"MODELNO");
	        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		        return ;
		}
		
		if(confirm(getHtmlMessage('49'))) 
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
