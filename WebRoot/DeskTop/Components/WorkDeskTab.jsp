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
	String PG_TITLE = "��ʾ����ҵ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//����������	
	String sSerialNo   = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));
	%>
<%/*~END~*/%>     


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sTitle="";
	  	String sAddStringArray[] = null;
		int initTab = 1;//�趨Ĭ�ϵ� tab ����ֵ����ڼ���tab
		ASResultSet rs1 = null;
		String sSql = " select ItemNo,ItemName,ItemAttribute from CODE_LIBRARY CL"+
					" where CodeNo = 'TabStrip'  and IsInUse = '1' ";
		//add by lzhang 2011/04/12 ���Ӳ鿴��ɫȨ�޿���
		if(CurUser.UserID.equals("9999999")||CurUser.hasRole("062")||CurUser.hasRole("262")||CurUser.hasRole("462")){
			sSql += " order by SortNo ";
		}else{
			sSql += " and ItemNo <> '050'  Order by SortNo ";
		}				
		String sTabStrip[][] = HTMLTab.getTabArrayWithSql(sSql,Sqlca);
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.all('tabtd')"));
		String sTableStyle = "valign=middle align=center cellspacing=0 cellpadding=0 border=0 width=95% height=95%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "DeskTopTab";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=���ڴ�ҳ�棬���Ժ�";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=no";
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
	function doTabAction(sArg){
  		if(sArg=="WorkTips")
  		{
  			OpenComp("WorkTips","/DeskTop/WorkTips.jsp","","<%=sIframeName%>","");
  		}
  		else if(sArg=="BusinessAlert")
  		{
  			OpenComp("AlarmHandleMain","/CreditManage/CreditAlarm/AlarmHandleMain.jsp","","<%=sIframeName%>","");
  		}
  		else if(sArg=="WorkRecordMain")
  		{
  			OpenComp("WorkRecordMain","/DeskTop/WorkRecordMain.jsp","","<%=sIframeName%>","");
  		}
  		else if(sArg=="UserDefine")
  		{
  			OpenComp("UserDefineMain","/DeskTop/UserDefineMain.jsp","","<%=sIframeName%>","");
  		}
  		//add by lzhang 2011-03-21��������źͻ�����ʾ
  		else if(sArg=="BalanceAlert")
  		{
  			OpenComp("AlarmBalanceMain","/CreditManage/CreditAlarm/AlarmBalanceMain.jsp","","<%=sIframeName%>","");
  		}
  		  		
		//����ҵ�����
    	if(sArg=="BusinessCurrenyDay")
  		{
  			OpenComp("BusinessCurrenyDay","/DeskTop/BusinessCurrenyDay.jsp","","<%=sIframeName%>","");
 	  	}
		//�ڼ�ҵ��̬
    	else if(sArg=="BusinessDynamic")
  		{
  			OpenComp("BusinessDynamic","/DeskTop/BusinessDynamic.jsp","","<%=sIframeName%>","");
 	  	}
		//���ż��жȣ��ش�ͻ���
    	else if(sArg=="VipCustomerFrame")
  		{
  			OpenComp("VipCustomerFrame","/DeskTop/VipCustomerFrame.jsp","","<%=sIframeName%>","");
 	  	}
		//����ҵ��ṹ
    	else if(sArg=="LoanInq1")
  		{
  			OpenComp("LoanIndView","/DeskTop/LoanIndView.jsp","InOutFlag=1","<%=sIframeName%>","");
 	  	}
		//����ҵ��ṹ
  		else if(sArg=="LoanInq2")
  		{
  			OpenComp("LoanIndView","/DeskTop/LoanIndView.jsp","InOutFlag=2","<%=sIframeName%>","");
  		}
		//�ʲ�����
  		else if(sArg=="LoanQuanlity")
  		{
  			OpenComp("LoanQuanlity","/DeskTop/LoanQuanlity.jsp","InOutFlag=2","<%=sIframeName%>","");
	  	}
  	}

	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1, document.getElementById('<%=sTabID%>'));
	<%=sTabStrip[0][2]%>;
	</script>	
<%/*~END~*/%>
	
<%@ include file="/IncludeEnd.jsp"%>