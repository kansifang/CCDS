<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --cwliu 2004-11-29
		Tester:
		Describe:  --��ĿͶ���������
		Input Param:
			ProjectNo��--��ǰ��Ŀ���
		Output Param:
			ProjectNo��--��ǰ��Ŀ���
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ĿͶ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "",sProjectType = "";//--���sql��䡢��Ŀ����
	
	//����������,��ǰ��Ŀ���

	String sProjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	//�����Ŀ����
	sSql = " select ProjectType  from PROJECT_INFO where ProjectNo='"+sProjectNo+"' ";
	sProjectType = Sqlca.getString(sSql); 
	if(sProjectType == null ) sProjectType = "";
	//���ҳ�����	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "";
	if(sProjectType.equals("02"))
		sTempletNo = "HouseProjectBudgetInfo";
	else
		sTempletNo = "FixProjectBudgetInfo";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");		
	if(sProjectType.equals("02"))
	{

		//�������طѣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���طѣ���Ԫ��������ڵ���0��\" ");
		//����ǰ�ڹ��̷ѣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM2"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ǰ�ڹ��̷ѣ���Ԫ��������ڵ���0��\" ");
		//�����������̿����ѣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM3"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������̿����ѣ���Ԫ��������ڵ���0��\" ");
		//���ý�����װ���̿����ѣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM4"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������װ���̿����ѣ���Ԫ��������ڵ���0��\" ");
		//���ø������̿����ѣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM5"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������̿����ѣ���Ԫ��������ڵ���0��\" ");
		//���ù�����ã���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM6"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ã���Ԫ��������ڵ���0��\" ");
		//���ò�����ã���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM7"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ã���Ԫ��������ڵ���0��\" ");
		//�������۷��ã���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM8"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���۷��ã���Ԫ��������ڵ���0��\" ");
		//����˰�ѣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM9"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"˰�ѣ���Ԫ��������ڵ���0��\" ");
		//���ò���Ԥ���ѣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM10"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ԥ���ѣ���Ԫ��������ڵ���0��\" ");
		//�����Ǽ�Ԥ���ѣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM11"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�Ǽ�Ԥ���ѣ���Ԫ��������ڵ���0��\" ");
		//�����������ã���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM12"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ã���Ԫ��������ڵ���0��\" ");
		//���÷��ý��13��Χ
		doTemp.appendHTMLStyle("EXESSUM13"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ý��13������ڵ���0��\" ");
		//���÷��ý��14��Χ
		doTemp.appendHTMLStyle("EXESSUM14"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ý��14������ڵ���0��\" ");
		//����סլ���۾��ۣ�Ԫÿƽ���ף���Χ
		doTemp.appendHTMLStyle("EXESSUM16"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"סլ���۾��ۣ�Ԫÿƽ���ף�������ڵ���0��\" ");
		//����סլ���ۺϼƣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM17"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"סլ���ۺϼƣ���Ԫ��������ڵ���0��\" ");
		//�����������۾��ۣ�Ԫÿƽ���ף���Χ
		doTemp.appendHTMLStyle("EXESSUM18"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������۾��ۣ�Ԫÿƽ���ף�������ڵ���0��\" ");
		//�����������ۺϼƣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM19"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ۺϼƣ���Ԫ��������ڵ���0��\" ");
		//����д�ּ����۾��ۣ�Ԫÿƽ���ף���Χ
		doTemp.appendHTMLStyle("EXESSUM20"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"д�ּ����۾��ۣ�Ԫÿƽ���ף�������ڵ���0��\" ");
		//����д�ּ����ۺϼƣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM21"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"д�ּ����ۺϼƣ���Ԫ��������ڵ���0��\" ");
		//���ó������۾��ۣ�Ԫÿƽ���ף���Χ
		doTemp.appendHTMLStyle("EXESSUM22"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������۾��ۣ�Ԫÿƽ���ף�������ڵ���0��\" ");
		//���ó������ۺϼƣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM23"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ۺϼƣ���Ԫ��������ڵ���0��\" ");
		//�����������۾��ۣ�Ԫÿƽ���ף���Χ
		doTemp.appendHTMLStyle("EXESSUM24"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������۾��ۣ�Ԫÿƽ���ף�������ڵ���0��\" ");
		//����������������ϼƣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM25"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������������ϼƣ���Ԫ��������ڵ���0��\" ");
		//�����������루��Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM26"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������루��Ԫ��������ڵ���0��\" ");
		//����Ͷ�ʻ����ڣ��£���Χ
		doTemp.appendHTMLStyle("REDOUNDTERM"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ͷ�ʻ����ڣ��£�������ڵ���0��\" ");
		//���ô�������ڣ��£���Χ
		doTemp.appendHTMLStyle("LOANTERM"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڣ��£�������ڵ���0��\" ");
	}else
	{
		//�������ط��ã���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ط��ã���Ԫ��������ڵ���0��\" ");
		//���ù��̷��ã���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM2"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���̷��ã���Ԫ��������ڵ���0��\" ");
		//�����豸���ã���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM3"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�豸���ã���Ԫ��������ڵ���0��\" ");
		//���ù̶��ʲ�Ͷ�ʷ������˰����Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM4"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶��ʲ�Ͷ�ʷ������˰����Ԫ��������ڵ���0��\" ");
		//���ý�������Ϣ����Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM5"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������Ϣ����Ԫ��������ڵ���0��\" ");
		//���������ʽ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM6"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʽ���Ԫ��������ڵ���0��\" ");
		//�����������ã���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM7"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ã���Ԫ��������ڵ���0��\" ");
		//�������۷��ã���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM8"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���۷��ã���Ԫ��������ڵ���0��\" ");
		//����˰�ѣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM9"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"˰�ѣ���Ԫ��������ڵ���0��\" ");
		//���ò���Ԥ���ѣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM10"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ԥ���ѣ���Ԫ��������ڵ���0��\" ");
		//�����Ǽ�Ԥ���ѣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM11"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�Ǽ�Ԥ���ѣ���Ԫ��������ڵ���0��\" ");
		//�����������ã���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM12"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ã���Ԫ��������ڵ���0��\" ");
		//���÷��ý��13��Χ
		doTemp.appendHTMLStyle("EXESSUM13"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ý��13������ڵ���0��\" ");
		//���÷��ý��14��Χ
		doTemp.appendHTMLStyle("EXESSUM14"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ý��14������ڵ���0��\" ");
		//����סլ���۾��ۣ�Ԫÿƽ���ף���Χ
		doTemp.appendHTMLStyle("EXESSUM16"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"סլ���۾��ۣ�Ԫÿƽ���ף�������ڵ���0��\" ");
		//����סլ���ۺϼƣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM17"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"סլ���ۺϼƣ���Ԫ��������ڵ���0��\" ");
		//�����������۾��ۣ�Ԫÿƽ���ף���Χ
		doTemp.appendHTMLStyle("EXESSUM18"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������۾��ۣ�Ԫÿƽ���ף�������ڵ���0��\" ");
		//�����������ۺϼƣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM19"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ۺϼƣ���Ԫ��������ڵ���0��\" ");
		//����д�ּ����۾��ۣ�Ԫÿƽ���ף���Χ
		doTemp.appendHTMLStyle("EXESSUM20"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"д�ּ����۾��ۣ�Ԫÿƽ���ף�������ڵ���0��\" ");
		//����д�ּ����ۺϼƣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM21"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"д�ּ����ۺϼƣ���Ԫ��������ڵ���0��\" ");
		//���ó������۾��ۣ�Ԫÿƽ���ף���Χ
		doTemp.appendHTMLStyle("EXESSUM22"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������۾��ۣ�Ԫÿƽ���ף�������ڵ���0��\" ");
		//���ó������ۺϼƣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM23"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ۺϼƣ���Ԫ��������ڵ���0��\" ");
		//�����������۾��ۣ�Ԫÿƽ���ף���Χ
		doTemp.appendHTMLStyle("EXESSUM24"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������۾��ۣ�Ԫÿƽ���ף�������ڵ���0��\" ");
		//����������������ϼƣ���Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM25"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������������ϼƣ���Ԫ��������ڵ���0��\" ");
		//�����������루��Ԫ����Χ
		doTemp.appendHTMLStyle("EXESSUM26"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������루��Ԫ��������ڵ���0��\" ");
		//����Ͷ�ʻ����ڣ��£���Χ
		doTemp.appendHTMLStyle("REDOUNDTERM"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ͷ�ʻ����ڣ��£�������ڵ���0��\" ");
		//���ô�������ڣ��£���Χ
		doTemp.appendHTMLStyle("LOANTERM"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������ڣ��£�������ڵ���0��\" ");
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectNo+","+sSerialNo);
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
		{"fasle","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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
		
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/ProjectFundsList.jsp","_self","");
	}
	
	/*~[Describe=�ϼƷ���;InputParam=��;OutPutParam=��;]~*/
	function getSum(iStart,iEnd,iDes)
	{		
		var Sum=0;
		if(iStart == '16' && iEnd == '26' && iDes == '27')//�ϼƣ���Ԫ��
		{
			for(var i=iStart+1;i<iEnd+1;i=i+2)
			{
			//alert(getItemValue(0,getRow(),"EXESSUM"+i));
			if(typeof(getItemValue(0,getRow(),"EXESSUM"+i))=="undefined" || getItemValue(0,getRow(),"EXESSUM"+i).length==0)
				continue;
			else
			Sum+=getItemValue(0,getRow(),"EXESSUM"+i);
			}
			
		}else//�ܼ�(��Ԫ)
		{
			for(var i=iStart;i<iEnd+1;i=i+1)
			{
			//alert(getItemValue(0,getRow(),"EXESSUM"+i));
			if(typeof(getItemValue(0,getRow(),"EXESSUM"+i))=="undefined" || getItemValue(0,getRow(),"EXESSUM"+i).length==0)
				continue;
			else
			Sum+=getItemValue(0,getRow(),"EXESSUM"+i);
			}
		}
		//��Ŀ�ʱ������������
		setItemValue(0,getRow(),"EXESSUM"+iDes,Sum);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp","_self","");
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

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		return true;
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"PROJECTNO","<%=sProjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "PROJECT_BUDGET";//����
		var sColumnName = "SERIALNO";//�ֶ���
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
