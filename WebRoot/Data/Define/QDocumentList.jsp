<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: ��ҵ� 2005-08-17
			Tester:
			Describe:�ĵ���Ϣ�б�
			Input Param:
	       		    ObjectNo: ������
	       		    ObjectType: ��������           		
	        Output Param:

			HistoryLog:zywei 2005/09/03 �ؼ����
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "�ĵ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������                     
	String sObjectNo = "";//--������
	//���ҳ�����
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectType.equals("Customer"))
	 	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	else							
		sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sTempletNo = "QDocument";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//���ò��ɼ���
    doTemp.setVisible("UserID,DocType,ObjectNo,ObjectType",false);
    //���÷��
   	doTemp.setEditStyle("DocKeyWord,DocAbstract,Remark", "1");
	doTemp.setHTMLStyle("DocKeyWord,DocAbstract,Remark", "");
    //���ɲ�ѯ��
	doTemp.setColumnAttribute("DocTypeName,DocTitle","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	//����setEvent
	Vector vTemp = dwTemp.genHTMLDataWindow("QDT,All");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	CurPage.setAttribute("ShowDetailArea","false");
	CurPage.setAttribute("DetailAreaHeight","150");
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
			{"true","","Button","����","�����ĵ���Ϣ","newRecord()",sResourcesPath},
			{"true","","Button","��������","�鿴��������","viewAndEdit_doc()",sResourcesPath},
			{"true","","Button","��������","�鿴��������","viewAndEdit_attachment()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
			{"false","","Button","��������","���������ĵ���Ϣ","exportFile()",sResourcesPath},
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

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Data/Define/QDocumentInfo.jsp","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����	
		sDocNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{ 
			if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
			{
				as_del('myiframe0');
				as_save('myiframe0') //�������ɾ������Ҫ���ô����             
			} 
		}else 
		{
			alert(getHtmlMessage('3'));
			return;
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit_doc()
	{
		sDocNo=getItemValue(0,getRow(),"DocNo");
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}
    	else
    	{
    		OpenPage("/Data/Define/QDocumentInfo.jsp?DocNo="+sDocNo,"_self","");
        }
	}
	
	/*~[Describe=�鿴���޸ĸ�������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit_attachment()
	{    
    	sDocNo=getItemValue(0,getRow(),"DocNo");
    	sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����	     
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{        
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;         
    	}
    	else
    	{
    		popComp("QDefinitionList","/Data/Define/QDefinitionList.jsp","docNo="+sDocNo);
      		reloadSelf();
      	}
	}
	function mySelectRow()
	{
		//hideFilterArea();
		var sCodeNo = getItemValue(0,getRow(),"DocNo");
		var sType = getItemValue(0,getRow(),"CodeAttribute");
		if(sCodeNo.length>0){
			document.getElementById("ListHorizontalBar").parentNode.style.display="";
			document.getElementById("ListDetailAreaTD").parentNode.style.display="";
			OpenComp("QTabConfigList","/Data/Define/QTabConfigList.jsp","CodeNo="+sCodeNo+"&type="+sType,"DetailFrame","");
		}
	}
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function exportFile()
	{
		//����������Ϣ       
    	OpenPage("/Common/Document/ExportFile.jsp","_self","");
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>


<%@	include file="/IncludeEnd.jsp"%>
