<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: ������Ϣ���ٲ�ѯ
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ�������Ϣ���ٲ�ѯ
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "";//--��ͷ
	String sCustomerType =""; //�ͻ����� 1Ϊ��˾�ͻ� 2Ϊͬҵ�ͻ� 3Ϊ���˿ͻ� 4Ϊ���ù�ͬ��
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����
	sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType="";	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"SerialNo","������ˮ��"},
							{"CustomerID","�ͻ����"},
							{"CustomerName","�ͻ�����"},
							{"BusinessType","ҵ��Ʒ��"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurType","��������"},										
							{"OccurTypeName","��������"},
							{"PhaseName","��ǰ�׶�"},
							{"Currency","����"},									
							{"BusinessSum","���"},
							{"TermMonth","����(��)"},
							{"VouchType","��Ҫ������ʽ"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"OperateOrgName","�������"},
							{"OperateUserName","������"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"FinancePlatformFlag","�Ƿ�����ƽ̨"}
							}; 
	if(sCustomerType.equalsIgnoreCase("1")){						
		sSql =	" select BA.SerialNo,BA.CustomerID,BA.CustomerName,BA.BusinessType,getBusinessName(BA.BusinessType) as BusinessTypeName, "+
				" BA.OccurType,getItemName('OccurType',BA.OccurType) as OccurTypeName,"+
				" FO.PhaseName,getItemName('Currency',BA.BusinessCurrency) as Currency,BA.BusinessSum,BA.TermMonth, " +
				" BA.VouchType, getItemName('VouchType',BA.VouchType) as VouchTypeName, " +
				" getOrgName(BA.OperateOrgID) as OperateOrgName, "+
				" getUserName(BA.OperateUserID) as OperateUserName, "+
				" getOrgName(BA.InputOrgID) as InputOrgName, "+
				" getUserName(BA.InputUserID) as InputUserName, "+
				" GETCustomerFPFlag(BA.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_APPLY BA ,FLOW_OBJECT FO ,BUSINESS_TYPE BT"+
				" where BA.SerialNo = FO.ObjectNo and FO.ObjectType='CreditApply' "+
				" and BT.TypeNo = BA.BusinessType and BT.Attribute1 = '1' and BA.BusinessType not in ('3060','3015') "+
				" and OperateOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("2")){
		sSql =	" select BA.SerialNo,BA.CustomerID,BA.CustomerName,BA.BusinessType,getBusinessName(BA.BusinessType) as BusinessTypeName, "+
				" BA.OccurType,getItemName('OccurType',BA.OccurType) as OccurTypeName,"+
				" FO.PhaseName,getItemName('Currency',BA.BusinessCurrency) as Currency,BA.BusinessSum,BA.TermMonth, " +
				" BA.VouchType, getItemName('VouchType',BA.VouchType) as VouchTypeName, " +
				" getOrgName(BA.OperateOrgID) as OperateOrgName, "+
				" getUserName(BA.OperateUserID) as OperateUserName, "+
				" getOrgName(BA.InputOrgID) as InputOrgName, "+
				" getUserName(BA.InputUserID) as InputUserName, "+
				" GETCustomerFPFlag(BA.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_APPLY BA ,FLOW_OBJECT FO"+
				" where BA.SerialNo = FO.ObjectNo and FO.ObjectType='CreditApply' "+
				" and BA.BusinessType = '3015' "+
				" and OperateOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("3")){
		sSql =	" select BA.SerialNo,BA.CustomerID,BA.CustomerName,BA.BusinessType,getBusinessName(BA.BusinessType) as BusinessTypeName, "+
				" BA.OccurType,getItemName('OccurType',BA.OccurType) as OccurTypeName,"+
				" FO.PhaseName,getItemName('Currency',BA.BusinessCurrency) as Currency,BA.BusinessSum,BA.TermMonth, " +
				" BA.VouchType, getItemName('VouchType',BA.VouchType) as VouchTypeName, " +
				" getOrgName(BA.OperateOrgID) as OperateOrgName, "+
				" getUserName(BA.OperateUserID) as OperateUserName, "+
				" getOrgName(BA.InputOrgID) as InputOrgName, "+
				" getUserName(BA.InputUserID) as InputUserName, "+
				" GETCustomerFPFlag(BA.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_APPLY BA ,FLOW_OBJECT FO ,BUSINESS_TYPE BT"+
				" where BA.SerialNo = FO.ObjectNo and FO.ObjectType='CreditApply' "+
				" and BT.TypeNo = BA.BusinessType and BT.Attribute1 = '2' "+
				" and OperateOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("4")){
		sSql =	" select BA.SerialNo,BA.CustomerID,BA.CustomerName,BA.BusinessType,getBusinessName(BA.BusinessType) as BusinessTypeName, "+
				" BA.OccurType,getItemName('OccurType',BA.OccurType) as OccurTypeName,"+
				" FO.PhaseName,getItemName('Currency',BA.BusinessCurrency) as Currency,BA.BusinessSum,BA.TermMonth, " +
				" BA.VouchType, getItemName('VouchType',BA.VouchType) as VouchTypeName, " +
				" getOrgName(BA.OperateOrgID) as OperateOrgName, "+
				" getUserName(BA.OperateUserID) as OperateUserName, "+
				" getOrgName(BA.InputOrgID) as InputOrgName, "+
				" getUserName(BA.InputUserID) as InputUserName, "+
				" GETCustomerFPFlag(BA.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_APPLY BA ,FLOW_OBJECT FO ,BUSINESS_TYPE BT "+
				" where BA.SerialNo = FO.ObjectNo and FO.ObjectType='CreditApply' "+
				" and BT.TypeNo = BA.BusinessType and BT.Attribute1 = '1' and BA.BusinessType = '3060' "+
				" and OperateOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("BA.SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_APPLY";	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("TermMonth,BusinessRate","style={width:60px} ");  	
	doTemp.setHTMLStyle("OperateOrgName,InputOrgName","style={width:250px} "); 	
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum,TermMonth,BusinessRate","3");
	doTemp.setType("BusinessSum,BusinessRate","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum","2");
	doTemp.setCheckFormat("TermMonth","5");
	doTemp.setVisible("VouchType,BusinessType,FinancePlatformFlag,OccurType",false);
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWCode("FinancePlatformFlag","YesNo");
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%1%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}else if("3".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%2%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}
	doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' ");

	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","BusinessType","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","TermMonth","Operators=BetweenNumber;DOFilterHtmlTemplate=Number");
	doTemp.setFilter(Sqlca,"6","OperateOrgName","");
	doTemp.setFilter(Sqlca,"7","OperateUserName","");
	doTemp.setFilter(Sqlca,"8","PhaseName","");
	doTemp.setFilter(Sqlca,"9","VouchType","");	
	if("1".equalsIgnoreCase(sCustomerType)){
	    doTemp.setFilter(Sqlca,"10","FinancePlatformFlag","Operators=EqualsString;");	
	}
	doTemp.setFilter(Sqlca,"11","OccurType","");
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
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","�鿴�������","�鿴�������","viewOpinions()",sResourcesPath},
		{"true","","Button","�鿴���鱨��","�鿴���鱨��","viewReport()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
	};
	if(CurUser.hasRole("095")||CurUser.hasRole("0A2")||CurUser.hasRole("0B5")||CurUser.hasRole("0C2")||
	 CurUser.hasRole("0D2")||CurUser.hasRole("0E9")||CurUser.hasRole("0F4")||CurUser.hasRole("0H5")||
	 CurUser.hasRole("0I4")||CurUser.hasRole("0J1")||CurUser.hasRole("282")||CurUser.hasRole("295")||
	 CurUser.hasRole("2A4")||CurUser.hasRole("2B9")||CurUser.hasRole("2C2")||CurUser.hasRole("2D4")||
	 CurUser.hasRole("2E4")||CurUser.hasRole("2G5")||CurUser.hasRole("2H5")||CurUser.hasRole("2I2")||
	 CurUser.hasRole("421")||CurUser.hasRole("495"))
	{
		sButtons[3][0] = "false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			openObject("CreditApply",sSerialNo,"002");
		}
	}	
    
    /*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	    popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","ObjectType=CreditApply&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*~[Describe=�鿴���鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewReport()
	{
		sObjectType = "CreditApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert("���鱨�滹δ��д��������д���鱨���ٲ鿴��");
			return;
		}
		
		sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
		if (sReturn == "false")
		{
			alert("���鱨�滹δ���ɣ��������ɵ��鱨���ٲ鿴��");
			return;  
		}
		
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
		OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
    }
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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
