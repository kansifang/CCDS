<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang 2004-12-16 20:35
		Tester:
		Content: ��ʾ����ҵ����Ϣ
		Input Param:
			    TaskNo��������
			    ObjectNo��������
			    ObjectType����������
			    FlowNo�����̱��
			    PhaseNo���׶α��
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ʾ����ҵ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	String sTaskNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	
	//���ҳ�����		
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	
	%>
	
	<%
		String  sEditFlag= "false";
		if(sFlowNo.equals("EntCreditFlowTJ01") && (sPhaseNo.equals("0130") || sPhaseNo.equals("0260")))//������鲿���Ա
		{
			sEditFlag="true";
		}
		if(sFlowNo.equals("IndCreditFlowTJ01") && (sPhaseNo.equals("0130") || sPhaseNo.equals("0200")))
		{
			sEditFlag="true";
		}
	
	%>
<%/*~END~*/%>     

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sSql = "";
		String sItemName = "";
		String sCustomerID = "";
		String sCustomerType = "",sBusinessType ="",sApplyType="",sEvaluateSerialNo="";
		String sTitle="";
	  	String sAddStringArray[] = null;
	  	String sTabStrip[][] = new String[20][3];	  	
		int initTab = 1;//�趨Ĭ�ϵ� tab ����ֵ����ڼ���tab
		ASResultSet rs = null;
		
		//�趨����
		sSql = 	" select CustomerName||'-'||getBusinessName(BusinessType), "+
				" BusinessSum,BusinessRate,nvl(TermMonth,0), "+
				" getOrgName(InputOrgID),getUserName(InputUserID),CustomerID,BusinessType,ApplyType "+
				" from BUSINESS_APPLY where SerialNo='"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sTitle = "��������-[" + rs.getString(1) +"]";
			sTitle += "-���[" + DataConvert.toMoney(rs.getString(2)) +"Ԫ]";
			sTitle += "-����[" + rs.getDouble(3) +"��]";
			sTitle += "-����[" + rs.getString(4) +"]";
			sTitle += "-�������[" + rs.getString(5) +"]";
			sTitle += "-������[" + rs.getString(6) +"]";
			sCustomerID = rs.getString("CustomerID");
			sBusinessType = rs.getString("BusinessType");
			sApplyType = rs.getString("ApplyType");
			if(sCustomerID == null) sCustomerID ="";
			if(sBusinessType == null) sBusinessType ="";
			if(sApplyType == null) sApplyType ="";
		}
		rs.getStatement().close();
		
		//ȡ�ÿͻ����õȼ�������Ϣ add by lpzhang 2009-8-24
		sSql = "select CustomerType from Customer_Info where CustomerID ='"+sCustomerID+"'";
		sCustomerType = Sqlca.getString(sSql);
		if(sCustomerType == null) sCustomerType="";
		
		if(!sBusinessType.equals("3015") && !sApplyType.equals("DependentApply") && sObjectType.equals("CreditApply"))
		{
			sSql = " select SerialNo from Evaluate_Record where ObjectType ='Customer' "+
			       " and ObjectNo ='"+sCustomerID+"'  order by AccountMonth desc fetch first 1 rows only ";
			
			sEvaluateSerialNo = Sqlca.getString(sSql);
			if(sEvaluateSerialNo == null) sEvaluateSerialNo ="";
		}
		

		sItemName = "�鿴�������";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('ViewFlowOpinions','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "��ʷ����������";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('viewHistoryOpinion','"+sCustomerID+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "ҵ��������Ϣ";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('CreditApply','"+sObjectNo+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);

		sItemName = "�ͻ���Ϣ";
		sAddStringArray = new String[] {"",sItemName,"doTabAction('Customer','"+sCustomerID+"')"};
		sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		
		if(!"".equals(sEvaluateSerialNo))
		{
			sItemName = "���õȼ�������Ϣ";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('Evaluate','"+sCustomerID+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		}
		//���ݶ��������� tab
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.all('tabtd')"));

		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=���ڴ�ҳ�棬���Ժ�";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=yes";
	%>

</script>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��]~*/%>
<html>
<head>
<title><%=sTitle%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab05.jsp"%>
</body>
</html>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script language=javascript>
	var bHidePrintButton = true;
  	function doTabAction(sObjectType,sObjectNo)
  	{
		if (sObjectType=="ViewFlowOpinions") 
		{ 			
			sCompID = "ViewApplyFlowOpinions";
			sCompURL = "/Common/WorkFlow/ViewApplyFlowOpinions.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			setDialogTitle("<%=sTitle%>");
			return true;
		}else  if (sObjectType=="viewHistoryOpinion") 
		{ 			
			sCompID = "HistoryApplyList";
			sCompURL = "/Common/WorkFlow/HistoryApplyList.jsp";
			sParamString = "CustomerID=<%=sCustomerID%>&ObjectNo=<%=sObjectNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			setDialogTitle("<%=sTitle%>");
			return true;
		}else  if (sObjectType=="Evaluate") 
		{ 			
			sCompID = "EvaluateDetail";
			sCompURL = "/Common/Evaluate/EvaluateDetail.jsp";
			sParamString = "Action=display&CustomerID=<%=sCustomerID%>&ObjectType=Customer&ObjectNo=<%=sCustomerID%>&SerialNo=<%=sEvaluateSerialNo%>&Editable=<%=sEditFlag%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			setDialogTitle("<%=sTitle%>");
			return true;
		}
		else {
			openObjectInFrame(sObjectType,sObjectNo,"002","<%=sIframeName%>");
			return true;
		}
  	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language=javascript>
	//��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,<%=initTab%>,document.all('<%=sTabID%>'));
	//�趨Ĭ��ҳ��
	<%=sTabStrip[initTab-1][2]%>;
	sCompID = "SignApplyTaskOpinionInfo";
	sCompURL = "/Common/WorkFlow/SignApplyTaskOpinionInfo.jsp";
	sParamString = "TaskNo=<%=sTaskNo%>&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>";
    OpenComp(sCompID,sCompURL,sParamString,"EditBlock");
	</script>	
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>