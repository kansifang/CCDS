<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   CYHui  2003.8.18
			Tester:
			Content: �����������̨_Main
			Input Param:
		ApproveType����������
			��ApproveCreditApply/����ҵ���������
			��ApproveApprovalApply/���������������	
			��ApprovePutOutApply/�������븴��
			Output param: 
			      
			History Log: 2005.08.03 jbye    �����޸�������������Ϣ
			 			 2005.08.05 zywei   �ؼ�ҳ��
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
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;δ����ģ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
		String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
		String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/
%>
	<%
		//�����������ѯ�����
		ASResultSet rs = null;
		//���������SQL��䡢��ǰ����������ɹ���
		String sSql = "",sFolderUnfinished = "",sFolderfinished = "";
		//����������׶α�š��׶����ơ�����������������ʾ��ǩ���ļ��б��
		String sPhaseNo = "",sPhaseName = "",sWorkCount = "",sPageShow = "",sFolderSign= "" ;
		//������������̱�š��׶����͡������š��������
		String sFlowNo = "",sPhaseType = "",sCompID = "",sCompName = "";
		//��������������������ơ����̶�������
		String sItemName = "",sObjectType = "";
		//������������Ͳ˵�ҳ��
		int iLeaf = 1,i = 0;
		//��������������������
		String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/
%>
	<%
		//�����������ʹӴ����Code_Library�л�������������ơ�����ģ�ͱ�š����̶������͡������š��������
		sSql = 	" select ItemName,Attribute2,ItemAttribute,Attribute7,Attribute8 "+
		" from Code_Library "+
		" where CodeNo = 'ApproveType'"+
		" and ItemNo ='"+sApproveType+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sItemName = DataConvert.toString(rs.getString("ItemName"));
			sFlowNo = DataConvert.toString(rs.getString("Attribute2"));
			sObjectType = DataConvert.toString(rs.getString("ItemAttribute"));
			sCompID = DataConvert.toString(rs.getString("Attribute7"));
			sCompName = DataConvert.toString(rs.getString("Attribute8"));
			//���ô��ڱ���
			PG_TITLE = sItemName;
			PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
		}else{
			throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApproveType:"+sApproveType+"����");
		}	
		rs.getStatement().close();
		//��FlowNo�𿪣�Ϊ�˼��ϵ�����,
		//��Ϊ�ڡ�δ��ɡ��͡�����ɡ������У�������ʾ��Ե�ǰ�û����������̵Ĺ������
		String sTempFlowNo = "(";
		StringTokenizer st = new StringTokenizer(sFlowNo,",");
		while(st.hasMoreTokens()){
			sTempFlowNo += "'"+ st.nextToken()+"',";
		}
		sTempFlowNo = sTempFlowNo.substring(0,sTempFlowNo.length()-1)+")";
		//out.println(sTempFlowNo);
		//1����ʼ����ͼ
		HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,PG_TITLE,"right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		String sSql0 = 	" select FlowNo,PhaseType,PhaseNo,PhaseName,Count(SerialNo) as WorkCount "+
				" from FLOW_TASK "+
				" where ObjectType = '"+sObjectType+"'"+
				" and FlowNo in "+sTempFlowNo+" "+
				" and PhaseNo not in ('0010','3000')"+
				" and UserID = '"+CurUser.UserID+"'";
		String sGO = " Group by FlowNo,PhaseType,PhaseNo,PhaseName "+
			" Order by FlowNo,PhaseNo ";
		//2�����õ�ǰ�û����ڸ������ĵ�ǰ�����˵���
		sFolderUnfinished = tviTemp.insertFolder("root","��ǰ����","",i++);
		//�����������FLOW_TASK�в�ѯ����ǰ�û��Ĵ��������������Ϣ
		sSql = sSql0+" and (nvl(EndTime,'')='' or EndTime =' ')"+sGO;
		rs = Sqlca.getASResultSet(sSql);
		while (rs.next()){	
			sFlowNo  =	 DataConvert.toString(rs.getString("FlowNo"));			 
			sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
			sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));  
			sPhaseName = DataConvert.toString(rs.getString("PhaseName")); 
			sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
			if(sWorkCount.equals(""))
		sPageShow  = sPhaseName+" 0 ��";	
			else
		sPageShow  = sPhaseName+" "+sWorkCount+" ��";						 
			tviTemp.insertPage(sFolderUnfinished,sPageShow,"javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++);
		}
		rs.getStatement().close();
		//4�����õ�ǰ�û����ڸ�����������ɹ����˵���
		sFolderfinished = tviTemp.insertFolder("root","����ɹ���","",i++);
		sSql = sSql0+" and (nvl(EndTime,'') <> '' or EndTime <> ' ')"+sGO;
		rs = Sqlca.getASResultSet(sSql);
		rs.beforeFirst();
		while (rs.next()){		 
			sFlowNo  =	 DataConvert.toString(rs.getString("FlowNo"));
			sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
			sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));  		  
			sPhaseName = DataConvert.toString(rs.getString("PhaseName"));  
			sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
			if(sWorkCount.equals(""))
		sPageShow  = sPhaseName+" 0 ��";	
			else
		sPageShow  = sPhaseName+" "+sWorkCount+" ��";		
			tviTemp.insertPage(sFolderfinished,sPageShow,"javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);
		}
		rs.getStatement().close();
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
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/
%>
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
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/
%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');
	selectItem('2');
	expandNode('<%=sFolderUnfinished%>');

	</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
