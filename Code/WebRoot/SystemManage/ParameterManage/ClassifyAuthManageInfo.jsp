<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong
		Tester:
		Content: ���շ����϶���Ȩ��������
		Input Param:
		       --SerialNO:��ˮ��
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���շ����϶���Ȩ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSerialNo="";//--��ˮ����
	String sSql="";//--���sql���
	//����������

	//���ҳ�����	,��ˮ��
    sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 		
			                    {"SerialNo","��Ȩ��ˮ��"},		                   
                                {"RoleID","��Ȩ�϶���"},	
                                {"CustomerType","�ͻ�����"},
                                {"ClassifyResult","����"},
                                {"RiskSum","һ����ս��"},
                                {"LowRiskSum","�ͷ��ս��"},
	                            {"InputUserName","�Ǽ���Ա"},
	                            {"InputOrgName","�Ǽǻ���"},
	                            {"InputDate","�Ǽ�����"},
	                            {"UpdateDate","��������"},
      					   };   				   		

	sSql = " select SerialNo,RoleID,getRoleName(RoleID) as RoleIDName,"+
	       " CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,"+
	       " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName,RiskSum,LowRiskSum,"+
	       " InputUserID,getUserName(InputUserID) as InputUserName,"+
	       " InputOrgID,getOrgName(InputOrgID) as InputOrgName,InputDate,UpdateDate "+ 
	       " from Classify_Auth "+		           
		   " where SerialNo = '"+sSerialNo+"' ";
    //sql����datawindows
	ASDataObject doTemp = new ASDataObject(sSql);
	//ͷ����
	doTemp.setHeader(sHeaders);
	//�޸ı�
	doTemp.UpdateTable = "Classify_Auth";
    //��������
	doTemp.setKey("SerialNo",true);
	//�����ֶεĲ��ɼ�
	doTemp.setVisible("SerialNo,InputOrgID,InputUserID,RoleIDName,CustomerTypeName,ClassifyResultName",false);
	//����number��
	doTemp.setAlign("RiskSum,LowRiskSum","3");
	doTemp.setType("RiskSum,LowRiskSum","Number");
	doTemp.setCheckFormat("RiskSum,LowRiskSum","2");
	//���ֶ��Ƿ�ɸ��£���Ҫ���ⲿ���������ģ�����UserName\OrgName	    
	doTemp.setUpdateable("InputUserName,InputOrgName,RoleIDName,CustomerTypeName,ClassifyResultName",false);
	//����html��ʽ
	doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");
	//���ô�����Դ
	doTemp.setDDDWSql("ClassifyResult","select itemNo,itemName from Code_Library where CodeNo ='ClassifyResult' and  itemno in('01','02','03','04','05') and isinuse ='1' ");
	doTemp.setDDDWSql("CustomerType","select ItemNo,ItemName from code_library where codeno='CustomerType' and itemno in('01','03') and isinuse ='1' ");
	doTemp.setDDDWSql("RoleID","select RoleID,RoleName from ROLE_INFO where RoleID in('241','041','210','0J0') order by RoleID desc");
	//����ֻ��
	doTemp.setReadOnly("InputUserName,InputOrgName,InputDate,UpdateDate",true);

	//��������
    //����numberֵ����
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
		{((CurUser.hasRole("097"))?"false":"true"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
		if(bIsInsert)
		{
			beforeInsert();
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
			return;
		}else{	
			beforeUpdate();
			as_save("myiframe0",sPostEvents);
		}
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/ParameterManage/ClassifyAuthManageList.jsp","_self","");
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
		sDay = "<%=StringFunction.getToday()%>";//--��õ�ǰ����
		setItemValue(0,0,"UpdateDate",sDay);
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateOrg","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
	}
	
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;

			sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
		}
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "Classify_Auth";//����
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
