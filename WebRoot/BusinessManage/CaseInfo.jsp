
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
	String sBatchNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BatchNo")));
	String sSerialNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));	
	String sEditable = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Editable")));
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
                            	{"ContentType","���"},
                            	{"ContentLength","�ĵ�����(�ֽ�)"},
                            	{"FileName","ί�з�"},
                            	{"BeginTime","���Ϳ�ʼʱ��"},
                            	{"EndTime","���ͽ���ʱ��"},
                            	{"ContentType","���"},
                            	{"ContentLength","�ĵ�����(�ֽ�)"}
	     			};    		                     
	
	    
    	//����SQL���
    	
	sSql = 	" SELECT BatchNo,SerialNo,DueNo,"+
			" LCustomerID,LCustomerName,LDate,LSum,DCustomerID,DCustomerName,"+
			" ID,CardNo,PayBackSum,PayBackDate,ActualPayBackSum,ActualPayBackDate,Balance,Remark,"+
			" BeginTime,EndTime"+
           	" FROM Batch_Case"+
			" WHERE SerialNo='"+sSerialNo+"'";
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
	doTemp.setReadOnly("SerialNo", true);
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����ΪGrid���
	dwTemp.ReadOnly = "0"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
	CurPage.setAttribute("ShowDetailArea","true");
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
			{"Y".equals(sEditable)?"true":"false","","Button","����","�鿴��������","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","doReturn()",sResourcesPath}
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
		as_save("myiframe0","");
	}
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CodeNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
</script>
<script language=javascript>
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
	function initRow(){
		if (getRowCount(0)== 0){//���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			setItemValue(0,0,"BatchNo","<%=sBatchNo%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"DocImportance","01");
			setItemValue(0,0,"DocDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"DocFlag","010");
			bIsInsert = true;
		}
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo()
	{
		var sTableName = "Batch_Case";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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
	var bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow();
	var sSerialNo = getItemValue(0,0,"SerialNo");//��������
	OpenPage("/BusinessManage/CaseLoanBack.jsp?SerialNo="+sSerialNo,"DetailFrame",OpenStyle);
</script>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>
