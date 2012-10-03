<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.6
		Tester:
		Content: ��ҳ����Ҫ����ҵ��������ص������������������������ˡ��Ŵ����븴��
		Input Param:
			ApproveType:��������			
			PhaseType���׶�����
			FlowNo������ģ�ͱ��
			PhaseNo���׶α��
			FinishFlag����ɱ�־��Y������ɣ�N��δ��ɣ�
		Output param:
		History Log: 
			2005.08.03 jbye    �����޸�������������Ϣ
			2005.08.05 zywei   �ؼ�ҳ��
			2006.02.21 zywei   ����������б��ϵİ�ť���ô����ݱ�CODE_LIBRARY���ֶ�ItemDescribe�Ƶ����ݱ�FLOW_MODEL���ֶ�Attribute1��Attribute2
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//���������SQL��䡢ģ��ItemNo���׶������顢�����Ӧ�׶Ρ��׶�����ǿ��where�Ӿ�1���׶�����ǿ��where�Ӿ�2
	String sSql = "",sTempletNo = "",sPhaseTypeSet = "",sViewID = "",sWhereClause1 = "",sWhereClause2 = ""; 
	//�����������ť������ť���������̶���
	String sButtonSet = "",sButton = "",sObjectType = "";
	//�����������ѯ�����
	ASResultSet rs = null; 
	
	//����������:���̶������͡��������͡����̱�š��׶α�š��׶����͡���ɱ�־
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo")); 
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo")); 
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType")); 
	String sFinishFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishFlag")); 
		
	//����ֵת���ɿ��ַ���
	if(sApproveType == null) sApproveType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";	
	if(sPhaseType == null) sPhaseType = "";
	if(sFinishFlag == null) sFinishFlag = "";
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	//�Ӵ����CODE_LIBRARY�л��ApproveMain����ͼ�Լ�������Ľ׶�,���̶�������,TaskListʹ���ĸ�ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApproveType' and ItemNo = '"+sApproveType+"' ";
	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sPhaseTypeSet = rs.getString("ItemDescribe");
		sObjectType = rs.getString("ItemAttribute");
		sButtonSet = rs.getString("Attribute5");		
		
		//����ֵת���ɿ��ַ���
		if(sPhaseTypeSet == null) sPhaseTypeSet = "";
		if(sObjectType == null) sObjectType = "";
		if(sButtonSet == null) sButtonSet = "";		
	}else{
		throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApproveType:"+sApproveType+"����");
	}
	rs.getStatement().close();
	//�����������������,����������
	if("CreditApproveFlow01".equals(sFlowNo))
	{
		sObjectType="CreditApproveApply";
	}
	//�Ӵ����CODE_LIBRARY�в�ѯ����ʲô��ͼ�鿴��������,where����1,where����2,ApplyList���ݶ���ID		
	sSql = 	" select ItemAttribute,Attribute1,Attribute2,Attribute4 "+
			" from CODE_LIBRARY where CodeNo = '"+sPhaseTypeSet+"' and ItemNo = '"+sFinishFlag+"' ";	
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){				
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));
		sTempletNo = rs.getString("Attribute4");
		
		//����ֵת���ɿ��ַ���		
		if(sViewID == null) sViewID = "";
		if(sWhereClause1 == null) sWhereClause1 = "";
		if(sWhereClause2 == null) sWhereClause2 = "";
		if(sTempletNo == null) sTempletNo = "";
	}else{		
		throw new Exception("û���ҵ���Ӧ�������׶ζ��壨CODE_LIBRARY,"+sSql+","+sFinishFlag+"����");
	}
	rs.getStatement().close();
	
	if(sTempletNo.equals("")) throw new Exception("û�ж��������б����ݶ���CODE_LIBRARY.ApproveType:"+sApproveType+"����");
	if(sViewID.equals("")) throw new Exception("û�ж��������׶���ͼ��CODE_LIBRARY,"+sPhaseTypeSet+","+sFinishFlag+"����");
	
	if(sObjectType.equalsIgnoreCase("PutOutApply") && (CurUser.hasRole("460") || CurUser.hasRole("260") || CurUser.hasRole("060") || CurUser.hasRole("0N5")) && sApproveType.equals("ApprovePutOutApply"))
	{
		if(sFinishFlag.equals("Z"))
		{
			sWhereClause2 += " and Business_PutOut.SendFlag in ('1','2') ";
		}else if(sFinishFlag.equals("Y"))
		{
			sWhereClause2 += " and (Business_PutOut.SendFlag not in ('1','2') or Business_PutOut.SendFlag is null) ";
		}
	}
	
		
	//add by zywei 2006/02/21 ������ɱ�־����ȡ��Ӧ���̱�š���Ӧ�׶α��Ӧ��ʾ�Ĺ��ܰ�ť
	if(sFinishFlag.equals("N")) //��ǰ����
		sButton = Sqlca.getString("select Attribute1 from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'");
	if(sFinishFlag.equals("Y") || sFinishFlag.equals("Z") ) //����ɹ���
		sButton = Sqlca.getString("select Attribute2 from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'");
	//����ֵת���ɿ��ַ���
	if(sButton == null) sButton = "";
			
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletFilter = "1=1";
	//������ʾģ���ź���ʾģ�������������DataObject����
	System.out.println("sTempletNo::::"+sTempletNo);
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//���ø��±���������
	doTemp.UpdateTable = "FLOW_TASK";
	doTemp.setKey("SerialNo",true);	 //Ϊ�����ɾ��
	//��where����1��where����2�еı�����ʵ�ʵ�ֵ�滻��������Ч��SQL���
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.UserID);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#PhaseNo",sPhaseNo);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#FlowNo",sFlowNo);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ObjectType",sObjectType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#UserID",CurUser.UserID);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#PhaseNo",sPhaseNo);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#FlowNo",sFlowNo);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ObjectType",sObjectType);
	//���ӿո��ֹsql���ƴ�ӳ���
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	//����ASDataObject�е���������
	doTemp.OrderClause = " order by FLOW_TASK.SerialNo desc ";
	
	doTemp.setAlign("CurrencyName,OccurTypeName","2");
	doTemp.setType("BusinessSum","Number");
	//add by xhyong 2011/04/02
	if("CreditApply".equals(sObjectType)&& (sFinishFlag.equals("Y") || sFinishFlag.equals("Z")))//����ҵ������
	{
		doTemp.setVisible("ApproveUserName,ApproveOrgName,ApproveDate",true);
	}
	//end add
	//���ɲ�ѯ��
	if(!sApproveType.equals("CreditCogApprove")&&!sApproveType.equals("ApproveBadBizApply")&&
	!sApproveType.equals("ApproveRiskSignalApply")&&!sApproveType.equals("ApproveRiskSignalFApply")){ //���õȼ���������ʱ��չʾ ,�弶����,����ҵ������ʱ��չʾ
		if(sApproveType.equals("ContractModApply")||sApproveType.equals("DataModApply")){
			doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' and ItemNo <> '015' and IsInUse='1'");
			doTemp.setFilter(Sqlca,"1","OccurType","Operators=EqualsString;");
		}
		else{
			doTemp.setFilter(Sqlca,"1","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}
	}
	if(!sApproveType.equals("ApproveBadBizApply")){ //�弶����ʱ��չʾ
		doTemp.setFilter(Sqlca,"2","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	}
	if(sApproveType.equals("ApproveBadBizApply"))//����ҵ������
	{
		doTemp.setFilter(Sqlca,"1","ObjectNo","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"3","OccurType","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"4","InputDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"5","OperateUserName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"6","OperateOrgName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	}
	if(sApproveType.equals("ApprovePutOutApply")){
		doTemp.setFilter(Sqlca,"3","ObjectNo","");
	}
 	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(10);
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'','"+sPhaseType+"','"+CurUser.UserID+"'");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //������仰����datawindowװ�����ݵ�SQL���
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	sSql = " select * from CODE_LIBRARY where CodeNo = '"+sButtonSet+"' and IsInUse = '1' Order by SortNo ";

	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){		
		sButtons[iCountRecord][0] = (sButton.indexOf(rs.getString("ItemNo"))>=0?"true":"false");
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ApplyType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseType",sPhaseType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		} 
		sButtons[iCountRecord][6] = sResourcesPath;

		if(sObjectType.equalsIgnoreCase("PutOutApply") && (CurUser.hasRole("460") || CurUser.hasRole("260") || CurUser.hasRole("060")) && sApproveType.equals("ApprovePutOutApply"))
		{
			if(sFinishFlag.equals("Z") && sButtons[iCountRecord][5].equals("send()"))
			{
				sButtons[iCountRecord][3] = "��ӡ֪ͨ��";
			}else if(sFinishFlag.equals("Y") && sButtons[iCountRecord][5].equals("cancelSend()"))
			{
				sButtons[iCountRecord][0]="false";
			}
			//֧�����Ա�޲鿴��鱨�水ť
			if(CurUser.hasRole("460")&& sButtons[iCountRecord][5].equals("viewCreateApproveReport()"))
			{
				sButtons[iCountRecord][0]="false";
			}
		}
		iCountRecord++;
	}
	rs.getStatement().close();
	 
	%> 
<%/*~END~*/%>
