<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu 20100329
		Tester:
		Content: ����������������ҵ����Ϣ
		Input Param:		
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������������ҵ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sCreditLineID = DataConvert.toRealString(iPostChange,CurComp.getParameter("ParentLineID"));
	if(sCreditLineID == null) sCreditLineID= "";
	if(sObjectNo == null) sObjectNo = "";	
	if(sCustomerID == null) sCustomerID = "";	
	String sSql = "select CustomerType,CustomerName from Customer_info where customerID = '"+sCustomerID+"'";
	String sCustomerType = "";
	String sCustomerName = "";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sCustomerType = rs.getString("CustomerType");
		sCustomerName = rs.getString("CustomerName");
	}
	rs.getStatement().close();
	if (sCustomerType == null) sCustomerType = "";	
	if (sCustomerName == null) sCustomerName = "";
	if(sCustomerType.substring(0,2).equals("01")){
		sCustomerType = "01";
	}
	else if(sCustomerType.substring(0,2).equals("03")){
		sCustomerType = "03";
	}else if(sCustomerType.substring(0,2).equals("05")){
		sCustomerType = "05";
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CreditLineApplyCreation";
	
	//����ģ�����������ݶ���	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//���ñ��䱳��ɫ
	doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	doTemp.appendHTMLStyle("CustomerType"," onChange=\"javascript:parent.setCLBusinessType()\" ");
	doTemp.appendHTMLStyle("OccurType"," onChange=\"javascript:parent.setCLOccurType()\" ");
	if(CurUser.hasRole("0F8")){
		doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='OccurType' and ItemNo='010' order by SortNo");
		doTemp.setDDDWSql("CustomerType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='CustomerType' and ItemNo ='0107' and IsInUse='1' order by SortNo");
	}
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
			{"true","","Button","ȷ��","ȷ���������Ŷ������","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ���������Ŷ������","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{		
		setItemValue(0,0,"ContractFlag","2");//��ռ�ö��
		as_save("myiframe0",sPostEvents);		
	}
		   
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		initSerialNo();
		sObjectNo = getItemValue(0,0,"SerialNo");
		sOccurType = getItemValue(0,0,"OccurType");
		sBusinessType = getItemValue(0,0,"BusinessType");
		if(sOccurType == "100")
		{
			if("3010" != sBusinessType && "3040" != sBusinessType && "3050" != sBusinessType && "3060" != sBusinessType)
			{
				alert("������ʽΪ������ҵ��Ʒ��ֻ��Ϊ��˾/�����ۺ����š����ù�ͬ��/ũ���������ţ�");
				return;
			}
			sRelativeObjectType = getItemValue(0,0,"RelativeObjectType");
			sRelativeAgreement = getItemValue(0,0,"RelativeAgreement");
			RunMethod("BusinessManage","InsertRelative",sObjectNo+","+sRelativeObjectType+","+sRelativeAgreement+",APPLY_RELATIVE");	
		}
		saveRecord("doReturn()");
	}
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		top.returnValue = sObjectNo;
		top.close();
	}

	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectBusinessType(sType)
	{	
		setObjectValue("SelectCLABusiness","ParentLineID,<%=sCreditLineID%>","@BusinessType@0@BusinessTypeName@1",0,0,"");		
	}
					
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼			
			//��������
			setItemValue(0,0,"OccurType","010");
			//�ͻ�����
			setItemValue(0,0,"CustomerType","<%=sCustomerType%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			//��������
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"BAAgreement","<%=sObjectNo%>");
			setItemValue(0,0,"ApplyType","DependentApply");
			//�������
			setItemValue(0,0,"OperateOrgID","<%=CurUser.OrgID%>");
			//������
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			//��������
			setItemValue(0,0,"OperateDate","<%=StringFunction.getToday()%>");
			//�Ǽǻ���
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			//�Ǽ���
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			//�Ǽ�����			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//��������
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//�ݴ��־
			setItemValue(0,0,"TempSaveFlag","1");//�Ƿ��־��1���ǣ�2����
			//�ͻ�����Ĭ��Ϊ��˾�ͻ�
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_APPLY";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "BA";//ǰ׺
								
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
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>