<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/08/01
		Tester:
		Describe: 	ũ����ɫ��Ϣ
		Input Param:
			--CustomerID����ǰ�ͻ����
			--EditRight:Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ũ����ɫ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletNo = "FarmerTraitInfo";
	//�������������ͻ�����
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//���ҳ�����	,��ˮ��
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sEditRight == null) sEditRight = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//����������(Ԫ)��Χ
	//doTemp.appendHTMLStyle("MONTHLYWAGES"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //--����DW��� 1:Grid 2:Freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath}
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
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;	
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
	
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		//1��У�� ����������ѡ��Ϊ"ũ��"����Ϊ������
		sIndRPRType = getItemValue(0,getRow(),"IndRPRType");//��������
		sVillageCode = getItemValue(0,getRow(),"VillageCode");//ũ�����ڵ�
		if(sIndRPRType == '010')
		{
			if (typeof(sVillageCode) == "undefined" || sVillageCode == "" )
			{
				alert("����������ѡ��Ϊũ��ʱ,ũ�����ڵز���Ϊ��!"); 
				return false;	
			}
		}
		
		//2:У�� ��Ϊ���û�ʱ�估����֤��֤���ڲ�Ӧ���ڵ�ǰ����
		sFCreditedDate = getItemValue(0,getRow(),"FCreditedDate");
		sFLoanDate = getItemValue(0,getRow(),"FLoanDate");
		sToDay = "<%=StringFunction.getToday()%>";
		if(sFCreditedDate>sToDay){
			alert("��Ϊ���û�ʱ�䲻�����ڵ�ǰ����!");
			return false;
		}
		if(sFLoanDate>sToDay){
			alert("����֤��֤���ڲ�Ӧ���ڵ�ǰ����!");
			return false;
		}
		return true;
	}
	
	/*~[Describe=����ʡ�ݡ�ֱϽ�С�������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getVillageCode(flag)
	{
		var sVillageCode = getItemValue(0,getRow(),"VillageCode");
		//��������м������������ʾ
		sVillageInfo = PopComp("VillageVFrame","/Common/ToolsA/VillageVFrame.jsp","Village="+sVillageCode,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		if(sVillageInfo == "NO")
		{
			setItemValue(0,getRow(),"VillageCode","");
			setItemValue(0,getRow(),"VillageName","");
		}else if(typeof(sVillageInfo) != "undefined" && sVillageInfo != "")
		{
			sVillageInfo = sVillageInfo.split('@');
			sVillageCode = sVillageInfo[0];//-- ��������
			sVillageName = sVillageInfo[1];//--���������
			setItemValue(0,getRow(),"VillageCode",sVillageCode);
			setItemValue(0,getRow(),"VillageName",sVillageName);					
		}
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
