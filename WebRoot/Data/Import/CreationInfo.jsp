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
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sOccurType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurType"));
	String sOccurDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurDate"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sOccurType == null) sOccurType = "";	
	if(sOccurDate == null) sOccurDate = "";	
	
	//���������SQL���
	String sSql = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String[][] sHeaders = {
							{"ConfigNo","��������"},							
							{"OneKey","��������"}
						  };
	sSql = 	" select ConfigNo,OneKey"+	
				" from Batch_Import where 1 = 2 ";	
	//ͨ��SQL����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);	
	//���ñ���
	doTemp.setHeader(sHeaders);
	
	//���ñ�����
	doTemp.setRequired("ConfigNo,OneKey",true);
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
		{"true","","Button","��һ��","�������Ŷ���������һ��","doReturn()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ���������Ŷ������","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
		/*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
		function doCancel(){		
			top.returnValue = "_CANCEL_";
			top.close();
		}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>	
	
	/*~[Describe=��һ��;InputParam=��;OutPutParam=��;]~*/
	function nextStep()
	{
		//��������
		sOccurDate = getItemValue(0,getRow(),"OneKey");		
		if (typeof(sOccurDate) == "undefined" || sOccurDate.length == 0)
		{
			alert(getBusinessMessage('507'));//��ѡ�������ڣ�
			return;
		}else
		{
			sToday = "<%=StringFunction.getToday()%>";//��ǰ����	
			if(sOccurDate > sToday)
			{		    
				alert(getBusinessMessage('508'));//�������ڱ������ڻ���ڵ�ǰ���ڣ�
				return;		    
			}
		}
		OpenPage("/CreditManage/CreditApply/CreditApplyCreationInfo2.jsp?ObjectType=<%=sObjectType%>&ApplyType=<%=sApplyType%>&PhaseType=<%=sPhaseType%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>&OccurType="+sOccurType+"&OccurDate="+sOccurDate,"_self","");
    }
    		
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼			
			sOccurType = "<%=sOccurType%>";
			sOccurDate = "<%=sOccurDate%>";
			setItemValue(0,0,"ConfigNo","b20140519000001");
			setItemValue(0,0,"OneKey","<%=DateUtils.getRelativeMonth(DateUtils.getToday(),0,0)%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");	
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");	
			setItemValue(0,0,"InputDate","<%=DateUtils.getToday()%>");			
		}
    }
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		var sConfigNo= getItemValue(0,0,"ConfigNo");		
		var sReportDate = getItemValue(0,0,"OneKey");		
		self.returnValue = sConfigNo+"@"+sReportDate;
		self.close();
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