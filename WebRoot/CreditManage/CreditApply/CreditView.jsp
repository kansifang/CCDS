<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jytian  2004-12-10
		Tester:
		Content: ҵ������������
		Input Param:
			 	SerialNo��ҵ��������ˮ��
		Output param:
			      
		History Log: 
				2005.08.09 ��ҵ� ������룬ȥ��window.open�򿪷���,ɾ�����ô��룬�����߼�
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/%>
	<%
	
	//�������
	String sBusinessType = "",sCustomerID = "",sApplyType="",sChangeObject="",sChangtype="";
	String sOccurType = "";
	String sTable="";
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sIsCreditLine = (String)CurComp.compParentComponent.compParentComponent.getAttribute("IsCreditLine");
	if(sIsCreditLine == null) sIsCreditLine = "";
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
	
	sSql="select CustomerID,OccurType,BusinessType,ApplyType,ChangeObject,changtype from "+sTable+" where SerialNo='"+sObjectNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCustomerID=DataConvert.toString(rs.getString("CustomerID"));
		sOccurType=DataConvert.toString(rs.getString("OccurType"));
		sBusinessType=DataConvert.toString(rs.getString("BusinessType"));
		sApplyType=DataConvert.toString(rs.getString("ApplyType"));
		sChangeObject=DataConvert.toString(rs.getString("ChangeObject"));
		sChangtype=DataConvert.toString(rs.getString("Changtype"));
		System.out.println("sChangtype=====================>>"+sChangtype);
	}
	rs.getStatement().close(); 

	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ҵ������","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//������ͼ�ṹ,���ݽ׶�(RelativeCode)����������(Attribute1)��ҵ��Ʒ��(Attribute2)���ų���ҵ��Ʒ��(Attribute3)���������Attribute5����������ͣ�Attribute6�����ɲ�ͬ����ͼ
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'CreditView' ";
	sSqlTreeView += "and (RelativeCode like '%"+sObjectType+"%' or RelativeCode='All') " +
	          " and ((Attribute1 like '%"+sOccurType+"%' or Attribute2 like '%"+sBusinessType+"%' ) "+	 
	          " or ((Attribute1='' or Attribute1 is null ) and (Attribute2='' or Attribute2 is null ) )) "+
	          " and (Attribute3 not like '%"+sBusinessType+"%' or Attribute3 is null or Attribute3='') "+
	          " and (Attribute4 not like '%"+sApplyType+"%' or Attribute4 is null or Attribute4='') "+
	          " and ((Attribute5 like '%"+sChangeObject+"%') or ((Attribute5='' or Attribute5 is null )  )) "+
	//          " and (Attribute6 <> '"+sChangtype+"' or Attribute6 is null or Attribute6='') "+
	          " and IsInUse = '1' " ;
	if("true".equals(sIsCreditLine)){
		sSqlTreeView +=" and ItemNo not in('040','040010','040020','040030','040040','041','041050','041060','080')";
	}          
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
		sCustomerID="<%=sCustomerID%>";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		sParaStringTmp=sParaStringTmp.replace("#ObjectType",sObjectType);
		sParaStringTmp=sParaStringTmp.replace("#ObjectNo",sObjectNo);
		sParaStringTmp=sParaStringTmp.replace("#CustomerID",sCustomerID);
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
		
		if(sCurItemDescribe1 == "GuarantyList"){
			openChildComp("GuarantyList","/CreditManage/GuarantyManage/GuarantyList.jsp","ObjectType=<%=sObjectType%>&WhereType=Business_Guaranty&ObjectNo=<%=sObjectNo%>");
			setTitle(getCurTVItem().name);
		}else if(sCurItemDescribe1=="ApplyAssureList1")
		{
			openChildComp("ApplyAssureList1","/CreditManage/CreditAssure/ApplyAssureList1.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>");
			setTitle(getCurTVItem().name);
		}else if(sCurItemDescribe1 == "RelativeBusinessList"){
			openChildComp("RelativeBusinessList","/CreditManage/CreditApply/RelativeBusinessList.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&CustomerID=<%=sCustomerID%>&OccurType=<%=sOccurType%>");
			setTitle(getCurTVItem().name);
		}else if(sCurItemDescribe0 != "null"){
			openChildComp(sCurItemDescribe1,sCurItemDescribe0,"ComponentName="+sCurItemName+"&AccountType=ALL&"+sCurItemDescribe2);
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
	expandNode('01');
	expandNode('040');
	expandNode('041');	
	selectItem('010');
	setTitle("������Ϣ");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>