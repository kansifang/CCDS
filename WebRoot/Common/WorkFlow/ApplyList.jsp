<%@page import="com.amarsoft.are.sql.ASResultSet"%>
<%@page import="com.amarsoft.are.util.DataConvert"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: ��ҳ����Ҫ����ҵ����ص������б������Ŷ�������б��������ҵ�������б�
			 ��������ҵ�������б�������������Ǽ��б����������б�
	Input Param:
		ApplyType����������
			��CreditLineApply/���Ŷ������
			��DependentApply/�����������	
			��IndependentApply/��������ҵ������	
			��ApproveApply/���ύ���������������
			��PutOutApply/���ύ��˳���
		PhaseType���׶�����
			��1010/���ύ�׶Σ���ʼ�׶Σ�
	Output param:
	History Log: zywei 2005/07/27 �ؼ�ҳ��
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = ""; //���SQL���
	ASResultSet rs = null; //��Ų�ѯ�����
	String sTempletNo = ""; //��ʾģ��ItemNo
	String sPhaseTypeSet = ""; //��Ž׶�������
	String sButton = ""; 
	String sObjectType = ""; //��Ŷ�������
	String sViewID = ""; //��Ų鿴��ʽ
	String sWhereClause1 = ""; //��Ž׶�����ǿ��where�Ӿ�1
	String sWhereClause2 = ""; //��Ž׶�����ǿ��where�Ӿ�2
	String sInitFlowNo = ""; 
	String sInitPhaseNo = "";
	String sButtonSet = "";
	
	//����������:��������,�׶�����	
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType")); //????
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType")); //????
	//����ֵת���ɿ��ַ���
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	//�����������(��������)�Ӵ����CODE_LIBRARY�л��ApplyMain����ͼ�Լ�������Ľ׶�,���̶�������,ApplyListʹ���ĸ�ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApplyType' and ItemNo = '"+sApplyType+"' ";
	
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
		throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ApplyType:"+sApplyType+"����");
	}
	rs.getStatement().close();
	//�������ID���������(�׶�����)�Ӵ����CODE_LIBRARY�в�ѯ����ʾ�İ�ť,��ʲô��ͼ�鿴��������,where����1,where����2,ApplyList���ݶ���ID
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute1,Attribute2,Attribute4 "+
			" from CODE_LIBRARY where CodeNo = '"+sPhaseTypeSet+"' and ItemNo = '"+sPhaseType+"' ";

	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sButton = rs.getString("ItemDescribe");
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));
		sTempletNo = rs.getString("Attribute4");
		
		//����ֵת���ɿ��ַ���
		if(sButton == null) sButton = "";
		if(sViewID == null) sViewID = "";
		if(sWhereClause1 == null) sWhereClause1 = "";
		if(sWhereClause2 == null) sWhereClause2 = "";
		if(sTempletNo == null) sTempletNo = "";
	}else{
		throw new Exception("û���ҵ���Ӧ������׶ζ��壨CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"����");
	}
	rs.getStatement().close();
	
	if(sTempletNo.equals("")) throw new Exception("û�ж���sTempletNo, ���CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"??");
	if(sViewID.equals("")) throw new Exception("û�ж���ViewID ���CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"??");
	
	//�����������(��������)�Ӵ����CODE_LIBRARY�л��Ĭ������ID
	sSql = " select Attribute2 from CODE_LIBRARY where CodeNo = 'ApplyType' and ItemNo = '"+sApplyType+"' ";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sInitFlowNo = rs.getString("Attribute2");
		
		//����ֵת���ɿ��ַ���
		if(sInitFlowNo == null) sInitFlowNo = "";
	}
	rs.getStatement().close();
	
	//����Ĭ������ID�����̱�FLOW_CATALOG�л�ó�ʼ�׶�
	sSql = " select InitPhase from FLOW_CATALOG where FlowNo = '"+sInitFlowNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sInitPhaseNo = rs.getString("InitPhase");
		
		//����ֵת���ɿ��ַ���
		if(sInitPhaseNo == null) sInitPhaseNo = "";
	}
	rs.getStatement().close();


	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletFilter = "1=1";
	//������ʾģ���ź���ʾģ�������������DataObject����
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//���ø��±���������
	doTemp.UpdateTable = "FLOW_OBJECT";
	doTemp.setKey("ObjectType,ObjectNo",true);	 //Ϊ�����ɾ��
	//��where����1��where����2�еı�����ʵ�ʵ�ֵ�滻��������Ч��SQL���
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.UserID);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ApplyType",sApplyType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ObjectType",sObjectType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#PhaseType",sPhaseType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#UserID",CurUser.UserID);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ApplyType",sApplyType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ObjectType",sObjectType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#PhaseType",sPhaseType);
	//���ӿո��ֹsql���ƴ�ӳ���
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	//����ASDataObject�е���������
	doTemp.OrderClause = " order by FLOW_OBJECT.ObjectNo desc ";

	//���ɲ�ѯ��
	if(sApplyType.equals("BadBizApply")||sApplyType.equals("DebtDisposeApply")){ //����ҵ������ʱչʾ
		doTemp.setFilter(Sqlca,"1","SerialNo","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"3","OccurType","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"4","ApplyDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"5","OperateUserName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		doTemp.setFilter(Sqlca,"6","OperateOrgName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	}else
	{
		doTemp.setFilter(Sqlca,"1","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	}
	if(!sApplyType.equals("CreditCogApply")&&!sApplyType.equals("BadBizApply")&&
			!sApplyType.equals("DebtDisposeApply")&&!sApplyType.equals("RiskSignalApply")&&
			!sApplyType.equals("RiskSignalFApply")){ //���õȼ���������ʱ��չʾ
		if(sApplyType.equals("ContractModApply")||sApplyType.equals("DataModApply")){
			doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' and ItemNo <> '015' and IsInUse='1'");
			doTemp.setFilter(Sqlca,"2","OccurType","Operators=EqualsString;");
		}
		else{
			doTemp.setFilter(Sqlca,"2","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}
	}
	//�����ʲ���ʾ�б��ֶο���
	if(sApplyType.equals("BadBizApply")){ 
		if(sPhaseType.equals("1030"))//�˻ز�������
		{
			doTemp.setVisible("ReturnDate",true);
			doTemp.setFilter(Sqlca,"7","ReturnDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}else if(sPhaseType.equals("1040"))//��׼
		{
			doTemp.setVisible("PassDate",true);
			doTemp.setFilter(Sqlca,"7","PassDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}else if(sPhaseType.equals("1050"))//���
		{
			doTemp.setVisible("VetoDate",true);
			doTemp.setFilter(Sqlca,"7","VetoDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}else if(sPhaseType.equals("1070"))//�޷�ִ��
		{
			doTemp.setVisible("PassDate",true);
			doTemp.setFilter(Sqlca,"7","PassDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}else if(sPhaseType.equals("1060"))//�鵵
		{
			doTemp.setVisible("PigeonholeDate",true);
			doTemp.setFilter(Sqlca,"7","PigeonholeDate","Operators=BeginsWith,EndWith,Contains,EqualsString;");
		}
	}
	
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(10);
	//ɾ����ǰ��ҵ����Ϣ
	//if(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract"))
	//	dwTemp.setEvent("AfterDelete","!BusinessManage.AddCLInfoLog(#ObjectType,#ObjectNo,Delete,#UserID,#OrgID)+!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	//else
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'"+sApplyType+"','"+sPhaseType+"','"+CurUser.UserID+"'");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//out.println("-------sql"+doTemp.SourceSql); //������仰����datawindowװ�����ݵ�SQL���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
	//0.�Ƿ���ʾ
	//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
	//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.��ť����
	//4.˵������
	//5.�¼�
	//6.��ԴͼƬ·��
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	//���ڿ��Ƶ��а�ť��ʾ��������
	String iButtonsLineMax = "9";
	//���ݰ�ť���Ӵ����CODE_LIBRARY�в�ѯ����ťӢ�����ƣ�����1������2��Button������ť�������ơ���ť������������ť����javascript��������
	sSql = 	" select ItemNo,Attribute1,Attribute2,ItemName,ItemDescribe,RelativeCode "+
			" from CODE_LIBRARY where CodeNo = '"+sButtonSet+"' and IsInUse = '1' Order by SortNo ";
	//out.println(sSql);
	rs = Sqlca.getASResultSet(sSql); 
	while(rs.next()){
		iCountRecord++;
		sButtons[iCountRecord][0] = (sButton.indexOf(rs.getString("ItemNo"))>=0?"true":"false");
		//sButtons[iCountRecord][0] = "true";
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ApplyType",sApplyType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseType",sPhaseType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		}
		sButtons[iCountRecord][6] = sResourcesPath;
		//�������Ŷ�����뼰�������ҵ�����벻��ʾ���͹�����������ť
		if("CreditLineApply".equals(sApplyType)||"DependentApply".equals(sApplyType))
		{
			if("doneApproveResult".equals(rs.getString("ItemNo")))
			{
				sButtons[iCountRecord][0]="false";	
			}
		}
		//��������ҵ����ʾ���͸���
		if("CreditApply".equals(sObjectType))
		{
			if("send".equals(rs.getString("ItemNo")))
			{
				sButtons[iCountRecord][0]="false";
			}
		}
	}
	rs.getStatement().close();
	
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);

	%> 
<%/*~END~*/%>