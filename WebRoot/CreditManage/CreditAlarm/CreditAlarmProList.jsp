<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: Ԥ���źŷ�����Ϣ_List
		Input Param:			
			SignalType��Ԥ�����ͣ�01������02�������
			SignalStatus��Ԥ��״̬��10��������15�����ַ���20�������У�30����׼��40�������   
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	String sCreditAlarmMain = "";	
	//����������		
	
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {							
							{"CustomerName","�ͻ�����"},
							{"SignalType","Ԥ������"},
							{"SignalStatus","Ԥ��״̬"},													
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�ʱ��"}
						};
	sSql =  " select SerialNo,ObjectType,ObjectNo,GetCustomerName(ObjectNo) as CustomerName, "+
			" getItemName('SignalType',SignalType) as SignalType, "+
			" getItemName('SignalStatus',SignalStatus) as SignalStatus, "+
			" GetOrgName(InputOrgID) as InputOrgName, "+
			" GetUserName(InputUserID) as InputUserName,InputDate  "+
			" from RISK_SIGNAL"+
			" where ObjectType = 'Customer'"+
			" and SignalType = '01' "+   
			" and SignalStatus = '30' "+
			" and InputUserID = '"+CurUser.UserID+"' ";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//�����ֶ�λ��
	doTemp.setAlign("SignalType,SignalStatus","2");
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	//���ø�ʽ
	doTemp.setHTMLStyle("CustomerName","style={width:200px}");	
	//���ù�����
	doTemp.setColumnAttribute("CustomerName,SignalName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
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
			{"true","","Button","Ԥ������","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","�鿴Ԥ�����ñ���","�鿴Ԥ�����ñ���","viewAlarmProInfo()",sResourcesPath}
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
			
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		//OpenPage("/CreditManage/CreditAlarm/RiskSignalView.jsp?SerialNo="+sSerialNo,"_blank02","");
	    OpenComp("RiskSignalApplyInfo","/CreditManage/CreditAlarm/RiskSignalView.jsp","SerialNo="+sSerialNo,"_blank","");  
	                                                                                                                                                             
	}
	
	/*~[Describe=�鿴Ԥ�����ñ���;InputParam=��;OutPutParam=��;]~*/
	function viewAlarmProInfo()
	{
		
	    var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sSerialNo,"","");
		sCompID = "CreditAlarmTab";
		sCompURL = "/CreditManage/CreditAlarm/CreditAlarmTab.jsp";
		sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType=RiskAlarmDone";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		/*
		sCompID = "InspectTab";
		sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
		sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType=RiskAlarmDone";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		*/
				
		
	} 
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
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
