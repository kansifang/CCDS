<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.07      
		Tester:	
		Content: ���ݲɼ� ��������¼��
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������¼��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//��� sql���
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��ȡ�����ͻ���Ϣ������	
	String sHeaders[][] = { 
					{"AccountMonth","����·�"},
					{"AccountMonth1","����·�"},
					{"RptType","��������"},
					{"RptTypeName","��������"},
					{"OrgBelongID","��������"},
					{"OrgBelongIDName","��������"},
					{"InputUserID","¼����"},
					{"InputUserIDName","¼����"},
					{"InputDate","¼��ʱ��"}
	        }; 
    sSql = "select AccountMonth,AccountMonth as AccountMonth1,RptType,getItemName('RptType',RptType) as RptTypeName,"+
    	   " OrgBelongID,getOrgName(OrgBelongID) as OrgBelongIDName,InputUserID,getUserName(InputUserID) as InputUserIDName,InputDate " + 
  	       " from Reserve_Stat " +
  	       " where 1=1 ";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Stat";
    doTemp.setKey("AccountMonth,RptType",true);
    doTemp.setDDDWSql("RptType","select ItemNo,ItemName from code_library where codeno = 'RptType'");
  //  doTemp.setDDDWSql("AccountMonth","select distinct AccountMonth,AccountMonth from Reserve_Stat desc ");
//    doTemp.setColumnAttribute("AccountMonth,OrgBelongID","IsFilter","1");
    doTemp.setVisible("AccountMonth,OrgBelongID,RptType,InputUserID",false);
	//doTemp.setCheckFormat("AccountMonth","6");
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","AccountMonth","");
	doTemp.setFilter(Sqlca,"2","RptType","");
	doTemp.setFilter(Sqlca,"3","OrgBelongID","");
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()){
	//	doTemp.WhereClause += " and AccountMonth In (Select max(AccountMonth) from Reserve_Stat )";
	//}
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//������datawindows����ʾ������
	dwTemp.setPageSize(20); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("AccountMonth");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //����datawindow��Sql���÷���
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","�鿴����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	function newRecord()
	{
		var sAccountMonth = '';
		var sRptType = '';
		var sReturnValue = '';//--��ſͻ�������Ϣ
		var sReturnValue = PopPage("/BusinessManage/ReserveDataPrepare/AddReport.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sReturnValue) != "undefined" && sReturnValue.length != 0 && sReturnValue != '_CANCEL_')
		{
			sReturnValue = sReturnValue.split("@");
			sAccountMonth = sReturnValue[0];
			sRptType = sReturnValue[1];
		}
		else {
			return;
		}
		var sReturnValue = PopComp("ReportInfo","/BusinessManage/ReserveDataPrepare/ReportInfo.jsp","AccountMonth="+sAccountMonth+"&RptType="+sRptType,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");

		reloadSelf();
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sRptType = getItemValue(0,getRow(),"RptType");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReportInfo","/BusinessManage/ReserveDataPrepare/ReportInfo.jsp","AccountMonth="+sAccountMonth+"&RptType="+sRptType,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function deleteRecord(sPostEvents)
	{
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sInputUserID = getItemValue(0,getRow(),"InputUserID");
		if (typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		if(sInputUserID == "<%=CurUser.UserID%>"){
			if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
			{
				as_del("myiframe0");
				as_save("myiframe0",sPostEvents);  //�������ɾ������Ҫ���ô����
			}
		}else
		{
			alert("�������ݲ�����¼���,����ɾ��");
		}
	}
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	function filterAction(sObjectID,sFilterID,sObjectID2){
	oMyObj = document.all(sObjectID);
	oMyObj2 = document.all(sObjectID2);
	if(sFilterID=="1"){
		
	}else if(sFilterID=="3"){
			//����ģ̬����ѡ��򣬲�������ֵ����sReturn
			sReturn = selectObjectInfo("Code","CodeNo=OrgInfo^��ѡ����������^","");
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_"){
				return;
			}else if(sReturn=="_CLEAR_"){
				oMyObj.value="";
				oMyObj2.value="";
			}else{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				oMyObj2.value=sReturns[1];
			}
		}
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>