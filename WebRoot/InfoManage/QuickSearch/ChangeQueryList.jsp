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
	                           	{"SerialNo","��ˮ��"},
	                        	{"FatherCNo","�����"},
	                        	{"ChildCNo","�ӱ��"},
	                           	{"ChangeNo","�����"},
	                           	{"SystemName","ϵͳ����"},
	                           	{"Status","���״̬"},
	                           	{"Summary","ժҪ"},
	                           	{"CreateDate","����ʱ��"},
	                           	{"ChangeType","�������"},
	                           	{"ChangeUser","���������"},
	                           	{"BusinessPriority","ҵ�����ȼ�"},
	                           	{"FactoryPriority","�������ȼ�"},
	                           	{"FinallyTerm","����ʵ���ڴ�"},
	                           	{"ChangeConfirmDate","����������ʱ��"},
	                           	{"UATDate","�����ύ�汾ʱ��"},
	                           	{"RelativeSystem","�漰���ϵͳ"},
	                           	{"ChangeConfirmPerson","�������������Ա"},
	                           	{"ChangeWorker","������Ա"},
	                           	{"Problem","��������"},
	                           	{"MeetingContent","���۹���"},
	                           	{"Remark","��ע"},
	                           	{"BranchSpecial","������ɫ"},
	                           	{"ChangeCondition","����״̬"},
	                           	{"OutFactoryDate","���߰汾"},
	                           	{"BusinessWriteCondition","ҵ���д���"},
	                           	{"SoftWriteCondition","�����д���"},
	                           	{"SoftWriteDir","����Ŀ¼"},
	                           	{"BusinessReviewResult","ҵ��������"},
	                           	{"ProjectManagerReviewResult","��Ŀ������������"},
	                           	{"ChangeManagerReviewResult","������������"},
	                           	{"UpdateUserName","ά����"},
						       	{"UpdateTime","ά��ʱ��"}
	     					};    		                     
    	//����SQL���
	sSql = 	" SELECT BatchNo,SerialNo,"+
    		" ChangeNo,"+
			" SystemName,Status,Summary,CreateDate,"+
			" ChangeType,ChangeUser,BusinessPriority,FactoryPriority,"+
			" FinallyTerm,ChangeConfirmDate,UATDate,RelativeSystem,"+
			" ChangeConfirmPerson,ChangeWorker,Problem,"+
			" MeetingContent,Remark,BranchSpecial,"+
			" ChangeCondition,OutFactoryDate,BusinessWriteCondition,"+
			" SoftWriteCondition,SoftWriteDir,BusinessReviewResult,ProjectManagerReviewResult,"+
			" ChangeManagerReviewResult,"+
			" FatherCNo||'��'||(Select SystemName from Batch_Case BC1 where BC1.ChangeNo=BC.FatherCNo) as FatherCNo,"+
    		" getRowsToRow(ChangeNo) as ChildCNo,"+
			" getUserName(UpdateUserID) as UpdateUserName,UpdateTime"+
			//" getItemName('Status',Status) as Status"+
		    " FROM Batch_Case BC"+
			" WHERE 1=1 "+
           	("".equals(sBatchNo)?"":" and BatchNo='"+sBatchNo+"'");
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����б��ͷ
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable = "Batch_Case";
	doTemp.setKey("ChangeNo",true);	
	
    doTemp.setVisible("BatchNo,SerialNo",false);
	doTemp.setHTMLStyle("ChangeNo,SystemName,Status","ondblclick=\"javascript:parent.viewAndEdit()\"");
    doTemp.setHTMLStyle("Summary"," style={width:300px;cursor:hand} onDBLClick=\"javascript:parent.viewAndEdit()\"");
    doTemp.setHTMLStyle("ChildCNo"," style={width:400px;cursor:hand} onDBLClick=\"javascript:parent.viewAndEdit()\"");
    //doTemp.setDDDWCode("SystemName", "SystemType");
    //���ɲ�ѯ��
  	doTemp.setColumnAttribute("Status,ChangeNo,SystemName,Summary,ChangeUser,FinallyTerm,OutFactoryDate","IsFilter","1");
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
			{CurUser.hasRole("482")?"true":"false","","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
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
		var sChangeNo = getItemValue(0,getRow(),"ChangeNo");
		var sSystemName = getItemValue(0,getRow(),"SystemName");
		if (typeof(sChangeNo)=="undefined" || sChangeNo.length==0){
        	alert("��ѡ��һ����¼��");
			return;
    	}
   		popComp("CaseInfo","/BusinessManage/CaseInfo.jsp","BatchNo=<%=sBatchNo%>&ChangeNo="+sChangeNo+"&SystemName="+sSystemName,"");
   		reloadSelf();
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
		var sChangeNo = getItemValue(0,getRow(),"ChangeNo");
		if (typeof(sChangeNo)=="undefined" || sChangeNo.length==0)
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