<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong  2009/09/08
		Tester:
		Describe: ��ծ�ʲ���Ϣ(����)����
		Input Param:
			SerialNo��ҵ��������ˮ��
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ���Ϣ(����)����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	ASResultSet rs = null;//-- ��Ž����
	String sSql = "";
	String sRelativeSerialNo = "",sAssetName = "",sAssetAmount = "";
	String sAssetType = "",sEvalOrgName = "";
	double dAssetMarketSum = 0.00,dAssetEvaluateSum = 0.00,dAssetAccountSum = 0.00;
	//����������	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";
	
	//���ҳ�����		
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));	
	if(sSerialNo == null ) sSerialNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ȡ�ÿͻ�����
	sSql = "select SerialNo,AssetName,AssetAmount,AssetType,AssetMarketSum,"+
			" AssetEvaluateSum,EvalOrgName,AssetAccountSum"+
			" from ASSET_INFO "+
			" where SerialNo in(Select RelativeSerialNo "+
			" from BADBIZ_APPLY��where SerialNo='"+sObjectNo+"') ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sRelativeSerialNo = rs.getString("SerialNo");
		sAssetName = rs.getString("AssetName");
		sAssetAmount = rs.getString("AssetAmount");
		sAssetType = rs.getString("AssetType");
		dAssetMarketSum = rs.getDouble("AssetMarketSum");
		dAssetEvaluateSum = rs.getDouble("AssetEvaluateSum");
		sEvalOrgName = rs.getString("EvalOrgName");
		dAssetAccountSum = rs.getDouble("AssetAccountSum");
	}
	rs.getStatement().close();
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "PDADisposeInfo";

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//���ñ��ʷ�Χ
	//doTemp.appendHTMLStyle("RightProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"Ȩ��ֵ������ķ�ΧΪ[0,100]\" ");
	//doTemp.appendHTMLStyle("DebtProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"ծ��ֵ������ķ�ΧΪ[0,100]\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	dwTemp.setEvent("AfterUpdate","!PublicMethod.UpdateColValue(String@TempSaveFlag@2,BADBIZ_APPLY,String@SerialNo@#ObjectNo)");
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"flase","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{				
		if(bIsInsert)
		{
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/PDADisposeList.jsp","_self","");
		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	/*~[Describe=�Զ�����ֵ;InputParam=��;OutPutParam=��;]~*/
	function automCompute()
	{	
		sAssetSum = getItemValue(0,getRow(),"AssetSum");//��ծ�ʲ������
		sPershareValue = getItemValue(0,getRow(),"PershareValue");//�⴦��(����)�۸�
		sLossesSum = getItemValue(0,getRow(),"LossesSum");//Ԥ�ƴ��÷���
		setItemValue(0,0,"ProfitLossSum",sPershareValue-sAssetSum);
		setItemValue(0,0,"IntoCashSum",sPershareValue-sAssetSum-sLossesSum);
		if(sAssetSum!=0)
		{
			setItemValue(0,0,"IntoCashRatio",roundOff((sPershareValue-sAssetSum-sLossesSum)*100/sAssetSum,2));
		}
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
		setItemValue(0,0,"ObjectType","<%=sObjectType%>");
		setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}


	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		setItemValue(0,0,"RelativeSerialNo","<%=sRelativeSerialNo%>");
		setItemValue(0,0,"AssetName","<%=sAssetName%>");
		setItemValue(0,0,"AssetAmount","<%=sAssetAmount%>");
		setItemValue(0,0,"AssetType","<%=sAssetType%>");
		setItemValue(0,0,"AssetMarketSum","<%=dAssetMarketSum%>");
		setItemValue(0,0,"EvalNetValue","<%=dAssetEvaluateSum%>");
		setItemValue(0,0,"EvalOrgName","<%=sEvalOrgName%>");
		setItemValue(0,0,"AssetSum","<%=dAssetAccountSum%>");
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"AssetFlag","030");
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSET_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
