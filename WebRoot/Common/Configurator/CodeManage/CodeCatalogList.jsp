<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: ����Ŀ¼�б�
			Input Param:
	                  
			Output param:
			                
			History Log: 
			wuxiong 2005-02-19
	            
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";
		
	//����������		
		
	//���ҳ�����	
	String sCodeTypeOne =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeTypeOne"));
	String sCodeTypeTwo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeTypeTwo"));
	//����ֵת��Ϊ���ַ���	
	if (sCodeTypeOne == null) sCodeTypeOne = ""; 
	if (sCodeTypeTwo == null) sCodeTypeTwo = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders={
		{"CodeNo","�����"},
		{"CodeName","��������"},
		{"SortNo","�����"},
		{"CodeDescribe","��������"},
	};

	sSql = "Select "+
		   "CodeNo,"+
		   "CodeName,"+
		   "CodeTypeOne,"+
		   "CodeTypeTwo,"+
		   "SortNo,"+
		   "CodeDescribe "+
		   "from CODE_CATALOG "+
		   "Where 1=1 ";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.multiSelectionEnabled=false;
	doTemp.UpdateTable="CODE_CATALOG";
	doTemp.setKey("CodeNo",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("CodeNo"," style={width:160px} ");
	doTemp.setHTMLStyle("CodeName"," style={width:160px} ");
	doTemp.setHTMLStyle("SortNo"," style={width:43px} ");
	doTemp.setHTMLStyle("CodeDescribe"," style={width:360px} ");
	//��ѯ
 	doTemp.setColumnAttribute("CodeNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

   	doTemp.setVisible("CodeTypeOne,CodeTypeTwo",false);    	
 		
	if(sCodeTypeOne!=null && !sCodeTypeOne.equals("")) doTemp.WhereClause+=" and CodeTypeOne='"+sCodeTypeOne+"'";
	if(sCodeTypeTwo!=null && !sCodeTypeTwo.equals("")) doTemp.WhereClause+=" and CodeTypeTwo='"+sCodeTypeTwo+"'";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelCodeLibrary(#CodeNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{"true","","Button","�����б�","�鿴/�޸Ĵ�������","viewAndEditCode()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{"true","","Button","����","������ѡ�еļ�¼","exportDataObject()",sResourcesPath},
			{"true","","Button","����SortNo","����SortNo","GenerateCodeCatalogSortNo()",sResourcesPath}
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
        sReturn=popComp("CodeCatalogInfo","/Common/Configurator/CodeManage/CodeCatalogInfo.jsp","CodeTypeOne=<%=sCodeTypeOne%>&CodeTypeTwo=<%=sCodeTypeTwo%>","");
        reloadSelf();        
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sCodeNo = getItemValue(0,getRow(),"CodeNo");
        sCodeName = getItemValue(0,getRow(),"CodeName");
        if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) 
        {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
        
	    popComp("CodeCatalogInfo","/Common/Configurator/CodeManage/CodeCatalogInfo.jsp","CodeNo="+sCodeNo,"");
	}
    
    /*~[Describe=�鿴���޸Ĵ�������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditCode()
	{
        sCodeNo = getItemValue(0,getRow(),"CodeNo");
        sCodeName = getItemValue(0,getRow(),"CodeName");
        if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) 
        {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		popComp("CodeItem","/Common/Configurator/CodeManage/CodeItemList.jsp","CodeNo="+sCodeNo+"&CodeName="+sCodeName,"");  
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sCodeNo = getItemValue(0,getRow(),"CodeNo");
		if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function exportDataObject()
	{
		sCodeNo = getItemValue(0,getRow(),"CodeNo");
        if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0 ) 
        {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		sServerRoot = "";
		sReturn = PopPage("/Common/Configurator/ObjectExim/ExportDataObject.jsp?ObjectType=Code&ObjectNo="+sCodeNo+"&ServerRootPath="+sServerRoot,"","");
		if(sReturn=="succeeded"){
			alert("�ɹ��������ݣ�");
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
	function GenerateCodeCatalogSortNo(){
		RunMethod("Configurator","GenerateCodeCatalogSortNo","");
	}
	
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
	my_load(2,0,'myiframe0');
    
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
