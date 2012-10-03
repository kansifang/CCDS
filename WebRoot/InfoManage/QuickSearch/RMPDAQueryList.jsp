<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong 2004.12.07
		Tester:
		Content: ��ծ�ʲ����ٲ�ѯ
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ���ծ�ʲ����ٲ�ѯ
					ObjectType		�������ͣ�ASSET_INFO
												����������Ŀ���Ǳ�����չ��,�������ܻ��ῼ�������ʲ���
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql;//���sql���
	String sComponentName;//--�������
	String PG_CONTENT_TITLE;//--��ͷ
	String sObjectType="ASSET_INFO";//--��������
	
	//����������	,�������
	sComponentName	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"SerialNo","�ʲ����"},										
							{"AssetName","�ʲ�����"},
							{"AssetStatus","�ʲ�״̬"},
							{"AssetStatusName","�ʲ�״̬"},
							{"Flag","�������/����"},
							{"FlagName","�������/����"},
							{"AssetType","�ʲ����"},	
							{"AssetTypeName","�ʲ����"},	
							{"AssetSum","��ծ���(Ԫ)"},
							{"AssetBalance","�ʲ����(Ԫ)"},
							{"ManageUserID","������"},
							{"ManageOrgID","�������"}
						}; 

	//�ӵ�ծ�ʲ���Ϣ��ASSET_INFO��ѡ���ѵ���/�����е��ʲ�

	sSql = 	" select SerialNo,"+
			" AssetName,"+
			" AssetStatus,"+
			" getItemName('AssetStatus',trim(AssetStatus)) as AssetStatusName,"+
			" AssetType,"+
			" getItemName('PDAType',trim(AssetType)) as AssetTypeName,"+
			" Flag ,"+
			" getItemName('Flag',Flag) as FlagName,"+
			" AssetSum, " +	
			" AssetBalance, " +	
			" getUserName(ManageUserID) as ManageUserID, " +	
			" getOrgName(ManageOrgID) as ManageOrgID"+			
			" from ASSET_INFO" +
			" where AssetAttribute='01' "+
			" and ObjectType='AssetInfo' "+
			" order by AssetName desc";
	//AssetAttribute��01����ծ�ʲ���02������ʲ�
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("SerialNo");

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";
	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);	 

	//���ò��ɼ���
	doTemp.setVisible("AssetType,Flag,AssetStatus",false);

	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("SerialNo","style={width:100px} ");  
	doTemp.setHTMLStyle("AssetTypeName,FlagName","style={width:85px} ");  
	doTemp.setHTMLStyle("AssetName,ManageUserID,ManageOrgID,AssetSum,AssetBalance,AssetNo,AssetStatusName"," style={width:80px} ");
	
	//���ö��뷽ʽ
	doTemp.setAlign("AssetSum,AssetBalance","3");
	doTemp.setType("AssetSum,AssetBalance","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("AssetSum,AssetBalance","2");
		
	//���ɲ�ѯ��*************************************************************************************
	doTemp.setDDDWCode("AssetType","PDAType");
	doTemp.setDDDWCode("AssetStatus","AssetStatus");

	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","AssetName","");
	doTemp.setFilter(Sqlca,"2","AssetType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"3","AssetStatus","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"4","ManageOrgID","");
	doTemp.setFilter(Sqlca,"5","ManageUserID","");
	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

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
	String sButtons[][] = {
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��õ�ծ�ʲ���ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");			
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","ObjectNo="+sSerialNo+"&RightType=ReadOnly","");
		reloadSelf();
	}	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
