<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-28
			Tester:
			Content: ����ģ���б�
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
		{"ObjectName","������������"},
		{"SortNo","�����"},
		{"TreeCode","������ͼ"},
		{"PagePath","����ҳ��"},
		{"ObjectAttribute","��������"},
		{"ObjectTable","��Ӧ���ݱ�"},
		{"KeyCol","�ؼ��ֶ�"},
		{"KeyColName","�����ֶ�"},
		{"ViewType","������ͼ��"},
		{"DefaultView","Ĭ����ͼ"},
		{"RightType","Ȩ�޷���"},
		{"Describe","��;˵��"}
	};
	sSql = "select "+
		   "ObjectType,"+
		   "ObjectName,"+
		   "SortNo,"+
		   "TreeCode,"+
		   "PagePath,"+
		   "ObjectAttribute,"+
		   "ObjectTable,"+
		   "KeyCol,"+
		   "KeyColName,"+
		   "ViewType,"+
		   "DefaultView,"+
		   "RightType,"+
		   "UsageDescribe "+
		  "from OBJECTTYPE_CATALOG Where 1=1 order by SortNo";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "OBJECTTYPE_CATALOG";
	doTemp.setKey("ObjectType",true);
	doTemp.setHeader(sHeaders);
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	doTemp.setHTMLStyle("PagePath,ObjectAttribute,ObjectTable"," style={width:300px} ");

 	doTemp.setColumnAttribute("ObjectType,ObjectName,PagePath,SortNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","1+!Configurator.DelObjTypeRelative(#ObjectType)");
	
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
			{"false","","Button","����","�鿴/�޸�����","as_save('myiframe0')",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"false","","Button","�������Ͳ㼶�б�","�鿴/�޸Ķ������Ͳ㼶�б�","viewAndEdit2()",sResourcesPath},
			{"false","","Button","���������б�","�鿴/�޸Ķ��������б�","viewAndEdit3()",sResourcesPath},
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
        sReturn=popComp("ObjTypeCatalogInfo","/Common/Configurator/ObjectManage/ObjTypeCatalogInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //�������ݺ�ˢ���б�
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/ObjectManage/ObjTypeCatalogList.jsp","_self","");    
                }
            }
        }
        
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        popComp("ObjectTypeView","/Common/Configurator/ObjectManage/ObjTypeCatalogView.jsp","ObjectNo="+sObjectType,"");
        
	}
    
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2()
	{
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        popComp("ObjTypeLevelList","/Common/Configurator/ObjectManage/ObjTypeLevelList.jsp","ObjectType="+sObjectType,"");
        
	}

    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit3()
	{
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        popComp("ObjTypeAttributeList","/Common/Configurator/ObjectManage/ObjTypeAttributeList.jsp","ObjectType="+sObjectType,"");
        
	}
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
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
