<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: jytian 2004-12-21
			Tester:
			Describe:�ĵ������б�
			Input Param:
	       		�ĵ����:BatchNo
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
		String PG_TITLE = "�ĵ������б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	//���ҳ�����
	
	//����������
	String sBatchNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BatchNo"))); 
	String sStatus = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Status")));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = 	{ 
                            	{"BatchNo","���κ�"},
                            	{"SerialNo","���Ӻ�"},
                            	{"DueNo","��ݺ�"},
                            	{"LCustomerID","ί�з�"},
                            	{"LCustomerName","ί�з�"},
                            	{"LDate","ί������"},
                            	{"LSum","ί�н��"},
                            	{"DCustomerID","����"},
                            	{"DCustomerName","����"},
                            	{"ID","���֤��"},
                            	{"CardNo","����"},
                            	{"PayBackSum","Ӧ������"},
                            	{"PayBackDate","Ӧ������"},
                            	{"ActualPayBackSum","ʵ�ʻ�����"},
                            	{"ActualPayBackDate","ʵ�ʻ�����"},
                            	{"Balance","���"},
                            	{"Remark","����"},
                            	{"BeginTime","���Ϳ�ʼʱ��"},
                            	{"EndTime","���ͽ���ʱ��"},
                            	{"BeginTime","���Ϳ�ʼʱ��"},
                            	{"EndTime","���ͽ���ʱ��"}
	     			};    		                     
	
	    
    	//����SQL���
    	
	sSql = 	" SELECT BatchNo,SerialNo,DueNo,"+
	" LCustomerID,LCustomerName,"+
	" LDate,LSum,"+
	" DCustomerID,DCustomerName,"+
	" ID,CardNo,"+
	" PayBackSum,PayBackDate,"+
	" ActualPayBackSum,ActualPayBackDate,"+
	" Balance,Remark,"+
	" BeginTime,EndTime,"+
	" getItemName('Status',Status) as Status"+
           	" FROM Batch_Case"+
	" WHERE 1=1 "+
           	("".equals(sBatchNo)?"":" and BatchNo='"+sBatchNo+"'")+
           	("".equals(sStatus)?"":" and Status='"+sStatus+"'");
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����б��ͷ
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable = "Batch_Case";
	doTemp.setKey("SerialNo",true);	
	
    doTemp.setVisible("BatchNo,LCustomerID,DCustomerID",false);
	doTemp.setHTMLStyle("BeginTime,EndTime,ContentType"," ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setHTMLStyle("ContentLength"," style={width:50px} ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setHTMLStyle("FileName"," style={width:150px} ondblclick=\"javascript:parent.viewFile()\" ");
    doTemp.setAlign("ContentLength","3");
    //���ɲ�ѯ��
  	doTemp.setColumnAttribute("LCustomerName,DCustomerName","IsFilter","1");
  	doTemp.generateFilters(Sqlca);
  	doTemp.parseFilterData(request,iPostChange);
  	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
			{"false","","Button","����","����һ����ظ�����Ϣ","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"false","","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
			{"false","","Button","�ϴ�/�鿴�ĵ�","�鿴��������","viewDoc()",sResourcesPath}
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
		popComp("CaseInfo","/BusinessManage/CaseInfo.jsp","BatchNo=<%=sBatchNo%>","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=�鿴����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    	{
        	alert("��ѡ��һ����¼��");
			return;
    	}
    	else
    	{
    		popComp("CaseInfo","/BusinessManage/CaseInfo.jsp","BatchNo=<%=sBatchNo%>&SerialNo="+sSerialNo,"");
    		reloadSelf();
		}
	}
	/*~[Describe=�ϴ�����;InputParam=��;OutPutParam=��;]~*/	
	function uploadFile()
	{
		var sBatchNo= getItemValue(0,getRow(),"BatchNo");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		popComp("AttachmentChooseDialog","/Common/Document/AttachmentChooseDialog.jsp","BatchNo="+sBatchNo+"&SerialNo="+sSerialNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewFile()
	{
		var sDocNo= getItemValue(0,getRow(),"DocNo");
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		else
		{
			popComp("AttachmentView","/Common/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
			reloadSelf();
		}
	}
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function exportFile()
	{
		//����������Ϣ       
    	OpenPage("/BusinessManage/Document/ExportFile.jsp","_self","");
	}
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
			{
        		as_del('myiframe0');
        		as_save('myiframe0'); 
    		}
		}
		
	}	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewDoc()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����		     	
    	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}
    	else
    	{
    		sReturn=popComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType=Case&ObjectNo="+sSerialNo,"");
            reloadSelf(); 
        }
	}
	</script>
<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	hideFilterArea();
	my_load(2,0,'myiframe0');
</script>
<%@	include file="/IncludeEnd.jsp"%>