<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/09/08
		Tester:
		Describe: ��ծ�ʲ���Ϣ(����)�б�
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
	String PG_TITLE = "��ծ�ʲ���Ϣ(����)�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
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
				{"SerialNo","���ʵ�ծ������"},		
				{"BorrowerName","��ծ��"},
				{"AssetName","��ծ�ʲ�����"},
				{"AssetAmount","��ծ�ʲ�����"},
				{"AssetBalance","ͬ���ʲ��г��۸�"},
				{"EvalNetValue","�����۸�"},
				{"AssetSum","����۸�"},
				{"AssetTypeName","�⴦�÷�ʽ"},
				{"PershareValue","�⴦�ü۸�"},
				{"LossesSum","�⴦�÷���"},
				{"ProfitLossFlagName","Ԥ��ӯ��"},
				{"ProfitLossSum","Ԥ��ӯ����"},
				{"LossSum","Ԥ����ʧ��(%)"},
				{"InAccontDate","�⴦��ʱ��"},
				{"OrgName","�Ǽǻ���"},
				{"UserName","�Ǽ���"},
			      	};
	
	
			      		
	String sSql =	" select SerialNo,AssetType,BorrowerName,AssetName,AssetAmount,"+
					" AssetBalance,EvalNetValue,AssetSum,"+
					" getItemName('PDADispositionType',AssetType) as AssetTypeName,PershareValue,LossesSum,"+
					" getItemName('ProfitLoss',ProfitLossFlag) as ProfitLossFlagName,ProfitLossSum,LossSum,InAccontDate, "+
					" InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName " +
					" from ASSET_INFO " +
					" where ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' " ;


	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	doTemp.setVisible("ObjectType,ObjectNo,AssetType,InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);

	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	
	//����С����ʾ״̬,
	doTemp.setAlign("AssetSum,ProfitLossSum,AssetBalance,EvalNetValue","3");
	doTemp.setType("AssetSum,ProfitLossSum,AssetBalance,EvalNetValue","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("AssetSum,ProfitLossSum,AssetBalance,EvalNetValue","2");
	
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
		OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/PDADisposeInfo.jsp","_self","");
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
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/PDADisposeInfo.jsp?SerialNo="+sSerialNo, "_self","");
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
