<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jbye 2004-12-16 20:35
		Tester:
		Content: ������ʾһ�����еĲ��񱨱�
		Input Param:
                ObjectNo�������� ĿǰĬ��Ϊ�ͻ����
                ObjectType���������� ĿǰĬ��CustomerFS
                ReportDate�������ֹ����
                Role����ɫ
                RecordNo��������
                ReportScope������ھ�
                
		Output param:
		History Log: zywei 2006/01/23 ���Ӳ���ReportScope����ʱû�ã��Ⱥ�ף��ʦ���ۣ�
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���񱨱�һ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	
	String sObjectNo = "",sObjectType = "",sReportDate = "",sRole = "",sRecordNo = "",sReportScope = "";
	//������ ��ʱΪ�ͻ���
	sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sReportDate =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate"));
    sRole =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Role"));
    sRecordNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	sReportScope =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportScope"));
	String sEditable =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Editable"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sReportDate == null) sReportDate = "";
	if(sRole == null) sRole = "";
	if(sRecordNo == null) sRecordNo = "";
	if(sReportScope == null) sReportScope = "";
	if(sEditable == null) sReportScope = "";
	
	%>
<%/*~END~*/%>     

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sSql = "",sReportName = "",sReportType = "",sReportNo = "",sVisibleFlag = "",sModelClass = "";
		String sCustomerName = "",sTitle = "";
		ASResultSet rs ;
		int initTab = 1;//�趨Ĭ�ϵ� tab ����ֵ����ڼ���tab
		
		//�趨����
		sSql = "select CustomerName from CUSTOMER_INFO where CustomerID = '"+sObjectNo+"'";
		rs = Sqlca.getResultSet(sSql);
		if(rs.next())
		{
			sCustomerName = rs.getString("CustomerName");
		}
		rs.getStatement().close();
		
		sTitle = sCustomerName +"  "+sReportDate.substring(0,4)+"��"+sReportDate.substring(5,7)+"�� ���񱨱�";
		
		//ȡ�ö�Ӧ�ı�������
		sSql =  " select 'true',ReportName,'doTabAction('''||ReportNo||''')',ReportNo,ReportDate from REPORT_RECORD "+
				" where ObjectType = '"+sObjectType+"' "+
				" and ObjectNo = '"+sObjectNo+"' "+
				" and ReportScope = '"+sReportScope+"' "+
				" and ReportDate = '"+sReportDate+"' "+							
				" order by ModelNo";
		
		//����sql����ʼ��tab ��
		String sTabStrip[][] = HTMLTab.getTabArrayWithSql(sSql,Sqlca);
		
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
<body leftmargin="0" topmargin="0" class="pagebackground" onBeforeUnload="unloadCheck()">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script language=javascript>
  	function doTabAction(sReportNo)
  	{
		// add by byhu 20050328: �뿪δ������ʾ
		try{
			if(typeof(<%=sIframeName%>.dataModified)=="undefined" || <%=sIframeName%>.dataModified==false){
			}else if(<%=sIframeName%>.dataModified==true && confirm(sUnloadMessage)){
			}else{
				return false;
			}
			
		}catch(e){
		}
		// end

		if(sReportNo=="goBack")
  		{
  			if(confirm(getHtmlMessage('14')))//��ȷʵҪ�˳���
			{
				self.close();
			}else
			{
				return false;
			}
  		}else
  		{
	  		OpenComp("ReportData","/Common/FinanceReport/ReportData.jsp","Role=<%=sRole%>&CustomerID=<%=sObjectNo%>&RecordNo=<%=sRecordNo%>&ReportNo="+sReportNo+"&Editable="+"<%=sEditable%>","<%=sIframeName%>","");
			return true;
		}
  	}

	function unloadCheck(){
		try{
			if(<%=sIframeName%>.dataModified){
				event.returnValue=sUnloadMessage;
			}else{
			}
		}catch(e){
		}
	}

	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language=javascript>
	//��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,<%=initTab%>,document.all('<%=sTabID%>'));
	//�趨Ĭ��ҳ��
	<%=sTabStrip[initTab-1][2]%>
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
