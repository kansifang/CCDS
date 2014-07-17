<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.7
		Tester:
		Content: �������Ŷ������
		Input Param:
			ObjectType����������
			ApplyType����������
			PhaseType���׶�����
			FlowNo�����̺�
			PhaseNo���׶κ�
			OccurType����������	
			OccurDate����������
		Output param:
		History Log: zywei 2005/07/28
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ŷ���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α�š�������ʽ����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type")));
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	//���������SQL���
	String sSql = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String[][] sHeaders = {
							{"ReportConfigNo","��ѯ����"},							
							{"OneKey","��������"},
							{"EDocNo","����ģ��"}
						  };
	sSql = 	" select SerialNo,ReportConfigNo,OneKey,Type,EDocNo"+	
			" from Batch_Report where 1 = 2 ";	
	//ͨ��SQL����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);	
	//���ñ���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="Batch_Report";
	doTemp.setKey("SerialNo",true);
	//���ñ�����
	doTemp.setRequired("ReportConfigNo,OneKey",true);
	//����������ѡ������
	doTemp.setDDDWSql("ReportConfigNo", "select DocNo,DocTitle from Doc_Library where DocNo like 'QDT%'");
	doTemp.setDDDWSql("EDocNo", "select EDocNo,EDocName from EDoc_Define");
	//���ñ��䱳��ɫ
	doTemp.setHTMLStyle("OccurType,OccurDate","style={background=\"#EEEEff\"} ");
	//�������ڸ�ʽ
	doTemp.setCheckFormat("OneKey","6");	
	//ע��,����HTMLStyle������ReadOnly������ReadOnly������
	doTemp.setHTMLStyle("InputDate"," style={width:80px}");
	doTemp.setReadOnly("InputOrgName,InputUserName,InputDate",true);
	doTemp.setVisible("SerialNo,Type", false);
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
		{"true","","Button","��һ��","�������Ŷ���������һ��","saveRecord('doReturn()')",sResourcesPath},
		{"true","","Button","ȡ��","ȡ���������Ŷ������","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
		/*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
		function doCancel(){		
			top.returnValue = "_CANCEL_";
			top.close();
		}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>	
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
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
		
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼	
			bIsInsert = true;

			setItemValue(0,0,"ReportConfigNo","b20140519000001");
			setItemValue(0,0,"OneKey","<%=DateUtils.getRelativeMonth(DateUtils.getToday(),0,0)%>");
			setItemValue(0,0,"Type","<%=sType%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");	
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");	
			setItemValue(0,0,"InputDate","<%=DateUtils.getToday()%>");			
		}
    }
	/*~[Describe=ȷ������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		var sSerialNo= getItemValue(0,0,"SerialNo");
		var sConfigNo= getItemValue(0,0,"ReportConfigNo");		
		var sKey = getItemValue(0,0,"OneKey");		
		self.returnValue = sSerialNo+"@"+sConfigNo+"@"+sKey;
		self.close();
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo()
	{
		var sTableName = "Batch_Report";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sCodeNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sCodeNo);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();	
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��	
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>