
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2005/08/25
		Tester:
		Content: ��Ȩ��������ҳ��
		Input Param:
			PolicyID����Ȩ����ID
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sPolicyID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PolicyID"));
	if(sPolicyID == null) sPolicyID = "";
		
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String[][] sHeaders = {							
							{"FormerPolicyName","ǰ��������"},
							{"PolicyName","��������"},
							{"EffDate","��������"},
							{"EffStatus","��Ч״̬"},
							{"PolicyDescribe","����˵��"},
						  };
	String sSql = 	" select PolicyID,FormerPolicyID,getPolicyName(FormerPolicyID) as FormerPolicyName, "+
					" PolicyName,EffDate,EffStatus,PolicyDescribe,InputUser,InputTime,UpdateUser,UpdateTime "+
					" from AA_POLICY "+
					" where PolicyID = '"+sPolicyID+"' ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "AA_POLICY";
	doTemp.setKey("PolicyID",true);	
	doTemp.setHeader(sHeaders);
	//���ò��ɼ�
	doTemp.setVisible("FormerPolicyID,FormerPolicyName,PolicyID,InputUser,InputTime,UpdateUser,UpdateTime",false);
	//����������
	doTemp.setDDDWCode("EffStatus","EffStatus");
	//���ñ�����
	doTemp.setRequired("PolicyName,EffDate,EffStatus",true);
	doTemp.setCheckFormat("EffDate","3");
	//���ò��ɸ���
	doTemp.setUpdateable("FormerPolicyName",false);
	//����ֻ��
	doTemp.setReadOnly("FormerPolicyID,FormerPolicyName",true);
	//���õ���ʽѡ�񴰿�
	doTemp.setUnit("FormerPolicyName","<input class=inputdate type=button value=\"...\" onClick=parent.getFormerPolicyID()>");
	
	doTemp.setHTMLStyle("PolicyDescribe"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("PolicyDescribe",400);
 	//���ø�ʽ
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPolicyID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath}
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

	/*~[Describe=���������޸�;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0");
		
	}
			
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
		setItemValue(0,0,"InputTime",sNow);
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sNow);
	}	

	/*~[Describe=������Ȩ����ѡ�񴰿�;InputParam=��;OutPutParam=��;]~*/
	function getFormerPolicyID()
	{
		//��õ�ǰ��Ȩ����ID
		sPolicyID = getItemValue(0,getRow(),"PolicyID");	
		if(typeof(sPolicyID) != "undefined" && sPolicyID != "") //�޸ĺͲ鿴����ʱ����ѯ��Ч������Ч�����ڵ�ǰ����֮ǰ����Ȩ��������ȥ����֮�⣩
		{	
			sParaString = "PolicyID"+","+sPolicyID;
			setObjectValue("SelectFormerPolicy",sParaString,"@FormerPolicyID@0@FormerPolicyName@1",0,0,"");			
		}else //����ʱ����ѯ��Ч������Ч�����ڵ�ǰ����֮ǰ����Ȩ����
		{
			setObjectValue("SelectPolicy","","@FormerPolicyID@0@FormerPolicyName@1",0,0,"");			
		}		
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}				
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "AA_POLICY";//����
		var sColumnName = "PolicyID";//�ֶ���
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
