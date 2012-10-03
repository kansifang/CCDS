<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bqliu 2011-06-13
		Tester:
		Content: Ԥ����Ϣ_Info
		Input Param:	
			SignalType��Ԥ�����ͣ�01������02�������		
			SignalStatus��Ԥ��״̬��10��������15�����ַ���20�������У�30����׼��40������� 
			SerialNo��Ԥ����ˮ��    
		Output param:
		                
		History Log: pliu 2011-08-19
		                 
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
	String sSql = "",sCustomerType="";
		
	//����������		
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalStatus"));
	String sSignalType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalType"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sSignalStatus == null) sSignalStatus = "";
	if(sSignalType == null) sSignalType = "";
	//�����������ѯ�����
	ASResultSet rs = null;
%>
<%/*~END~*/%>

<%	
	//��ȡ�ͻ�����
	sSql = " select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sCustomerType = DataConvert.toString(rs.getString("CustomerType"));
		if(sCustomerType == null) sCustomerType = "";		
	}
	rs.getStatement().close();
	
	
	String[][] sHeaders = {							
							{"SignalName","Ԥ���ź�"},
							{"SignalType","Ԥ������"},
							{"SignalStatus","Ԥ��״̬"},													
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�ʱ��"}
						};
		
	sSql =  " select CR.SerialNo,CR.SignalNo as SignalNo,CR.CustomerID as CustomerID,CR.SignalName as SignalName,"+
	        " getItemName('SignalType',RS.SignalType) as SignalType,"+
			" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus, "+
			" GetOrgName(CR.InputOrgID) as InputOrgName, "+
			" GetUserName(CR.InputUserID) as InputUserName,CR.InputDate "+
			" from Customer_RiskSignal CR,Risk_Signal RS,RISKSIGNAL_RELATIVE RR"+
			" where RR.ObjectNo = CR.SerialNo "+
			" and RS.SerialNo=RR.SerialNo and RR.ObjectType='RiskSignal' "+
			" and RS.SerialNo = '"+sObjectNo+"'";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="Customer_RiskSignal";
	doTemp.setHTMLStyle("SignalName","style={width=200px}");
	//�����ֶ�λ��
	doTemp.setAlign("SignalType,SignalStatus","2");
	//���ùؼ���
	doTemp.setKey("SignalNo,CustomerID",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SignalNo,CustomerID,SerialNo",false);
	
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
			{"02".equals(sSignalType)?"false":"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"02".equals(sSignalType)?"false":"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{		
		//OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp","_self","");
		var sParaString = "CodeNo"+","+"AlertSignal2";
		if("<%=sCustomerType%>".substring(0,2)=="01")
		{
			sParaString=sParaString+",SortID,EndAL";
		}else if("<%=sCustomerType%>".substring(0,2)=="03")
		{
			sParaString=sParaString+",SortID,IndAL";
		}
		
		var sReturn = setObjectValue("SelectAlarmCode",sParaString,"@SignalNo@0@SignalName@1",0,0,"");
		if (typeof(sReturn) != "undefined" && sReturn != "" )
		{
			sSignalNo = sReturn.split("@")[0];	
			sSignalName = sReturn.split("@")[1];
			sMessage=RunMethod("BusinessManage","AddRiskSignal","<%=sObjectNo%>,RiskSignal,<%=sCustomerID%>,"+sSignalNo+","+sSignalName+",<%=CurUser.UserID%>,<%=CurUser.OrgID%>");
			if(typeof(sMessage)!="undefined"&&sMessage!=""&& sMessage.length>0 ) 
			{
				alert(sMessage);
				return;
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			sReturn=RunMethod("BusinessManage","DeleteRiskSignal","RiskSignal,"+sSerialNo+",<%=sObjectNo%>");
			if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED") 
			{
				alert(getHtmlMessage('7'));//��Ϣɾ���ɹ���
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('8'));//�Բ���ɾ����Ϣʧ�ܣ�
				return;
			}
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function initRow()
	{
		setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
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