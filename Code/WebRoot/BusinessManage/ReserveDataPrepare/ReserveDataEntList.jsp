<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.07      
		Tester:	
		Content: ���ݲɼ������Թ�����ά��
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Թ�����ά��"; // ��������ڱ��� <title> PG_TITLE </title>
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
	String sHeaders[][]={
							{"AccountMonth","����·�"},
							{"AccountMonth1","����·�"},
	                        {"LoanAccount","��ݺ�"},
	                        {"DuebillNo","��ݱ��"},
	                        {"CustomerOrgCode","�ͻ���֯��������"},
	                        {"CustomerOrgCodeName","�ͻ���֯��������"},
	                        {"CustomerID","�ͻ����"},
	                        {"CustomerName","�ͻ�����"},
	                        {"IndustryType","��ҵ����"},
	                        {"Scope","��ҵ��ģ"},
	                        {"PutoutDate","������"},
	                        {"Maturity","������"},
	                        {"RMBBalance","���(Ԫ)"},
	                        {"MFiveClassify","�弶����"},
	                        {"MFiveClassifyName","�弶����"},
//	                        {"AFiveClassify","����弶����"},
//	                        {"AFiveClassifyName","����弶����"},
	                        {"AuditStatFlag","�Ƿ����"},
	                        {"AuditStatFlagName","�Ƿ����"},
	                        {"ManageStatFlag","����ģʽ"},
	                        {"ManageStatFlagName","����ģʽ"},                     
	                        {"Manageuserid","�ܻ���"},
	                        {"ManageuserName","�ܻ���"},
	                        {"ManageOrgID","�ܻ�����"},
	                        {"ManageOrgName","�ܻ�����"},
	                        {"Region","�ͻ����ڵ���"},
	                        {"LoanType","ҵ�����"}
                        };
    sSql = " select AccountMonth,AccountMonth as AccountMonth1,LoanAccount,DuebillNo,CustomerID,CustomerName,PutoutDate,"+
    	   " CustomerOrgCode,getOrgName(CustomerOrgCode) as CustomerOrgCodeName,IndustryType,Scope,"+
    	   " Maturity,RMBBalance,MFiveClassify,getItemName('MFiveClassify',MFiveClassify) as MFiveClassifyName,"+
    	   " AFiveClassify,getItemName('MFiveClassify',AFiveClassify) as AFiveClassifyName,"+
    	   " AuditStatFlag,getItemName('AuditStatFlag',AuditStatFlag) as AuditStatFlagName,ManageStatFlag,getItemName('ManageStatFlag',ManageStatFlag) as ManageStatFlagName,"+
    	   " Manageuserid,getUserName(Manageuserid) as ManageuserName, " +
    	   " ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName, "+
    	   " Region,LoanType "+
    	   " from Reserve_Total  " +
    	   " where BusinessFlag = '1'";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
