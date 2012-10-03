<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xlyu 2011-09-29
		Tester:
		Content: Ԥ����Ϣ_Info
		Input Param:	
			SignalType��Ԥ�����ͣ�01������02�������		
			SignalStatus��Ԥ��״̬��10��������15�����ַ���20�������У�30����׼��40������� 
			SerialNo��Ԥ����ˮ��    
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
		
	//����������		
	//String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//����ֵת��Ϊ���ַ���
    //if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>

<%	
	String[][] sHeaders = {							
							{"SerialNo","Ԥ����ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"SignalTypeName","Ԥ������"},
							{"SignalType","Ԥ������"},
							{"SignalLevelName","Ԥ������"},
							{"SignalLevel","Ԥ������"},
							{"SignalStatusName","Ԥ��״̬"},	
							{"SignalStatus","Ԥ��״̬"},	
							{"CustomerOpenBalance","���ڽ��"},
							{"FinalOrgName","������������"},
							{"FinalUserName","����������"},
							{"OperateOrgName","�ܻ�����"},
							{"OperateUserName","�ܻ���"}
						};
	sSql =  "select RS.SerialNo,RS.SignalType,getItemName('SignalType',RS.SignalType) as SignalTypeName,"+
			" GetCustomerName(RS.ObjectNo) as CustomerName,"+
			" RS.SignalLevel,getItemName('SignalLevel',RS.SignalLevel) as SignalLevelName,"+
	        " RS.SignalStatus,getItemName('SignalStatus',RS.SignalStatus) as SignalStatusName,"+
	        " RS.CustomerOpenBalance as CustomerOpenBalance,"+
	        " getUserName(RS.InputUserID) as OperateUserName,"+
	        " getOrgName(RS.InputOrgID) as OperateOrgName, "+
	        " A.UserName  as FinalUserName,A.OrgName as FinalOrgName "+ 
	        " from RISK_SIGNAL RS  "+
	        " left join (select ObjectNo,OrgName,UserName from FLOW_TASK FT where  FT.ObjectType='RiskSignalApply' and exists(select 1 from FLOW_TASK where RelativeSerialNo=FT.SerialNo and PhaseNo='1000') ) A "+
	        " ON A.ObjectNo = RS.SerialNo "+
	        " where RS.InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
	if(CurUser.hasRole("0J1")) sSql +="and InputUserID in (select userid from user_role where roleid='080')";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	//�����ֶ�λ��
	doTemp.setAlign("SignalType,SignalStatus","2");
	//���ùؼ���
	doTemp.setKey("SignalNo,ObjectNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SignalType,SignalLevel,SignalStatus",false);
	//���ó��ڽ����ʾΪ��λһ����С�������λ
	doTemp.setType("CustomerOpenBalance","Number");
	doTemp.setCheckFormat("CustomerOpenBalance","2");
	doTemp.setDDDWCode("SignalType","SignalType");
	doTemp.setDDDWCode("SignalLevel","SignalLevel");
	doTemp.setDDDWCode("SignalStatus","SignalStatus");
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","OperateOrgName","");
	doTemp.setFilter(Sqlca,"3","SignalType","");
	doTemp.setFilter(Sqlca,"4","SignalLevel","");
	doTemp.setFilter(Sqlca,"5","SignalStatus","");
	doTemp.setFilter(Sqlca,"6","FinalOrgName","");
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{"true","","Button","Ԥ������","Ԥ������","viewAndEdit()",sResourcesPath},
			{"false","","Button","�鿴���","�鿴���","viewOpinions()",sResourcesPath},
			{"true","","Button","Ԥ������������","�鿴Ԥ������������","checkManulReport()",sResourcesPath},
			{"true","","Button","Ԥ����������","�鿴Ԥ����������","checkRiskFreeReport()",sResourcesPath},
			{"true","","Button","���ñ���","�鿴���ñ���","viewDisposeReport()",sResourcesPath}
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    //---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//���������������ˮ�ţ��������������
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=RiskSignalApply&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		
		reloadSelf();
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		popComp("ViewRiskSignalOpinions","/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	   }
	   
	/*~[Describe=�鿴Ԥ������������;InputParam=��;OutPutParam=��;]~*/
	function checkManulReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");//����Ԥ���ź���ˮ��
		var sObjectType = "RiskSignal";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RiskSignal");
	    if (typeof(sSerialNo)!="undefined" && sSerialNo.length!=0 && sSerialNo != "Null")
		{
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			return;
		}	
	}
	
	/*~[Describe=�鿴Ԥ����������;InputParam=��;OutPutParam=��;]~*/
	function checkRiskFreeReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");//����Ԥ���ź���ˮ��
		var sObjectType = "FreeRiskSignal";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",FreeRiskSignal");
	    if (typeof(sSerialNo)!="undefined" && sSerialNo.length!=0 && sSerialNo != "Null")
		{
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}	
	}
	
	/*~[Describe=�鿴Ԥ�����ñ���;InputParam=��;OutPutParam=��;]~*/
	function viewDisposeReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType = "RiskSignalDispose";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RiskSignalDispose");
	    
	    if (typeof(sSerialNo)!="undefined" && sSerialNo.length!=0 && sSerialNo != "Null")
		{
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}	
	}
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function initRow()
	{
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>