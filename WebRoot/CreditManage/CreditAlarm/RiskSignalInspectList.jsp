<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei 2006/03/27
		Tester:
		Content: Ԥ���źż�鱨����Ϣ_info
		Input Param:
			  ObjectType:��������
			  ObjectNo��������   
		Output param:
		       
		History Log: 
		       
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ���źż�鱨����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//���ҳ�����	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomeID"));
	String sViewOnly = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("viewOnly"));
	if(sViewOnly == null) sViewOnly = "";
	if(sCustomerID == null) sCustomerID = "";
	String sInspectType = "030010";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%		
    	String sHeaders[][] = {
								{"CustomerName","�ͻ�����"},
								{"ObjectNo","�ͻ����"},
								{"InspectType","�������"},
								{"UpdateDate","��������"},
								{"InputUserName","�����"},
								{"InputOrgName","��������"}							
							  };

	  	String sSql =  " select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName,"+
						" getItemName('InspectType',InspectType) as InspectType,"+
			            " UpdateDate,InputUserID,InputOrgID,"+
			            " getUserName(InputUserID) as InputUserName,"+
			            " getOrgName(InputOrgID) as InputOrgName,ReportType"+
						" from INSPECT_INFO"+
						" where ObjectType='CustomerRisk' "+
		                " and InspectType  like '030%' "+
		                " and ObjectNo = '"+sCustomerID+"'";
		if("".equals(sViewOnly)){                
			sSql += " and InputUserID='"+CurUser.UserID+"'";
		}	
	//ͨ��SQL������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "INSPECT_INFO";
		//���ùؼ���
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
 	doTemp.setVisible("SerialNo,InputUserID,InputOrgID,ObjectNo,ObjectType,InspectType,ReportType",false);
	doTemp.setUpdateable("CustomerName,InputUserName,InputOrgName",false);

	doTemp.setHTMLStyle("UpdateDate,InputUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
	doTemp.setHTMLStyle("ObjectNo,CustomerName"," style={width:250px} ");
//	doTemp.setCheckFormat("UpdateDate","3");
	
	doTemp.setColumnAttribute("ObjectNo,CustomerName,UpdateDate","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
	//����HTMLDataWindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","����","��������","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴��������","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ���ñ���","deleteRecord()",sResourcesPath},
			{"true","","Button","�ͻ�������Ϣ","�鿴�ͻ�������Ϣ","viewCustomer()",sResourcesPath}
		};
	if("1".equals(sViewOnly)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
	}	
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
		sInspectType = "<%=sInspectType%>";
		sCustomerID = "<%=sCustomerID%>";
		if(sInspectType == '030010')
		{
			sSerialNo = PopPage("/CreditManage/CreditAlarm/AddRiskInspectAction.jsp?ObjectNo="+sCustomerID+"&InspectType="+sInspectType,"","");
			sCompID = "InspectTab";
			sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sCustomerID+"&ObjectType=CustomerRisk";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);	
		}
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"ObjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
			
		}	
		
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sInspectType = "<%=sInspectType%>";
		sViewOnly = "<%=sViewOnly%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		if(sInspectType == '030010' || sInspectType == '030020')
		{
			sCompID = "InspectTab";
			sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly="+sViewOnly;
			
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
    /*~[Describe=�鿴�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomer()
	{
		var sCustomerID;
		if("<%=sInspectType%>"=="030010" || "<%=sInspectType%>"=="030020")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			openObject("Customer",sCustomerID,"001");
		}
    		
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>