<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   XWu  2004.11.29
		Tester:
		Content: �ͻ������ʲ���Ϣ
		Input Param:
            CustomerID���ͻ����
            SerialNo����Ϣ��ˮ��
            EditRight:Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		Output param:

		History Log: 
             2003.08.20 CYHui
             2003.08.28 CYHui
             2003.09.08 CYHui 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ������ʲ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql ="";
	
	//����������:�ͻ�ID	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	//ȡ��ˮ��
	String sSerialNo   =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sEditRight == null) sEditRight = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 
							{"CustomerID","���˱��"},
							{"SerialNo","��ˮ��"},
							{"AssetType","�ʲ�����"},
							{"AuthNo","֤����"},
							{"AssetDescribe","�ʲ�����"},
							{"AuthOrg","��֤����"},
							{"AuthDate","��֤����"},
							{"EvaluateValue","������ֵ"},
							{"EvaluateMethod","��������"},
							{"AccountValue","���ʼ�ֵ"},
							{"UpToDate","ͳ�ƽ�ֹ����"},
							{"InputOrgName","�Ǽǵ�λ"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"},
							{"Remark","��ע"},
							{"AssetName","�ʲ�����"}
						  };

		sSql =	" select CustomerID,SerialNo,AssetType,AssetName,AuthNo,AssetDescribe,AuthOrg,"+
				" AuthDate,EvaluateValue,EvaluateMethod,AccountValue,UpToDate,Remark,"+
				" InputOrgID,getOrgName(InputOrgID) as InputOrgName," +
				" InputUserID,getUserName(InputUserID) as InputUserName," +
				" InputDate,UpdateDate"+
				" from CUSTOMER_IMASSET"+
				" where CustomerID='"+sCustomerID+"' "+
				" and SerialNo='"+sSerialNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_IMASSET";

	doTemp.setKey("CustomerID,SerialNo",true);
	doTemp.setUpdateable("InputOrgName,InputUserName",false);
	doTemp.setUnit("EvaluateValue,AccountValue","Ԫ");
	doTemp.setLimit("AssetDescribe,Remark",200);
	
	doTemp.setVisible("CustomerID,SerialNo,InputOrgID,InputUserID",false);
	doTemp.setRequired("AssetType,AssetDescribe,,EvaluateMethod,AuthOrg,AccountValue,UpToDate",true);
	doTemp.setUpdateable("InputUserName",false);	
	doTemp.setReadOnly("InputUserName",true); 
	doTemp.setAlign("AuthDate,UpToDate,InputDate,UpdateDate","2");
	doTemp.setAlign("EvaluateValue,AccountValue","3");
	doTemp.setType("EvaluateValue,AccountValue","Number");

	doTemp.setCheckFormat("AuthDate,UpToDate,InputDate,UpdateDate","3");
	doTemp.setCheckFormat("EvaluateValue,AccountValue","2");
	doTemp.setHTMLStyle("AuthDate,UpToDate,InputDate,UpdateDate"," style={width:70px}");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setReadOnly("InputDate,UpdateDate,InputOrgName,InputUserName",true);
	doTemp.setDDDWCode("AssetType","ImmaterialAssetType");
	doTemp.setDDDWCode("EvaluateMethod","EvaluateMethod");
	doTemp.setEditStyle("Remark,AssetDescribe","3");
	doTemp.setHTMLStyle("Remark,AssetDescribe"," style={height:100px;width:400px} ");
	
	//����������ֵ(Ԫ)��Χ
	doTemp.appendHTMLStyle("EvaluateValue"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ֵ(Ԫ)������ڵ���0��\" ");
	//�������ʼ�ֵ(Ԫ)��Χ
	doTemp.appendHTMLStyle("AccountValue"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʼ�ֵ(Ԫ)������ڵ���0��\" ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sSerialNo);
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
		{(sEditRight.equals("02")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntImassetsList.jsp","_self","");
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{		
		initSerialNo();//��ʼ����ˮ���ֶ�
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{					
		//У��ͳ�ƽ�ֹ�����Ƿ���ڵ�ǰ����
		sUpToDate = getItemValue(0,0,"UpToDate");//ͳ�ƽ�ֹ����
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����		
		if(typeof(sUpToDate) != "undefined" && sUpToDate != "" )
		{
			if(sUpToDate >= sToday)
			{		    
				alert(getBusinessMessage('144'));//ͳ�ƽ�ֹ���ڱ������ڵ�ǰ���ڣ�
				return false;		    
			}
		}
		
		//У����֤�����Ƿ���ڵ�ǰ����
		sAuthDate = getItemValue(0,0,"AuthDate");//��֤����
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����		
		if(typeof(sAuthDate) != "undefined" && sAuthDate != "" )
		{
			if(sAuthDate >= sToday)
			{		    
				alert(getBusinessMessage('145'));//��֤���ڱ������ڵ�ǰ���ڣ�
				return false;		    
			}
			//У��ͳ�ƽ�ֹ�����Ƿ������֤����
			if(sUpToDate <= sAuthDate)
			{		    
				alert(getBusinessMessage('164'));//ͳ�ƽ�ֹ���ڱ���������֤���ڣ�
				return false;		    
			}
		}
		
		
		
						
		return true;
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
   	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_IMASSET";//����
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
