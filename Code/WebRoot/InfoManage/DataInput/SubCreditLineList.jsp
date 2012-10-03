<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2006/03/31
		Tester:
		Content: ���Ŷ�ȷ����б�ҳ��
		Input Param:
			ParentLineID����ȱ��
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	
	//���ҳ�����	
	String sParentLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentLineID"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	if(sObjectNo == null) sObjectNo = "" ;
	if(sParentLineID == null) sParentLineID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//��ʾ����				
	String[][] sHeaders = {		
						{"CustomerID","�ͻ����"},
						{"CustomerName","�ͻ�����"},
						{"BusinessTypeName","ҵ��Ʒ��"},
						{"RotativeName","�Ƿ�ѭ��"},
						{"BailRatio","��ͱ�֤�����"},		
						{"LineSum1","�����޶�"},
						{"LineSum2","�����޶�"}
					};
	
		sSql =  " select LineID,CustomerID,CustomerName,BusinessType, "+
				" getBusinessName(BusinessType) as BusinessTypeName, "+
				" Rotative,getItemName('YesNo',Rotative) as RotativeName, "+
				" BailRatio,LineSum1,LineSum2 "+
				" from CL_INFO "+
				" Where ParentLineID = '"+sParentLineID+"' ";	
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID,",true);		
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("LineID,BusinessType,Rotative,RotativeName,BailRatio,LineSum1",false);
	//���ø�ʽ
	doTemp.setType("LineSum1,LineSum2,BailRatio","Number");
	doTemp.setUnit("LineSum1,LineSum2","(Ԫ)");
	doTemp.setUnit("BailRatio","(%)");
	
			
	//����Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	dwTemp.setEvent("AfterDelete","!CreditLine.DeleteCLLimitationRelative(#LineID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"false","","Button","��������","����/�鿴/�޸���������","LimitationView()",sResourcesPath}
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
		OpenPage("/CreditManage/CreditLine/SubCreditLineInfo.jsp?ParentLineID=<%=sParentLineID%>","_self","");
	}
	
	/*~[Describe=����/�鿴/�޸���������;InputParam=��;OutPutParam=��;]~*/
	function LimitationView()
	{
		sSubLineID = getItemValue(0,getRow(),"LineID");
		if (typeof(sSubLineID)=="undefined" || sSubLineID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("CreidtLineLimitationView","/CreditManage/CreditLine/CreidtLineLimitationView.jsp","SubLineID="+sSubLineID,"","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sLineID = getItemValue(0,getRow(),"LineID");
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSubLineID = getItemValue(0,getRow(),"LineID");
		if (typeof(sSubLineID) == "undefined" || sSubLineID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/CreditManage/CreditLine/SubCreditLineInfo.jsp?ParentLineID=<%=sParentLineID%>&SubLineID="+sSubLineID,"_self","");
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
