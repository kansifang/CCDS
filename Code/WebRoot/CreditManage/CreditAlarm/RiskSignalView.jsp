<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong  2011/03/31
		Tester:
		Content: Ԥ���ź�������
		Input Param:
			 	SerialNo��ҵ��������ˮ��
		Output param:
			      
		History Log: 
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	
	//�������
	String sSignalType = "";
	String sCustomerID = "";
	String sSignalStatus = "";
	String sTable="";
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//System.out.println("--------begin-------"+sObjectType+"/"+sObjectNo);
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/%>
	<%
	
	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ���������ģ����
	String sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){ 
		sTable=DataConvert.toString(rs.getString("ObjectTable"));
	}
	rs.getStatement().close(); 
	sSql="select ObjectNo,SignalStatus,SignalType from "+sTable+" where SerialNo='"+sObjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sSignalType=DataConvert.toString(rs.getString("SignalType"));
		sCustomerID = DataConvert.toString(rs.getString("ObjectNo"));
		sSignalStatus = DataConvert.toString(rs.getString("SignalStatus"));
	}
	rs.getStatement().close(); 
   	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	//������ͼ�ṹ,���ݽ׶�(RelativeCode)����������(Attribute1)��ҵ��Ʒ��(Attribute2)���ų���ҵ��Ʒ��(Attribute3)���ɲ�ͬ����ͼ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'RiskSignalView' ";
	sSqlTreeView += "and (RelativeCode like '%"+sSignalType+"%' or RelativeCode='All') " +
	         		" and IsInUse = '1' " ;
	//System.out.println("---------------"+sSqlTreeView);
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ��
	//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca

	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/%>
	<script language=javascript> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		
		sObjectType="<%=sObjectType%>";
		sObjectNo="<%=sObjectNo%>";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		sParaStringTmp=sParaStringTmp.replace("#ObjectType",sObjectType);
		sParaStringTmp=sParaStringTmp.replace("#ObjectNo",sObjectNo);
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}

	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var AccountType="";
		var sSerialNo = getCurTVItem().id;
		if (sSerialNo == "root")	return;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe0=sCurItemDescribe[0];
		sCurItemDescribe1=sCurItemDescribe[1];
		sCurItemDescribe2=sCurItemDescribe[2];
		
		if(sCurItemDescribe0 != "null"){
			openChildComp(sCurItemDescribe1,sCurItemDescribe0,"ComponentName="+sCurItemName+"&AccountType=ALL&"+sCurItemDescribe2+"&CustomerID=<%=sCustomerID%>&SignalStatus=<%=sSignalStatus%>&SignalType=<%=sSignalType%>");
			setTitle(getCurTVItem().name);
		}
	}

	//����������ı���
	function setTitle(sTitle){
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}
	
	function startMenu() {
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/%>
	<script language="JavaScript">
	myleft.width=170;
	startMenu();
	expandNode('root');	
	selectItem('010');
	selectItem('015');
	setTitle("������Ϣ");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>