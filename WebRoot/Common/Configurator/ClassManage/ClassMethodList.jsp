<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-28
			Tester:
			Content:�༰�����б�
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
	String sSql;
	String sSortNo; //������
    //����������	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassName"));
    if (sClassName == null) sClassName = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders={
		{"ClassName","������"},
		{"MethodName","��������"},
		{"MethodType","��������"},
		{"MethodDescribe","��������"},
		{"ReturnType","����ֵ����"},
		{"MethodArgs","��������"},
		{"MethodCode","����ʵ�ִ���"},
		{"Remark","��ע"},
		};

	sSql = "select "+
	"ClassName,"+
	"MethodName, "+
	"MethodType,"+
	"MethodDescribe,"+
	"ReturnType,"+
	"MethodArgs,"+
	"MethodCode,"+
	"Remark "+
	"from CLASS_METHOD Where 1 = 1 ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CLASS_METHOD";
	doTemp.setKey("ClassName,MethodName",true);
	doTemp.setHeader(sHeaders);
	doTemp.setHTMLStyle("MethodCode"," style={width:600px} ");
	doTemp.setHTMLStyle("MethodType"," style={width:80px} ");	
 	doTemp.setHTMLStyle("ClassName"," style={width:160px} ");
	doTemp.setHTMLStyle("ClassType"," style={width:100px} ");
	doTemp.setHTMLStyle("ClassDescribe"," style={width:300px} ");
	doTemp.setHTMLStyle("ParentClass"," style={width:160px} ");
	doTemp.setEditStyle("MethodArgs,MethodCode","3");
	doTemp.setHTMLStyle("MethodArgs,MethodCode"," style={width:300px;height:22px} onDBLClick=\"parent.editObjectValueWithScriptEditorForASScript(this)\"");

	//��ѯ
 	doTemp.setColumnAttribute("ClassName,MethodName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(sClassName!=null && !sClassName.equals("")) 
	{
		doTemp.WhereClause  += " And ClassName='"+sClassName+"'";
	}
	/*
	else
	{
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause  += " And 1=2";
	}
	*/	
	doTemp.OrderClause += " Order by  ClassName,MethodCode ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelClassMethod(#ClassName)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql);
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
		{(sClassName.equals("")?"false":"true"),"","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
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
	    sReturn=popComp("ClassMethodInfo","/Common/Configurator/ClassManage/ClassMethodInfo.jsp","","");
		reloadSelf();
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sClassName = getItemValue(0,getRow(),"ClassName");
        sMethodName = getItemValue(0,getRow(),"MethodName");
        if(typeof(sClassName)=="undefined" || sClassName.length==0) 
        {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
	    sReturn=popComp("ClassMethodInfo","/Common/Configurator/ClassManage/ClassMethodInfo.jsp","ClassName="+sClassName+"&MethodName="+sMethodName,"");
		reloadSelf();
	}
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		as_save("myiframe0","");
	}

    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2()
	{
        sClassName = getItemValue(0,getRow(),"ClassName");
        sClassDescribe = getItemValue(0,getRow(),"ClassDescribe");
        if(typeof(sClassName)=="undefined" || sClassName.length==0) 
        {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
	    popComp("ClassMethodList","/Common/Configurator/ClassManage/ClassMethodList.jsp","ClassName="+sClassName+"&ClassDescribe="+sClassDescribe,"");        
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sClassName = getItemValue(0,getRow(),"ClassName");
        if(typeof(sClassName)=="undefined" || sClassName.length==0) 
        {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('54'))) 
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
