<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong 2004.12.12
		Tester:
		Content: ��ծ�ʲ�������ط���̨��
		Input Param:
				ObjectType���������ͣ�ASSET_INFO��
				ObjectNo�������ţ��ʲ���ˮ�ţ�
		Output param:

		History Log: zywei 2005/09/07 �ؼ����		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�������ط���̨���б�"; // ��������ڱ��� <title> PG_TITLE </title>
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

	//��ȡҳ�����	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"ObjectType","��������"},
							{"ObjectNo","�ʲ����"},
							{"SerialNo","������ˮ��"},							
							{"AssetName","�ʲ�����"},
							{"Assettype","�ʲ�����"},
							{"AssettypeName","�ʲ�����"},
							{"OccurType","���÷�����ʽ"},
							{"OccurTypeName","���÷�����ʽ"},
							{"CostType","��������"},
							{"CostTypeName","��������"},
							{"CostSum","��������"},
							{"OccurDate","��������"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputDate","�Ǽ�����"}
						}; 
						
	//�ӵ�ծ�ʲ�������Ϣ��COST_INFO��ѡ��������Ϣ��¼
	sSql = 	" select COST_INFO.ObjectType as ObjectType,"+
			" COST_INFO.ObjectNo as ObjectNo,"+
			" COST_INFO.SerialNo as SerialNo,"+			
			" ASSET_INFO.AssetName as AssetName,"+
			" ASSET_INFO.Assettype as Assettype,"+
			" getItemName('PDAType',trim(ASSET_INFO.Assettype)) as AssettypeName,"+
			" COST_INFO.OccurType as OccurType,"+  
			" getItemName('OccurStyle',trim(COST_INFO.OccurType)) as OccurTypeName,"+
			" COST_INFO.CostType as CostType,"+
			" getItemName('FeeType',trim(COST_INFO.CostType)) as CostTypeName,"+
			" COST_INFO.CostSum as CostSum,"+
			" COST_INFO.OccurDate as OccurDate,"+
			" getUserName(COST_INFO.InputUserID) as InputUserName, " +	
			" getOrgName(COST_INFO.InputOrgID) as InputOrgName,"+			
			" COST_INFO.InputDate as InputDate"+
			" from COST_INFO,ASSET_INFO" +
			" where COST_INFO.ObjectType = '"+sObjectType+"' "+
			" and COST_INFO.ObjectNo = '"+sObjectNo+"' "+
			" and ASSET_INFO.SerialNo = COST_INFO.ObjectNo "+
			" order by COST_INFO.InputDate desc";
		
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "COST_INFO";	
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 
	//���ò��ɼ���
	doTemp.setVisible("ObjectType,ObjectNo,Assettype,OccurType,CostType,SerialNo",false);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("OccurDate,InputDate,InputUserName","style={width:80px} ");  
	doTemp.setHTMLStyle("CostSum,CostTypeName","style={width:80px} ");  
	doTemp.setHTMLStyle("AssettypeName,OccurTypeName"," style={width:100px} ");
	doTemp.setUpdateable("AssettypeName,OccurTypeName,CostTypeName",false); 
	//���ö��뷽ʽ
	doTemp.setAlign("CostSum","3");
	doTemp.setType("CostSum","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("CostSum","2");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ

	//��������¼�
	
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
			{"true","","Button","����","����","newRecord()",sResourcesPath},
			{"true","","Button","����","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACostInfoBookInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��÷�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACostInfoBookInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>	
		
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
