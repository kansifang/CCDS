<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ycsun 2008/10/04
		Tester:
		Describe: 
		Input Param:
		Output Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����/��Ϣ��¶"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<% 
       String sReportType = DataConvert.toString(request.getParameter("ReportType"));
			//����Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�̶������ѯ�б�","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		String sSqlTreeView = "";
		if("0".equals(CurOrg.OrgLevel)){
			sSqlTreeView = "FROM R_SHEET_MODEL where (OrderNo like 'k%' or OrderNo like 'l%' or OrderNo like 'm%' or OrderNo like 'n%') and status = '1' and (OrderNo is not null and   OrderNo <> '') ";
		}else{
			sSqlTreeView = "FROM R_SHEET_MODEL where  OrderNo in ('n','n01') and status = '1' and (OrderNo is not null and   OrderNo <> '') ";
		}
		
		//tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
		tviTemp.initWithSql("OrderNo", "SheetTitle", "", "Describe", "", sSqlTreeView, Sqlca);  
		//out.println();
		Vector dd = tviTemp.Items;
%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>
<html>
<head>
<title>Ǩ����󱨱�ϵͳ</title>


<script language=javascript>
	function doAction(sAction){
		if(sAction == "back"){
			if (confirm("��ȷ��Ҫ�˳�����ϵͳ��")){
				//window.open("<%=sWebRootPath%>/index.html","_top");  
				window.open("<%=sWebRootPath%>/Main.jsp","_top");
			}
		}else if(sAction == "Fix_k0101"){
			OpenPage("/FixStat/Fixk0101.jsp","right","");
		}else if(sAction == "Fix_k0201"){
			OpenPage("/FixStat/Fixk0201.jsp","right","");
		}else if(sAction == "Fix_l0101"){
			OpenPage("/FixStat/Fixl0101.jsp","right","");
		}else if(sAction == "Fix_l0102"){
			OpenPage("/FixStat/Fixl0102.jsp","right","");
		}else if(sAction == "Fix_l0201"){
			OpenPage("/FixStat/Fixl0201.jsp","right","");
		}
		else{
			OpenPage("/FixStat/FixSheetShowJZ.jsp?SheetID="+sAction+"&DisplayCriteria=true&rand="+randomNumber(),"right");
			setTitle(getCurTVItem().name);
		}
	}
	
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}	
</script> 

<script language="JavaScript">
	myleft.width=250;
	startMenu() ;
	expandNode('root');
	expandNode('k');
	expandNode('k1');
	expandNode('k2');
	expandNode('l');
	expandNode('m');
	expandNode('n');
</script>
<%@ include file="/IncludeEnd.jsp"%>