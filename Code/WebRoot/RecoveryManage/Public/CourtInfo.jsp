<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2004-12-24
		Tester:
		Describe: ���������ϸ��Ϣ
		Input Param:
			CustomerID����ǰ�ͻ����
			SerialNo:	��ˮ��
		Output Param:
			CustomerID����ǰ�ͻ����

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������ϸ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	   String sHeaders[][] = { 							
				{"AgencyName","�����������"},
				{"DepartType","�����������"},
				{"LaunchDate","����ʱ��"},
				{"WorkDate","�칫ʱ��"},
				{"AgencyTel","��ϵ�绰"},
				{"PostNo","��������"},
				{"FaxNo","�������"},				
				{"AgencyAdd","��ַ"},
				{"PrincipalName","����������"},
				{"UserName","�Ǽ���"},
				{"OrgName","�Ǽǻ���"},				
				{"InputDate","�Ǽ�����"},
				{"UpdateDate","��������"},
				{"Remark","��ע"}								
			}; 
	
	String sSql;
	sSql = 	" select SerialNo,AgencyName,AgencyType,DepartType,"+
		   	" LaunchDate,WorkDate, "+		   
		   	" AgencyTel,PostNo,FaxNo,AgencyAdd,PrincipalName,Remark,"+
		   	" InputUserID,getUserName(InputUserID) as UserName," +		
		   	" InputOrgID,getOrgName(InputOrgID) as OrgName," +	  		  
		   	" InputDate,UpdateDate" +
		   	" from  AGENCY_INFO " +
	       	" where SerialNo='"+sSerialNo+"'";
	       
	//out.println(sSql);
	
	//����Sql���ɴ������
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "AGENCY_INFO";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo,InputUserID,InputOrgID,AgencyType",false);	
	
	
	//������Ӵ�����ȡ��ֵ
	doTemp.setDDDWCode("AgencyType","AgencyType1");
	doTemp.setDDDWCode("DepartType","DepartType");
	
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);
	
	//doTemp.setHTMLStyle("Remark"," style={height:150px;width:400px};overflow:scroll ");
	//doTemp.setHTMLStyle("BusinessBound"," style={height:150px;width:400px};overflow:scroll ");
	
	//���ó���
	doTemp.setLimit("Remark",100);
	doTemp.setLimit("AgencyName,FaxNo,AgencyAdd",80);
	doTemp.setLimit("AgencyTel,PrincipalName",32);
	doTemp.setLimit("PostNo",6);
	
	//���ñ༭��ʽ����ı���
	
	doTemp.setEditStyle("Remark","3");
	
	doTemp.setHTMLStyle("InputDate,WorkDate,UpdateDate,OrgName,UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("AgencyAdd"," style={width:300px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	doTemp.setRequired("AgencyName,DepartType,AgencyTel,PrincipalName",true);
	
	doTemp.setCheckFormat("LaunchDate,WorkDate","3");
	
	
	//���ÿɸ����ֶ�
	doTemp.setUpdateable("OrgName,UserName",false);

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
		var sLaunchDate= getItemValue(0,0,"LaunchDate");
		var sWorkDate= getItemValue(0,0,"WorkDate");
		if(typeof(sLaunchDate) != "undefined" && sLaunchDate != "" && typeof(sWorkDate) != "undefined" && sWorkDate != "")
		{
			if (sLaunchDate > sWorkDate) 
			{
				alert("����ʱ��ӦС�ڵ��ڰ칫ʱ�䣡");
				return;
			}
		}
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
		OpenPage("/RecoveryManage/Public/CourtList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/Public/AgencyInfo.jsp","_self","");
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}


	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"AgencyType","01");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "AGENCY_INFO";//����
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
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
