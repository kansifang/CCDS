<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: Ԥ���źŷ����϶���Ϣ_List
		Input Param:			 
			FinishType��������ͣ�Y������ɣ�N��δ��ɣ�			    
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
	String sClewDate = "";
	String sSql = "";
		
	//����������	
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));	
	//����ֵת��Ϊ���ַ���	
	if(sFinishType == null) sFinishType = "";
	//���ҳ�����	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��ʾ����
	sClewDate = StringFunction.getRelativeDate(StringFunction.getToday(),7);
	
	String[][] sHeaders = {							
							{"CustomerName","�ͻ�����"},
							{"SignalName","Ԥ���ź�"},
							{"SignalType","Ԥ������"},
							{"SignalStatus","Ԥ��״̬"},													
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�ʱ��"}
						};
		
	sSql =  " select RS.ObjectNo,GetCustomerName(RS.ObjectNo) as CustomerName, "+
			" RS.SignalName,getItemName('SignalType',RS.SignalType) as SignalType, "+
			" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus, "+
			" GetOrgName(RS.InputOrgID) as InputOrgName, "+
			" GetUserName(RS.InputUserID) as InputUserName,RS.InputDate,RS.SerialNo, "+
			" RS.ObjectType "+
			" from RISK_SIGNAL RS "+
			" where RS.ObjectType = 'Customer' "+
			" and RS.SignalType = '01' "+ 
			" and RS.SignalStatus = '30' "+
			" and RS.ObjectNo not in "+
			" (select ObjectNo from RISK_SIGNAL where ObjectType = 'Customer'  and SignalType = '02' and RS.SignalStatus <>'30')"+
			" and RS.InputUserID = '"+CurUser.UserID+"'";

	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	
	doTemp.setHTMLStyle("CustomerName,SignalName","style={width:200px}");
	doTemp.setHTMLStyle("SignalType,SignalStatus","style={width:50px}");
	doTemp.setHTMLStyle("InputDate","style={width:80px}");
	//���ø�ʽ
	doTemp.setAlign("SignalType,SignalStatus","2");
	//���ù�����
	doTemp.setColumnAttribute("SignalName","IsFilter","1");
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
			{(sFinishType.equals("N")?"true":"false"),"","Button","Ԥ���������","��д�ñ�Ԥ����Ϣ��Ԥ����鱨��","newReport()",sResourcesPath},		
			{(sFinishType.equals("Y")?"true":"false"),"","Button","�鿴Ԥ����鱨��","�鿴/�޸�Ԥ����鱨������","viewReport()",sResourcesPath},
			{"true","","Button","Ԥ������","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{(sFinishType.equals("N")?"true":"false"),"","Button","��ɼ��","�ύ��ѡ�еļ�¼","commitRecord()",sResourcesPath}		
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=Ԥ�����;InputParam=��;OutPutParam=��;]~*/
	function newReport()
	{		
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		OpenPage("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp?ObjectType=RiskSignal&ObjectNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=�鿴Ԥ���������;InputParam=��;OutPutParam=��;]~*/
	function viewReport()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		PopComp("RiskSignalReports","/CreditManage/CreditAlarm/RiskSignalInspectList.jsp","CustomeID="+sObjectNo,"");
	
	}
					
	/*~[Describe=�鿴���޸�Ԥ������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		OpenPage("/CreditManage/CreditAlarm/RiskSignalCheckInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=�ύ��¼;InputParam=��;OutPutParam=��;]~*/
	function commitRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		//�ύ����
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishDate@<%=StringFunction.getToday()%>,RISK_SIGNAL,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("��ѡ��¼�ύʧ�ܣ�");
			return;
		}else
		{
			reloadSelf();
			alert("��ѡ��¼�ύ�ɹ���");
		}					
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
