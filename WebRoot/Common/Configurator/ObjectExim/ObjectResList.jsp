<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   zxu 2005-07-01
			Tester:
			Content: ���󵼳���Դ�б�
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
		String PG_TITLE = "���󵼳���Դ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	
    //���ҳ�����	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectType==null) sObjectType="";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders = {
		{"ObjectType","��������"},
		{"SortNo","˳���"},
		{"TableID","���ݱ���"},
		{"ExportSql","������Sql"},
		{"BeforeImpSql","����ʱԤ����Sql"},
		{"EffStatus","��Ч��־"}
	};
	
	sSql =  "select "+
	"ObjectType,"+
	"SortNo,"+
	"TableID,"+
	"ExportSql,"+
	"BeforeImpSql,"+
	"EffStatus "+
		" from OBJECT_RES_LIST where 1=1 order by ObjectType,SortNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "OBJECT_RES_LIST";
	doTemp.setKey("ObjectType,SortNo",true);
	doTemp.setHeader(sHeaders);
	
	//��ѯ
 	doTemp.setColumnAttribute("ObjectType,SortNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	doTemp.setDDDWCode("EffStatus","TrueFalse");
	doTemp.setHTMLStyle("ExportSql"," style={width:320px} ");

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
	var sCurMethodNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sReturn=popComp("ObjectResInfo","/Common/Configurator/ObjectExim/ObjectResInfo.jsp","","");
		//�޸����ݺ�ˢ���б�
		reloadSelf();
	}
	
        /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sSortNo = getItemValue(0,getRow(),"SortNo");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0 || typeof(sSortNo)=="undefined" || sSortNo.length==0 ) {
		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
                return ;
	    }
		sReturn=popComp("ObjectResInfo","/Common/Configurator/ObjectExim/ObjectResInfo.jsp","ObjectType="+sObjectType+"&SortNo="+sSortNo,"");
            //�޸����ݺ�ˢ���б�
	    reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sSortNo = getItemValue(0,getRow(),"SortNo");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0 || typeof(sSortNo)=="undefined" || sSortNo.length==0 ) {
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
	    sObjectNo = getItemValue(0,getRow(),"ObjectType");
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
	my_load(2,0,'myiframe0');
    
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
