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
	String PG_TITLE = "���̻�е���Ҷ������"   ; // ��������ڱ��� <title> PG_TITLE </title>  
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";

	out.print("<fieldset ><font color='red'><b>��ע�⣺���������빤�̻�е���Ҷ����Э��</b></font></fieldset>");
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ProjectAgreement";
	String sTempletFilter = "1=1";
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//������ߴ�����
	doTemp.appendHTMLStyle("LoanSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ߴ�����(Ԫ)������ڵ���0��\" ");
	//������ߴ�������(��)��Χ
	doTemp.appendHTMLStyle("LoanTerm"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ߴ�������(��)������ڵ���0��\" ");
	//��������)��Χ
	doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ޱ�����ڵ���0��\" ");
	//������ͽɴ汣֤�����(%)��Χ
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��ͽɴ汣֤�����(��)�ķ�ΧΪ[0,100]\" ");
	//�������������̱���(%)��Χ
	doTemp.appendHTMLStyle("CompanyBailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���������̱���(��)�ķ�ΧΪ[0,100]\" ");
	//�������о����̱���(%)��Χ
	doTemp.appendHTMLStyle("DealerBailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���о����̱���(��)�ķ�ΧΪ[0,100]\" ");
	//������ߴ������(%)��Χ
	doTemp.appendHTMLStyle("LoanRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��ߴ������(��)�ķ�ΧΪ[0,100]\" ");
	//��������Э���ģ)��Χ
	doTemp.appendHTMLStyle("AgreementScale"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Э���ģ������ڵ���0��\" ");
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "0"; 
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+",ProjectAgreement");
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
		{"true","","Button","��Э����Ϣ","�༭/�鿴��Э����Ϣ","viewDealerAgreement()",sResourcesPath},
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
			sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
			sMaturity = getItemValue(0,getRow(),"Maturity");
			if(sPutOutDate > sMaturity)
			{
				alert("Э��ǩ�����ڲ��ܴ���Э�鵽���գ�");
				return;
			}
			if(bIsInsert){		
				beforeInsert();
			}	
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
			
		}		
	}	


	/*~[Describe=,�鿴��Э������ĵ���Э��;InputParam=��;OutPutParam=��;]~*/
	function viewDealerAgreement()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����RAGREEMENT
		OpenComp("DealerAgreementList","/CreditManage/CreditLine/DealerAgreementList.jsp","ESerialNo="+sSerialNo,"_blank",OpenStyle);
	}
    
	</script>
	
	

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		//���´�Э�鹤�̻�е����
		sLoanType = getItemValue(0,getRow(),"LoanType");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		RunMethod("CreditLine","UpdateLoanType",sLoanType+","+sSerialNo);
	}
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getCompanyName()
	{
		setObjectValue("getCompanyName","","@CustomerID@0@CustomerName@1",0,0,"");		
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{

		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
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
			setItemValue(0,0,"AgreementType","ProjectAgreement");
			setItemValue(0,0,"FreezeFlag","1");
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
		var sTableName = "ENT_AGREEMENT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
	
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	/*
	if(getRowCount(0)== 0) 
	{
		OpenPage("/Blank.jsp?TextToShow=��¼�빤�̻�е���Ҷ����Э��!","DetailFrame","");
	}else
	{
		mySelectRow();	
	}*/
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>