<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		
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
	String sObjectNo = "";//--������
	//����������
	String sBatchNo = DataConvert.toString( DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BatchNo")));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = {
	                            {"DocTitle","��������"},
	                            {"DocType","����ʹ��ģ��"},
	                            {"DocImportance","�ĵ���Ҫ��"},
	                            {"DocSource","ί����"},
	                            {"DocDate","�½�����"},
	                            {"DocAttribute","�ĵ�����"},
	                            {"Remark","��ע"},
	                            {"UserName","�Ǽ���"},
	                            {"OrgName","�Ǽǻ���"},
	                            {"InputTime","�Ǽ�����"},
	                            {"UpdateTime","��������"}
	                          };

	    String sSql = " select BatchNo,DocTitle,DocType,"+
	    			  " DocImportance,DocSource,"+
	                  " DocDate,DocAttribute,ImportFlag," +
	                  " Remark,OrgID,OrgName,"+
	                  " UserID,UserName,InputTime,"+
	                  " UpdateTime,Status "+//010 δ��� 020 ����ɵ���
	                  " from Batch_Info "+
	                  " where BatchNo = '" + sBatchNo + "' ";
		//����ASDataObject����doTemp
	   	ASDataObject doTemp = new ASDataObject(sSql);
	   	//�����ͷ
		doTemp.setHeader(sHeaders);
		//���ÿɸ��µı�
		doTemp.UpdateTable = "Batch_Info";
		//���ùؼ���
		doTemp.setKey("BatchNo",true);
		//�����Ƿ�ɼ�
		doTemp.setVisible("BatchNo,OrgID,UserID,DocAttribute,DocSource,ImportFlag,DocImportance,Status",false);
		//���ñ�����
		doTemp.setRequired("DocTitle,DocType",true);

		//����������
		//doTemp.setDDDWCode("DocType","DocStyle");
		doTemp.setDDDWCode("DocImportance","DocImportance");
		doTemp.setDDDWCode("DocAttribute","select ItemNo,ItemName from Code_Library where CodeNo = 'DocumentKind' and ItemNo <>'02' and IsInUse='1'");
		doTemp.setDDDWSql("DocType", "select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%'");
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

		//dwTemp.setEvent("AfterInsert","!DocumentManage.InsertDocRelative(#BatchNo,"+sObjectType+","+sObjectNo+")");

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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CodeNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
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
			setItemValue(0,0,"ImportFlag","2");//����δ����
			setItemValue(0,0,"Status","010");//δ��ɵ���
			bIsInsert = true;
		}
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo()
	{
		var sTableName = "Batch_Info";//����
		var sColumnName = "BatchNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sBatchNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sBatchNo);
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
</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>