<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: --jytian 
			Tester:
			Describe: --�ĵ�������ҳ��
			
			Input Param:
			Output Param:

			HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-24	fbkang	��������ʽ	
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "�ĵ�������ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
		String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
		String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/
%>
	<%
		//�������
		String sSql = "";//���sql���	
		String sSynthesisTemplet = "";//--��ǰģ������
		String sSynthesisInfoTemplet = "";//--��ҳ���ģ������
		ASResultSet rs = null;//--��Ž����

		//���ҳ�����
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/
%>
	<%
		//ȡ����ͼģ������	
		sSynthesisTemplet = "Document";
		sSynthesisInfoTemplet = "";	

		//����Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�ĵ�����","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent = true; //�Ƿ��Զ�����ѡ���¼�

		//������ͼ�ṹ
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sSynthesisTemplet+"' and (IsInUse='1' or IsInUse is null)";
		tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//����������������Ϊ��
		//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/
%>
	<script language=javascript> 

	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];
		sCurItemDescribe2=sCurItemDescribe[1];
		sCurItemDescribe3=sCurItemDescribe[2];

		if(sCurItemDescribe2 == "Back")
		{
			self.close();
		}else if(sCurItemDescribe2 == "Main")
		{
			window.open("<%=sWebRootPath%>/Redirector.jsp?ComponentURL=/Main.jsp&ComponentID=Main&ParentClientID=<%=CurComp.ClientID%>&rand="+randomNumber(),"_top");
		}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "" && sCurItemDescribe1 != "root")
		{
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&SynthesisInfoTemplet=<%=sSynthesisInfoTemplet%>&ObjectType="+sCurItemDescribe3,"right");
			setTitle(getCurTVItem().name);
		}
	}

	//����������ı���
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/
%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');	
	expandNode('020');
	expandNode('030');
	</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
