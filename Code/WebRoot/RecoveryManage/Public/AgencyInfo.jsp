<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: bliu 2004-12-02
		Tester:
		Describe: ���������ϸ��Ϣ
		Input Param:
			CustomerID����ǰ�ͻ����
			SerialNo:	��ˮ��
		Output Param:
			CustomerID����ǰ�ͻ����

		HistoryLog:slliu 2004.12.17
					ndeng 2004.12.23
					zywei 2005/09/07 �ؼ����			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������

	//���ҳ�����	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 							
							{"AgencyName","��������"},								
							{"AgencyLicense","Ӫҵִ�ձ��"},
							{"BusinessBound","Ӫҵ��Χ"},				
							{"Kind","����"},
							{"LaunchDate","����ʱ��"},
							{"AgencyTel","��ϵ�绰"},
							{"PostNo","��������"},
							{"FaxNo","�������"},				
							{"AgencyAdd","��ַ"},
							{"PrincipalName","����������"},
							{"PartnerName","�ϻ���/����������"},
							{"UserName","�Ǽ���"},
							{"OrgName","�Ǽǻ���"},				
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"},
							{"Remark","��ע"}								
						}; 	
	
	sSql = " select SerialNo,AgencyName,AgencyType,AgencyLicense,BusinessBound,Kind,LaunchDate, "+		   
		   " AgencyTel,PostNo,FaxNo,AgencyAdd,PrincipalName,PartnerName,Remark,InputUserID, "+
		   " getUserName(InputUserID) as UserName,InputOrgID,getOrgName(InputOrgID) as OrgName, "+	   
		   " InputDate,UpdateDate" +
		   " from AGENCY_INFO " +
	       " where SerialNo = '"+sSerialNo+"' ";

	//����Sql���ɴ������	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "AGENCY_INFO";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo,AgencyType,InputUserID,InputOrgID",false);	
		
	//������Ӵ�����ȡ��ֵ
	doTemp.setDDDWCode("Kind","AgencyKind");
	doTemp.setDDDWCode("AgencyType","AgencyType1");	
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);

	//���ó���
	doTemp.setLimit("AgencyName",32);
	doTemp.setLimit("AgencyLicense",20);
	doTemp.setLimit("AgencyTel",32);
	doTemp.setLimit("FaxNo",80);
	doTemp.setLimit("AgencyAdd",80);
	doTemp.setLimit("PrincipalName",32);
	doTemp.setLimit("PartnerName",32);
	doTemp.setLimit("PostNo",6);
	doTemp.setLimit("Remark",100);
	doTemp.setLimit("BusinessBound",100);
	
	//���ñ༭��ʽ����ı���
	doTemp.setEditStyle("BusinessBound","3");
	doTemp.setEditStyle("Remark","3");
	//��������򳤶�
	doTemp.setHTMLStyle("InputDate,UpdateDate,OrgName,UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("AgencyAdd"," style={width:300px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	//���ñ�����
	doTemp.setRequired("AgencyName,AgencyType,AgencyLicense,Kind,AgencyTel",true);
	//�������ڼ���ʽ
	doTemp.setCheckFormat("LaunchDate","3");		
	//���ò��ɸ����ֶ�
	doTemp.setUpdateable("OrgName,UserName",false);
	doTemp.appendHTMLStyle("PostNo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" ");
	
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

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/Public/AgencyList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
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

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"AgencyType","02");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "AGENCY_INFO";//����
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
