<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    ����ģ��Ŀ¼����
		Input Param:
                    ModelNo��    �����¼���
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ģ��Ŀ¼����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if(sModelNo==null) sModelNo="";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
   	String sHeaders[][] = {
				{"ModelNo","��������"},
				{"ModelName","����������"},
				{"ModelType","���������"},
				{"ModelDescribe","����������"},
				{"TransformMethod","ת������"},
				{"Remark","��ע"},
			       };  

	sSql = " Select  "+
				"ModelNo,"+
				"ModelName,"+
				"ModelType,"+
				"ModelDescribe,"+
				"TransformMethod,"+
				"Remark "+ 
				"From EVALUATE_CATALOG Where ModelNo = '"+sModelNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="EVALUATE_CATALOG";
	doTemp.setKey("ModelNo",true);
	doTemp.setHeader(sHeaders);

	if (!sModelNo.equals(""))
	{
		doTemp.setReadOnly("ModelNo",true);
	}
	else
	{
		doTemp.setRequired("ModelNo",true);
	}
	doTemp.setHTMLStyle("ModelNo"," style={width:160px} ");
	doTemp.setHTMLStyle("ModelName"," style={width:400px} ");
	doTemp.setHTMLStyle("ModelDescribe"," style={width:600px} ");
	doTemp.setEditStyle("TransformMethod,Remark","3");
	doTemp.setHTMLStyle("TransformMethod,Remark"," style={height:150px;width:600px;overflow:scroll} ");

	doTemp.setDDDWCode("ModelType","EvaluateModelType");	

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

 	//filter��������
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","���沢����","�����޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
		{"true","","Button","ת����������","ת����������","my_formatIF()",sResourcesPath},
        	// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","���ش����б�","doReturn('Y')",sResourcesPath}
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
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
        as_save("myiframe0","self.close();");
        
	}
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
        as_save("myiframe0","doReturn('Y');");
        
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
        as_save("myiframe0","newRecord()");
        
	}
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        OpenComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","","_self","");
	}

	function my_formatIF()
	{
		try{			
			var sValue = getItemValue(0,getRow(),"TransformMethod");
			sValue = sValue.replace(/\r\nif/g,"if"); 
			sValue = sValue.replace(/if/g,"\r\nif"); 
			sValue = sValue.replace("\r\n",""); 
			setItemValue(0,getRow(),"TransformMethod",sValue);	
		} catch(e){
		}	
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
		    bIsInsert = true;
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
