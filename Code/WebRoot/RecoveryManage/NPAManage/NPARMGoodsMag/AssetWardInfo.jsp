<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
/*
*	Author: SLLIU 2005-01-15
*	Tester:
*	Describe: �ʲ������Ϣ;
*	Input Param:
*		ObjectType���������ͣ���ȫ�GuarantyInfo������ʲ���AssetInfo��											
*		ObjectNo���ʲ����
		SerialNo�������Ϣ��ˮ��
*	Output Param:     
*        	
*	HistoryLog: zywei 2006/01/24 �ؼ����
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ʲ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//����������	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));     
	if(sObjectType == null) sObjectType = "";		
	if(sObjectNo == null) sObjectNo = "";
	//��ȡҳ�����	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); //ȡ��ˮ��
	if(sSerialNo==null) sSerialNo="";	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = {
					{"SerialNo","��ˮ��"},
					{"WardDate","���ʱ��"},
					{"WardContent","�������"},
					{"OperateUserName","�����"},
					{"OperateOrgName","�������������"},
					{"Remark","��ע"},
					{"InputUserName","�Ǽ���"},
					{"InputOrgName","�Ǽǻ���"},
					{"InputDate","�Ǽ�����"},
					{"UpdateDate","��������"}
			       };  

	String sSql = 	" select  SerialNo,ObjectNo,ObjectType,"+
					" WardDate,"+
					" WardContent,"+
					" OperateUserID,getUserName(OperateUserID) as OperateUserName," +	
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,Remark," +	
					" InputUserID,getUserName(InputUserID) as InputUserName," +	
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName," +																																																							
					" InputDate,UpdateDate " +	
	       			" from ASSETWARD_INFO " +
	       			" where ObjectType='"+sObjectType+"' "+
	       			" and objectno='"+sObjectNo+"' "+
	       			" and SerialNo = '"+sSerialNo+"' "+
	       			" order by InputDate desc";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSETWARD_INFO";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ò��ɸ���
	doTemp.setUpdateable("InputUserName,InputOrgName,OperateUserName,OperateOrgName",false);
	//��������
	doTemp.setCheckFormat("WardDate","3");
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	doTemp.setVisible("OperateUserID,OperateOrgID,InputUserID,InputOrgID",false);
	//ѡ���ֻ�������Ա
	doTemp.setUnit("OperateUserName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectUser(\""+CurOrg.OrgID+"\",\"OperateUserID\",\"OperateUserName\",\"OperateOrgID\",\"OperateOrgName\")>");
	doTemp.setAlign("WardDate","1");	
	//����ֻ��
	doTemp.setReadOnly("SerialNo,InputUserName,InputOrgName,OperateUserName,OperateOrgName",true);
	//���ñ�����
	doTemp.setRequired("WardDate,WardContent,OperateUserName",true);
	//���ó���
	doTemp.setLimit("Remark",100);	
	//����ѡ���п�	
	doTemp.setHTMLStyle("WardDate,OperateUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("WardContent"," style={width:300px} ");	
	doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");	
	//���ñ༭��ʽ����ı���
	doTemp.setEditStyle("Remark","3");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����ʱ�����¼�

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
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/AssetWardList.jsp","_self","");
	}
    	
     

</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
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

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			
			
			//�Ǽ��ˡ��Ǽǻ���
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
		}		
    }
    
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSETWARD_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);	
	}
	
  	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser(sParam,sUserID,sUserName,sOrgID,sOrgName)
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectUserBelongOrg",sParaString,"@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0,"");		
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