//	doTemp.setColumnAttribute("AccountMonth,LoanAccount,CustomerName,AuditStatFlag,ManageStatFlag,ManageuserName","IsFilter","1");
	
    doTemp.UpdateTable="Reserve_Total";
    doTemp.setKey("AccountMonth,LoanAccount",true);
    doTemp.setVisible("AccountMonth,DuebillNo,CustomerOrgCode,CustomerOrgCodeName,CustomerID,IndustryType,"+
     	              "Scope,MFiveClassify,AFiveClassify,AFiveClassifyName,AuditStatFlag,ManageStatFlag,Manageuserid,ManageOrgID,"+
     	              "Region,LoanType",false);
    doTemp.setType("RMBBalance","Number") ;	              
    doTemp.setCheckFormat("AccountMonth1,PutoutDate,Maturity","3"); 	              
    //doTemp.setCheckFormat("AccountMonth","6");
    doTemp.setHTMLStyle("LoanAccount","style={width:150}");
    doTemp.setHTMLStyle("ManageOrgName,CustomerName","style={width:200}");    
    //doTemp.setDDDWSql("Scope","select ItemNo,ItemName from code_library where codeno = 'Scope'");
    //doTemp.setDDDWSql("IndustryType","select ItemNo,ItemName from code_library where codeno = 'IndustryType1'");
    //doTemp.setDDDWSql("AccountMonth","select distinct AccountMonth,AccountMonth from Reserve_Total desc ");
    doTemp.setDDDWSql("MFiveClassify","select ItemNo,ItemName from code_library where codeno = 'MFiveClassify'");
    doTemp.setDDDWSql("AFiveClassify","select ItemNo,ItemName from code_library where codeno = 'MFiveClassify'");
    doTemp.setHTMLStyle("AccountMonth,MFiveClassifyName,AuditStatFlagName,ManageStatFlagName,ManageuserName","style={width:80}");
    doTemp.setHTMLStyle("PutoutDate,Maturity,AFiveClassifyName","style={width:100}");
	doTemp.setDDDWSql("AuditStatFlag","select ItemNo,ItemName from code_library where codeno = 'AuditStatFlag' and isinuse='1'");
   	doTemp.setDDDWSql("ManageStatFlag","select ItemNo,ItemName from code_library where codeno = 'ManageStatFlag'");
   	
   	
    doTemp.generateFilters(Sqlca);
    doTemp.setFilter(Sqlca,"1","AccountMonth","");
    doTemp.setFilter(Sqlca,"2","LoanAccount","");
    doTemp.setFilter(Sqlca,"3","CustomerOrgCode","");
    doTemp.setFilter(Sqlca,"4","CustomerName","");
    doTemp.setFilter(Sqlca,"5","Region","");
    doTemp.setFilter(Sqlca,"6","IndustryType","");    
    doTemp.setFilter(Sqlca,"7","Scope","");        
    doTemp.setFilter(Sqlca,"8","RMBBalance","");
    doTemp.setFilter(Sqlca,"9","LoanType",""); 
    doTemp.setFilter(Sqlca,"10","MFiveClassify","Operators=EqualsString;");
    doTemp.setFilter(Sqlca,"11","AuditStatFlag","Operators=EqualsString;");    
    doTemp.setFilter(Sqlca,"12","ManageOrgID","");
    //doTemp.setFilter(Sqlca,"12","ManageOrgID","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()){
	//	doTemp.WhereClause += " and AccountMonth In (Select max(AccountMonth) from Reserve_Total )";
	//}
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//������datawindows����ʾ������
	dwTemp.setPageSize(25); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("LoanAccount");
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
//			{"true","","Button","�޸�","�޸�","update()",sResourcesPath},
			{"true","","Button","�鿴����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","����Excel","����Excel","exportAll()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�޸�;InputParam=��;OutPutParam=��;]~
	function update()
	{
		var sIsManageUser = false;
		var sManageUserID = getItemValue(0,getRow(),"Manageuserid");
		if(sManageUserID == "<%=CurUser.UserID%>")
		{
			sIsManageUser = true;
		}
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataEntInfo","/BusinessManage/ReserveDataPrepare/ReserveDataEntInfo.jsp","LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth+"&IsUpdate=true&IsManageUser="+sIsManageUser,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	*/
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sIsManageUser = false;
		var sManageUserID = getItemValue(0,getRow(),"Manageuserid");
		if(sManageUserID == "<%=CurUser.UserID%>")
		{
			sIsManageUser = true;
		}
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataEntInfo","/BusinessManage/ReserveDataPrepare/ReserveDataEntInfo.jsp","LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth+"&IsManageUser="+sIsManageUser,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
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
		
		}else if(sFilterID=="6"){
			//����ģ̬����ѡ��򣬲�������ֵ����sReturn
			sReturn = selectObjectInfo("Code","CodeNo=IndustryType^��ѡ����ҵ����^length(ItemNo)=1","");
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
		}else if(sFilterID=="5"){
			//����ģ̬����ѡ��򣬲�������ֵ����sReturn
			sReturn = selectObjectInfo("Code","CodeNo=AreaCode^��ѡ��ͻ����ڵ�^IsInUse=1","");
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
		}else if(sFilterID=="9"){
			//����ģ̬����ѡ��򣬲�������ֵ����sReturn
			sReturn = selectObjectInfo("Code","CodeNo=IndustryType^��ѡ����ҵ����^length(ItemNo)=1","");
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
		}else if(sFilterID=="12"){
			//����ģ̬����ѡ��򣬲�������ֵ����sReturn
			sReturn = selectObjectInfo("Code","CodeNo=OrgInfo^��ѡ��ܻ�����^","");
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
		}else if(sFilterID="7"){
			//����ģ̬����ѡ��򣬲�������ֵ����sReturn
			sReturn = selectObjectInfo("Code","CodeNo=Scope^��ѡ����ҵ��ģ^","");
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