<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2010/02/01
		Tester:
		Content: ��������������
		Input Param:
                CustomerID���ͻ����
                SerialNo����Ϣ��ˮ��
                EditRight��Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
                ReportDate:�����·�
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sSql = "";//--���sql���
	ASResultSet rs = null;//-- ��Ž����
	String sCustomerName = "",sSex = "",sCertID = "";
	String sBirthday = "",sFamilyAdd = "",sMobileTelephone = "";
	String sWorkCorp = "",sManageAdd = "",sRelaCustomerName = "";
	String sRelativeID = "",sManageArea = "",sRelaCustomerID = "";
	String sPermitID = "";
	//������������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";
	//���ҳ�������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sEditRight = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sEditRight == null) sEditRight = "";
	String sAssessFormType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssessFormType"));
	if(sAssessFormType == null) sAssessFormType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//��ȡ�ͻ������Ϣ
	if("03".equals(sCustomerType))//���˿ͻ�
	{
		sSql = "select FullName,Sex,CertID,Birthday,FamilyAdd,MobileTelephone,WorkCorp "+
			" from IND_INFO "+
			" where CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			 sCustomerName = rs.getString("FullName");
			 sSex = rs.getString("Sex");
			 sCertID = rs.getString("CertID");
			 sBirthday = rs.getString("Birthday");
			 sFamilyAdd = rs.getString("FamilyAdd");
			 sMobileTelephone = rs.getString("MobileTelephone");
			 sWorkCorp = rs.getString("WorkCorp");
		}
		rs.getStatement().close();
	}else if("0501".equals(sCustomerType))//���ù�ͬ��
	{
		sSql = "select CustomerName "+
			" from CUSTOMER_INFO "+
			" where CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			 sCustomerName = rs.getString("CustomerName");
		}
		rs.getStatement().close();
	}else{
		sRelaCustomerID = sCustomerID;
		//ȡ��˾�ͻ���Ϣ
		sSql = "select EnterpriseName,OfficeAdd,MostBusiness,LicenseNo "+
			" from ENT_INFO "+
			" where CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sRelaCustomerName = rs.getString("EnterpriseName");
			 sManageAdd = rs.getString("OfficeAdd");
			 sManageArea = rs.getString("MostBusiness");
			 sPermitID = rs.getString("LicenseNo");
		}
		rs.getStatement().close();
		//ȡ������������Ϣ
		sSql = "select RelativeID,CustomerName,CertID,Sex,Birthday,FamilyAdd,Telephone "+
		" from CUSTOMER_RELATIVE "+
		" where RelationShip='0100' and CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			 sCustomerName = rs.getString("CustomerName");
			 sRelativeID = rs.getString("RelativeID");
			 sCertID = rs.getString("CertID");
			 sSex = rs.getString("Sex");
			 sBirthday = rs.getString("Birthday");
			 sFamilyAdd = rs.getString("FamilyAdd");
			 sMobileTelephone = rs.getString("Telephone");
			 if(sMobileTelephone == null) sMobileTelephone = "";
			 if(sFamilyAdd == null) sFamilyAdd = "";
		}
		rs.getStatement().close();
	}
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AssessFormInfo1";
	if("".equals(sAssessFormType))
	{
		if("0501".equals(sCustomerType))//���ù�ͬ��
		{
			sAssessFormType = "030";
		}else//��˾�ͻ�
		{
			sAssessFormType = "010";
		}
	}
	//�������õȼ�����ģ��ȷ��ģ������
	if(sAssessFormType.equals("010"))
	{
		sTempletNo = "AssessFormInfo1";
	}else if(sAssessFormType.equals("020")){
		sTempletNo = "AssessFormInfo2";
	}else if(sAssessFormType.equals("030")){
		sTempletNo = "AssessFormInfo3";
	}
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//���ÿ��޸�
	if("03".equals(sCustomerType) && "010".equals(sAssessFormType))
	{
		doTemp.setReadOnly("RelaCustomerName,ManageAdd",false);
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform	
	if(sEditRight.equals("02"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		{"false","","Button","����","����","getAssessScore()",sResourcesPath},
		{(sEditRight.equals("01")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
		if("010".equals(sAssessFormType) && sEditRight.equals("01")){
			sButtons[0][0] = "true";
		}
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
			bIsInsert = false;
		}

		beforeUpdate();
		
		sAssessFormType  = "<%=sAssessFormType%>";
		sCustomerType = "<%=sCustomerType%>"
		if(sAssessFormType != "030"){
			sAssessLevel = getItemValue(0,getRow(),"AssessLevel");
			sCustomerID = "<%=sCustomerID%>";
			if(sCustomerType.substring(0,2) == "03"){
				sReturn = RunMethod("CustomerManage","UpdateAssessLevel",sAssessLevel+","+sCustomerID);
				if(sReturn != 1.0)
					return;
			}	
		}
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/Common/Evaluate/AssessformList.jsp","_self","");
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{		
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{	
		if("<%=sAssessFormType%>" == "010")
		getAssessScore();
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{		
		return true;
	}
	
	/*~[Describe=��ñ���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function getAssessRate(pItemNum1,pItemNum2,pRate)
	{		
		sItemNum1=getItemValue(0,getRow(),pItemNum1);
		sItemNum2=getItemValue(0,getRow(),pItemNum2);
		if(typeof(sItemNum1)!="undefined" && sItemNum1.length!=0 && typeof(sItemNum2)!="undefined" && sItemNum2.length!=0 && sItemNum1!=0)
		{
			setItemValue(0,0,pRate,roundOff(sItemNum2*100/sItemNum1,2));
		}
	}
	
	function getAssessRate2(){
		sItemNum1=getItemValue(0,getRow(),"AssessNum7");
		sItemNum2=getItemValue(0,getRow(),"AssessNum8");
		sItemNum3=getItemValue(0,getRow(),"AssessNum1");
		sItemTotalNum = 0;
		if(typeof(sItemNum1)!="undefined" && typeof(sItemNum2)!="undefined" && typeof(sItemNum3)!="undefined" )
		{
			sItemTotalNum = parseInt(sItemNum1)+parseInt(sItemNum2)+parseInt(sItemNum3);
		}		
		sItemNum4=getItemValue(0,getRow(),"AssessNum9");//���û���
		sItemNum5=getItemValue(0,getRow(),"AssessNum2");//�����̻���
		if(sItemTotalNum != 0 && typeof(sItemNum4)!="undefined" ){
			setItemValue(0,0,"AssessRate4",roundOff(sItemNum4*100/sItemTotalNum,2));
		}
		if(sItemTotalNum != 0 && typeof(sItemNum5)!="undefined" ){
			setItemValue(0,0,"AssessRate1",roundOff(sItemNum5*100/sItemTotalNum,2));
		}
	}

	/*~[Describe=��ñ���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function getAssessRate1(pItemNum1,pItemNum2,pItemNum3,pRate)
	{		
		sItemNum1=getItemValue(0,getRow(),pItemNum1);
		sItemNum2=getItemValue(0,getRow(),pItemNum2);
		sItemNum3=getItemValue(0,getRow(),pItemNum3);		
		if(typeof(sItemNum1)!="undefined" && sItemNum1.length!=0 && typeof(sItemNum2)!="undefined" && sItemNum2.length!=0 && sItemNum1!=0&& typeof(sItemNum3)!="undefined" && sItemNum3.length!=0 && sItemNum3!=0)
		{
			setItemValue(0,0,pRate,roundOff(sItemNum3*100/(parseInt(sItemNum1)+parseInt(sItemNum2)+parseInt(sItemNum3)),2));
		}
	}
	
	/*~[Describe=�������������÷�;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function getAssessScore()
	{		
		sAssessItem1 = parseInt(getItemValue(0,getRow(),"AssessItem1"));
		sAssessItem2 = parseInt(getItemValue(0,getRow(),"AssessItem2"));
		sAssessItem3 = parseInt(getItemValue(0,getRow(),"AssessItem3"));
		sAssessItem4 = parseInt(getItemValue(0,getRow(),"AssessItem4"));
		sAssessItem5 = parseInt(getItemValue(0,getRow(),"AssessItem5"));
		sAssessItem6 = parseInt(getItemValue(0,getRow(),"AssessItem6"));
		sAssessItem7 = parseInt(getItemValue(0,getRow(),"AssessItem7"));
		sAssessItem8 = parseInt(getItemValue(0,getRow(),"AssessItem8"));
		sAssessItem9 = parseInt(getItemValue(0,getRow(),"AssessItem9"));
		sAssessScore=sAssessItem1+sAssessItem2+sAssessItem3+sAssessItem4+sAssessItem5+sAssessItem6+sAssessItem7+sAssessItem8+sAssessItem9
		if(sAssessScore>=85)
		{
			setItemValue(0,0,"AssessLevel","030");
		}else if(sAssessScore>=70)
		{
			setItemValue(0,0,"AssessLevel","020");
		}else 
		{
			setItemValue(0,0,"AssessLevel","010")
		}
		setItemValue(0,0,"AssessScore",sAssessScore);
	}
	
	function getAssessLevel(){
		sAssessItem = getItemValue(0,getRow(),"PerFamilySum");
		if(sAssessItem>"8000")
			setItemValue(0,0,"AssessLevel","030");
		else if(sAssessItem>"5000")	
			setItemValue(0,0,"AssessLevel","020");
		else if(sAssessItem>"2000")	
			setItemValue(0,0,"AssessLevel","010");		
		else{ 	
			alert("��ͥ�˾������벻��С��2000Ԫ��");
			setItemValue(0,0,"AssessLevel","");
		}		
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		var sAge="";
		sToday = "<%=StringFunction.getToday()%>";
		sBirthday = "<%=sBirthday%>";
		if(typeof(sBirthday)!="undefined" && sBirthday.length!=0)
		{
			sToday=sToday.split("/");
			sBirthday=sBirthday.split("/");
			sAge=sToday[0]-sBirthday[0]
		}
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"ObjectNo","<%=sCustomerID%>");
			setItemValue(0,0,"ObjectType","Customer");
			setItemValue(0,0,"AssessFormType","<%=sAssessFormType%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Sex","<%=sSex%>");
			setItemValue(0,0,"CertID","<%=sCertID%>");
			setItemValue(0,0,"FamilyAdd","<%=sFamilyAdd%>");
			setItemValue(0,0,"MobileTelephone","<%=sMobileTelephone%>");
			setItemValue(0,0,"WorkCorp","<%=sWorkCorp%>");
			setItemValue(0,0,"ManageAdd","<%=sManageAdd%>");
			setItemValue(0,0,"ManageArea","<%=sManageArea%>");
			setItemValue(0,0,"PermitID","<%=sPermitID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			if("<%=sCustomerType%>"!='03'&&"<%=sCustomerType%>"!='0501')
			{
				setItemValue(0,0,"CustomerID","<%=sRelativeID%>");
			}else
			{
				setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			}
			setItemValue(0,0,"RelaCustomerName","<%=sRelaCustomerName%>");
			setItemValue(0,0,"RelaCustomerID","<%=sRelaCustomerID%>");
			setItemValue(0,0,"Age",sAge);
		}
    }
    
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSESSFORM_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
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
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
