<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --zwhu  2009.11.18      
		Tester:	
		Content: 
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����Ա����������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//��� sql���
	String sInspectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InspectType"));
	if(sInspectType==null) sInspectType="";
	String sCustomerID = "";
	sSql = " select BC.CustomerID from Business_Contract BC,CHECK_Frequency CF where BC.CustomerID = CF.CustomerID "+
		   " and CF.FinishFrequencyDate < BC.OccurDate";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		
	}	   
	rs.getStatement().close();
	sSql = "";	   
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��ȡ�ͻ���Ϣ������	
	String sHeaders[][] = {
				{"CustomerID","�ͻ�ID"},
				{"CustomerType","�ͻ�����"},
				{"CustomerName","�ͻ�����"},
				{"CheckFrequency","���Ƶ��"},
			};
     if(sInspectType.equals("020001")){
	 //NEW
	 	sSql = " select CI.CustomerID,getItemName('CustomerType',CI.CustomerType) as CustomerType,CI.CustomerName from CUSTOMER_INFO CI "+
	 		   " left outer join CHECK_Frequency CF on CI.CustomerID=CF.CustomerID "+
	 		   " where CI.CustomerID in(Select CustomerID from Customer_Belong where BelongAttribute='1' and UserID='"+CurUser.UserID+"')"+
	 		   " and (FinishFrequencyDate = '' or FinishFrequencyDate is null )"+
	 		   " and(CustomerType like '01%' or CustomerType like '03%')";

	 }else
	 {
	 	sSql = " select CI.CustomerID,getItemName('CustomerType',CI.CustomerType) as CustomerType,CI.CustomerName,getItemName('CheckFrequency',CF.CheckFrequency) as CheckFrequency from CUSTOMER_INFO CI,CHECK_Frequency CF"+
	 		   " where CI.CustomerID = CF.CustomerID and CF.customerid in(Select CustomerID from Customer_Belong where BelongAttribute='1' and UserID='"+CurUser.UserID+"') and (CF.FinishFrequencyDate is not null and FinishFrequencyDate<>'')";
	 }       
	//out.println(sSql);
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="CUSTOMER_INFO";
    doTemp.setKey("CustomerID",true);
	doTemp.generateFilters(Sqlca);
 	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//������datawindows����ʾ������
	dwTemp.setPageSize(10); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"false","","Button","���ü��Ƶ��","���ü��Ƶ��","CheckFrequency()",sResourcesPath},
			{"true","","Button","����","����","viewAndEdit()",sResourcesPath},
			{"false","","Button","���","���","Finished()",sResourcesPath},
			{"false","","Button","����","����","ReEdit()",sResourcesPath}
		};	
	if(sInspectType.equals("020001")){
		sButtons[0][0] = "true";
		sButtons[2][0] = "true";
	}	
	else{
		sButtons[3][0] = "true";
	}
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	
<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=���ü��Ƶ��;InputParam=��;OutPutParam=��;]~*/
	function CheckFrequency()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ����¼");
			return;
		}		
		
		var sReturnValue = PopPage("/CreditManage/CreditCheck/AddCheckFrequency.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(sReturnValue=="" || sReturnValue=="_CANCEL_" || sReturnValue=="_CLEAR_" || sReturnValue=="_NONE_" || typeof(sReturnValue)=="undefined")
		{
			return;
		}
		sSerialNo = PopPage("/CreditManage/CreditCheck/AddCheckFrequencyAction.jsp?ObjectNo="+sCustomerID+"&CheckFrequency="+sReturnValue,"","");
//		OpenPage("/CreditManage/CreditCheck/CheckFrequencyInfo.jsp?CustomerID="+sCustomerID+"&InspectType=<%=sInspectType%>", "_self","");
		

		reloadSelf();
	}


	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ����¼");
			return;
		}
		sReturnValue=RunMethod("CustomerManage","QueryCheckFre",sCustomerID);			
		if(typeof(sReturnValue)=="undefined" || sReturnValue.length==0 ||sReturnValue=="0"){
			alert("������¼û�����ü��Ƶ��");
			return;
		}	
		OpenPage("/CreditManage/CreditCheck/CheckFrequencyInfo.jsp?CustomerID="+sCustomerID+"&InspectType=<%=sInspectType%>", "_self","");
	}

  /*~[Describe=���;InputParam=��;OutPutParam=��;]~*/
	function Finished()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sToDay = "<%=StringFunction.getToday()%>";
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ����¼");
			return;
		}
		sReturnValue=RunMethod("CustomerManage","QueryCheckFre",sCustomerID);
		if(typeof(sReturnValue)=="undefined" || sReturnValue.length==0||sReturnValue=="0"){
			alert("������¼û�����ü��Ƶ��");
			return;
		}	
		sReturnValue=RunMethod("CustomerManage","FinishCheckFre",sCustomerID+","+sToDay);
		if(typeof(sReturnValue)=="undefined" || sReturnValue.length==0)
		{
			alert("δ��ɲ�������");
		}
		reloadSelf();
	}
	
	function ReEdit()
	{
	    sSerialNo = getItemValue(0,getRow(),"CustomerID");
	    sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm("��ȷ��Ҫ������"))
		{
			sReturnValue=RunMethod("CustomerManage","ReEditCheckFre",sCustomerID);
			if(typeof(sReturnValue)=="undefined" || sReturnValue.length==0)
			{
				alert("����ʧ��");
			}
			reloadSelf();
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