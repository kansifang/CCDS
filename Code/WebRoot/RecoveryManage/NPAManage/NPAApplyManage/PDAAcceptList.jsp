<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/09/08
		Tester:
		Describe: ��ծ�ʲ���Ϣ(��ȡ)�б�
		Input Param:
			ObjectType: ��������
			ObjectNo��������
		Output Param:
			SerialNo��ҵ����ˮ��
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ���Ϣ(��ȡ)�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//sql���
	ASResultSet rs = null;
	//���ҳ�����
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";

%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	String sHeaders[][] = 	{
				{"SerialNo","��ծ�ʲ����"},	
				{"ObjectNo","���ʵ�ծ������"},
				{"CustomerName","�ͻ�����"},
				{"BorrowerName","�ֳ�������"},
				{"BorrowerTypeName","�ֳ������"},
				{"AssetTypeName","�ʲ�����"},				
				{"AssetName","�ʲ�����"},
				{"AssetAmount","��ծ�ʲ�����"},
				{"AssetMarketSum","��ծ�ʲ��м�"},
				{"AssetEvaluateSum","��ծ�ʲ�������"},
				{"EnterAccountSum","��ծ�ʲ������ʼ۸�"},
				{"Number","��ֳ��������"},
				{"AssetSum","��ֳ������(Ԫ)"},
				{"AssetIBalance1","��ֳ�������Ϣ(Ԫ)"},
				{"AssetIBalance2","��ֳ�������Ϣ(Ԫ)"},
				{"OrgName","�Ǽǻ���"},
				{"UserName","�Ǽ���"},
			      	};
	
	
			      		
	sSql =	" select ObjectNo,SerialNo,CustomerName,BorrowerName,getItemName('BorrowerType1',BorrowerType) as BorrowerTypeName,"+
			" AssetType,getItemName('PDAAssetType',AssetType) as AssetTypeName,AssetName,"+
			" AssetAmount,"+
			" AssetMarketSum,AssetEvaluateSum,EnterAccountSum,"+
			" Number,AssetSum,AssetBalance,AssetIBalance1,AssetIBalance2, "+
			" InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName,AssetFlag " +
			" from ASSET_INFO " +
			" where ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' " ;


	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	doTemp.setVisible("AssetBalance,ObjectType,AssetType,AssetFlag,InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);

	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	
	//����С����ʾ״̬,
	doTemp.setAlign("AssetSum,AssetBalance,AssetIBalance1,AssetIBalance2,AssetMarketSum,AssetEvaluateSum,EnterAccountSum","3");
	doTemp.setType("AssetSum,AssetBalance,AssetIBalance1,AssetIBalance2,AssetMarketSum,AssetEvaluateSum,EnterAccountSum","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("AssetSum,AssetBalance,,AssetIBalance1,AssetIBalance2,AssetMarketSum,AssetEvaluateSum,EnterAccountSum","2");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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

	String sButtons[][] = 
		{
		{"true","","Button","����","������ծ�ʲ���Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴��ծ�ʲ���Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ծ�ʲ���Ϣ","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/PDAAcceptInfo.jsp","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sAssetType   = getItemValue(0,getRow(),"AssetType");
		sAssetFlag   = getItemValue(0,getRow(),"AssetFlag");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/PDAAcceptInfo.jsp?SerialNo="+sSerialNo+"&AssetType="+sAssetType+"&AssetFlag="+sAssetFlag, "_self","");
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
