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
	String sSerialNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = 	{ 
                            	{"SerialNo","ҵ���"},
                            	{"ActionType","ҵ������"},
                            	{"BeginTime","��ʼʱ��"},
                            	{"EndTime","����ʱ��"},
                            	{"Achievement","��ɹ�"},
                            	{"Remark","�ܽ�"},
                            	{"PhaseName","��ǰ�׶�"}
	     			};    		                     
	
	    
    	//����SQL���
    	
	sSql = 	" SELECT ObjectType,ObjectNo,FlowNo,PhaseNo,BCA.SerialNo,RelativeSerialNo,"+
				" getItemName('ActionType',ActionType) as ActionType,"+
				" BeginTime,"+
				" EndTime,Achievement,"+
				" Remark,"+
				" PhaseName"+
			    " FROM Batch_Case_Action BCA "+
				" left join Flow_Object FO"+
			    " on BCA.SerialNo=FO.ObjectNo"+
				" and FO.ObjectType in('ApplyCaseHelpOT','ApplyCaseOVisitOT')"+
			    " and FO.UserID='"+CurUser.UserID+"'"+
				" WHERE RelativeSerialNo='"+sSerialNo+"'"+
			    " order by SerialNo asc";
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����б��ͷ
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable = "Batch_Case_Action";
	doTemp.setKey("SerialNo",true);	
	
    doTemp.setVisible("RelativeSerialNo,ObjectType,ObjectNo,FlowNo,PhaseNo",false);
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
	dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
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
				{"true","","Button","����","����һ����ظ�����Ϣ","newRecord()",sResourcesPath},
				{"true","","Button","����","�鿴��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
				{"true","","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
				{"true","","Button","�ϴ�����","�鿴��������","uploadDoc()",sResourcesPath},
				{"true","","Button","�鿴����","�鿴��������","viewDoc()",sResourcesPath},
				{"true","","Button","ǩ�����","ɾ���ĵ���Ϣ","signCheckOpinion()",sResourcesPath},
				{"true","","Button","�ύ","�鿴��������","doSubmitIn()",sResourcesPath},
				{"true","","Button","�ջ�","�鿴��������","takeBack()",sResourcesPath}
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
		popComp("ActionInfo","/BusinessManage/Action/ActionInfo.jsp","RelativeSerialNo=<%=sSerialNo%>","dialogWidth=900px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
    		popComp("ActionInfo","/BusinessManage/Action/ActionInfo.jsp","SerialNo="+sSerialNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    		reloadSelf();
		}
	}
	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function doSubmitIn()
	{
		//��ö������͡������š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		//���������ˮ��
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert("��ѡ��һ��Э�߻���ü�¼��");
			return;
		}
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert("������Ѿ��ύ�ˣ������ٴ��ύ��");//�÷Ŵ������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}
		
		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		//����Ƿ�ǩ�����
		sReturn = PopPage("/Common/BusinessFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
			return;
		}
		//���������ύѡ�񴰿�		
		sPhaseInfo = PopPage("/Common/BusinessFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined") return;
		else if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			reloadSelf();
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else
		{
			sPhaseInfo = PopPage("/Common/BusinessFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success")
			{
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				reloadSelf();
			}else if (sPhaseInfo == "Failure")
			{
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}	
	}
	/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
	function signCheckOpinion()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ��Э�߻���ü�¼��");
			return;
		}
		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		sCompID = "SignOpinionInfo";
		sCompURL = "/Common/BusinessFlow/SignOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
	//�ջ�
	function takeBack(){
		//���ջ��������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = "0010";	
		//��ȡ������ˮ��
		sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0)
		{
			if(confirm(getBusinessMessage('498'))) //ȷ���ջظñ�ҵ����
			{
				sRetValue = PopPage("/Common/BusinessFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				reloadSelf();
			}
		}else
		{
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}				
	}
</script>
<script  language=javascript>
	/*~[Describe=�ϴ�����;InputParam=1����2����;OutPutParam=��;]~*/
	function uploadDoc(){
		var sObjectType="Action";
		var sObjectNo=getItemValue(0,getRow(),"SerialNo");
		var sDocAttribute="01";
		var sDocTitle="";
		if(typeof(sObjectNo)=="undefined"||sObjectNo.length==0){
	    	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		var sDocNo=RunMethod("PublicMethod","GetColValue","Doc_Library.DocNo,Doc_Relative@Doc_Library,None@Doc_Relative.DocNo@Doc_Library.DocNo@String@ObjectType@"+sObjectType+"@String@ObjectNo@"+sObjectNo+"@String@DocAttribute@"+sDocAttribute);
		if(sDocNo.length==0){
			sDocNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=Doc_Library&ColumnName=DocNo&Prefix=","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			RunMethod("PublicMethod","InsertColValue","String@DocNo@"+sDocNo+"@String@ObjectType@"+sObjectType+"@String@ObjectNo@"+sObjectNo+",Doc_Relative");
			RunMethod("PublicMethod","InsertColValue","String@DocNo@"+sDocNo+"@String@DocTitle@"+sDocTitle+"_Ĭ���ļ���_<%=StringFunction.getNow()%>@String@DocAttribute@"+sDocAttribute+"@String@OrgID@<%=CurUser.OrgID%>@String@UserID@<%=CurUser.UserID%>@String@InputOrg@<%=CurUser.OrgID%>@String@InputUser@<%=CurUser.UserID%>@String@InputTime@<%=StringFunction.getToday()%>,Doc_Library");
		}else{
			sDocNo=sDocNo.split("@")[1];
		}
		popComp("FileChooseDialog","/Common/Document/FileChooseDialog.jsp","DocNo="+sDocNo+"&Message=�ϴ��ɹ�","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf(); 
	}
	/*~[Describe=�鿴����;InputParam=��;OutPutParam=��;]~*/
	function viewDoc(){
		var sObjectType="Action";
		var sObjectNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
	    	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
			sReturn=popComp("DocumentList","/Common/Document/DocumentList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	        reloadSelf(); 
	    }
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
