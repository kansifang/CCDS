<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.7
		Tester:
		Content: �������Ŷ������
		Input Param:
			ObjectType����������
			ApplyType����������
			PhaseType���׶�����
			FlowNo�����̺�
			PhaseNo���׶κ�
			OccurType����������	
			OccurDate����������
		Output param:
		History Log: zywei 2005/07/28
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ŷ���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α�š�������ʽ����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
	//���������SQL���
	String sSql = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String[][] sHeaders = {
							{"SerialNo","��ˮ��"},		
							{"ChangeNo","�����"},	
							{"SystemName","ϵͳ����"}
						  };
	sSql = 	" select SerialNo,ChangeNo,SystemName,TempSaveFlag"+	
				" from Batch_Case where 1 = 2 ";	
	//ͨ��SQL����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);	
	//���ñ���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="Batch_Case";
	doTemp.setKey("SerialNo,ChangeNo", true);
	//���ñ�����
	doTemp.setRequired("ConfigNo,OneKey",true);
	doTemp.setVisible("SerialNo,ChangeNo,TempSaveFlag", false);
	//doTemp.setVisible("SerialNo,ChangeNo", false);
	//����������ѡ������
	if(sApplyType.equals("IndependentApply"))
		doTemp.setDDDWCode("OccurType","OccurType");	
	if(sApplyType.equals("DependentApply"))
		doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' and ItemNo <> '015' and IsInUse='1'");
	//���ñ��䱳��ɫ
	doTemp.setHTMLStyle("OccurType,OccurDate","style={background=\"#EEEEff\"} ");
	//�������ڸ�ʽ
	doTemp.setCheckFormat("OneKey","6");	
	//ע��,����HTMLStyle������ReadOnly������ReadOnly������
	doTemp.setHTMLStyle("InputDate"," style={width:80px}");
	doTemp.setReadOnly("InputOrgName,InputUserName,InputDate",true);
	doTemp.setDDDWSql("ConfigNo", "select CodeNo,CodeName from Code_Catalog where CodeNo like 'b%'");
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
		{"true","","Button","ȷ��","�������Ŷ���������һ��","doCreation()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ���������Ŷ������","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
		/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
		function doCreation()
		{
			sIsJGT = getItemValue(0,0,"isJGT");		
			sCreditAggreement = getItemValue(0,0,"CreditAggreement");		
			
			if(sIsJGT == "1" && sCreditAggreement.length == 0){
				alert("����ͨҵ����ѡ����Э��ţ�");
				return 
			}
			saveRecord();
		}
		/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
		function saveRecord()
		{
			//--added by wwhe 2009.06.10 for:У��������ҵ���Ƿ��ڶ�ȷ��䷶Χ��
			var sCreditAggreement = getItemValue(0,0,"CreditAggreement");
			var sBusinessType = getItemValue(0,0,"BusinessType");
			var sManageDepartFlag = getItemValue(0,0,"ManageDepartFlag");
			if(typeof(sCreditAggreement) != "undefined" && sCreditAggreement != "" ){
				var sReturnValue = RunMethod("PublicMethod","ExecuteSql","Select count(*) from code_library where codeno='CreditLineBusinessType' and ItemDescribe='"+sManageDepartFlag+"' and  ~ZKH~substr~ZKH~'"+sBusinessType+"'@1@4~YKH~=bankno  or bankno like '"+sBusinessType+"~BFH~' ~YKH~");
				if(sReturnValue ==0){
					alert("���Ŷ������δ�����ҵ��Ʒ�֣�������ѡ��ҵ��Ʒ��");
					return false;
				}
			}else{//added by bllou 20120426 û�й�����Ƚ�����ʾ
				if((typeof(sCreditAggreement) != "undefined" && sCreditAggreement.length==0)&&!confirm("û�й������Ŷ�ȣ�ȷ�ϼ�����")){//added by ymwu �޸�ԭ�ж���жϷ�ʽ ԭ��Ϊ�� "<%=sApplyType%>" == "DependentApply"
					return false;
				}
			}
			initSerialNo();
			as_save("myiframe0","");	
			AfterInsert();
		}
		/*~[added by wwhe 2009-06-08 for:Describe=��������¼�;InputParam=��;OutPutParam=��;]~*/
		function AfterInsert(){
			var sObjectType = "<%=sObjectType%>";
			var sApplyType = "<%=sApplyType%>";
			var sFlowNo = "<%=sFlowNo%>";
			var sPhaseNo = "<%=sPhaseNo%>";
			var sUserID = "<%=CurUser.UserID%>";
			var sOrgID = "<%=CurOrg.OrgID%>";
			var sSerialNo = getItemValue(0,0,"SerialNo");
			//��ԭ��SelectFlow���ж����̵ķ�ʽ��Ϊͨ��SelectFlow.jsp add by ymwu
			sFlowNo = PopPage("/Common/BusinessFlow/Apply/SelectFlow.jsp?OrgID="+sOrgID+"&ApplyType="+sApplyType,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			RunMethod("WorkFlowEngine","InitializeFlow",sObjectType+","+sSerialNo+","+sApplyType+","+sFlowNo+","+sPhaseNo+","+sUserID+","+sOrgID);	
			doReturn();
		}
		/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
		function doReturn(){
			var sSerialNo= getItemValue(0,0,"SerialNo");		
			//var sReportDate = getItemValue(0,0,"OneKey");		
			self.returnValue = sSerialNo+"@";
			self.close();
		}
		/*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
		function doCancel(){		
			top.returnValue = "_CANCEL_";
			top.close();
		}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼	
			setItemValue(0,0,"OneKey","<%=DateUtils.getRelativeMonth(DateUtils.getToday(),0,0)%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");	
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");	
			setItemValue(0,0,"InputDate","<%=DateUtils.getToday()%>");	
			setItemValue(0,0,"TempSaveFlag","1");
		}
    }
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "Batch_Case";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
		setItemValue(0,getRow(),"ChangeNo",sSerialNo);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();	
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��	
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>