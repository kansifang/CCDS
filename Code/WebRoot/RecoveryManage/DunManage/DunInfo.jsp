<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ��ҵ� 2005-08-18
		Tester:
		Content: ���պ���ϸ��Ϣ_List
		Input Param:
				SerialNo	���պ���ˮ��
				���в�����Ϊ�����������
				ComponentName	������ƣ����պ�����/���պ��б�
				ComponentType	������ͣ�MainWindo/ListWindow	
				ObjectType	�������ͣ�BUSINESS_CONTRACT
				ObjectNo	�����ţ���ͬ���
						��������������Ŀ���Ǳ�����չ��,�������ܲ������û������ʲ��Ĵ��պ�����.
						
		Output param:
		
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(sObjectType==null) sObjectType="";
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sObjectNo==null) sObjectNo="";
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));			
	if(sSerialNo==null) sSerialNo="";
	String sSql = "select CustomerID,CustomerName from BADBIZ_ACCOUNT where serialno = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	String sCustomerID = "";
	String sCustomerName = "";
	if(rs.next()){
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
	}
	rs.getStatement().close();
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	ASDataObject doTemp = new ASDataObject("DunManageInfo",Sqlca);

	//�����Զ��ۼ��ֶ�
	doTemp.appendHTMLStyle("Corpus,InterestInSheet,InterestOutSheet,ElseFee"," onChange=\"javascript:parent.getDunSum()\" ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","����","goBack()",sResourcesPath},
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
	    fCorpus = getItemValue(0,getRow(),"Corpus");
		fInterestInSheet = getItemValue(0,getRow(),"InterestInSheet");
		fInterestOutSheet = getItemValue(0,getRow(),"InterestOutSheet");
		fElseFee = getItemValue(0,getRow(),"ElseFee");
		fFeedbackContent = getItemValue(0,getRow(),"FeedbackContent");
		
     	if(fCorpus<0 || fInterestInSheet < 0 ||fInterestOutSheet <0 || fElseFee <0 ) 
     	{
     		alert("�������ϢӦ�����㣡���������룡"); 	
     		return;
     	}
     	if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
     	//���ս��������ϼƻ��
	function getDunSum()
	{
		fCorpus = getItemValue(0,getRow(),"Corpus");
		fInterestInSheet = getItemValue(0,getRow(),"InterestInSheet");
		fInterestOutSheet = getItemValue(0,getRow(),"InterestOutSheet");
		fElseFee = getItemValue(0,getRow(),"ElseFee");
     		
		if(typeof(fCorpus)=="undefined" || fCorpus.length==0) fCorpus=0; 
		if(typeof(fInterestInSheet)=="undefined" || fInterestInSheet.length==0) fInterestInSheet=0; 
		if(typeof(fInterestOutSheet)=="undefined" || fInterestOutSheet.length==0) fInterestOutSheet=0; 
		if(typeof(fElseFee)=="undefined" || fElseFee.length==0) fElseFee=0; 
     		
		fDunSum = fCorpus+fInterestInSheet+fInterestOutSheet+fElseFee;
		setItemValue(0,getRow(),"DunSum",fDunSum);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
				
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		sDunDate =  getItemValue(0,getRow(),"DunDate");
		if("<%=sObjectType%>"=="BadBizAccount"&& typeof(sDunDate)!="undefined" && sDunDate.length!=0)
		{
			sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@LastDunDate@"+sDunDate+",BADBIZ_ACCOUNT,String@SerialNo@<%=sObjectNo%>");
		}
	}
	
	function goBack()
	{
		OpenPage("/RecoveryManage/DunManage/DunList.jsp","_self","");
	}

	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser()
	{
		setObjectInfo("User","OrgID=<%=CurOrg.OrgID%>@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0);
		/*
		* setObjectInfo()����˵����---------------------------
		* ���ܣ� ����ָ�������Ӧ�Ĳ�ѯѡ��Ի��򣬲������صĶ������õ�ָ��DW����
		* ����ֵ�� ���硰ObjectID@ObjectName���ķ��ش��������ж�Σ����硰UserID@UserName@OrgID@OrgName��
		* sObjectType�� ��������
		* sValueString��ʽ�� ������� @ ID���� @ ID�ڷ��ش��е�λ�� @ Name���� @ Name�ڷ��ش��е�λ��
		* iArgDW:  �ڼ���DW��Ĭ��Ϊ0
		* iArgRow:  �ڼ��У�Ĭ��Ϊ0
		* ��������� common.js -----------------------------
		*/
	}


	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			
			setItemValue(0,0,"DunDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");

			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");			
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");			

			setItemValue(0,0,"Corpus","0.00");
			setItemValue(0,0,"InterestInSheet","0.00");
			setItemValue(0,0,"InterestOutSheet","0.00");
			setItemValue(0,0,"ElseFee","0.00");

			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.OrgID%>");	
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");	
			setItemValue(0,0,"DunObjectType","01");
			setItemValue(0,0,"DunObjectName","<%=sCustomerName%>");
			
			
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "Dun_Info";//����
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