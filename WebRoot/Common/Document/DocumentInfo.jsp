<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: ��ҵ�2005-08-17
			Tester:
			Describe:�ĵ�������Ϣ
			Input Param:
			     ObjectNo: ������
	             ObjectType: ��������
	             DocNo: �ĵ����
			Output Param:
			HistoryLog:

		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "�ĵ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	//����������
	String sObjectType=DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"))); 
	String sObjectNo=DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")));
	//���ҳ��������ĵ���ź��ĵ�¼����ID
	String sDocNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocNo")));
	String sUserID =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID")));
	String sAutoFinish =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AutoFinish")));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = {
	                            {"DocTitle","�ĵ�����"},
	                            {"DocType","�ĵ�����"},
	                            {"DocImportance","�ĵ���Ҫ��"},
	                            {"DocSource","�ĵ���Դ"},
	                            {"DocUnit","���Ƶ�λ"},
	                            {"DocDate","�½�����"},
	                            {"DocAttribute","�ĵ�����"},
	                            {"Remark","��ע"},
	                            {"UserName","�Ǽ���"},
	                            {"OrgName","�Ǽǻ���"},
	                            {"InputTime","�Ǽ�����"},
	                            {"UpdateTime","��������"}
	                          };

	    String sSql = " select DocNo,DocTitle,DocImportance,DocSource,DocUnit,DocDate,DocAttribute," +
	                  " Remark,OrgID,OrgName,UserID,UserName,InputTime,UpdateTime from DOC_LIBRARY "+
	                  " where DocNo = '" + sDocNo + "' ";
		//����ASDataObject����doTemp
	   	ASDataObject doTemp = new ASDataObject(sSql);
	   	//�����ͷ
		doTemp.setHeader(sHeaders);
		//���ÿɸ��µı�
		doTemp.UpdateTable = "DOC_LIBRARY";
		//���ùؼ���
		doTemp.setKey("DocNo",true);
		//�����Ƿ�ɼ�
		doTemp.setVisible("DocNo,OrgID,UserID",false);
		//���ñ�����
		doTemp.setRequired("DocTitle",true);

		//����������
		//doTemp.setDDDWCode("DocType","DocStyle");
		doTemp.setDDDWCode("DocImportance","DocImportance");
		doTemp.setDDDWSql("DocAttribute","select ItemNo,ItemName from Code_Library where CodeNo = 'DocumentKind' and ItemNo <>'02' and IsInUse='1'");
		doTemp.setDefaultValue("DocImportance","01");

	    //�༭��ʽΪ��ע������Ӧ��ʾģ���еı༭��ʽ1���ı���2��ѡ���3����ע������ʼΪ�ı���
		doTemp.setEditStyle("Remark","3");
		//����ֻ������
		doTemp.setReadOnly("OrgName,UserName,InputTime,UpdateTime",true);
		//���������ͣ���Ӧ��ʾģ���еĸ�ʽ1���ַ�����2���֣���С������3�����ڣ�4��ʱ�䣬5����������
		doTemp.setCheckFormat("DocDate","3");
		//��html��ʽ
		doTemp.setEditStyle("Remark","3");
		doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px};overflow:scroll ");
		doTemp.setHTMLStyle("DocTitle,DocSource"," style={width:200px}");
		doTemp.setHTMLStyle("UserName,AttachmentCount,InputTime,UpdateTime"," style={width:80px} ");
		doTemp.setLimit("Remark",200);
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      //����Ϊfreeform���
		dwTemp.ReadOnly = "0"; //����Ϊ��ֻ��

		dwTemp.setEvent("AfterInsert","!DocumentManage.InsertDocRelative(#DocNo,"+sObjectType+","+sObjectNo+")");

		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/
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
			{(CurUser.UserID.equals(sUserID)?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{(CurUser.UserID.equals(sUserID)?"true":"false"),"","Button","�鿴/�޸ĸ���","�鿴/�޸�ѡ���ĵ���ص����и���","viewAndEdit_attachment()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","doReturn()",sResourcesPath}
			};
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=�鿴��������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit_attachment()
	{
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		var sUerID = getItemValue(0,getRow(),"UserID");//ȡ¼����ID
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{
        	alert("���ȱ����ĵ����ݣ����ϴ�������");  //��ѡ��һ����¼��
			return;
    	}
    	else
    	{
			popComp("AttachmentList","/Common/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUerID);
			//reloadSelf();
		}
	}
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		parent.sObjectInfo = sDocNo;
		parent.closeAndReturn();
	}

	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>

	<script language=javascript>
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		//У����������Ƿ���ڵ�ǰ����
		sDocDate = getItemValue(0,0,"DocDate");//��������
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����
		if(typeof(sDocDate) != "undefined" && sDocDate != "" )
		{
			if(sDocDate > sToday)
			{
				alert(getBusinessMessage('161'));//�������ڱ������ڵ�ǰ���ڣ�
				return false;
			}
		}

		return true;
	}

	function initRow()
	{
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"DocImportance","01");
			setItemValue(0,0,"DocDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo()
	{
		var sTableName = "DOC_LIBRARY";//����
		var sColumnName = "DocNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sDocNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sDocNo);
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
	//�����ļ���ֱ̨��ִ�У��Խ�ʡʱ��
	/*
	if("<%=sAutoFinish%>"=="true"){
		setItemValue(0,0,"DocTitle","�����ļ�_<%=StringFunction.getNow()%>");
		setItemValue(0,0,"DocAttribute","02");
		saveRecord();
		bCheckBeforeUnload=false;
		doReturn();
	}
	*/
</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>