<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: xxx 2005-08-17
			Tester:
			Describe:�ĵ���Ϣ�б�
			Input Param:
	       		    ObjectNo: ������
	       		    ObjectType: ��������           		
	        Output Param:

			HistoryLog:xxxx 2005/09/03 �ؼ����
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
	String sReportDate = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)request.getParameter("DOFILTER_1_1_VALUE")));//setFilter 
	String sConfigNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)request.getParameter("DOFILTER_DF1_1_VALUE")));//doTemp.setColumnAttribute("��������","IsFilter","1");
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][]	={};
	String sS=",";
	if("".equalsIgnoreCase(sConfigNo)){
		sS="";
	}else{
		sHeaders=Sqlca.getStringMatrix("select ItemDescribe,Attribute1 from Code_Library where CodeNo='"+sConfigNo+"' and IsInUse='1' order by SortNo asc");
		for(int i=0;i<sHeaders.length;i++){
	  		sS+=sHeaders[i][0]+",";
	  	}
	  	if(sS.length()>0){
	  		sS=sS.substring(0,sS.length()-1);
	  	}
	}
    	//����SQL���
    String sSql = " SELECT  ConfigNo as ��������,OneKey as ��������,ImportIndex as ���"+
    				sS+
    				",ImportNo as �����,ImportTime as ����ʱ��,UserID as ������"+
    	 			" FROM Batch_Import_Interim " +
		  			" WHERE 1=1 order by ImportNo asc";
	//����ASDataObject����doTemp
    ASDataObject doTemp = new ASDataObject(sSql);
    //���ñ�ͷ
    doTemp.setHeader(sHeaders);
    //�ɸ��µı�
    doTemp.UpdateTable = "Batch_Import_Interim";
    //���ùؼ���
	doTemp.setKey("ImportNo,ImportIndex",true);
	//���ò��ɼ���
    doTemp.setVisible("��������,ImportFlag",false);
    //���÷��
    //doTemp.setAlign("AttachmentCount","3");
    if(!"".equalsIgnoreCase(sConfigNo)){
    	doTemp.setHTMLStyle(2,"style={width:300px}");//��Ŀ�ӿ�
    	doTemp.setHTMLStyle(4,"style={width:300px}");//��Ŀ�ӿ�
	}
    doTemp.setHTMLStyle("ImportNo"," style={width:180px}");
    doTemp.setHTMLStyle("��������"," style={width:50px}");
    //���ɲ�ѯ��
    doTemp.setFilter(Sqlca, "1", "��������", "HtmlTemplate=PopSelect;");//������Զ���ʹ��---��֪��Ϊʲô������÷� ����ʾ��������ť���������filterAction�����޷�����
    //doTemp.setColumnAttribute("��������","IsFilter","1");
	//doTemp.setColumnAttribute("��������", "FilterOptions", "HtmlTemplate=PopSelect;");
	doTemp.setColumnAttribute("��������","IsFilter","1");
	doTemp.setColumnAttribute("��������", "FilterOptions", "Operators=EqualsString;");
    if(sHeaders.length!=0){
    	//doTemp.setHTMLStyle(DataConvert.toString(StringFunction.getAttribute(sHeaders,"��ͬ��ˮ��",1,0))," style={width:95px}");
        String CustomerName=DataConvert.toString(StringFunction.getAttribute(sHeaders,"�ͻ�����",1,0));
        if(!"".equals(CustomerName)){
        	doTemp.setHTMLStyle(CustomerName," style={width:250px}");
        	//���ɲ�ѯ��
            doTemp.setColumnAttribute(CustomerName,"IsFilter","1");
        }
        String ItemName=DataConvert.toString(StringFunction.getAttribute(sHeaders,"��Ŀ",1,0));
        if(!"".equals(ItemName)){
        	doTemp.setHTMLStyle(ItemName," style={width:260px}");
        	//���ɲ�ѯ��
            doTemp.setColumnAttribute(ItemName,"IsFilter","1");
        }
        String IName=DataConvert.toString(StringFunction.getAttribute(sHeaders,"��ĿItem",1,0));
        if(!"".equals(IName)){
        	doTemp.setHTMLStyle(IName," style={width:260px}");
        	//���ɲ�ѯ��
            doTemp.setColumnAttribute(IName,"IsFilter","1");
        }
       	//doTemp.setHTMLStyle(DataConvert.toString(StringFunction.getAttribute(sHeaders,"����",1,0))," style={width:20px}");
    }
    doTemp.setHTMLStyle("���"," style={width:25px}");
    doTemp.setDDDWSql("��������", "select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%' order by InputTime asc");
   // doTemp.setCheckFormat("��������", "3");
	doTemp.generateFilters(Sqlca);//�����doTemp.setColumnAttribute("��������","IsFilter","1")���������ѯ�� filterID ��DFΪǰ׺ �� DF1 DF2...
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) {
		 doTemp.WhereClause+=" and 1=2";
	}
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.iPageSize=20;
	//����setEvent
	dwTemp.setEvent("AfterDelete","!PublicMethod.DeleteColValue(Batch_Case,String@BatchNo@#BatchNo)");

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
				{"false","","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
				{"true","","Button","�鿴����","�鿴��������","viewDoc()",sResourcesPath},
				{"false","","Button","�ϴ�����","�鿴��������","uploadDoc()",sResourcesPath},
				{"false","","Button","��������","�鿴��������","ImportBatch('02')",sResourcesPath},
				{"false","","Button","�������","�鿴��������","summation()",sResourcesPath},
				{"true","","Button","��������","�鿴��������","ImportBatch('01')",sResourcesPath}
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
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����	
		sBatchNo = getItemValue(0,getRow(),"ImportNo");
		if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{ 
			if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
			{
				as_del('myiframe0');
				as_save('myiframe0'); //�������ɾ������Ҫ���ô����   
				mySelectRow();
				reloadSelf(); 
			} 
		}else{
			alert(getHtmlMessage('3'));
			return;
		}
	}
	/*~[Describe=�ϴ�����;InputParam=1����2����;OutPutParam=��;]~*/
	function uploadDoc(){
		var sBatchNo="<%=sConfigNo+sReportDate%>";
		var sDocTitle="S63";
    	if(typeof(sBatchNo)=="undefined" || sBatchNo.length==0){
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}
   		var sDocNo=RunMethod("PublicMethod","GetColValue","Doc_Library.DocNo,Doc_Relative@Doc_Library,None@Doc_Relative.DocNo@Doc_Library.DocNo@String@ObjectType@Batch@String@ObjectNo@"+sBatchNo+"@String@DocAttribute@01");
   		if(sDocNo.length==0){
   			sDocNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=Doc_Library&ColumnName=DocNo&Prefix=","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
   			RunMethod("PublicMethod","InsertColValue","String@DocNo@"+sDocNo+"@String@ObjectType@Batch@String@ObjectNo@"+sBatchNo+",Doc_Relative");
   			RunMethod("PublicMethod","InsertColValue","String@DocNo@"+sDocNo+"@String@DocTitle@"+sDocTitle+"_Ĭ���ļ���_<%=StringFunction.getNow()%>@String@DocAttribute@01@String@OrgID@<%=CurUser.OrgID%>@String@UserID@<%=CurUser.UserID%>@String@InputOrg@<%=CurUser.OrgID%>@String@InputUser@<%=CurUser.UserID%>@String@InputTime@<%=StringFunction.getToday()%>,Doc_Library");
   		}else{
   			sDocNo=sDocNo.split("@")[1];
   		}
   		popComp("FileChooseDialog","/Document/FileChooseDialog.jsp","BatchNo="+sBatchNo+"&DocModelNo=&DocNo="+sDocNo+"&Handler=&Message=�ϴ��ɹ�&Type=","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
   		reloadSelf(); 
	}
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewDoc()
	{
		var sBatchNo=getItemValue(0,getRow(),"��������");
		var sUserID=getItemValue(0,getRow(),"UserID");
    	if (typeof(sUserID)=="undefined" || sUserID.length==0)
    	{
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}else{
    		sReturn=popComp("DocumentList","/Document/DocumentList.jsp","ObjectType=Batch&ObjectNo="+sBatchNo,"");
            reloadSelf(); 
        }
	}
	/*~[Describe=��������;InputParam=1����2����;OutPutParam=��;]~*/
	function ImportBatch(sType)
	{
		//Doc_Relative ObjectType=Batch ObjectNo=ConfigNo 
		var sReturn=popComp("FileChooseDialog","/Document/FileChooseDialog.jsp","","dialogWidth=900px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") 
   			return;
   		sReturn = sReturn.split("@");
		var sConfigNo=sReturn[0];
		var sUploadMethod=sReturn[1];
		var sReportDates=sReturn[2];
		var sFiles=sReturn[3];
   		//2���ϴ��ļ��� �����������ݿⲢ�������ӹ�����
   		ShowMessage("���ڽ����ĵ��ϴ���ĺ�������,�����ĵȴ�.......",true,false);
   		sReturn=PopPage("/Data/Import/Handler.jsp?HandleType=AfterImport&ConfigNo="+sConfigNo+"&OneKeys="+sReportDates+"&UploadMethod="+sUploadMethod+"&Files="+encodeURIComponent(encodeURIComponent(sFiles,'UTF-8')),"","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
   		if(sReturn=="true"){
   			alert("����ɹ���");
   		}else{
   			alert("����ʧ�ܣ�");
   		}
   		try{hideMessage();}catch(e) {};
   		reloadSelf(); 
	}
	function summation()
	{
		var sCompID = "CreationInfo";
		var sCompURL = "/Data/Import/CreationInfo.jsp";
		var sReturn = popComp(sCompID,sCompURL,"","dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var configNo=sReturn[0];
		var oneKey=sReturn[1];
		PopPage("/Data/Process/S63Handler.jsp?Type=02&ConfigNo="+configNo+"&OneKey="+oneKey,"","dialogWidth=0;dialogHeight=0;minimize:yes");
   		alert("���ܳɹ�");
		reloadSelf(); 
	}
	/*~[Describe=��ɵ�������;InputParam=��;OutPutParam=��;]~*/
	function FinishBatch()
	{
		var sBatchNo=getItemValue(0,getRow(),"BatchNo");
    	if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}
		if(confirm("ȷ����ɵ��룿"))
		{
			RunMethod("PublicMethod","UpdateColValue","String@Status@020,Batch_Info,String@BatchNo@"+sBatchNo);
			//RunMethod("PublicMethod","UpdateColValue","String@Status@030,Batch_Case,String@BatchNo@"+sBatchNo);
	   		var sArg="ApplyCaseDistOT,SerialNo@Batch_Case@BatchNo@"+sBatchNo+",ApplyCaseDist,ApplyCaseDistFlow,0010,<%=CurUser.UserID%>,<%=CurUser.OrgID%>";
	   		RunMethod("WorkFlowEngine","AutoBatchInitializeFlow",sArg);
			reloadSelf(); 
		}
	}
	/*~[Describe=ȡ����������;InputParam=��;OutPutParam=��;]~*/
	function unFinishBatch()
	{
		var sBatchNo=getItemValue(0,getRow(),"BatchNo");
		var sFlag=getItemValue(0,getRow(),"\"040CaseCount\"");
    	if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0)
    	{
        	alert(getHtmlMessage(1));//��ѡ��һ����¼��
			return;
    	}
    	if(sFlag!=="0"){
    		alert("��ǰ���������а������䣬����ȡ����");//��ѡ��һ����¼��
			return;
    	}
    	if(confirm("ȷ��ȡ����ɵ��룿")){
    		RunMethod("PublicMethod","UpdateColValue","String@Status@010,Batch_Info,String@BatchNo@"+sBatchNo);
    		RunMethod("PublicMethod","DeleteColValue","Flow_Object,String@ObjectType@ApplyCaseDistOT@Exists@None@select 1 from Batch_Case where Batch_Case.SerialNo=Flow_Object.ObjectNo and BatchNo='"+sBatchNo+"'");
    		RunMethod("PublicMethod","DeleteColValue","Flow_Task,String@ObjectType@ApplyCaseDistOT@Exists@None@select 1 from Batch_Case where Batch_Case.SerialNo=Flow_Task.ObjectNo and BatchNo='"+sBatchNo+"'");
    		reloadSelf(); 
		}
	}
	/*~[Describe=��ѯ����;InputParam=;OutPutParam=SerialNo;]~*/
	function filterAction(sInputValue,sFilterID,sInputDisplay)
	{
		var oMyObj = document.all(sInputValue);
		var oMyObj2 = document.all(sInputDisplay);
		if(sFilterID=="1"){
			getIndustryType(oMyObj,oMyObj2);
		}
	}
	/*~[Describe=����������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType(id,name){
		//������ҵ��������м������������ʾ��ҵ����
		var sIndustryTypeInfo = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(typeof(sIndustryTypeInfo)=="undefined" || sIndustryTypeInfo.length==0){
			return;
		}else{
			id.value=sIndustryTypeInfo;
			name.value=sIndustryTypeInfo;
		}
	}
	document.all("DOFILTER_1_1_DISPLAY").value="<%=sReportDate%>";
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
			//var sBatchNo = getItemValue(0,getRow(),"BatchNo");
			//document.getElementById("ListHorizontalBar").parentNode.style.display="";
			//document.getElementById("ListDetailAreaTD").parentNode.style.display="";
			//OpenComp("CaseList","/BusinessManage/CaseList.jsp","BatchNo="+sBatchNo,"DetailFrame","");
	
		}
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
	bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	mySelectRow();
	hideFilterArea();
</script>
<%
	/*~END~*/
%>


<%@	include file="/IncludeEnd.jsp"%>