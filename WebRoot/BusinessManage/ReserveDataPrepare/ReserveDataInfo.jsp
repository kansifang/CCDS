<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.07
		Tester:
		Content: ���ݲɼ�  ���Ŵ�����ά��
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŵ�����ά��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������

	//����������

	//���ҳ�����
	String sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sAssetNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssetNo"));
	if(sAssetNo==null) sAssetNo="";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ReserveDataInfo";
	//Reserve_Total.AccountMonth='#AccountMonth' and Reserve_Total.DuebillNo='#DuebillNo'
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "Reserve_Nocredit";
	doTemp.setKey("AssetNo",true);
	doTemp.setUnit("AccountMonth","<input type=\"button\" class=\"inputDate\" value=\"...\" onclick=\"parent.selectAccountMonth()\">");
	doTemp.setUnit("OrgName","<input type=\"button\" class=\"inputDate\" value=\"...\" onclick=\"parent.selectOrg()\">");
	doTemp.setHTMLStyle("Orgid","style={width:50px;}");
	doTemp.appendHTMLStyle("Balance"," onBlur=\"javascript:parent.setRMBBalance()\" ");
	doTemp.appendHTMLStyle("ExchangeRate"," onBlur=\"javascript:parent.setRMBBalance()\" ");
	doTemp.setHTMLStyle("AssetStatusDescribe,AssetChangeDescribe,AssetorBaseDescribe,Remark,AssetManageDescribe","style={width:260;height:150}overflow:scroll");
	doTemp.setHTMLStyle("AccountMonth,InputUserName,InputDate","style={width:100}");
	doTemp.setHTMLStyle("NoAssetAddress,AssetSaveAddress","style={width:200}");
	//doTemp.appendHTMLStyle("SubjectNo","onChange=\"javascript:parent.setSubjectNo()\" ");	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+sAssetNo);
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},		
		{"true","","Button","¼��/�޸ļ�ֵ׼����Ϣ","¼���鿴��ֵ׼����Ϣ","editReserve()",sResourcesPath},
		{"true","","Button","�ϴ�����","�ϴ�����","upload()",sResourcesPath},
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
	
	function selectVouchType() 
	{
    	sParaString = "CodeNo" + "," + "VouchType";
    	setObjectValue("SelectCode", sParaString, "@VouchType@0@VouchTypeName@1", 0, 0, "");
	}
	
	function setRMBBalance()
	{
		if(getActureVale()==false)
		{
			return;
		}
		else
		{
			var dBalance=getItemValue(0,getRow(),"Balance");
			var dExchangeRate=getItemValue(0,getRow(),"ExchangeRate");
			setItemValue(0,0,"RMBBalance",dBalance*dExchangeRate);
		}
	}
	function getActureVale()
	{
		var sBalance=getItemValue(0,getRow(),"Balance");
		if(typeof(sBalance)=="undefined" || sBalance.length==0)
		{
			return false;
		}
		var sExchangeRate=getItemValue(0,getRow(),"ExchangeRate");
		if(typeof(sExchangeRate)=="undefined" || sExchangeRate.length==0)
		{
			return false;
		}
		return true;
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}
		else{
			beforeUpdate();
		}
		sAssetNo = getItemValue(0,getRow(),"AssetNo");
		as_save("myiframe0",sPostEvents);
	}
	
	function goBack()
	{
		self.close();
	}
	function editReserve()
	{
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sAssetNo = getItemValue(0,getRow(),"AssetNo");
		if(typeof(sAssetNo) == "undefined" || sAssetNo.length == 0)
		{
			alert("���ȱ���ͻ�������Ϣ,�ٽ��м�ֵ׼����Ϣ¼��!");
			return;
		}
		var sReturn = PopComp("ReserveNullDataInfo","/BusinessManage/ReserveDataPrepare/ReserveNullDataInfo.jsp","AccountMonth="+sAccountMonth+"&AssetNo="+sAssetNo,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
	}
	function upload(){
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sAssetNo = getItemValue(0,getRow(),"AssetNo");
		if(typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert("û��¼�����·�,����¼�����·ݲ�����!");
			return;
		}
		if(typeof(sAssetNo) == "undefined" || sAssetNo.length == 0)
		{
			alert("���ȱ��������Ϣ,���ϴ�����!");
			return;
		} 
		PopComp("AddDocumentPreMessage","/BusinessManage/ReserveManage/AddDocumentPreMessage.jsp","ObjectType=ReserveImport&ObjectNo= " + sAssetNo + "&rand="+randomNumber(),"_blank","width=500,height=150,top=200,left=170;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 	
	}
	
	function selectOrg()
	{
		var sReturn= selectObjectValue("SelectAllOrg","",0,0,"");		
		
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'))
		{
			sReturn=sReturn.split("@");
			sTraceOrgID=sReturn[0];
			sTraceOrgName=sReturn[1];
			//alert(sTraceOrgID+"~~~"+sTraceOrgName);
			setItemValue(0,0,"Orgid",sTraceOrgID);
			setItemValue(0,0,"OrgName",sTraceOrgName);
		}
		else if (sReturn=='_CLEAR_')
		{
			sTraceOrgID="";
		}
		else 
		{
			return;
		}
		
	}	   
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
		initSerialNo();
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
			//setItemValue(0,0,"AccountMonth","<%=StringFunction.getToday().substring(0,7)%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
    }
    function initSerialNo() 
	{
		var sTableName = "Reserve_Nocredit";//����
		var sColumnName = "AssetNo";//�ֶ���
		var sPrefix = "fxd";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		if(typeof(sSerialNo)=="undefined" || sSerialNo=="undefined" || sSerialNo.lenth==0 || sSerialNo==" " || sSerialNo=="")
		{
			alert("����ʧ�ܣ������±��棡");
			return;
		}
		
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,0,sColumnName,sSerialNo);
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
