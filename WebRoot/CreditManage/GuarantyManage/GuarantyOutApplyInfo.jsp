<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   wangdw  2012.07.30
		Tester:
		Content: ����ѺƷ����_Info
		Input Param:	
		Output param:
		History Log:         
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ѺƷ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
    ASResultSet rs = null;
	//����������		
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    String sSignalStatus = "";
	//����ֵת��Ϊ���ַ���	
	if(sSerialNo == null) sSerialNo = "";
	
	

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {	
							{"reason","����ԭ��"}	,
							{"GUARANTYNAME","����Ѻ������"},
							{"GUARANTYTYPE","����Ѻ������"},
							{"OWNERNAME","Ȩ��������"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�ʱ��"},
							{"UpdateDate","����ʱ��"}
							};
		
	sSql =  " select GA.SerialNo,GI.OWNERNAME,GI.GUARANTYTYPE,GI.GUARANTYNAME,GA.reason,GetOrgName(GA.InputOrgID) as InputOrgName,GA.InputOrgID,GetUserName(GA.InputUserID) as InputUserName,GA.InputUserID,GA.InputDate,GA.UpdateDate from Guaranty_Apply GA,GUARANTY_INFO GI where GA.Objectno=GI.GUARANTYID "+
			" and SerialNo = '"+sSerialNo+"' ";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="Guaranty_Apply";
	//���ùؼ���
	doTemp.setKey("SerialNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("ApproveDate,AlarmApplyDate,SerialNo,ObjectType,SignalNo",false);
	
	//��������������
	doTemp.setDDDWCode("SignalLevel","SignalLevel");
	
	//���ø�ʽ
	doTemp.setDDDWCode("GUARANTYTYPE","GuarantyList");
	doTemp.setEditStyle("reason","3");
	doTemp.setHTMLStyle("reason"," style={height:100px;width:400px};overflow:scroll ");
	doTemp.setLimit("reason",800);
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("CustomerName"," style={width:200px;} ");
	doTemp.setEditStyle("MessageContent","3");
	doTemp.setCheckFormat("AlarmApplyDate","3");
	doTemp.setType("CustomerBalance,BailSum,CustomerOpenBalance","Number");
 	doTemp.setLimit("MessageContent",800);
	doTemp.setReadOnly("GUARANTYNAME,GUARANTYTYPE,InputUserName,InputOrgName,InputDate,UpdateDate",true);
 	doTemp.setRequired("MessageContent,SignalLevel,CustomerName,MessageOrigin",true);
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,InputUserID,InputOrgID",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,CustomerName",false);
  	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly="0";
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//��ȡ����׼��Ԥ����Ϣ�Ƿ��ѱ����
	String sFreeFlag = "��";
	
	if(sSignalStatus.equals("30")) //��׼
	{
		sSql = 	" select Count(SerialNo) from Guaranty_Apply "+
				" where RelativeSerialNo = '"+sSerialNo+"' "+				
				" and SignalStatus = '30' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			int iCount = rs.getInt(1);
			if(iCount > 0) sFreeFlag = "��";
			else sFreeFlag = "��";		
		} 
		rs.getStatement().close();
	}
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
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{	
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

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
			setItemValue(0,0,"ObjectType","Customer");	
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}
    }
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>