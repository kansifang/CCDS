<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:byhu 2005/07/27
		Tester:
		Content: ��������Ϣ
		Input Param:
			SubLineID����ȷ�����
			LimitationSetID��������������
			LimitationID�������������
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	//���ҳ�����	
	String sSubLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubLineID"));
	String sLimitationSetID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LimitationSetID"));
	String sLimitationID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LimitationID"));
	
	//��ȡ����������Ķ�������
	sSql =  " select CLT.ObjectType "+
			" from CL_LIMITATION_TYPE CLT,CL_LIMITATION_SET CLS "+
			" where CLS.LimitationType = CLT.TypeID "+
			" and CLS.LimitationSetID = '"+sLimitationSetID+"' ";	
	String sLimObjectType = Sqlca.getString(sSql);
	if(sLimObjectType == null) sLimObjectType = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String[][] sHeaders = {
							{"LimitationID","������ID"},
							{"LimObjectType","���ƶ�������"},
							{"LimObjectNo","���ƶ�����"},
							{"LimObjectName","���ƶ���"},
							{"LineSum1","�����޶�"},
							{"LineSum2","�����޶�"},
						};

	sSql =  " select LineID,LimitationSetID,LimitationID,LimObjectType, "+
			" LimObjectNo,LimObjectName,LineSum1,LineSum2,InputUser, "+
			" InputOrg,InputTime,UpdateTime "+
			" from CL_LIMITATION "+
			" where LineID = '"+sSubLineID+"' "+
			" and LimitationSetID = '"+sLimitationSetID+"' "+
			" and LimitationID = '"+sLimitationID+"' ";	
		
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_LIMITATION";
	doTemp.setVisible("LineID,LimitationSetID,LimitationID,LimObjectType,LimObjectNo,InputUser,InputOrg,InputTime,UpdateTime",false);
	//�������ƶ���Ĳ�ͬ���岻ͬ��ѡ������		
	if(sLimObjectType.equals("CurrencySet"))//ѡ�������
	{
		doTemp.setUnit("LimObjectName","<input type=button value=... class=inputDate onClick=parent.selectCurrencySet()");
	}
	if(sLimObjectType.equals("Currency"))//ѡ�����
	{
		doTemp.setUnit("LimObjectName","<input type=button value=... class=inputDate onClick=parent.selectCodeType(\"Currency\")");
	}
	if(sLimObjectType.equals("VouchTypeSet"))//ѡ�񵣱���ʽ��
	{
		doTemp.setUnit("LimObjectName","<input type=button value=... class=inputDate onClick=parent.selectVouchTypeSet()");
	}
	if(sLimObjectType.equals("VouchType"))//ѡ�񵣱���ʽ
	{
		doTemp.setUnit("LimObjectName","<input type=button value=... class=inputDate onClick=parent.selectCodeType(\"VouchType\")");
	}
	
	doTemp.setUnit("LineSum1,LineSum2","Ԫ");
	doTemp.setType("LineSum1,LineSum2","Number");
	doTemp.setRequired("LimObjectName",true);
	doTemp.setHeader(sHeaders);
	doTemp.setReadOnly("LimObjectName",true);
	
	//���������޶Χ
	doTemp.appendHTMLStyle("LineSum1"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����޶������ڵ���0��\" ");
	//���ó����޶Χ
	doTemp.appendHTMLStyle("LineSum2"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����޶������ڵ���0��\" ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql); //������仰����datawindow
	
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
		{"true","","Button","ȷ��","���沢����","saveAndGoBack()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ�����رմ���","goBack()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
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
	function saveAndGoBack()
	{
		saveRecord("goBack()");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		top.close();
	}

	/*~[Describe=���沢����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function saveAndNew()
	{
		saveRecord("newRecord()");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sCurDate = PopPage("/Common/ToolsB/GetDay.jsp","","");		
		setItemValue(0,0,"UpdateTime",sCurDate);
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		return true;
	}
			
	/*~[Describe=�������������ƶ���ѡ�񴰿ڣ��������ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCurrencySet()
	{
		setObjectValue("SelectCurrencySet","","@LimObjectNo@0@LimObjectName@1",0,0,"");
	}
	
	/*~[Describe=����������ʽ�����ƶ���ѡ�񴰿ڣ��������ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectVouchTypeSet()
	{
		setObjectValue("SelectVouchTypeSet","","@LimObjectNo@0@LimObjectName@1",0,0,"");
	}
		
	/*~[Describe=ѡ���������/������ʽ����;InputParam=��;OutPutParam=��;]~*/
	function selectCodeType(sCodeNo) {
		sParaString = "CodeNo"+","+	sCodeNo;	
		setObjectValue("SelectCode",sParaString,"@LimObjectNo@0@LimObjectName@1",0,0,"");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼			
			sCurDate = PopPage("/Common/ToolsB/GetDay.jsp","","");
			setItemValue(0,0,"LineID","<%=sSubLineID%>");
			setItemValue(0,0,"LimitationSetID","<%=sLimitationSetID%>");
			setItemValue(0,0,"LimObjectType","<%=sLimObjectType%>");
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputTime",sCurDate);
			setItemValue(0,0,"UpdateTime",sCurDate);
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CL_LIMITATION";//����
		var sColumnName = "LimitationID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
			
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
