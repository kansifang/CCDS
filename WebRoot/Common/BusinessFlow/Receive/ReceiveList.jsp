<%@page import="java.util.HashMap"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	String sSql = ""; //���SQL���
	ASResultSet rs = null; //��Ų�ѯ�����
	String sTempletNo = ""; //��ʾģ��ItemNo
	String sTreeMain = ""; //��Ž׶�������
	String sButton = ""; 
	String sObjectType = ""; //��Ŷ�������
	String sViewID = ""; //��Ų鿴��ʽ
	String sWhereClause1 = ""; //��Ž׶�����ǿ��where�Ӿ�1
	String sWhereClause2 = ""; //��Ž׶�����ǿ��where�Ӿ�2
	String sFlowNo = ""; 
	String sButtonSet = "";
	
	//����������:��������,�׶�����	
	String sReceiveType =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReceiveType")));
	String sPhaseNo =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo")));
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	//1�������������(��������)�Ӵ����CODE_LIBRARY�л��
	//ApplyMain����ͼ --ItemDescribe
	//������Ľ׶�,
	//���̶�������---ItemAttribute
	//ApplyListʹ���ĸ�����----Attribute2
	//ApplyListʹ���ĸ�ButtonSet----Attribute5
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute2,Attribute5"+
			" from CODE_LIBRARY "+
			" where CodeNo = 'ReceiveType'"+
			" and ItemNo = '"+sReceiveType+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sTreeMain = DataConvert.toString(rs.getString("ItemDescribe"));
		sObjectType = DataConvert.toString(rs.getString("ItemAttribute"));
		sFlowNo = DataConvert.toString(rs.getString("Attribute2"));
		sButtonSet = DataConvert.toString(rs.getString("Attribute5"));
	}else{
		throw new Exception("û���ҵ���Ӧ���������Ͷ��壨CODE_LIBRARY.ReceiveType:"+sReceiveType+"����");
	}
	rs.getStatement().close();
	//2��������ͼ����ͼ��(�׶�����)�Ӵ����CODE_LIBRARY�в�ѯ��
	//��ʾ�İ�ť -----ItemDescribe
	//��ʲô��ͼ�鿴��������--ItemAttribute 000�ǳ���Ȩ����ͼ 001��������Ȩ�ޣ�������Ȩ��
	//where����1,where����2--Attribute1,Attribute2
	//��ʾģ���dono--Attribute4
	//��ѯ�ֶ�--Attribute6
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute1,Attribute2,Attribute4"+
			" from CODE_LIBRARY "+
			" where CodeNo = '"+sTreeMain+"'"+
			" and ItemNo = '"+sPhaseNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sButton = DataConvert.toString(rs.getString("ItemDescribe"));
		sViewID = DataConvert.toString(rs.getString("ItemAttribute"));
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));
		sTempletNo = DataConvert.toString(rs.getString("Attribute4"));
	}else{
		throw new Exception("û���ҵ���Ӧ������׶ζ��壨CODE_LIBRARY,"+sTreeMain+","+sPhaseNo+"����");
	}
	rs.getStatement().close();
	
	if(sTempletNo.equals("")) 
		throw new Exception("û�ж���sTempletNo, ���CODE_LIBRARY,"+sTreeMain+","+sPhaseNo+"??");
	if(sViewID.equals("")) 
		throw new Exception("û�ж���ViewID ���CODE_LIBRARY,"+sTreeMain+","+sPhaseNo+"??");
	//4����ʾģ�崦��
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletFilter = "1=1";
	//������ʾģ���ź���ʾģ�������������DataObject����
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
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
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);
	//ɾ����ǰ��ҵ����Ϣ
	dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'"+sReceiveType+"','"+sPhaseNo+"','"+CurUser.UserID+"'");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println("-------sql"+doTemp.SourceSql); //������仰����datawindowװ�����ݵ�SQL���
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//���ݰ�ť���Ӵ����CODE_LIBRARY�в�ѯ��
	//����Ϊ��
	//0.�Ƿ���ʾ
	//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)--����1��
	//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)--����2��Button��
	//3.��ť���� ��ť��������--ItemName
	//4.��ť����������˵������--ItemDescribe
	//5.��ť����javascript�������ƣ��¼�--RelativeCode
	//6.��ԴͼƬ·��
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	//���ڿ��Ƶ��а�ť��ʾ��������
	String iButtonsLineMax = "8";
	sSql = 	" select ItemNo,Attribute1,Attribute2,ItemName,ItemDescribe,RelativeCode"+
			" from CODE_LIBRARY "+
			" where CodeNo = '"+sButtonSet+"'"+
			" and locate(ItemNo,'"+sButton+"')>0"+
			" and IsInUse = '1'"+
			" Order by SortNo ";
	rs = Sqlca.getASResultSet(sSql); 
	while(rs.next()){
		iCountRecord++;
		//��ť�Ƿ���ʾ
		sButtons[iCountRecord][0] = "true";
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) 
			sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		//��ť�¼�
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ReceiveType",sReceiveType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseNo",sPhaseNo);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		}
		sButtons[iCountRecord][6] = sResourcesPath;
	}
	rs.getStatement().close();
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
	%> 
<%/*~END~*/%>
