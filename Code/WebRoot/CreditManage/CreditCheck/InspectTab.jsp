<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang 2004-12-16 20:35
		Tester:
		Content: ��ʾ����ҵ����Ϣ
		Input Param:
                ObjectNo:����
                InspectType:��������
	                010	������;����
					020	�����鱨��
		Output param:
		History Log:   
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������;��鱨��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sReportType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportType"));
	String sViewOnly = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("viewOnly"));
	if(sViewOnly == null) sViewOnly = "";
	if(sReportType == null) sReportType="";
	String sType=""; //���ֿͻ�����
	String sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sObjectNo+"'");
	if(sCustomerType == null) sCustomerType="";
	else if (sCustomerType.startsWith("03"))  sType = "2";//���˿ͻ�����ҵ��
	else sType = "1";//��˾�ͻ�����ҵ��	
	%>
<%/*~END~*/%>     

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sSql = "";
		String sItemName = "";
		String sCustomerID = "";
		String sTitle="";
	  	String sAddStringArray[] = null;
	  	String sTabStrip[][] = new String[20][3];
		int initTab = 1;//�趨Ĭ�ϵ� tab ����ֵ����ڼ���tab

		if("Customer".equals(sObjectType)){
			sItemName = "�����Լ�鱨��";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('Inspect','"+sSerialNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			//�趨����
			sTitle = "�����Լ�鱨��";
		}else if("CustomerRisk".equals(sObjectType)){
			sItemName = "����Ԥ����鱨��";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('CustomerRisk','"+sSerialNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			//�趨����
			sTitle = "����Ԥ����鱨��";	
			
		}else if("CustomerRisk16".equals(sObjectType)){
			sItemName = "����Ԥ������������";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('CustomerRisk16','"+sSerialNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			//�趨����
			sTitle = "����Ԥ������������";	
			
		}else if("CreditApply".equals(sObjectType)){
			sItemName = "��������";
			sAddStringArray = new String[] {"",sItemName,"doTabAction('CreditApply','"+sObjectNo+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			//�趨����
			sTitle = "��������";
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
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script language=javascript>
  	function doTabAction(sObjectType,sObjectNo)
  	{
  		if (sObjectType=="Customer") {
			sViewID = "002";
			openObjectInFrame(sObjectType,sObjectNo,sViewID,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="BusinessContract") {
			sCompID = "CustomerLoanAfterList";
			sCompURL = "/CustomerManage/EntManage/CustomerLoanAfterList.jsp";
			sParamString = "CustomerID=<%=sCustomerID%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}

  		else if (sObjectType=="Inspect") {
  			sReportType = "<%=sReportType%>";
  			if(sReportType=="01"){//��˾�ͻ�һ����ճ����鱨��
				sCompID = "BusinessInspect07";
				sCompURL = "/FormatDoc/BusinessInspect/07.jsp";
			}else if(sReportType=="02"){//��˾�ͻ��ͷ��ճ����鱨��
				sCompID = "BusinessInspect08";
				sCompURL = "/FormatDoc/BusinessInspect/08.jsp";
			}else if(sReportType=="03"){
				sCompID = "BusinessInspect09";//���˿ͻ������鱨��
				sCompURL = "/FormatDoc/BusinessInspect/09.jsp";
			}else{
				sCompID = "BusinessInspect15";//΢С��ҵ�����鱨��
				sCompURL = "/FormatDoc/BusinessInspect/15.jsp";
			}		
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}  
  		else if(sObjectType=="CustomerRisk"){
			sCompID = "BusinessInspect10";//����Ԥ����鱨��
			sCompURL = "/FormatDoc/BusinessInspect/10.jsp";	
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>&viewOnly=<%=sViewOnly%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		
  		else if(sObjectType=="CustomerRisk16"){
			sCompID = "BusinessInspect16";//����Ԥ������������
			sCompURL = "/FormatDoc/CreditAlarm/16.jsp";	
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>&viewOnly=<%=sViewOnly%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		
  		else if(sObjectType == "CreditApply"){
  			sReportType = "<%=sReportType%>";
  			if(sReportType=="11"){//�������������ܾ����ֹܷ��ո��г�����ͨ����ҵ�񱨸�
				sCompID = "BusinessInspect11";
				sCompURL = "/FormatDoc/BusinessInspect/11.jsp";
			}else if(sReportType=="12"){//�����������ܾ����ֹܷ��ո��г������������
				sCompID = "BusinessInspect12";
				sCompURL = "/FormatDoc/BusinessInspect/12.jsp";
			}else if(sReportType=="13"){
				sCompID = "BusinessInspect13";//�к����г�����ͨ����ҵ�񱨸�
				sCompURL = "/FormatDoc/BusinessInspect/13.jsp";
			}else{
				sCompID = "BusinessInspect14";//�к����г����������ҵ�񱨸�
				sCompURL = "/FormatDoc/BusinessInspect/14.jsp";				
			}		
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="PrintInspectResume") {		
			sCompID = "BusinessInspect00";
			sCompURL = "/FormatDoc/BusinessInspect/00.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}  		
  		else if (sObjectType=="PrintInspectResum1") {			
			sCompID = "BusinessInspect03";
			sCompURL = "/FormatDoc/BusinessInspect/03.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="PrintInspectResum2") {	
			sCompID = "BusinessInspect04";
			sCompURL = "/FormatDoc/BusinessInspect/04.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}
  		else if (sObjectType=="PrintInspectResum3") {		
			sCompID = "BusinessInspect05";
			sCompURL = "/FormatDoc/BusinessInspect/05.jsp";
			sParamString = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo=<%=sSerialNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
			return true;
  		}  		
  		else if (sObjectType=="PrintInspectResum4") {
			sCompID = "CustomerFAList";
			sCompURL = "/CustomerManage/FinanceAnalyse/CustomerFAList.jsp";
			sParamString = "CustomerID=<%=sObjectNo%>";
			OpenComp(sCompID,sCompURL,sParamString,"<%=sIframeName%>");
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
	</script>	
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>