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
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//����ֵת��Ϊ���ַ���
    if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>

<%	
	String[][] sHeaders = {							
							{"SerialNo","Ԥ����ˮ��"},
							{"SignalType","Ԥ������"},
							{"SignalLevel","Ԥ������"},
							{"SignalStatus","Ԥ��״̬"},	
							{"CustomerOpenBalance","���ڽ��"},
							{"OperateOrgName","�Ǽǻ���"},
							{"OperateUserName","�Ǽ���"},
							
						};
		
	sSql =  "select RS.SerialNo,getItemName('SignalType',RS.SignalType) as SignalType,getItemName('SignalLevel',RS.SignalLevel) as SignalLevel,"+
	        " getItemName('SignalStatus',RS.SignalStatus) as SignalStatus,"+
	        " RS.CustomerOpenBalance as CustomerOpenBalance,getUserName(RS.InputUserID) as OperateUserName,"+
	        " getOrgName(RS.InputOrgID) as OperateOrgName "+
	        " from FLOW_OBJECT,RISK_SIGNAL RS where  FLOW_OBJECT.ObjectNo = RS.SerialNo and RS.ObjectNo='"+sCustomerID+"'";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	//doTemp.UpdateTable="RISK_SIGNAL";
	//doTemp.setHTMLStyle("SignalName","style={width=200px}");
	//�����ֶ�λ��
	doTemp.setAlign("SignalType,SignalStatus","2");
	//���ùؼ���
	doTemp.setKey("SignalNo,ObjectNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	//doTemp.setVisible("SignalNo,ObjectNo",false);
	//���ó��ڽ����ʾΪ��λһ����С�������λ
	doTemp.setType("CustomerOpenBalance","Number");
	doTemp.setCheckFormat("CustomerOpenBalance","2");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
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
			{"true","","Button","�鿴���","�鿴���","viewOpinions()",sResourcesPath}
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
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
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
		//OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp?ObjectNo="+sSerialNo,"_self","");
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
	   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function initRow()
	{
		//setItemValue(0,0,"OperateUserName","<%=CurUser.UserID%>");
		//setItemValue(0,0,"OperateOrgName","<%=CurUser.OrgID%>");
		//setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
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