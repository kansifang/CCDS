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
	String sReportType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)request.getParameter("DOFILTER_DF1_1_VALUE")));
	String sReportDate = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)request.getParameter("DOFILTER_3_1_VALUE")));
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
	if("".equalsIgnoreCase(sReportType)){
		sS="";
	}else{
		sHeaders=Sqlca.getStringMatrix("select ItemDescribe,Attribute1 from Code_library where  CodeNo='"+sReportType+"' and IsInUse='1' order by ItemNo asc");
	  	for(int i=0;i<sHeaders.length;i++){
	  		sS+=sHeaders[i][0]+",";
	  	}
	  	if(sS.length()>0){
	  		sS=sS.substring(0,sS.length()-1);
	  	}
	}
    	//����SQL���
    String sSql = " SELECT  ReportType as ��������,ReportDate as ��������"+sS+
    	 " FROM Batch_Import" +
		  " WHERE 1=1";
	//����ASDataObject����doTemp
    ASDataObject doTemp = new ASDataObject(sSql);
    //���ñ�ͷ
    doTemp.setHeader(sHeaders);
    //�ɸ��µı�
    doTemp.UpdateTable = "Batch_Import";
    //���ùؼ���
	doTemp.setKey("ImportNo",true);
	//���ò��ɼ���
    doTemp.setVisible("��������,ObjectNo,ObjectType,ImportFlag",false);
    //���÷��
    doTemp.setAlign("AttachmentCount","3");
    if(!"".equalsIgnoreCase(sReportType)){
    	doTemp.setHTMLStyle(2,"style={width:300px}");
	}
    doTemp.setHTMLStyle("DocTitle"," style={width:140px}");
    doTemp.setHTMLStyle("UserName,OrgName,AttachmentCount,InputTime,UpdateTime"," style={width:80px} ");
    doTemp.setDDDWSql("��������", "select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%'");
   // doTemp.setCheckFormat("��������", "3");
    //���ɲ�ѯ��
	doTemp.setColumnAttribute("��������","IsFilter","1");
	doTemp.setColumnAttribute("��������", "FilterOptions", "Operators=EqualsString");
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca, "3", "��������", "HtmlTemplate=PopSelect;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 
	 if(!doTemp.haveReceivedFilterCriteria()) {
		 doTemp.WhereClause+=" and 1=2";
	 }
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.iPageSize=10;
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
				{"true","","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
				{"true","","Button","�鿴����","�鿴��������","viewDoc()",sResourcesPath},
				{"true","","Button","�ϴ�����","�鿴��������","uploadDoc()",sResourcesPath},
				{"true","","Button","��������","�鿴��������","ImportBatch(1)",sResourcesPath},
				{"true","","Button","��������","�鿴��������","ImportBatch(2)",sResourcesPath}
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
		sBatchNo = getItemValue(0,getRow(),"BatchNo");
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
		var sBatchNo="<%=sReportType+sReportDate%>";
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
   		popComp("FileChooseDialog","/Common/Document/FileChooseDialog.jsp","BatchNo="+sBatchNo+"&DocModelNo=&DocNo="+sDocNo+"&Handler=&Message=�ϴ��ɹ�&Type=","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
   		reloadSelf(); 
	}
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewDoc()
	{
		sBatchNo=getItemValue(0,getRow(),"BatchNo");
		sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����		     	
    	if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}
    	else
    	{
    		sReturn=popComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType=Batch&ObjectNo="+sBatchNo,"");
            reloadSelf(); 
        }
	}
	/*~[Describe=��������;InputParam=1����2����;OutPutParam=��;]~*/
	function ImportBatch(sType)
	{
		var sCompID = "CreationInfo";
		var sCompURL = "/BusinessManage/WorkReport/CreationInfo.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") 
			return;
		sReturn = sReturn.split("@");
		var sReportType=sReturn[0];
		var sReportDate=sReturn[1];
		var sBatchNo=sReportType+sReportDate;
   		var sDocNo=RunMethod("PublicMethod","GetColValue","Doc_Library.DocNo,Doc_Relative@Doc_Library,None@Doc_Relative.DocNo@Doc_Library.DocNo@String@ObjectType@Batch@String@ObjectNo@"+sBatchNo+"@String@DocAttribute@02");
   		if(sDocNo.length==0){
   			sDocNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=Doc_Library&ColumnName=DocNo&Prefix=","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
   			RunMethod("PublicMethod","InsertColValue","String@DocNo@"+sDocNo+"@String@ObjectType@Batch@String@ObjectNo@"+sReportType+"_"+sReportDate+",Doc_Relative");
   			RunMethod("PublicMethod","InsertColValue","String@DocNo@"+sDocNo+"@String@DocTitle@"+sReportType+"_"+sReportDate+"_<%=StringFunction.getNow()%>@String@OrgID@<%=CurUser.OrgID%>@String@UserID@<%=CurUser.UserID%>@String@InputOrg@<%=CurUser.OrgID%>@String@InputUser@<%=CurUser.UserID%>@String@InputTime@<%=StringFunction.getToday()%>,Doc_Library");
   		}else{
   			sDocNo=sDocNo.split("@")[1];
   		}
   		popComp("FileChooseDialog","/Common/Document/FileChooseDialog.jsp","DocModelNo="+sReportType+"&DocNo="+sDocNo+"&Handler=S63Handler&Message=���ε���ɹ�&Type="+sType+"&ReportType="+sReportType+"&ReportDate="+sReportDate,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
	/*~[Describe=��ѯ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function filterAction(sObjectID,sFilterID,sObjectID2)
	{
		var oMyObj = document.all(sObjectID);
		var oMyObj2 = document.all(sObjectID2);
		if(sFilterID=="3"){
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
	document.all("DOFILTER_3_1_DISPLAY").value="<%=sReportDate%>";
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
			var sBatchNo = getItemValue(0,getRow(),"BatchNo");
			document.getElementById("ListHorizontalBar").parentNode.style.display="";
			document.getElementById("ListDetailAreaTD").parentNode.style.display="";
			OpenComp("CaseList","/BusinessManage/CaseList.jsp","BatchNo="+sBatchNo,"DetailFrame","");
	
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