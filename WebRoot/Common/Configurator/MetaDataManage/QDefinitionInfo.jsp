<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   CYHui  2003.8.18
			Tester:
			Content: ��ҵծȯ������Ϣ_List
			Input Param:
		                CustomerID���ͻ����
		                CustomerRight:Ȩ�޴���----01�鿴Ȩ��02ά��Ȩ��03����ά��Ȩ
			Output param:
			                CustomerID����ǰ�ͻ�����Ŀͻ���
			              	Issuedate:��������
			              	BondType:ծȯ����
			                CustomerRight:Ȩ�޴���
			                EditRight:�༭Ȩ�޴���----01�鿴Ȩ��02�༭Ȩ
			History Log: 
			                 2003.08.20 CYHui
			                 2003.08.28 CYHui
			                 2003.09.08 CYHui 
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "��ѯ����ά��ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql;
	
	//����������

	//���ҳ�����	
	//���ҳ�����	
	String sDocNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("docNo")));
	String sAttachmentNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("attachmentNo")));
	//String sColumn = DataConvert.toString(DataConvert.toRealString(5,(String)CurPage.getParameter("R0F4")));���������
	String sColumn = DataConvert.toString(DataConvert.decode(request.getParameter("R0F4"),"UTF-8"));
	String sMethod = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("method")));
%>
<%
	/*~END~*/
%>

