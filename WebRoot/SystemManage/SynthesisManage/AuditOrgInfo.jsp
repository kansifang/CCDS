<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Content: �����Ͽ�������������ҳ��
			Input Param:
		SerialNo����ˮ��
			Output param:
			History Log: 

		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "�����Ͽ�������������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//���ҳ�����	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	
	//�������
	String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = {     
						{"attribute1","�����������"},
						{"CustomerName","������������"},
			                    {"InputOrgName","�Ǽǻ���"},
			                    {"InputUserName","�Ǽ���"},
			                    {"InputDate","�Ǽ�����"},
			                    {"UpdateDate","��������"},	
			         }; 
		sSql = " select SerialNo,SectionType,attribute1,CustomerName,getOrgName(InputOrgID) as InputOrgName, "+
			   " InputOrgID,getUserName(InputUserID) as InputUserName,InputUserID,InputDate,UpdateDate "+
			   " from CUSTOMER_SPECIAL "+
		       " where SerialNo = '"+sSerialNo+"' "; 
		//ͨ��sql�������ݴ������		
		ASDataObject doTemp = new ASDataObject(sSql);
		//���ñ�ͷ		
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "CUSTOMER_SPECIAL"; 
		//���ùؼ���		
		doTemp.setKey("SerialNo",true);
		//���ñ�������
		doTemp.setRequired("CustomerName",true);
		//�����Ƿ�ɼ�����
		doTemp.setVisible("SerialNo,SectionType,InputOrgID,InputUserID",false);
		//������ʾ�ĳ���
		doTemp.setHTMLStyle("InputDate,UpdateDate"," style={width:80px}");
			
		//�������������Ʋ��ɸ���
		doTemp.setUpdateable("InputOrgName,InputUserName",false);
		//��������������Ϊֻ�����ӵ����Ի�����ѡ��	
		doTemp.setReadOnly("InputOrgName,InputUserName,InputDate,UpdateDate",true);	
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		session.setAttribute(dwTemp.Name,dwTemp);
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/
%>
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
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			initSerialNo();//��ʼ����ˮ���ֶ�		
		setItemValue(0,getRow(),"UpdateDate","<%=StringFunction.getToday()%>");		
		as_save("myiframe0");		
	}
		
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/AuditOrgList.jsp","_self","");
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>

	<script language=javascript>
								
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");
			setItemValue(0,getRow(),"SectionType","60");
			setItemValue(0,getRow(),"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");	
			setItemValue(0,getRow(),"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"UpdateDate","<%=StringFunction.getToday()%>");				
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_SPECIAL";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
