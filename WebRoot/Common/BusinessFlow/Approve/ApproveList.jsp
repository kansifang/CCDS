<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//���������SQL��䡢ģ��ItemNo���׶������顢�����Ӧ�׶Ρ��׶�����ǿ��where�Ӿ�1���׶�����ǿ��where�Ӿ�2
	String sSql = "",sTempletNo = "",sTreeMain = "",sViewID = "",sWhereClause1 = "",sWhereClause2 = ""; 
	//�����������ť������ť���������̶���
	String sButtonSet = "",sButton = "",sObjectType = "";
	//�Ƿ�ǿ�����ɷ������۱��� added bllou 2012-02-21
	boolean bYNRiskReport = false;
	//�����������ѯ�����
	ASResultSet rs = null; 
	
	//����������:���̶������͡��������͡����̱�š��׶α�š��׶����͡���ɱ�־
	String sApproveType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType")));
	String sFlowNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"))); 
	String sPhaseNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"))); 
	String sPhaseType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"))); 
	String sFinishFlag = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishFlag"))); 
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	//�Ӵ����CODE_LIBRARY�л��ApproveMain����ͼ�Լ�������Ľ׶�,���̶�������,TaskListʹ���ĸ�ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5"+
			" from CODE_LIBRARY "+
			" where CodeNo = 'ApproveType'"+
			" and ItemNo = '"+sApproveType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sTreeMain = DataConvert.toString(rs.getString("ItemDescribe"));
		sObjectType = DataConvert.toString(rs.getString("ItemAttribute"));
		sButtonSet = DataConvert.toString(rs.getString("Attribute5"));		
	}else{
		throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApproveType:"+sApproveType+"����");
	}
	rs.getStatement().close();
	//�Ӵ����CODE_LIBRARY�в�ѯ����ʲô��ͼ�鿴��������,where����1,where����2,ApplyList���ݶ���ID		
	sSql = 	" select ItemAttribute,Attribute1,Attribute2,Attribute4 "+
			" from CODE_LIBRARY"+
			" where CodeNo = '"+sTreeMain+"'"+
			" and ItemNo = '"+sFinishFlag+"'";//N or Y
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){				
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));
		sTempletNo = rs.getString("Attribute4");
	}else{		
		throw new Exception("û���ҵ���Ӧ�������׶ζ��壨CODE_LIBRARY,"+sSql+","+sFinishFlag+"����");
	}
	rs.getStatement().close();
	if(sTempletNo.equals("")) 
		throw new Exception("û�ж��������б����ݶ���CODE_LIBRARY.ApproveType:"+sApproveType+"����");
	if(sViewID.equals("")) 
		throw new Exception("û�ж��������׶���ͼ��CODE_LIBRARY,"+sTreeMain+","+sFinishFlag+"����");
		
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletFilter = "1=1";
	//������ʾģ���ź���ʾģ�������������DataObject����
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
	//���ɲ�ѯ��
	////���õȼ���������,����������������ծ�ʲ������������ʲ�����ʱ��չʾ
	doTemp.generateFilters(Sqlca);
 	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);
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
	//������ɱ�־����ȡ��Ӧ���̱�š���Ӧ�׶α��Ӧ��ʾ�Ĺ��ܰ�ť,Task�׶������������ð�ť
	if(sFinishFlag.equals("N")) //��ǰ����
		sButton = DataConvert.toString(Sqlca.getString("select Attribute1 from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'"));
	if(sFinishFlag.equals("Y")) //����ɹ���
		sButton = DataConvert.toString(Sqlca.getString("select Attribute2 from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'"));
	sSql = " select ItemNo,Attribute1,Attribute2,ItemName,ItemDescribe,RelativeCode"+
		" from CODE_LIBRARY"+
		" where CodeNo = '"+sButtonSet+"'"+
		" and locate(ItemNo,'"+sButton+"')>0"+
		" and IsInUse = '1' Order by SortNo ";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){		
		sButtons[iCountRecord][0] ="true";
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) 
			sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ApplyType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseType",sPhaseType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		} 
		sButtons[iCountRecord][6] = sResourcesPath;
		iCountRecord++;
	}
	rs.getStatement().close();
	%> 
<%
	//add by bllou ����Ƿ�����������յ��鱨����Ϣ 2012-02-21
	if("CreditApply".equalsIgnoreCase(sObjectType) && sButton.indexOf("genRiskReport") >= 0 && (CurUser.hasRole("009") || CurUser.hasRole("209") || CurUser.hasRole("409") )){
		bYNRiskReport = true;
	}
%>
<%/*~END~*/%>
