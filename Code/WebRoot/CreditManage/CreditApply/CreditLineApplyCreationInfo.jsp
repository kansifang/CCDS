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
		Output param:
		History Log: zywei 2005/07/28
					 zywei 2005/07/28 �����Ŷ������ҳ�浥������	
					 lpzhang 2009-8-26 for TJ
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
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
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
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CreditLineApplyCreationInfo";
	
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
	
	//���ñ���ʱ�����������ݱ�Ķ���
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+") + !WorkFlowEngine.InitializeCLInfo(#SerialNo,#BusinessType,#CustomerID,#CustomerName,#InputUserID,#InputOrgID)");
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
	var ChangeObject = "";
	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		initSerialNo();
		sObjectNo = getItemValue(0,0,"SerialNo");
		sOccurType = getItemValue(0,0,"OccurType");
		sBusinessType = getItemValue(0,0,"BusinessType");
		if(sOccurType == "100" || sOccurType == "090" )
		{
			if("3010" != sBusinessType && "3040" != sBusinessType && "3050" != sBusinessType && "3060" != sBusinessType)
			{
				alert("������ʽΪ��������ҵ��Ʒ��ֻ��Ϊ��˾/�����ۺ����š����ù�ͬ��/ũ���������ţ�");
				return;
			}
			sRelativeObjectType = getItemValue(0,0,"RelativeObjectType");
			sRelativeAgreement = getItemValue(0,0,"RelativeAgreement");
			RunMethod("BusinessManage","InsertRelative",sObjectNo+","+sRelativeObjectType+","+sRelativeAgreement+",APPLY_RELATIVE");	
		}
		//������������� 120��� ���ȱ���������Ϣ��Ȼ�����BackUpContract��������������Ϣ���ߺ�ͬ��Ϣ��ȡ���������Ϣ��
		if(sOccurType == "120")
		{
			sRelativeObjectType = getItemValue(0,0,"RelativeObjectType");
			sRelativeAgreement = getItemValue(0,0,"RelativeAgreement");
			sChangType = getItemValue(0,0,"ChangType");
			saveRecord("doReturn()");
			//�����ϵ��
			RunMethod("BusinessManage","InsertRelative",sObjectNo+","+sRelativeObjectType+","+sRelativeAgreement+",APPLY_RELATIVE");
			//���ù���BackUpContract ���ݱ����Ϣ����ʷ��
			RunMethod("BusinessManage","BackUpContract",sRelativeObjectType+","+sObjectNo+","+sRelativeAgreement+","+sBusinessType+","+sChangType+",APPLY_RELATIVE");
		}
		//����������Ͳ���120�������ֻ���ñ���������Ϣ��
		else
		{
			saveRecord("doReturn()");
		}
	}
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		top.returnValue = sObjectNo;
		top.close();
	}
	//�����򲻿���
	function setFieldDisabled(sField)
	{
	  setItemDisabled(0,0,sField,true);
      getASObject(0,0,sField).style.background ="#efefef";
      setItemValue(0,0,sField,"");
	}
	
	//�ָ���Ϊ����
	function setFieldNotDisabled(sField)
	{ 
	   setItemDisabled(0,0,sField,false);
	  // getASObject(0,0,sField).style.background ="WHITE";
	  // setItemValue(0,0,sField,"");
	}
	//���÷�����ʽ
	function setCLOccurType()
	{
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
		sOccurType = getItemValue(0,0,"OccurType");
		if(sOccurType == "100" || sOccurType == "090" || sOccurType == "120")
		{
			setItemValue(0,0,"BusinessType","");
			setItemValue(0,0,"BusinessTypeName","");
			setItemRequired(0,0,"RelativeAgreement",true);
		}else{
			setItemRequired(0,0,"RelativeAgreement",false);
		}
		
	}
	
		
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{			
		sCustomerType = getItemValue(0,0,"CustomerType");
		sOccurType = getItemValue(0,0,"OccurType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert("����ѡ��ͻ�����!");
			return;
		}
		//����ҵ�����Ȩ�Ŀͻ���Ϣ
		if(sCustomerType == "0107")//ͬҵ
		{
			sParaString = "UserID"+","+"<%=CurUser.UserID%>";
			setObjectValue("SelectApplyCustomer7",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		}else if(sCustomerType == "04" || sCustomerType == "05")
		{
			sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+sCustomerType;
			setObjectValue("SelectApplyCustomer6",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		}
		else
		{
			sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+sCustomerType;
			setObjectValue("SelectApplyCustomer3",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		}
		//�������������120������򵯳�ѡ�������󡢱�����͵�ҳ�� add by wangdw 2012-08-31
		if(sOccurType == "120"){
		sReturnValue =PopPage("/CreditManage/CreditApply/AssembleBusinessDialogChangeOther.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
		if(typeof(sReturnValue)!="undefined" && sReturnValue.length!=0 && sReturnValue != '_none_')
				{
					sss2 = sReturnValue.split("@");
					ChangeObject = sss2[0];
					setItemValue(0,getRow(),"ChangType",sss2[1]);
					if(ChangeObject == "01")
					{
						setItemValue(0,getRow(),"RelativeObjectType","ApplyChange");	
					}else if(ChangeObject == "02")
					{
						setItemValue(0,getRow(),"RelativeObjectType","ContractChange");	
					}
				}
		}
		
	}
	
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectBusinessType(sType)
	{	
		if(sType == "CL") //���Ŷ�ȵ�ҵ��Ʒ��
		{
			sCustomerType = getItemValue(0,0,"CustomerType");
			sOccurType = getItemValue(0,0,"OccurType");
			if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
			{
				alert("����ѡ��ͻ�����!");
				return;
			}
			if(sCustomerType == "0107")
			{
				setItemValue(0,0,"BusinessType","3015");
				setItemValue(0,0,"BusinessTypeName","ͬҵ���");
				alert("ͬҵ�ͻ���ҵ��Ʒ��ֻ����ͬҵ��ȣ�");
				
			}else if(sCustomerType == "03")
			{
				setItemValue(0,0,"BusinessType","3040");
				setItemValue(0,0,"BusinessTypeName","�����ۺ����Ŷ��");
				alert("���˿ͻ���ҵ��Ʒ��ֻ���Ǹ����ۺ����Ŷ�ȣ�");
				
			}else if(sCustomerType == "04")
			{
				setItemValue(0,0,"BusinessType","3050");
				setItemValue(0,0,"BusinessTypeName","ũ������С�����Ŷ��");
				alert("ũ������С�飬ҵ��Ʒ��ֻ����ũ������С�����Ŷ�ȣ�");
				
			}else if(sCustomerType == "05")
			{
				setItemValue(0,0,"BusinessType","3060");
				setItemValue(0,0,"BusinessTypeName","���ù�ͬ�����Ŷ��");
				alert("���ù�ͬ�壬ҵ��Ʒ��ֻ�������ù�ͬ�����Ŷ�ȣ�");
				
			}else if(sCustomerType == "01" && (sOccurType == "100" || sOccurType == "090" ))
			{
				setItemValue(0,0,"BusinessType","3010");
				setItemValue(0,0,"BusinessTypeName","��˾�ۺ����Ŷ��");
				alert("��˾�ͻ���ֻ�ܶԹ�˾�ۺ����Ŷ�Ƚ��е�����");
				
			}else
			{
				setObjectValue("SelectEntEDBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
			}		
		}
	}
	
	//����ҵ��Ʒ��
	function setCLBusinessType()
	{
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
		sCustomerType = getItemValue(0,0,"CustomerType");
		
		    if(sCustomerType == "0107")
			{
				setItemValue(0,0,"BusinessType","3015");
				setItemValue(0,0,"BusinessTypeName","ͬҵ���");
				
			}else if(sCustomerType == "01")
			{
				setItemValue(0,0,"BusinessType","3010");
				setItemValue(0,0,"BusinessTypeName","��˾�ۺ����Ŷ��");
				
			}else if(sCustomerType == "03")
			{
				setItemValue(0,0,"BusinessType","3040");
				setItemValue(0,0,"BusinessTypeName","�����ۺ����Ŷ��");
				
			}else if(sCustomerType == "04")
			{
				setItemValue(0,0,"BusinessType","3050");
				setItemValue(0,0,"BusinessTypeName","ũ������С�����Ŷ��");
				
			}else if(sCustomerType == "05")
			{
				setItemValue(0,0,"BusinessType","3060");
				setItemValue(0,0,"BusinessTypeName","���ù�ͬ�����Ŷ��");
			}		
		
	}
	
	//�������������Ŷ��
	function selectCLBusiness(){
	    sCustomerID = getItemValue(0,0,"CustomerID");
	    sOccurType = getItemValue(0,0,"OccurType");
	    sBusinessType = getItemValue(0,0,"BusinessType");
	    sRelativeObjectType = getItemValue(0,0,"RelativeObjectType");   	//�������
	    if(sOccurType != "100" && sOccurType != "090"&& sOccurType != "120")
		{
			alert("������ʽ���Ƕ�Ȼ������������Ҫ¼�������Ϣ��");
			return;
		}
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//����ѡ�����ſͻ���
			return;
		}
		if(sOccurType == "090"){	
			setObjectValue("SelectLineReApply","CustomerID,"+sCustomerID+","+"OperateUserID"+","+"<%=CurUser.UserID%>","@RelativeAgreement@0",0,0,"");			
			setItemValue(0,0,"RelativeObjectType","BusinessReApply");	
		}
		//������������120�����ʱ��  add by wangdw 2012-09-06
		else if (sOccurType == "120"){
			if(sRelativeObjectType == "ApplyChange")
				{
					//������
					sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerID"+","+sCustomerID+","+"BusinessType"+","+sBusinessType;
					setObjectValue("selectCLBusinessApplyChange",sParaString,"@RelativeAgreement@0",0,0,"");	
				}
			if(sRelativeObjectType == "ContractChange")
				{
					//��ͬ���
					sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerID"+","+sCustomerID+","+"BusinessType"+","+sBusinessType+","+"CurDate"+",<%=StringFunction.getToday()%>";
					setObjectValue("selectCLBusinessContractChange",sParaString,"@RelativeAgreement@0",0,0,"");	
				}
		}
		else{
			sBusinessType = getItemValue(0,0,"BusinessType");
			sParaString = "CustomerID"+","+sCustomerID+","+"BusinessType"+","+sBusinessType;
			setObjectValue("selectCLBusiness",sParaString,"@RelativeAgreement@0",0,0,"");			
			setItemValue(0,0,"RelativeObjectType","CLBusinessChange");	
		}	
		
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
			setItemValue(0,0,"CustomerType","01");
			//��Ʒ��������
			setItemValue(0,0,"BusinessTypeName","��˾�ۺ����Ŷ��");
			//��Ʒ����
			setItemValue(0,0,"BusinessType","3010");	
			if(<%=CurUser.hasRole("0F8")%>){
				setItemValue(0,0,"CustomerType","0107");
				setItemValue(0,0,"BusinessTypeName","ͬҵ���");
				setItemValue(0,0,"BusinessType","3015");
			}
			//��������
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			//��������
			setItemValue(0,0,"ApplyType","<%=sApplyType%>");
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