<%
	String sDescribeCount = "";
	String sUpdate0 = "";
	if(sMethod.equals("2")){ //2:update docContect
		//html����������У���ԭ�ⲻ���������ݿ⣬��ȡʱ��setItemValue(0,0,"Column",sColumn)ʱ �����
		//setItemValue(0,0,"Column","zzz
		//		yyy"),����Ȼ��js��java��һ���ַ������ж��������ӷ��������⣬�����⴦���
		sColumn=sColumn.replaceAll("[\r\n]", "");
		byte abyte0[] = sColumn.getBytes("GBK");
		sUpdate0 = "update Doc_Attachment set DocContent=?,ContentLength=?,UpdateTime='"+StringFunction.getToday()+"' "+
					" where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'";
		PreparedStatement pre0 = Sqlca.conn.prepareStatement(sUpdate0);
		pre0.clearParameters();
		pre0.setBinaryStream(1, new ByteArrayInputStream(abyte0,0,abyte0.length), abyte0.length);
		pre0.setString(2, DataConvert.toString(String.valueOf(abyte0.length)));
		pre0.executeUpdate();
		pre0.close();	   				
	}//else if(sMethod.equals("1")){//1:display 
	StringBuffer sb=new StringBuffer("");
	ASResultSet rs1 = Sqlca.getResultSet("select ContentLength from Doc_Attachment"+
							" where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
	if(rs1.next()){		
		int iContentLength=DataConvert.toInt(rs1.getString("ContentLength"));
		if (iContentLength>0){
			byte bb[] = new byte[iContentLength];
			int iByte = 0;		
			java.io.InputStream inStream = null;
			ASResultSet rs2 = Sqlca.getResultSet2("select DocContent from Doc_Attachment"+
					" where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");//ע����getResultSet2
			if(rs2.next()){
				inStream = rs2.getBinaryStream("DocContent");
				while(true){
					iByte = inStream.read(bb);
					if(iByte<=0)
						break;
					sb.append(new String(bb,"GBK"));
				}
			}
			rs2.getStatement().close();
		}
	}
	rs1.getStatement().close();	
	sColumn=sb.toString().replaceAll("\"", "'");
	//}
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sTempletNo = "QDefinition";
		String sTempletFilter = "1=1";
		
		ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
		//��ѯ
	 	//doTemp.setColumnAttribute(sKeyColumn,"IsFilter","1");
		//doTemp.generateFilters(Sqlca);
		//doTemp.parseFilterData(request,iPostChange);
		//CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
		//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		dwTemp.setPageSize(10);
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sDocNo+","+sAttachmentNo);
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
			{"true","","Button","���沢����","���������޸���","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
			{"true","","Button","��ѯ","ά�����ݿ�","handleDatabase()",sResourcesPath}
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
	<script language=javascript src="<%=sWebRootPath%>/Common/Configurator/MetaDataManage/editor.js"> </script>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0","reloadSelf()");
		
		updateHtmlData();
		//goBack();
	}
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		parent.sObjectInfo="OK";
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
		initSerialNo();//��ʼ����ˮ���ֶ�
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
		setItemValue(0,0,"InputTime",sNow);
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sNow);
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"DocNo","<%=sDocNo%>");
			setItemValue(0,0,"QStyle","01");
			bIsInsert = true;
		}
		setItemValue(0,0,"Column","<%=sColumn%>");
		//���ڱ������������α�ҳ�棬һ���Ǹ���Blob��һ��ˢ�£�����ʱAttachmentNo����ֵ��������Blobʱ���䱻��գ������ڴ�
		//�������ϣ���ˢ��ʱ����ֵ��
		var sAttachmentNo=getItemValue(0,0,"AttachmentNo");
		setItemValue(0,0,"AttachmentNo",sAttachmentNo);
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "Doc_Attachment";//����
		var sColumnName = "AttachmentNo";//�ֶ���
		var sPrefix = "QDN";//ǰ׺
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
	<script type="text/javascript">
	<!--
	//according to value of QStyle,display different element
	function displayContent(element){
		var selectValue="";
		if(typeof(element) =="string"){
			selectValue=document.frames("myiframe0").document.all["R0F"+getColIndex(0,element)].value;
		}else if(typeof(element) =="object"){
			selectValue=element.value;
		}
		if(selectValue=="01"){
			setStyle("Column","none");
			setStyle("TableName,KeyColumn","block");
		}else if(selectValue=="02"){
			setStyle("Column","block");
			setStyle("TableName,KeyColumn","none");
		}
	}
	function setStyle(colnames,isDisplay){ 
		var myiframeWindow=document.getElementsByName("myiframe0")[0].contentWindow;
		var colNs=colnames.split(",");
		for(var i=0;i<colNs.length;i++){
			myiframeWindow.document.getElementsByName("R0F"+getColIndex(0,colNs[i]))[0].parentNode.parentNode.style.display=isDisplay;
		}
	}
	//����������ѯ��䵽FormatDoc_Data.htmlData
	function updateHtmlData()
	{
		var sDocNo="<%=sDocNo%>";
		var sAttachmentNo=getItemValue(0,0,"AttachmentNo");
		var sStyle=getItemValue(0,0,"QStyle");
		var objectArray =document.frames("myiframe0").document.getElementsByName("R0F4");
		//�Ա����ݽ��б��룬�ڷ������DataConvert.toRealString(5,s)��DataConvert.decode(s,"GBK")���н���
		//objectArray[0].value=asConvU2G(objectArray[0].value); ���������
		objectArray[0].value=encodeURIComponent(objectArray[0].value,'UTF-8');
		var form1=document.frames("myiframe0").document.forms("form1");
		if(sStyle=="02"){
			form1.action=sWebRootPath+"/Common/Configurator/MetaDataManage/QDefinitionInfo.jsp?CompClientID=<%=sCompClientID%>&docNo="+sDocNo+"&attachmentNo="+sAttachmentNo+"&method=2";
		}else if(sStyle=="01"){
			form1.action=sWebRootPath+"/Common/Configurator/MetaDataManage/QDefinitionInfo.jsp?CompClientID=<%=sCompClientID%>&docNo="+sDocNo+"&attachmentNo="+sAttachmentNo+"&method=1";
		}
		form1.method='post';
		form1.target = "_parent";
		form1.submit();
	}
	//���ò�ѯ������ɲ�ѯҳ��
	function handleDatabase()
	{
		//self.close();
		//OpenComp("QDefinitionInfo","/Common/Configurator/MetaDataManage/QDefinitionInfo.jsp","docNo=<%=sDocNo%>&attachmentNo=<%=sDocNo%>&method=1&CompClientID=<%=sCompClientID%>","_self");

		var iframe0 =document.frames("myiframe0");
		//�Ա����ݽ��б��룬�ڷ������DataConvert.toRealString(5,s)��DataConvert.decode(s,"GBK")���н���
		for(var i=0;i<DZ[0][1].length;i++){
			var objectArray=iframe0.document.getElementsByName("R0F"+i);
			if(objectArray.length>0&&i!=3){
				iframe0.document.getElementsByName("R0F"+i)[0].value=asConvU2G(objectArray[0].value);
			}
		}
		var form1=iframe0.document.forms("form1");
		form1.action=sWebRootPath+"/Common/Configurator/MetaDataManage/QResultList.jsp?CompClientID=<%=sCompClientID%>";
		form1.method='post';
		form1.target = "_blank";
		form1.submit();
		//reloadSelf();
	}
	//-->
	</script>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	bCheckBeforeUnload=false;
	bNotCheckModified=true;
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	displayContent("QStyle");
	editor_generate('R0F4');
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>