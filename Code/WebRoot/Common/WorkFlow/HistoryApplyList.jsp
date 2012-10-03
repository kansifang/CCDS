<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2005.3.11
		Tester:
		Content: ��ʷ�����б�
		Input Param:
		Output param:
		History Log: 
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
	String sWhereClause = "";
	
	//����������	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	ASDataObject doTemp = new ASDataObject("CreditApplyList",Sqlca);
	
	doTemp.WhereClause += 	" and FLOW_OBJECT.ObjectNo = BUSINESS_APPLY.SerialNo "+
							//" and FLOW_OBJECT.FlowNo = 'CreditFlow' "+
							" and FLOW_OBJECT.ObjectType = 'CreditApply' "+
							"  and BUSINESS_APPLY.InputOrgID in (select OrgId from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
							" and BUSINESS_APPLY.SerialNo != '"+sObjectNo+"' ";

	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//if(!doTemp.haveReceivedFilterCriteria())
	doTemp.WhereClause+="  and BUSINESS_APPLY.CustomerID = '"+sCustomerID+"' ";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);

	//����DataWindowչ�ַ��ͱ༭��ʽ
	dwTemp.Style="1";
	dwTemp.ReadOnly = "1";
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
		{"false","","Button","��������","��������","viewTab()",sResourcesPath},
		{"true","","Button","�鿴���","�鿴���","viewOpinions()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>



<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>

	/*~[Describe=�鿴���鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewReport()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			return;
		}
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sFlag = PopPage("/FormatDoc/ChooseFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if(sFlag == "2")
		{
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}
		else
		{
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}

	}	
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		//alert(sObjectType+"*"+sObjectNo+"*"+sFlowNo+"*"+sPhaseNo);
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}

	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function viewDetail()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		openObject(sObjectType,sObjectNo,"002");
	}

	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	
	

	/*~[Describe=�Զ����ձ���;InputParam=��;OutPutParam=��;]~*/
	function riskSkan()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sReturn = PopPage("/Common/WorkFlow/CheckBusinessAction.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"","","");
		PopPage("/Common/WorkFlow/CheckActionView.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&CustomerID="+sCustomerID+"&Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=30;center:yes;status:no;statusbar:no");
	}


</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>

<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>
