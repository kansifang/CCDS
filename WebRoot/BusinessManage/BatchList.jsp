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
                            	{"DocTitle","��������"},
                            	{"DocType","����ʹ��ģ��"},
                            	{"DocDate","���ν�������"},
                            	{"TotalCaseCount","���������"}, 
                            	{"TotalCaseSum","�����ί��"},
                            	{"\"040CaseCount\"","�ѷ���������"}, 
                            	{"\"040CaseSum\"","�ѷ�����ί��"},
                            	{"ImportFlagN","�����Ƿ��ѵ���"},
                            	{"UserName","�Ǽ���"},
                            	{"OrgName","�Ǽǻ���"},
                            	{"InputTime","�Ǽ�����"},
                            	{"UpdateTime","��������"}
                           	};                           
    	//����SQL���
    String sSql = " SELECT BatchNo,DocTitle,DocType,DocDate," + 
		  " getCaseSum(BatchNo,1,'all') as TotalCaseCount,"+
		  " getCaseSum(BatchNo,2,'all') as TotalCaseSum,"+
		  " getCaseSum(BatchNo,1,'040') as \"040CaseCount\","+//�����ֿ�ͷ�ı�����������д
		  " getCaseSum(BatchNo,2,'040') as \"040CaseSum\","+
    	  " ImportFlag,getItemName('YesNo',ImportFlag) as ImportFlagN,OrgName,UserID,UserName,InputTime,UpdateTime " +
		  " FROM Batch_Info" +
		  " WHERE Status='"+sStatus+"'";
	//����ASDataObject����doTemp
    ASDataObject doTemp = new ASDataObject(sSql);
    //���ñ�ͷ
    doTemp.setHeader(sHeaders);
    //�ɸ��µı�
    doTemp.UpdateTable = "Batch_Info";
    //���ùؼ���
	doTemp.setKey("BatchNo",true);
	//���ò��ɼ���
    doTemp.setVisible("UserID,ObjectNo,ObjectType,ImportFlag",false);
    //���÷��
    doTemp.setAlign("AttachmentCount","3");
    doTemp.setHTMLStyle("AttachmentCount","style={width:80px}");
    doTemp.setHTMLStyle("DocTitle"," style={width:140px}");
    doTemp.setHTMLStyle("UserName,OrgName,AttachmentCount,InputTime,UpdateTime"," style={width:80px} ");
    doTemp.setDDDWSql("DocType", "select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%'");
    doTemp.setHTMLStyle("BatchNo,DocTitle,DocType"," style={width:200px;height:20px;cursor:hand} onDBLClick=\"parent.viewConfigList()\"");
    //���ɲ�ѯ��
	doTemp.setColumnAttribute("DocTypeName,DocTitle","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

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
			{"010".equals(sStatus)?"true":"false","","Button","����","�����ĵ���Ϣ","newRecord()",sResourcesPath},
			{"true","","Button","��������","�鿴�ĵ�����","viewAndEdit()",sResourcesPath},
			{"010".equals(sStatus)?"true":"false","","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
			{"true","","Button","�鿴����","�鿴��������","viewDoc()",sResourcesPath},
			{"true","","Button","�ϴ�����","�鿴��������","uploadDoc()",sResourcesPath},
			{"010".equals(sStatus)?"true":"false","","Button","��������","�鿴��������","ImportBatch(1)",sResourcesPath},
			{"010".equals(sStatus)?"false":"false","","Button","��ɵ���","�鿴��������","FinishBatch()",sResourcesPath},
			{"020".equals(sStatus)?"false":"false","","Button","��������","�鿴��������","ImportBatch(2)",sResourcesPath},
			{"020".equals(sStatus)?"false":"false","","Button","ȡ����ɵ���","�鿴��������","unFinishBatch()",sResourcesPath},
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
		sReturn=popComp("BatchInfo","/BusinessManage/BatchInfo.jsp","","dialogWidth=50;dialogHeight=60;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
        reloadSelf();  
	}
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
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sBatchNo=getItemValue(0,getRow(),"BatchNo");
    	if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0){
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}else{
    		sReturn=popComp("BatchInfo","/BusinessManage/BatchInfo.jsp","BatchNo="+sBatchNo,"");
            reloadSelf(); 
        }
	}
	/*~[Describe=�ϴ�����;InputParam=1����2����;OutPutParam=��;]~*/
	function uploadDoc(){
		var sBatchNo=getItemValue(0,getRow(),"BatchNo");
		var sDocTitle=getItemValue(0,getRow(),"DocTitle");
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
    		sReturn=popComp("DocumentList","/Document/DocumentList.jsp","ObjectType=Batch&ObjectNo="+sBatchNo,"");
            reloadSelf(); 
        }
	}
	/*~[Describe=��������;InputParam=1����2����;OutPutParam=��;]~*/
	function ImportBatch(sType)
	{
		var sBatchNo=getItemValue(0,getRow(),"BatchNo");
		var sConfigNo=getItemValue(0,getRow(),"DocType");
		var sDocTitle=getItemValue(0,getRow(),"DocTitle");
		var sImportFlag=getItemValue(0,getRow(),"ImportFlag");
    	if (typeof(sBatchNo)=="undefined" || sBatchNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}
    	if (sType=="1" &&sImportFlag=="1")
    	{
        	alert("�������ѵ��룬�����ظ����룬��ϵ���ǰ���Σ����½������ٵ��룡");  //��ѡ��һ����¼��
			return;
    	}
   		var sReturn=popComp("FileChooseDialog","/Document/FileChooseDialog.jsp","PCNo="+sBatchNo+"&ConfigNo="+sConfigNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
   		if(typeof(sReturn)!=="undefined" && sReturn.length!==0){
   			//alert(sReturn);������ ��ReturnΪtrue
   			//RunMethod("PublicMethod","UpdateColValue","String@Status@020,Batch_Info,String@BatchNo@"+sBatchNo);
   	   		reloadSelf(); 
   		}
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
		function viewConfigList(){
			var sBatchNo = getItemValue(0,getRow(),"BatchNo");
			if(sBatchNo.length>0){
				popComp("CaseList","/BusinessManage/CaseList.jsp","BatchNo="+sBatchNo,"","");
			}
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
