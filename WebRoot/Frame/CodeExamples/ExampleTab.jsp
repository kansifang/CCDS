<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content:
			Input Param:
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/
%>
	<%
		//�������
		
		//����������	

		//���ҳ�����
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/
%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%//String sSqlTab = "select ItemNo,ItemName,Attribute1 from CODE_LIBRARY where CodeNo = 'VouchType' and ItemNo in('01','02')";
	  	//String sTabStrip[][] = HTMLTab.getTabArrayWithSql(sSqlTab,Sqlca);
	  	
	  	String sTabStrip[][] = {
								{"","abc","doTabAction(\'firstTab\')"},
								{"","def","doTabAction(\'secondTab\')"},
								{"","ghi","doTabAction(\'thirdTab\')"},
								{"","jkl","doTabAction(\'fourthTab\')"}
								};

		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.all('tabtd')"));

		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=���ڴ�ҳ�棬���Ժ�";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=no";%>

</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��]~*/
%>
<html>
<head>
<title><%=PG_TITLE%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/
%>
	<script language=javascript>

	/**
	 * Ĭ�ϵ�tabִ�к���
	 * ����true�����л�tabҳ;
	 * ����false�����л�tabҳ
	 */
  	function doTabAction(sArg)
  	{
  		
  		if(sArg=="firstTab")
  		{
			OpenComp("Blank","/Blank.jsp","ComponentName=���1&TextToShow="+sArg,"<%=sIframeName%>","");
			return true; 
		}else if(sArg=="secondTab")
  		{
			OpenComp("Blank","/Blank.jsp","ComponentName=���1&TextToShow="+sArg,"<%=sIframeName%>","");
			return true;
		}else
		{
			alert("����ѡ��һ����ҵ��");
			return false; 
		}
  	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/
%>

	<script language=javascript>
	
	//��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.all('<%=sTabID%>'));
	doTabAction('firstTab');

	</script>

<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
