<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong  2010/01/25
		Tester:
		Describe: ��ծ�ʲ���������
		Input Param:
			SerialNo��ҵ��������ˮ��
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//sql���
	ASResultSet rs = null;
	String sEidtRight = "";

	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";
	//���ҳ�����	������ˮ��,��ծ�ʲ�����,��ծ�ʲ������׶�	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sAssetType = DataConvert.toRealString(iPostChange,(String)request.getParameter("AssetType"));	
	String sAssetFlag = DataConvert.toRealString(iPostChange,(String)request.getParameter("AssetFlag"));
	if(sSerialNo == null ) sSerialNo = "";
	if(sAssetType == null ) sAssetType = "";
	if(sAssetFlag == null ) sAssetFlag = "";
	
	if("020010010".equals(sDealType) || "020010020".equals(sDealType))
	{
		sEidtRight = "01";
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "";
	//���ݵ�ծ�ʲ�����ȡ��ͬ�ĵ�ծ�ʲ�ģ��
	if(sAssetType.length()>2)
	{
		if(sAssetType.substring(0,6).equals("010010"))//������Ϣ
		{
			sTempletNo = "PDAssetSoilMendInfo";
		}else if(sAssetType.substring(0,6).equals("010020"))//������Ϣ
		{
			sTempletNo = "PDAssetHouseMendInfo";
		}else if(sAssetType.substring(0,3).equals("020"))//������������Ϣ
		{
			sTempletNo = "PDAssetOthersMendInfo";
		}
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//���ñ��ʷ�Χ
	//doTemp.appendHTMLStyle("RightProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"Ȩ��ֵ������ķ�ΧΪ[0,100]\" ");
	//doTemp.appendHTMLStyle("DebtProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"ծ��ֵ������ķ�ΧΪ[0,100]\" ");

	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		{"01".equals(sEidtRight)?"true":"flase","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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
		if("<%=sDealType%>" == "050" || "<%=sDealType%>" == "060" )
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAssetDisposeList.jsp","_self","");
		}else
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAssetList.jsp","_self","");
		}
		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	 /*~[Describe=�����ʲ�����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectPDAAssetType()
	{
		sParaString = "CodeNo"+",PDAAssetType";		
		setObjectValue("SelectCode",sParaString,"@AssetType@0@AssetTypeName@1",0,0,"");
	}
	
	/*~[Describe=�Զ������ծ�ʲ��������;InputParam=��;OutPutParam=��;]~*/
	function getAssetAccountBalance()
	{
		sAssetAccountSum = getItemValue(0,getRow(),"AssetAccountSum");//��ծ�ʲ����˽��
		sAssetSaleSum = getItemValue(0,getRow(),"AssetSaleSum");//��ծ�ʲ����۱��ֽ��
		sAssetDisposeSum = getItemValue(0,getRow(),"AssetDisposeSum");//��ծ�ʲ�������ʧ���
		if (typeof(sAssetAccountSum)!="undefined" && sAssetAccountSum.length!=0&&typeof(sAssetSaleSum)!="undefined" && sAssetSaleSum.length!=0&&typeof(sAssetDisposeSum)!="undefined" && sAssetDisposeSum.length!=0)
		{
			setItemValue(0,0,"AssetAccountBalance",sAssetAccountSum-sAssetSaleSum-sAssetDisposeSum);
		}
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
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
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
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
