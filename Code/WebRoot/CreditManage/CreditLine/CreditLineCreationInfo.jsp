<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: �������Ŷ��ҳ��
		Input Param:
			
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������
		
	//���ҳ�����	
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%	
	//������ʾ����				
	String[][] sHeaders = {					
					{"CLTypeID","������ͱ��"},
					{"CLTypeName","�����������"},					
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},
					{"LineSum1","��Ƚ�Ԫ��"},
					{"Currency","����"},
					{"LineEffDate","��Ч��"},
					{"BeginDate","��ʼ��"},
					{"EndDate","������"},
					{"InputOrgName","�Ǽǻ���"},
					{"InputUserName","�Ǽ���"},
					{"InputTime","�Ǽ�����"},
					{"UpdateTime","��������"}															
					};
	String sSql = 	" select LineID,CLTypeID,CLTypeName,BCSerialNo,CustomerID,CustomerName, "+
					" LineSum1,Currency,LineEffDate,BeginDate,EndDate,LineEffFlag, "+
					" FreezeFlag,GetOrgName(InputOrg) as InputOrgName,InputOrg,InputUser, "+
					" GetUserName(InputUser) as InputUserName,InputTime,UpdateTime "+
					" from CL_INFO Where 1=2 ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setDDDWCode("LineEffFlag","EffStatus");
	
	//���ò��ɼ�����
	doTemp.setVisible("LineID,CLTypeID,BCSerialNo,LineEffDate,LineEffFlag,FreezeFlag,InputUser,InputOrg",false);
	//����ֻ������
	doTemp.setReadOnly("LineID,CLTypeID,CLTypeName,CustomerID,CustomerName,InputUserName,InputOrgName,InputTime,UpdateTime",true);
	//���ñ�����
	doTemp.setRequired("LineID,CLTypeName,CustomerName,LineSum1,Currency,BeginDate,EndDate",true);
	//���ò��ɸ�������
	doTemp.setUpdateable("InputUserName,InputOrgName",false);
	//���ø�ʽ
	doTemp.setType("LineSum1","Number");
	doTemp.setCheckFormat("LineEffDate,BeginDate,EndDate","3");	
	doTemp.setHTMLStyle("InputUserName,InputTime,UpdateTime"," style={width:80px;} ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");		
	doTemp.setUnit("CustomerName","<input type=button value=\"...\" onClick=parent.selectCustomer()>");
	doTemp.setUnit("CLTypeName","<input type=button value=\"...\" onClick=parent.setCLType()>");
	
	//���ö�Ƚ�Ԫ����Χ
	doTemp.appendHTMLStyle("LineSum1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ƚ�Ԫ��������ڵ���0��\" ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent
	dwTemp.setEvent("AfterInsert","!BusinessManage.AddCLContractInfo(#BCSerialNo,#CustomerID,#CustomerName,#LineSum1,#Currency,#BeginDate,#EndDate,#InputUser)");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.AddCLContractInfo(#BCSerialNo,#CustomerID,#CustomerName,#LineSum1,#Currency,#BeginDate,#EndDate,#InputUser)");
		
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
		{"true","","Button","ȷ��","���������޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","ȡ��","����","cancel()",sResourcesPath},
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
	
	/*~[Describe=���������޸�,�������б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function saveRecordAndReturn()
	{
		saveRecord("goBack()");
	}
	
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	function goBack(){
		var sLineID = getItemValue(0,0,"LineID");
		var sLineName = getItemValue(0,0,"LineName");
		top.returnValue = sLineID + "@" + sLineName;
		top.close();
	}
	
	function cancel(){
		top.close();
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶΣ�CL_INFO��
		initBCSerialNo();//��ʼ����ˮ���ֶΣ�BUSINESS_CONTRACT��		
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetDay.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sNow);
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		//У����Ч���Ƿ����ڵ�ǰ����		
		sLineEffDate = getItemValue(0,getRow(),"LineEffDate");//��Ч��
		sInputTime = getItemValue(0,getRow(),"InputTime");//�Ǽ�����
		if (typeof(sLineEffDate)!="undefined" && sLineEffDate.length > 0)
		{			
			if(sLineEffDate < sToday && sInputTime == sToday)
			{		    
				alert(getBusinessMessage('409'));//��Ч�ձ������ڻ���ڵ�ǰ���ڣ�
				return false;		    
			}
		}
		
		//������Ч�ա���ʼ�պ͵�����֮���ҵ���߼���ϵ
		sBeginDate = getItemValue(0,getRow(),"BeginDate");//��ʼ��			
		sEndDate = getItemValue(0,getRow(),"EndDate");//������	
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����
		if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
		{			
			if(sBeginDate < sToday  && sInputTime == sToday)
			{		    
				alert(getBusinessMessage('410'));//��ʼ�ձ������ڻ���ڵ�ǰ���ڣ�
				return false;		    
			}
						
			if(typeof(sEndDate)!="undefined" && sEndDate.length > 0)
			{
				if(sEndDate <= sBeginDate)
				{		    
					alert(getBusinessMessage('172'));//�����ձ���������ʼ�գ�
					return false;		    
				}
				
				if (typeof(sLineEffDate)!="undefined" && sLineEffDate.length > 0)
				{
					if(sEndDate <= sLineEffDate)
					{		    
						alert(getBusinessMessage('411'));//�����ձ���������Ч�գ�
						return false;		    
					}
				}
			}	
		}
						
		return true;
	}
	
	/*~[Describe=�����������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function setCLType(){
		setObjectValue("SelectCreditLineType","","@CLTypeID@0@CLTypeName@1",0,0,"");		
	}
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{			
		//����ҵ�����Ȩ�Ŀͻ���Ϣ
		sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+"01";
		setObjectValue("SelectApplyCustomer1",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{		
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"LineEffFlag","1");
			setItemValue(0,0,"FreezeFlag","1");//FreezeFlag(1:����;2:����;3:�ⶳ;4:��ֹ)
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");			
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CL_INFO";//����
		var sColumnName = "LineID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initBCSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"BCSerialNo",sSerialNo);
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
