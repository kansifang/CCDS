<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   wangdw  2012.7.11
		Tester:
		Content: ����Ѻ���������������̨_Main
		Input Param:
			ApproveType����������
				��ApproveCreditApply/����ҵ���������
				��ApproveApprovalApply/���������������	
				��ApprovePutOutApply/�������븴��
		Output param: 
		      
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;δ����ģ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�����������ѯ�����
	ASResultSet rs = null;
	//���������SQL��䡢��ǰ����������ɹ���
	String sSql = "",sFolderUnfinished = "",sFolderfinished = "";
	//����������׶α�š��׶����ơ�����������������ʾ��ǩ���ļ��б��
	String sPhaseNo = "",sPhaseName = "",sWorkCount = "",sPageShow = "",sFolderSign= "" ;
	//������������̱�š��׶����͡������š��������
	String sFlowNo = "",sPhaseType = "",sCompID = "",sCompName = "",sFlowName="";
	//��������������������ơ����̶�������
	String sItemName = "",sObjectType = "",sCurNodeNo="";
	//������������Ͳ˵�ҳ��
	int iLeaf = 1,i = 0;
	
	//��������������������
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
	String sNodeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("NodeNo"));
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sNodeNo == null) sNodeNo = "";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%	
		
	//�����������ʹӴ����CODE_LIBRARY�л�������������ơ�����ģ�ͱ�š����̶������͡������š��������
	sSql = 	" select ItemName,Attribute2,ItemAttribute,Attribute7,Attribute8 from CODE_LIBRARY where "+
			" CodeNo = 'ApproveType' and ItemNo = '"+sApproveType+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sItemName = rs.getString("ItemName");
		sFlowNo = rs.getString("Attribute2");
		sObjectType = rs.getString("ItemAttribute");
		sCompID = rs.getString("Attribute7");
		sCompName = rs.getString("Attribute8");
		
		//����ֵת���ɿ��ַ���
		if(sItemName == null) sItemName = "";
		if(sFlowNo == null) sFlowNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sCompID == null) sCompID = "";
		if(sCompName == null) sCompName = "";
		
		//���ô��ڱ���
		PG_TITLE = sItemName;
		PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
	}else
	{
		throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApproveType:"+sApproveType+"����");
	}	
	rs.getStatement().close();

	//��FlowNo�𿪣�Ϊ�˼��ϵ�����
	String sTempFlowNo = "(";
	StringTokenizer st = new StringTokenizer(sFlowNo,",");
	while(st.hasMoreTokens())
	{
		sTempFlowNo += "'"+ st.nextToken()+"',";
	}

	if(!sTempFlowNo.equals(""))
	{
		sTempFlowNo = sTempFlowNo.substring(0,sTempFlowNo.length()-1)+")";
	}
	
	//out.println(sTempFlowNo);
	HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,PG_TITLE,"right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��

	//���õ�ǰ�û����ڸ������ĵ�ǰ�����˵���
	sFolderUnfinished = tviTemp.insertFolder("root","��ǰ����","",i++);
	//�����������FLOW_TASK�в�ѯ����ǰ�û��Ĵ��������������Ϣ
	sSql = 	" select FlowNo,FlowName,PhaseType,PhaseNo,PhaseName,getNodeNo(FlowNo,PhaseNo) as NodeNo,Count(SerialNo) as WorkCount "+
			" from FLOW_TASK "+
			" where PhaseType <>'1010' ";
	if("CreditApply".equals(sObjectType))
	{
		//��������Ҳ������������
		sSql +=" and (ObjectType = '"+sObjectType+"' or  ObjectType='CreditApproveApply') " ;
	}else{
		sSql +=" and ObjectType = '"+sObjectType+"' " ;
	}
	if(!sObjectType.equalsIgnoreCase("CreditApply"))
		sSql += " and FlowNo in "+sTempFlowNo+" ";
	if("BadBizApply".equals(sObjectType))
	{
		sSql += " and PhaseNo<>'0010' and PhaseNo<>'3000' ";
	}
	sSql += " and UserID = '"+CurUser.UserID+"' "+
			" and (EndTime is  null or EndTime =' ' or EndTime ='') "+
			" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName "+
			" Order by FlowNo,PhaseNo ";
	//out.println(sSql);
	rs = Sqlca.getASResultSet(sSql);
	while (rs.next())
	{	
		sFlowNo  =	 DataConvert.toString(rs.getString("FlowNo"));	
		sFlowName = DataConvert.toString(rs.getString("FlowName"));	
		sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
		sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));  
		sPhaseName = DataConvert.toString(rs.getString("PhaseName")); 
		sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
		sCurNodeNo = DataConvert.toString(rs.getString("NodeNo"));   
		 
		//����ֵת���ɿ��ַ���		
		if(sFlowName == null) sFlowName = ""; 
		if(sPhaseType == null) sPhaseType = ""; 
		if(sPhaseNo == null) sPhaseNo = ""; 		
		if(sPhaseName == null) sPhaseName = ""; 
		if(sWorkCount == null) sWorkCount = "";
		if(sCurNodeNo == null) sCurNodeNo= "";
		if(sWorkCount.equals(""))
			sPageShow  = sPhaseName+" 0 ��";	
		else
			sPageShow  = "��"+sFlowName+"��"+sPhaseName+" "+sWorkCount+" ��";						 
		
		if(!"".equals(sNodeNo)){
			tviTemp.insertPage(sCurNodeNo,sFolderUnfinished,sPageShow,"","javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++,"");
		}else
		{
			tviTemp.insertPage(sFolderUnfinished,sPageShow,"javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++);
		}
		
	}
	rs.getStatement().close();

	//4�����õ�ǰ�û����ڸ�����������ɹ����˵���
	sFolderfinished = tviTemp.insertFolder("root","����ɹ���","",i++);
	sSql = 	" select FlowNo,FlowName,PhaseType,PhaseNo,PhaseName,Count(SerialNo) as WorkCount "+
			" from FLOW_TASK FT "+
			" where 1=1 ";
	if("CreditApply".equals(sObjectType))
	{
		//��������Ҳ������������
		sSql +=" and (ObjectType = '"+sObjectType+"' or  ObjectType='CreditApproveApply') " ;
	}else{
		sSql +=" and ObjectType = '"+sObjectType+"' " ;
	}
	if(!sObjectType.equalsIgnoreCase("CreditApply"))
		sSql += " and FlowNo in "+sTempFlowNo+" ";
	
	if(sObjectType.equalsIgnoreCase("PutOutApply") && (CurUser.hasRole("460") || CurUser.hasRole("260") || CurUser.hasRole("060") || CurUser.hasRole("0N5")))
	{
		sSql += " and exists (select 'X' from Business_PutOut BP where BP.SerialNo = FT.ObjectNo and FT.ObjectType ='PutOutApply' and (BP.SendFlag not  in ('1','2')  or BP.SendFlag is null) )";
	}
	sSql += " and UserID = '"+CurUser.UserID+"' "+
			" and EndTime is not null "+	
			" and (EndTime <> ' ' or EndTime <> '') and PhaseType <>'1010' "+	
			" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName "+
			" Order by FlowNo,PhaseNo ";
	
	rs = Sqlca.getASResultSet(sSql);
	rs.beforeFirst();
	while (rs.next())
	{		 
		sFlowNo  =	 DataConvert.toString(rs.getString("FlowNo"));
		sFlowName = DataConvert.toString(rs.getString("FlowName"));	
		sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
		sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));  		  
		sPhaseName = DataConvert.toString(rs.getString("PhaseName"));  
		sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
		
		//����ֵת���ɿ��ַ���		
		if(sFlowName == null) sFlowName = ""; 
		if(sPhaseType == null) sPhaseType = ""; 
		if(sPhaseNo == null) sPhaseNo = ""; 		
		if(sPhaseName == null) sPhaseName = ""; 
		if(sWorkCount == null) sWorkCount = "";
		
		if(sWorkCount.equals(""))
			sPageShow  = sPhaseName+" 0 ��";	
		else
			sPageShow  = "��"+sFlowName+"��"+sPhaseName+" "+sWorkCount+" ��";		
		
		tviTemp.insertPage(sFolderfinished,sPageShow,"javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);
	}
	rs.getStatement().close();
	System.out.println("sObjectType:"+sObjectType+"&&:"+(CurUser.hasRole("460") || CurUser.hasRole("260")));
	//5�����õ�ǰ�û����ڸ�����������ɹ����˵���(�ſ�����)
	if(sObjectType.equalsIgnoreCase("PutOutApply") && (CurUser.hasRole("460") || CurUser.hasRole("260") || CurUser.hasRole("060") || CurUser.hasRole("0N5")))
	{
		sFolderfinished = tviTemp.insertFolder("root","�鵵��ͳ��","",i++);
		sSql = 	" select FlowNo,FlowName,PhaseType,PhaseNo,PhaseName,Count(SerialNo) as WorkCount "+
				" from FLOW_TASK FT "+
				" where ObjectType = '"+sObjectType+"' ";
		
		sSql += " and exists (select 'X' from Business_PutOut BP where BP.SerialNo = FT.ObjectNo and FT.ObjectType ='PutOutApply' and  BP.SendFlag in ('1','2') )";
		
		sSql += " and UserID = '"+CurUser.UserID+"' "+
				" and EndTime is not null "+	
				" and (EndTime <> ' ' or EndTime <> '')"+	
				" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName "+
				" Order by FlowNo,PhaseNo ";
		
		rs = Sqlca.getASResultSet(sSql);
		rs.beforeFirst();
		while (rs.next())
		{		 
			sFlowNo  =	 DataConvert.toString(rs.getString("FlowNo"));
			sFlowName = DataConvert.toString(rs.getString("FlowName"));	
			sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
			sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));  		  
			sPhaseName = DataConvert.toString(rs.getString("PhaseName"));  
			sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
			
			//����ֵת���ɿ��ַ���		
			if(sFlowName == null) sFlowName = ""; 
			if(sPhaseType == null) sPhaseType = ""; 
			if(sPhaseNo == null) sPhaseNo = ""; 		
			if(sPhaseName == null) sPhaseName = ""; 
			if(sWorkCount == null) sWorkCount = "";
			
			if(sWorkCount.equals(""))
				sPageShow  = sPhaseName+" 0 ��";	
			else
				sPageShow  = "��"+sFlowName+"��"+sPhaseName+" "+sWorkCount+" ��";		
			
			tviTemp.insertPage(sFolderfinished,sPageShow,"javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"Z\")",iLeaf++);
		}
		rs.getStatement().close();
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script language=javascript> 
	
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
	function openPhase(sApproveType,sPhaseType,sFlowNo,sPhaseNo,sFinishFlag)
	{
		//�򿪶�Ӧ����������
		OpenComp("<%=sCompID%>","<%=sCompName%>","ApproveType="+sApproveType+"&FlowNo="+sFlowNo+"&PhaseType="+sPhaseType+"&PhaseNo="+sPhaseNo+"&FinishFlag="+sFinishFlag,"right","");
		setTitle(getCurTVItem().name);
	}
    
	/*~[Describe=����������ı���;InputParam=sTitle:����;OutPutParam=��;]~*/
	function setTitle(sTitle)
	{
		//document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
		
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>;
	}
	
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');
	expandNode('<%=sFolderUnfinished%>');
	if("<%=sNodeNo%>" !="")
	{ 
		selectItem('<%=sNodeNo%>');
	}else{
		selectItem('2');
	}

	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
