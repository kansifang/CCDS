<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2011/03/18
		Tester:
		Content: Ԥ�������������̨_Main
		Input Param:
			ApproveType����������
				��ApproveRiskSignalApply/Ԥ���źŷ����������
			ApproveType1����������1
				��ApproveRiskSignalFApply/Ԥ���źŽ���������	
		Output param: 
		      
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ���ź��϶�"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;Ԥ���ź��϶�&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�����������ѯ�����
	ASResultSet rs = null,rs1 = null;
	//���������SQL��䡢��ǰ����������ɹ���
	String sSql = "",sSql1="",sFolder1 = "",sFolder11 = "",sFolder12 = "",sFolder2 = "";
	//����������׶α�š��׶����ơ�����������������ʾ��ǩ���ļ��б��
	String sPhaseNo = "",sPhaseName = "",sWorkCount = "",sPageShow = "",sFolderSign= "" ;
	//������������̱�š��׶����͡������š��������
	String sFlowNo = "",sPhaseType = "",sFlowName="";
	//��������������������ơ����̶�������
	String sItemName = "",sObjectType = "",sCurNodeNo="";
	//�������:������
	int iCount = 0;
	//������������Ͳ˵�ҳ��
	int iLeaf = 1,i = 0,i1 = 0,i2 = 0,j = 0,k = 0;
	String[] h={"0","0","0","0","0","0","0","0","0","0"};
	String[] sCompID={"","","","","","","","","",""};
	String[] sCompName={"","","","","","","","","",""};
	//��������������������
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
	String sNodeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("NodeNo"));
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";
	if(sNodeNo == null) sNodeNo = "";
	//���sNodeNoΪ����ȡĬ��ֵ
	if("".equals(sNodeNo))
	{
		sSql = 	" select 1  " +//��ѯ��ǰ�����Ƿ��з����Ԥ���ź�����
			"from RISK_SIGNAL RS, FLOW_TASK FT "+
			" where RS.SerialNo = FT.ObjectNo "+
			" and FT.ObjectType ='RiskSignalApply' "+
			" and FT.UserID='"+CurUser.UserID+"' "+
			" and SignalType ='01' "+
			" and (FT.EndTime is null "+
			" or FT.EndTime = '') "+
			" and (FT.PhaseAction is null "+
			" or FT.PhaseAction = '')";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			//����Ĭ��ΪԤ������ǰ����
			sNodeNo="3";
		}else{
			iCount=6;
			//��ѯ����Ԥ���źŵ�ǰ��������
			sSql1 = " select count(*) "+
				" from FLOW_TASK "+
				" where ObjectType = 'RiskSignalApply' and ApplyType='RiskSignalApply' "+
				" and UserID = '"+CurUser.UserID+"' "+
				" and (EndTime is null or EndTime = '')"+
				" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName ";
			rs1 = Sqlca.getASResultSet(sSql1);
			while(rs1.next())
			{
				iCount=iCount+1;
			}
			rs1.getStatement().close();
			//��ѯ����Ԥ���ź�����ɹ�������
			sSql1 = " select count(*) "+
				" from FLOW_TASK "+
				" where ObjectType = 'RiskSignalApply' and ApplyType='RiskSignalApply' "+
				" and UserID = '"+CurUser.UserID+"' "+
				" and EndTime is not null and EndTime <> '' "+
				" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName ";
			rs1 = Sqlca.getASResultSet(sSql1);
			while(rs1.next())
			{
				iCount=iCount+1;
			}
			rs1.getStatement().close();
			sNodeNo = ""+iCount;
		}
		rs.getStatement().close();
	}else{
		if("6".equals(sNodeNo))
		{
			iCount=Integer.parseInt(sNodeNo);
			//��ѯ����Ԥ���źŵ�ǰ��������
			sSql1 = " select count(*) "+
				" from FLOW_TASK "+
				" where ObjectType = 'RiskSignalApply' and ApplyType='RiskSignalApply' "+
				" and UserID = '"+CurUser.UserID+"' "+
				" and (EndTime is null or EndTime = '')"+
				" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName ";
			rs1 = Sqlca.getASResultSet(sSql1);
			while(rs1.next())
			{
				iCount=iCount+1;
			}
			rs1.getStatement().close();
			//��ѯ����Ԥ���ź�����ɹ�������
			sSql1 = " select count(*) "+
				" from FLOW_TASK "+
				" where ObjectType = 'RiskSignalApply' and ApplyType='RiskSignalApply' "+
				" and UserID = '"+CurUser.UserID+"' "+
				" and EndTime is not null and EndTime <> '' "+
				" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName ";
			rs1 = Sqlca.getASResultSet(sSql1);
			while(rs1.next())
			{
				iCount=iCount+1;
			}
			rs1.getStatement().close();
			sNodeNo = ""+iCount;
		}
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//out.println(sTempFlowNo);
	HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,PG_TITLE,"right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	String[] sApproveTypeTemp = sApproveType.split("@");
	while(j<sApproveTypeTemp.length)
	{
		sApproveType = sApproveTypeTemp[j];
		//�����������ʹӴ����CODE_LIBRARY�л�������������ơ�����ģ�ͱ�š����̶������͡������š��������
		sSql = 	" select ItemName,Attribute2,ItemAttribute,Attribute7,Attribute8 from CODE_LIBRARY where "+
				" CodeNo = 'ApproveType' and ItemNo = '"+sApproveType+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sItemName = rs.getString("ItemName");
			sFlowNo = rs.getString("Attribute2");
			sObjectType = rs.getString("ItemAttribute");
			sCompID[j] = rs.getString("Attribute7");
			sCompName[j] = rs.getString("Attribute8");
			//����ֵת���ɿ��ַ���
			if(sItemName == null) sItemName = "";
			if(sFlowNo == null) sFlowNo = "";
			if(sObjectType == null) sObjectType = "";
			if(sCompID[j] == null) sCompID[j] = "";
			if(sCompName == null) sCompName[j] = "";
			
			//���ô��ڱ���
			PG_TITLE = sItemName;
			//PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
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
		
		
	
		//���õ�ǰ�û����ڸ������ĵ�ǰ�����˵���
		sFolder1 = tviTemp.insertFolder("root",PG_TITLE,"",i++);
		h[k] = sFolder1;
		k++;
		sFolder11 = tviTemp.insertFolder(sFolder1,"��ǰ����","",i1++);
		h[k] = sFolder11;
		k++;
		//�����������FLOW_TASK�в�ѯ����ǰ�û��Ĵ��������������Ϣ
		sSql = 	" select FlowNo,FlowName,PhaseType,PhaseNo,PhaseName,getNodeNo(FlowNo,PhaseNo) as NodeNo,Count(SerialNo) as WorkCount "+
				" from FLOW_TASK "+
				" where ObjectType = '"+sObjectType+"'  and PhaseType <>'1010' and PhaseType <>'1030' ";
				sSql += " and FlowNo in "+sTempFlowNo+" ";
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
			//if(!"".equals(sNodeNo)){
				//tviTemp.insertPage(sCurNodeNo,sFolder1,sPageShow,"","javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++,"");
			//}else
			//{
				tviTemp.insertPage(sFolder11,sPageShow,"javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++);
			//}
		}
		rs.getStatement().close();
	
		//4�����õ�ǰ�û����ڸ�����������ɹ����˵���
		sFolder12 = tviTemp.insertFolder(sFolder1,"����ɹ���","",i1++);
		sSql = 	" select FlowNo,FlowName,PhaseType,PhaseNo,PhaseName,Count(SerialNo) as WorkCount "+
				" from FLOW_TASK FT "+
				" where ObjectType = '"+sObjectType+"' ";
			sSql += " and FlowNo in "+sTempFlowNo+" ";
		sSql += " and UserID = '"+CurUser.UserID+"' "+
				" and EndTime is not null "+	
				" and EndTime <> ' ' and EndTime <> '' and PhaseType <>'1010' "+	
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
			
			tviTemp.insertPage(sFolder12,sPageShow,"javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);
		}
		rs.getStatement().close();
		j += 1;
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
		if(sFlowNo=="RiskSignalFlow")//Ԥ������
		{
			sTempApproveType="ApproveRiskSignalApply";
			//�򿪶�Ӧ����������
			OpenComp("<%=sCompID[0]%>","<%=sCompName[0]%>","ApproveType="+sTempApproveType+"&FlowNo="+sFlowNo+"&PhaseType="+sPhaseType+"&PhaseNo="+sPhaseNo+"&FinishFlag="+sFinishFlag,"right","");
		}else{//Ԥ�����
			sTempApproveType="ApproveRiskSignalFApply";
			//�򿪶�Ӧ����������
			OpenComp("<%=sCompID[1]%>","<%=sCompName[1]%>","ApproveType="+sTempApproveType+"&FlowNo="+sFlowNo+"&PhaseType="+sPhaseType+"&PhaseNo="+sPhaseNo+"&FinishFlag="+sFinishFlag,"right","");
		}
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
	<%
		int j1 = 0;
		while(j1<10)
		{
	%>
			expandNode('<%=h[j1]%>');
	<%
			j1++;
		}
	%>
	if("<%=sNodeNo%>" !="")
	{ 
		selectItem('<%=sNodeNo%>');
	}else{
		selectItem('3');
	}

	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
