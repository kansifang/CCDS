<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  zrli 2009-8-20
		Tester:
		Content: 
		Input Param:
                    OrgID���������
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ȩ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
		
	//����������	
	
	//���ҳ�����	
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
	if(sOrgID == null) sOrgID = "";
	if(sSerialNo == null) sSerialNo = "";
	ASOrg org = new ASOrg(sOrgID,Sqlca);

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "OrgAuthInfo";
	String sTempletFilter = "1=1";
	String sRoleIDRange = "";
	if(org.OrgLevel.equals("0")) sRoleIDRange = "'410','210','211','226','011','010'";
	else if(org.OrgLevel.equals("3")) sRoleIDRange = "'410','210','211','226'";
	else if(org.OrgLevel.equals("6")) sRoleIDRange = "'410'";
	else sRoleIDRange = "''";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
    //���û���ѡ��ʽ
    doTemp.setUnit("VouchTypeName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectVouchType();\"> ");
	doTemp.setHTMLStyle("VouchTypeName","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.selectVouchType()\" ");
	doTemp.setUnit("BusinessTypeName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectBusinessType();\"> ");
	doTemp.setHTMLStyle("BusinessTypeName","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.selectBusinessType()\" ");
	doTemp.setDDDWSql("RoleID","select roleid,rolename from role_info where roleid in ("+sRoleIDRange+") order by roleid");	
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
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","���ص��б����","doReturn()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurOrgID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
        as_save("myiframe0","");
        
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(){
		OpenPage("/SystemManage/GeneralSetup/OrgAuthList.jsp","_self","");
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	bIsInsert = false;
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getOrgName()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sOrgLevel = getItemValue(0,getRow(),"OrgLevel");
		
		if (typeof(sOrgID) == 'undefined' || sOrgID.length == 0) 
        {
        	alert(getBusinessMessage("900"));//�����������ţ�
        	return;
        }
		if (typeof(sOrgLevel) == 'undefined' || sOrgLevel.length == 0) 
        {
        	alert(getBusinessMessage("901"));//��ѡ�񼶱�
        	return;
        }
		sParaString = "OrgID"+","+sOrgID+","+"OrgLevel"+","+sOrgLevel;		
		setObjectValue("SelectOrg",sParaString,"@RelativeOrgID@0@RelativeOrgName@1",0,0,"");
		
	}
	/*~[Describe=ѡ����Ҫ������ʽ;InputParam=��;OutPutParam=��;]~*/
	function selectVouchType() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectBusinessType()
	{		
		setObjectValue("SelectBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
	}	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{		
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ORG_AUTH";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "OA";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			initSerialNo();//��ʼ����ˮ���ֶ�
            setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
            setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
            setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
            setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"OrgName","<%=org.OrgName%>");
            setItemValue(0,0,"OrgID","<%=sOrgID%>");
            bIsInsert = true;
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
