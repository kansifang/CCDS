<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
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
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;

	//����������	
	String sAlertID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertID"));
	String sUserID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sAlertType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertType"));
	String sFinishedFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FinishedFlag"));
	//out.println(sUsersSelected);

	//���ҳ�����	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ExampleList";
	String sTempletFilter = "1=1";

	String[][] sHeaders = {
		{"ObjectName","��ʾ��ض���"},
		{"AlertTip","��ʾ��Ϣ"},
		{"Requirement","����Ҫ��"},
		{"UserID","������"},
		{"UserName","������"},
		{"Treatment","�������"},
		{"BeginTime","��ʼʱ��"},
		{"EndTime","���ʱ��"},
		};
		
	sSql = "select AL.ObjectType,AL.ObjectNo,GetObjectName(AL.ObjectType,AL.ObjectNo) as ObjectName,AL.AlertTip,AH.SerialNo,AH.HandleNo,AH.UserID,GetUserName(AL.UserID) as UserName,AH.Requirement,AH.Treatment,AH.BeginTime,AH.EndTime "+
		" from ALERT_HANDLE AH,ALERT_LOG AL "+
		" where AH.SerialNo=AL.SerialNo ";
	ASDataObject doTemp = new ASDataObject(sSql);
	
	if(sAlertID!=null) doTemp.WhereClause+=" and AH.SerialNo='"+sAlertID+"'";
	if(sAlertType!=null) doTemp.WhereClause+=" and AL.AlertType='"+sAlertType+"'";
	if(sUserID!=null) doTemp.WhereClause+=" and AH.UserID='"+sUserID+"'";
	if(sFinishedFlag==null) doTemp.WhereClause+=" and AH.EndTime is null";
	if(sFinishedFlag!=null&&sFinishedFlag.equals("FinishedAlarm")) doTemp.WhereClause+=" and AL.AlertType like 'AL%' and AH.EndTime is not null";
	if(sFinishedFlag!=null&&sFinishedFlag.equals("FinishedNotification")) doTemp.WhereClause+=" and AL.AlertType like 'NF%' and AH.EndTime is not null";
	
	
	//doTemp.multiSelectionEnabled=true;
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("SerialNo,HandleNo,UserID,ObjectType,ObjectNo",false);
	doTemp.setHTMLStyle("AlertTip","style={width:250px}");
	doTemp.setHTMLStyle("ObjectName","style={width:200px}");

	doTemp.setColumnAttribute("AlertTip,ObjectName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
	//out.println(doTemp.SourceSql);
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
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"true","","Button","����","����","viewDetail()",sResourcesPath},
		{"true","","Button","��ɴ���","��д�������","handle()",sResourcesPath},
		{"true","","Button","ԭʼ���","�鿴��ص�ҵ�����","openWithObjectViewer()",sResourcesPath},
		{"true","","Button","������Ȳ���","������Ȳ���","submitAlsert()",sResourcesPath}
		};
	
	if(sFinishedFlag!=null&&(sFinishedFlag.equals("FinishedNotification")||sFinishedFlag.equals("FinishedAlarm"))){
		sButtons[1][0]="false";
	}
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------


	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function handle(){
		sAlertID=getItemValue(0,getRow(),"SerialNo");
		sHandleNo=getItemValue(0,getRow(),"HandleNo");
		if (typeof(sAlertID)=="undefined" || sAlertID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		popComp("AlertHandleFinishInfo","/CreditManage/CreditAlarm/AlertHandleFinishInfo.jsp","AlertID="+sAlertID+"&HandleNo="+sHandleNo,"","");
		reloadSelf();
	
	}
	
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function openWithObjectViewer()
	{
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectType)=="undefined" || sObjectType.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		openObject(sObjectType,sObjectNo,"001");
	}

	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function viewDetail()
	{
		sAlertID=getItemValue(0,getRow(),"SerialNo");
		sHandleNo=getItemValue(0,getRow(),"HandleNo");
		if (typeof(sAlertID)=="undefined" || sAlertID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		popComp("AlertHandleInfo","/CreditManage/CreditAlarm/AlertHandleInfo.jsp","AlertID="+sAlertID+"&HandleNo="+sHandleNo,"","");
		reloadSelf();
	}
	function submitAlsert()
	{
			var sReturn3;
            var sSerialNo = "1111";
            var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
             
            sReturn3 = popComp("SubmitAlarm","/PublicInfo/SubmitAlarm.jsp","OneStepRun=yes&ScenarioNo="+sScenarioID+"&ObjectType=ApplySerialNo&ObjectNo="+sSerialNo,"dialogWidth=40;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no","");
             
            if (typeof(sReturn3)== 'undefined' || sReturn3.length == 0) 
            {
                alert("�����Ǹ���ֵĴ���");
                
            } else if (sReturn3 >= 0) //�ɹ� 
            {
                if( sReturn3 == 0 )
                 { 
                    alert("�Ѿ��ɹ��ύ��Ԥ������͵����ưɣ� ����" );    
                	 
                 }
                 else
                 {
                    alert("���뿴������Ҫ�ύ���Ԥ�������� ���� \n��ȥ��\"Ԥ���������\"ȥ���ɡ�" );    
                	                  
                 }
            } 
           
            return;    
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
<%
    if(!doTemp.haveReceivedFilterCriteria()) {
%>
	showFilterArea();
<%
	}	
%>
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
