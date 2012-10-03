<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
	/*
		Author: FSGong  2004-12-14
		Tester:
		Describe: ��ծ�ʲ�����̨��;
		Input Param:
				ObjectType���������ͣ�ASSET_INFO��
				ObjectNo�������ţ��ʲ���ˮ�ţ�
		Output param:	          
		HistoryLog:zywei 2005/09/07 �ؼ����
	*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�����̨���б�;"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";	
	
	//���ҳ�����

%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�����ͷ�ļ�
	String sHeaders[][] = {
							{"ObjectType","��������"},
							{"ObjectNo","�ʲ���ˮ��"},
							{"SerialNo","������ˮ��"},						
							{"AssetName","�ʲ�����"},
							{"CashBackType","�ջط�ʽ"},
							{"FormerCurrency","ԭ����"},
							{"ReclaimCurrency","���ֱ���"},
							{"ReclaimSum","���ֽ��"},
							{"EnterAccountDate","��������"},			
							{"ReclaimDate","��������"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputDate","�Ǽ�����"}
						 };  
						 
	sSql = 	" select RECLAIM_INFO.ObjectType as ObjectType,"+
			" RECLAIM_INFO.ObjectNo as ObjectNo,"+
			" RECLAIM_INFO.SerialNo as SerialNo,"+		
			" ASSET_INFO.AssetName as AssetName,"+
			" getItemName('CashBackType1',RECLAIM_INFO.CashBackType) as CashBackType,"+
			" getItemName('Currency',RECLAIM_INFO.FormerCurrency) as FormerCurrency,"+
			" getItemName('Currency',RECLAIM_INFO.ReclaimCurrency) as ReclaimCurrency,"+
			" RECLAIM_INFO.ReclaimSum as ReclaimSum,"+
			" RECLAIM_INFO.EnterAccountDate as EnterAccountDate,"+			
			" RECLAIM_INFO.ReclaimDate as ReclaimDate,"+
			" getUserName(RECLAIM_INFO.InputUserID) as InputUserName, " +	
			" getOrgName(RECLAIM_INFO.InputOrgID) as InputOrgName ,"+			
			" RECLAIM_INFO.InputDate as InputDate"+
			" from RECLAIM_INFO,ASSET_INFO " +
			" where RECLAIM_INFO.OBJECTTYPE = '"+sObjectType+"' "+
			" and RECLAIM_INFO.objectno = '"+sObjectNo+"' "+
			" and ASSET_INFO.SerialNo = RECLAIM_INFO.ObjectNo "+
			" order by RECLAIM_INFO.InputDate desc";
   
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "RECLAIM_INFO";	
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 
	//���ò��ɼ���
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo",false);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CashBackType,FormerCurrency,ReclaimCurrency,EnterAccountDate,ReclaimDate,InputUserName,InputDate","style={width:80px} ");  
	doTemp.setHTMLStyle("ReclaimSum,AssetName","style={width:100px} ");  
	doTemp.setUpdateable("CashBackType,FormerCurrency,ReclaimCurrency",false); 
	//���ö��뷽ʽ
	doTemp.setAlign("ReclaimSum","3");
	doTemp.setType("ReclaimSum","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("ReclaimSum","2");	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute(",AssetNo,AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //����DW��� 1:Grid 2:Freeform
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
			{"true","","Button","����","������ծ�ʲ����ּ�¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴��ծ�ʲ�������ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ծ�ʲ�������Ϣ","deleteRecord()",sResourcesPath},
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
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACashBookInfo.jsp?ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACashBookInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","right");
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
