<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   lpzhang 2009-8-5
		       
		Tester:	
		Content:���̻�е���Ҷ������
		Input Param:
			
			
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���̻�е���Ҷ�ȴ�Э������"   ; // ��������ڱ��� <title> PG_TITLE </title>  
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));//������
	String ESerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ESerialNo"));//��Э��
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(ESerialNo == null) ESerialNo = "";
    out.print("<fieldset ><font color='red'><b>��ע�⣺���������빤�̻�е���Ҷ�ȴ�Э��</b></font></fieldset>");
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	ASResultSet rs = null;
	//��Э�鹤�̻�е����  
	String sParentLoanType = "" ,sParentCurrency = "";
	//��Э������ ,�����ģ����ߴ������߱���
	double dParentTermMonth = 0.0 ,dParentAgreementScale = 0.0,dParentLoanSum = 0.0,dParentLoanRatio = 0.0;

	String sSql = "select LoanType,Currency,TermMonth,AgreementScale,LoanSum,LoanRatio from ENT_Agreement where SerialNo ='"+ESerialNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sParentLoanType = rs.getString("LoanType");   
		sParentCurrency = rs.getString("Currency"); 
		dParentTermMonth = rs.getDouble("TermMonth");   
		dParentAgreementScale = rs.getDouble("AgreementScale");  
		dParentLoanSum = rs.getDouble("LoanSum");    
		dParentLoanRatio = rs.getDouble("LoanRatio");   
		if(sParentLoanType == null) sParentLoanType = "";
		if(sParentCurrency == null) sParentCurrency = "";
	}
	rs.getStatement().close();
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "DealerAgreement";
	String sTempletFilter = "1=1";
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//������ߴ�����
	doTemp.appendHTMLStyle("LimitSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ߴ�����(Ԫ)������ڵ���0��\" ");
	//������ߴ�������(��)��Χ
	doTemp.appendHTMLStyle("LimitLoanTerm"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ߴ�������(��)������ڵ���0��\" ");
	//��������)��Χ
	doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ޱ�����ڵ���0��\" ");
	//������ͽɴ汣֤�����(%)��Χ
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�ɴ汣֤�����(��)�ķ�ΧΪ[0,100]\" ");
	//�������������̱���(%)��Χ
	doTemp.appendHTMLStyle("CompanyBailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���������̱���(��)�ķ�ΧΪ[0,100]\" ");
	//�������о����̱���(%)��Χ
	doTemp.appendHTMLStyle("DealerBailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���о����̱���(��)�ķ�ΧΪ[0,100]\" ");
	//������ߴ������(%)��Χ
	doTemp.appendHTMLStyle("LimitLoanRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��ߴ������(��)�ķ�ΧΪ[0,100]\" ");
	//���ô�Э���Ƚ�Χ
	doTemp.appendHTMLStyle("CreditSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Э���Ƚ�������ڵ���0��\" ");

	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "0"; 
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+ESerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //����datawindow��Sql���÷���

	
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{	
	
		if(vI_all("myiframe0"))
		{
			if(!ValidityCheck()) return;
			if(bIsInsert){		
				beforeInsert();
			}	
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
		}	
		//parent.reloadSelf();
	}	

	</script>
	
	

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getCompanyName()
	{
		setObjectValue("getCompanyName","","@DealerID@0@DealerName@1",0,0,"");		
		//���뵱ǰ����������
		/*
	    sParaString = "ObjectType"+",BuildAgreement";
		sReturn = selectObjectValue("SelectEntAgreement",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || sReturn=="_CLEAR_" || typeof(sReturn)=="undefined") return;
		sReturn= sReturn.split('@');
		sSerialNo = sReturn[0];
		*/
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		//�����ж�
		var dParentTermMonth = "<%=dParentTermMonth%>";
		var dTermMonth = getItemValue(0,getRow(),"LimitLoanTerm");
		if(parseFloat(dTermMonth) > parseFloat(dParentTermMonth))
		{
			alert("�Բ��𣬴�Э����ߴ������޲��ܸ�����Э�����ߴ������ޣ�");
			return false;
		}
		//��ߴ������ж�
		var dParentLoanSum = "<%=dParentLoanSum%>";
		var sParentCurrency = "<%=sParentCurrency%>";
		var dLimitSum = getItemValue(0,getRow(),"LimitSum");
		var sCurrency = getItemValue(0,getRow(),"Currency");
		var dErateRatio =  RunMethod("BusinessManage","getErateRatio",sCurrency+","+sParentCurrency+",''");
		if(parseFloat(dLimitSum)*dErateRatio > parseFloat(dParentLoanSum))
		{
			alert("�Բ�����ߴ�����ܸ�����Э����ߴ����");
			return false;
		}
		//��������ж�
		var dParentLoanRatio = "<%=dParentLoanRatio%>";
		var dLimitLoanRatio = getItemValue(0,getRow(),"LimitLoanRatio");
		if(parseFloat(dLimitLoanRatio) > parseFloat(dParentLoanRatio))
		{
			alert("�Բ�����ߴ���������ܸ�����Э����ߴ��������");
			return false;
		}
		//�����ģ�ж�
		var dParentAgreementScale = "<%=dParentAgreementScale%>"; 
		var dCreditSum = getItemValue(0,getRow(),"CreditSum");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var dTotalCreditSum =  RunMethod("CreditLine","getTotalCreditSum","<%=ESerialNo%>,"+sSerialNo+","+dCreditSum+","+sCurrency+","+sParentCurrency);
		if(parseFloat(dTotalCreditSum) > parseFloat(dParentAgreementScale))
		{
			alert("�Բ��𣬴�Э���Ƚ��ܸ�����Э���ģ��");
			return false;
		}
		
		return true;
	}
	
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{

		if(getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ObjectNo","<%=ESerialNo%>");
			setItemValue(0,0,"LoanType","<%=sParentLoanType%>");
		}
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");

	}
	
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "DEALER_AGREEMENT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");//��������

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��GetChildSerialNo
		var sSerialNo = PopPage("/Common/ToolsB/GetChildSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&ObjectNo="+sObjectNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
	
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>