<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zrli 
		Tester:
		Content: �ʱ��������
		Input Param:
		       --SerialNO:��ˮ��
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ʱ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSerialNo="";//--��ˮ����
	String sArgumentType="";//��������
	String sSql="";//--���sql���
	//����������

	//���ҳ�����	,��ˮ��
    sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    sArgumentType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ArgumentType"));

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 		
								{"SerialNo","��ˮ��"},		                   
			                    {"ArgumentType","��������"},	
			                    {"BelongOrg","��������"},	
			                    {"BelongOrgName","��������"},	
			                    {"ArgumentValue","�ʱ�����"},		
							    {"InputUser","�Ǽ���Ա"},		
						        {"InputUserName","�Ǽ���Ա"},
						        {"InputDate","�Ǽ�����"},
						        {"InputOrg","�Ǽǻ���"},
						        {"InputOrgName","�Ǽǻ���"},
						        {"UpdateUser","������Ա"},
						        {"UpdateUserName","������Ա"},
						        {"UpdateDate","��������"},
						        {"UpdateOrg","���»���"},
						        {"UpdateOrgName","���»���"}
			               };   				   		
	
	sSql = " select SerialNo,ArgumentType,BelongOrg,getOrgName(BelongOrg) as BelongOrgName,ArgumentValue,"+
		   " InputUser,getUserName(InputUser) as "+
		   " InputUserName,InputDate,InputOrg,getOrgName(InputOrg) as InputOrgName,UpdateUser,getUserName(UpdateUser) as UpdateUserName,"+
		   " UpdateDate,UpdateOrg,getOrgName(UpdateOrg) as UpdateOrgName from Parameter_CFG "+	            
		    " where SerialNo = '"+sSerialNo+"' ";
    //sql����datawindows
	ASDataObject doTemp = new ASDataObject(sSql);
	//ͷ����
	doTemp.setHeader(sHeaders);
	//�޸ı�
	doTemp.UpdateTable = "PARAMETER_CFG";
    //��������
	doTemp.setKey("SerialNo",true);
	//�����ֶεĲ��ɼ�
	doTemp.setVisible("SerialNo,ArgumentType,InputUser,InputOrg,UpdateUser,UpdateOrg,BelongOrg",false);
	//����number��
	doTemp.setCheckFormat("ArgumentValue","5");
	//���ֶ��Ƿ�ɸ��£���Ҫ���ⲿ���������ģ�����UserName\OrgName	    
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName,UpdateOrgName,BelongOrgName",false);
	doTemp.setReadOnly("ArgumentModel,BelongOrgName",true);
	doTemp.setHTMLStyle("BelongOrgName,InputOrgName,UpdateOrgName"," style={width:250px} ");
	//���ñ�����
	doTemp.setRequired("ArgumentValue,BelongOrg",true);
	doTemp.setUnit("ArgumentValue","��Ԫ");
	doTemp.setUnit("BelongOrgName","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getOrgName();\"> ");
	doTemp.setHTMLStyle("BelongOrgName","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getOrgName()\" ");
	
	//����ֻ����
	
	//�������ڵĸ�ʽ
	//doTemp.setCheckFormat("InputDate,UpdateDate","3");

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
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getOrgName()
	{
		sOrgID = "<%=CurOrg.OrgID%>";
		sOrgLevel = "<%=CurOrg.OrgLevel%>";
		
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
		setObjectValue("SelectOrg",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");
		
	}
	
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
		OpenPage("/SystemManage/ParameterManage/EquityList.jsp","_self","");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

		/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--���»����ˮ��
		OpenPage("/SystemManage/ParameterManage/EquityInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
	}
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
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
	    //���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤������		
		setObjectValue("SelectOwner","","@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");	    
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;

			sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"UpdateOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
			setItemValue(0,0,"ArgumentType","<%=sArgumentType%>");//--�������
		}
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "PARAMETER_CFG";//����
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
