<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-28
			Tester:
			Content: ������ģ��Ŀ¼�б�
			Input Param:
	                  
			Output param:
			                
			History Log:  xhgao 2009-03-20 �����ؼ�
	            
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "������ģ��Ŀ¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	//����������	
	//���ҳ�����
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders={
	{"ModelNo","ģ����"},
	{"ModelName","ģ������"},
	{"ModelDescribe","ģ������"},
	{"ModelAttribute","ģ������"},
	};

	sSql = "select "+
	"ModelNo,"+
	"ModelName,"+
	"ModelDescribe,"+
	"ModelAttribute "+
	"from CLASSIFY_CATALOG";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("ModelNo",true);
	doTemp.UpdateTable="CLASSIFY_CATALOG";
	doTemp.setHeader(sHeaders);

 	doTemp.setHTMLStyle("ModelNo"," style={width:160px} ");

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    	dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelClassifyModel(#ModelNo)");
	
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
			{"true","","Button","ģ���б�","�鿴/�޸�ģ���б�","viewAndEdit2()",sResourcesPath},
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
       	sReturn=popComp("ClassifyCatalogInfo","/Common/Configurator/ClassifyManage/ClassifyCatalogInfo.jsp","","");
       	if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
       	{
  	    	//�������ݺ�ˢ���б�
  	    	if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
  	    	{
    	    	sReturnValues = sReturn.split("@");
    	    	if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
    	    	{
    	    	    OpenPage("/Common/Configurator/ClassifyManage/ClassifyCatalogList.jsp","_self","");    
    	    	}
  	    	}
       	}
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sModelNo = getItemValue(0,getRow(),"ModelNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            		return ;
		}
        //openObject("ClassifyCatalogView",sModelNo,"001");
        popComp("ClassifyCatalogView","/Common/Configurator/ClassifyManage/ClassifyCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0010","");
	}
    
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2()
	{
       	sModelNo = getItemValue(0,getRow(),"ModelNo");
       	if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
           	return ;
		}
        //popComp("ClassifyModelList","/Common/Configurator/ClassifyManage/ClassifyModelList.jsp","ModelNo="+sModelNo,"");
        popComp("ClassifyCatalogView","/Common/Configurator/ClassifyManage/ClassifyCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0020","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sModelNo = getItemValue(0,getRow(),"ModelNo");
        	if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('51'))) 
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
    
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
