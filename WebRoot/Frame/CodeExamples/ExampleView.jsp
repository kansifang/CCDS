<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content:ʾ��������Ϣ�鿴ҳ��
			Input Param:
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;δ����ģ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
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
		
		//����������	
		String sExampleID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
		//���ҳ�����
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/
%>
	<%
		//����Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"δ����","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

		//������ͼ�ṹ
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo='ExampleTree' and IsInUse='1' ";
		sSqlTreeView += "and (RelativeCode like '%"+sViewID+"%' or RelativeCode='All') ";//��ͼfilter

		tviTemp.initWithSql("SortNo","ItemName","ItemName","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//tviTemp.initWithCode("ExampleTree",Sqlca);
		//����������������Ϊ��
		//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/
%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
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

		/*
		 * ������������
		 * ToInheritObj:�Ƿ񽫶����Ȩ��״̬��ر��������������
		 * OpenerFunctionName:�����Զ�ע�����������REG_FUNCTION_DEF.TargetComp��
		 */
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;

		if(sCurItemname=="������Ϣ")
		{
			openChildComp("ExampleInfo","/Frame/CodeExamples/ExampleInfo.jsp","ExampleID=<%=sExampleID%>");
		}else if(sCurItemname=="������Ϣ")
		{
			openChildComp("ExampleTab","/Frame/CodeExamples/ExampleTab.jsp","ExampleID=<%=sExampleID%>");
			return;
		}else if(sCurItemname=="������")
		{
			openChildComp("ExampleFrame","/Frame/CodeExamples/ExampleFrame.jsp","ExampleID=<%=sExampleID%>");
			return;
		}else if(sCurItemname=="�������")
		{
			openChildComp("ObjectShare","/Common/ObjectRight/ObjectRightList.jsp","ObjectType=Example&ObjectNo=<%=sExampleID%>");
		}
		setTitle(getCurTVItem().name);
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
	expandNode('10');
	</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
