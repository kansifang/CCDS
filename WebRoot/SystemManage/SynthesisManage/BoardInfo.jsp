<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: ndeng 2005-04-20 
			Tester:
			Describe: ����֪ͨ���
			Input Param:
		OrgID��
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
		String PG_TITLE = "֪ͨ���"; // ��������ڱ��� <title> PG_TITLE </title>
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

	String sBoardNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("BoardNo"));
	if(sBoardNo==null) sBoardNo="";
	
	//���ҳ�����
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = { {"BoardNo","������"},
	    	                        {"BoardName","��������"},
	    	                        {"BoardTitle","�������"},
	    				            {"BoardDesc","��������"},
	    				            {"IsPublish","�Ƿ񷢲�"},
	    				            {"ShowToOrgs","���ܻ���"},
	    				            {"IsNew","�Ƿ���"},
	                				{"IsEject","�Ƿ񵯳�"},
	                				{"FileName","�����ļ���"},
	                				{"ContentType","��������"},
	                				{"ContentLength","���ݳ���"},
	                				{"UploadTime","�ϴ�ʱ��"}
			            }; 	 

		String sSql ="select BoardNo,BoardName,BoardTitle,BoardDesc,IsPublish,ShowToOrgs,IsNew,IsEject,FileName,"+
			        "ContentType,ContentLength,UploadTime "+
			        "from BOARD_LIST "+
			        "where BoardNo = '"+sBoardNo+"' ";	
	                	
	    ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "BOARD_LIST"; 

		doTemp.setKey("BoardNo",true);
		doTemp.setVisible("BoardNo",false);
		doTemp.setDDDWCode("IsPublish,IsNew,IsEject","YesNo");
		doTemp.setDefaultValue("IsPublish,IsNew,IsEject","1");
		doTemp.setReadOnly("ShowToOrgs,FileName,ContentType,ContentLength,UploadTime",true);
		doTemp.setHTMLStyle("BoardTitle,FileName,BoardDesc"," style={width:300px}");
		doTemp.setRequired("BoardName,BoardTitle",true);
		doTemp.setUnit("ShowToOrgs"," <input class=\"inputdate\" value=\"...\" type=button value=.. onclick=parent.selectOrgs()>");
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
		//����HTMLDataWindow
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
			{"true","","Button","�ϴ��ļ�","�ϴ��ļ�","fileadd()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	function fileadd()
	{
		sBoardNo = getItemValue(0,getRow(),"BoardNo");
	    if(typeof(sBoardNo)=="undefined" || sBoardNo.length==0) {
			alert("�ȱ�����Ϣ���ϴ��ļ�!");
	        return ;
		}
		popComp("FileAdd","/SystemManage/SynthesisManage/FileAdd.jsp","BoardNo="+sBoardNo,"dialogWidth=550px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/BoardList.jsp","_self","");
	}

	/*~[Describe=ѡ������б�;InputParam=��;OutPutParam=��;]~*/
	function selectOrgs()
	{
		sBoardNo = getItemValue(0,getRow(),"BoardNo");
		var OrgList = PopPage("/SystemManage/SynthesisManage/DefaultOrgSelect.jsp?rand="+randomNumber(),"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
		if (typeof(OrgList)=="undefined" || OrgList=="_none_" || OrgList.length==0)
		return;
		OrgList = OrgList.replace(/,/g,"@");
		alert(OrgList);
		RunMethod("BusinessManage","insertBoardListOrgs",sBoardNo+","+OrgList);
		reloadSelf();
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

	}


	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BOARD_LIST";//����
		var sColumnName = "BoardNo";//�ֶ���
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
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
