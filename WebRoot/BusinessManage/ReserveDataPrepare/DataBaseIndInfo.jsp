<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.07
		Tester:
		Content: ���ݲɼ�  �Ը��˾�ά��
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Ը�����ά��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������

	//����������

	//���ҳ�����
	String sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "DataBaseIndInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "Reserve_IndPara";
	doTemp.setDDDWCode("LossScope","LossScope");
	doTemp.setUnit("AccountMonth"," <input type=button class=inputDate value=... onclick=parent.selectAccountMonth() > ");
	doTemp.setHTMLStyle("AccountMonth,LastAccountMonth","style={width:80}");
   	//doTemp.setDDDWCode("LossRateCalType","LossScope");
   	doTemp.setUnit("LastAccountMonth"," <input type=button class=inputDate value=... onclick=parent.selectLastAccountMonth() > ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//session.setAttribute(dwTemp.Name,dwTemp);
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
		{"false","","Button","�Զ�����","�Զ�����","my_cal()",sResourcesPath},
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","�ϴ�����","�ϴ�����","Upload()",sResourcesPath},
		{"true","","Button","����","����","goBack()",sResourcesPath}
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

	function selectAccountMonth()
	{
		
		var sAccountMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=21;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sAccountMonth)!="undefined" && sAccountMonth!="")
		{	
			setItemValue(0,0,"AccountMonth",sAccountMonth);
		}
		else
			setItemValue(0,0,"AccountMonth","");
	}
	function selectLastAccountMonth()
	{
		var sLastAccountMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=21;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sLastAccountMonth)!="undefined" && sLastAccountMonth!="")
		{	
			setItemValue(0,0,"LastAccountMonth",sLastAccountMonth);
		}
		else
			setItemValue(0,0,"LastAccountMonth","");
	}
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			sAccountmonth = getItemValue(0,0,"AccountMonth");
			sReturnValue = RunMethod("�»��׼��","DataBaseIndInfo",sAccountmonth);
			if(sReturnValue==1)
			{
				alert("���·ݵĻ��������Ѿ����ڣ�������¼�����·ݣ�");
				return;
			}
			var sLastAccountMonth = PopPage("/BusinessManage/ReserveDataPrepare/GetLastAccountMonth.jsp?AccountMonth="+sAccountmonth,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			if(sLastAccountMonth != ""){
				setItemValue(0,getRow(),"LastAccountMonth",sLastAccountMonth);
			}
			beforeInsert();
		}
		else{
			beforeUpdate();
		}
		
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=�Զ�����;InputParam=��;OutPutParam=��;]~*/
	function my_cal(){
		sLossScope  = getItemValue(0,getRow(),"LossScope");
		if(typeof(sLossScope)== "undefined" || sLossScope == "" || sLossScope == "M"){
		    alert("��ǰ��ʧ�ʼ������ͣ����ܽ����Զ�����");
		    return;
		}
		sAccountMonth  = getItemValue(0,getRow(),"AccountMonth");
	    if(sLossScope != "M")	{//ȡ����ƽ��ֵ
	    	sReturn = self.showModalDialog("CalLossRateAction.jsp?LossScope="+sLossScope+"&AccountMonth="+sAccountMonth+"&rand="+randomNumber()," ","dialogWidth=20;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;close:no");
	        ss = sReturn.split('@');
	        setItemValue(0,0,"ALossRate1",ss[0]);
	        setItemValue(0,0,"ALossRate2",ss[1]);
	    }
	}
	
	function goBack()
	{
		//var sReturn = PopComp("RelatingCustomerView","/RelatingExchange/RelatingCustomerView.jsp","CustomerID="+sCustomerID,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		self.close();
	}
	/*~[Describe=���沢����һ����¼;InputParam=��;OutPutParam=��;]~*/
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo() ;
		bIsInsert = false;
		
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		
	}
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
		
    }
	function initSerialNo() 
	{
		var sTableName = "Reserve_IndPara";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "GR";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		//��ֹ��ˮ��ȡ��----------added by yjfang on 20060601
		if(typeof(sSerialNo)=="undefined" || sSerialNo=="undefined" || sSerialNo.lenth==0 || sSerialNo==" " || sSerialNo=="")
		{
			alert("����ʧ�ܣ������±��棡");
			return;
		}
		
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
   	function Upload(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo"); 
		if(typeof(sSerialNo)=="undefined" || sSerialNo=="undefined" || sSerialNo.lenth==0 || sSerialNo==" " || sSerialNo=="")
		{
			alert("���ȱ����¼�����ϴ�������");
			return;
		}
		PopComp("AddDocumentPreMessage","/BusinessManage/ReserveManage/AddDocumentPreMessage.jsp","ObjectType=CS&ObjectNo= " +sSerialNo+ "&rand="+randomNumber(),"_blank","width=500,height=150,top=200,left=170;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 	
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
