
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2005/08/29
		Tester:
		Content: ��Ȩ�������Ϣҳ��
		Input Param:
			PolicyID����Ȩ����ID
			FlowNo�����̺�
			PhaseNo���׶κ�
			AuthID����Ȩ��ID
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","300");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sPolicyID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PolicyID"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sAuthID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthID"));
	//����ֵת��Ϊ���ַ���
	if(sPolicyID == null) sPolicyID = "";
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sAuthID == null) sAuthID = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//��ȡ��������
	String sFlowName = Sqlca.getString("select FlowName from FLOW_CATALOG where FlowNo = '"+sFlowNo+"'");
	String sPhaseName = Sqlca.getString("select PhaseName from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'");
	//����ֵת��Ϊ���ַ���
	if(sFlowName == null) sFlowName = "";
	if(sPhaseName == null) sPhaseName = "";
	
	String[][] sHeaders = {							
							{"PolicyName","��Ȩ����"},
							{"SortNo","�����"},
							{"FlowName","����"},
							{"PhaseName","�׶�"},							
							{"OrgName","����"},							
							{"ProductName","��Ʒ"},							
							{"GuarantyTypeName","������ʽ"},
							{"EffDate","��������"},
							{"EffStatus","��Ч״̬"},
							{"BizBalanceCeiling","�������ʽ�����ޣ�Ԫ��"},
							{"BizExposureCeiling","�������ʳ�����Ȩ���ޣ�Ԫ��"},
							{"CustBalanceCeiling","�������������Ȩ���ޣ�Ԫ��"},
							{"CustExposureCeilin","��������������Ȩ���ޣ�Ԫ��"},
							{"InterestRateFloor","�����������ޣ�%��"}
						};
	String sSql = 	" select AuthID,PolicyID, "+
					" SortNo,FlowNo,getFlowName(FlowNo) as FlowName,PhaseNo, "+
					" getPhaseName(FlowNo,PhaseNo) as PhaseName, "+
					" OrgID,getOrgName(OrgID) as OrgName,ProductID, "+
					" getBusinessName(ProductID) as ProductName,GuarantyType, "+
					" getItemName('VouchType',GuarantyType) as GuarantyTypeName, "+
					" EffDate,EffStatus,BizBalanceCeiling,BizExposureCeiling, "+
					" CustBalanceCeiling,CustExposureCeilin,InterestRateFloor, "+
					" InputUser,InputTime, "+
					" UpdateUser,UpdateTime "+
					" from AA_AUTHPOINT "+
					" where AuthID = '"+sAuthID+"' "+
					" and PolicyID = '"+sPolicyID+"' ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "AA_AUTHPOINT";
	doTemp.setKey("AuthID",true);	
	doTemp.setHeader(sHeaders);
	//���ò��ɼ�
	doTemp.setVisible("AuthID,PolicyID,FlowNo,PhaseNo,OrgLevel,OrgID,ProductID,GuarantyType,InputUser,InputTime,UpdateUser,UpdateTime",false);
	//���������򣨴��룩
	//add by hxd in 2005/11/29
	doTemp.setDDDWCode("EffStatus","EffStatus");
	//doTemp.setHRadioCode("EffStatus","EffStatus");
	//doTemp.setVRadioCode("EffStatus","EffStatus");
	//doTemp.setPopCode("EffStatus","EffStatus");
		
	//����������SQl��
	//doTemp.setDDDWSql("GuarantyCategory","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and length(ItemNo)=3 and ItemNo <>'000' and IsInUse = '1' ");
	//���ñ�����
	doTemp.setRequired("PolicyName,EffDate,EffStatus",true);
	
	//���������������ʽ
	doTemp.setAlign("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin,InterestRateFloor","3");
	doTemp.setType("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin,InterestRateFloor","Number");
	doTemp.setCheckFormat("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin","2");
	doTemp.setCheckFormat("EffDate","3");
	doTemp.setHTMLStyle("OrgName","style={width:250px}");
	//���ò��ɸ���
	doTemp.setUpdateable("PolicyName,FlowName,PhaseName,OrgName,ProductName,GuarantyTypeName",false);
	//����ֻ��
	doTemp.setReadOnly("PolicyName,FlowName,PhaseName",true);
	//���õ���ʽ����ѡ��ģʽ
	doTemp.setUnit("PolicyName","<input class=inputdate type=button value=\"...\" onClick=parent.getPolicyName()>");
	//doTemp.setUnit("FlowName","<input class=inputdate type=button value=\"...\" onClick=parent.getFlowName()>");
	//doTemp.setUnit("PhaseName","<input class=inputdate type=button value=\"...\" onClick=parent.getPhaseName()>");
	doTemp.setUnit("OrgName","<input class=inputdate type=button value=\"...\" onClick=parent.getOrgName()>");
	doTemp.setUnit("ProductName","<input class=inputdate type=button value=\"...\" onClick=parent.getProductName()>");
	doTemp.setUnit("GuarantyTypeName","<input class=inputdate type=button value=\"...\" onClick=parent.getGuarantyTypeName()>");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","����","����","testAuthPoint()",sResourcesPath},
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
	function saveRecord()
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0");
		
	}	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/Common/Configurator/AAManage/AuthPointSettingList.jsp?PolicyID=<%=sPolicyID%>","_self","");
	}
	
	function testAuthPoint(){
		//��Ȩ��ID   
	    sAuthID = getItemValue(0,getRow(),"AuthID");			
		if (typeof(sAuthID) == "undefined" || sAuthID.length == 0)
		{
			alert(getBusinessMessage('001'));//���ȱ���������Ȩ��Ϣ��Ȼ����ܽ��в��ԣ�
			return;
		}
		popComp("TestAuthPoint","/Common/Configurator/AAManage/AAPointTest.jsp","AuthID=<%=sAuthID%>&PolicyNo=<%=sPolicyID%>","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
		setItemValue(0,0,"InputTime",sNow);
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sNow);
	}	

	/*~[Describe=������Ȩ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getPolicyName(){
		sToday = "<%=StringFunction.getToday()%>";	
		sParaString = "Today,"+sToday;
		setObjectValue("SelectPolicy",sParaString,"@PolicyID@0@PolicyName@1",0,0,"");
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getFlowName(){
		setObjectValue("SelectFlow","","@FlowNo@0@FlowName@1",0,0,"");
	}
	
	/*~[Describe=�����׶�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getPhaseName(){
		//������̺�
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sFlowNo) == "undefined" || sFlowNo == "")
		{
			alert(getBusinessMessage('002'));//����ѡ��׶�֮ǰ��ѡ�����̣�
			return;
		}
		sParaString = "FlowNo"+","+sFlowNo;
		setObjectValue("SelectPhase",sParaString,"@PhaseNo@0@PhaseName@1",0,0,"");
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getOrgName(){
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
			
	/*~[Describe=������Ʒѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getProductName(){
		setObjectValue("SelectAllBusinessType","","@ProductID@0@ProductName@1",0,0,"");
	}
	
	/*~[Describe=����������ʽѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getGuarantyTypeName(){
		sParaString = "CodeNo"+",VouchType";		
		setObjectValue("SelectCode",sParaString,"@GuarantyType@0@GuarantyTypeName@1",0,0,"");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"FlowNo","<%=sFlowNo%>");
			setItemValue(0,0,"FlowName","<%=sFlowName%>");
			setItemValue(0,0,"PhaseNo","<%=sPhaseNo%>");
			setItemValue(0,0,"PhaseName","<%=sPhaseName%>");
			setItemValue(0,0,"PolicyID","<%=sPolicyID%>");
		}		
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "AA_AUTHPOINT";//����
		var sColumnName = "AuthID";//�ֶ���
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
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	OpenPage("/Common/Configurator/AAManage/ExceptionSettingList.jsp","DetailFrame","");
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
