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
	       		�ĵ����:DocNo
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
	String sDocNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	if(sDocNo == null) sDocNo = "";
	if(sUserID == null) sUserID = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = 	{ 
                            	{"AttachmentNo","���"},
                            	{"FileName","��������"},
                            	{"BeginTime","���Ϳ�ʼʱ��"},
                            	{"EndTime","���ͽ���ʱ��"},
                            	{"ContentType","���"},
                            	{"ContentLength","�ĵ�����(�ֽ�)"}
	     			};    		                     
	
	    
    	//����SQL���
    	
	sSql = 	" SELECT DocNo,AttachmentNo,FileName,BeginTime,EndTime,ContentType,ContentLength"+
           	" FROM DOC_ATTACHMENT WHERE DocNo='"+ sDocNo +"' ORDER BY AttachmentNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����б��ͷ
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable = "DOC_ATTACHMENT";
	doTemp.setKey("DocNo,AttachmentNo",true);	
	
    doTemp.setVisible("DocNo",false);
	doTemp.setHTMLStyle("AttachmentNo"," style={width:40px} ondblclick=\"javascript:parent.viewFile()\" ");
	doTemp.setHTMLStyle("BeginTime,EndTime,ContentType"," ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setHTMLStyle("ContentLength"," style={width:50px} ondblclick=\"javascript:parent.viewFile()\"");
	doTemp.setHTMLStyle("FileName"," style={width:150px} ondblclick=\"javascript:parent.viewFile()\" ");
    doTemp.setAlign("ContentLength","3");
	
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
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
			{(CurUser.UserID.equals(sUserID)?"true":"false"),"","Button","����","����һ����ظ�����Ϣ","newRecord()",sResourcesPath},
			{"true","","Button","�鿴����","�鿴��������","viewFile()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
			
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
		var sDocNo="<%=sDocNo%>";
		//popComp("AttachmentChooseDialog","/Document/AttachmentChooseDialog.jsp","DocNo="+sDocNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		popComp("FileChooseDialog","/Document/FileChooseDialog.jsp","DocNo="+sDocNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
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
	function viewFile()
	{
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		var sDocNo= getItemValue(0,getRow(),"DocNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		else
		{
			popComp("AttachmentView","/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
		}
	}
		
	function goBack()
	{
		self.close();
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
